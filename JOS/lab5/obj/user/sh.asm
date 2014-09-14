
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 05 0a 00 00       	call   800a36 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 1c             	sub    $0x1c,%esp
  800049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  80004f:	85 db                	test   %ebx,%ebx
  800051:	75 28                	jne    80007b <_gettoken+0x3b>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
  800053:	b8 00 00 00 00       	mov    $0x0,%eax
_gettoken(char *s, char **p1, char **p2)
{
	int t;

	if (s == 0) {
		if (debug > 1)
  800058:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  80005f:	0f 8e 3a 01 00 00    	jle    80019f <_gettoken+0x15f>
			cprintf("GETTOKEN NULL\n");
  800065:	c7 04 24 00 38 80 00 	movl   $0x803800,(%esp)
  80006c:	e8 4f 0b 00 00       	call   800bc0 <cprintf>
		return 0;
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
  800076:	e9 24 01 00 00       	jmp    80019f <_gettoken+0x15f>
	}

	if (debug > 1)
  80007b:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800082:	7e 10                	jle    800094 <_gettoken+0x54>
		cprintf("GETTOKEN: %s\n", s);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	c7 04 24 0f 38 80 00 	movl   $0x80380f,(%esp)
  80008f:	e8 2c 0b 00 00       	call   800bc0 <cprintf>

	*p1 = 0;
  800094:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  80009a:	8b 45 10             	mov    0x10(%ebp),%eax
  80009d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  8000a3:	eb 07                	jmp    8000ac <_gettoken+0x6c>
		*s++ = 0;
  8000a5:	83 c3 01             	add    $0x1,%ebx
  8000a8:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000ac:	0f be 03             	movsbl (%ebx),%eax
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	c7 04 24 1d 38 80 00 	movl   $0x80381d,(%esp)
  8000ba:	e8 9a 13 00 00       	call   801459 <strchr>
  8000bf:	85 c0                	test   %eax,%eax
  8000c1:	75 e2                	jne    8000a5 <_gettoken+0x65>
  8000c3:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000c5:	0f b6 03             	movzbl (%ebx),%eax
  8000c8:	84 c0                	test   %al,%al
  8000ca:	75 28                	jne    8000f4 <_gettoken+0xb4>
		if (debug > 1)
			cprintf("EOL\n");
		return 0;
  8000cc:	b8 00 00 00 00       	mov    $0x0,%eax
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
		*s++ = 0;
	if (*s == 0) {
		if (debug > 1)
  8000d1:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  8000d8:	0f 8e c1 00 00 00    	jle    80019f <_gettoken+0x15f>
			cprintf("EOL\n");
  8000de:	c7 04 24 22 38 80 00 	movl   $0x803822,(%esp)
  8000e5:	e8 d6 0a 00 00       	call   800bc0 <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 ab 00 00 00       	jmp    80019f <_gettoken+0x15f>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 33 38 80 00 	movl   $0x803833,(%esp)
  800102:	e8 52 13 00 00       	call   801459 <strchr>
  800107:	85 c0                	test   %eax,%eax
  800109:	74 2f                	je     80013a <_gettoken+0xfa>
		t = *s;
  80010b:	0f be 1b             	movsbl (%ebx),%ebx
		*p1 = s;
  80010e:	89 3e                	mov    %edi,(%esi)
		*s++ = 0;
  800110:	c6 07 00             	movb   $0x0,(%edi)
  800113:	83 c7 01             	add    $0x1,%edi
  800116:	8b 45 10             	mov    0x10(%ebp),%eax
  800119:	89 38                	mov    %edi,(%eax)
		*p2 = s;
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
  80011b:	89 d8                	mov    %ebx,%eax
	if (strchr(SYMBOLS, *s)) {
		t = *s;
		*p1 = s;
		*s++ = 0;
		*p2 = s;
		if (debug > 1)
  80011d:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800124:	7e 79                	jle    80019f <_gettoken+0x15f>
			cprintf("TOK %c\n", t);
  800126:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80012a:	c7 04 24 27 38 80 00 	movl   $0x803827,(%esp)
  800131:	e8 8a 0a 00 00       	call   800bc0 <cprintf>
		return t;
  800136:	89 d8                	mov    %ebx,%eax
  800138:	eb 65                	jmp    80019f <_gettoken+0x15f>
	}
	*p1 = s;
  80013a:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80013c:	0f b6 03             	movzbl (%ebx),%eax
  80013f:	84 c0                	test   %al,%al
  800141:	75 0c                	jne    80014f <_gettoken+0x10f>
  800143:	eb 21                	jmp    800166 <_gettoken+0x126>
		s++;
  800145:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800148:	0f b6 03             	movzbl (%ebx),%eax
  80014b:	84 c0                	test   %al,%al
  80014d:	74 17                	je     800166 <_gettoken+0x126>
  80014f:	0f be c0             	movsbl %al,%eax
  800152:	89 44 24 04          	mov    %eax,0x4(%esp)
  800156:	c7 04 24 2f 38 80 00 	movl   $0x80382f,(%esp)
  80015d:	e8 f7 12 00 00       	call   801459 <strchr>
  800162:	85 c0                	test   %eax,%eax
  800164:	74 df                	je     800145 <_gettoken+0x105>
		s++;
	*p2 = s;
  800166:	8b 45 10             	mov    0x10(%ebp),%eax
  800169:	89 18                	mov    %ebx,(%eax)
		t = **p2;
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
  80016b:	b8 77 00 00 00       	mov    $0x77,%eax
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
		s++;
	*p2 = s;
	if (debug > 1) {
  800170:	83 3d 00 60 80 00 01 	cmpl   $0x1,0x806000
  800177:	7e 26                	jle    80019f <_gettoken+0x15f>
		t = **p2;
  800179:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  80017c:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80017f:	8b 06                	mov    (%esi),%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 3b 38 80 00 	movl   $0x80383b,(%esp)
  80018c:	e8 2f 0a 00 00       	call   800bc0 <cprintf>
		**p2 = t;
  800191:	8b 45 10             	mov    0x10(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	89 fa                	mov    %edi,%edx
  800198:	88 10                	mov    %dl,(%eax)
	}
	return 'w';
  80019a:	b8 77 00 00 00       	mov    $0x77,%eax
}
  80019f:	83 c4 1c             	add    $0x1c,%esp
  8001a2:	5b                   	pop    %ebx
  8001a3:	5e                   	pop    %esi
  8001a4:	5f                   	pop    %edi
  8001a5:	5d                   	pop    %ebp
  8001a6:	c3                   	ret    

008001a7 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a7:	55                   	push   %ebp
  8001a8:	89 e5                	mov    %esp,%ebp
  8001aa:	83 ec 18             	sub    $0x18,%esp
  8001ad:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001b0:	85 c0                	test   %eax,%eax
  8001b2:	74 24                	je     8001d8 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001b4:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001bb:	00 
  8001bc:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001c3:	00 
  8001c4:	89 04 24             	mov    %eax,(%esp)
  8001c7:	e8 74 fe ff ff       	call   800040 <_gettoken>
  8001cc:	a3 08 60 80 00       	mov    %eax,0x806008
		return 0;
  8001d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8001d6:	eb 3c                	jmp    800214 <gettoken+0x6d>
	}
	c = nc;
  8001d8:	a1 08 60 80 00       	mov    0x806008,%eax
  8001dd:	a3 04 60 80 00       	mov    %eax,0x806004
	*p1 = np1;
  8001e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e5:	8b 15 10 60 80 00    	mov    0x806010,%edx
  8001eb:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001ed:	c7 44 24 08 0c 60 80 	movl   $0x80600c,0x8(%esp)
  8001f4:	00 
  8001f5:	c7 44 24 04 10 60 80 	movl   $0x806010,0x4(%esp)
  8001fc:	00 
  8001fd:	a1 0c 60 80 00       	mov    0x80600c,%eax
  800202:	89 04 24             	mov    %eax,(%esp)
  800205:	e8 36 fe ff ff       	call   800040 <_gettoken>
  80020a:	a3 08 60 80 00       	mov    %eax,0x806008
	return c;
  80020f:	a1 04 60 80 00       	mov    0x806004,%eax
}
  800214:	c9                   	leave  
  800215:	c3                   	ret    

00800216 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
  800219:	57                   	push   %edi
  80021a:	56                   	push   %esi
  80021b:	53                   	push   %ebx
  80021c:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  800222:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800229:	00 
  80022a:	8b 45 08             	mov    0x8(%ebp),%eax
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 72 ff ff ff       	call   8001a7 <gettoken>

again:
	argc = 0;
  800235:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80023a:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  80023d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800241:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800248:	e8 5a ff ff ff       	call   8001a7 <gettoken>
  80024d:	83 f8 3e             	cmp    $0x3e,%eax
  800250:	0f 84 dd 00 00 00    	je     800333 <runcmd+0x11d>
  800256:	83 f8 3e             	cmp    $0x3e,%eax
  800259:	7f 1a                	jg     800275 <runcmd+0x5f>
  80025b:	85 c0                	test   %eax,%eax
  80025d:	8d 76 00             	lea    0x0(%esi),%esi
  800260:	0f 84 5b 02 00 00    	je     8004c1 <runcmd+0x2ab>
  800266:	83 f8 3c             	cmp    $0x3c,%eax
  800269:	74 44                	je     8002af <runcmd+0x99>
  80026b:	90                   	nop
  80026c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800270:	e9 2c 02 00 00       	jmp    8004a1 <runcmd+0x28b>
  800275:	83 f8 77             	cmp    $0x77,%eax
  800278:	74 11                	je     80028b <runcmd+0x75>
  80027a:	83 f8 7c             	cmp    $0x7c,%eax
  80027d:	8d 76 00             	lea    0x0(%esi),%esi
  800280:	0f 84 2e 01 00 00    	je     8003b4 <runcmd+0x19e>
  800286:	e9 16 02 00 00       	jmp    8004a1 <runcmd+0x28b>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  80028b:	83 fe 10             	cmp    $0x10,%esi
  80028e:	66 90                	xchg   %ax,%ax
  800290:	75 11                	jne    8002a3 <runcmd+0x8d>
				cprintf("too many arguments\n");
  800292:	c7 04 24 45 38 80 00 	movl   $0x803845,(%esp)
  800299:	e8 22 09 00 00       	call   800bc0 <cprintf>
				exit();
  80029e:	e8 0b 08 00 00       	call   800aae <exit>
			}
			argv[argc++] = t;
  8002a3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002a6:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  8002aa:	8d 76 01             	lea    0x1(%esi),%esi
			break;
  8002ad:	eb 8e                	jmp    80023d <runcmd+0x27>

		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002ba:	e8 e8 fe ff ff       	call   8001a7 <gettoken>
  8002bf:	83 f8 77             	cmp    $0x77,%eax
  8002c2:	74 11                	je     8002d5 <runcmd+0xbf>
				cprintf("syntax error: < not followed by word\n");
  8002c4:	c7 04 24 98 39 80 00 	movl   $0x803998,(%esp)
  8002cb:	e8 f0 08 00 00       	call   800bc0 <cprintf>
				exit();
  8002d0:	e8 d9 07 00 00       	call   800aae <exit>
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002dc:	00 
  8002dd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e0:	89 04 24             	mov    %eax,(%esp)
  8002e3:	e8 ae 23 00 00       	call   802696 <open>
  8002e8:	89 c7                	mov    %eax,%edi
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	79 1e                	jns    80030c <runcmd+0xf6>
				cprintf("open %s for read: %e", t, fd);
  8002ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f9:	c7 04 24 59 38 80 00 	movl   $0x803859,(%esp)
  800300:	e8 bb 08 00 00       	call   800bc0 <cprintf>
				exit();
  800305:	e8 a4 07 00 00       	call   800aae <exit>
  80030a:	eb 0a                	jmp    800316 <runcmd+0x100>
			}
			if (fd != 0) {
  80030c:	85 c0                	test   %eax,%eax
  80030e:	66 90                	xchg   %ax,%ax
  800310:	0f 84 27 ff ff ff    	je     80023d <runcmd+0x27>
				dup(fd, 0);
  800316:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80031d:	00 
  80031e:	89 3c 24             	mov    %edi,(%esp)
  800321:	e8 f2 1d 00 00       	call   802118 <dup>
				close(fd);
  800326:	89 3c 24             	mov    %edi,(%esp)
  800329:	e8 95 1d 00 00       	call   8020c3 <close>
  80032e:	e9 0a ff ff ff       	jmp    80023d <runcmd+0x27>
			}
			break;

		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800333:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800337:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80033e:	e8 64 fe ff ff       	call   8001a7 <gettoken>
  800343:	83 f8 77             	cmp    $0x77,%eax
  800346:	74 11                	je     800359 <runcmd+0x143>
				cprintf("syntax error: > not followed by word\n");
  800348:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  80034f:	e8 6c 08 00 00       	call   800bc0 <cprintf>
				exit();
  800354:	e8 55 07 00 00       	call   800aae <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800359:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800360:	00 
  800361:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800364:	89 04 24             	mov    %eax,(%esp)
  800367:	e8 2a 23 00 00       	call   802696 <open>
  80036c:	89 c7                	mov    %eax,%edi
  80036e:	85 c0                	test   %eax,%eax
  800370:	79 1c                	jns    80038e <runcmd+0x178>
				cprintf("open %s for write: %e", t, fd);
  800372:	89 44 24 08          	mov    %eax,0x8(%esp)
  800376:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037d:	c7 04 24 6e 38 80 00 	movl   $0x80386e,(%esp)
  800384:	e8 37 08 00 00       	call   800bc0 <cprintf>
				exit();
  800389:	e8 20 07 00 00       	call   800aae <exit>
			}
			if (fd != 1) {
  80038e:	83 ff 01             	cmp    $0x1,%edi
  800391:	0f 84 a6 fe ff ff    	je     80023d <runcmd+0x27>
				dup(fd, 1);
  800397:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80039e:	00 
  80039f:	89 3c 24             	mov    %edi,(%esp)
  8003a2:	e8 71 1d 00 00       	call   802118 <dup>
				close(fd);
  8003a7:	89 3c 24             	mov    %edi,(%esp)
  8003aa:	e8 14 1d 00 00       	call   8020c3 <close>
  8003af:	e9 89 fe ff ff       	jmp    80023d <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003b4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 87 2d 00 00       	call   803149 <pipe>
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	79 15                	jns    8003db <runcmd+0x1c5>
				cprintf("pipe: %e", r);
  8003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ca:	c7 04 24 84 38 80 00 	movl   $0x803884,(%esp)
  8003d1:	e8 ea 07 00 00       	call   800bc0 <cprintf>
				exit();
  8003d6:	e8 d3 06 00 00       	call   800aae <exit>
			}
			if (debug)
  8003db:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8003e2:	74 20                	je     800404 <runcmd+0x1ee>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  8003e4:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8003ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ee:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8003f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f8:	c7 04 24 8d 38 80 00 	movl   $0x80388d,(%esp)
  8003ff:	e8 bc 07 00 00       	call   800bc0 <cprintf>
			if ((r = fork()) < 0) {
  800404:	e8 07 17 00 00       	call   801b10 <fork>
  800409:	89 c7                	mov    %eax,%edi
  80040b:	85 c0                	test   %eax,%eax
  80040d:	79 15                	jns    800424 <runcmd+0x20e>
				cprintf("fork: %e", r);
  80040f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800413:	c7 04 24 9a 38 80 00 	movl   $0x80389a,(%esp)
  80041a:	e8 a1 07 00 00       	call   800bc0 <cprintf>
				exit();
  80041f:	e8 8a 06 00 00       	call   800aae <exit>
			}
			if (r == 0) {
  800424:	85 ff                	test   %edi,%edi
  800426:	75 40                	jne    800468 <runcmd+0x252>
				if (p[0] != 0) {
  800428:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80042e:	85 c0                	test   %eax,%eax
  800430:	74 1e                	je     800450 <runcmd+0x23a>
					dup(p[0], 0);
  800432:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800439:	00 
  80043a:	89 04 24             	mov    %eax,(%esp)
  80043d:	e8 d6 1c 00 00       	call   802118 <dup>
					close(p[0]);
  800442:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800448:	89 04 24             	mov    %eax,(%esp)
  80044b:	e8 73 1c 00 00       	call   8020c3 <close>
				}
				close(p[1]);
  800450:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800456:	89 04 24             	mov    %eax,(%esp)
  800459:	e8 65 1c 00 00       	call   8020c3 <close>

	pipe_child = 0;
	gettoken(s, 0);

again:
	argc = 0;
  80045e:	be 00 00 00 00       	mov    $0x0,%esi
				if (p[0] != 0) {
					dup(p[0], 0);
					close(p[0]);
				}
				close(p[1]);
				goto again;
  800463:	e9 d5 fd ff ff       	jmp    80023d <runcmd+0x27>
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800468:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80046e:	83 f8 01             	cmp    $0x1,%eax
  800471:	74 1e                	je     800491 <runcmd+0x27b>
					dup(p[1], 1);
  800473:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80047a:	00 
  80047b:	89 04 24             	mov    %eax,(%esp)
  80047e:	e8 95 1c 00 00       	call   802118 <dup>
					close(p[1]);
  800483:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800489:	89 04 24             	mov    %eax,(%esp)
  80048c:	e8 32 1c 00 00       	call   8020c3 <close>
				}
				close(p[0]);
  800491:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800497:	89 04 24             	mov    %eax,(%esp)
  80049a:	e8 24 1c 00 00       	call   8020c3 <close>
				goto runit;
  80049f:	eb 25                	jmp    8004c6 <runcmd+0x2b0>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  8004a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a5:	c7 44 24 08 a3 38 80 	movl   $0x8038a3,0x8(%esp)
  8004ac:	00 
  8004ad:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8004b4:	00 
  8004b5:	c7 04 24 bf 38 80 00 	movl   $0x8038bf,(%esp)
  8004bc:	e8 06 06 00 00       	call   800ac7 <_panic>
runcmd(char* s)
{
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
  8004c1:	bf 00 00 00 00       	mov    $0x0,%edi
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004c6:	85 f6                	test   %esi,%esi
  8004c8:	75 1e                	jne    8004e8 <runcmd+0x2d2>
		if (debug)
  8004ca:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8004d1:	0f 84 90 01 00 00    	je     800667 <runcmd+0x451>
			cprintf("EMPTY COMMAND\n");
  8004d7:	c7 04 24 c9 38 80 00 	movl   $0x8038c9,(%esp)
  8004de:	e8 dd 06 00 00       	call   800bc0 <cprintf>
  8004e3:	e9 7f 01 00 00       	jmp    800667 <runcmd+0x451>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  8004e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004eb:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004ee:	74 22                	je     800512 <runcmd+0x2fc>
		argv0buf[0] = '/';
  8004f0:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fb:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  800501:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800507:	89 04 24             	mov    %eax,(%esp)
  80050a:	e8 fc 0d 00 00       	call   80130b <strcpy>
		argv[0] = argv0buf;
  80050f:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  800512:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800519:	00 

	// Print the command.
	if (debug) {
  80051a:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800521:	74 48                	je     80056b <runcmd+0x355>
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800523:	a1 24 64 80 00       	mov    0x806424,%eax
  800528:	8b 40 48             	mov    0x48(%eax),%eax
  80052b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052f:	c7 04 24 d8 38 80 00 	movl   $0x8038d8,(%esp)
  800536:	e8 85 06 00 00       	call   800bc0 <cprintf>
		for (i = 0; argv[i]; i++)
  80053b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	74 1d                	je     80055f <runcmd+0x349>
  800542:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
  800545:	89 44 24 04          	mov    %eax,0x4(%esp)
  800549:	c7 04 24 63 39 80 00 	movl   $0x803963,(%esp)
  800550:	e8 6b 06 00 00       	call   800bc0 <cprintf>
  800555:	83 c3 04             	add    $0x4,%ebx
	argv[argc] = 0;

	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", thisenv->env_id);
		for (i = 0; argv[i]; i++)
  800558:	8b 43 fc             	mov    -0x4(%ebx),%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	75 e6                	jne    800545 <runcmd+0x32f>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  80055f:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  800566:	e8 55 06 00 00       	call   800bc0 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80056b:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80056e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800572:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	e8 e3 22 00 00       	call   802860 <spawn>
  80057d:	89 c3                	mov    %eax,%ebx
  80057f:	85 c0                	test   %eax,%eax
  800581:	0f 89 c3 00 00 00    	jns    80064a <runcmd+0x434>
		cprintf("spawn %s: %e\n", argv[0], r);
  800587:	89 44 24 08          	mov    %eax,0x8(%esp)
  80058b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800592:	c7 04 24 e6 38 80 00 	movl   $0x8038e6,(%esp)
  800599:	e8 22 06 00 00       	call   800bc0 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  80059e:	e8 53 1b 00 00       	call   8020f6 <close_all>
  8005a3:	eb 4c                	jmp    8005f1 <runcmd+0x3db>
	if (r >= 0) {
		if (debug)
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005a5:	a1 24 64 80 00       	mov    0x806424,%eax
  8005aa:	8b 40 48             	mov    0x48(%eax),%eax
  8005ad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005b1:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005bc:	c7 04 24 f4 38 80 00 	movl   $0x8038f4,(%esp)
  8005c3:	e8 f8 05 00 00       	call   800bc0 <cprintf>
		wait(r);
  8005c8:	89 1c 24             	mov    %ebx,(%esp)
  8005cb:	e8 1f 2d 00 00       	call   8032ef <wait>
		if (debug)
  8005d0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005d7:	74 18                	je     8005f1 <runcmd+0x3db>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005d9:	a1 24 64 80 00       	mov    0x806424,%eax
  8005de:	8b 40 48             	mov    0x48(%eax),%eax
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 09 39 80 00 	movl   $0x803909,(%esp)
  8005ec:	e8 cf 05 00 00       	call   800bc0 <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  8005f1:	85 ff                	test   %edi,%edi
  8005f3:	74 4e                	je     800643 <runcmd+0x42d>
		if (debug)
  8005f5:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005fc:	74 1c                	je     80061a <runcmd+0x404>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  8005fe:	a1 24 64 80 00       	mov    0x806424,%eax
  800603:	8b 40 48             	mov    0x48(%eax),%eax
  800606:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80060a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060e:	c7 04 24 1f 39 80 00 	movl   $0x80391f,(%esp)
  800615:	e8 a6 05 00 00       	call   800bc0 <cprintf>
		wait(pipe_child);
  80061a:	89 3c 24             	mov    %edi,(%esp)
  80061d:	e8 cd 2c 00 00       	call   8032ef <wait>
		if (debug)
  800622:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800629:	74 18                	je     800643 <runcmd+0x42d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80062b:	a1 24 64 80 00       	mov    0x806424,%eax
  800630:	8b 40 48             	mov    0x48(%eax),%eax
  800633:	89 44 24 04          	mov    %eax,0x4(%esp)
  800637:	c7 04 24 09 39 80 00 	movl   $0x803909,(%esp)
  80063e:	e8 7d 05 00 00       	call   800bc0 <cprintf>
	}

	// Done!
	exit();
  800643:	e8 66 04 00 00       	call   800aae <exit>
  800648:	eb 1d                	jmp    800667 <runcmd+0x451>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
		cprintf("spawn %s: %e\n", argv[0], r);

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  80064a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800650:	e8 a1 1a 00 00       	call   8020f6 <close_all>
	if (r >= 0) {
		if (debug)
  800655:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80065c:	0f 84 66 ff ff ff    	je     8005c8 <runcmd+0x3b2>
  800662:	e9 3e ff ff ff       	jmp    8005a5 <runcmd+0x38f>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
	}

	// Done!
	exit();
}
  800667:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  80066d:	5b                   	pop    %ebx
  80066e:	5e                   	pop    %esi
  80066f:	5f                   	pop    %edi
  800670:	5d                   	pop    %ebp
  800671:	c3                   	ret    

00800672 <usage>:
}


void
usage(void)
{
  800672:	55                   	push   %ebp
  800673:	89 e5                	mov    %esp,%ebp
  800675:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800678:	c7 04 24 e8 39 80 00 	movl   $0x8039e8,(%esp)
  80067f:	e8 3c 05 00 00       	call   800bc0 <cprintf>
	exit();
  800684:	e8 25 04 00 00       	call   800aae <exit>
}
  800689:	c9                   	leave  
  80068a:	c3                   	ret    

0080068b <umain>:

