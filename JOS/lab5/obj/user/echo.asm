
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 ca 00 00 00       	call   8000fb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800042:	83 ff 01             	cmp    $0x1,%edi
  800045:	7e 77                	jle    8000be <umain+0x8b>
  800047:	c7 44 24 04 a0 21 80 	movl   $0x8021a0,0x4(%esp)
  80004e:	00 
  80004f:	8b 46 04             	mov    0x4(%esi),%eax
  800052:	89 04 24             	mov    %eax,(%esp)
  800055:	e8 5b 02 00 00       	call   8002b5 <strcmp>
  80005a:	85 c0                	test   %eax,%eax
  80005c:	75 7e                	jne    8000dc <umain+0xa9>
		nflag = 1;
		argc--;
  80005e:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800061:	83 c6 04             	add    $0x4,%esi
	}
	for (i = 1; i < argc; i++) {
  800064:	83 ff 01             	cmp    $0x1,%edi
  800067:	7f 7c                	jg     8000e5 <umain+0xb2>
  800069:	e9 85 00 00 00       	jmp    8000f3 <umain+0xc0>
		if (i > 1)
  80006e:	83 fb 01             	cmp    $0x1,%ebx
  800071:	7e 1c                	jle    80008f <umain+0x5c>
			write(1, " ", 1);
  800073:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80007a:	00 
  80007b:	c7 44 24 04 a3 21 80 	movl   $0x8021a3,0x4(%esp)
  800082:	00 
  800083:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80008a:	e8 b4 0c 00 00       	call   800d43 <write>
		write(1, argv[i], strlen(argv[i]));
  80008f:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800092:	89 04 24             	mov    %eax,(%esp)
  800095:	e8 f6 00 00 00       	call   800190 <strlen>
  80009a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80009e:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000ac:	e8 92 0c 00 00       	call   800d43 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000b1:	83 c3 01             	add    $0x1,%ebx
  8000b4:	39 fb                	cmp    %edi,%ebx
  8000b6:	7c b6                	jl     80006e <umain+0x3b>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000b8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000bc:	75 35                	jne    8000f3 <umain+0xc0>
		write(1, "\n", 1);
  8000be:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000c5:	00 
  8000c6:	c7 44 24 04 a1 22 80 	movl   $0x8022a1,0x4(%esp)
  8000cd:	00 
  8000ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d5:	e8 69 0c 00 00       	call   800d43 <write>
  8000da:	eb 17                	jmp    8000f3 <umain+0xc0>
void
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
  8000dc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8000e3:	eb 07                	jmp    8000ec <umain+0xb9>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
  8000e5:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  8000ec:	bb 01 00 00 00       	mov    $0x1,%ebx
  8000f1:	eb 9c                	jmp    80008f <umain+0x5c>
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
		write(1, "\n", 1);
}
  8000f3:	83 c4 1c             	add    $0x1c,%esp
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 10             	sub    $0x10,%esp
  800103:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800106:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800109:	e8 4d 05 00 00       	call   80065b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80010e:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800114:	39 c2                	cmp    %eax,%edx
  800116:	74 17                	je     80012f <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800118:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80011d:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800120:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800126:	8b 49 40             	mov    0x40(%ecx),%ecx
  800129:	39 c1                	cmp    %eax,%ecx
  80012b:	75 18                	jne    800145 <libmain+0x4a>
  80012d:	eb 05                	jmp    800134 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80012f:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800134:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800137:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80013d:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800143:	eb 0b                	jmp    800150 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800145:	83 c2 01             	add    $0x1,%edx
  800148:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80014e:	75 cd                	jne    80011d <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800150:	85 db                	test   %ebx,%ebx
  800152:	7e 07                	jle    80015b <libmain+0x60>
		binaryname = argv[0];
  800154:	8b 06                	mov    (%esi),%eax
  800156:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80015b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80015f:	89 1c 24             	mov    %ebx,(%esp)
  800162:	e8 cc fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800167:	e8 07 00 00 00       	call   800173 <exit>
}
  80016c:	83 c4 10             	add    $0x10,%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5d                   	pop    %ebp
  800172:	c3                   	ret    

00800173 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800179:	e8 a8 09 00 00       	call   800b26 <close_all>
	sys_env_destroy(0);
  80017e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800185:	e8 7f 04 00 00       	call   800609 <sys_env_destroy>
}
  80018a:	c9                   	leave  
  80018b:	c3                   	ret    
  80018c:	66 90                	xchg   %ax,%ax
  80018e:	66 90                	xchg   %ax,%ax

00800190 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800196:	80 3a 00             	cmpb   $0x0,(%edx)
  800199:	74 10                	je     8001ab <strlen+0x1b>
  80019b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8001a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8001a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8001a7:	75 f7                	jne    8001a0 <strlen+0x10>
  8001a9:	eb 05                	jmp    8001b0 <strlen+0x20>
  8001ab:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	53                   	push   %ebx
  8001b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001bc:	85 c9                	test   %ecx,%ecx
  8001be:	74 1c                	je     8001dc <strnlen+0x2a>
  8001c0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8001c3:	74 1e                	je     8001e3 <strnlen+0x31>
  8001c5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8001ca:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001cc:	39 ca                	cmp    %ecx,%edx
  8001ce:	74 18                	je     8001e8 <strnlen+0x36>
  8001d0:	83 c2 01             	add    $0x1,%edx
  8001d3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8001d8:	75 f0                	jne    8001ca <strnlen+0x18>
  8001da:	eb 0c                	jmp    8001e8 <strnlen+0x36>
  8001dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e1:	eb 05                	jmp    8001e8 <strnlen+0x36>
  8001e3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8001e8:	5b                   	pop    %ebx
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    

008001eb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001eb:	55                   	push   %ebp
  8001ec:	89 e5                	mov    %esp,%ebp
  8001ee:	53                   	push   %ebx
  8001ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001f5:	89 c2                	mov    %eax,%edx
  8001f7:	83 c2 01             	add    $0x1,%edx
  8001fa:	83 c1 01             	add    $0x1,%ecx
  8001fd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800201:	88 5a ff             	mov    %bl,-0x1(%edx)
  800204:	84 db                	test   %bl,%bl
  800206:	75 ef                	jne    8001f7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800208:	5b                   	pop    %ebx
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    

0080020b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	53                   	push   %ebx
  80020f:	83 ec 08             	sub    $0x8,%esp
  800212:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800215:	89 1c 24             	mov    %ebx,(%esp)
  800218:	e8 73 ff ff ff       	call   800190 <strlen>
	strcpy(dst + len, src);
  80021d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800220:	89 54 24 04          	mov    %edx,0x4(%esp)
  800224:	01 d8                	add    %ebx,%eax
  800226:	89 04 24             	mov    %eax,(%esp)
  800229:	e8 bd ff ff ff       	call   8001eb <strcpy>
	return dst;
}
  80022e:	89 d8                	mov    %ebx,%eax
  800230:	83 c4 08             	add    $0x8,%esp
  800233:	5b                   	pop    %ebx
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    

00800236 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	56                   	push   %esi
  80023a:	53                   	push   %ebx
  80023b:	8b 75 08             	mov    0x8(%ebp),%esi
  80023e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800241:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800244:	85 db                	test   %ebx,%ebx
  800246:	74 17                	je     80025f <strncpy+0x29>
  800248:	01 f3                	add    %esi,%ebx
  80024a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80024c:	83 c1 01             	add    $0x1,%ecx
  80024f:	0f b6 02             	movzbl (%edx),%eax
  800252:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800255:	80 3a 01             	cmpb   $0x1,(%edx)
  800258:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80025b:	39 d9                	cmp    %ebx,%ecx
  80025d:	75 ed                	jne    80024c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80025f:	89 f0                	mov    %esi,%eax
  800261:	5b                   	pop    %ebx
  800262:	5e                   	pop    %esi
  800263:	5d                   	pop    %ebp
  800264:	c3                   	ret    

00800265 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800265:	55                   	push   %ebp
  800266:	89 e5                	mov    %esp,%ebp
  800268:	57                   	push   %edi
  800269:	56                   	push   %esi
  80026a:	53                   	push   %ebx
  80026b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80026e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800271:	8b 75 10             	mov    0x10(%ebp),%esi
  800274:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800276:	85 f6                	test   %esi,%esi
  800278:	74 34                	je     8002ae <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80027a:	83 fe 01             	cmp    $0x1,%esi
  80027d:	74 26                	je     8002a5 <strlcpy+0x40>
  80027f:	0f b6 0b             	movzbl (%ebx),%ecx
  800282:	84 c9                	test   %cl,%cl
  800284:	74 23                	je     8002a9 <strlcpy+0x44>
  800286:	83 ee 02             	sub    $0x2,%esi
  800289:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80028e:	83 c0 01             	add    $0x1,%eax
  800291:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800294:	39 f2                	cmp    %esi,%edx
  800296:	74 13                	je     8002ab <strlcpy+0x46>
  800298:	83 c2 01             	add    $0x1,%edx
  80029b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80029f:	84 c9                	test   %cl,%cl
  8002a1:	75 eb                	jne    80028e <strlcpy+0x29>
  8002a3:	eb 06                	jmp    8002ab <strlcpy+0x46>
  8002a5:	89 f8                	mov    %edi,%eax
  8002a7:	eb 02                	jmp    8002ab <strlcpy+0x46>
  8002a9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8002ab:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8002ae:	29 f8                	sub    %edi,%eax
}
  8002b0:	5b                   	pop    %ebx
  8002b1:	5e                   	pop    %esi
  8002b2:	5f                   	pop    %edi
  8002b3:	5d                   	pop    %ebp
  8002b4:	c3                   	ret    

008002b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8002b5:	55                   	push   %ebp
  8002b6:	89 e5                	mov    %esp,%ebp
  8002b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8002be:	0f b6 01             	movzbl (%ecx),%eax
  8002c1:	84 c0                	test   %al,%al
  8002c3:	74 15                	je     8002da <strcmp+0x25>
  8002c5:	3a 02                	cmp    (%edx),%al
  8002c7:	75 11                	jne    8002da <strcmp+0x25>
		p++, q++;
  8002c9:	83 c1 01             	add    $0x1,%ecx
  8002cc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8002cf:	0f b6 01             	movzbl (%ecx),%eax
  8002d2:	84 c0                	test   %al,%al
  8002d4:	74 04                	je     8002da <strcmp+0x25>
  8002d6:	3a 02                	cmp    (%edx),%al
  8002d8:	74 ef                	je     8002c9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8002da:	0f b6 c0             	movzbl %al,%eax
  8002dd:	0f b6 12             	movzbl (%edx),%edx
  8002e0:	29 d0                	sub    %edx,%eax
}
  8002e2:	5d                   	pop    %ebp
  8002e3:	c3                   	ret    

008002e4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	56                   	push   %esi
  8002e8:	53                   	push   %ebx
  8002e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8002ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ef:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8002f2:	85 f6                	test   %esi,%esi
  8002f4:	74 29                	je     80031f <strncmp+0x3b>
  8002f6:	0f b6 03             	movzbl (%ebx),%eax
  8002f9:	84 c0                	test   %al,%al
  8002fb:	74 30                	je     80032d <strncmp+0x49>
  8002fd:	3a 02                	cmp    (%edx),%al
  8002ff:	75 2c                	jne    80032d <strncmp+0x49>
  800301:	8d 43 01             	lea    0x1(%ebx),%eax
  800304:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800306:	89 c3                	mov    %eax,%ebx
  800308:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80030b:	39 f0                	cmp    %esi,%eax
  80030d:	74 17                	je     800326 <strncmp+0x42>
  80030f:	0f b6 08             	movzbl (%eax),%ecx
  800312:	84 c9                	test   %cl,%cl
  800314:	74 17                	je     80032d <strncmp+0x49>
  800316:	83 c0 01             	add    $0x1,%eax
  800319:	3a 0a                	cmp    (%edx),%cl
  80031b:	74 e9                	je     800306 <strncmp+0x22>
  80031d:	eb 0e                	jmp    80032d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80031f:	b8 00 00 00 00       	mov    $0x0,%eax
  800324:	eb 0f                	jmp    800335 <strncmp+0x51>
  800326:	b8 00 00 00 00       	mov    $0x0,%eax
  80032b:	eb 08                	jmp    800335 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80032d:	0f b6 03             	movzbl (%ebx),%eax
  800330:	0f b6 12             	movzbl (%edx),%edx
  800333:	29 d0                	sub    %edx,%eax
}
  800335:	5b                   	pop    %ebx
  800336:	5e                   	pop    %esi
  800337:	5d                   	pop    %ebp
  800338:	c3                   	ret    

00800339 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800339:	55                   	push   %ebp
  80033a:	89 e5                	mov    %esp,%ebp
  80033c:	53                   	push   %ebx
  80033d:	8b 45 08             	mov    0x8(%ebp),%eax
  800340:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800343:	0f b6 18             	movzbl (%eax),%ebx
  800346:	84 db                	test   %bl,%bl
  800348:	74 1d                	je     800367 <strchr+0x2e>
  80034a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80034c:	38 d3                	cmp    %dl,%bl
  80034e:	75 06                	jne    800356 <strchr+0x1d>
  800350:	eb 1a                	jmp    80036c <strchr+0x33>
  800352:	38 ca                	cmp    %cl,%dl
  800354:	74 16                	je     80036c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800356:	83 c0 01             	add    $0x1,%eax
  800359:	0f b6 10             	movzbl (%eax),%edx
  80035c:	84 d2                	test   %dl,%dl
  80035e:	75 f2                	jne    800352 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800360:	b8 00 00 00 00       	mov    $0x0,%eax
  800365:	eb 05                	jmp    80036c <strchr+0x33>
  800367:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80036c:	5b                   	pop    %ebx
  80036d:	5d                   	pop    %ebp
  80036e:	c3                   	ret    

0080036f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80036f:	55                   	push   %ebp
  800370:	89 e5                	mov    %esp,%ebp
  800372:	53                   	push   %ebx
  800373:	8b 45 08             	mov    0x8(%ebp),%eax
  800376:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800379:	0f b6 18             	movzbl (%eax),%ebx
  80037c:	84 db                	test   %bl,%bl
  80037e:	74 16                	je     800396 <strfind+0x27>
  800380:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800382:	38 d3                	cmp    %dl,%bl
  800384:	75 06                	jne    80038c <strfind+0x1d>
  800386:	eb 0e                	jmp    800396 <strfind+0x27>
  800388:	38 ca                	cmp    %cl,%dl
  80038a:	74 0a                	je     800396 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80038c:	83 c0 01             	add    $0x1,%eax
  80038f:	0f b6 10             	movzbl (%eax),%edx
  800392:	84 d2                	test   %dl,%dl
  800394:	75 f2                	jne    800388 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800396:	5b                   	pop    %ebx
  800397:	5d                   	pop    %ebp
  800398:	c3                   	ret    