void
umain(int argc, char **argv)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	57                   	push   %edi
  80068f:	56                   	push   %esi
  800690:	53                   	push   %ebx
  800691:	83 ec 3c             	sub    $0x3c,%esp
  800694:	8b 75 0c             	mov    0xc(%ebp),%esi
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  800697:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80069a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80069e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a2:	8d 45 08             	lea    0x8(%ebp),%eax
  8006a5:	89 04 24             	mov    %eax,(%esp)
  8006a8:	e8 c9 16 00 00       	call   801d76 <argstart>
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
  8006ad:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
umain(int argc, char **argv)
{
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
  8006b4:	bf 3f 00 00 00       	mov    $0x3f,%edi
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006b9:	8d 5d d8             	lea    -0x28(%ebp),%ebx
  8006bc:	eb 32                	jmp    8006f0 <umain+0x65>
		switch (r) {
  8006be:	83 f8 69             	cmp    $0x69,%eax
  8006c1:	74 0f                	je     8006d2 <umain+0x47>
  8006c3:	83 f8 78             	cmp    $0x78,%eax
  8006c6:	74 21                	je     8006e9 <umain+0x5e>
  8006c8:	83 f8 64             	cmp    $0x64,%eax
  8006cb:	75 15                	jne    8006e2 <umain+0x57>
  8006cd:	8d 76 00             	lea    0x0(%esi),%esi
  8006d0:	eb 07                	jmp    8006d9 <umain+0x4e>
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006d2:	bf 01 00 00 00       	mov    $0x1,%edi
  8006d7:	eb 17                	jmp    8006f0 <umain+0x65>
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
		switch (r) {
		case 'd':
			debug++;
  8006d9:	83 05 00 60 80 00 01 	addl   $0x1,0x806000
			break;
  8006e0:	eb 0e                	jmp    8006f0 <umain+0x65>
			break;
		case 'x':
			echocmds = 1;
			break;
		default:
			usage();
  8006e2:	e8 8b ff ff ff       	call   800672 <usage>
  8006e7:	eb 07                	jmp    8006f0 <umain+0x65>
			break;
		case 'i':
			interactive = 1;
			break;
		case 'x':
			echocmds = 1;
  8006e9:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
	while ((r = argnext(&args)) >= 0)
  8006f0:	89 1c 24             	mov    %ebx,(%esp)
  8006f3:	e8 b6 16 00 00       	call   801dae <argnext>
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	79 c2                	jns    8006be <umain+0x33>
  8006fc:	89 fb                	mov    %edi,%ebx
			break;
		default:
			usage();
		}

	if (argc > 2)
  8006fe:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800702:	7e 05                	jle    800709 <umain+0x7e>
		usage();
  800704:	e8 69 ff ff ff       	call   800672 <usage>
	if (argc == 2) {
  800709:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  80070d:	75 72                	jne    800781 <umain+0xf6>
		close(0);
  80070f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800716:	e8 a8 19 00 00       	call   8020c3 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80071b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800722:	00 
  800723:	8b 46 04             	mov    0x4(%esi),%eax
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	e8 68 1f 00 00       	call   802696 <open>
  80072e:	85 c0                	test   %eax,%eax
  800730:	79 27                	jns    800759 <umain+0xce>
			panic("open %s: %e", argv[1], r);
  800732:	89 44 24 10          	mov    %eax,0x10(%esp)
  800736:	8b 46 04             	mov    0x4(%esi),%eax
  800739:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073d:	c7 44 24 08 3f 39 80 	movl   $0x80393f,0x8(%esp)
  800744:	00 
  800745:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  80074c:	00 
  80074d:	c7 04 24 bf 38 80 00 	movl   $0x8038bf,(%esp)
  800754:	e8 6e 03 00 00       	call   800ac7 <_panic>
		assert(r == 0);
  800759:	85 c0                	test   %eax,%eax
  80075b:	74 24                	je     800781 <umain+0xf6>
  80075d:	c7 44 24 0c 4b 39 80 	movl   $0x80394b,0xc(%esp)
  800764:	00 
  800765:	c7 44 24 08 52 39 80 	movl   $0x803952,0x8(%esp)
  80076c:	00 
  80076d:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  800774:	00 
  800775:	c7 04 24 bf 38 80 00 	movl   $0x8038bf,(%esp)
  80077c:	e8 46 03 00 00       	call   800ac7 <_panic>
	}
	if (interactive == '?')
  800781:	83 fb 3f             	cmp    $0x3f,%ebx
  800784:	75 0e                	jne    800794 <umain+0x109>
		interactive = iscons(0);
  800786:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80078d:	e8 1a 02 00 00       	call   8009ac <iscons>
  800792:	89 c7                	mov    %eax,%edi

	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  800794:	85 ff                	test   %edi,%edi
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	ba 3c 39 80 00       	mov    $0x80393c,%edx
  8007a0:	0f 45 c2             	cmovne %edx,%eax
  8007a3:	89 04 24             	mov    %eax,(%esp)
  8007a6:	e8 15 0a 00 00       	call   8011c0 <readline>
  8007ab:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  8007ad:	85 c0                	test   %eax,%eax
  8007af:	75 1a                	jne    8007cb <umain+0x140>
			if (debug)
  8007b1:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007b8:	74 0c                	je     8007c6 <umain+0x13b>
				cprintf("EXITING\n");
  8007ba:	c7 04 24 67 39 80 00 	movl   $0x803967,(%esp)
  8007c1:	e8 fa 03 00 00       	call   800bc0 <cprintf>
			exit();	// end of file
  8007c6:	e8 e3 02 00 00       	call   800aae <exit>
		}
		if (debug)
  8007cb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007d2:	74 10                	je     8007e4 <umain+0x159>
			cprintf("LINE: %s\n", buf);
  8007d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d8:	c7 04 24 70 39 80 00 	movl   $0x803970,(%esp)
  8007df:	e8 dc 03 00 00       	call   800bc0 <cprintf>
		if (buf[0] == '#')
  8007e4:	80 3b 23             	cmpb   $0x23,(%ebx)
  8007e7:	74 ab                	je     800794 <umain+0x109>
			continue;
		if (echocmds)
  8007e9:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ed:	74 10                	je     8007ff <umain+0x174>
			printf("# %s\n", buf);
  8007ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f3:	c7 04 24 7a 39 80 00 	movl   $0x80397a,(%esp)
  8007fa:	e8 30 20 00 00       	call   80282f <printf>
		if (debug)
  8007ff:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800806:	74 0c                	je     800814 <umain+0x189>
			cprintf("BEFORE FORK\n");
  800808:	c7 04 24 80 39 80 00 	movl   $0x803980,(%esp)
  80080f:	e8 ac 03 00 00       	call   800bc0 <cprintf>
		if ((r = fork()) < 0)
  800814:	e8 f7 12 00 00       	call   801b10 <fork>
  800819:	89 c6                	mov    %eax,%esi
  80081b:	85 c0                	test   %eax,%eax
  80081d:	79 20                	jns    80083f <umain+0x1b4>
			panic("fork: %e", r);
  80081f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800823:	c7 44 24 08 9a 38 80 	movl   $0x80389a,0x8(%esp)
  80082a:	00 
  80082b:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  800832:	00 
  800833:	c7 04 24 bf 38 80 00 	movl   $0x8038bf,(%esp)
  80083a:	e8 88 02 00 00       	call   800ac7 <_panic>
		if (debug)
  80083f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800846:	74 10                	je     800858 <umain+0x1cd>
			cprintf("FORK: %d\n", r);
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 8d 39 80 00 	movl   $0x80398d,(%esp)
  800853:	e8 68 03 00 00       	call   800bc0 <cprintf>
		if (r == 0) {
  800858:	85 f6                	test   %esi,%esi
  80085a:	75 12                	jne    80086e <umain+0x1e3>
			runcmd(buf);
  80085c:	89 1c 24             	mov    %ebx,(%esp)
  80085f:	e8 b2 f9 ff ff       	call   800216 <runcmd>
			exit();
  800864:	e8 45 02 00 00       	call   800aae <exit>
  800869:	e9 26 ff ff ff       	jmp    800794 <umain+0x109>
		} else
			wait(r);
  80086e:	89 34 24             	mov    %esi,(%esp)
  800871:	e8 79 2a 00 00       	call   8032ef <wait>
  800876:	e9 19 ff ff ff       	jmp    800794 <umain+0x109>
  80087b:	66 90                	xchg   %ax,%ax
  80087d:	66 90                	xchg   %ax,%ax
  80087f:	90                   	nop

00800880 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800890:	c7 44 24 04 09 3a 80 	movl   $0x803a09,0x4(%esp)
  800897:	00 
  800898:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089b:	89 04 24             	mov    %eax,(%esp)
  80089e:	e8 68 0a 00 00       	call   80130b <strcpy>
	return 0;
}
  8008a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a8:	c9                   	leave  
  8008a9:	c3                   	ret    

008008aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	57                   	push   %edi
  8008ae:	56                   	push   %esi
  8008af:	53                   	push   %ebx
  8008b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8008ba:	74 4a                	je     800906 <devcons_write+0x5c>
  8008bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008cc:	8b 75 10             	mov    0x10(%ebp),%esi
  8008cf:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8008d1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8008d4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8008d9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8008dc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8008e0:	03 45 0c             	add    0xc(%ebp),%eax
  8008e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e7:	89 3c 24             	mov    %edi,(%esp)
  8008ea:	e8 17 0c 00 00       	call   801506 <memmove>
		sys_cputs(buf, m);
  8008ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008f3:	89 3c 24             	mov    %edi,(%esp)
  8008f6:	e8 f1 0d 00 00       	call   8016ec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8008fb:	01 f3                	add    %esi,%ebx
  8008fd:	89 d8                	mov    %ebx,%eax
  8008ff:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800902:	72 c8                	jb     8008cc <devcons_write+0x22>
  800904:	eb 05                	jmp    80090b <devcons_write+0x61>
  800906:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80090b:	89 d8                	mov    %ebx,%eax
  80090d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  800913:	5b                   	pop    %ebx
  800914:	5e                   	pop    %esi
  800915:	5f                   	pop    %edi
  800916:	5d                   	pop    %ebp
  800917:	c3                   	ret    

00800918 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80091e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  800923:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800927:	75 07                	jne    800930 <devcons_read+0x18>
  800929:	eb 28                	jmp    800953 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80092b:	e8 6a 0e 00 00       	call   80179a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  800930:	e8 d5 0d 00 00       	call   80170a <sys_cgetc>
  800935:	85 c0                	test   %eax,%eax
  800937:	74 f2                	je     80092b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  800939:	85 c0                	test   %eax,%eax
  80093b:	78 16                	js     800953 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80093d:	83 f8 04             	cmp    $0x4,%eax
  800940:	74 0c                	je     80094e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  800942:	8b 55 0c             	mov    0xc(%ebp),%edx
  800945:	88 02                	mov    %al,(%edx)
	return 1;
  800947:	b8 01 00 00 00       	mov    $0x1,%eax
  80094c:	eb 05                	jmp    800953 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  800953:	c9                   	leave  
  800954:	c3                   	ret    

00800955 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  800961:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800968:	00 
  800969:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096c:	89 04 24             	mov    %eax,(%esp)
  80096f:	e8 78 0d 00 00       	call   8016ec <sys_cputs>
}
  800974:	c9                   	leave  
  800975:	c3                   	ret    

00800976 <getchar>:

int
getchar(void)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80097c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800983:	00 
  800984:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80098b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800992:	e8 8f 18 00 00       	call   802226 <read>
	if (r < 0)
  800997:	85 c0                	test   %eax,%eax
  800999:	78 0f                	js     8009aa <getchar+0x34>
		return r;
	if (r < 1)
  80099b:	85 c0                	test   %eax,%eax
  80099d:	7e 06                	jle    8009a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80099f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8009a3:	eb 05                	jmp    8009aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8009a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	89 04 24             	mov    %eax,(%esp)
  8009bf:	e8 b7 15 00 00       	call   801f7b <fd_lookup>
  8009c4:	85 c0                	test   %eax,%eax
  8009c6:	78 11                	js     8009d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8009c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cb:	8b 15 00 50 80 00    	mov    0x805000,%edx
  8009d1:	39 10                	cmp    %edx,(%eax)
  8009d3:	0f 94 c0             	sete   %al
  8009d6:	0f b6 c0             	movzbl %al,%eax
}
  8009d9:	c9                   	leave  
  8009da:	c3                   	ret    

008009db <opencons>:

int
opencons(void)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009e4:	89 04 24             	mov    %eax,(%esp)
  8009e7:	e8 1b 15 00 00       	call   801f07 <fd_alloc>
		return r;
  8009ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009ee:	85 c0                	test   %eax,%eax
  8009f0:	78 40                	js     800a32 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009f9:	00 
  8009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a08:	e8 ac 0d 00 00       	call   8017b9 <sys_page_alloc>
		return r;
  800a0d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800a0f:	85 c0                	test   %eax,%eax
  800a11:	78 1f                	js     800a32 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800a13:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a21:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a28:	89 04 24             	mov    %eax,(%esp)
  800a2b:	e8 b0 14 00 00       	call   801ee0 <fd2num>
  800a30:	89 c2                	mov    %eax,%edx
}
  800a32:	89 d0                	mov    %edx,%eax
  800a34:	c9                   	leave  
  800a35:	c3                   	ret    

00800a36 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	56                   	push   %esi
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 10             	sub    $0x10,%esp
  800a3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a41:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800a44:	e8 32 0d 00 00       	call   80177b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800a49:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800a4f:	39 c2                	cmp    %eax,%edx
  800a51:	74 17                	je     800a6a <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800a53:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800a58:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800a5b:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800a61:	8b 49 40             	mov    0x40(%ecx),%ecx
  800a64:	39 c1                	cmp    %eax,%ecx
  800a66:	75 18                	jne    800a80 <libmain+0x4a>
  800a68:	eb 05                	jmp    800a6f <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800a6f:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800a72:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800a78:	89 15 24 64 80 00    	mov    %edx,0x806424
			break;
  800a7e:	eb 0b                	jmp    800a8b <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800a80:	83 c2 01             	add    $0x1,%edx
  800a83:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800a89:	75 cd                	jne    800a58 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a8b:	85 db                	test   %ebx,%ebx
  800a8d:	7e 07                	jle    800a96 <libmain+0x60>
		binaryname = argv[0];
  800a8f:	8b 06                	mov    (%esi),%eax
  800a91:	a3 1c 50 80 00       	mov    %eax,0x80501c

	// call user main routine
	umain(argc, argv);
  800a96:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a9a:	89 1c 24             	mov    %ebx,(%esp)
  800a9d:	e8 e9 fb ff ff       	call   80068b <umain>

	// exit gracefully
	exit();
  800aa2:	e8 07 00 00 00       	call   800aae <exit>
}
  800aa7:	83 c4 10             	add    $0x10,%esp
  800aaa:	5b                   	pop    %ebx
  800aab:	5e                   	pop    %esi
  800aac:	5d                   	pop    %ebp
  800aad:	c3                   	ret    

00800aae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800ab4:	e8 3d 16 00 00       	call   8020f6 <close_all>
	sys_env_destroy(0);
  800ab9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ac0:	e8 64 0c 00 00       	call   801729 <sys_env_destroy>
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    

00800ac7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	56                   	push   %esi
  800acb:	53                   	push   %ebx
  800acc:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800acf:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800ad2:	8b 35 1c 50 80 00    	mov    0x80501c,%esi
  800ad8:	e8 9e 0c 00 00       	call   80177b <sys_getenvid>
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae0:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ae4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800aeb:	89 74 24 08          	mov    %esi,0x8(%esp)
  800aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af3:	c7 04 24 20 3a 80 00 	movl   $0x803a20,(%esp)
  800afa:	e8 c1 00 00 00       	call   800bc0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b03:	8b 45 10             	mov    0x10(%ebp),%eax
  800b06:	89 04 24             	mov    %eax,(%esp)
  800b09:	e8 51 00 00 00       	call   800b5f <vcprintf>
	cprintf("\n");
  800b0e:	c7 04 24 20 38 80 00 	movl   $0x803820,(%esp)
  800b15:	e8 a6 00 00 00       	call   800bc0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b1a:	cc                   	int3   
  800b1b:	eb fd                	jmp    800b1a <_panic+0x53>

00800b1d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b1d:	55                   	push   %ebp
  800b1e:	89 e5                	mov    %esp,%ebp
  800b20:	53                   	push   %ebx
  800b21:	83 ec 14             	sub    $0x14,%esp
  800b24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b27:	8b 13                	mov    (%ebx),%edx
  800b29:	8d 42 01             	lea    0x1(%edx),%eax
  800b2c:	89 03                	mov    %eax,(%ebx)
  800b2e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b31:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b35:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b3a:	75 19                	jne    800b55 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800b3c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800b43:	00 
  800b44:	8d 43 08             	lea    0x8(%ebx),%eax
  800b47:	89 04 24             	mov    %eax,(%esp)
  800b4a:	e8 9d 0b 00 00       	call   8016ec <sys_cputs>
		b->idx = 0;
  800b4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800b55:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800b59:	83 c4 14             	add    $0x14,%esp
  800b5c:	5b                   	pop    %ebx
  800b5d:	5d                   	pop    %ebp
  800b5e:	c3                   	ret    

00800b5f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b68:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b6f:	00 00 00 
	b.cnt = 0;
  800b72:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b79:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b8a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b94:	c7 04 24 1d 0b 80 00 	movl   $0x800b1d,(%esp)
  800b9b:	e8 b4 01 00 00       	call   800d54 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800ba0:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800baa:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800bb0:	89 04 24             	mov    %eax,(%esp)
  800bb3:	e8 34 0b 00 00       	call   8016ec <sys_cputs>

	return b.cnt;
}
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	89 04 24             	mov    %eax,(%esp)
  800bd3:	e8 87 ff ff ff       	call   800b5f <vcprintf>
	va_end(ap);

	return cnt;
}
  800bd8:	c9                   	leave  
  800bd9:	c3                   	ret    
  800bda:	66 90                	xchg   %ax,%ax
  800bdc:	66 90                	xchg   %ax,%ax
  800bde:	66 90                	xchg   %ax,%ax