00800399 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	57                   	push   %edi
  80039d:	56                   	push   %esi
  80039e:	53                   	push   %ebx
  80039f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8003a5:	85 c9                	test   %ecx,%ecx
  8003a7:	74 36                	je     8003df <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8003a9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003af:	75 28                	jne    8003d9 <memset+0x40>
  8003b1:	f6 c1 03             	test   $0x3,%cl
  8003b4:	75 23                	jne    8003d9 <memset+0x40>
		c &= 0xFF;
  8003b6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8003ba:	89 d3                	mov    %edx,%ebx
  8003bc:	c1 e3 08             	shl    $0x8,%ebx
  8003bf:	89 d6                	mov    %edx,%esi
  8003c1:	c1 e6 18             	shl    $0x18,%esi
  8003c4:	89 d0                	mov    %edx,%eax
  8003c6:	c1 e0 10             	shl    $0x10,%eax
  8003c9:	09 f0                	or     %esi,%eax
  8003cb:	09 c2                	or     %eax,%edx
  8003cd:	89 d0                	mov    %edx,%eax
  8003cf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8003d1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8003d4:	fc                   	cld    
  8003d5:	f3 ab                	rep stos %eax,%es:(%edi)
  8003d7:	eb 06                	jmp    8003df <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	fc                   	cld    
  8003dd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8003df:	89 f8                	mov    %edi,%eax
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	57                   	push   %edi
  8003ea:	56                   	push   %esi
  8003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ee:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8003f4:	39 c6                	cmp    %eax,%esi
  8003f6:	73 35                	jae    80042d <memmove+0x47>
  8003f8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8003fb:	39 d0                	cmp    %edx,%eax
  8003fd:	73 2e                	jae    80042d <memmove+0x47>
		s += n;
		d += n;
  8003ff:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800402:	89 d6                	mov    %edx,%esi
  800404:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800406:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80040c:	75 13                	jne    800421 <memmove+0x3b>
  80040e:	f6 c1 03             	test   $0x3,%cl
  800411:	75 0e                	jne    800421 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800413:	83 ef 04             	sub    $0x4,%edi
  800416:	8d 72 fc             	lea    -0x4(%edx),%esi
  800419:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80041c:	fd                   	std    
  80041d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80041f:	eb 09                	jmp    80042a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800421:	83 ef 01             	sub    $0x1,%edi
  800424:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800427:	fd                   	std    
  800428:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80042a:	fc                   	cld    
  80042b:	eb 1d                	jmp    80044a <memmove+0x64>
  80042d:	89 f2                	mov    %esi,%edx
  80042f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800431:	f6 c2 03             	test   $0x3,%dl
  800434:	75 0f                	jne    800445 <memmove+0x5f>
  800436:	f6 c1 03             	test   $0x3,%cl
  800439:	75 0a                	jne    800445 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80043b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80043e:	89 c7                	mov    %eax,%edi
  800440:	fc                   	cld    
  800441:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800443:	eb 05                	jmp    80044a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800445:	89 c7                	mov    %eax,%edi
  800447:	fc                   	cld    
  800448:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80044a:	5e                   	pop    %esi
  80044b:	5f                   	pop    %edi
  80044c:	5d                   	pop    %ebp
  80044d:	c3                   	ret    

0080044e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	e8 79 ff ff ff       	call   8003e6 <memmove>
}
  80046d:	c9                   	leave  
  80046e:	c3                   	ret    

0080046f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80046f:	55                   	push   %ebp
  800470:	89 e5                	mov    %esp,%ebp
  800472:	57                   	push   %edi
  800473:	56                   	push   %esi
  800474:	53                   	push   %ebx
  800475:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800478:	8b 75 0c             	mov    0xc(%ebp),%esi
  80047b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80047e:	8d 78 ff             	lea    -0x1(%eax),%edi
  800481:	85 c0                	test   %eax,%eax
  800483:	74 36                	je     8004bb <memcmp+0x4c>
		if (*s1 != *s2)
  800485:	0f b6 03             	movzbl (%ebx),%eax
  800488:	0f b6 0e             	movzbl (%esi),%ecx
  80048b:	ba 00 00 00 00       	mov    $0x0,%edx
  800490:	38 c8                	cmp    %cl,%al
  800492:	74 1c                	je     8004b0 <memcmp+0x41>
  800494:	eb 10                	jmp    8004a6 <memcmp+0x37>
  800496:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  80049b:	83 c2 01             	add    $0x1,%edx
  80049e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  8004a2:	38 c8                	cmp    %cl,%al
  8004a4:	74 0a                	je     8004b0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  8004a6:	0f b6 c0             	movzbl %al,%eax
  8004a9:	0f b6 c9             	movzbl %cl,%ecx
  8004ac:	29 c8                	sub    %ecx,%eax
  8004ae:	eb 10                	jmp    8004c0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8004b0:	39 fa                	cmp    %edi,%edx
  8004b2:	75 e2                	jne    800496 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8004b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b9:	eb 05                	jmp    8004c0 <memcmp+0x51>
  8004bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004c0:	5b                   	pop    %ebx
  8004c1:	5e                   	pop    %esi
  8004c2:	5f                   	pop    %edi
  8004c3:	5d                   	pop    %ebp
  8004c4:	c3                   	ret    

008004c5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8004c5:	55                   	push   %ebp
  8004c6:	89 e5                	mov    %esp,%ebp
  8004c8:	53                   	push   %ebx
  8004c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8004d4:	39 d0                	cmp    %edx,%eax
  8004d6:	73 13                	jae    8004eb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  8004d8:	89 d9                	mov    %ebx,%ecx
  8004da:	38 18                	cmp    %bl,(%eax)
  8004dc:	75 06                	jne    8004e4 <memfind+0x1f>
  8004de:	eb 0b                	jmp    8004eb <memfind+0x26>
  8004e0:	38 08                	cmp    %cl,(%eax)
  8004e2:	74 07                	je     8004eb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8004e4:	83 c0 01             	add    $0x1,%eax
  8004e7:	39 d0                	cmp    %edx,%eax
  8004e9:	75 f5                	jne    8004e0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8004eb:	5b                   	pop    %ebx
  8004ec:	5d                   	pop    %ebp
  8004ed:	c3                   	ret    

008004ee <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8004ee:	55                   	push   %ebp
  8004ef:	89 e5                	mov    %esp,%ebp
  8004f1:	57                   	push   %edi
  8004f2:	56                   	push   %esi
  8004f3:	53                   	push   %ebx
  8004f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004fa:	0f b6 0a             	movzbl (%edx),%ecx
  8004fd:	80 f9 09             	cmp    $0x9,%cl
  800500:	74 05                	je     800507 <strtol+0x19>
  800502:	80 f9 20             	cmp    $0x20,%cl
  800505:	75 10                	jne    800517 <strtol+0x29>
		s++;
  800507:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80050a:	0f b6 0a             	movzbl (%edx),%ecx
  80050d:	80 f9 09             	cmp    $0x9,%cl
  800510:	74 f5                	je     800507 <strtol+0x19>
  800512:	80 f9 20             	cmp    $0x20,%cl
  800515:	74 f0                	je     800507 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  800517:	80 f9 2b             	cmp    $0x2b,%cl
  80051a:	75 0a                	jne    800526 <strtol+0x38>
		s++;
  80051c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80051f:	bf 00 00 00 00       	mov    $0x0,%edi
  800524:	eb 11                	jmp    800537 <strtol+0x49>
  800526:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80052b:	80 f9 2d             	cmp    $0x2d,%cl
  80052e:	75 07                	jne    800537 <strtol+0x49>
		s++, neg = 1;
  800530:	83 c2 01             	add    $0x1,%edx
  800533:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800537:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80053c:	75 15                	jne    800553 <strtol+0x65>
  80053e:	80 3a 30             	cmpb   $0x30,(%edx)
  800541:	75 10                	jne    800553 <strtol+0x65>
  800543:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800547:	75 0a                	jne    800553 <strtol+0x65>
		s += 2, base = 16;
  800549:	83 c2 02             	add    $0x2,%edx
  80054c:	b8 10 00 00 00       	mov    $0x10,%eax
  800551:	eb 10                	jmp    800563 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  800553:	85 c0                	test   %eax,%eax
  800555:	75 0c                	jne    800563 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800557:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800559:	80 3a 30             	cmpb   $0x30,(%edx)
  80055c:	75 05                	jne    800563 <strtol+0x75>
		s++, base = 8;
  80055e:	83 c2 01             	add    $0x1,%edx
  800561:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800563:	bb 00 00 00 00       	mov    $0x0,%ebx
  800568:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80056b:	0f b6 0a             	movzbl (%edx),%ecx
  80056e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800571:	89 f0                	mov    %esi,%eax
  800573:	3c 09                	cmp    $0x9,%al
  800575:	77 08                	ja     80057f <strtol+0x91>
			dig = *s - '0';
  800577:	0f be c9             	movsbl %cl,%ecx
  80057a:	83 e9 30             	sub    $0x30,%ecx
  80057d:	eb 20                	jmp    80059f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  80057f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800582:	89 f0                	mov    %esi,%eax
  800584:	3c 19                	cmp    $0x19,%al
  800586:	77 08                	ja     800590 <strtol+0xa2>
			dig = *s - 'a' + 10;
  800588:	0f be c9             	movsbl %cl,%ecx
  80058b:	83 e9 57             	sub    $0x57,%ecx
  80058e:	eb 0f                	jmp    80059f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  800590:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800593:	89 f0                	mov    %esi,%eax
  800595:	3c 19                	cmp    $0x19,%al
  800597:	77 16                	ja     8005af <strtol+0xc1>
			dig = *s - 'A' + 10;
  800599:	0f be c9             	movsbl %cl,%ecx
  80059c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80059f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8005a2:	7d 0f                	jge    8005b3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8005a4:	83 c2 01             	add    $0x1,%edx
  8005a7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8005ab:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8005ad:	eb bc                	jmp    80056b <strtol+0x7d>
  8005af:	89 d8                	mov    %ebx,%eax
  8005b1:	eb 02                	jmp    8005b5 <strtol+0xc7>
  8005b3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8005b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005b9:	74 05                	je     8005c0 <strtol+0xd2>
		*endptr = (char *) s;
  8005bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005be:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8005c0:	f7 d8                	neg    %eax
  8005c2:	85 ff                	test   %edi,%edi
  8005c4:	0f 44 c3             	cmove  %ebx,%eax
}
  8005c7:	5b                   	pop    %ebx
  8005c8:	5e                   	pop    %esi
  8005c9:	5f                   	pop    %edi
  8005ca:	5d                   	pop    %ebp
  8005cb:	c3                   	ret    

008005cc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8005cc:	55                   	push   %ebp
  8005cd:	89 e5                	mov    %esp,%ebp
  8005cf:	57                   	push   %edi
  8005d0:	56                   	push   %esi
  8005d1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005da:	8b 55 08             	mov    0x8(%ebp),%edx
  8005dd:	89 c3                	mov    %eax,%ebx
  8005df:	89 c7                	mov    %eax,%edi
  8005e1:	89 c6                	mov    %eax,%esi
  8005e3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8005e5:	5b                   	pop    %ebx
  8005e6:	5e                   	pop    %esi
  8005e7:	5f                   	pop    %edi
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <sys_cgetc>:

int
sys_cgetc(void)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	57                   	push   %edi
  8005ee:	56                   	push   %esi
  8005ef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8005fa:	89 d1                	mov    %edx,%ecx
  8005fc:	89 d3                	mov    %edx,%ebx
  8005fe:	89 d7                	mov    %edx,%edi
  800600:	89 d6                	mov    %edx,%esi
  800602:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800604:	5b                   	pop    %ebx
  800605:	5e                   	pop    %esi
  800606:	5f                   	pop    %edi
  800607:	5d                   	pop    %ebp
  800608:	c3                   	ret    

00800609 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800609:	55                   	push   %ebp
  80060a:	89 e5                	mov    %esp,%ebp
  80060c:	57                   	push   %edi
  80060d:	56                   	push   %esi
  80060e:	53                   	push   %ebx
  80060f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800612:	b9 00 00 00 00       	mov    $0x0,%ecx
  800617:	b8 03 00 00 00       	mov    $0x3,%eax
  80061c:	8b 55 08             	mov    0x8(%ebp),%edx
  80061f:	89 cb                	mov    %ecx,%ebx
  800621:	89 cf                	mov    %ecx,%edi
  800623:	89 ce                	mov    %ecx,%esi
  800625:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800627:	85 c0                	test   %eax,%eax
  800629:	7e 28                	jle    800653 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80062b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80062f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800636:	00 
  800637:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  80063e:	00 
  80063f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800646:	00 
  800647:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  80064e:	e8 63 10 00 00       	call   8016b6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800653:	83 c4 2c             	add    $0x2c,%esp
  800656:	5b                   	pop    %ebx
  800657:	5e                   	pop    %esi
  800658:	5f                   	pop    %edi
  800659:	5d                   	pop    %ebp
  80065a:	c3                   	ret    

0080065b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	57                   	push   %edi
  80065f:	56                   	push   %esi
  800660:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800661:	ba 00 00 00 00       	mov    $0x0,%edx
  800666:	b8 02 00 00 00       	mov    $0x2,%eax
  80066b:	89 d1                	mov    %edx,%ecx
  80066d:	89 d3                	mov    %edx,%ebx
  80066f:	89 d7                	mov    %edx,%edi
  800671:	89 d6                	mov    %edx,%esi
  800673:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800675:	5b                   	pop    %ebx
  800676:	5e                   	pop    %esi
  800677:	5f                   	pop    %edi
  800678:	5d                   	pop    %ebp
  800679:	c3                   	ret    

0080067a <sys_yield>:

void
sys_yield(void)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
  80067d:	57                   	push   %edi
  80067e:	56                   	push   %esi
  80067f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	b8 0b 00 00 00       	mov    $0xb,%eax
  80068a:	89 d1                	mov    %edx,%ecx
  80068c:	89 d3                	mov    %edx,%ebx
  80068e:	89 d7                	mov    %edx,%edi
  800690:	89 d6                	mov    %edx,%esi
  800692:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800694:	5b                   	pop    %ebx
  800695:	5e                   	pop    %esi
  800696:	5f                   	pop    %edi
  800697:	5d                   	pop    %ebp
  800698:	c3                   	ret    