00800be0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	57                   	push   %edi
  800be4:	56                   	push   %esi
  800be5:	53                   	push   %ebx
  800be6:	83 ec 3c             	sub    $0x3c,%esp
  800be9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800bec:	89 d7                	mov    %edx,%edi
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800bf4:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bf7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800bfa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c05:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c08:	39 f1                	cmp    %esi,%ecx
  800c0a:	72 14                	jb     800c20 <printnum+0x40>
  800c0c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800c0f:	76 0f                	jbe    800c20 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	8d 70 ff             	lea    -0x1(%eax),%esi
  800c17:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800c1a:	85 f6                	test   %esi,%esi
  800c1c:	7f 60                	jg     800c7e <printnum+0x9e>
  800c1e:	eb 72                	jmp    800c92 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c23:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800c27:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800c2a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  800c2d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c31:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c35:	8b 44 24 08          	mov    0x8(%esp),%eax
  800c39:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800c3d:	89 c3                	mov    %eax,%ebx
  800c3f:	89 d6                	mov    %edx,%esi
  800c41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c44:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c47:	89 54 24 08          	mov    %edx,0x8(%esp)
  800c4b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c52:	89 04 24             	mov    %eax,(%esp)
  800c55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c5c:	e8 0f 29 00 00       	call   803570 <__udivdi3>
  800c61:	89 d9                	mov    %ebx,%ecx
  800c63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c67:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c6b:	89 04 24             	mov    %eax,(%esp)
  800c6e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c72:	89 fa                	mov    %edi,%edx
  800c74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c77:	e8 64 ff ff ff       	call   800be0 <printnum>
  800c7c:	eb 14                	jmp    800c92 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c7e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c82:	8b 45 18             	mov    0x18(%ebp),%eax
  800c85:	89 04 24             	mov    %eax,(%esp)
  800c88:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c8a:	83 ee 01             	sub    $0x1,%esi
  800c8d:	75 ef                	jne    800c7e <printnum+0x9e>
  800c8f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c92:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c96:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c9a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c9d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800ca0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ca4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 04 24             	mov    %eax,(%esp)
  800cae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800cb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb5:	e8 e6 29 00 00       	call   8036a0 <__umoddi3>
  800cba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cbe:	0f be 80 43 3a 80 00 	movsbl 0x803a43(%eax),%eax
  800cc5:	89 04 24             	mov    %eax,(%esp)
  800cc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
}
  800ccd:	83 c4 3c             	add    $0x3c,%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd8:	83 fa 01             	cmp    $0x1,%edx
  800cdb:	7e 0e                	jle    800ceb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 10                	mov    (%eax),%edx
  800cdf:	8d 4a 08             	lea    0x8(%edx),%ecx
  800ce2:	89 08                	mov    %ecx,(%eax)
  800ce4:	8b 02                	mov    (%edx),%eax
  800ce6:	8b 52 04             	mov    0x4(%edx),%edx
  800ce9:	eb 22                	jmp    800d0d <getuint+0x38>
	else if (lflag)
  800ceb:	85 d2                	test   %edx,%edx
  800ced:	74 10                	je     800cff <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800cef:	8b 10                	mov    (%eax),%edx
  800cf1:	8d 4a 04             	lea    0x4(%edx),%ecx
  800cf4:	89 08                	mov    %ecx,(%eax)
  800cf6:	8b 02                	mov    (%edx),%eax
  800cf8:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfd:	eb 0e                	jmp    800d0d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800cff:	8b 10                	mov    (%eax),%edx
  800d01:	8d 4a 04             	lea    0x4(%edx),%ecx
  800d04:	89 08                	mov    %ecx,(%eax)
  800d06:	8b 02                	mov    (%edx),%eax
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d15:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 10                	mov    (%eax),%edx
  800d1b:	3b 50 04             	cmp    0x4(%eax),%edx
  800d1e:	73 0a                	jae    800d2a <sprintputch+0x1b>
		*b->buf++ = ch;
  800d20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d23:	89 08                	mov    %ecx,(%eax)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	88 02                	mov    %al,(%edx)
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d32:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800d35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d39:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	89 04 24             	mov    %eax,(%esp)
  800d4d:	e8 02 00 00 00       	call   800d54 <vprintfmt>
	va_end(ap);
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 3c             	sub    $0x3c,%esp
  800d5d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d63:	eb 18                	jmp    800d7d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800d65:	85 c0                	test   %eax,%eax
  800d67:	0f 84 c3 03 00 00    	je     801130 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  800d6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d71:	89 04 24             	mov    %eax,(%esp)
  800d74:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d77:	89 f3                	mov    %esi,%ebx
  800d79:	eb 02                	jmp    800d7d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d7b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d7d:	8d 73 01             	lea    0x1(%ebx),%esi
  800d80:	0f b6 03             	movzbl (%ebx),%eax
  800d83:	83 f8 25             	cmp    $0x25,%eax
  800d86:	75 dd                	jne    800d65 <vprintfmt+0x11>
  800d88:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  800d8c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800d93:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800d9a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	eb 1d                	jmp    800dc5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800da8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800daa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  800dae:	eb 15                	jmp    800dc5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800db2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800db6:	eb 0d                	jmp    800dc5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800db8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dbb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dbe:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dc5:	8d 5e 01             	lea    0x1(%esi),%ebx
  800dc8:	0f b6 06             	movzbl (%esi),%eax
  800dcb:	0f b6 c8             	movzbl %al,%ecx
  800dce:	83 e8 23             	sub    $0x23,%eax
  800dd1:	3c 55                	cmp    $0x55,%al
  800dd3:	0f 87 2f 03 00 00    	ja     801108 <vprintfmt+0x3b4>
  800dd9:	0f b6 c0             	movzbl %al,%eax
  800ddc:	ff 24 85 80 3b 80 00 	jmp    *0x803b80(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800de3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800de6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800de9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800ded:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800df0:	83 f9 09             	cmp    $0x9,%ecx
  800df3:	77 50                	ja     800e45 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800df5:	89 de                	mov    %ebx,%esi
  800df7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dfa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800dfd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800e00:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800e04:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800e07:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800e0a:	83 fb 09             	cmp    $0x9,%ebx
  800e0d:	76 eb                	jbe    800dfa <vprintfmt+0xa6>
  800e0f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800e12:	eb 33                	jmp    800e47 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e14:	8b 45 14             	mov    0x14(%ebp),%eax
  800e17:	8d 48 04             	lea    0x4(%eax),%ecx
  800e1a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800e1d:	8b 00                	mov    (%eax),%eax
  800e1f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e22:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800e24:	eb 21                	jmp    800e47 <vprintfmt+0xf3>
  800e26:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800e29:	85 c9                	test   %ecx,%ecx
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e30:	0f 49 c1             	cmovns %ecx,%eax
  800e33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	eb 8b                	jmp    800dc5 <vprintfmt+0x71>
  800e3a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800e3c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800e43:	eb 80                	jmp    800dc5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e45:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e4b:	0f 89 74 ff ff ff    	jns    800dc5 <vprintfmt+0x71>
  800e51:	e9 62 ff ff ff       	jmp    800db8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e56:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e59:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800e5b:	e9 65 ff ff ff       	jmp    800dc5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e60:	8b 45 14             	mov    0x14(%ebp),%eax
  800e63:	8d 50 04             	lea    0x4(%eax),%edx
  800e66:	89 55 14             	mov    %edx,0x14(%ebp)
  800e69:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e6d:	8b 00                	mov    (%eax),%eax
  800e6f:	89 04 24             	mov    %eax,(%esp)
  800e72:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e75:	e9 03 ff ff ff       	jmp    800d7d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e7a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7d:	8d 50 04             	lea    0x4(%eax),%edx
  800e80:	89 55 14             	mov    %edx,0x14(%ebp)
  800e83:	8b 00                	mov    (%eax),%eax
  800e85:	99                   	cltd   
  800e86:	31 d0                	xor    %edx,%eax
  800e88:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800e8a:	83 f8 0f             	cmp    $0xf,%eax
  800e8d:	7f 0b                	jg     800e9a <vprintfmt+0x146>
  800e8f:	8b 14 85 e0 3c 80 00 	mov    0x803ce0(,%eax,4),%edx
  800e96:	85 d2                	test   %edx,%edx
  800e98:	75 20                	jne    800eba <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  800e9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e9e:	c7 44 24 08 5b 3a 80 	movl   $0x803a5b,0x8(%esp)
  800ea5:	00 
  800ea6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 04 24             	mov    %eax,(%esp)
  800eb0:	e8 77 fe ff ff       	call   800d2c <printfmt>
  800eb5:	e9 c3 fe ff ff       	jmp    800d7d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  800eba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ebe:	c7 44 24 08 64 39 80 	movl   $0x803964,0x8(%esp)
  800ec5:	00 
  800ec6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 04 24             	mov    %eax,(%esp)
  800ed0:	e8 57 fe ff ff       	call   800d2c <printfmt>
  800ed5:	e9 a3 fe ff ff       	jmp    800d7d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eda:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800edd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ee0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee3:	8d 50 04             	lea    0x4(%eax),%edx
  800ee6:	89 55 14             	mov    %edx,0x14(%ebp)
  800ee9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	ba 54 3a 80 00       	mov    $0x803a54,%edx
  800ef2:	0f 45 d0             	cmovne %eax,%edx
  800ef5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800ef8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  800efc:	74 04                	je     800f02 <vprintfmt+0x1ae>
  800efe:	85 f6                	test   %esi,%esi
  800f00:	7f 19                	jg     800f1b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f02:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f05:	8d 70 01             	lea    0x1(%eax),%esi
  800f08:	0f b6 10             	movzbl (%eax),%edx
  800f0b:	0f be c2             	movsbl %dl,%eax
  800f0e:	85 c0                	test   %eax,%eax
  800f10:	0f 85 95 00 00 00    	jne    800fab <vprintfmt+0x257>
  800f16:	e9 85 00 00 00       	jmp    800fa0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f1f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f22:	89 04 24             	mov    %eax,(%esp)
  800f25:	e8 a8 03 00 00       	call   8012d2 <strnlen>
  800f2a:	29 c6                	sub    %eax,%esi
  800f2c:	89 f0                	mov    %esi,%eax
  800f2e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800f31:	85 f6                	test   %esi,%esi
  800f33:	7e cd                	jle    800f02 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800f35:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800f39:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800f3c:	89 c3                	mov    %eax,%ebx
  800f3e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f42:	89 34 24             	mov    %esi,(%esp)
  800f45:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f48:	83 eb 01             	sub    $0x1,%ebx
  800f4b:	75 f1                	jne    800f3e <vprintfmt+0x1ea>
  800f4d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800f50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f53:	eb ad                	jmp    800f02 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800f55:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f59:	74 1e                	je     800f79 <vprintfmt+0x225>
  800f5b:	0f be d2             	movsbl %dl,%edx
  800f5e:	83 ea 20             	sub    $0x20,%edx
  800f61:	83 fa 5e             	cmp    $0x5e,%edx
  800f64:	76 13                	jbe    800f79 <vprintfmt+0x225>
					putch('?', putdat);
  800f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f69:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f6d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800f74:	ff 55 08             	call   *0x8(%ebp)
  800f77:	eb 0d                	jmp    800f86 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f80:	89 04 24             	mov    %eax,(%esp)
  800f83:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f86:	83 ef 01             	sub    $0x1,%edi
  800f89:	83 c6 01             	add    $0x1,%esi
  800f8c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800f90:	0f be c2             	movsbl %dl,%eax
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 20                	jne    800fb7 <vprintfmt+0x263>
  800f97:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800f9a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fa0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fa4:	7f 25                	jg     800fcb <vprintfmt+0x277>
  800fa6:	e9 d2 fd ff ff       	jmp    800d7d <vprintfmt+0x29>
  800fab:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800fae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800fb1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fb4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb7:	85 db                	test   %ebx,%ebx
  800fb9:	78 9a                	js     800f55 <vprintfmt+0x201>
  800fbb:	83 eb 01             	sub    $0x1,%ebx
  800fbe:	79 95                	jns    800f55 <vprintfmt+0x201>
  800fc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800fc3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc9:	eb d5                	jmp    800fa0 <vprintfmt+0x24c>
  800fcb:	8b 75 08             	mov    0x8(%ebp),%esi
  800fce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800fd1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800fd4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fd8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800fdf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe1:	83 eb 01             	sub    $0x1,%ebx
  800fe4:	75 ee                	jne    800fd4 <vprintfmt+0x280>
  800fe6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe9:	e9 8f fd ff ff       	jmp    800d7d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800fee:	83 fa 01             	cmp    $0x1,%edx
  800ff1:	7e 16                	jle    801009 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800ff3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ff6:	8d 50 08             	lea    0x8(%eax),%edx
  800ff9:	89 55 14             	mov    %edx,0x14(%ebp)
  800ffc:	8b 50 04             	mov    0x4(%eax),%edx
  800fff:	8b 00                	mov    (%eax),%eax
  801001:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801004:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801007:	eb 32                	jmp    80103b <vprintfmt+0x2e7>
	else if (lflag)
  801009:	85 d2                	test   %edx,%edx
  80100b:	74 18                	je     801025 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80100d:	8b 45 14             	mov    0x14(%ebp),%eax
  801010:	8d 50 04             	lea    0x4(%eax),%edx
  801013:	89 55 14             	mov    %edx,0x14(%ebp)
  801016:	8b 30                	mov    (%eax),%esi
  801018:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	c1 f8 1f             	sar    $0x1f,%eax
  801020:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801023:	eb 16                	jmp    80103b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8d 50 04             	lea    0x4(%eax),%edx
  80102b:	89 55 14             	mov    %edx,0x14(%ebp)
  80102e:	8b 30                	mov    (%eax),%esi
  801030:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801033:	89 f0                	mov    %esi,%eax
  801035:	c1 f8 1f             	sar    $0x1f,%eax
  801038:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80103b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80103e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801041:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801046:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80104a:	0f 89 80 00 00 00    	jns    8010d0 <vprintfmt+0x37c>
				putch('-', putdat);
  801050:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801054:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80105b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80105e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801061:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801064:	f7 d8                	neg    %eax
  801066:	83 d2 00             	adc    $0x0,%edx
  801069:	f7 da                	neg    %edx
			}
			base = 10;
  80106b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801070:	eb 5e                	jmp    8010d0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801072:	8d 45 14             	lea    0x14(%ebp),%eax
  801075:	e8 5b fc ff ff       	call   800cd5 <getuint>
			base = 10;
  80107a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80107f:	eb 4f                	jmp    8010d0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801081:	8d 45 14             	lea    0x14(%ebp),%eax
  801084:	e8 4c fc ff ff       	call   800cd5 <getuint>
			base = 8;
  801089:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80108e:	eb 40                	jmp    8010d0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801090:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801094:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80109b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80109e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010a2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8010a9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8010ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8010af:	8d 50 04             	lea    0x4(%eax),%edx
  8010b2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b5:	8b 00                	mov    (%eax),%eax
  8010b7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8010bc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8010c1:	eb 0d                	jmp    8010d0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8010c6:	e8 0a fc ff ff       	call   800cd5 <getuint>
			base = 16;
  8010cb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010d0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8010d4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8010d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8010db:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010e3:	89 04 24             	mov    %eax,(%esp)
  8010e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010ea:	89 fa                	mov    %edi,%edx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	e8 ec fa ff ff       	call   800be0 <printnum>
			break;
  8010f4:	e9 84 fc ff ff       	jmp    800d7d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010fd:	89 0c 24             	mov    %ecx,(%esp)
  801100:	ff 55 08             	call   *0x8(%ebp)
			break;
  801103:	e9 75 fc ff ff       	jmp    800d7d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801108:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80110c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801113:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801116:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80111a:	0f 84 5b fc ff ff    	je     800d7b <vprintfmt+0x27>
  801120:	89 f3                	mov    %esi,%ebx
  801122:	83 eb 01             	sub    $0x1,%ebx
  801125:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801129:	75 f7                	jne    801122 <vprintfmt+0x3ce>
  80112b:	e9 4d fc ff ff       	jmp    800d7d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801130:	83 c4 3c             	add    $0x3c,%esp
  801133:	5b                   	pop    %ebx
  801134:	5e                   	pop    %esi
  801135:	5f                   	pop    %edi
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 28             	sub    $0x28,%esp
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801144:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801147:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80114b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80114e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801155:	85 c0                	test   %eax,%eax
  801157:	74 30                	je     801189 <vsnprintf+0x51>
  801159:	85 d2                	test   %edx,%edx
  80115b:	7e 2c                	jle    801189 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80115d:	8b 45 14             	mov    0x14(%ebp),%eax
  801160:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	89 44 24 08          	mov    %eax,0x8(%esp)
  80116b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80116e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801172:	c7 04 24 0f 0d 80 00 	movl   $0x800d0f,(%esp)
  801179:	e8 d6 fb ff ff       	call   800d54 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80117e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801181:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801187:	eb 05                	jmp    80118e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80118e:	c9                   	leave  
  80118f:	c3                   	ret    

00801190 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801196:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801199:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80119d:	8b 45 10             	mov    0x10(%ebp),%eax
  8011a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	89 04 24             	mov    %eax,(%esp)
  8011b1:	e8 82 ff ff ff       	call   801138 <vsnprintf>
	va_end(ap);

	return rc;
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    
  8011b8:	66 90                	xchg   %ax,%ax
  8011ba:	66 90                	xchg   %ax,%ax
  8011bc:	66 90                	xchg   %ax,%ax
  8011be:	66 90                	xchg   %ax,%ax

008011c0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	57                   	push   %edi
  8011c4:	56                   	push   %esi
  8011c5:	53                   	push   %ebx
  8011c6:	83 ec 1c             	sub    $0x1c,%esp
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	74 18                	je     8011e8 <readline+0x28>
		fprintf(1, "%s", prompt);
  8011d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d4:	c7 44 24 04 64 39 80 	movl   $0x803964,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011e3:	e8 26 16 00 00       	call   80280e <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  8011e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011ef:	e8 b8 f7 ff ff       	call   8009ac <iscons>
  8011f4:	89 c7                	mov    %eax,%edi
#else
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
  8011f6:	be 00 00 00 00       	mov    $0x0,%esi
	echoing = iscons(0);
	while (1) {
		c = getchar();
  8011fb:	e8 76 f7 ff ff       	call   800976 <getchar>
  801200:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801202:	85 c0                	test   %eax,%eax
  801204:	79 25                	jns    80122b <readline+0x6b>
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
	i = 0;
	echoing = iscons(0);
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  80120b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80120e:	0f 84 88 00 00 00    	je     80129c <readline+0xdc>
				cprintf("read error: %e\n", c);
  801214:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801218:	c7 04 24 3f 3d 80 00 	movl   $0x803d3f,(%esp)
  80121f:	e8 9c f9 ff ff       	call   800bc0 <cprintf>
			return NULL;
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	eb 71                	jmp    80129c <readline+0xdc>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80122b:	83 f8 7f             	cmp    $0x7f,%eax
  80122e:	74 05                	je     801235 <readline+0x75>
  801230:	83 f8 08             	cmp    $0x8,%eax
  801233:	75 19                	jne    80124e <readline+0x8e>
  801235:	85 f6                	test   %esi,%esi
  801237:	7e 15                	jle    80124e <readline+0x8e>
			if (echoing)
  801239:	85 ff                	test   %edi,%edi
  80123b:	74 0c                	je     801249 <readline+0x89>
				cputchar('\b');
  80123d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  801244:	e8 0c f7 ff ff       	call   800955 <cputchar>
			i--;
  801249:	83 ee 01             	sub    $0x1,%esi
  80124c:	eb ad                	jmp    8011fb <readline+0x3b>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80124e:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801254:	7f 1c                	jg     801272 <readline+0xb2>
  801256:	83 fb 1f             	cmp    $0x1f,%ebx
  801259:	7e 17                	jle    801272 <readline+0xb2>
			if (echoing)
  80125b:	85 ff                	test   %edi,%edi
  80125d:	74 08                	je     801267 <readline+0xa7>
				cputchar(c);
  80125f:	89 1c 24             	mov    %ebx,(%esp)
  801262:	e8 ee f6 ff ff       	call   800955 <cputchar>
			buf[i++] = c;
  801267:	88 9e 20 60 80 00    	mov    %bl,0x806020(%esi)
  80126d:	8d 76 01             	lea    0x1(%esi),%esi
  801270:	eb 89                	jmp    8011fb <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801272:	83 fb 0d             	cmp    $0xd,%ebx
  801275:	74 09                	je     801280 <readline+0xc0>
  801277:	83 fb 0a             	cmp    $0xa,%ebx
  80127a:	0f 85 7b ff ff ff    	jne    8011fb <readline+0x3b>
			if (echoing)
  801280:	85 ff                	test   %edi,%edi
  801282:	74 0c                	je     801290 <readline+0xd0>
				cputchar('\n');
  801284:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80128b:	e8 c5 f6 ff ff       	call   800955 <cputchar>
			buf[i] = 0;
  801290:	c6 86 20 60 80 00 00 	movb   $0x0,0x806020(%esi)
			return buf;
  801297:	b8 20 60 80 00       	mov    $0x806020,%eax
		}
	}
}
  80129c:	83 c4 1c             	add    $0x1c,%esp
  80129f:	5b                   	pop    %ebx
  8012a0:	5e                   	pop    %esi
  8012a1:	5f                   	pop    %edi
  8012a2:	5d                   	pop    %ebp
  8012a3:	c3                   	ret    
  8012a4:	66 90                	xchg   %ax,%ax
  8012a6:	66 90                	xchg   %ax,%ax
  8012a8:	66 90                	xchg   %ax,%ax
  8012aa:	66 90                	xchg   %ax,%ax
  8012ac:	66 90                	xchg   %ax,%ax
  8012ae:	66 90                	xchg   %ax,%ax

008012b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012b6:	80 3a 00             	cmpb   $0x0,(%edx)
  8012b9:	74 10                	je     8012cb <strlen+0x1b>
  8012bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8012c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012c7:	75 f7                	jne    8012c0 <strlen+0x10>
  8012c9:	eb 05                	jmp    8012d0 <strlen+0x20>
  8012cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8012d0:	5d                   	pop    %ebp
  8012d1:	c3                   	ret    

008012d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	53                   	push   %ebx
  8012d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012dc:	85 c9                	test   %ecx,%ecx
  8012de:	74 1c                	je     8012fc <strnlen+0x2a>
  8012e0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8012e3:	74 1e                	je     801303 <strnlen+0x31>
  8012e5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8012ea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012ec:	39 ca                	cmp    %ecx,%edx
  8012ee:	74 18                	je     801308 <strnlen+0x36>
  8012f0:	83 c2 01             	add    $0x1,%edx
  8012f3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8012f8:	75 f0                	jne    8012ea <strnlen+0x18>
  8012fa:	eb 0c                	jmp    801308 <strnlen+0x36>
  8012fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801301:	eb 05                	jmp    801308 <strnlen+0x36>
  801303:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801308:	5b                   	pop    %ebx
  801309:	5d                   	pop    %ebp
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	53                   	push   %ebx
  80130f:	8b 45 08             	mov    0x8(%ebp),%eax
  801312:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801315:	89 c2                	mov    %eax,%edx
  801317:	83 c2 01             	add    $0x1,%edx
  80131a:	83 c1 01             	add    $0x1,%ecx
  80131d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801321:	88 5a ff             	mov    %bl,-0x1(%edx)
  801324:	84 db                	test   %bl,%bl
  801326:	75 ef                	jne    801317 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801328:	5b                   	pop    %ebx
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	53                   	push   %ebx
  80132f:	83 ec 08             	sub    $0x8,%esp
  801332:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801335:	89 1c 24             	mov    %ebx,(%esp)
  801338:	e8 73 ff ff ff       	call   8012b0 <strlen>
	strcpy(dst + len, src);
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	89 54 24 04          	mov    %edx,0x4(%esp)
  801344:	01 d8                	add    %ebx,%eax
  801346:	89 04 24             	mov    %eax,(%esp)
  801349:	e8 bd ff ff ff       	call   80130b <strcpy>
	return dst;
}
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	83 c4 08             	add    $0x8,%esp
  801353:	5b                   	pop    %ebx
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    

00801356 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801356:	55                   	push   %ebp
  801357:	89 e5                	mov    %esp,%ebp
  801359:	56                   	push   %esi
  80135a:	53                   	push   %ebx
  80135b:	8b 75 08             	mov    0x8(%ebp),%esi
  80135e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801361:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801364:	85 db                	test   %ebx,%ebx
  801366:	74 17                	je     80137f <strncpy+0x29>
  801368:	01 f3                	add    %esi,%ebx
  80136a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80136c:	83 c1 01             	add    $0x1,%ecx
  80136f:	0f b6 02             	movzbl (%edx),%eax
  801372:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801375:	80 3a 01             	cmpb   $0x1,(%edx)
  801378:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	39 d9                	cmp    %ebx,%ecx
  80137d:	75 ed                	jne    80136c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80137f:	89 f0                	mov    %esi,%eax
  801381:	5b                   	pop    %ebx
  801382:	5e                   	pop    %esi
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    

00801385 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	57                   	push   %edi
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801391:	8b 75 10             	mov    0x10(%ebp),%esi
  801394:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801396:	85 f6                	test   %esi,%esi
  801398:	74 34                	je     8013ce <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80139a:	83 fe 01             	cmp    $0x1,%esi
  80139d:	74 26                	je     8013c5 <strlcpy+0x40>
  80139f:	0f b6 0b             	movzbl (%ebx),%ecx
  8013a2:	84 c9                	test   %cl,%cl
  8013a4:	74 23                	je     8013c9 <strlcpy+0x44>
  8013a6:	83 ee 02             	sub    $0x2,%esi
  8013a9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8013ae:	83 c0 01             	add    $0x1,%eax
  8013b1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b4:	39 f2                	cmp    %esi,%edx
  8013b6:	74 13                	je     8013cb <strlcpy+0x46>
  8013b8:	83 c2 01             	add    $0x1,%edx
  8013bb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8013bf:	84 c9                	test   %cl,%cl
  8013c1:	75 eb                	jne    8013ae <strlcpy+0x29>
  8013c3:	eb 06                	jmp    8013cb <strlcpy+0x46>
  8013c5:	89 f8                	mov    %edi,%eax
  8013c7:	eb 02                	jmp    8013cb <strlcpy+0x46>
  8013c9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8013cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013ce:	29 f8                	sub    %edi,%eax
}
  8013d0:	5b                   	pop    %ebx
  8013d1:	5e                   	pop    %esi
  8013d2:	5f                   	pop    %edi
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    

008013d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
  8013d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013db:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8013de:	0f b6 01             	movzbl (%ecx),%eax
  8013e1:	84 c0                	test   %al,%al
  8013e3:	74 15                	je     8013fa <strcmp+0x25>
  8013e5:	3a 02                	cmp    (%edx),%al
  8013e7:	75 11                	jne    8013fa <strcmp+0x25>
		p++, q++;
  8013e9:	83 c1 01             	add    $0x1,%ecx
  8013ec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013ef:	0f b6 01             	movzbl (%ecx),%eax
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 04                	je     8013fa <strcmp+0x25>
  8013f6:	3a 02                	cmp    (%edx),%al
  8013f8:	74 ef                	je     8013e9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fa:	0f b6 c0             	movzbl %al,%eax
  8013fd:	0f b6 12             	movzbl (%edx),%edx
  801400:	29 d0                	sub    %edx,%eax
}
  801402:	5d                   	pop    %ebp
  801403:	c3                   	ret    

00801404 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	56                   	push   %esi
  801408:	53                   	push   %ebx
  801409:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80140c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80140f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801412:	85 f6                	test   %esi,%esi
  801414:	74 29                	je     80143f <strncmp+0x3b>
  801416:	0f b6 03             	movzbl (%ebx),%eax
  801419:	84 c0                	test   %al,%al
  80141b:	74 30                	je     80144d <strncmp+0x49>
  80141d:	3a 02                	cmp    (%edx),%al
  80141f:	75 2c                	jne    80144d <strncmp+0x49>
  801421:	8d 43 01             	lea    0x1(%ebx),%eax
  801424:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801426:	89 c3                	mov    %eax,%ebx
  801428:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80142b:	39 f0                	cmp    %esi,%eax
  80142d:	74 17                	je     801446 <strncmp+0x42>
  80142f:	0f b6 08             	movzbl (%eax),%ecx
  801432:	84 c9                	test   %cl,%cl
  801434:	74 17                	je     80144d <strncmp+0x49>
  801436:	83 c0 01             	add    $0x1,%eax
  801439:	3a 0a                	cmp    (%edx),%cl
  80143b:	74 e9                	je     801426 <strncmp+0x22>
  80143d:	eb 0e                	jmp    80144d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80143f:	b8 00 00 00 00       	mov    $0x0,%eax
  801444:	eb 0f                	jmp    801455 <strncmp+0x51>
  801446:	b8 00 00 00 00       	mov    $0x0,%eax
  80144b:	eb 08                	jmp    801455 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80144d:	0f b6 03             	movzbl (%ebx),%eax
  801450:	0f b6 12             	movzbl (%edx),%edx
  801453:	29 d0                	sub    %edx,%eax
}
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	53                   	push   %ebx
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801463:	0f b6 18             	movzbl (%eax),%ebx
  801466:	84 db                	test   %bl,%bl
  801468:	74 1d                	je     801487 <strchr+0x2e>
  80146a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80146c:	38 d3                	cmp    %dl,%bl
  80146e:	75 06                	jne    801476 <strchr+0x1d>
  801470:	eb 1a                	jmp    80148c <strchr+0x33>
  801472:	38 ca                	cmp    %cl,%dl
  801474:	74 16                	je     80148c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801476:	83 c0 01             	add    $0x1,%eax
  801479:	0f b6 10             	movzbl (%eax),%edx
  80147c:	84 d2                	test   %dl,%dl
  80147e:	75 f2                	jne    801472 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801480:	b8 00 00 00 00       	mov    $0x0,%eax
  801485:	eb 05                	jmp    80148c <strchr+0x33>
  801487:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148c:	5b                   	pop    %ebx
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801499:	0f b6 18             	movzbl (%eax),%ebx
  80149c:	84 db                	test   %bl,%bl
  80149e:	74 16                	je     8014b6 <strfind+0x27>
  8014a0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8014a2:	38 d3                	cmp    %dl,%bl
  8014a4:	75 06                	jne    8014ac <strfind+0x1d>
  8014a6:	eb 0e                	jmp    8014b6 <strfind+0x27>
  8014a8:	38 ca                	cmp    %cl,%dl
  8014aa:	74 0a                	je     8014b6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ac:	83 c0 01             	add    $0x1,%eax
  8014af:	0f b6 10             	movzbl (%eax),%edx
  8014b2:	84 d2                	test   %dl,%dl
  8014b4:	75 f2                	jne    8014a8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  8014b6:	5b                   	pop    %ebx
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    