00800699 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
  80069c:	57                   	push   %edi
  80069d:	56                   	push   %esi
  80069e:	53                   	push   %ebx
  80069f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006a2:	be 00 00 00 00       	mov    $0x0,%esi
  8006a7:	b8 04 00 00 00       	mov    $0x4,%eax
  8006ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006af:	8b 55 08             	mov    0x8(%ebp),%edx
  8006b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006b5:	89 f7                	mov    %esi,%edi
  8006b7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8006b9:	85 c0                	test   %eax,%eax
  8006bb:	7e 28                	jle    8006e5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006bd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006c1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8006c8:	00 
  8006c9:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  8006d0:	00 
  8006d1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8006d8:	00 
  8006d9:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  8006e0:	e8 d1 0f 00 00       	call   8016b6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8006e5:	83 c4 2c             	add    $0x2c,%esp
  8006e8:	5b                   	pop    %ebx
  8006e9:	5e                   	pop    %esi
  8006ea:	5f                   	pop    %edi
  8006eb:	5d                   	pop    %ebp
  8006ec:	c3                   	ret    

008006ed <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8006ed:	55                   	push   %ebp
  8006ee:	89 e5                	mov    %esp,%ebp
  8006f0:	57                   	push   %edi
  8006f1:	56                   	push   %esi
  8006f2:	53                   	push   %ebx
  8006f3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006f6:	b8 05 00 00 00       	mov    $0x5,%eax
  8006fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fe:	8b 55 08             	mov    0x8(%ebp),%edx
  800701:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800704:	8b 7d 14             	mov    0x14(%ebp),%edi
  800707:	8b 75 18             	mov    0x18(%ebp),%esi
  80070a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80070c:	85 c0                	test   %eax,%eax
  80070e:	7e 28                	jle    800738 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800710:	89 44 24 10          	mov    %eax,0x10(%esp)
  800714:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80071b:	00 
  80071c:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800723:	00 
  800724:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80072b:	00 
  80072c:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800733:	e8 7e 0f 00 00       	call   8016b6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800738:	83 c4 2c             	add    $0x2c,%esp
  80073b:	5b                   	pop    %ebx
  80073c:	5e                   	pop    %esi
  80073d:	5f                   	pop    %edi
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	57                   	push   %edi
  800744:	56                   	push   %esi
  800745:	53                   	push   %ebx
  800746:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800749:	bb 00 00 00 00       	mov    $0x0,%ebx
  80074e:	b8 06 00 00 00       	mov    $0x6,%eax
  800753:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800756:	8b 55 08             	mov    0x8(%ebp),%edx
  800759:	89 df                	mov    %ebx,%edi
  80075b:	89 de                	mov    %ebx,%esi
  80075d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80075f:	85 c0                	test   %eax,%eax
  800761:	7e 28                	jle    80078b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800763:	89 44 24 10          	mov    %eax,0x10(%esp)
  800767:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80076e:	00 
  80076f:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  800776:	00 
  800777:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80077e:	00 
  80077f:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800786:	e8 2b 0f 00 00       	call   8016b6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80078b:	83 c4 2c             	add    $0x2c,%esp
  80078e:	5b                   	pop    %ebx
  80078f:	5e                   	pop    %esi
  800790:	5f                   	pop    %edi
  800791:	5d                   	pop    %ebp
  800792:	c3                   	ret    

00800793 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	57                   	push   %edi
  800797:	56                   	push   %esi
  800798:	53                   	push   %ebx
  800799:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80079c:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8007ac:	89 df                	mov    %ebx,%edi
  8007ae:	89 de                	mov    %ebx,%esi
  8007b0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8007b2:	85 c0                	test   %eax,%eax
  8007b4:	7e 28                	jle    8007de <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007ba:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8007c1:	00 
  8007c2:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  8007c9:	00 
  8007ca:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8007d1:	00 
  8007d2:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  8007d9:	e8 d8 0e 00 00       	call   8016b6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8007de:	83 c4 2c             	add    $0x2c,%esp
  8007e1:	5b                   	pop    %ebx
  8007e2:	5e                   	pop    %esi
  8007e3:	5f                   	pop    %edi
  8007e4:	5d                   	pop    %ebp
  8007e5:	c3                   	ret    

008007e6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	57                   	push   %edi
  8007ea:	56                   	push   %esi
  8007eb:	53                   	push   %ebx
  8007ec:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8007f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8007ff:	89 df                	mov    %ebx,%edi
  800801:	89 de                	mov    %ebx,%esi
  800803:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800805:	85 c0                	test   %eax,%eax
  800807:	7e 28                	jle    800831 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800809:	89 44 24 10          	mov    %eax,0x10(%esp)
  80080d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800814:	00 
  800815:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  80081c:	00 
  80081d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800824:	00 
  800825:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  80082c:	e8 85 0e 00 00       	call   8016b6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800831:	83 c4 2c             	add    $0x2c,%esp
  800834:	5b                   	pop    %ebx
  800835:	5e                   	pop    %esi
  800836:	5f                   	pop    %edi
  800837:	5d                   	pop    %ebp
  800838:	c3                   	ret    

00800839 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800839:	55                   	push   %ebp
  80083a:	89 e5                	mov    %esp,%ebp
  80083c:	57                   	push   %edi
  80083d:	56                   	push   %esi
  80083e:	53                   	push   %ebx
  80083f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800842:	bb 00 00 00 00       	mov    $0x0,%ebx
  800847:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084f:	8b 55 08             	mov    0x8(%ebp),%edx
  800852:	89 df                	mov    %ebx,%edi
  800854:	89 de                	mov    %ebx,%esi
  800856:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800858:	85 c0                	test   %eax,%eax
  80085a:	7e 28                	jle    800884 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80085c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800860:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800867:	00 
  800868:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  80086f:	00 
  800870:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800877:	00 
  800878:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  80087f:	e8 32 0e 00 00       	call   8016b6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800884:	83 c4 2c             	add    $0x2c,%esp
  800887:	5b                   	pop    %ebx
  800888:	5e                   	pop    %esi
  800889:	5f                   	pop    %edi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	57                   	push   %edi
  800890:	56                   	push   %esi
  800891:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800892:	be 00 00 00 00       	mov    $0x0,%esi
  800897:	b8 0c 00 00 00       	mov    $0xc,%eax
  80089c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089f:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008a5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8008a8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8008aa:	5b                   	pop    %ebx
  8008ab:	5e                   	pop    %esi
  8008ac:	5f                   	pop    %edi
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	57                   	push   %edi
  8008b3:	56                   	push   %esi
  8008b4:	53                   	push   %ebx
  8008b5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008bd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	89 cb                	mov    %ecx,%ebx
  8008c7:	89 cf                	mov    %ecx,%edi
  8008c9:	89 ce                	mov    %ecx,%esi
  8008cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8008cd:	85 c0                	test   %eax,%eax
  8008cf:	7e 28                	jle    8008f9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008d5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8008dc:	00 
  8008dd:	c7 44 24 08 af 21 80 	movl   $0x8021af,0x8(%esp)
  8008e4:	00 
  8008e5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8008ec:	00 
  8008ed:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  8008f4:	e8 bd 0d 00 00       	call   8016b6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8008f9:	83 c4 2c             	add    $0x2c,%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5f                   	pop    %edi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    
  800901:	66 90                	xchg   %ax,%ax
  800903:	66 90                	xchg   %ax,%ax
  800905:	66 90                	xchg   %ax,%ax
  800907:	66 90                	xchg   %ax,%ax
  800909:	66 90                	xchg   %ax,%ax
  80090b:	66 90                	xchg   %ax,%ax
  80090d:	66 90                	xchg   %ax,%ax
  80090f:	90                   	nop

00800910 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	05 00 00 00 30       	add    $0x30000000,%eax
  80091b:	c1 e8 0c             	shr    $0xc,%eax
}
  80091e:	5d                   	pop    %ebp
  80091f:	c3                   	ret    

00800920 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80092b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800930:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800935:	5d                   	pop    %ebp
  800936:	c3                   	ret    

00800937 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800937:	55                   	push   %ebp
  800938:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80093a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80093f:	a8 01                	test   $0x1,%al
  800941:	74 34                	je     800977 <fd_alloc+0x40>
  800943:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800948:	a8 01                	test   $0x1,%al
  80094a:	74 32                	je     80097e <fd_alloc+0x47>
  80094c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800951:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800953:	89 c2                	mov    %eax,%edx
  800955:	c1 ea 16             	shr    $0x16,%edx
  800958:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80095f:	f6 c2 01             	test   $0x1,%dl
  800962:	74 1f                	je     800983 <fd_alloc+0x4c>
  800964:	89 c2                	mov    %eax,%edx
  800966:	c1 ea 0c             	shr    $0xc,%edx
  800969:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800970:	f6 c2 01             	test   $0x1,%dl
  800973:	75 1a                	jne    80098f <fd_alloc+0x58>
  800975:	eb 0c                	jmp    800983 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800977:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80097c:	eb 05                	jmp    800983 <fd_alloc+0x4c>
  80097e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	89 08                	mov    %ecx,(%eax)
			return 0;
  800988:	b8 00 00 00 00       	mov    $0x0,%eax
  80098d:	eb 1a                	jmp    8009a9 <fd_alloc+0x72>
  80098f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800994:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800999:	75 b6                	jne    800951 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80099b:	8b 45 08             	mov    0x8(%ebp),%eax
  80099e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8009a4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8009b1:	83 f8 1f             	cmp    $0x1f,%eax
  8009b4:	77 36                	ja     8009ec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8009b6:	c1 e0 0c             	shl    $0xc,%eax
  8009b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8009be:	89 c2                	mov    %eax,%edx
  8009c0:	c1 ea 16             	shr    $0x16,%edx
  8009c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8009ca:	f6 c2 01             	test   $0x1,%dl
  8009cd:	74 24                	je     8009f3 <fd_lookup+0x48>
  8009cf:	89 c2                	mov    %eax,%edx
  8009d1:	c1 ea 0c             	shr    $0xc,%edx
  8009d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8009db:	f6 c2 01             	test   $0x1,%dl
  8009de:	74 1a                	je     8009fa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8009e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ea:	eb 13                	jmp    8009ff <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f1:	eb 0c                	jmp    8009ff <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8009f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009f8:	eb 05                	jmp    8009ff <fd_lookup+0x54>
  8009fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8009ff:	5d                   	pop    %ebp
  800a00:	c3                   	ret    

00800a01 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800a01:	55                   	push   %ebp
  800a02:	89 e5                	mov    %esp,%ebp
  800a04:	53                   	push   %ebx
  800a05:	83 ec 14             	sub    $0x14,%esp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800a0e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800a14:	75 1e                	jne    800a34 <dev_lookup+0x33>
  800a16:	eb 0e                	jmp    800a26 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800a18:	b8 20 30 80 00       	mov    $0x803020,%eax
  800a1d:	eb 0c                	jmp    800a2b <dev_lookup+0x2a>
  800a1f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800a24:	eb 05                	jmp    800a2b <dev_lookup+0x2a>
  800a26:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  800a2b:	89 03                	mov    %eax,(%ebx)
			return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a32:	eb 38                	jmp    800a6c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800a34:	39 05 20 30 80 00    	cmp    %eax,0x803020
  800a3a:	74 dc                	je     800a18 <dev_lookup+0x17>
  800a3c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  800a42:	74 db                	je     800a1f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800a44:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800a4a:	8b 52 48             	mov    0x48(%edx),%edx
  800a4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a51:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a55:	c7 04 24 dc 21 80 00 	movl   $0x8021dc,(%esp)
  800a5c:	e8 4e 0d 00 00       	call   8017af <cprintf>
	*dev = 0;
  800a61:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800a67:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800a6c:	83 c4 14             	add    $0x14,%esp
  800a6f:	5b                   	pop    %ebx
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	56                   	push   %esi
  800a76:	53                   	push   %ebx
  800a77:	83 ec 20             	sub    $0x20,%esp
  800a7a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a83:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800a87:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800a8d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800a90:	89 04 24             	mov    %eax,(%esp)
  800a93:	e8 13 ff ff ff       	call   8009ab <fd_lookup>
  800a98:	85 c0                	test   %eax,%eax
  800a9a:	78 05                	js     800aa1 <fd_close+0x2f>
	    || fd != fd2)
  800a9c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800a9f:	74 0c                	je     800aad <fd_close+0x3b>
		return (must_exist ? r : 0);
  800aa1:	84 db                	test   %bl,%bl
  800aa3:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa8:	0f 44 c2             	cmove  %edx,%eax
  800aab:	eb 3f                	jmp    800aec <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800aad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab4:	8b 06                	mov    (%esi),%eax
  800ab6:	89 04 24             	mov    %eax,(%esp)
  800ab9:	e8 43 ff ff ff       	call   800a01 <dev_lookup>
  800abe:	89 c3                	mov    %eax,%ebx
  800ac0:	85 c0                	test   %eax,%eax
  800ac2:	78 16                	js     800ada <fd_close+0x68>
		if (dev->dev_close)
  800ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  800aca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	74 07                	je     800ada <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800ad3:	89 34 24             	mov    %esi,(%esp)
  800ad6:	ff d0                	call   *%eax
  800ad8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800ada:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ade:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ae5:	e8 56 fc ff ff       	call   800740 <sys_page_unmap>
	return r;
  800aea:	89 d8                	mov    %ebx,%eax
}
  800aec:	83 c4 20             	add    $0x20,%esp
  800aef:	5b                   	pop    %ebx
  800af0:	5e                   	pop    %esi
  800af1:	5d                   	pop    %ebp
  800af2:	c3                   	ret    

00800af3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800af3:	55                   	push   %ebp
  800af4:	89 e5                	mov    %esp,%ebp
  800af6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800af9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800afc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	89 04 24             	mov    %eax,(%esp)
  800b06:	e8 a0 fe ff ff       	call   8009ab <fd_lookup>
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	85 d2                	test   %edx,%edx
  800b0f:	78 13                	js     800b24 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800b11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800b18:	00 
  800b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b1c:	89 04 24             	mov    %eax,(%esp)
  800b1f:	e8 4e ff ff ff       	call   800a72 <fd_close>
}
  800b24:	c9                   	leave  
  800b25:	c3                   	ret    

00800b26 <close_all>:

void
close_all(void)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	53                   	push   %ebx
  800b2a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800b32:	89 1c 24             	mov    %ebx,(%esp)
  800b35:	e8 b9 ff ff ff       	call   800af3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800b3a:	83 c3 01             	add    $0x1,%ebx
  800b3d:	83 fb 20             	cmp    $0x20,%ebx
  800b40:	75 f0                	jne    800b32 <close_all+0xc>
		close(i);
}
  800b42:	83 c4 14             	add    $0x14,%esp
  800b45:	5b                   	pop    %ebx
  800b46:	5d                   	pop    %ebp
  800b47:	c3                   	ret    

00800b48 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
  800b4e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5b:	89 04 24             	mov    %eax,(%esp)
  800b5e:	e8 48 fe ff ff       	call   8009ab <fd_lookup>
  800b63:	89 c2                	mov    %eax,%edx
  800b65:	85 d2                	test   %edx,%edx
  800b67:	0f 88 e1 00 00 00    	js     800c4e <dup+0x106>
		return r;
	close(newfdnum);
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	89 04 24             	mov    %eax,(%esp)
  800b73:	e8 7b ff ff ff       	call   800af3 <close>

	newfd = INDEX2FD(newfdnum);
  800b78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b7b:	c1 e3 0c             	shl    $0xc,%ebx
  800b7e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800b84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b87:	89 04 24             	mov    %eax,(%esp)
  800b8a:	e8 91 fd ff ff       	call   800920 <fd2data>
  800b8f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800b91:	89 1c 24             	mov    %ebx,(%esp)
  800b94:	e8 87 fd ff ff       	call   800920 <fd2data>
  800b99:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800b9b:	89 f0                	mov    %esi,%eax
  800b9d:	c1 e8 16             	shr    $0x16,%eax
  800ba0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ba7:	a8 01                	test   $0x1,%al
  800ba9:	74 43                	je     800bee <dup+0xa6>
  800bab:	89 f0                	mov    %esi,%eax
  800bad:	c1 e8 0c             	shr    $0xc,%eax
  800bb0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800bb7:	f6 c2 01             	test   $0x1,%dl
  800bba:	74 32                	je     800bee <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800bbc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800bc3:	25 07 0e 00 00       	and    $0xe07,%eax
  800bc8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800bcc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800bd0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bd7:	00 
  800bd8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bdc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800be3:	e8 05 fb ff ff       	call   8006ed <sys_page_map>
  800be8:	89 c6                	mov    %eax,%esi
  800bea:	85 c0                	test   %eax,%eax
  800bec:	78 3e                	js     800c2c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800bee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bf1:	89 c2                	mov    %eax,%edx
  800bf3:	c1 ea 0c             	shr    $0xc,%edx
  800bf6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bfd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800c03:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c07:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c12:	00 
  800c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c1e:	e8 ca fa ff ff       	call   8006ed <sys_page_map>
  800c23:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800c28:	85 f6                	test   %esi,%esi
  800c2a:	79 22                	jns    800c4e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800c2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c37:	e8 04 fb ff ff       	call   800740 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800c3c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c47:	e8 f4 fa ff ff       	call   800740 <sys_page_unmap>
	return r;
  800c4c:	89 f0                	mov    %esi,%eax
}
  800c4e:	83 c4 3c             	add    $0x3c,%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    

00800c56 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	53                   	push   %ebx
  800c5a:	83 ec 24             	sub    $0x24,%esp
  800c5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c60:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c67:	89 1c 24             	mov    %ebx,(%esp)
  800c6a:	e8 3c fd ff ff       	call   8009ab <fd_lookup>
  800c6f:	89 c2                	mov    %eax,%edx
  800c71:	85 d2                	test   %edx,%edx
  800c73:	78 6d                	js     800ce2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c7f:	8b 00                	mov    (%eax),%eax
  800c81:	89 04 24             	mov    %eax,(%esp)
  800c84:	e8 78 fd ff ff       	call   800a01 <dev_lookup>
  800c89:	85 c0                	test   %eax,%eax
  800c8b:	78 55                	js     800ce2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c90:	8b 50 08             	mov    0x8(%eax),%edx
  800c93:	83 e2 03             	and    $0x3,%edx
  800c96:	83 fa 01             	cmp    $0x1,%edx
  800c99:	75 23                	jne    800cbe <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800c9b:	a1 04 40 80 00       	mov    0x804004,%eax
  800ca0:	8b 40 48             	mov    0x48(%eax),%eax
  800ca3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cab:	c7 04 24 1d 22 80 00 	movl   $0x80221d,(%esp)
  800cb2:	e8 f8 0a 00 00       	call   8017af <cprintf>
		return -E_INVAL;
  800cb7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cbc:	eb 24                	jmp    800ce2 <read+0x8c>
	}
	if (!dev->dev_read)
  800cbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cc1:	8b 52 08             	mov    0x8(%edx),%edx
  800cc4:	85 d2                	test   %edx,%edx
  800cc6:	74 15                	je     800cdd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800ccb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cd6:	89 04 24             	mov    %eax,(%esp)
  800cd9:	ff d2                	call   *%edx
  800cdb:	eb 05                	jmp    800ce2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  800cdd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800ce2:	83 c4 24             	add    $0x24,%esp
  800ce5:	5b                   	pop    %ebx
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 1c             	sub    $0x1c,%esp
  800cf1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cf4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800cf7:	85 f6                	test   %esi,%esi
  800cf9:	74 33                	je     800d2e <readn+0x46>
  800cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  800d00:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800d05:	89 f2                	mov    %esi,%edx
  800d07:	29 c2                	sub    %eax,%edx
  800d09:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d0d:	03 45 0c             	add    0xc(%ebp),%eax
  800d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d14:	89 3c 24             	mov    %edi,(%esp)
  800d17:	e8 3a ff ff ff       	call   800c56 <read>
		if (m < 0)
  800d1c:	85 c0                	test   %eax,%eax
  800d1e:	78 1b                	js     800d3b <readn+0x53>
			return m;
		if (m == 0)
  800d20:	85 c0                	test   %eax,%eax
  800d22:	74 11                	je     800d35 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800d24:	01 c3                	add    %eax,%ebx
  800d26:	89 d8                	mov    %ebx,%eax
  800d28:	39 f3                	cmp    %esi,%ebx
  800d2a:	72 d9                	jb     800d05 <readn+0x1d>
  800d2c:	eb 0b                	jmp    800d39 <readn+0x51>
  800d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d33:	eb 06                	jmp    800d3b <readn+0x53>
  800d35:	89 d8                	mov    %ebx,%eax
  800d37:	eb 02                	jmp    800d3b <readn+0x53>
  800d39:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800d3b:	83 c4 1c             	add    $0x1c,%esp
  800d3e:	5b                   	pop    %ebx
  800d3f:	5e                   	pop    %esi
  800d40:	5f                   	pop    %edi
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	53                   	push   %ebx
  800d47:	83 ec 24             	sub    $0x24,%esp
  800d4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d54:	89 1c 24             	mov    %ebx,(%esp)
  800d57:	e8 4f fc ff ff       	call   8009ab <fd_lookup>
  800d5c:	89 c2                	mov    %eax,%edx
  800d5e:	85 d2                	test   %edx,%edx
  800d60:	78 68                	js     800dca <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6c:	8b 00                	mov    (%eax),%eax
  800d6e:	89 04 24             	mov    %eax,(%esp)
  800d71:	e8 8b fc ff ff       	call   800a01 <dev_lookup>
  800d76:	85 c0                	test   %eax,%eax
  800d78:	78 50                	js     800dca <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800d81:	75 23                	jne    800da6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800d83:	a1 04 40 80 00       	mov    0x804004,%eax
  800d88:	8b 40 48             	mov    0x48(%eax),%eax
  800d8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d93:	c7 04 24 39 22 80 00 	movl   $0x802239,(%esp)
  800d9a:	e8 10 0a 00 00       	call   8017af <cprintf>
		return -E_INVAL;
  800d9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800da4:	eb 24                	jmp    800dca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800da6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da9:	8b 52 0c             	mov    0xc(%edx),%edx
  800dac:	85 d2                	test   %edx,%edx
  800dae:	74 15                	je     800dc5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800db0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800db3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800db7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800dbe:	89 04 24             	mov    %eax,(%esp)
  800dc1:	ff d2                	call   *%edx
  800dc3:	eb 05                	jmp    800dca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800dc5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  800dca:	83 c4 24             	add    $0x24,%esp
  800dcd:	5b                   	pop    %ebx
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <seek>:

int
seek(int fdnum, off_t offset)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800dd6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	89 04 24             	mov    %eax,(%esp)
  800de3:	e8 c3 fb ff ff       	call   8009ab <fd_lookup>
  800de8:	85 c0                	test   %eax,%eax
  800dea:	78 0e                	js     800dfa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800def:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	53                   	push   %ebx
  800e00:	83 ec 24             	sub    $0x24,%esp
  800e03:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e09:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e0d:	89 1c 24             	mov    %ebx,(%esp)
  800e10:	e8 96 fb ff ff       	call   8009ab <fd_lookup>
  800e15:	89 c2                	mov    %eax,%edx
  800e17:	85 d2                	test   %edx,%edx
  800e19:	78 61                	js     800e7c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 00                	mov    (%eax),%eax
  800e27:	89 04 24             	mov    %eax,(%esp)
  800e2a:	e8 d2 fb ff ff       	call   800a01 <dev_lookup>
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	78 49                	js     800e7c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800e3a:	75 23                	jne    800e5f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  800e3c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e41:	8b 40 48             	mov    0x48(%eax),%eax
  800e44:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e48:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4c:	c7 04 24 fc 21 80 00 	movl   $0x8021fc,(%esp)
  800e53:	e8 57 09 00 00       	call   8017af <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800e58:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e5d:	eb 1d                	jmp    800e7c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  800e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e62:	8b 52 18             	mov    0x18(%edx),%edx
  800e65:	85 d2                	test   %edx,%edx
  800e67:	74 0e                	je     800e77 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800e69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800e70:	89 04 24             	mov    %eax,(%esp)
  800e73:	ff d2                	call   *%edx
  800e75:	eb 05                	jmp    800e7c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800e77:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  800e7c:	83 c4 24             	add    $0x24,%esp
  800e7f:	5b                   	pop    %ebx
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    

00800e82 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800e82:	55                   	push   %ebp
  800e83:	89 e5                	mov    %esp,%ebp
  800e85:	53                   	push   %ebx
  800e86:	83 ec 24             	sub    $0x24,%esp
  800e89:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e8c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 04 24             	mov    %eax,(%esp)
  800e99:	e8 0d fb ff ff       	call   8009ab <fd_lookup>
  800e9e:	89 c2                	mov    %eax,%edx
  800ea0:	85 d2                	test   %edx,%edx
  800ea2:	78 52                	js     800ef6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ea4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eae:	8b 00                	mov    (%eax),%eax
  800eb0:	89 04 24             	mov    %eax,(%esp)
  800eb3:	e8 49 fb ff ff       	call   800a01 <dev_lookup>
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	78 3a                	js     800ef6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800ec3:	74 2c                	je     800ef1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800ec5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ec8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800ecf:	00 00 00 
	stat->st_isdir = 0;
  800ed2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800ed9:	00 00 00 
	stat->st_dev = dev;
  800edc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800ee2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ee6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ee9:	89 14 24             	mov    %edx,(%esp)
  800eec:	ff 50 14             	call   *0x14(%eax)
  800eef:	eb 05                	jmp    800ef6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800ef1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800ef6:	83 c4 24             	add    $0x24,%esp
  800ef9:	5b                   	pop    %ebx
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800f0b:	00 
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	89 04 24             	mov    %eax,(%esp)
  800f12:	e8 af 01 00 00       	call   8010c6 <open>
  800f17:	89 c3                	mov    %eax,%ebx
  800f19:	85 db                	test   %ebx,%ebx
  800f1b:	78 1b                	js     800f38 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f20:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f24:	89 1c 24             	mov    %ebx,(%esp)
  800f27:	e8 56 ff ff ff       	call   800e82 <fstat>
  800f2c:	89 c6                	mov    %eax,%esi
	close(fd);
  800f2e:	89 1c 24             	mov    %ebx,(%esp)
  800f31:	e8 bd fb ff ff       	call   800af3 <close>
	return r;
  800f36:	89 f0                	mov    %esi,%eax
}
  800f38:	83 c4 10             	add    $0x10,%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 10             	sub    $0x10,%esp
  800f47:	89 c6                	mov    %eax,%esi
  800f49:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800f4b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800f52:	75 11                	jne    800f65 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800f54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800f5b:	e8 18 0f 00 00       	call   801e78 <ipc_find_env>
  800f60:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800f65:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800f74:	00 
  800f75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f79:	a1 00 40 80 00       	mov    0x804000,%eax
  800f7e:	89 04 24             	mov    %eax,(%esp)
  800f81:	e8 8c 0e 00 00       	call   801e12 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800f86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f8d:	00 
  800f8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f99:	e8 0a 0e 00 00       	call   801da8 <ipc_recv>
}
  800f9e:	83 c4 10             	add    $0x10,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	53                   	push   %ebx
  800fa9:	83 ec 14             	sub    $0x14,%esp
  800fac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  800fb5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800fba:	ba 00 00 00 00       	mov    $0x0,%edx
  800fbf:	b8 05 00 00 00       	mov    $0x5,%eax
  800fc4:	e8 76 ff ff ff       	call   800f3f <fsipc>
  800fc9:	89 c2                	mov    %eax,%edx
  800fcb:	85 d2                	test   %edx,%edx
  800fcd:	78 2b                	js     800ffa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800fcf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800fd6:	00 
  800fd7:	89 1c 24             	mov    %ebx,(%esp)
  800fda:	e8 0c f2 ff ff       	call   8001eb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800fdf:	a1 80 50 80 00       	mov    0x805080,%eax
  800fe4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800fea:	a1 84 50 80 00       	mov    0x805084,%eax
  800fef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ffa:	83 c4 14             	add    $0x14,%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8b 40 0c             	mov    0xc(%eax),%eax
  80100c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801011:	ba 00 00 00 00       	mov    $0x0,%edx
  801016:	b8 06 00 00 00       	mov    $0x6,%eax
  80101b:	e8 1f ff ff ff       	call   800f3f <fsipc>
}
  801020:	c9                   	leave  
  801021:	c3                   	ret    