008014b9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014b9:	55                   	push   %ebp
  8014ba:	89 e5                	mov    %esp,%ebp
  8014bc:	57                   	push   %edi
  8014bd:	56                   	push   %esi
  8014be:	53                   	push   %ebx
  8014bf:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8014c5:	85 c9                	test   %ecx,%ecx
  8014c7:	74 36                	je     8014ff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8014c9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8014cf:	75 28                	jne    8014f9 <memset+0x40>
  8014d1:	f6 c1 03             	test   $0x3,%cl
  8014d4:	75 23                	jne    8014f9 <memset+0x40>
		c &= 0xFF;
  8014d6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014da:	89 d3                	mov    %edx,%ebx
  8014dc:	c1 e3 08             	shl    $0x8,%ebx
  8014df:	89 d6                	mov    %edx,%esi
  8014e1:	c1 e6 18             	shl    $0x18,%esi
  8014e4:	89 d0                	mov    %edx,%eax
  8014e6:	c1 e0 10             	shl    $0x10,%eax
  8014e9:	09 f0                	or     %esi,%eax
  8014eb:	09 c2                	or     %eax,%edx
  8014ed:	89 d0                	mov    %edx,%eax
  8014ef:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8014f1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8014f4:	fc                   	cld    
  8014f5:	f3 ab                	rep stos %eax,%es:(%edi)
  8014f7:	eb 06                	jmp    8014ff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8014f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fc:	fc                   	cld    
  8014fd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8014ff:	89 f8                	mov    %edi,%eax
  801501:	5b                   	pop    %ebx
  801502:	5e                   	pop    %esi
  801503:	5f                   	pop    %edi
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	57                   	push   %edi
  80150a:	56                   	push   %esi
  80150b:	8b 45 08             	mov    0x8(%ebp),%eax
  80150e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801511:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801514:	39 c6                	cmp    %eax,%esi
  801516:	73 35                	jae    80154d <memmove+0x47>
  801518:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80151b:	39 d0                	cmp    %edx,%eax
  80151d:	73 2e                	jae    80154d <memmove+0x47>
		s += n;
		d += n;
  80151f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801522:	89 d6                	mov    %edx,%esi
  801524:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801526:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80152c:	75 13                	jne    801541 <memmove+0x3b>
  80152e:	f6 c1 03             	test   $0x3,%cl
  801531:	75 0e                	jne    801541 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801533:	83 ef 04             	sub    $0x4,%edi
  801536:	8d 72 fc             	lea    -0x4(%edx),%esi
  801539:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80153c:	fd                   	std    
  80153d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80153f:	eb 09                	jmp    80154a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801541:	83 ef 01             	sub    $0x1,%edi
  801544:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801547:	fd                   	std    
  801548:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80154a:	fc                   	cld    
  80154b:	eb 1d                	jmp    80156a <memmove+0x64>
  80154d:	89 f2                	mov    %esi,%edx
  80154f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801551:	f6 c2 03             	test   $0x3,%dl
  801554:	75 0f                	jne    801565 <memmove+0x5f>
  801556:	f6 c1 03             	test   $0x3,%cl
  801559:	75 0a                	jne    801565 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80155b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80155e:	89 c7                	mov    %eax,%edi
  801560:	fc                   	cld    
  801561:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801563:	eb 05                	jmp    80156a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801565:	89 c7                	mov    %eax,%edi
  801567:	fc                   	cld    
  801568:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80156a:	5e                   	pop    %esi
  80156b:	5f                   	pop    %edi
  80156c:	5d                   	pop    %ebp
  80156d:	c3                   	ret    

0080156e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801574:	8b 45 10             	mov    0x10(%ebp),%eax
  801577:	89 44 24 08          	mov    %eax,0x8(%esp)
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	89 04 24             	mov    %eax,(%esp)
  801588:	e8 79 ff ff ff       	call   801506 <memmove>
}
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	57                   	push   %edi
  801593:	56                   	push   %esi
  801594:	53                   	push   %ebx
  801595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801598:	8b 75 0c             	mov    0xc(%ebp),%esi
  80159b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80159e:	8d 78 ff             	lea    -0x1(%eax),%edi
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	74 36                	je     8015db <memcmp+0x4c>
		if (*s1 != *s2)
  8015a5:	0f b6 03             	movzbl (%ebx),%eax
  8015a8:	0f b6 0e             	movzbl (%esi),%ecx
  8015ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b0:	38 c8                	cmp    %cl,%al
  8015b2:	74 1c                	je     8015d0 <memcmp+0x41>
  8015b4:	eb 10                	jmp    8015c6 <memcmp+0x37>
  8015b6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  8015bb:	83 c2 01             	add    $0x1,%edx
  8015be:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  8015c2:	38 c8                	cmp    %cl,%al
  8015c4:	74 0a                	je     8015d0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	0f b6 c9             	movzbl %cl,%ecx
  8015cc:	29 c8                	sub    %ecx,%eax
  8015ce:	eb 10                	jmp    8015e0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015d0:	39 fa                	cmp    %edi,%edx
  8015d2:	75 e2                	jne    8015b6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d9:	eb 05                	jmp    8015e0 <memcmp+0x51>
  8015db:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e0:	5b                   	pop    %ebx
  8015e1:	5e                   	pop    %esi
  8015e2:	5f                   	pop    %edi
  8015e3:	5d                   	pop    %ebp
  8015e4:	c3                   	ret    

008015e5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	53                   	push   %ebx
  8015e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  8015ef:	89 c2                	mov    %eax,%edx
  8015f1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8015f4:	39 d0                	cmp    %edx,%eax
  8015f6:	73 13                	jae    80160b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f8:	89 d9                	mov    %ebx,%ecx
  8015fa:	38 18                	cmp    %bl,(%eax)
  8015fc:	75 06                	jne    801604 <memfind+0x1f>
  8015fe:	eb 0b                	jmp    80160b <memfind+0x26>
  801600:	38 08                	cmp    %cl,(%eax)
  801602:	74 07                	je     80160b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801604:	83 c0 01             	add    $0x1,%eax
  801607:	39 d0                	cmp    %edx,%eax
  801609:	75 f5                	jne    801600 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80160b:	5b                   	pop    %ebx
  80160c:	5d                   	pop    %ebp
  80160d:	c3                   	ret    

0080160e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	57                   	push   %edi
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	8b 55 08             	mov    0x8(%ebp),%edx
  801617:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80161a:	0f b6 0a             	movzbl (%edx),%ecx
  80161d:	80 f9 09             	cmp    $0x9,%cl
  801620:	74 05                	je     801627 <strtol+0x19>
  801622:	80 f9 20             	cmp    $0x20,%cl
  801625:	75 10                	jne    801637 <strtol+0x29>
		s++;
  801627:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80162a:	0f b6 0a             	movzbl (%edx),%ecx
  80162d:	80 f9 09             	cmp    $0x9,%cl
  801630:	74 f5                	je     801627 <strtol+0x19>
  801632:	80 f9 20             	cmp    $0x20,%cl
  801635:	74 f0                	je     801627 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801637:	80 f9 2b             	cmp    $0x2b,%cl
  80163a:	75 0a                	jne    801646 <strtol+0x38>
		s++;
  80163c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80163f:	bf 00 00 00 00       	mov    $0x0,%edi
  801644:	eb 11                	jmp    801657 <strtol+0x49>
  801646:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80164b:	80 f9 2d             	cmp    $0x2d,%cl
  80164e:	75 07                	jne    801657 <strtol+0x49>
		s++, neg = 1;
  801650:	83 c2 01             	add    $0x1,%edx
  801653:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801657:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80165c:	75 15                	jne    801673 <strtol+0x65>
  80165e:	80 3a 30             	cmpb   $0x30,(%edx)
  801661:	75 10                	jne    801673 <strtol+0x65>
  801663:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801667:	75 0a                	jne    801673 <strtol+0x65>
		s += 2, base = 16;
  801669:	83 c2 02             	add    $0x2,%edx
  80166c:	b8 10 00 00 00       	mov    $0x10,%eax
  801671:	eb 10                	jmp    801683 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801673:	85 c0                	test   %eax,%eax
  801675:	75 0c                	jne    801683 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801677:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801679:	80 3a 30             	cmpb   $0x30,(%edx)
  80167c:	75 05                	jne    801683 <strtol+0x75>
		s++, base = 8;
  80167e:	83 c2 01             	add    $0x1,%edx
  801681:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801683:	bb 00 00 00 00       	mov    $0x0,%ebx
  801688:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80168b:	0f b6 0a             	movzbl (%edx),%ecx
  80168e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801691:	89 f0                	mov    %esi,%eax
  801693:	3c 09                	cmp    $0x9,%al
  801695:	77 08                	ja     80169f <strtol+0x91>
			dig = *s - '0';
  801697:	0f be c9             	movsbl %cl,%ecx
  80169a:	83 e9 30             	sub    $0x30,%ecx
  80169d:	eb 20                	jmp    8016bf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  80169f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8016a2:	89 f0                	mov    %esi,%eax
  8016a4:	3c 19                	cmp    $0x19,%al
  8016a6:	77 08                	ja     8016b0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  8016a8:	0f be c9             	movsbl %cl,%ecx
  8016ab:	83 e9 57             	sub    $0x57,%ecx
  8016ae:	eb 0f                	jmp    8016bf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  8016b0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8016b3:	89 f0                	mov    %esi,%eax
  8016b5:	3c 19                	cmp    $0x19,%al
  8016b7:	77 16                	ja     8016cf <strtol+0xc1>
			dig = *s - 'A' + 10;
  8016b9:	0f be c9             	movsbl %cl,%ecx
  8016bc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8016bf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8016c2:	7d 0f                	jge    8016d3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8016c4:	83 c2 01             	add    $0x1,%edx
  8016c7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8016cb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8016cd:	eb bc                	jmp    80168b <strtol+0x7d>
  8016cf:	89 d8                	mov    %ebx,%eax
  8016d1:	eb 02                	jmp    8016d5 <strtol+0xc7>
  8016d3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  8016d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d9:	74 05                	je     8016e0 <strtol+0xd2>
		*endptr = (char *) s;
  8016db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016de:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  8016e0:	f7 d8                	neg    %eax
  8016e2:	85 ff                	test   %edi,%edi
  8016e4:	0f 44 c3             	cmove  %ebx,%eax
}
  8016e7:	5b                   	pop    %ebx
  8016e8:	5e                   	pop    %esi
  8016e9:	5f                   	pop    %edi
  8016ea:	5d                   	pop    %ebp
  8016eb:	c3                   	ret    

008016ec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	57                   	push   %edi
  8016f0:	56                   	push   %esi
  8016f1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fd:	89 c3                	mov    %eax,%ebx
  8016ff:	89 c7                	mov    %eax,%edi
  801701:	89 c6                	mov    %eax,%esi
  801703:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801705:	5b                   	pop    %ebx
  801706:	5e                   	pop    %esi
  801707:	5f                   	pop    %edi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <sys_cgetc>:

int
sys_cgetc(void)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	57                   	push   %edi
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b8 01 00 00 00       	mov    $0x1,%eax
  80171a:	89 d1                	mov    %edx,%ecx
  80171c:	89 d3                	mov    %edx,%ebx
  80171e:	89 d7                	mov    %edx,%edi
  801720:	89 d6                	mov    %edx,%esi
  801722:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    

00801729 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	57                   	push   %edi
  80172d:	56                   	push   %esi
  80172e:	53                   	push   %ebx
  80172f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801732:	b9 00 00 00 00       	mov    $0x0,%ecx
  801737:	b8 03 00 00 00       	mov    $0x3,%eax
  80173c:	8b 55 08             	mov    0x8(%ebp),%edx
  80173f:	89 cb                	mov    %ecx,%ebx
  801741:	89 cf                	mov    %ecx,%edi
  801743:	89 ce                	mov    %ecx,%esi
  801745:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801747:	85 c0                	test   %eax,%eax
  801749:	7e 28                	jle    801773 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80174b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80174f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801756:	00 
  801757:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  80175e:	00 
  80175f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801766:	00 
  801767:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  80176e:	e8 54 f3 ff ff       	call   800ac7 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801773:	83 c4 2c             	add    $0x2c,%esp
  801776:	5b                   	pop    %ebx
  801777:	5e                   	pop    %esi
  801778:	5f                   	pop    %edi
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	57                   	push   %edi
  80177f:	56                   	push   %esi
  801780:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801781:	ba 00 00 00 00       	mov    $0x0,%edx
  801786:	b8 02 00 00 00       	mov    $0x2,%eax
  80178b:	89 d1                	mov    %edx,%ecx
  80178d:	89 d3                	mov    %edx,%ebx
  80178f:	89 d7                	mov    %edx,%edi
  801791:	89 d6                	mov    %edx,%esi
  801793:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801795:	5b                   	pop    %ebx
  801796:	5e                   	pop    %esi
  801797:	5f                   	pop    %edi
  801798:	5d                   	pop    %ebp
  801799:	c3                   	ret    

0080179a <sys_yield>:

void
sys_yield(void)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8017aa:	89 d1                	mov    %edx,%ecx
  8017ac:	89 d3                	mov    %edx,%ebx
  8017ae:	89 d7                	mov    %edx,%edi
  8017b0:	89 d6                	mov    %edx,%esi
  8017b2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017b4:	5b                   	pop    %ebx
  8017b5:	5e                   	pop    %esi
  8017b6:	5f                   	pop    %edi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    

008017b9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	57                   	push   %edi
  8017bd:	56                   	push   %esi
  8017be:	53                   	push   %ebx
  8017bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c2:	be 00 00 00 00       	mov    $0x0,%esi
  8017c7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017d5:	89 f7                	mov    %esi,%edi
  8017d7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	7e 28                	jle    801805 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e1:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8017e8:	00 
  8017e9:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  8017f0:	00 
  8017f1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8017f8:	00 
  8017f9:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  801800:	e8 c2 f2 ff ff       	call   800ac7 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801805:	83 c4 2c             	add    $0x2c,%esp
  801808:	5b                   	pop    %ebx
  801809:	5e                   	pop    %esi
  80180a:	5f                   	pop    %edi
  80180b:	5d                   	pop    %ebp
  80180c:	c3                   	ret    

0080180d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	57                   	push   %edi
  801811:	56                   	push   %esi
  801812:	53                   	push   %ebx
  801813:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801816:	b8 05 00 00 00       	mov    $0x5,%eax
  80181b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80181e:	8b 55 08             	mov    0x8(%ebp),%edx
  801821:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801824:	8b 7d 14             	mov    0x14(%ebp),%edi
  801827:	8b 75 18             	mov    0x18(%ebp),%esi
  80182a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80182c:	85 c0                	test   %eax,%eax
  80182e:	7e 28                	jle    801858 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801830:	89 44 24 10          	mov    %eax,0x10(%esp)
  801834:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80183b:	00 
  80183c:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  801843:	00 
  801844:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80184b:	00 
  80184c:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  801853:	e8 6f f2 ff ff       	call   800ac7 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801858:	83 c4 2c             	add    $0x2c,%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	57                   	push   %edi
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801869:	bb 00 00 00 00       	mov    $0x0,%ebx
  80186e:	b8 06 00 00 00       	mov    $0x6,%eax
  801873:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801876:	8b 55 08             	mov    0x8(%ebp),%edx
  801879:	89 df                	mov    %ebx,%edi
  80187b:	89 de                	mov    %ebx,%esi
  80187d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80187f:	85 c0                	test   %eax,%eax
  801881:	7e 28                	jle    8018ab <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801883:	89 44 24 10          	mov    %eax,0x10(%esp)
  801887:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80188e:	00 
  80188f:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  801896:	00 
  801897:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80189e:	00 
  80189f:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  8018a6:	e8 1c f2 ff ff       	call   800ac7 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018ab:	83 c4 2c             	add    $0x2c,%esp
  8018ae:	5b                   	pop    %ebx
  8018af:	5e                   	pop    %esi
  8018b0:	5f                   	pop    %edi
  8018b1:	5d                   	pop    %ebp
  8018b2:	c3                   	ret    

008018b3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018b3:	55                   	push   %ebp
  8018b4:	89 e5                	mov    %esp,%ebp
  8018b6:	57                   	push   %edi
  8018b7:	56                   	push   %esi
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018bc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8018c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cc:	89 df                	mov    %ebx,%edi
  8018ce:	89 de                	mov    %ebx,%esi
  8018d0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	7e 28                	jle    8018fe <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018da:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8018e1:	00 
  8018e2:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  8018e9:	00 
  8018ea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018f1:	00 
  8018f2:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  8018f9:	e8 c9 f1 ff ff       	call   800ac7 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8018fe:	83 c4 2c             	add    $0x2c,%esp
  801901:	5b                   	pop    %ebx
  801902:	5e                   	pop    %esi
  801903:	5f                   	pop    %edi
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	57                   	push   %edi
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80190f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801914:	b8 09 00 00 00       	mov    $0x9,%eax
  801919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80191c:	8b 55 08             	mov    0x8(%ebp),%edx
  80191f:	89 df                	mov    %ebx,%edi
  801921:	89 de                	mov    %ebx,%esi
  801923:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801925:	85 c0                	test   %eax,%eax
  801927:	7e 28                	jle    801951 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801929:	89 44 24 10          	mov    %eax,0x10(%esp)
  80192d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801934:	00 
  801935:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  80193c:	00 
  80193d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801944:	00 
  801945:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  80194c:	e8 76 f1 ff ff       	call   800ac7 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801951:	83 c4 2c             	add    $0x2c,%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5f                   	pop    %edi
  801957:	5d                   	pop    %ebp
  801958:	c3                   	ret    

00801959 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801959:	55                   	push   %ebp
  80195a:	89 e5                	mov    %esp,%ebp
  80195c:	57                   	push   %edi
  80195d:	56                   	push   %esi
  80195e:	53                   	push   %ebx
  80195f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801962:	bb 00 00 00 00       	mov    $0x0,%ebx
  801967:	b8 0a 00 00 00       	mov    $0xa,%eax
  80196c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80196f:	8b 55 08             	mov    0x8(%ebp),%edx
  801972:	89 df                	mov    %ebx,%edi
  801974:	89 de                	mov    %ebx,%esi
  801976:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801978:	85 c0                	test   %eax,%eax
  80197a:	7e 28                	jle    8019a4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80197c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801980:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801987:	00 
  801988:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  80198f:	00 
  801990:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801997:	00 
  801998:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  80199f:	e8 23 f1 ff ff       	call   800ac7 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019a4:	83 c4 2c             	add    $0x2c,%esp
  8019a7:	5b                   	pop    %ebx
  8019a8:	5e                   	pop    %esi
  8019a9:	5f                   	pop    %edi
  8019aa:	5d                   	pop    %ebp
  8019ab:	c3                   	ret    

008019ac <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	57                   	push   %edi
  8019b0:	56                   	push   %esi
  8019b1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019b2:	be 00 00 00 00       	mov    $0x0,%esi
  8019b7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8019bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8019c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019c5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019c8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5f                   	pop    %edi
  8019cd:	5d                   	pop    %ebp
  8019ce:	c3                   	ret    

008019cf <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	57                   	push   %edi
  8019d3:	56                   	push   %esi
  8019d4:	53                   	push   %ebx
  8019d5:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019d8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8019dd:	b8 0d 00 00 00       	mov    $0xd,%eax
  8019e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e5:	89 cb                	mov    %ecx,%ebx
  8019e7:	89 cf                	mov    %ecx,%edi
  8019e9:	89 ce                	mov    %ecx,%esi
  8019eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	7e 28                	jle    801a19 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019f5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8019fc:	00 
  8019fd:	c7 44 24 08 4f 3d 80 	movl   $0x803d4f,0x8(%esp)
  801a04:	00 
  801a05:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a0c:	00 
  801a0d:	c7 04 24 6c 3d 80 00 	movl   $0x803d6c,(%esp)
  801a14:	e8 ae f0 ff ff       	call   800ac7 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a19:	83 c4 2c             	add    $0x2c,%esp
  801a1c:	5b                   	pop    %ebx
  801a1d:	5e                   	pop    %esi
  801a1e:	5f                   	pop    %edi
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    

00801a21 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
  801a25:	83 ec 24             	sub    $0x24,%esp
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801a2b:	8b 18                	mov    (%eax),%ebx
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	// get page number
	uint32_t pn = ((uint32_t)addr) >> 12;
  801a2d:	89 da                	mov    %ebx,%edx
  801a2f:	c1 ea 0c             	shr    $0xc,%edx
	const pte_t pte = uvpt[pn];
  801a32:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!((err & FEC_WR) && (pte & PTE_COW))) {
  801a39:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801a3d:	74 05                	je     801a44 <pgfault+0x23>
  801a3f:	f6 c6 08             	test   $0x8,%dh
  801a42:	75 1c                	jne    801a60 <pgfault+0x3f>
		panic("pgfault: %x is not write access to copy-on-write page.\n");
  801a44:	c7 44 24 08 7c 3d 80 	movl   $0x803d7c,0x8(%esp)
  801a4b:	00 
  801a4c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801a53:	00 
  801a54:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801a5b:	e8 67 f0 ff ff       	call   800ac7 <_panic>
	//   You should make three system calls. ?????
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	int err_code;
	if ((err_code = sys_page_alloc(0, PFTEMP, PTE_U | PTE_P | PTE_W)) < 0) {
  801a60:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a67:	00 
  801a68:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801a6f:	00 
  801a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a77:	e8 3d fd ff ff       	call   8017b9 <sys_page_alloc>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	79 20                	jns    801aa0 <pgfault+0x7f>
		panic("pgfault:sys_page_alloc:%e", err_code);
  801a80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a84:	c7 44 24 08 e4 3d 80 	movl   $0x803de4,0x8(%esp)
  801a8b:	00 
  801a8c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801a93:	00 
  801a94:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801a9b:	e8 27 f0 ff ff       	call   800ac7 <_panic>
	}
	
	// copy the content of the fault page to TEMP area.
	void* addr_round = ROUNDDOWN(addr, PGSIZE);
  801aa0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memmove(PFTEMP, addr_round, PGSIZE);
  801aa6:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801aad:	00 
  801aae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab2:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801ab9:	e8 48 fa ff ff       	call   801506 <memmove>

	// remap
	int new_perm = PTE_U | PTE_P | PTE_W;
	if ((err_code = sys_page_map(0, PFTEMP, 0, addr_round, new_perm)) < 0) {
  801abe:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801ac5:	00 
  801ac6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801aca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ad1:	00 
  801ad2:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801ad9:	00 
  801ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae1:	e8 27 fd ff ff       	call   80180d <sys_page_map>
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	79 20                	jns    801b0a <pgfault+0xe9>
		panic("pgfault: sys_page_map:%e", err_code);
  801aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aee:	c7 44 24 08 fe 3d 80 	movl   $0x803dfe,0x8(%esp)
  801af5:	00 
  801af6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801afd:	00 
  801afe:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801b05:	e8 bd ef ff ff       	call   800ac7 <_panic>
	}
}
  801b0a:	83 c4 24             	add    $0x24,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <fork>:
// Assembly language pgfault entrypoint defined in lib/pfentry.S.
extern void _pgfault_upcall(void);

envid_t
fork(void)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	57                   	push   %edi
  801b14:	56                   	push   %esi
  801b15:	53                   	push   %ebx
  801b16:	83 ec 2c             	sub    $0x2c,%esp
	// set parent process fault handler
	set_pgfault_handler(pgfault);
  801b19:	c7 04 24 21 1a 80 00 	movl   $0x801a21,(%esp)
  801b20:	e8 36 18 00 00       	call   80335b <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801b25:	b8 07 00 00 00       	mov    $0x7,%eax
  801b2a:	cd 30                	int    $0x30
  801b2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// allocate a new env for child process with kernel part mapping
	envid_t envid;
	if ((envid = sys_exofork()) < 0) {
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	79 1c                	jns    801b4f <fork+0x3f>
		panic("fork");
  801b33:	c7 44 24 08 17 3e 80 	movl   $0x803e17,0x8(%esp)
  801b3a:	00 
  801b3b:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  801b42:	00 
  801b43:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801b4a:	e8 78 ef ff ff       	call   800ac7 <_panic>
  801b4f:	89 c7                	mov    %eax,%edi
	}

	if (envid == 0) {
  801b51:	bb 00 08 00 00       	mov    $0x800,%ebx
  801b56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b5a:	75 21                	jne    801b7d <fork+0x6d>
		// in child process
		thisenv = &envs[ENVX(sys_getenvid())];
  801b5c:	e8 1a fc ff ff       	call   80177b <sys_getenvid>
  801b61:	25 ff 03 00 00       	and    $0x3ff,%eax
  801b66:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801b69:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801b6e:	a3 24 64 80 00       	mov    %eax,0x806424
		return 0;
  801b73:	b8 00 00 00 00       	mov    $0x0,%eax
  801b78:	e9 cf 01 00 00       	jmp    801d4c <fork+0x23c>
	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
		// check whether current page is present
		if (!(uvpd[pn_beg >> 10] & PTE_P)) {
  801b7d:	89 d8                	mov    %ebx,%eax
  801b7f:	c1 e8 0a             	shr    $0xa,%eax
  801b82:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b89:	a8 01                	test   $0x1,%al
  801b8b:	0f 84 fc 00 00 00    	je     801c8d <fork+0x17d>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801b91:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b98:	a8 05                	test   $0x5,%al
  801b9a:	0f 84 ed 00 00 00    	je     801c8d <fork+0x17d>
// use sys_page_map
static int
duppage(envid_t envid, unsigned pn)
{
	// get the PTE of page pn
	const pte_t pte = uvpt[pn];
  801ba0:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801ba7:	89 de                	mov    %ebx,%esi
  801ba9:	c1 e6 0c             	shl    $0xc,%esi

	int err_code;
	void* va = (void*)(pn * PGSIZE);
	// this page is not share page and it is writable or c-o-w
	if ( !(pte & PTE_SHARE) &&
  801bac:	f6 c4 04             	test   $0x4,%ah
  801baf:	0f 85 93 00 00 00    	jne    801c48 <fork+0x138>
  801bb5:	a9 02 08 00 00       	test   $0x802,%eax
  801bba:	0f 84 88 00 00 00    	je     801c48 <fork+0x138>
			 ((pte & PTE_W) || (pte & PTE_COW))) {

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801bc0:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801bc7:	00 
  801bc8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bcc:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801bd0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bdb:	e8 2d fc ff ff       	call   80180d <sys_page_map>
  801be0:	85 c0                	test   %eax,%eax
  801be2:	79 20                	jns    801c04 <fork+0xf4>
			panic("duppage:sys_page_map:1:%e", err_code);
  801be4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be8:	c7 44 24 08 1c 3e 80 	movl   $0x803e1c,0x8(%esp)
  801bef:	00 
  801bf0:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  801bf7:	00 
  801bf8:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801bff:	e8 c3 ee ff ff       	call   800ac7 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  801c04:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801c0b:	00 
  801c0c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c10:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c17:	00 
  801c18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c1c:	89 3c 24             	mov    %edi,(%esp)
  801c1f:	e8 e9 fb ff ff       	call   80180d <sys_page_map>
  801c24:	85 c0                	test   %eax,%eax
  801c26:	79 65                	jns    801c8d <fork+0x17d>
			panic("duppage:sys_page_map:2:%e", err_code);
  801c28:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c2c:	c7 44 24 08 36 3e 80 	movl   $0x803e36,0x8(%esp)
  801c33:	00 
  801c34:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801c3b:	00 
  801c3c:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801c43:	e8 7f ee ff ff       	call   800ac7 <_panic>
		}

	} else { // read-only page or share page
		int perm = (pte & PTE_SYSCALL);
  801c48:	25 07 0e 00 00       	and    $0xe07,%eax
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801c4d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c51:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c55:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c59:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c64:	e8 a4 fb ff ff       	call   80180d <sys_page_map>
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	79 20                	jns    801c8d <fork+0x17d>
			panic("sys_page_map:3:%e", err_code);
  801c6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c71:	c7 44 24 08 50 3e 80 	movl   $0x803e50,0x8(%esp)
  801c78:	00 
  801c79:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c80:	00 
  801c81:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801c88:	e8 3a ee ff ff       	call   800ac7 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801c8d:	83 c3 01             	add    $0x1,%ebx
  801c90:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801c96:	0f 85 e1 fe ff ff    	jne    801b7d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801c9c:	c7 44 24 04 c4 33 80 	movl   $0x8033c4,0x4(%esp)
  801ca3:	00 
  801ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca7:	89 04 24             	mov    %eax,(%esp)
  801caa:	e8 aa fc ff ff       	call   801959 <sys_env_set_pgfault_upcall>
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	79 20                	jns    801cd3 <fork+0x1c3>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801cb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cb7:	c7 44 24 08 b4 3d 80 	movl   $0x803db4,0x8(%esp)
  801cbe:	00 
  801cbf:	c7 44 24 04 a3 00 00 	movl   $0xa3,0x4(%esp)
  801cc6:	00 
  801cc7:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801cce:	e8 f4 ed ff ff       	call   800ac7 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801cd3:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cda:	00 
  801cdb:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801ce2:	ee 
  801ce3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ce6:	89 04 24             	mov    %eax,(%esp)
  801ce9:	e8 cb fa ff ff       	call   8017b9 <sys_page_alloc>
  801cee:	85 c0                	test   %eax,%eax
  801cf0:	79 20                	jns    801d12 <fork+0x202>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801cf2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf6:	c7 44 24 08 62 3e 80 	movl   $0x803e62,0x8(%esp)
  801cfd:	00 
  801cfe:	c7 44 24 04 a8 00 00 	movl   $0xa8,0x4(%esp)
  801d05:	00 
  801d06:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801d0d:	e8 b5 ed ff ff       	call   800ac7 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801d12:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d19:	00 
  801d1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d1d:	89 04 24             	mov    %eax,(%esp)
  801d20:	e8 8e fb ff ff       	call   8018b3 <sys_env_set_status>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	79 20                	jns    801d49 <fork+0x239>
		panic("fork:sys_env_set_status:%e", err_code);
  801d29:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d2d:	c7 44 24 08 7a 3e 80 	movl   $0x803e7a,0x8(%esp)
  801d34:	00 
  801d35:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  801d3c:	00 
  801d3d:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801d44:	e8 7e ed ff ff       	call   800ac7 <_panic>
	}

	return envid;
  801d49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801d4c:	83 c4 2c             	add    $0x2c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <sfork>:

// Challenge!
int
sfork(void)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801d5a:	c7 44 24 08 95 3e 80 	movl   $0x803e95,0x8(%esp)
  801d61:	00 
  801d62:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  801d69:	00 
  801d6a:	c7 04 24 d9 3d 80 00 	movl   $0x803dd9,(%esp)
  801d71:	e8 51 ed ff ff       	call   800ac7 <_panic>

00801d76 <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	53                   	push   %ebx
  801d7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801d83:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801d85:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d88:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d8d:	83 39 01             	cmpl   $0x1,(%ecx)
  801d90:	7e 0f                	jle    801da1 <argstart+0x2b>
  801d92:	85 d2                	test   %edx,%edx
  801d94:	ba 00 00 00 00       	mov    $0x0,%edx
  801d99:	bb 21 38 80 00       	mov    $0x803821,%ebx
  801d9e:	0f 44 da             	cmove  %edx,%ebx
  801da1:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  801da4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801dab:	5b                   	pop    %ebx
  801dac:	5d                   	pop    %ebp
  801dad:	c3                   	ret    

00801dae <argnext>:

int
argnext(struct Argstate *args)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	53                   	push   %ebx
  801db2:	83 ec 14             	sub    $0x14,%esp
  801db5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801db8:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801dbf:	8b 43 08             	mov    0x8(%ebx),%eax
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	74 71                	je     801e37 <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801dc6:	80 38 00             	cmpb   $0x0,(%eax)
  801dc9:	75 50                	jne    801e1b <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801dcb:	8b 0b                	mov    (%ebx),%ecx
  801dcd:	83 39 01             	cmpl   $0x1,(%ecx)
  801dd0:	74 57                	je     801e29 <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801dd2:	8b 53 04             	mov    0x4(%ebx),%edx
  801dd5:	8b 42 04             	mov    0x4(%edx),%eax
  801dd8:	80 38 2d             	cmpb   $0x2d,(%eax)
  801ddb:	75 4c                	jne    801e29 <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801ddd:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801de1:	74 46                	je     801e29 <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801de3:	83 c0 01             	add    $0x1,%eax
  801de6:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801de9:	8b 01                	mov    (%ecx),%eax
  801deb:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801df2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df6:	8d 42 08             	lea    0x8(%edx),%eax
  801df9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfd:	83 c2 04             	add    $0x4,%edx
  801e00:	89 14 24             	mov    %edx,(%esp)
  801e03:	e8 fe f6 ff ff       	call   801506 <memmove>
		(*args->argc)--;
  801e08:	8b 03                	mov    (%ebx),%eax
  801e0a:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e0d:	8b 43 08             	mov    0x8(%ebx),%eax
  801e10:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e13:	75 06                	jne    801e1b <argnext+0x6d>
  801e15:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e19:	74 0e                	je     801e29 <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801e1b:	8b 53 08             	mov    0x8(%ebx),%edx
  801e1e:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801e21:	83 c2 01             	add    $0x1,%edx
  801e24:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801e27:	eb 13                	jmp    801e3c <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801e29:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801e30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e35:	eb 05                	jmp    801e3c <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801e3c:	83 c4 14             	add    $0x14,%esp
  801e3f:	5b                   	pop    %ebx
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	53                   	push   %ebx
  801e46:	83 ec 14             	sub    $0x14,%esp
  801e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801e4c:	8b 43 08             	mov    0x8(%ebx),%eax
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	74 5a                	je     801ead <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801e53:	80 38 00             	cmpb   $0x0,(%eax)
  801e56:	74 0c                	je     801e64 <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801e58:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801e5b:	c7 43 08 21 38 80 00 	movl   $0x803821,0x8(%ebx)
  801e62:	eb 44                	jmp    801ea8 <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801e64:	8b 03                	mov    (%ebx),%eax
  801e66:	83 38 01             	cmpl   $0x1,(%eax)
  801e69:	7e 2f                	jle    801e9a <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801e6b:	8b 53 04             	mov    0x4(%ebx),%edx
  801e6e:	8b 4a 04             	mov    0x4(%edx),%ecx
  801e71:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e74:	8b 00                	mov    (%eax),%eax
  801e76:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801e7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e81:	8d 42 08             	lea    0x8(%edx),%eax
  801e84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e88:	83 c2 04             	add    $0x4,%edx
  801e8b:	89 14 24             	mov    %edx,(%esp)
  801e8e:	e8 73 f6 ff ff       	call   801506 <memmove>
		(*args->argc)--;
  801e93:	8b 03                	mov    (%ebx),%eax
  801e95:	83 28 01             	subl   $0x1,(%eax)
  801e98:	eb 0e                	jmp    801ea8 <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801e9a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801ea1:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801ea8:	8b 43 0c             	mov    0xc(%ebx),%eax
  801eab:	eb 05                	jmp    801eb2 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801eb2:	83 c4 14             	add    $0x14,%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5d                   	pop    %ebp
  801eb7:	c3                   	ret    

00801eb8 <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	83 ec 18             	sub    $0x18,%esp
  801ebe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801ec1:	8b 51 0c             	mov    0xc(%ecx),%edx
  801ec4:	89 d0                	mov    %edx,%eax
  801ec6:	85 d2                	test   %edx,%edx
  801ec8:	75 08                	jne    801ed2 <argvalue+0x1a>
  801eca:	89 0c 24             	mov    %ecx,(%esp)
  801ecd:	e8 70 ff ff ff       	call   801e42 <argnextvalue>
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    
  801ed4:	66 90                	xchg   %ax,%ax
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	66 90                	xchg   %ax,%ax
  801eda:	66 90                	xchg   %ax,%ax
  801edc:	66 90                	xchg   %ax,%ax
  801ede:	66 90                	xchg   %ax,%ax

00801ee0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	05 00 00 00 30       	add    $0x30000000,%eax
  801eeb:	c1 e8 0c             	shr    $0xc,%eax
}
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    

00801ef0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801efb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f00:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801f05:	5d                   	pop    %ebp
  801f06:	c3                   	ret    

00801f07 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f0a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801f0f:	a8 01                	test   $0x1,%al
  801f11:	74 34                	je     801f47 <fd_alloc+0x40>
  801f13:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801f18:	a8 01                	test   $0x1,%al
  801f1a:	74 32                	je     801f4e <fd_alloc+0x47>
  801f1c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801f21:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f23:	89 c2                	mov    %eax,%edx
  801f25:	c1 ea 16             	shr    $0x16,%edx
  801f28:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f2f:	f6 c2 01             	test   $0x1,%dl
  801f32:	74 1f                	je     801f53 <fd_alloc+0x4c>
  801f34:	89 c2                	mov    %eax,%edx
  801f36:	c1 ea 0c             	shr    $0xc,%edx
  801f39:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f40:	f6 c2 01             	test   $0x1,%dl
  801f43:	75 1a                	jne    801f5f <fd_alloc+0x58>
  801f45:	eb 0c                	jmp    801f53 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801f47:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801f4c:	eb 05                	jmp    801f53 <fd_alloc+0x4c>
  801f4e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 08                	mov    %ecx,(%eax)
			return 0;
  801f58:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5d:	eb 1a                	jmp    801f79 <fd_alloc+0x72>
  801f5f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f64:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801f69:	75 b6                	jne    801f21 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801f74:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801f79:	5d                   	pop    %ebp
  801f7a:	c3                   	ret    

00801f7b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f81:	83 f8 1f             	cmp    $0x1f,%eax
  801f84:	77 36                	ja     801fbc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801f86:	c1 e0 0c             	shl    $0xc,%eax
  801f89:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f8e:	89 c2                	mov    %eax,%edx
  801f90:	c1 ea 16             	shr    $0x16,%edx
  801f93:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f9a:	f6 c2 01             	test   $0x1,%dl
  801f9d:	74 24                	je     801fc3 <fd_lookup+0x48>
  801f9f:	89 c2                	mov    %eax,%edx
  801fa1:	c1 ea 0c             	shr    $0xc,%edx
  801fa4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801fab:	f6 c2 01             	test   $0x1,%dl
  801fae:	74 1a                	je     801fca <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801fb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb3:	89 02                	mov    %eax,(%edx)
	return 0;
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fba:	eb 13                	jmp    801fcf <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fbc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc1:	eb 0c                	jmp    801fcf <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fc3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fc8:	eb 05                	jmp    801fcf <fd_lookup+0x54>
  801fca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801fcf:	5d                   	pop    %ebp
  801fd0:	c3                   	ret    

00801fd1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	53                   	push   %ebx
  801fd5:	83 ec 14             	sub    $0x14,%esp
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801fde:	39 05 20 50 80 00    	cmp    %eax,0x805020
  801fe4:	75 1e                	jne    802004 <dev_lookup+0x33>
  801fe6:	eb 0e                	jmp    801ff6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fe8:	b8 3c 50 80 00       	mov    $0x80503c,%eax
  801fed:	eb 0c                	jmp    801ffb <dev_lookup+0x2a>
  801fef:	b8 00 50 80 00       	mov    $0x805000,%eax
  801ff4:	eb 05                	jmp    801ffb <dev_lookup+0x2a>
  801ff6:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801ffb:	89 03                	mov    %eax,(%ebx)
			return 0;
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	eb 38                	jmp    80203c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  802004:	39 05 3c 50 80 00    	cmp    %eax,0x80503c
  80200a:	74 dc                	je     801fe8 <dev_lookup+0x17>
  80200c:	39 05 00 50 80 00    	cmp    %eax,0x805000
  802012:	74 db                	je     801fef <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802014:	8b 15 24 64 80 00    	mov    0x806424,%edx
  80201a:	8b 52 48             	mov    0x48(%edx),%edx
  80201d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802021:	89 54 24 04          	mov    %edx,0x4(%esp)
  802025:	c7 04 24 ac 3e 80 00 	movl   $0x803eac,(%esp)
  80202c:	e8 8f eb ff ff       	call   800bc0 <cprintf>
	*dev = 0;
  802031:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  802037:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80203c:	83 c4 14             	add    $0x14,%esp
  80203f:	5b                   	pop    %ebx
  802040:	5d                   	pop    %ebp
  802041:	c3                   	ret    

00802042 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 20             	sub    $0x20,%esp
  80204a:	8b 75 08             	mov    0x8(%ebp),%esi
  80204d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802050:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802053:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802057:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80205d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802060:	89 04 24             	mov    %eax,(%esp)
  802063:	e8 13 ff ff ff       	call   801f7b <fd_lookup>
  802068:	85 c0                	test   %eax,%eax
  80206a:	78 05                	js     802071 <fd_close+0x2f>
	    || fd != fd2)
  80206c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80206f:	74 0c                	je     80207d <fd_close+0x3b>
		return (must_exist ? r : 0);
  802071:	84 db                	test   %bl,%bl
  802073:	ba 00 00 00 00       	mov    $0x0,%edx
  802078:	0f 44 c2             	cmove  %edx,%eax
  80207b:	eb 3f                	jmp    8020bc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80207d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802080:	89 44 24 04          	mov    %eax,0x4(%esp)
  802084:	8b 06                	mov    (%esi),%eax
  802086:	89 04 24             	mov    %eax,(%esp)
  802089:	e8 43 ff ff ff       	call   801fd1 <dev_lookup>
  80208e:	89 c3                	mov    %eax,%ebx
  802090:	85 c0                	test   %eax,%eax
  802092:	78 16                	js     8020aa <fd_close+0x68>
		if (dev->dev_close)
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80209a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	74 07                	je     8020aa <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8020a3:	89 34 24             	mov    %esi,(%esp)
  8020a6:	ff d0                	call   *%eax
  8020a8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8020aa:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b5:	e8 a6 f7 ff ff       	call   801860 <sys_page_unmap>
	return r;
  8020ba:	89 d8                	mov    %ebx,%eax
}
  8020bc:	83 c4 20             	add    $0x20,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5e                   	pop    %esi
  8020c1:	5d                   	pop    %ebp
  8020c2:	c3                   	ret    

008020c3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
  8020c6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d3:	89 04 24             	mov    %eax,(%esp)
  8020d6:	e8 a0 fe ff ff       	call   801f7b <fd_lookup>
  8020db:	89 c2                	mov    %eax,%edx
  8020dd:	85 d2                	test   %edx,%edx
  8020df:	78 13                	js     8020f4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8020e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8020e8:	00 
  8020e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ec:	89 04 24             	mov    %eax,(%esp)
  8020ef:	e8 4e ff ff ff       	call   802042 <fd_close>
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <close_all>:

void
close_all(void)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	53                   	push   %ebx
  8020fa:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802102:	89 1c 24             	mov    %ebx,(%esp)
  802105:	e8 b9 ff ff ff       	call   8020c3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80210a:	83 c3 01             	add    $0x1,%ebx
  80210d:	83 fb 20             	cmp    $0x20,%ebx
  802110:	75 f0                	jne    802102 <close_all+0xc>
		close(i);
}
  802112:	83 c4 14             	add    $0x14,%esp
  802115:	5b                   	pop    %ebx
  802116:	5d                   	pop    %ebp
  802117:	c3                   	ret    

00802118 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	57                   	push   %edi
  80211c:	56                   	push   %esi
  80211d:	53                   	push   %ebx
  80211e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802121:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802124:	89 44 24 04          	mov    %eax,0x4(%esp)
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 48 fe ff ff       	call   801f7b <fd_lookup>
  802133:	89 c2                	mov    %eax,%edx
  802135:	85 d2                	test   %edx,%edx
  802137:	0f 88 e1 00 00 00    	js     80221e <dup+0x106>
		return r;
	close(newfdnum);
  80213d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802140:	89 04 24             	mov    %eax,(%esp)
  802143:	e8 7b ff ff ff       	call   8020c3 <close>

	newfd = INDEX2FD(newfdnum);
  802148:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80214b:	c1 e3 0c             	shl    $0xc,%ebx
  80214e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802157:	89 04 24             	mov    %eax,(%esp)
  80215a:	e8 91 fd ff ff       	call   801ef0 <fd2data>
  80215f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802161:	89 1c 24             	mov    %ebx,(%esp)
  802164:	e8 87 fd ff ff       	call   801ef0 <fd2data>
  802169:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80216b:	89 f0                	mov    %esi,%eax
  80216d:	c1 e8 16             	shr    $0x16,%eax
  802170:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802177:	a8 01                	test   $0x1,%al
  802179:	74 43                	je     8021be <dup+0xa6>
  80217b:	89 f0                	mov    %esi,%eax
  80217d:	c1 e8 0c             	shr    $0xc,%eax
  802180:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802187:	f6 c2 01             	test   $0x1,%dl
  80218a:	74 32                	je     8021be <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80218c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802193:	25 07 0e 00 00       	and    $0xe07,%eax
  802198:	89 44 24 10          	mov    %eax,0x10(%esp)
  80219c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021a7:	00 
  8021a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b3:	e8 55 f6 ff ff       	call   80180d <sys_page_map>
  8021b8:	89 c6                	mov    %eax,%esi
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	78 3e                	js     8021fc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021c1:	89 c2                	mov    %eax,%edx
  8021c3:	c1 ea 0c             	shr    $0xc,%edx
  8021c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021cd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8021d3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021d7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021e2:	00 
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ee:	e8 1a f6 ff ff       	call   80180d <sys_page_map>
  8021f3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021f8:	85 f6                	test   %esi,%esi
  8021fa:	79 22                	jns    80221e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8021fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 54 f6 ff ff       	call   801860 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80220c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802210:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802217:	e8 44 f6 ff ff       	call   801860 <sys_page_unmap>
	return r;
  80221c:	89 f0                	mov    %esi,%eax
}
  80221e:	83 c4 3c             	add    $0x3c,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5f                   	pop    %edi
  802224:	5d                   	pop    %ebp
  802225:	c3                   	ret    

00802226 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	53                   	push   %ebx
  80222a:	83 ec 24             	sub    $0x24,%esp
  80222d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802230:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802233:	89 44 24 04          	mov    %eax,0x4(%esp)
  802237:	89 1c 24             	mov    %ebx,(%esp)
  80223a:	e8 3c fd ff ff       	call   801f7b <fd_lookup>
  80223f:	89 c2                	mov    %eax,%edx
  802241:	85 d2                	test   %edx,%edx
  802243:	78 6d                	js     8022b2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802245:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802248:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	89 04 24             	mov    %eax,(%esp)
  802254:	e8 78 fd ff ff       	call   801fd1 <dev_lookup>
  802259:	85 c0                	test   %eax,%eax
  80225b:	78 55                	js     8022b2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80225d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802260:	8b 50 08             	mov    0x8(%eax),%edx
  802263:	83 e2 03             	and    $0x3,%edx
  802266:	83 fa 01             	cmp    $0x1,%edx
  802269:	75 23                	jne    80228e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80226b:	a1 24 64 80 00       	mov    0x806424,%eax
  802270:	8b 40 48             	mov    0x48(%eax),%eax
  802273:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802277:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227b:	c7 04 24 ed 3e 80 00 	movl   $0x803eed,(%esp)
  802282:	e8 39 e9 ff ff       	call   800bc0 <cprintf>
		return -E_INVAL;
  802287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80228c:	eb 24                	jmp    8022b2 <read+0x8c>
	}
	if (!dev->dev_read)
  80228e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802291:	8b 52 08             	mov    0x8(%edx),%edx
  802294:	85 d2                	test   %edx,%edx
  802296:	74 15                	je     8022ad <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802298:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80229f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022a6:	89 04 24             	mov    %eax,(%esp)
  8022a9:	ff d2                	call   *%edx
  8022ab:	eb 05                	jmp    8022b2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8022ad:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8022b2:	83 c4 24             	add    $0x24,%esp
  8022b5:	5b                   	pop    %ebx
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    