00801022 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
  801025:	56                   	push   %esi
  801026:	53                   	push   %ebx
  801027:	83 ec 10             	sub    $0x10,%esp
  80102a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8b 40 0c             	mov    0xc(%eax),%eax
  801033:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801038:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80103e:	ba 00 00 00 00       	mov    $0x0,%edx
  801043:	b8 03 00 00 00       	mov    $0x3,%eax
  801048:	e8 f2 fe ff ff       	call   800f3f <fsipc>
  80104d:	89 c3                	mov    %eax,%ebx
  80104f:	85 c0                	test   %eax,%eax
  801051:	78 6a                	js     8010bd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801053:	39 c6                	cmp    %eax,%esi
  801055:	73 24                	jae    80107b <devfile_read+0x59>
  801057:	c7 44 24 0c 56 22 80 	movl   $0x802256,0xc(%esp)
  80105e:	00 
  80105f:	c7 44 24 08 5d 22 80 	movl   $0x80225d,0x8(%esp)
  801066:	00 
  801067:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  80106e:	00 
  80106f:	c7 04 24 72 22 80 00 	movl   $0x802272,(%esp)
  801076:	e8 3b 06 00 00       	call   8016b6 <_panic>
	assert(r <= PGSIZE);
  80107b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801080:	7e 24                	jle    8010a6 <devfile_read+0x84>
  801082:	c7 44 24 0c 7d 22 80 	movl   $0x80227d,0xc(%esp)
  801089:	00 
  80108a:	c7 44 24 08 5d 22 80 	movl   $0x80225d,0x8(%esp)
  801091:	00 
  801092:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  801099:	00 
  80109a:	c7 04 24 72 22 80 00 	movl   $0x802272,(%esp)
  8010a1:	e8 10 06 00 00       	call   8016b6 <_panic>
	memmove(buf, &fsipcbuf, r);
  8010a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010aa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8010b1:	00 
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	89 04 24             	mov    %eax,(%esp)
  8010b8:	e8 29 f3 ff ff       	call   8003e6 <memmove>
	return r;
}
  8010bd:	89 d8                	mov    %ebx,%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
  8010c2:	5b                   	pop    %ebx
  8010c3:	5e                   	pop    %esi
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 24             	sub    $0x24,%esp
  8010cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8010d0:	89 1c 24             	mov    %ebx,(%esp)
  8010d3:	e8 b8 f0 ff ff       	call   800190 <strlen>
  8010d8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8010dd:	7f 60                	jg     80113f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8010df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e2:	89 04 24             	mov    %eax,(%esp)
  8010e5:	e8 4d f8 ff ff       	call   800937 <fd_alloc>
  8010ea:	89 c2                	mov    %eax,%edx
  8010ec:	85 d2                	test   %edx,%edx
  8010ee:	78 54                	js     801144 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8010f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010f4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8010fb:	e8 eb f0 ff ff       	call   8001eb <strcpy>
	fsipcbuf.open.req_omode = mode;
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	b8 01 00 00 00       	mov    $0x1,%eax
  801110:	e8 2a fe ff ff       	call   800f3f <fsipc>
  801115:	89 c3                	mov    %eax,%ebx
  801117:	85 c0                	test   %eax,%eax
  801119:	79 17                	jns    801132 <open+0x6c>
		fd_close(fd, 0);
  80111b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801122:	00 
  801123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801126:	89 04 24             	mov    %eax,(%esp)
  801129:	e8 44 f9 ff ff       	call   800a72 <fd_close>
		return r;
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	eb 12                	jmp    801144 <open+0x7e>
	}

	return fd2num(fd);
  801132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801135:	89 04 24             	mov    %eax,(%esp)
  801138:	e8 d3 f7 ff ff       	call   800910 <fd2num>
  80113d:	eb 05                	jmp    801144 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80113f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801144:	83 c4 24             	add    $0x24,%esp
  801147:	5b                   	pop    %ebx
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    
  80114a:	66 90                	xchg   %ax,%ax
  80114c:	66 90                	xchg   %ax,%ax
  80114e:	66 90                	xchg   %ax,%ax

00801150 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	56                   	push   %esi
  801154:	53                   	push   %ebx
  801155:	83 ec 10             	sub    $0x10,%esp
  801158:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	89 04 24             	mov    %eax,(%esp)
  801161:	e8 ba f7 ff ff       	call   800920 <fd2data>
  801166:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801168:	c7 44 24 04 89 22 80 	movl   $0x802289,0x4(%esp)
  80116f:	00 
  801170:	89 1c 24             	mov    %ebx,(%esp)
  801173:	e8 73 f0 ff ff       	call   8001eb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801178:	8b 46 04             	mov    0x4(%esi),%eax
  80117b:	2b 06                	sub    (%esi),%eax
  80117d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801183:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80118a:	00 00 00 
	stat->st_dev = &devpipe;
  80118d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801194:	30 80 00 
	return 0;
}
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
  80119c:	83 c4 10             	add    $0x10,%esp
  80119f:	5b                   	pop    %ebx
  8011a0:	5e                   	pop    %esi
  8011a1:	5d                   	pop    %ebp
  8011a2:	c3                   	ret    

008011a3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	53                   	push   %ebx
  8011a7:	83 ec 14             	sub    $0x14,%esp
  8011aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8011ad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b8:	e8 83 f5 ff ff       	call   800740 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8011bd:	89 1c 24             	mov    %ebx,(%esp)
  8011c0:	e8 5b f7 ff ff       	call   800920 <fd2data>
  8011c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d0:	e8 6b f5 ff ff       	call   800740 <sys_page_unmap>
}
  8011d5:	83 c4 14             	add    $0x14,%esp
  8011d8:	5b                   	pop    %ebx
  8011d9:	5d                   	pop    %ebp
  8011da:	c3                   	ret    

008011db <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
  8011de:	57                   	push   %edi
  8011df:	56                   	push   %esi
  8011e0:	53                   	push   %ebx
  8011e1:	83 ec 2c             	sub    $0x2c,%esp
  8011e4:	89 c6                	mov    %eax,%esi
  8011e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8011e9:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ee:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8011f1:	89 34 24             	mov    %esi,(%esp)
  8011f4:	e8 c7 0c 00 00       	call   801ec0 <pageref>
  8011f9:	89 c7                	mov    %eax,%edi
  8011fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011fe:	89 04 24             	mov    %eax,(%esp)
  801201:	e8 ba 0c 00 00       	call   801ec0 <pageref>
  801206:	39 c7                	cmp    %eax,%edi
  801208:	0f 94 c2             	sete   %dl
  80120b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80120e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  801214:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801217:	39 fb                	cmp    %edi,%ebx
  801219:	74 21                	je     80123c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80121b:	84 d2                	test   %dl,%dl
  80121d:	74 ca                	je     8011e9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80121f:	8b 51 58             	mov    0x58(%ecx),%edx
  801222:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801226:	89 54 24 08          	mov    %edx,0x8(%esp)
  80122a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80122e:	c7 04 24 90 22 80 00 	movl   $0x802290,(%esp)
  801235:	e8 75 05 00 00       	call   8017af <cprintf>
  80123a:	eb ad                	jmp    8011e9 <_pipeisclosed+0xe>
	}
}
  80123c:	83 c4 2c             	add    $0x2c,%esp
  80123f:	5b                   	pop    %ebx
  801240:	5e                   	pop    %esi
  801241:	5f                   	pop    %edi
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    

00801244 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801244:	55                   	push   %ebp
  801245:	89 e5                	mov    %esp,%ebp
  801247:	57                   	push   %edi
  801248:	56                   	push   %esi
  801249:	53                   	push   %ebx
  80124a:	83 ec 1c             	sub    $0x1c,%esp
  80124d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801250:	89 34 24             	mov    %esi,(%esp)
  801253:	e8 c8 f6 ff ff       	call   800920 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	74 61                	je     8012bf <devpipe_write+0x7b>
  80125e:	89 c3                	mov    %eax,%ebx
  801260:	bf 00 00 00 00       	mov    $0x0,%edi
  801265:	eb 4a                	jmp    8012b1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801267:	89 da                	mov    %ebx,%edx
  801269:	89 f0                	mov    %esi,%eax
  80126b:	e8 6b ff ff ff       	call   8011db <_pipeisclosed>
  801270:	85 c0                	test   %eax,%eax
  801272:	75 54                	jne    8012c8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801274:	e8 01 f4 ff ff       	call   80067a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801279:	8b 43 04             	mov    0x4(%ebx),%eax
  80127c:	8b 0b                	mov    (%ebx),%ecx
  80127e:	8d 51 20             	lea    0x20(%ecx),%edx
  801281:	39 d0                	cmp    %edx,%eax
  801283:	73 e2                	jae    801267 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801285:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801288:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80128c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80128f:	99                   	cltd   
  801290:	c1 ea 1b             	shr    $0x1b,%edx
  801293:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801296:	83 e1 1f             	and    $0x1f,%ecx
  801299:	29 d1                	sub    %edx,%ecx
  80129b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80129f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8012a3:	83 c0 01             	add    $0x1,%eax
  8012a6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8012a9:	83 c7 01             	add    $0x1,%edi
  8012ac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8012af:	74 13                	je     8012c4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8012b1:	8b 43 04             	mov    0x4(%ebx),%eax
  8012b4:	8b 0b                	mov    (%ebx),%ecx
  8012b6:	8d 51 20             	lea    0x20(%ecx),%edx
  8012b9:	39 d0                	cmp    %edx,%eax
  8012bb:	73 aa                	jae    801267 <devpipe_write+0x23>
  8012bd:	eb c6                	jmp    801285 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8012bf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8012c4:	89 f8                	mov    %edi,%eax
  8012c6:	eb 05                	jmp    8012cd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8012c8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8012cd:	83 c4 1c             	add    $0x1c,%esp
  8012d0:	5b                   	pop    %ebx
  8012d1:	5e                   	pop    %esi
  8012d2:	5f                   	pop    %edi
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	57                   	push   %edi
  8012d9:	56                   	push   %esi
  8012da:	53                   	push   %ebx
  8012db:	83 ec 1c             	sub    $0x1c,%esp
  8012de:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8012e1:	89 3c 24             	mov    %edi,(%esp)
  8012e4:	e8 37 f6 ff ff       	call   800920 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8012e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012ed:	74 54                	je     801343 <devpipe_read+0x6e>
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	be 00 00 00 00       	mov    $0x0,%esi
  8012f6:	eb 3e                	jmp    801336 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8012f8:	89 f0                	mov    %esi,%eax
  8012fa:	eb 55                	jmp    801351 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8012fc:	89 da                	mov    %ebx,%edx
  8012fe:	89 f8                	mov    %edi,%eax
  801300:	e8 d6 fe ff ff       	call   8011db <_pipeisclosed>
  801305:	85 c0                	test   %eax,%eax
  801307:	75 43                	jne    80134c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801309:	e8 6c f3 ff ff       	call   80067a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80130e:	8b 03                	mov    (%ebx),%eax
  801310:	3b 43 04             	cmp    0x4(%ebx),%eax
  801313:	74 e7                	je     8012fc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801315:	99                   	cltd   
  801316:	c1 ea 1b             	shr    $0x1b,%edx
  801319:	01 d0                	add    %edx,%eax
  80131b:	83 e0 1f             	and    $0x1f,%eax
  80131e:	29 d0                	sub    %edx,%eax
  801320:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801328:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80132b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80132e:	83 c6 01             	add    $0x1,%esi
  801331:	3b 75 10             	cmp    0x10(%ebp),%esi
  801334:	74 12                	je     801348 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801336:	8b 03                	mov    (%ebx),%eax
  801338:	3b 43 04             	cmp    0x4(%ebx),%eax
  80133b:	75 d8                	jne    801315 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80133d:	85 f6                	test   %esi,%esi
  80133f:	75 b7                	jne    8012f8 <devpipe_read+0x23>
  801341:	eb b9                	jmp    8012fc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801343:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801348:	89 f0                	mov    %esi,%eax
  80134a:	eb 05                	jmp    801351 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80134c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801351:	83 c4 1c             	add    $0x1c,%esp
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5f                   	pop    %edi
  801357:	5d                   	pop    %ebp
  801358:	c3                   	ret    

00801359 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801359:	55                   	push   %ebp
  80135a:	89 e5                	mov    %esp,%ebp
  80135c:	56                   	push   %esi
  80135d:	53                   	push   %ebx
  80135e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801361:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801364:	89 04 24             	mov    %eax,(%esp)
  801367:	e8 cb f5 ff ff       	call   800937 <fd_alloc>
  80136c:	89 c2                	mov    %eax,%edx
  80136e:	85 d2                	test   %edx,%edx
  801370:	0f 88 4d 01 00 00    	js     8014c3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801376:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80137d:	00 
  80137e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801381:	89 44 24 04          	mov    %eax,0x4(%esp)
  801385:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80138c:	e8 08 f3 ff ff       	call   800699 <sys_page_alloc>
  801391:	89 c2                	mov    %eax,%edx
  801393:	85 d2                	test   %edx,%edx
  801395:	0f 88 28 01 00 00    	js     8014c3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80139b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80139e:	89 04 24             	mov    %eax,(%esp)
  8013a1:	e8 91 f5 ff ff       	call   800937 <fd_alloc>
  8013a6:	89 c3                	mov    %eax,%ebx
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	0f 88 fe 00 00 00    	js     8014ae <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8013b7:	00 
  8013b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013c6:	e8 ce f2 ff ff       	call   800699 <sys_page_alloc>
  8013cb:	89 c3                	mov    %eax,%ebx
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	0f 88 d9 00 00 00    	js     8014ae <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8013d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d8:	89 04 24             	mov    %eax,(%esp)
  8013db:	e8 40 f5 ff ff       	call   800920 <fd2data>
  8013e0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8013e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8013e9:	00 
  8013ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f5:	e8 9f f2 ff ff       	call   800699 <sys_page_alloc>
  8013fa:	89 c3                	mov    %eax,%ebx
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	0f 88 97 00 00 00    	js     80149b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801404:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801407:	89 04 24             	mov    %eax,(%esp)
  80140a:	e8 11 f5 ff ff       	call   800920 <fd2data>
  80140f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801416:	00 
  801417:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80141b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801422:	00 
  801423:	89 74 24 04          	mov    %esi,0x4(%esp)
  801427:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142e:	e8 ba f2 ff ff       	call   8006ed <sys_page_map>
  801433:	89 c3                	mov    %eax,%ebx
  801435:	85 c0                	test   %eax,%eax
  801437:	78 52                	js     80148b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801439:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80143f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801442:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80144e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801454:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801457:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801466:	89 04 24             	mov    %eax,(%esp)
  801469:	e8 a2 f4 ff ff       	call   800910 <fd2num>
  80146e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801471:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801476:	89 04 24             	mov    %eax,(%esp)
  801479:	e8 92 f4 ff ff       	call   800910 <fd2num>
  80147e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801481:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	eb 38                	jmp    8014c3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80148b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80148f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801496:	e8 a5 f2 ff ff       	call   800740 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a9:	e8 92 f2 ff ff       	call   800740 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014bc:	e8 7f f2 ff ff       	call   800740 <sys_page_unmap>
  8014c1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8014c3:	83 c4 30             	add    $0x30,%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5e                   	pop    %esi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 04 24             	mov    %eax,(%esp)
  8014dd:	e8 c9 f4 ff ff       	call   8009ab <fd_lookup>
  8014e2:	89 c2                	mov    %eax,%edx
  8014e4:	85 d2                	test   %edx,%edx
  8014e6:	78 15                	js     8014fd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8014e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014eb:	89 04 24             	mov    %eax,(%esp)
  8014ee:	e8 2d f4 ff ff       	call   800920 <fd2data>
	return _pipeisclosed(fd, p);
  8014f3:	89 c2                	mov    %eax,%edx
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	e8 de fc ff ff       	call   8011db <_pipeisclosed>
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    
  8014ff:	90                   	nop