008022b8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
  8022bb:	57                   	push   %edi
  8022bc:	56                   	push   %esi
  8022bd:	53                   	push   %ebx
  8022be:	83 ec 1c             	sub    $0x1c,%esp
  8022c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022c4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022c7:	85 f6                	test   %esi,%esi
  8022c9:	74 33                	je     8022fe <readn+0x46>
  8022cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022d5:	89 f2                	mov    %esi,%edx
  8022d7:	29 c2                	sub    %eax,%edx
  8022d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022dd:	03 45 0c             	add    0xc(%ebp),%eax
  8022e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e4:	89 3c 24             	mov    %edi,(%esp)
  8022e7:	e8 3a ff ff ff       	call   802226 <read>
		if (m < 0)
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	78 1b                	js     80230b <readn+0x53>
			return m;
		if (m == 0)
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 11                	je     802305 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022f4:	01 c3                	add    %eax,%ebx
  8022f6:	89 d8                	mov    %ebx,%eax
  8022f8:	39 f3                	cmp    %esi,%ebx
  8022fa:	72 d9                	jb     8022d5 <readn+0x1d>
  8022fc:	eb 0b                	jmp    802309 <readn+0x51>
  8022fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802303:	eb 06                	jmp    80230b <readn+0x53>
  802305:	89 d8                	mov    %ebx,%eax
  802307:	eb 02                	jmp    80230b <readn+0x53>
  802309:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80230b:	83 c4 1c             	add    $0x1c,%esp
  80230e:	5b                   	pop    %ebx
  80230f:	5e                   	pop    %esi
  802310:	5f                   	pop    %edi
  802311:	5d                   	pop    %ebp
  802312:	c3                   	ret    

00802313 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	53                   	push   %ebx
  802317:	83 ec 24             	sub    $0x24,%esp
  80231a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80231d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802320:	89 44 24 04          	mov    %eax,0x4(%esp)
  802324:	89 1c 24             	mov    %ebx,(%esp)
  802327:	e8 4f fc ff ff       	call   801f7b <fd_lookup>
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	85 d2                	test   %edx,%edx
  802330:	78 68                	js     80239a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802332:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802335:	89 44 24 04          	mov    %eax,0x4(%esp)
  802339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	89 04 24             	mov    %eax,(%esp)
  802341:	e8 8b fc ff ff       	call   801fd1 <dev_lookup>
  802346:	85 c0                	test   %eax,%eax
  802348:	78 50                	js     80239a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80234a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802351:	75 23                	jne    802376 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802353:	a1 24 64 80 00       	mov    0x806424,%eax
  802358:	8b 40 48             	mov    0x48(%eax),%eax
  80235b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80235f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802363:	c7 04 24 09 3f 80 00 	movl   $0x803f09,(%esp)
  80236a:	e8 51 e8 ff ff       	call   800bc0 <cprintf>
		return -E_INVAL;
  80236f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802374:	eb 24                	jmp    80239a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	8b 52 0c             	mov    0xc(%edx),%edx
  80237c:	85 d2                	test   %edx,%edx
  80237e:	74 15                	je     802395 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802380:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802383:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80238a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80238e:	89 04 24             	mov    %eax,(%esp)
  802391:	ff d2                	call   *%edx
  802393:	eb 05                	jmp    80239a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802395:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80239a:	83 c4 24             	add    $0x24,%esp
  80239d:	5b                   	pop    %ebx
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    

008023a0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023a6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8023a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b0:	89 04 24             	mov    %eax,(%esp)
  8023b3:	e8 c3 fb ff ff       	call   801f7b <fd_lookup>
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	78 0e                	js     8023ca <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8023bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8023c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	53                   	push   %ebx
  8023d0:	83 ec 24             	sub    $0x24,%esp
  8023d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023dd:	89 1c 24             	mov    %ebx,(%esp)
  8023e0:	e8 96 fb ff ff       	call   801f7b <fd_lookup>
  8023e5:	89 c2                	mov    %eax,%edx
  8023e7:	85 d2                	test   %edx,%edx
  8023e9:	78 61                	js     80244c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	89 04 24             	mov    %eax,(%esp)
  8023fa:	e8 d2 fb ff ff       	call   801fd1 <dev_lookup>
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 49                	js     80244c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80240a:	75 23                	jne    80242f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80240c:	a1 24 64 80 00       	mov    0x806424,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802411:	8b 40 48             	mov    0x48(%eax),%eax
  802414:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80241c:	c7 04 24 cc 3e 80 00 	movl   $0x803ecc,(%esp)
  802423:	e8 98 e7 ff ff       	call   800bc0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802428:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80242d:	eb 1d                	jmp    80244c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80242f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802432:	8b 52 18             	mov    0x18(%edx),%edx
  802435:	85 d2                	test   %edx,%edx
  802437:	74 0e                	je     802447 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802439:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80243c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802440:	89 04 24             	mov    %eax,(%esp)
  802443:	ff d2                	call   *%edx
  802445:	eb 05                	jmp    80244c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  802447:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80244c:	83 c4 24             	add    $0x24,%esp
  80244f:	5b                   	pop    %ebx
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    

00802452 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	53                   	push   %ebx
  802456:	83 ec 24             	sub    $0x24,%esp
  802459:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80245c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80245f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	89 04 24             	mov    %eax,(%esp)
  802469:	e8 0d fb ff ff       	call   801f7b <fd_lookup>
  80246e:	89 c2                	mov    %eax,%edx
  802470:	85 d2                	test   %edx,%edx
  802472:	78 52                	js     8024c6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802477:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	89 04 24             	mov    %eax,(%esp)
  802483:	e8 49 fb ff ff       	call   801fd1 <dev_lookup>
  802488:	85 c0                	test   %eax,%eax
  80248a:	78 3a                	js     8024c6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802493:	74 2c                	je     8024c1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802495:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802498:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80249f:	00 00 00 
	stat->st_isdir = 0;
  8024a2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024a9:	00 00 00 
	stat->st_dev = dev;
  8024ac:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8024b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b9:	89 14 24             	mov    %edx,(%esp)
  8024bc:	ff 50 14             	call   *0x14(%eax)
  8024bf:	eb 05                	jmp    8024c6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8024c1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8024c6:	83 c4 24             	add    $0x24,%esp
  8024c9:	5b                   	pop    %ebx
  8024ca:	5d                   	pop    %ebp
  8024cb:	c3                   	ret    

008024cc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024cc:	55                   	push   %ebp
  8024cd:	89 e5                	mov    %esp,%ebp
  8024cf:	56                   	push   %esi
  8024d0:	53                   	push   %ebx
  8024d1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024db:	00 
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 af 01 00 00       	call   802696 <open>
  8024e7:	89 c3                	mov    %eax,%ebx
  8024e9:	85 db                	test   %ebx,%ebx
  8024eb:	78 1b                	js     802508 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8024ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f4:	89 1c 24             	mov    %ebx,(%esp)
  8024f7:	e8 56 ff ff ff       	call   802452 <fstat>
  8024fc:	89 c6                	mov    %eax,%esi
	close(fd);
  8024fe:	89 1c 24             	mov    %ebx,(%esp)
  802501:	e8 bd fb ff ff       	call   8020c3 <close>
	return r;
  802506:	89 f0                	mov    %esi,%eax
}
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	5b                   	pop    %ebx
  80250c:	5e                   	pop    %esi
  80250d:	5d                   	pop    %ebp
  80250e:	c3                   	ret    

0080250f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
  802512:	56                   	push   %esi
  802513:	53                   	push   %ebx
  802514:	83 ec 10             	sub    $0x10,%esp
  802517:	89 c6                	mov    %eax,%esi
  802519:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80251b:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802522:	75 11                	jne    802535 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802524:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80252b:	e8 b3 0f 00 00       	call   8034e3 <ipc_find_env>
  802530:	a3 20 64 80 00       	mov    %eax,0x806420
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802535:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80253c:	00 
  80253d:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802544:	00 
  802545:	89 74 24 04          	mov    %esi,0x4(%esp)
  802549:	a1 20 64 80 00       	mov    0x806420,%eax
  80254e:	89 04 24             	mov    %eax,(%esp)
  802551:	e8 27 0f 00 00       	call   80347d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802556:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80255d:	00 
  80255e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802562:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802569:	e8 a7 0e 00 00       	call   803415 <ipc_recv>
}
  80256e:	83 c4 10             	add    $0x10,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5d                   	pop    %ebp
  802574:	c3                   	ret    

00802575 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	53                   	push   %ebx
  802579:	83 ec 14             	sub    $0x14,%esp
  80257c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80257f:	8b 45 08             	mov    0x8(%ebp),%eax
  802582:	8b 40 0c             	mov    0xc(%eax),%eax
  802585:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80258a:	ba 00 00 00 00       	mov    $0x0,%edx
  80258f:	b8 05 00 00 00       	mov    $0x5,%eax
  802594:	e8 76 ff ff ff       	call   80250f <fsipc>
  802599:	89 c2                	mov    %eax,%edx
  80259b:	85 d2                	test   %edx,%edx
  80259d:	78 2b                	js     8025ca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80259f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8025a6:	00 
  8025a7:	89 1c 24             	mov    %ebx,(%esp)
  8025aa:	e8 5c ed ff ff       	call   80130b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8025af:	a1 80 70 80 00       	mov    0x807080,%eax
  8025b4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8025ba:	a1 84 70 80 00       	mov    0x807084,%eax
  8025bf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ca:	83 c4 14             	add    $0x14,%esp
  8025cd:	5b                   	pop    %ebx
  8025ce:	5d                   	pop    %ebp
  8025cf:	c3                   	ret    

008025d0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025dc:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8025e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8025e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8025eb:	e8 1f ff ff ff       	call   80250f <fsipc>
}
  8025f0:	c9                   	leave  
  8025f1:	c3                   	ret    

008025f2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	56                   	push   %esi
  8025f6:	53                   	push   %ebx
  8025f7:	83 ec 10             	sub    $0x10,%esp
  8025fa:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8025fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802600:	8b 40 0c             	mov    0xc(%eax),%eax
  802603:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  802608:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80260e:	ba 00 00 00 00       	mov    $0x0,%edx
  802613:	b8 03 00 00 00       	mov    $0x3,%eax
  802618:	e8 f2 fe ff ff       	call   80250f <fsipc>
  80261d:	89 c3                	mov    %eax,%ebx
  80261f:	85 c0                	test   %eax,%eax
  802621:	78 6a                	js     80268d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802623:	39 c6                	cmp    %eax,%esi
  802625:	73 24                	jae    80264b <devfile_read+0x59>
  802627:	c7 44 24 0c 26 3f 80 	movl   $0x803f26,0xc(%esp)
  80262e:	00 
  80262f:	c7 44 24 08 52 39 80 	movl   $0x803952,0x8(%esp)
  802636:	00 
  802637:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80263e:	00 
  80263f:	c7 04 24 2d 3f 80 00 	movl   $0x803f2d,(%esp)
  802646:	e8 7c e4 ff ff       	call   800ac7 <_panic>
	assert(r <= PGSIZE);
  80264b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802650:	7e 24                	jle    802676 <devfile_read+0x84>
  802652:	c7 44 24 0c 38 3f 80 	movl   $0x803f38,0xc(%esp)
  802659:	00 
  80265a:	c7 44 24 08 52 39 80 	movl   $0x803952,0x8(%esp)
  802661:	00 
  802662:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802669:	00 
  80266a:	c7 04 24 2d 3f 80 00 	movl   $0x803f2d,(%esp)
  802671:	e8 51 e4 ff ff       	call   800ac7 <_panic>
	memmove(buf, &fsipcbuf, r);
  802676:	89 44 24 08          	mov    %eax,0x8(%esp)
  80267a:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802681:	00 
  802682:	8b 45 0c             	mov    0xc(%ebp),%eax
  802685:	89 04 24             	mov    %eax,(%esp)
  802688:	e8 79 ee ff ff       	call   801506 <memmove>
	return r;
}
  80268d:	89 d8                	mov    %ebx,%eax
  80268f:	83 c4 10             	add    $0x10,%esp
  802692:	5b                   	pop    %ebx
  802693:	5e                   	pop    %esi
  802694:	5d                   	pop    %ebp
  802695:	c3                   	ret    

00802696 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	53                   	push   %ebx
  80269a:	83 ec 24             	sub    $0x24,%esp
  80269d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8026a0:	89 1c 24             	mov    %ebx,(%esp)
  8026a3:	e8 08 ec ff ff       	call   8012b0 <strlen>
  8026a8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026ad:	7f 60                	jg     80270f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8026af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b2:	89 04 24             	mov    %eax,(%esp)
  8026b5:	e8 4d f8 ff ff       	call   801f07 <fd_alloc>
  8026ba:	89 c2                	mov    %eax,%edx
  8026bc:	85 d2                	test   %edx,%edx
  8026be:	78 54                	js     802714 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8026c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026c4:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8026cb:	e8 3b ec ff ff       	call   80130b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8026d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026d3:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8026d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026db:	b8 01 00 00 00       	mov    $0x1,%eax
  8026e0:	e8 2a fe ff ff       	call   80250f <fsipc>
  8026e5:	89 c3                	mov    %eax,%ebx
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	79 17                	jns    802702 <open+0x6c>
		fd_close(fd, 0);
  8026eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026f2:	00 
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	89 04 24             	mov    %eax,(%esp)
  8026f9:	e8 44 f9 ff ff       	call   802042 <fd_close>
		return r;
  8026fe:	89 d8                	mov    %ebx,%eax
  802700:	eb 12                	jmp    802714 <open+0x7e>
	}
	return fd2num(fd);
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	89 04 24             	mov    %eax,(%esp)
  802708:	e8 d3 f7 ff ff       	call   801ee0 <fd2num>
  80270d:	eb 05                	jmp    802714 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80270f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  802714:	83 c4 24             	add    $0x24,%esp
  802717:	5b                   	pop    %ebx
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    

0080271a <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80271a:	55                   	push   %ebp
  80271b:	89 e5                	mov    %esp,%ebp
  80271d:	53                   	push   %ebx
  80271e:	83 ec 14             	sub    $0x14,%esp
  802721:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  802723:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802727:	7e 31                	jle    80275a <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  802729:	8b 40 04             	mov    0x4(%eax),%eax
  80272c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802730:	8d 43 10             	lea    0x10(%ebx),%eax
  802733:	89 44 24 04          	mov    %eax,0x4(%esp)
  802737:	8b 03                	mov    (%ebx),%eax
  802739:	89 04 24             	mov    %eax,(%esp)
  80273c:	e8 d2 fb ff ff       	call   802313 <write>
		if (result > 0)
  802741:	85 c0                	test   %eax,%eax
  802743:	7e 03                	jle    802748 <writebuf+0x2e>
			b->result += result;
  802745:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802748:	39 43 04             	cmp    %eax,0x4(%ebx)
  80274b:	74 0d                	je     80275a <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80274d:	85 c0                	test   %eax,%eax
  80274f:	ba 00 00 00 00       	mov    $0x0,%edx
  802754:	0f 4f c2             	cmovg  %edx,%eax
  802757:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80275a:	83 c4 14             	add    $0x14,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    

00802760 <putch>:

static void
putch(int ch, void *thunk)
{
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	53                   	push   %ebx
  802764:	83 ec 04             	sub    $0x4,%esp
  802767:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80276a:	8b 53 04             	mov    0x4(%ebx),%edx
  80276d:	8d 42 01             	lea    0x1(%edx),%eax
  802770:	89 43 04             	mov    %eax,0x4(%ebx)
  802773:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802776:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80277a:	3d 00 01 00 00       	cmp    $0x100,%eax
  80277f:	75 0e                	jne    80278f <putch+0x2f>
		writebuf(b);
  802781:	89 d8                	mov    %ebx,%eax
  802783:	e8 92 ff ff ff       	call   80271a <writebuf>
		b->idx = 0;
  802788:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  80278f:	83 c4 04             	add    $0x4,%esp
  802792:	5b                   	pop    %ebx
  802793:	5d                   	pop    %ebp
  802794:	c3                   	ret    

00802795 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802795:	55                   	push   %ebp
  802796:	89 e5                	mov    %esp,%ebp
  802798:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  80279e:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8027a7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8027ae:	00 00 00 
	b.result = 0;
  8027b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8027b8:	00 00 00 
	b.error = 1;
  8027bb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8027c2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8027c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027d3:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8027d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027dd:	c7 04 24 60 27 80 00 	movl   $0x802760,(%esp)
  8027e4:	e8 6b e5 ff ff       	call   800d54 <vprintfmt>
	if (b.idx > 0)
  8027e9:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8027f0:	7e 0b                	jle    8027fd <vfprintf+0x68>
		writebuf(&b);
  8027f2:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8027f8:	e8 1d ff ff ff       	call   80271a <writebuf>

	return (b.result ? b.result : b.error);
  8027fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802814:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802817:	89 44 24 08          	mov    %eax,0x8(%esp)
  80281b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	89 04 24             	mov    %eax,(%esp)
  802828:	e8 68 ff ff ff       	call   802795 <vfprintf>
	va_end(ap);

	return cnt;
}
  80282d:	c9                   	leave  
  80282e:	c3                   	ret    

0080282f <printf>:

int
printf(const char *fmt, ...)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802835:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802838:	89 44 24 08          	mov    %eax,0x8(%esp)
  80283c:	8b 45 08             	mov    0x8(%ebp),%eax
  80283f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802843:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80284a:	e8 46 ff ff ff       	call   802795 <vfprintf>
	va_end(ap);

	return cnt;
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    
  802851:	66 90                	xchg   %ax,%ax
  802853:	66 90                	xchg   %ax,%ax
  802855:	66 90                	xchg   %ax,%ax
  802857:	66 90                	xchg   %ax,%ax
  802859:	66 90                	xchg   %ax,%ax
  80285b:	66 90                	xchg   %ax,%ax
  80285d:	66 90                	xchg   %ax,%ax
  80285f:	90                   	nop