00801500 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801503:	b8 00 00 00 00       	mov    $0x0,%eax
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
  80150d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801510:	c7 44 24 04 a8 22 80 	movl   $0x8022a8,0x4(%esp)
  801517:	00 
  801518:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151b:	89 04 24             	mov    %eax,(%esp)
  80151e:	e8 c8 ec ff ff       	call   8001eb <strcpy>
	return 0;
}
  801523:	b8 00 00 00 00       	mov    $0x0,%eax
  801528:	c9                   	leave  
  801529:	c3                   	ret    

0080152a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80152a:	55                   	push   %ebp
  80152b:	89 e5                	mov    %esp,%ebp
  80152d:	57                   	push   %edi
  80152e:	56                   	push   %esi
  80152f:	53                   	push   %ebx
  801530:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801536:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80153a:	74 4a                	je     801586 <devcons_write+0x5c>
  80153c:	b8 00 00 00 00       	mov    $0x0,%eax
  801541:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801546:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80154c:	8b 75 10             	mov    0x10(%ebp),%esi
  80154f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801551:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801554:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801559:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80155c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801560:	03 45 0c             	add    0xc(%ebp),%eax
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	89 3c 24             	mov    %edi,(%esp)
  80156a:	e8 77 ee ff ff       	call   8003e6 <memmove>
		sys_cputs(buf, m);
  80156f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801573:	89 3c 24             	mov    %edi,(%esp)
  801576:	e8 51 f0 ff ff       	call   8005cc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80157b:	01 f3                	add    %esi,%ebx
  80157d:	89 d8                	mov    %ebx,%eax
  80157f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801582:	72 c8                	jb     80154c <devcons_write+0x22>
  801584:	eb 05                	jmp    80158b <devcons_write+0x61>
  801586:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801593:	5b                   	pop    %ebx
  801594:	5e                   	pop    %esi
  801595:	5f                   	pop    %edi
  801596:	5d                   	pop    %ebp
  801597:	c3                   	ret    

00801598 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8015a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015a7:	75 07                	jne    8015b0 <devcons_read+0x18>
  8015a9:	eb 28                	jmp    8015d3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8015ab:	e8 ca f0 ff ff       	call   80067a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8015b0:	e8 35 f0 ff ff       	call   8005ea <sys_cgetc>
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	74 f2                	je     8015ab <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 16                	js     8015d3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8015bd:	83 f8 04             	cmp    $0x4,%eax
  8015c0:	74 0c                	je     8015ce <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8015c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c5:	88 02                	mov    %al,(%edx)
	return 1;
  8015c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8015cc:	eb 05                	jmp    8015d3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8015e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015e8:	00 
  8015e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8015ec:	89 04 24             	mov    %eax,(%esp)
  8015ef:	e8 d8 ef ff ff       	call   8005cc <sys_cputs>
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <getchar>:

int
getchar(void)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8015fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801603:	00 
  801604:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801612:	e8 3f f6 ff ff       	call   800c56 <read>
	if (r < 0)
  801617:	85 c0                	test   %eax,%eax
  801619:	78 0f                	js     80162a <getchar+0x34>
		return r;
	if (r < 1)
  80161b:	85 c0                	test   %eax,%eax
  80161d:	7e 06                	jle    801625 <getchar+0x2f>
		return -E_EOF;
	return c;
  80161f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801623:	eb 05                	jmp    80162a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801625:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80162a:	c9                   	leave  
  80162b:	c3                   	ret    

0080162c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801632:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	8b 45 08             	mov    0x8(%ebp),%eax
  80163c:	89 04 24             	mov    %eax,(%esp)
  80163f:	e8 67 f3 ff ff       	call   8009ab <fd_lookup>
  801644:	85 c0                	test   %eax,%eax
  801646:	78 11                	js     801659 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801651:	39 10                	cmp    %edx,(%eax)
  801653:	0f 94 c0             	sete   %al
  801656:	0f b6 c0             	movzbl %al,%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <opencons>:

int
opencons(void)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801661:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 cb f2 ff ff       	call   800937 <fd_alloc>
		return r;
  80166c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 40                	js     8016b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801672:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801679:	00 
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801688:	e8 0c f0 ff ff       	call   800699 <sys_page_alloc>
		return r;
  80168d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80168f:	85 c0                	test   %eax,%eax
  801691:	78 1f                	js     8016b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801693:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8016a8:	89 04 24             	mov    %eax,(%esp)
  8016ab:	e8 60 f2 ff ff       	call   800910 <fd2num>
  8016b0:	89 c2                	mov    %eax,%edx
}
  8016b2:	89 d0                	mov    %edx,%eax
  8016b4:	c9                   	leave  
  8016b5:	c3                   	ret    

008016b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8016b6:	55                   	push   %ebp
  8016b7:	89 e5                	mov    %esp,%ebp
  8016b9:	56                   	push   %esi
  8016ba:	53                   	push   %ebx
  8016bb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8016be:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8016c1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8016c7:	e8 8f ef ff ff       	call   80065b <sys_getenvid>
  8016cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016cf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016da:	89 74 24 08          	mov    %esi,0x8(%esp)
  8016de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e2:	c7 04 24 b4 22 80 00 	movl   $0x8022b4,(%esp)
  8016e9:	e8 c1 00 00 00       	call   8017af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8016ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f5:	89 04 24             	mov    %eax,(%esp)
  8016f8:	e8 51 00 00 00       	call   80174e <vcprintf>
	cprintf("\n");
  8016fd:	c7 04 24 a1 22 80 00 	movl   $0x8022a1,(%esp)
  801704:	e8 a6 00 00 00       	call   8017af <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801709:	cc                   	int3   
  80170a:	eb fd                	jmp    801709 <_panic+0x53>

0080170c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	53                   	push   %ebx
  801710:	83 ec 14             	sub    $0x14,%esp
  801713:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801716:	8b 13                	mov    (%ebx),%edx
  801718:	8d 42 01             	lea    0x1(%edx),%eax
  80171b:	89 03                	mov    %eax,(%ebx)
  80171d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801720:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801724:	3d ff 00 00 00       	cmp    $0xff,%eax
  801729:	75 19                	jne    801744 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80172b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801732:	00 
  801733:	8d 43 08             	lea    0x8(%ebx),%eax
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	e8 8e ee ff ff       	call   8005cc <sys_cputs>
		b->idx = 0;
  80173e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801744:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801748:	83 c4 14             	add    $0x14,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    

0080174e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801757:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80175e:	00 00 00 
	b.cnt = 0;
  801761:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801768:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80176b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	89 44 24 08          	mov    %eax,0x8(%esp)
  801779:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80177f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801783:	c7 04 24 0c 17 80 00 	movl   $0x80170c,(%esp)
  80178a:	e8 b5 01 00 00       	call   801944 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80178f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801795:	89 44 24 04          	mov    %eax,0x4(%esp)
  801799:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80179f:	89 04 24             	mov    %eax,(%esp)
  8017a2:	e8 25 ee ff ff       	call   8005cc <sys_cputs>

	return b.cnt;
}
  8017a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8017ad:	c9                   	leave  
  8017ae:	c3                   	ret    

008017af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8017af:	55                   	push   %ebp
  8017b0:	89 e5                	mov    %esp,%ebp
  8017b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8017b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	89 04 24             	mov    %eax,(%esp)
  8017c2:	e8 87 ff ff ff       	call   80174e <vcprintf>
	va_end(ap);

	return cnt;
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    
  8017c9:	66 90                	xchg   %ax,%ax
  8017cb:	66 90                	xchg   %ax,%ax
  8017cd:	66 90                	xchg   %ax,%ax
  8017cf:	90                   	nop

008017d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8017d0:	55                   	push   %ebp
  8017d1:	89 e5                	mov    %esp,%ebp
  8017d3:	57                   	push   %edi
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	83 ec 3c             	sub    $0x3c,%esp
  8017d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017dc:	89 d7                	mov    %edx,%edi
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8017ea:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8017ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8017f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8017f8:	39 f1                	cmp    %esi,%ecx
  8017fa:	72 14                	jb     801810 <printnum+0x40>
  8017fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8017ff:	76 0f                	jbe    801810 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801801:	8b 45 14             	mov    0x14(%ebp),%eax
  801804:	8d 70 ff             	lea    -0x1(%eax),%esi
  801807:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80180a:	85 f6                	test   %esi,%esi
  80180c:	7f 60                	jg     80186e <printnum+0x9e>
  80180e:	eb 72                	jmp    801882 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801810:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801813:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801817:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80181a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80181d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801821:	89 44 24 08          	mov    %eax,0x8(%esp)
  801825:	8b 44 24 08          	mov    0x8(%esp),%eax
  801829:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80182d:	89 c3                	mov    %eax,%ebx
  80182f:	89 d6                	mov    %edx,%esi
  801831:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801834:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801837:	89 54 24 08          	mov    %edx,0x8(%esp)
  80183b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80183f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184c:	e8 af 06 00 00       	call   801f00 <__udivdi3>
  801851:	89 d9                	mov    %ebx,%ecx
  801853:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801857:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80185b:	89 04 24             	mov    %eax,(%esp)
  80185e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801862:	89 fa                	mov    %edi,%edx
  801864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801867:	e8 64 ff ff ff       	call   8017d0 <printnum>
  80186c:	eb 14                	jmp    801882 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80186e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801872:	8b 45 18             	mov    0x18(%ebp),%eax
  801875:	89 04 24             	mov    %eax,(%esp)
  801878:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80187a:	83 ee 01             	sub    $0x1,%esi
  80187d:	75 ef                	jne    80186e <printnum+0x9e>
  80187f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801882:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801886:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80188a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80188d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801890:	89 44 24 08          	mov    %eax,0x8(%esp)
  801894:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801898:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189b:	89 04 24             	mov    %eax,(%esp)
  80189e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a5:	e8 86 07 00 00       	call   802030 <__umoddi3>
  8018aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8018ae:	0f be 80 d7 22 80 00 	movsbl 0x8022d7(%eax),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018bb:	ff d0                	call   *%eax
}
  8018bd:	83 c4 3c             	add    $0x3c,%esp
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5f                   	pop    %edi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8018c8:	83 fa 01             	cmp    $0x1,%edx
  8018cb:	7e 0e                	jle    8018db <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8018cd:	8b 10                	mov    (%eax),%edx
  8018cf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8018d2:	89 08                	mov    %ecx,(%eax)
  8018d4:	8b 02                	mov    (%edx),%eax
  8018d6:	8b 52 04             	mov    0x4(%edx),%edx
  8018d9:	eb 22                	jmp    8018fd <getuint+0x38>
	else if (lflag)
  8018db:	85 d2                	test   %edx,%edx
  8018dd:	74 10                	je     8018ef <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8018df:	8b 10                	mov    (%eax),%edx
  8018e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8018e4:	89 08                	mov    %ecx,(%eax)
  8018e6:	8b 02                	mov    (%edx),%eax
  8018e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ed:	eb 0e                	jmp    8018fd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8018ef:	8b 10                	mov    (%eax),%edx
  8018f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8018f4:	89 08                	mov    %ecx,(%eax)
  8018f6:	8b 02                	mov    (%edx),%eax
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8018fd:	5d                   	pop    %ebp
  8018fe:	c3                   	ret    