00802860 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	57                   	push   %edi
  802864:	56                   	push   %esi
  802865:	53                   	push   %ebx
  802866:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
  80286c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open. %s\n", prog);
  80286f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802873:	c7 04 24 44 3f 80 00 	movl   $0x803f44,(%esp)
  80287a:	e8 41 e3 ff ff       	call   800bc0 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0) {
  80287f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802886:	00 
  802887:	89 1c 24             	mov    %ebx,(%esp)
  80288a:	e8 07 fe ff ff       	call   802696 <open>
  80288f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  802895:	85 c0                	test   %eax,%eax
  802897:	79 17                	jns    8028b0 <spawn+0x50>
		cprintf("cannot\n");
  802899:	c7 04 24 4e 3f 80 00 	movl   $0x803f4e,(%esp)
  8028a0:	e8 1b e3 ff ff       	call   800bc0 <cprintf>
		return r;
  8028a5:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028ab:	e9 ea 05 00 00       	jmp    802e9a <spawn+0x63a>
	}
	fd = r;

	cprintf("read elf header.\n");
  8028b0:	c7 04 24 56 3f 80 00 	movl   $0x803f56,(%esp)
  8028b7:	e8 04 e3 ff ff       	call   800bc0 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8028bc:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8028c3:	00 
  8028c4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8028ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ce:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028d4:	89 04 24             	mov    %eax,(%esp)
  8028d7:	e8 dc f9 ff ff       	call   8022b8 <readn>
  8028dc:	3d 00 02 00 00       	cmp    $0x200,%eax
  8028e1:	75 0c                	jne    8028ef <spawn+0x8f>
	    || elf->e_magic != ELF_MAGIC) {
  8028e3:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8028ea:	45 4c 46 
  8028ed:	74 36                	je     802925 <spawn+0xc5>
		close(fd);
  8028ef:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028f5:	89 04 24             	mov    %eax,(%esp)
  8028f8:	e8 c6 f7 ff ff       	call   8020c3 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  8028fd:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802904:	46 
  802905:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  80290b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290f:	c7 04 24 68 3f 80 00 	movl   $0x803f68,(%esp)
  802916:	e8 a5 e2 ff ff       	call   800bc0 <cprintf>
		return -E_NOT_EXEC;
  80291b:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802920:	e9 75 05 00 00       	jmp    802e9a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
  802925:	c7 04 24 82 3f 80 00 	movl   $0x803f82,(%esp)
  80292c:	e8 8f e2 ff ff       	call   800bc0 <cprintf>
  802931:	b8 07 00 00 00       	mov    $0x7,%eax
  802936:	cd 30                	int    $0x30
  802938:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80293e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802944:	85 c0                	test   %eax,%eax
  802946:	0f 88 ff 04 00 00    	js     802e4b <spawn+0x5eb>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80294c:	89 c6                	mov    %eax,%esi
  80294e:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802954:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802957:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  80295d:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802963:	b9 11 00 00 00       	mov    $0x11,%ecx
  802968:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80296a:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802970:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  802976:	c7 04 24 8f 3f 80 00 	movl   $0x803f8f,(%esp)
  80297d:	e8 3e e2 ff ff       	call   800bc0 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802982:	8b 45 0c             	mov    0xc(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	74 38                	je     8029c3 <spawn+0x163>
  80298b:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802990:	be 00 00 00 00       	mov    $0x0,%esi
  802995:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  802998:	89 04 24             	mov    %eax,(%esp)
  80299b:	e8 10 e9 ff ff       	call   8012b0 <strlen>
  8029a0:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8029a4:	83 c3 01             	add    $0x1,%ebx
  8029a7:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8029ae:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8029b1:	85 c0                	test   %eax,%eax
  8029b3:	75 e3                	jne    802998 <spawn+0x138>
  8029b5:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8029bb:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8029c1:	eb 1e                	jmp    8029e1 <spawn+0x181>
  8029c3:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  8029ca:	00 00 00 
  8029cd:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  8029d4:	00 00 00 
  8029d7:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8029dc:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8029e1:	bf 00 10 40 00       	mov    $0x401000,%edi
  8029e6:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8029e8:	89 fa                	mov    %edi,%edx
  8029ea:	83 e2 fc             	and    $0xfffffffc,%edx
  8029ed:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8029f4:	29 c2                	sub    %eax,%edx
  8029f6:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  8029fc:	8d 42 f8             	lea    -0x8(%edx),%eax
  8029ff:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802a04:	0f 86 49 04 00 00    	jbe    802e53 <spawn+0x5f3>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802a0a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a11:	00 
  802a12:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a19:	00 
  802a1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a21:	e8 93 ed ff ff       	call   8017b9 <sys_page_alloc>
  802a26:	85 c0                	test   %eax,%eax
  802a28:	0f 88 6c 04 00 00    	js     802e9a <spawn+0x63a>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a2e:	85 db                	test   %ebx,%ebx
  802a30:	7e 46                	jle    802a78 <spawn+0x218>
  802a32:	be 00 00 00 00       	mov    $0x0,%esi
  802a37:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802a3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  802a40:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802a46:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802a4c:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802a4f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802a52:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a56:	89 3c 24             	mov    %edi,(%esp)
  802a59:	e8 ad e8 ff ff       	call   80130b <strcpy>
		string_store += strlen(argv[i]) + 1;
  802a5e:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802a61:	89 04 24             	mov    %eax,(%esp)
  802a64:	e8 47 e8 ff ff       	call   8012b0 <strlen>
  802a69:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a6d:	83 c6 01             	add    $0x1,%esi
  802a70:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  802a76:	75 c8                	jne    802a40 <spawn+0x1e0>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802a78:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802a7e:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802a84:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802a8b:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802a91:	74 24                	je     802ab7 <spawn+0x257>
  802a93:	c7 44 24 0c 14 40 80 	movl   $0x804014,0xc(%esp)
  802a9a:	00 
  802a9b:	c7 44 24 08 52 39 80 	movl   $0x803952,0x8(%esp)
  802aa2:	00 
  802aa3:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  802aaa:	00 
  802aab:	c7 04 24 9b 3f 80 00 	movl   $0x803f9b,(%esp)
  802ab2:	e8 10 e0 ff ff       	call   800ac7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802ab7:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802abd:	89 c8                	mov    %ecx,%eax
  802abf:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802ac4:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802ac7:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802acd:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802ad0:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802ad6:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802adc:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802ae3:	00 
  802ae4:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802aeb:	ee 
  802aec:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802af2:	89 44 24 08          	mov    %eax,0x8(%esp)
  802af6:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802afd:	00 
  802afe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b05:	e8 03 ed ff ff       	call   80180d <sys_page_map>
  802b0a:	89 c3                	mov    %eax,%ebx
  802b0c:	85 c0                	test   %eax,%eax
  802b0e:	0f 88 70 03 00 00    	js     802e84 <spawn+0x624>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802b14:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b1b:	00 
  802b1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b23:	e8 38 ed ff ff       	call   801860 <sys_page_unmap>
  802b28:	89 c3                	mov    %eax,%ebx
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	0f 88 52 03 00 00    	js     802e84 <spawn+0x624>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  802b32:	c7 04 24 a7 3f 80 00 	movl   $0x803fa7,(%esp)
  802b39:	e8 82 e0 ff ff       	call   800bc0 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b3e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802b44:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802b4b:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b51:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802b58:	00 
  802b59:	0f 84 dc 01 00 00    	je     802d3b <spawn+0x4db>
  802b5f:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802b66:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  802b69:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802b6f:	83 38 01             	cmpl   $0x1,(%eax)
  802b72:	0f 85 a2 01 00 00    	jne    802d1a <spawn+0x4ba>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b78:	89 c1                	mov    %eax,%ecx
  802b7a:	8b 40 18             	mov    0x18(%eax),%eax
  802b7d:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802b80:	83 f8 01             	cmp    $0x1,%eax
  802b83:	19 c0                	sbb    %eax,%eax
  802b85:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802b8b:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  802b92:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b99:	89 c8                	mov    %ecx,%eax
  802b9b:	8b 51 04             	mov    0x4(%ecx),%edx
  802b9e:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  802ba4:	8b 79 10             	mov    0x10(%ecx),%edi
  802ba7:	8b 49 14             	mov    0x14(%ecx),%ecx
  802baa:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802bb9:	25 ff 0f 00 00       	and    $0xfff,%eax
  802bbe:	74 14                	je     802bd4 <spawn+0x374>
		va -= i;
  802bc0:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  802bc6:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802bcc:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  802bce:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802bd4:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802bdb:	0f 84 39 01 00 00    	je     802d1a <spawn+0x4ba>
  802be1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802be6:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802beb:	39 f7                	cmp    %esi,%edi
  802bed:	77 31                	ja     802c20 <spawn+0x3c0>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802bef:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802bf5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bf9:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802bff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c03:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802c09:	89 04 24             	mov    %eax,(%esp)
  802c0c:	e8 a8 eb ff ff       	call   8017b9 <sys_page_alloc>
  802c11:	85 c0                	test   %eax,%eax
  802c13:	0f 89 ed 00 00 00    	jns    802d06 <spawn+0x4a6>
  802c19:	89 c3                	mov    %eax,%ebx
  802c1b:	e9 44 02 00 00       	jmp    802e64 <spawn+0x604>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c20:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c27:	00 
  802c28:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c2f:	00 
  802c30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c37:	e8 7d eb ff ff       	call   8017b9 <sys_page_alloc>
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	0f 88 16 02 00 00    	js     802e5a <spawn+0x5fa>
  802c44:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c4a:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c50:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c56:	89 04 24             	mov    %eax,(%esp)
  802c59:	e8 42 f7 ff ff       	call   8023a0 <seek>
  802c5e:	85 c0                	test   %eax,%eax
  802c60:	0f 88 f8 01 00 00    	js     802e5e <spawn+0x5fe>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802c66:	89 f9                	mov    %edi,%ecx
  802c68:	29 f1                	sub    %esi,%ecx
  802c6a:	89 c8                	mov    %ecx,%eax
  802c6c:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  802c72:	ba 00 10 00 00       	mov    $0x1000,%edx
  802c77:	0f 47 c2             	cmova  %edx,%eax
  802c7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c7e:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c85:	00 
  802c86:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c8c:	89 04 24             	mov    %eax,(%esp)
  802c8f:	e8 24 f6 ff ff       	call   8022b8 <readn>
  802c94:	85 c0                	test   %eax,%eax
  802c96:	0f 88 c6 01 00 00    	js     802e62 <spawn+0x602>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802c9c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802ca2:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ca6:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802cac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802cb0:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802cb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cba:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cc1:	00 
  802cc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cc9:	e8 3f eb ff ff       	call   80180d <sys_page_map>
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	79 20                	jns    802cf2 <spawn+0x492>
				panic("spawn: sys_page_map data: %e", r);
  802cd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cd6:	c7 44 24 08 b4 3f 80 	movl   $0x803fb4,0x8(%esp)
  802cdd:	00 
  802cde:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  802ce5:	00 
  802ce6:	c7 04 24 9b 3f 80 00 	movl   $0x803f9b,(%esp)
  802ced:	e8 d5 dd ff ff       	call   800ac7 <_panic>
			sys_page_unmap(0, UTEMP);
  802cf2:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cf9:	00 
  802cfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d01:	e8 5a eb ff ff       	call   801860 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802d06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d0c:	89 de                	mov    %ebx,%esi
  802d0e:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802d14:	0f 82 d1 fe ff ff    	jb     802beb <spawn+0x38b>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d1a:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802d21:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802d28:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802d2f:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  802d35:	0f 8f 2e fe ff ff    	jg     802b69 <spawn+0x309>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802d3b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d41:	89 04 24             	mov    %eax,(%esp)
  802d44:	e8 7a f3 ff ff       	call   8020c3 <close>

// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
  802d49:	bb 00 08 00 00       	mov    $0x800,%ebx
  802d4e:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {

		if (!(uvpd[pn_beg >> 10] & (PTE_P | PTE_U))) {
  802d54:	89 d8                	mov    %ebx,%eax
  802d56:	c1 e8 0a             	shr    $0xa,%eax
  802d59:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802d60:	a8 05                	test   $0x5,%al
  802d62:	74 52                	je     802db6 <spawn+0x556>
			continue;
		}

		const pte_t pte = uvpt[pn_beg];
  802d64:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax

		if (pte & PTE_SHARE) {
  802d6b:	f6 c4 04             	test   $0x4,%ah
  802d6e:	74 46                	je     802db6 <spawn+0x556>
  802d70:	89 da                	mov    %ebx,%edx
  802d72:	c1 e2 0c             	shl    $0xc,%edx
			void* va = (void*) (pn_beg * PGSIZE);
			int perm = pte & PTE_SYSCALL;
  802d75:	25 07 0e 00 00       	and    $0xe07,%eax
			int err_code;
			if ((err_code = sys_page_map(0, va, child, va, perm)) < 0) {
  802d7a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d7e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802d82:	89 74 24 08          	mov    %esi,0x8(%esp)
  802d86:	89 54 24 04          	mov    %edx,0x4(%esp)
  802d8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d91:	e8 77 ea ff ff       	call   80180d <sys_page_map>
  802d96:	85 c0                	test   %eax,%eax
  802d98:	79 1c                	jns    802db6 <spawn+0x556>
				panic("copy_shared_pages:sys_page_map");
  802d9a:	c7 44 24 08 3c 40 80 	movl   $0x80403c,0x8(%esp)
  802da1:	00 
  802da2:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
  802da9:	00 
  802daa:	c7 04 24 9b 3f 80 00 	movl   $0x803f9b,(%esp)
  802db1:	e8 11 dd ff ff       	call   800ac7 <_panic>
static int
copy_shared_pages(envid_t child)
{
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  802db6:	83 c3 01             	add    $0x1,%ebx
  802db9:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  802dbf:	75 93                	jne    802d54 <spawn+0x4f4>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802dc1:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802dc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dcb:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802dd1:	89 04 24             	mov    %eax,(%esp)
  802dd4:	e8 2d eb ff ff       	call   801906 <sys_env_set_trapframe>
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	79 20                	jns    802dfd <spawn+0x59d>
		panic("sys_env_set_trapframe: %e", r);
  802ddd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802de1:	c7 44 24 08 d1 3f 80 	movl   $0x803fd1,0x8(%esp)
  802de8:	00 
  802de9:	c7 44 24 04 8b 00 00 	movl   $0x8b,0x4(%esp)
  802df0:	00 
  802df1:	c7 04 24 9b 3f 80 00 	movl   $0x803f9b,(%esp)
  802df8:	e8 ca dc ff ff       	call   800ac7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802dfd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802e04:	00 
  802e05:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e0b:	89 04 24             	mov    %eax,(%esp)
  802e0e:	e8 a0 ea ff ff       	call   8018b3 <sys_env_set_status>
  802e13:	85 c0                	test   %eax,%eax
  802e15:	79 20                	jns    802e37 <spawn+0x5d7>
		panic("sys_env_set_status: %e", r);
  802e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e1b:	c7 44 24 08 eb 3f 80 	movl   $0x803feb,0x8(%esp)
  802e22:	00 
  802e23:	c7 44 24 04 8e 00 00 	movl   $0x8e,0x4(%esp)
  802e2a:	00 
  802e2b:	c7 04 24 9b 3f 80 00 	movl   $0x803f9b,(%esp)
  802e32:	e8 90 dc ff ff       	call   800ac7 <_panic>

	cprintf("spawn return.\n");
  802e37:	c7 04 24 02 40 80 00 	movl   $0x804002,(%esp)
  802e3e:	e8 7d dd ff ff       	call   800bc0 <cprintf>
	return child;
  802e43:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e49:	eb 4f                	jmp    802e9a <spawn+0x63a>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802e4b:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e51:	eb 47                	jmp    802e9a <spawn+0x63a>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802e53:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802e58:	eb 40                	jmp    802e9a <spawn+0x63a>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802e5a:	89 c3                	mov    %eax,%ebx
  802e5c:	eb 06                	jmp    802e64 <spawn+0x604>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802e5e:	89 c3                	mov    %eax,%ebx
  802e60:	eb 02                	jmp    802e64 <spawn+0x604>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802e62:	89 c3                	mov    %eax,%ebx

	cprintf("spawn return.\n");
	return child;

error:
	sys_env_destroy(child);
  802e64:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802e6a:	89 04 24             	mov    %eax,(%esp)
  802e6d:	e8 b7 e8 ff ff       	call   801729 <sys_env_destroy>
	close(fd);
  802e72:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802e78:	89 04 24             	mov    %eax,(%esp)
  802e7b:	e8 43 f2 ff ff       	call   8020c3 <close>
	return r;
  802e80:	89 d8                	mov    %ebx,%eax
  802e82:	eb 16                	jmp    802e9a <spawn+0x63a>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802e84:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e8b:	00 
  802e8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e93:	e8 c8 e9 ff ff       	call   801860 <sys_page_unmap>
  802e98:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802e9a:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802ea0:	5b                   	pop    %ebx
  802ea1:	5e                   	pop    %esi
  802ea2:	5f                   	pop    %edi
  802ea3:	5d                   	pop    %ebp
  802ea4:	c3                   	ret    

00802ea5 <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802ea5:	55                   	push   %ebp
  802ea6:	89 e5                	mov    %esp,%ebp
  802ea8:	57                   	push   %edi
  802ea9:	56                   	push   %esi
  802eaa:	53                   	push   %ebx
  802eab:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802eae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802eb2:	74 61                	je     802f15 <spawnl+0x70>
  802eb4:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802eb7:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802ebc:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802ebf:	83 c0 04             	add    $0x4,%eax
  802ec2:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802ec6:	74 04                	je     802ecc <spawnl+0x27>
		argc++;
  802ec8:	89 ca                	mov    %ecx,%edx
  802eca:	eb f0                	jmp    802ebc <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802ecc:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  802ed3:	83 e0 f0             	and    $0xfffffff0,%eax
  802ed6:	29 c4                	sub    %eax,%esp
  802ed8:	8d 74 24 0b          	lea    0xb(%esp),%esi
  802edc:	c1 ee 02             	shr    $0x2,%esi
  802edf:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  802ee6:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802ee8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802eeb:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  802ef2:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  802ef9:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802efa:	89 ce                	mov    %ecx,%esi
  802efc:	85 c9                	test   %ecx,%ecx
  802efe:	74 25                	je     802f25 <spawnl+0x80>
  802f00:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802f05:	83 c0 01             	add    $0x1,%eax
  802f08:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  802f0c:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802f0f:	39 f0                	cmp    %esi,%eax
  802f11:	75 f2                	jne    802f05 <spawnl+0x60>
  802f13:	eb 10                	jmp    802f25 <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  802f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f18:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  802f1b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802f22:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802f25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	89 04 24             	mov    %eax,(%esp)
  802f2f:	e8 2c f9 ff ff       	call   802860 <spawn>
}
  802f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802f37:	5b                   	pop    %ebx
  802f38:	5e                   	pop    %esi
  802f39:	5f                   	pop    %edi
  802f3a:	5d                   	pop    %ebp
  802f3b:	c3                   	ret    
  802f3c:	66 90                	xchg   %ax,%ax
  802f3e:	66 90                	xchg   %ax,%ax

00802f40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802f40:	55                   	push   %ebp
  802f41:	89 e5                	mov    %esp,%ebp
  802f43:	56                   	push   %esi
  802f44:	53                   	push   %ebx
  802f45:	83 ec 10             	sub    $0x10,%esp
  802f48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	89 04 24             	mov    %eax,(%esp)
  802f51:	e8 9a ef ff ff       	call   801ef0 <fd2data>
  802f56:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802f58:	c7 44 24 04 5b 40 80 	movl   $0x80405b,0x4(%esp)
  802f5f:	00 
  802f60:	89 1c 24             	mov    %ebx,(%esp)
  802f63:	e8 a3 e3 ff ff       	call   80130b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802f68:	8b 46 04             	mov    0x4(%esi),%eax
  802f6b:	2b 06                	sub    (%esi),%eax
  802f6d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802f73:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802f7a:	00 00 00 
	stat->st_dev = &devpipe;
  802f7d:	c7 83 88 00 00 00 3c 	movl   $0x80503c,0x88(%ebx)
  802f84:	50 80 00 
	return 0;
}
  802f87:	b8 00 00 00 00       	mov    $0x0,%eax
  802f8c:	83 c4 10             	add    $0x10,%esp
  802f8f:	5b                   	pop    %ebx
  802f90:	5e                   	pop    %esi
  802f91:	5d                   	pop    %ebp
  802f92:	c3                   	ret    

00802f93 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f93:	55                   	push   %ebp
  802f94:	89 e5                	mov    %esp,%ebp
  802f96:	53                   	push   %ebx
  802f97:	83 ec 14             	sub    $0x14,%esp
  802f9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fa1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fa8:	e8 b3 e8 ff ff       	call   801860 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802fad:	89 1c 24             	mov    %ebx,(%esp)
  802fb0:	e8 3b ef ff ff       	call   801ef0 <fd2data>
  802fb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fc0:	e8 9b e8 ff ff       	call   801860 <sys_page_unmap>
}
  802fc5:	83 c4 14             	add    $0x14,%esp
  802fc8:	5b                   	pop    %ebx
  802fc9:	5d                   	pop    %ebp
  802fca:	c3                   	ret    

00802fcb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802fcb:	55                   	push   %ebp
  802fcc:	89 e5                	mov    %esp,%ebp
  802fce:	57                   	push   %edi
  802fcf:	56                   	push   %esi
  802fd0:	53                   	push   %ebx
  802fd1:	83 ec 2c             	sub    $0x2c,%esp
  802fd4:	89 c6                	mov    %eax,%esi
  802fd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802fd9:	a1 24 64 80 00       	mov    0x806424,%eax
  802fde:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802fe1:	89 34 24             	mov    %esi,(%esp)
  802fe4:	e8 42 05 00 00       	call   80352b <pageref>
  802fe9:	89 c7                	mov    %eax,%edi
  802feb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fee:	89 04 24             	mov    %eax,(%esp)
  802ff1:	e8 35 05 00 00       	call   80352b <pageref>
  802ff6:	39 c7                	cmp    %eax,%edi
  802ff8:	0f 94 c2             	sete   %dl
  802ffb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802ffe:	8b 0d 24 64 80 00    	mov    0x806424,%ecx
  803004:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  803007:	39 fb                	cmp    %edi,%ebx
  803009:	74 21                	je     80302c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80300b:	84 d2                	test   %dl,%dl
  80300d:	74 ca                	je     802fd9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80300f:	8b 51 58             	mov    0x58(%ecx),%edx
  803012:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803016:	89 54 24 08          	mov    %edx,0x8(%esp)
  80301a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80301e:	c7 04 24 62 40 80 00 	movl   $0x804062,(%esp)
  803025:	e8 96 db ff ff       	call   800bc0 <cprintf>
  80302a:	eb ad                	jmp    802fd9 <_pipeisclosed+0xe>
	}
}
  80302c:	83 c4 2c             	add    $0x2c,%esp
  80302f:	5b                   	pop    %ebx
  803030:	5e                   	pop    %esi
  803031:	5f                   	pop    %edi
  803032:	5d                   	pop    %ebp
  803033:	c3                   	ret    

00803034 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803034:	55                   	push   %ebp
  803035:	89 e5                	mov    %esp,%ebp
  803037:	57                   	push   %edi
  803038:	56                   	push   %esi
  803039:	53                   	push   %ebx
  80303a:	83 ec 1c             	sub    $0x1c,%esp
  80303d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803040:	89 34 24             	mov    %esi,(%esp)
  803043:	e8 a8 ee ff ff       	call   801ef0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803048:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80304c:	74 61                	je     8030af <devpipe_write+0x7b>
  80304e:	89 c3                	mov    %eax,%ebx
  803050:	bf 00 00 00 00       	mov    $0x0,%edi
  803055:	eb 4a                	jmp    8030a1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803057:	89 da                	mov    %ebx,%edx
  803059:	89 f0                	mov    %esi,%eax
  80305b:	e8 6b ff ff ff       	call   802fcb <_pipeisclosed>
  803060:	85 c0                	test   %eax,%eax
  803062:	75 54                	jne    8030b8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803064:	e8 31 e7 ff ff       	call   80179a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803069:	8b 43 04             	mov    0x4(%ebx),%eax
  80306c:	8b 0b                	mov    (%ebx),%ecx
  80306e:	8d 51 20             	lea    0x20(%ecx),%edx
  803071:	39 d0                	cmp    %edx,%eax
  803073:	73 e2                	jae    803057 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803078:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80307c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80307f:	99                   	cltd   
  803080:	c1 ea 1b             	shr    $0x1b,%edx
  803083:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803086:	83 e1 1f             	and    $0x1f,%ecx
  803089:	29 d1                	sub    %edx,%ecx
  80308b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80308f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803093:	83 c0 01             	add    $0x1,%eax
  803096:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803099:	83 c7 01             	add    $0x1,%edi
  80309c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80309f:	74 13                	je     8030b4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8030a4:	8b 0b                	mov    (%ebx),%ecx
  8030a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8030a9:	39 d0                	cmp    %edx,%eax
  8030ab:	73 aa                	jae    803057 <devpipe_write+0x23>
  8030ad:	eb c6                	jmp    803075 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8030b4:	89 f8                	mov    %edi,%eax
  8030b6:	eb 05                	jmp    8030bd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8030bd:	83 c4 1c             	add    $0x1c,%esp
  8030c0:	5b                   	pop    %ebx
  8030c1:	5e                   	pop    %esi
  8030c2:	5f                   	pop    %edi
  8030c3:	5d                   	pop    %ebp
  8030c4:	c3                   	ret    

008030c5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8030c5:	55                   	push   %ebp
  8030c6:	89 e5                	mov    %esp,%ebp
  8030c8:	57                   	push   %edi
  8030c9:	56                   	push   %esi
  8030ca:	53                   	push   %ebx
  8030cb:	83 ec 1c             	sub    $0x1c,%esp
  8030ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8030d1:	89 3c 24             	mov    %edi,(%esp)
  8030d4:	e8 17 ee ff ff       	call   801ef0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8030dd:	74 54                	je     803133 <devpipe_read+0x6e>
  8030df:	89 c3                	mov    %eax,%ebx
  8030e1:	be 00 00 00 00       	mov    $0x0,%esi
  8030e6:	eb 3e                	jmp    803126 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8030e8:	89 f0                	mov    %esi,%eax
  8030ea:	eb 55                	jmp    803141 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8030ec:	89 da                	mov    %ebx,%edx
  8030ee:	89 f8                	mov    %edi,%eax
  8030f0:	e8 d6 fe ff ff       	call   802fcb <_pipeisclosed>
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	75 43                	jne    80313c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8030f9:	e8 9c e6 ff ff       	call   80179a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8030fe:	8b 03                	mov    (%ebx),%eax
  803100:	3b 43 04             	cmp    0x4(%ebx),%eax
  803103:	74 e7                	je     8030ec <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803105:	99                   	cltd   
  803106:	c1 ea 1b             	shr    $0x1b,%edx
  803109:	01 d0                	add    %edx,%eax
  80310b:	83 e0 1f             	and    $0x1f,%eax
  80310e:	29 d0                	sub    %edx,%eax
  803110:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803118:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80311b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80311e:	83 c6 01             	add    $0x1,%esi
  803121:	3b 75 10             	cmp    0x10(%ebp),%esi
  803124:	74 12                	je     803138 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  803126:	8b 03                	mov    (%ebx),%eax
  803128:	3b 43 04             	cmp    0x4(%ebx),%eax
  80312b:	75 d8                	jne    803105 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80312d:	85 f6                	test   %esi,%esi
  80312f:	75 b7                	jne    8030e8 <devpipe_read+0x23>
  803131:	eb b9                	jmp    8030ec <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803133:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803138:	89 f0                	mov    %esi,%eax
  80313a:	eb 05                	jmp    803141 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80313c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  803141:	83 c4 1c             	add    $0x1c,%esp
  803144:	5b                   	pop    %ebx
  803145:	5e                   	pop    %esi
  803146:	5f                   	pop    %edi
  803147:	5d                   	pop    %ebp
  803148:	c3                   	ret    

00803149 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803149:	55                   	push   %ebp
  80314a:	89 e5                	mov    %esp,%ebp
  80314c:	56                   	push   %esi
  80314d:	53                   	push   %ebx
  80314e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803151:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803154:	89 04 24             	mov    %eax,(%esp)
  803157:	e8 ab ed ff ff       	call   801f07 <fd_alloc>
  80315c:	89 c2                	mov    %eax,%edx
  80315e:	85 d2                	test   %edx,%edx
  803160:	0f 88 4d 01 00 00    	js     8032b3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803166:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80316d:	00 
  80316e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803171:	89 44 24 04          	mov    %eax,0x4(%esp)
  803175:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80317c:	e8 38 e6 ff ff       	call   8017b9 <sys_page_alloc>
  803181:	89 c2                	mov    %eax,%edx
  803183:	85 d2                	test   %edx,%edx
  803185:	0f 88 28 01 00 00    	js     8032b3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80318b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80318e:	89 04 24             	mov    %eax,(%esp)
  803191:	e8 71 ed ff ff       	call   801f07 <fd_alloc>
  803196:	89 c3                	mov    %eax,%ebx
  803198:	85 c0                	test   %eax,%eax
  80319a:	0f 88 fe 00 00 00    	js     80329e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031a7:	00 
  8031a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031b6:	e8 fe e5 ff ff       	call   8017b9 <sys_page_alloc>
  8031bb:	89 c3                	mov    %eax,%ebx
  8031bd:	85 c0                	test   %eax,%eax
  8031bf:	0f 88 d9 00 00 00    	js     80329e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	89 04 24             	mov    %eax,(%esp)
  8031cb:	e8 20 ed ff ff       	call   801ef0 <fd2data>
  8031d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8031d9:	00 
  8031da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031e5:	e8 cf e5 ff ff       	call   8017b9 <sys_page_alloc>
  8031ea:	89 c3                	mov    %eax,%ebx
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	0f 88 97 00 00 00    	js     80328b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f7:	89 04 24             	mov    %eax,(%esp)
  8031fa:	e8 f1 ec ff ff       	call   801ef0 <fd2data>
  8031ff:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803206:	00 
  803207:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80320b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803212:	00 
  803213:	89 74 24 04          	mov    %esi,0x4(%esp)
  803217:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80321e:	e8 ea e5 ff ff       	call   80180d <sys_page_map>
  803223:	89 c3                	mov    %eax,%ebx
  803225:	85 c0                	test   %eax,%eax
  803227:	78 52                	js     80327b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803229:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  80322f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803232:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80323e:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  803244:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803247:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	89 04 24             	mov    %eax,(%esp)
  803259:	e8 82 ec ff ff       	call   801ee0 <fd2num>
  80325e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803261:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	89 04 24             	mov    %eax,(%esp)
  803269:	e8 72 ec ff ff       	call   801ee0 <fd2num>
  80326e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803271:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803274:	b8 00 00 00 00       	mov    $0x0,%eax
  803279:	eb 38                	jmp    8032b3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80327b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80327f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803286:	e8 d5 e5 ff ff       	call   801860 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80328b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80328e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803292:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803299:	e8 c2 e5 ff ff       	call   801860 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032ac:	e8 af e5 ff ff       	call   801860 <sys_page_unmap>
  8032b1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8032b3:	83 c4 30             	add    $0x30,%esp
  8032b6:	5b                   	pop    %ebx
  8032b7:	5e                   	pop    %esi
  8032b8:	5d                   	pop    %ebp
  8032b9:	c3                   	ret    

008032ba <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8032ba:	55                   	push   %ebp
  8032bb:	89 e5                	mov    %esp,%ebp
  8032bd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	89 04 24             	mov    %eax,(%esp)
  8032cd:	e8 a9 ec ff ff       	call   801f7b <fd_lookup>
  8032d2:	89 c2                	mov    %eax,%edx
  8032d4:	85 d2                	test   %edx,%edx
  8032d6:	78 15                	js     8032ed <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8032d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032db:	89 04 24             	mov    %eax,(%esp)
  8032de:	e8 0d ec ff ff       	call   801ef0 <fd2data>
	return _pipeisclosed(fd, p);
  8032e3:	89 c2                	mov    %eax,%edx
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	e8 de fc ff ff       	call   802fcb <_pipeisclosed>
}
  8032ed:	c9                   	leave  
  8032ee:	c3                   	ret    