008018ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801905:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801909:	8b 10                	mov    (%eax),%edx
  80190b:	3b 50 04             	cmp    0x4(%eax),%edx
  80190e:	73 0a                	jae    80191a <sprintputch+0x1b>
		*b->buf++ = ch;
  801910:	8d 4a 01             	lea    0x1(%edx),%ecx
  801913:	89 08                	mov    %ecx,(%eax)
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	88 02                	mov    %al,(%edx)
}
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801922:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801925:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801929:	8b 45 10             	mov    0x10(%ebp),%eax
  80192c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	89 44 24 04          	mov    %eax,0x4(%esp)
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	89 04 24             	mov    %eax,(%esp)
  80193d:	e8 02 00 00 00       	call   801944 <vprintfmt>
	va_end(ap);
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	57                   	push   %edi
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
  80194a:	83 ec 3c             	sub    $0x3c,%esp
  80194d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801950:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801953:	eb 18                	jmp    80196d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801955:	85 c0                	test   %eax,%eax
  801957:	0f 84 c3 03 00 00    	je     801d20 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80195d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801961:	89 04 24             	mov    %eax,(%esp)
  801964:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801967:	89 f3                	mov    %esi,%ebx
  801969:	eb 02                	jmp    80196d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80196b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80196d:	8d 73 01             	lea    0x1(%ebx),%esi
  801970:	0f b6 03             	movzbl (%ebx),%eax
  801973:	83 f8 25             	cmp    $0x25,%eax
  801976:	75 dd                	jne    801955 <vprintfmt+0x11>
  801978:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80197c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801983:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80198a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801991:	ba 00 00 00 00       	mov    $0x0,%edx
  801996:	eb 1d                	jmp    8019b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801998:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80199a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80199e:	eb 15                	jmp    8019b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019a0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8019a2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8019a6:	eb 0d                	jmp    8019b5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8019a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019ae:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019b5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8019b8:	0f b6 06             	movzbl (%esi),%eax
  8019bb:	0f b6 c8             	movzbl %al,%ecx
  8019be:	83 e8 23             	sub    $0x23,%eax
  8019c1:	3c 55                	cmp    $0x55,%al
  8019c3:	0f 87 2f 03 00 00    	ja     801cf8 <vprintfmt+0x3b4>
  8019c9:	0f b6 c0             	movzbl %al,%eax
  8019cc:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8019d3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8019d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8019d9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8019dd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8019e0:	83 f9 09             	cmp    $0x9,%ecx
  8019e3:	77 50                	ja     801a35 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8019e5:	89 de                	mov    %ebx,%esi
  8019e7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8019ea:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8019ed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8019f0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8019f4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8019f7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8019fa:	83 fb 09             	cmp    $0x9,%ebx
  8019fd:	76 eb                	jbe    8019ea <vprintfmt+0xa6>
  8019ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801a02:	eb 33                	jmp    801a37 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801a04:	8b 45 14             	mov    0x14(%ebp),%eax
  801a07:	8d 48 04             	lea    0x4(%eax),%ecx
  801a0a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  801a0d:	8b 00                	mov    (%eax),%eax
  801a0f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a12:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801a14:	eb 21                	jmp    801a37 <vprintfmt+0xf3>
  801a16:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801a19:	85 c9                	test   %ecx,%ecx
  801a1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a20:	0f 49 c1             	cmovns %ecx,%eax
  801a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a26:	89 de                	mov    %ebx,%esi
  801a28:	eb 8b                	jmp    8019b5 <vprintfmt+0x71>
  801a2a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  801a2c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801a33:	eb 80                	jmp    8019b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a35:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801a37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a3b:	0f 89 74 ff ff ff    	jns    8019b5 <vprintfmt+0x71>
  801a41:	e9 62 ff ff ff       	jmp    8019a8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801a46:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a49:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  801a4b:	e9 65 ff ff ff       	jmp    8019b5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801a50:	8b 45 14             	mov    0x14(%ebp),%eax
  801a53:	8d 50 04             	lea    0x4(%eax),%edx
  801a56:	89 55 14             	mov    %edx,0x14(%ebp)
  801a59:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a5d:	8b 00                	mov    (%eax),%eax
  801a5f:	89 04 24             	mov    %eax,(%esp)
  801a62:	ff 55 08             	call   *0x8(%ebp)
			break;
  801a65:	e9 03 ff ff ff       	jmp    80196d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6d:	8d 50 04             	lea    0x4(%eax),%edx
  801a70:	89 55 14             	mov    %edx,0x14(%ebp)
  801a73:	8b 00                	mov    (%eax),%eax
  801a75:	99                   	cltd   
  801a76:	31 d0                	xor    %edx,%eax
  801a78:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801a7a:	83 f8 0f             	cmp    $0xf,%eax
  801a7d:	7f 0b                	jg     801a8a <vprintfmt+0x146>
  801a7f:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  801a86:	85 d2                	test   %edx,%edx
  801a88:	75 20                	jne    801aaa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  801a8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a8e:	c7 44 24 08 ef 22 80 	movl   $0x8022ef,0x8(%esp)
  801a95:	00 
  801a96:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	89 04 24             	mov    %eax,(%esp)
  801aa0:	e8 77 fe ff ff       	call   80191c <printfmt>
  801aa5:	e9 c3 fe ff ff       	jmp    80196d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  801aaa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801aae:	c7 44 24 08 6f 22 80 	movl   $0x80226f,0x8(%esp)
  801ab5:	00 
  801ab6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801aba:	8b 45 08             	mov    0x8(%ebp),%eax
  801abd:	89 04 24             	mov    %eax,(%esp)
  801ac0:	e8 57 fe ff ff       	call   80191c <printfmt>
  801ac5:	e9 a3 fe ff ff       	jmp    80196d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801aca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  801acd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ad0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad3:	8d 50 04             	lea    0x4(%eax),%edx
  801ad6:	89 55 14             	mov    %edx,0x14(%ebp)
  801ad9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  801adb:	85 c0                	test   %eax,%eax
  801add:	ba e8 22 80 00       	mov    $0x8022e8,%edx
  801ae2:	0f 45 d0             	cmovne %eax,%edx
  801ae5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801ae8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  801aec:	74 04                	je     801af2 <vprintfmt+0x1ae>
  801aee:	85 f6                	test   %esi,%esi
  801af0:	7f 19                	jg     801b0b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801af2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801af5:	8d 70 01             	lea    0x1(%eax),%esi
  801af8:	0f b6 10             	movzbl (%eax),%edx
  801afb:	0f be c2             	movsbl %dl,%eax
  801afe:	85 c0                	test   %eax,%eax
  801b00:	0f 85 95 00 00 00    	jne    801b9b <vprintfmt+0x257>
  801b06:	e9 85 00 00 00       	jmp    801b90 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b0f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 98 e6 ff ff       	call   8001b2 <strnlen>
  801b1a:	29 c6                	sub    %eax,%esi
  801b1c:	89 f0                	mov    %esi,%eax
  801b1e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801b21:	85 f6                	test   %esi,%esi
  801b23:	7e cd                	jle    801af2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801b25:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801b29:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801b2c:	89 c3                	mov    %eax,%ebx
  801b2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b32:	89 34 24             	mov    %esi,(%esp)
  801b35:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801b38:	83 eb 01             	sub    $0x1,%ebx
  801b3b:	75 f1                	jne    801b2e <vprintfmt+0x1ea>
  801b3d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801b40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b43:	eb ad                	jmp    801af2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801b45:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b49:	74 1e                	je     801b69 <vprintfmt+0x225>
  801b4b:	0f be d2             	movsbl %dl,%edx
  801b4e:	83 ea 20             	sub    $0x20,%edx
  801b51:	83 fa 5e             	cmp    $0x5e,%edx
  801b54:	76 13                	jbe    801b69 <vprintfmt+0x225>
					putch('?', putdat);
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801b64:	ff 55 08             	call   *0x8(%ebp)
  801b67:	eb 0d                	jmp    801b76 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801b69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b70:	89 04 24             	mov    %eax,(%esp)
  801b73:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801b76:	83 ef 01             	sub    $0x1,%edi
  801b79:	83 c6 01             	add    $0x1,%esi
  801b7c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801b80:	0f be c2             	movsbl %dl,%eax
  801b83:	85 c0                	test   %eax,%eax
  801b85:	75 20                	jne    801ba7 <vprintfmt+0x263>
  801b87:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801b8a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b8d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801b90:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b94:	7f 25                	jg     801bbb <vprintfmt+0x277>
  801b96:	e9 d2 fd ff ff       	jmp    80196d <vprintfmt+0x29>
  801b9b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  801b9e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801ba1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801ba4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801ba7:	85 db                	test   %ebx,%ebx
  801ba9:	78 9a                	js     801b45 <vprintfmt+0x201>
  801bab:	83 eb 01             	sub    $0x1,%ebx
  801bae:	79 95                	jns    801b45 <vprintfmt+0x201>
  801bb0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801bb3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801bb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bb9:	eb d5                	jmp    801b90 <vprintfmt+0x24c>
  801bbb:	8b 75 08             	mov    0x8(%ebp),%esi
  801bbe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801bc1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801bc4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801bc8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801bcf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801bd1:	83 eb 01             	sub    $0x1,%ebx
  801bd4:	75 ee                	jne    801bc4 <vprintfmt+0x280>
  801bd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bd9:	e9 8f fd ff ff       	jmp    80196d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801bde:	83 fa 01             	cmp    $0x1,%edx
  801be1:	7e 16                	jle    801bf9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801be3:	8b 45 14             	mov    0x14(%ebp),%eax
  801be6:	8d 50 08             	lea    0x8(%eax),%edx
  801be9:	89 55 14             	mov    %edx,0x14(%ebp)
  801bec:	8b 50 04             	mov    0x4(%eax),%edx
  801bef:	8b 00                	mov    (%eax),%eax
  801bf1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801bf4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801bf7:	eb 32                	jmp    801c2b <vprintfmt+0x2e7>
	else if (lflag)
  801bf9:	85 d2                	test   %edx,%edx
  801bfb:	74 18                	je     801c15 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8d 50 04             	lea    0x4(%eax),%edx
  801c03:	89 55 14             	mov    %edx,0x14(%ebp)
  801c06:	8b 30                	mov    (%eax),%esi
  801c08:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c0b:	89 f0                	mov    %esi,%eax
  801c0d:	c1 f8 1f             	sar    $0x1f,%eax
  801c10:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801c13:	eb 16                	jmp    801c2b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801c15:	8b 45 14             	mov    0x14(%ebp),%eax
  801c18:	8d 50 04             	lea    0x4(%eax),%edx
  801c1b:	89 55 14             	mov    %edx,0x14(%ebp)
  801c1e:	8b 30                	mov    (%eax),%esi
  801c20:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801c23:	89 f0                	mov    %esi,%eax
  801c25:	c1 f8 1f             	sar    $0x1f,%eax
  801c28:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801c31:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801c36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c3a:	0f 89 80 00 00 00    	jns    801cc0 <vprintfmt+0x37c>
				putch('-', putdat);
  801c40:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c44:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801c4b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  801c4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801c54:	f7 d8                	neg    %eax
  801c56:	83 d2 00             	adc    $0x0,%edx
  801c59:	f7 da                	neg    %edx
			}
			base = 10;
  801c5b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801c60:	eb 5e                	jmp    801cc0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801c62:	8d 45 14             	lea    0x14(%ebp),%eax
  801c65:	e8 5b fc ff ff       	call   8018c5 <getuint>
			base = 10;
  801c6a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  801c6f:	eb 4f                	jmp    801cc0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801c71:	8d 45 14             	lea    0x14(%ebp),%eax
  801c74:	e8 4c fc ff ff       	call   8018c5 <getuint>
			base = 8;
  801c79:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  801c7e:	eb 40                	jmp    801cc0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801c80:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c84:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801c8b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  801c8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801c92:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801c99:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  801c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9f:	8d 50 04             	lea    0x4(%eax),%edx
  801ca2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801ca5:	8b 00                	mov    (%eax),%eax
  801ca7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  801cac:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801cb1:	eb 0d                	jmp    801cc0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801cb3:	8d 45 14             	lea    0x14(%ebp),%eax
  801cb6:	e8 0a fc ff ff       	call   8018c5 <getuint>
			base = 16;
  801cbb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801cc0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801cc4:	89 74 24 10          	mov    %esi,0x10(%esp)
  801cc8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801ccb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ccf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cd3:	89 04 24             	mov    %eax,(%esp)
  801cd6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cda:	89 fa                	mov    %edi,%edx
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	e8 ec fa ff ff       	call   8017d0 <printnum>
			break;
  801ce4:	e9 84 fc ff ff       	jmp    80196d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801ce9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ced:	89 0c 24             	mov    %ecx,(%esp)
  801cf0:	ff 55 08             	call   *0x8(%ebp)
			break;
  801cf3:	e9 75 fc ff ff       	jmp    80196d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801cf8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801cfc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801d03:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801d06:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  801d0a:	0f 84 5b fc ff ff    	je     80196b <vprintfmt+0x27>
  801d10:	89 f3                	mov    %esi,%ebx
  801d12:	83 eb 01             	sub    $0x1,%ebx
  801d15:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801d19:	75 f7                	jne    801d12 <vprintfmt+0x3ce>
  801d1b:	e9 4d fc ff ff       	jmp    80196d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801d20:	83 c4 3c             	add    $0x3c,%esp
  801d23:	5b                   	pop    %ebx
  801d24:	5e                   	pop    %esi
  801d25:	5f                   	pop    %edi
  801d26:	5d                   	pop    %ebp
  801d27:	c3                   	ret    

00801d28 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
  801d2b:	83 ec 28             	sub    $0x28,%esp
  801d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d31:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801d34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d37:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801d3b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801d3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801d45:	85 c0                	test   %eax,%eax
  801d47:	74 30                	je     801d79 <vsnprintf+0x51>
  801d49:	85 d2                	test   %edx,%edx
  801d4b:	7e 2c                	jle    801d79 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d50:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d62:	c7 04 24 ff 18 80 00 	movl   $0x8018ff,(%esp)
  801d69:	e8 d6 fb ff ff       	call   801944 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801d6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d71:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	eb 05                	jmp    801d7e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801d79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d86:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801d89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 04 24             	mov    %eax,(%esp)
  801da1:	e8 82 ff ff ff       	call   801d28 <vsnprintf>
	va_end(ap);

	return rc;
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	56                   	push   %esi
  801dac:	53                   	push   %ebx
  801dad:	83 ec 10             	sub    $0x10,%esp
  801db0:	8b 75 08             	mov    0x8(%ebp),%esi
  801db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801db9:	83 f8 01             	cmp    $0x1,%eax
  801dbc:	19 c0                	sbb    %eax,%eax
  801dbe:	f7 d0                	not    %eax
  801dc0:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801dc5:	89 04 24             	mov    %eax,(%esp)
  801dc8:	e8 e2 ea ff ff       	call   8008af <sys_ipc_recv>
	if (err_code < 0) {
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	79 16                	jns    801de7 <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801dd1:	85 f6                	test   %esi,%esi
  801dd3:	74 06                	je     801ddb <ipc_recv+0x33>
  801dd5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801ddb:	85 db                	test   %ebx,%ebx
  801ddd:	74 2c                	je     801e0b <ipc_recv+0x63>
  801ddf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801de5:	eb 24                	jmp    801e0b <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801de7:	85 f6                	test   %esi,%esi
  801de9:	74 0a                	je     801df5 <ipc_recv+0x4d>
  801deb:	a1 04 40 80 00       	mov    0x804004,%eax
  801df0:	8b 40 74             	mov    0x74(%eax),%eax
  801df3:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801df5:	85 db                	test   %ebx,%ebx
  801df7:	74 0a                	je     801e03 <ipc_recv+0x5b>
  801df9:	a1 04 40 80 00       	mov    0x804004,%eax
  801dfe:	8b 40 78             	mov    0x78(%eax),%eax
  801e01:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801e03:	a1 04 40 80 00       	mov    0x804004,%eax
  801e08:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	57                   	push   %edi
  801e16:	56                   	push   %esi
  801e17:	53                   	push   %ebx
  801e18:	83 ec 1c             	sub    $0x1c,%esp
  801e1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e21:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e24:	eb 25                	jmp    801e4b <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801e26:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e29:	74 20                	je     801e4b <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801e2b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e2f:	c7 44 24 08 e0 25 80 	movl   $0x8025e0,0x8(%esp)
  801e36:	00 
  801e37:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e3e:	00 
  801e3f:	c7 04 24 ec 25 80 00 	movl   $0x8025ec,(%esp)
  801e46:	e8 6b f8 ff ff       	call   8016b6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e4b:	85 db                	test   %ebx,%ebx
  801e4d:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e52:	0f 45 c3             	cmovne %ebx,%eax
  801e55:	8b 55 14             	mov    0x14(%ebp),%edx
  801e58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e60:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e64:	89 3c 24             	mov    %edi,(%esp)
  801e67:	e8 20 ea ff ff       	call   80088c <sys_ipc_try_send>
  801e6c:	85 c0                	test   %eax,%eax
  801e6e:	75 b6                	jne    801e26 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801e70:	83 c4 1c             	add    $0x1c,%esp
  801e73:	5b                   	pop    %ebx
  801e74:	5e                   	pop    %esi
  801e75:	5f                   	pop    %edi
  801e76:	5d                   	pop    %ebp
  801e77:	c3                   	ret    

00801e78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e7e:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e83:	39 c8                	cmp    %ecx,%eax
  801e85:	74 17                	je     801e9e <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e87:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e8c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e8f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e95:	8b 52 50             	mov    0x50(%edx),%edx
  801e98:	39 ca                	cmp    %ecx,%edx
  801e9a:	75 14                	jne    801eb0 <ipc_find_env+0x38>
  801e9c:	eb 05                	jmp    801ea3 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ea3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ea6:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801eab:	8b 40 40             	mov    0x40(%eax),%eax
  801eae:	eb 0e                	jmp    801ebe <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eb0:	83 c0 01             	add    $0x1,%eax
  801eb3:	3d 00 04 00 00       	cmp    $0x400,%eax
  801eb8:	75 d2                	jne    801e8c <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801eba:	66 b8 00 00          	mov    $0x0,%ax
}
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ec6:	89 d0                	mov    %edx,%eax
  801ec8:	c1 e8 16             	shr    $0x16,%eax
  801ecb:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ed7:	f6 c1 01             	test   $0x1,%cl
  801eda:	74 1d                	je     801ef9 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801edc:	c1 ea 0c             	shr    $0xc,%edx
  801edf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ee6:	f6 c2 01             	test   $0x1,%dl
  801ee9:	74 0e                	je     801ef9 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801eeb:	c1 ea 0c             	shr    $0xc,%edx
  801eee:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801ef5:	ef 
  801ef6:	0f b7 c0             	movzwl %ax,%eax
}
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    
  801efb:	66 90                	xchg   %ax,%ax
  801efd:	66 90                	xchg   %ax,%ax
  801eff:	90                   	nop

00801f00 <__udivdi3>:
  801f00:	55                   	push   %ebp
  801f01:	57                   	push   %edi
  801f02:	56                   	push   %esi
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801f0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801f12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f16:	85 c0                	test   %eax,%eax
  801f18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f1c:	89 ea                	mov    %ebp,%edx
  801f1e:	89 0c 24             	mov    %ecx,(%esp)
  801f21:	75 2d                	jne    801f50 <__udivdi3+0x50>
  801f23:	39 e9                	cmp    %ebp,%ecx
  801f25:	77 61                	ja     801f88 <__udivdi3+0x88>
  801f27:	85 c9                	test   %ecx,%ecx
  801f29:	89 ce                	mov    %ecx,%esi
  801f2b:	75 0b                	jne    801f38 <__udivdi3+0x38>
  801f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f32:	31 d2                	xor    %edx,%edx
  801f34:	f7 f1                	div    %ecx
  801f36:	89 c6                	mov    %eax,%esi
  801f38:	31 d2                	xor    %edx,%edx
  801f3a:	89 e8                	mov    %ebp,%eax
  801f3c:	f7 f6                	div    %esi
  801f3e:	89 c5                	mov    %eax,%ebp
  801f40:	89 f8                	mov    %edi,%eax
  801f42:	f7 f6                	div    %esi
  801f44:	89 ea                	mov    %ebp,%edx
  801f46:	83 c4 0c             	add    $0xc,%esp
  801f49:	5e                   	pop    %esi
  801f4a:	5f                   	pop    %edi
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    
  801f4d:	8d 76 00             	lea    0x0(%esi),%esi
  801f50:	39 e8                	cmp    %ebp,%eax
  801f52:	77 24                	ja     801f78 <__udivdi3+0x78>
  801f54:	0f bd e8             	bsr    %eax,%ebp
  801f57:	83 f5 1f             	xor    $0x1f,%ebp
  801f5a:	75 3c                	jne    801f98 <__udivdi3+0x98>
  801f5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f60:	39 34 24             	cmp    %esi,(%esp)
  801f63:	0f 86 9f 00 00 00    	jbe    802008 <__udivdi3+0x108>
  801f69:	39 d0                	cmp    %edx,%eax
  801f6b:	0f 82 97 00 00 00    	jb     802008 <__udivdi3+0x108>
  801f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f78:	31 d2                	xor    %edx,%edx
  801f7a:	31 c0                	xor    %eax,%eax
  801f7c:	83 c4 0c             	add    $0xc,%esp
  801f7f:	5e                   	pop    %esi
  801f80:	5f                   	pop    %edi
  801f81:	5d                   	pop    %ebp
  801f82:	c3                   	ret    
  801f83:	90                   	nop
  801f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f88:	89 f8                	mov    %edi,%eax
  801f8a:	f7 f1                	div    %ecx
  801f8c:	31 d2                	xor    %edx,%edx
  801f8e:	83 c4 0c             	add    $0xc,%esp
  801f91:	5e                   	pop    %esi
  801f92:	5f                   	pop    %edi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    
  801f95:	8d 76 00             	lea    0x0(%esi),%esi
  801f98:	89 e9                	mov    %ebp,%ecx
  801f9a:	8b 3c 24             	mov    (%esp),%edi
  801f9d:	d3 e0                	shl    %cl,%eax
  801f9f:	89 c6                	mov    %eax,%esi
  801fa1:	b8 20 00 00 00       	mov    $0x20,%eax
  801fa6:	29 e8                	sub    %ebp,%eax
  801fa8:	89 c1                	mov    %eax,%ecx
  801faa:	d3 ef                	shr    %cl,%edi
  801fac:	89 e9                	mov    %ebp,%ecx
  801fae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fb2:	8b 3c 24             	mov    (%esp),%edi
  801fb5:	09 74 24 08          	or     %esi,0x8(%esp)
  801fb9:	89 d6                	mov    %edx,%esi
  801fbb:	d3 e7                	shl    %cl,%edi
  801fbd:	89 c1                	mov    %eax,%ecx
  801fbf:	89 3c 24             	mov    %edi,(%esp)
  801fc2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fc6:	d3 ee                	shr    %cl,%esi
  801fc8:	89 e9                	mov    %ebp,%ecx
  801fca:	d3 e2                	shl    %cl,%edx
  801fcc:	89 c1                	mov    %eax,%ecx
  801fce:	d3 ef                	shr    %cl,%edi
  801fd0:	09 d7                	or     %edx,%edi
  801fd2:	89 f2                	mov    %esi,%edx
  801fd4:	89 f8                	mov    %edi,%eax
  801fd6:	f7 74 24 08          	divl   0x8(%esp)
  801fda:	89 d6                	mov    %edx,%esi
  801fdc:	89 c7                	mov    %eax,%edi
  801fde:	f7 24 24             	mull   (%esp)
  801fe1:	39 d6                	cmp    %edx,%esi
  801fe3:	89 14 24             	mov    %edx,(%esp)
  801fe6:	72 30                	jb     802018 <__udivdi3+0x118>
  801fe8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801fec:	89 e9                	mov    %ebp,%ecx
  801fee:	d3 e2                	shl    %cl,%edx
  801ff0:	39 c2                	cmp    %eax,%edx
  801ff2:	73 05                	jae    801ff9 <__udivdi3+0xf9>
  801ff4:	3b 34 24             	cmp    (%esp),%esi
  801ff7:	74 1f                	je     802018 <__udivdi3+0x118>
  801ff9:	89 f8                	mov    %edi,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	e9 7a ff ff ff       	jmp    801f7c <__udivdi3+0x7c>
  802002:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802008:	31 d2                	xor    %edx,%edx
  80200a:	b8 01 00 00 00       	mov    $0x1,%eax
  80200f:	e9 68 ff ff ff       	jmp    801f7c <__udivdi3+0x7c>
  802014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802018:	8d 47 ff             	lea    -0x1(%edi),%eax
  80201b:	31 d2                	xor    %edx,%edx
  80201d:	83 c4 0c             	add    $0xc,%esp
  802020:	5e                   	pop    %esi
  802021:	5f                   	pop    %edi
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    
  802024:	66 90                	xchg   %ax,%ax
  802026:	66 90                	xchg   %ax,%ax
  802028:	66 90                	xchg   %ax,%ax
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <__umoddi3>:
  802030:	55                   	push   %ebp
  802031:	57                   	push   %edi
  802032:	56                   	push   %esi
  802033:	83 ec 14             	sub    $0x14,%esp
  802036:	8b 44 24 28          	mov    0x28(%esp),%eax
  80203a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80203e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802042:	89 c7                	mov    %eax,%edi
  802044:	89 44 24 04          	mov    %eax,0x4(%esp)
  802048:	8b 44 24 30          	mov    0x30(%esp),%eax
  80204c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802050:	89 34 24             	mov    %esi,(%esp)
  802053:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802057:	85 c0                	test   %eax,%eax
  802059:	89 c2                	mov    %eax,%edx
  80205b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80205f:	75 17                	jne    802078 <__umoddi3+0x48>
  802061:	39 fe                	cmp    %edi,%esi
  802063:	76 4b                	jbe    8020b0 <__umoddi3+0x80>
  802065:	89 c8                	mov    %ecx,%eax
  802067:	89 fa                	mov    %edi,%edx
  802069:	f7 f6                	div    %esi
  80206b:	89 d0                	mov    %edx,%eax
  80206d:	31 d2                	xor    %edx,%edx
  80206f:	83 c4 14             	add    $0x14,%esp
  802072:	5e                   	pop    %esi
  802073:	5f                   	pop    %edi
  802074:	5d                   	pop    %ebp
  802075:	c3                   	ret    
  802076:	66 90                	xchg   %ax,%ax
  802078:	39 f8                	cmp    %edi,%eax
  80207a:	77 54                	ja     8020d0 <__umoddi3+0xa0>
  80207c:	0f bd e8             	bsr    %eax,%ebp
  80207f:	83 f5 1f             	xor    $0x1f,%ebp
  802082:	75 5c                	jne    8020e0 <__umoddi3+0xb0>
  802084:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802088:	39 3c 24             	cmp    %edi,(%esp)
  80208b:	0f 87 e7 00 00 00    	ja     802178 <__umoddi3+0x148>
  802091:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802095:	29 f1                	sub    %esi,%ecx
  802097:	19 c7                	sbb    %eax,%edi
  802099:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80209d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8020a9:	83 c4 14             	add    $0x14,%esp
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
  8020b0:	85 f6                	test   %esi,%esi
  8020b2:	89 f5                	mov    %esi,%ebp
  8020b4:	75 0b                	jne    8020c1 <__umoddi3+0x91>
  8020b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020bb:	31 d2                	xor    %edx,%edx
  8020bd:	f7 f6                	div    %esi
  8020bf:	89 c5                	mov    %eax,%ebp
  8020c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020c5:	31 d2                	xor    %edx,%edx
  8020c7:	f7 f5                	div    %ebp
  8020c9:	89 c8                	mov    %ecx,%eax
  8020cb:	f7 f5                	div    %ebp
  8020cd:	eb 9c                	jmp    80206b <__umoddi3+0x3b>
  8020cf:	90                   	nop
  8020d0:	89 c8                	mov    %ecx,%eax
  8020d2:	89 fa                	mov    %edi,%edx
  8020d4:	83 c4 14             	add    $0x14,%esp
  8020d7:	5e                   	pop    %esi
  8020d8:	5f                   	pop    %edi
  8020d9:	5d                   	pop    %ebp
  8020da:	c3                   	ret    
  8020db:	90                   	nop
  8020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	8b 04 24             	mov    (%esp),%eax
  8020e3:	be 20 00 00 00       	mov    $0x20,%esi
  8020e8:	89 e9                	mov    %ebp,%ecx
  8020ea:	29 ee                	sub    %ebp,%esi
  8020ec:	d3 e2                	shl    %cl,%edx
  8020ee:	89 f1                	mov    %esi,%ecx
  8020f0:	d3 e8                	shr    %cl,%eax
  8020f2:	89 e9                	mov    %ebp,%ecx
  8020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f8:	8b 04 24             	mov    (%esp),%eax
  8020fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8020ff:	89 fa                	mov    %edi,%edx
  802101:	d3 e0                	shl    %cl,%eax
  802103:	89 f1                	mov    %esi,%ecx
  802105:	89 44 24 08          	mov    %eax,0x8(%esp)
  802109:	8b 44 24 10          	mov    0x10(%esp),%eax
  80210d:	d3 ea                	shr    %cl,%edx
  80210f:	89 e9                	mov    %ebp,%ecx
  802111:	d3 e7                	shl    %cl,%edi
  802113:	89 f1                	mov    %esi,%ecx
  802115:	d3 e8                	shr    %cl,%eax
  802117:	89 e9                	mov    %ebp,%ecx
  802119:	09 f8                	or     %edi,%eax
  80211b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80211f:	f7 74 24 04          	divl   0x4(%esp)
  802123:	d3 e7                	shl    %cl,%edi
  802125:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802129:	89 d7                	mov    %edx,%edi
  80212b:	f7 64 24 08          	mull   0x8(%esp)
  80212f:	39 d7                	cmp    %edx,%edi
  802131:	89 c1                	mov    %eax,%ecx
  802133:	89 14 24             	mov    %edx,(%esp)
  802136:	72 2c                	jb     802164 <__umoddi3+0x134>
  802138:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80213c:	72 22                	jb     802160 <__umoddi3+0x130>
  80213e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802142:	29 c8                	sub    %ecx,%eax
  802144:	19 d7                	sbb    %edx,%edi
  802146:	89 e9                	mov    %ebp,%ecx
  802148:	89 fa                	mov    %edi,%edx
  80214a:	d3 e8                	shr    %cl,%eax
  80214c:	89 f1                	mov    %esi,%ecx
  80214e:	d3 e2                	shl    %cl,%edx
  802150:	89 e9                	mov    %ebp,%ecx
  802152:	d3 ef                	shr    %cl,%edi
  802154:	09 d0                	or     %edx,%eax
  802156:	89 fa                	mov    %edi,%edx
  802158:	83 c4 14             	add    $0x14,%esp
  80215b:	5e                   	pop    %esi
  80215c:	5f                   	pop    %edi
  80215d:	5d                   	pop    %ebp
  80215e:	c3                   	ret    
  80215f:	90                   	nop
  802160:	39 d7                	cmp    %edx,%edi
  802162:	75 da                	jne    80213e <__umoddi3+0x10e>
  802164:	8b 14 24             	mov    (%esp),%edx
  802167:	89 c1                	mov    %eax,%ecx
  802169:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80216d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802171:	eb cb                	jmp    80213e <__umoddi3+0x10e>
  802173:	90                   	nop
  802174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802178:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80217c:	0f 82 0f ff ff ff    	jb     802091 <__umoddi3+0x61>
  802182:	e9 1a ff ff ff       	jmp    8020a1 <__umoddi3+0x71>