008032ef <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8032ef:	55                   	push   %ebp
  8032f0:	89 e5                	mov    %esp,%ebp
  8032f2:	56                   	push   %esi
  8032f3:	53                   	push   %ebx
  8032f4:	83 ec 10             	sub    $0x10,%esp
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  8032fa:	85 c0                	test   %eax,%eax
  8032fc:	75 24                	jne    803322 <wait+0x33>
  8032fe:	c7 44 24 0c 7a 40 80 	movl   $0x80407a,0xc(%esp)
  803305:	00 
  803306:	c7 44 24 08 52 39 80 	movl   $0x803952,0x8(%esp)
  80330d:	00 
  80330e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  803315:	00 
  803316:	c7 04 24 85 40 80 00 	movl   $0x804085,(%esp)
  80331d:	e8 a5 d7 ff ff       	call   800ac7 <_panic>
	e = &envs[ENVX(envid)];
  803322:	89 c3                	mov    %eax,%ebx
  803324:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80332a:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  80332d:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803333:	8b 73 48             	mov    0x48(%ebx),%esi
  803336:	39 c6                	cmp    %eax,%esi
  803338:	75 1a                	jne    803354 <wait+0x65>
  80333a:	8b 43 54             	mov    0x54(%ebx),%eax
  80333d:	85 c0                	test   %eax,%eax
  80333f:	74 13                	je     803354 <wait+0x65>
		sys_yield();
  803341:	e8 54 e4 ff ff       	call   80179a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803346:	8b 43 48             	mov    0x48(%ebx),%eax
  803349:	39 f0                	cmp    %esi,%eax
  80334b:	75 07                	jne    803354 <wait+0x65>
  80334d:	8b 43 54             	mov    0x54(%ebx),%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	75 ed                	jne    803341 <wait+0x52>
		sys_yield();
}
  803354:	83 c4 10             	add    $0x10,%esp
  803357:	5b                   	pop    %ebx
  803358:	5e                   	pop    %esi
  803359:	5d                   	pop    %ebp
  80335a:	c3                   	ret    

0080335b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80335b:	55                   	push   %ebp
  80335c:	89 e5                	mov    %esp,%ebp
  80335e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  803361:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  803368:	75 50                	jne    8033ba <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  80336a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803371:	00 
  803372:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803379:	ee 
  80337a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803381:	e8 33 e4 ff ff       	call   8017b9 <sys_page_alloc>
  803386:	85 c0                	test   %eax,%eax
  803388:	79 1c                	jns    8033a6 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  80338a:	c7 44 24 08 90 40 80 	movl   $0x804090,0x8(%esp)
  803391:	00 
  803392:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  803399:	00 
  80339a:	c7 04 24 b4 40 80 00 	movl   $0x8040b4,(%esp)
  8033a1:	e8 21 d7 ff ff       	call   800ac7 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8033a6:	c7 44 24 04 c4 33 80 	movl   $0x8033c4,0x4(%esp)
  8033ad:	00 
  8033ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8033b5:	e8 9f e5 ff ff       	call   801959 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8033c2:	c9                   	leave  
  8033c3:	c3                   	ret    

008033c4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8033c4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8033c5:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8033ca:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8033cc:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  8033cf:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  8033d1:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  8033d6:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  8033d9:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  8033de:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  8033e1:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  8033e3:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  8033e6:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  8033e8:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  8033ea:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  8033ef:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  8033f2:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  8033f7:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  8033fa:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  8033fc:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  803401:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  803404:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  803409:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  80340c:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  80340e:	83 c4 08             	add    $0x8,%esp
	popal
  803411:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  803412:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  803413:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803414:	c3                   	ret    

00803415 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803415:	55                   	push   %ebp
  803416:	89 e5                	mov    %esp,%ebp
  803418:	56                   	push   %esi
  803419:	53                   	push   %ebx
  80341a:	83 ec 10             	sub    $0x10,%esp
  80341d:	8b 75 08             	mov    0x8(%ebp),%esi
  803420:	8b 45 0c             	mov    0xc(%ebp),%eax
  803423:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  803426:	85 c0                	test   %eax,%eax
  803428:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80342d:	0f 44 c2             	cmove  %edx,%eax
  803430:	89 04 24             	mov    %eax,(%esp)
  803433:	e8 97 e5 ff ff       	call   8019cf <sys_ipc_recv>
	if (err_code < 0) {
  803438:	85 c0                	test   %eax,%eax
  80343a:	79 16                	jns    803452 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80343c:	85 f6                	test   %esi,%esi
  80343e:	74 06                	je     803446 <ipc_recv+0x31>
  803440:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  803446:	85 db                	test   %ebx,%ebx
  803448:	74 2c                	je     803476 <ipc_recv+0x61>
  80344a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  803450:	eb 24                	jmp    803476 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  803452:	85 f6                	test   %esi,%esi
  803454:	74 0a                	je     803460 <ipc_recv+0x4b>
  803456:	a1 24 64 80 00       	mov    0x806424,%eax
  80345b:	8b 40 74             	mov    0x74(%eax),%eax
  80345e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  803460:	85 db                	test   %ebx,%ebx
  803462:	74 0a                	je     80346e <ipc_recv+0x59>
  803464:	a1 24 64 80 00       	mov    0x806424,%eax
  803469:	8b 40 78             	mov    0x78(%eax),%eax
  80346c:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80346e:	a1 24 64 80 00       	mov    0x806424,%eax
  803473:	8b 40 70             	mov    0x70(%eax),%eax
}
  803476:	83 c4 10             	add    $0x10,%esp
  803479:	5b                   	pop    %ebx
  80347a:	5e                   	pop    %esi
  80347b:	5d                   	pop    %ebp
  80347c:	c3                   	ret    

0080347d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80347d:	55                   	push   %ebp
  80347e:	89 e5                	mov    %esp,%ebp
  803480:	57                   	push   %edi
  803481:	56                   	push   %esi
  803482:	53                   	push   %ebx
  803483:	83 ec 1c             	sub    $0x1c,%esp
  803486:	8b 7d 08             	mov    0x8(%ebp),%edi
  803489:	8b 75 0c             	mov    0xc(%ebp),%esi
  80348c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80348f:	eb 25                	jmp    8034b6 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  803491:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803494:	74 20                	je     8034b6 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  803496:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80349a:	c7 44 24 08 c2 40 80 	movl   $0x8040c2,0x8(%esp)
  8034a1:	00 
  8034a2:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8034a9:	00 
  8034aa:	c7 04 24 ce 40 80 00 	movl   $0x8040ce,(%esp)
  8034b1:	e8 11 d6 ff ff       	call   800ac7 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8034b6:	85 db                	test   %ebx,%ebx
  8034b8:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8034bd:	0f 45 c3             	cmovne %ebx,%eax
  8034c0:	8b 55 14             	mov    0x14(%ebp),%edx
  8034c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8034c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8034cf:	89 3c 24             	mov    %edi,(%esp)
  8034d2:	e8 d5 e4 ff ff       	call   8019ac <sys_ipc_try_send>
  8034d7:	85 c0                	test   %eax,%eax
  8034d9:	75 b6                	jne    803491 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8034db:	83 c4 1c             	add    $0x1c,%esp
  8034de:	5b                   	pop    %ebx
  8034df:	5e                   	pop    %esi
  8034e0:	5f                   	pop    %edi
  8034e1:	5d                   	pop    %ebp
  8034e2:	c3                   	ret    

008034e3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8034e3:	55                   	push   %ebp
  8034e4:	89 e5                	mov    %esp,%ebp
  8034e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8034e9:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8034ee:	39 c8                	cmp    %ecx,%eax
  8034f0:	74 17                	je     803509 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8034f2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8034f7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8034fa:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803500:	8b 52 50             	mov    0x50(%edx),%edx
  803503:	39 ca                	cmp    %ecx,%edx
  803505:	75 14                	jne    80351b <ipc_find_env+0x38>
  803507:	eb 05                	jmp    80350e <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803509:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80350e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  803511:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  803516:	8b 40 40             	mov    0x40(%eax),%eax
  803519:	eb 0e                	jmp    803529 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80351b:	83 c0 01             	add    $0x1,%eax
  80351e:	3d 00 04 00 00       	cmp    $0x400,%eax
  803523:	75 d2                	jne    8034f7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  803525:	66 b8 00 00          	mov    $0x0,%ax
}
  803529:	5d                   	pop    %ebp
  80352a:	c3                   	ret    

0080352b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80352b:	55                   	push   %ebp
  80352c:	89 e5                	mov    %esp,%ebp
  80352e:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803531:	89 d0                	mov    %edx,%eax
  803533:	c1 e8 16             	shr    $0x16,%eax
  803536:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80353d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  803542:	f6 c1 01             	test   $0x1,%cl
  803545:	74 1d                	je     803564 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  803547:	c1 ea 0c             	shr    $0xc,%edx
  80354a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  803551:	f6 c2 01             	test   $0x1,%dl
  803554:	74 0e                	je     803564 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  803556:	c1 ea 0c             	shr    $0xc,%edx
  803559:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  803560:	ef 
  803561:	0f b7 c0             	movzwl %ax,%eax
}
  803564:	5d                   	pop    %ebp
  803565:	c3                   	ret    
  803566:	66 90                	xchg   %ax,%ax
  803568:	66 90                	xchg   %ax,%ax
  80356a:	66 90                	xchg   %ax,%ax
  80356c:	66 90                	xchg   %ax,%ax
  80356e:	66 90                	xchg   %ax,%ax

00803570 <__udivdi3>:
  803570:	55                   	push   %ebp
  803571:	57                   	push   %edi
  803572:	56                   	push   %esi
  803573:	83 ec 0c             	sub    $0xc,%esp
  803576:	8b 44 24 28          	mov    0x28(%esp),%eax
  80357a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80357e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803582:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803586:	85 c0                	test   %eax,%eax
  803588:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80358c:	89 ea                	mov    %ebp,%edx
  80358e:	89 0c 24             	mov    %ecx,(%esp)
  803591:	75 2d                	jne    8035c0 <__udivdi3+0x50>
  803593:	39 e9                	cmp    %ebp,%ecx
  803595:	77 61                	ja     8035f8 <__udivdi3+0x88>
  803597:	85 c9                	test   %ecx,%ecx
  803599:	89 ce                	mov    %ecx,%esi
  80359b:	75 0b                	jne    8035a8 <__udivdi3+0x38>
  80359d:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a2:	31 d2                	xor    %edx,%edx
  8035a4:	f7 f1                	div    %ecx
  8035a6:	89 c6                	mov    %eax,%esi
  8035a8:	31 d2                	xor    %edx,%edx
  8035aa:	89 e8                	mov    %ebp,%eax
  8035ac:	f7 f6                	div    %esi
  8035ae:	89 c5                	mov    %eax,%ebp
  8035b0:	89 f8                	mov    %edi,%eax
  8035b2:	f7 f6                	div    %esi
  8035b4:	89 ea                	mov    %ebp,%edx
  8035b6:	83 c4 0c             	add    $0xc,%esp
  8035b9:	5e                   	pop    %esi
  8035ba:	5f                   	pop    %edi
  8035bb:	5d                   	pop    %ebp
  8035bc:	c3                   	ret    
  8035bd:	8d 76 00             	lea    0x0(%esi),%esi
  8035c0:	39 e8                	cmp    %ebp,%eax
  8035c2:	77 24                	ja     8035e8 <__udivdi3+0x78>
  8035c4:	0f bd e8             	bsr    %eax,%ebp
  8035c7:	83 f5 1f             	xor    $0x1f,%ebp
  8035ca:	75 3c                	jne    803608 <__udivdi3+0x98>
  8035cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8035d0:	39 34 24             	cmp    %esi,(%esp)
  8035d3:	0f 86 9f 00 00 00    	jbe    803678 <__udivdi3+0x108>
  8035d9:	39 d0                	cmp    %edx,%eax
  8035db:	0f 82 97 00 00 00    	jb     803678 <__udivdi3+0x108>
  8035e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8035e8:	31 d2                	xor    %edx,%edx
  8035ea:	31 c0                	xor    %eax,%eax
  8035ec:	83 c4 0c             	add    $0xc,%esp
  8035ef:	5e                   	pop    %esi
  8035f0:	5f                   	pop    %edi
  8035f1:	5d                   	pop    %ebp
  8035f2:	c3                   	ret    
  8035f3:	90                   	nop
  8035f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8035f8:	89 f8                	mov    %edi,%eax
  8035fa:	f7 f1                	div    %ecx
  8035fc:	31 d2                	xor    %edx,%edx
  8035fe:	83 c4 0c             	add    $0xc,%esp
  803601:	5e                   	pop    %esi
  803602:	5f                   	pop    %edi
  803603:	5d                   	pop    %ebp
  803604:	c3                   	ret    
  803605:	8d 76 00             	lea    0x0(%esi),%esi
  803608:	89 e9                	mov    %ebp,%ecx
  80360a:	8b 3c 24             	mov    (%esp),%edi
  80360d:	d3 e0                	shl    %cl,%eax
  80360f:	89 c6                	mov    %eax,%esi
  803611:	b8 20 00 00 00       	mov    $0x20,%eax
  803616:	29 e8                	sub    %ebp,%eax
  803618:	89 c1                	mov    %eax,%ecx
  80361a:	d3 ef                	shr    %cl,%edi
  80361c:	89 e9                	mov    %ebp,%ecx
  80361e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803622:	8b 3c 24             	mov    (%esp),%edi
  803625:	09 74 24 08          	or     %esi,0x8(%esp)
  803629:	89 d6                	mov    %edx,%esi
  80362b:	d3 e7                	shl    %cl,%edi
  80362d:	89 c1                	mov    %eax,%ecx
  80362f:	89 3c 24             	mov    %edi,(%esp)
  803632:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803636:	d3 ee                	shr    %cl,%esi
  803638:	89 e9                	mov    %ebp,%ecx
  80363a:	d3 e2                	shl    %cl,%edx
  80363c:	89 c1                	mov    %eax,%ecx
  80363e:	d3 ef                	shr    %cl,%edi
  803640:	09 d7                	or     %edx,%edi
  803642:	89 f2                	mov    %esi,%edx
  803644:	89 f8                	mov    %edi,%eax
  803646:	f7 74 24 08          	divl   0x8(%esp)
  80364a:	89 d6                	mov    %edx,%esi
  80364c:	89 c7                	mov    %eax,%edi
  80364e:	f7 24 24             	mull   (%esp)
  803651:	39 d6                	cmp    %edx,%esi
  803653:	89 14 24             	mov    %edx,(%esp)
  803656:	72 30                	jb     803688 <__udivdi3+0x118>
  803658:	8b 54 24 04          	mov    0x4(%esp),%edx
  80365c:	89 e9                	mov    %ebp,%ecx
  80365e:	d3 e2                	shl    %cl,%edx
  803660:	39 c2                	cmp    %eax,%edx
  803662:	73 05                	jae    803669 <__udivdi3+0xf9>
  803664:	3b 34 24             	cmp    (%esp),%esi
  803667:	74 1f                	je     803688 <__udivdi3+0x118>
  803669:	89 f8                	mov    %edi,%eax
  80366b:	31 d2                	xor    %edx,%edx
  80366d:	e9 7a ff ff ff       	jmp    8035ec <__udivdi3+0x7c>
  803672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803678:	31 d2                	xor    %edx,%edx
  80367a:	b8 01 00 00 00       	mov    $0x1,%eax
  80367f:	e9 68 ff ff ff       	jmp    8035ec <__udivdi3+0x7c>
  803684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803688:	8d 47 ff             	lea    -0x1(%edi),%eax
  80368b:	31 d2                	xor    %edx,%edx
  80368d:	83 c4 0c             	add    $0xc,%esp
  803690:	5e                   	pop    %esi
  803691:	5f                   	pop    %edi
  803692:	5d                   	pop    %ebp
  803693:	c3                   	ret    
  803694:	66 90                	xchg   %ax,%ax
  803696:	66 90                	xchg   %ax,%ax
  803698:	66 90                	xchg   %ax,%ax
  80369a:	66 90                	xchg   %ax,%ax
  80369c:	66 90                	xchg   %ax,%ax
  80369e:	66 90                	xchg   %ax,%ax

008036a0 <__umoddi3>:
  8036a0:	55                   	push   %ebp
  8036a1:	57                   	push   %edi
  8036a2:	56                   	push   %esi
  8036a3:	83 ec 14             	sub    $0x14,%esp
  8036a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8036aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8036ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8036b2:	89 c7                	mov    %eax,%edi
  8036b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8036bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8036c0:	89 34 24             	mov    %esi,(%esp)
  8036c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036c7:	85 c0                	test   %eax,%eax
  8036c9:	89 c2                	mov    %eax,%edx
  8036cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036cf:	75 17                	jne    8036e8 <__umoddi3+0x48>
  8036d1:	39 fe                	cmp    %edi,%esi
  8036d3:	76 4b                	jbe    803720 <__umoddi3+0x80>
  8036d5:	89 c8                	mov    %ecx,%eax
  8036d7:	89 fa                	mov    %edi,%edx
  8036d9:	f7 f6                	div    %esi
  8036db:	89 d0                	mov    %edx,%eax
  8036dd:	31 d2                	xor    %edx,%edx
  8036df:	83 c4 14             	add    $0x14,%esp
  8036e2:	5e                   	pop    %esi
  8036e3:	5f                   	pop    %edi
  8036e4:	5d                   	pop    %ebp
  8036e5:	c3                   	ret    
  8036e6:	66 90                	xchg   %ax,%ax
  8036e8:	39 f8                	cmp    %edi,%eax
  8036ea:	77 54                	ja     803740 <__umoddi3+0xa0>
  8036ec:	0f bd e8             	bsr    %eax,%ebp
  8036ef:	83 f5 1f             	xor    $0x1f,%ebp
  8036f2:	75 5c                	jne    803750 <__umoddi3+0xb0>
  8036f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8036f8:	39 3c 24             	cmp    %edi,(%esp)
  8036fb:	0f 87 e7 00 00 00    	ja     8037e8 <__umoddi3+0x148>
  803701:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803705:	29 f1                	sub    %esi,%ecx
  803707:	19 c7                	sbb    %eax,%edi
  803709:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80370d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803711:	8b 44 24 08          	mov    0x8(%esp),%eax
  803715:	8b 54 24 0c          	mov    0xc(%esp),%edx
  803719:	83 c4 14             	add    $0x14,%esp
  80371c:	5e                   	pop    %esi
  80371d:	5f                   	pop    %edi
  80371e:	5d                   	pop    %ebp
  80371f:	c3                   	ret    
  803720:	85 f6                	test   %esi,%esi
  803722:	89 f5                	mov    %esi,%ebp
  803724:	75 0b                	jne    803731 <__umoddi3+0x91>
  803726:	b8 01 00 00 00       	mov    $0x1,%eax
  80372b:	31 d2                	xor    %edx,%edx
  80372d:	f7 f6                	div    %esi
  80372f:	89 c5                	mov    %eax,%ebp
  803731:	8b 44 24 04          	mov    0x4(%esp),%eax
  803735:	31 d2                	xor    %edx,%edx
  803737:	f7 f5                	div    %ebp
  803739:	89 c8                	mov    %ecx,%eax
  80373b:	f7 f5                	div    %ebp
  80373d:	eb 9c                	jmp    8036db <__umoddi3+0x3b>
  80373f:	90                   	nop
  803740:	89 c8                	mov    %ecx,%eax
  803742:	89 fa                	mov    %edi,%edx
  803744:	83 c4 14             	add    $0x14,%esp
  803747:	5e                   	pop    %esi
  803748:	5f                   	pop    %edi
  803749:	5d                   	pop    %ebp
  80374a:	c3                   	ret    
  80374b:	90                   	nop
  80374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803750:	8b 04 24             	mov    (%esp),%eax
  803753:	be 20 00 00 00       	mov    $0x20,%esi
  803758:	89 e9                	mov    %ebp,%ecx
  80375a:	29 ee                	sub    %ebp,%esi
  80375c:	d3 e2                	shl    %cl,%edx
  80375e:	89 f1                	mov    %esi,%ecx
  803760:	d3 e8                	shr    %cl,%eax
  803762:	89 e9                	mov    %ebp,%ecx
  803764:	89 44 24 04          	mov    %eax,0x4(%esp)
  803768:	8b 04 24             	mov    (%esp),%eax
  80376b:	09 54 24 04          	or     %edx,0x4(%esp)
  80376f:	89 fa                	mov    %edi,%edx
  803771:	d3 e0                	shl    %cl,%eax
  803773:	89 f1                	mov    %esi,%ecx
  803775:	89 44 24 08          	mov    %eax,0x8(%esp)
  803779:	8b 44 24 10          	mov    0x10(%esp),%eax
  80377d:	d3 ea                	shr    %cl,%edx
  80377f:	89 e9                	mov    %ebp,%ecx
  803781:	d3 e7                	shl    %cl,%edi
  803783:	89 f1                	mov    %esi,%ecx
  803785:	d3 e8                	shr    %cl,%eax
  803787:	89 e9                	mov    %ebp,%ecx
  803789:	09 f8                	or     %edi,%eax
  80378b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80378f:	f7 74 24 04          	divl   0x4(%esp)
  803793:	d3 e7                	shl    %cl,%edi
  803795:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803799:	89 d7                	mov    %edx,%edi
  80379b:	f7 64 24 08          	mull   0x8(%esp)
  80379f:	39 d7                	cmp    %edx,%edi
  8037a1:	89 c1                	mov    %eax,%ecx
  8037a3:	89 14 24             	mov    %edx,(%esp)
  8037a6:	72 2c                	jb     8037d4 <__umoddi3+0x134>
  8037a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8037ac:	72 22                	jb     8037d0 <__umoddi3+0x130>
  8037ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8037b2:	29 c8                	sub    %ecx,%eax
  8037b4:	19 d7                	sbb    %edx,%edi
  8037b6:	89 e9                	mov    %ebp,%ecx
  8037b8:	89 fa                	mov    %edi,%edx
  8037ba:	d3 e8                	shr    %cl,%eax
  8037bc:	89 f1                	mov    %esi,%ecx
  8037be:	d3 e2                	shl    %cl,%edx
  8037c0:	89 e9                	mov    %ebp,%ecx
  8037c2:	d3 ef                	shr    %cl,%edi
  8037c4:	09 d0                	or     %edx,%eax
  8037c6:	89 fa                	mov    %edi,%edx
  8037c8:	83 c4 14             	add    $0x14,%esp
  8037cb:	5e                   	pop    %esi
  8037cc:	5f                   	pop    %edi
  8037cd:	5d                   	pop    %ebp
  8037ce:	c3                   	ret    
  8037cf:	90                   	nop
  8037d0:	39 d7                	cmp    %edx,%edi
  8037d2:	75 da                	jne    8037ae <__umoddi3+0x10e>
  8037d4:	8b 14 24             	mov    (%esp),%edx
  8037d7:	89 c1                	mov    %eax,%ecx
  8037d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8037dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8037e1:	eb cb                	jmp    8037ae <__umoddi3+0x10e>
  8037e3:	90                   	nop
  8037e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8037e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8037ec:	0f 82 0f ff ff ff    	jb     803701 <__umoddi3+0x61>
  8037f2:	e9 1a ff ff ff       	jmp    803711 <__umoddi3+0x71>
