
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
  800065:	c7 04 24 a0 37 80 00 	movl   $0x8037a0,(%esp)
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
  800088:	c7 04 24 af 37 80 00 	movl   $0x8037af,(%esp)
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
  8000b3:	c7 04 24 bd 37 80 00 	movl   $0x8037bd,(%esp)
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
  8000de:	c7 04 24 c2 37 80 00 	movl   $0x8037c2,(%esp)
  8000e5:	e8 d6 0a 00 00       	call   800bc0 <cprintf>
		return 0;
  8000ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ef:	e9 ab 00 00 00       	jmp    80019f <_gettoken+0x15f>
	}
	if (strchr(SYMBOLS, *s)) {
  8000f4:	0f be c0             	movsbl %al,%eax
  8000f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fb:	c7 04 24 d3 37 80 00 	movl   $0x8037d3,(%esp)
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
  80012a:	c7 04 24 c7 37 80 00 	movl   $0x8037c7,(%esp)
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
  800156:	c7 04 24 cf 37 80 00 	movl   $0x8037cf,(%esp)
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
  800185:	c7 04 24 db 37 80 00 	movl   $0x8037db,(%esp)
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
  800292:	c7 04 24 e5 37 80 00 	movl   $0x8037e5,(%esp)
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
  8002c4:	c7 04 24 38 39 80 00 	movl   $0x803938,(%esp)
  8002cb:	e8 f0 08 00 00       	call   800bc0 <cprintf>
				exit();
  8002d0:	e8 d9 07 00 00       	call   800aae <exit>
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002dc:	00 
  8002dd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002e0:	89 04 24             	mov    %eax,(%esp)
  8002e3:	e8 d0 23 00 00       	call   8026b8 <open>
  8002e8:	89 c7                	mov    %eax,%edi
  8002ea:	85 c0                	test   %eax,%eax
  8002ec:	79 1e                	jns    80030c <runcmd+0xf6>
				cprintf("open %s for read: %e", t, fd);
  8002ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f9:	c7 04 24 f9 37 80 00 	movl   $0x8037f9,(%esp)
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
  800321:	e8 e2 1d 00 00       	call   802108 <dup>
				close(fd);
  800326:	89 3c 24             	mov    %edi,(%esp)
  800329:	e8 85 1d 00 00       	call   8020b3 <close>
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
  800348:	c7 04 24 60 39 80 00 	movl   $0x803960,(%esp)
  80034f:	e8 6c 08 00 00       	call   800bc0 <cprintf>
				exit();
  800354:	e8 55 07 00 00       	call   800aae <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800359:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800360:	00 
  800361:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800364:	89 04 24             	mov    %eax,(%esp)
  800367:	e8 4c 23 00 00       	call   8026b8 <open>
  80036c:	89 c7                	mov    %eax,%edi
  80036e:	85 c0                	test   %eax,%eax
  800370:	79 1c                	jns    80038e <runcmd+0x178>
				cprintf("open %s for write: %e", t, fd);
  800372:	89 44 24 08          	mov    %eax,0x8(%esp)
  800376:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800379:	89 44 24 04          	mov    %eax,0x4(%esp)
  80037d:	c7 04 24 0e 38 80 00 	movl   $0x80380e,(%esp)
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
  8003a2:	e8 61 1d 00 00       	call   802108 <dup>
				close(fd);
  8003a7:	89 3c 24             	mov    %edi,(%esp)
  8003aa:	e8 04 1d 00 00       	call   8020b3 <close>
  8003af:	e9 89 fe ff ff       	jmp    80023d <runcmd+0x27>
			}
			break;

		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003b4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003ba:	89 04 24             	mov    %eax,(%esp)
  8003bd:	e8 17 2d 00 00       	call   8030d9 <pipe>
  8003c2:	85 c0                	test   %eax,%eax
  8003c4:	79 15                	jns    8003db <runcmd+0x1c5>
				cprintf("pipe: %e", r);
  8003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ca:	c7 04 24 24 38 80 00 	movl   $0x803824,(%esp)
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
  8003f8:	c7 04 24 2d 38 80 00 	movl   $0x80382d,(%esp)
  8003ff:	e8 bc 07 00 00       	call   800bc0 <cprintf>
			if ((r = fork()) < 0) {
  800404:	e8 07 17 00 00       	call   801b10 <fork>
  800409:	89 c7                	mov    %eax,%edi
  80040b:	85 c0                	test   %eax,%eax
  80040d:	79 15                	jns    800424 <runcmd+0x20e>
				cprintf("fork: %e", r);
  80040f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800413:	c7 04 24 3a 38 80 00 	movl   $0x80383a,(%esp)
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
  80043d:	e8 c6 1c 00 00       	call   802108 <dup>
					close(p[0]);
  800442:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800448:	89 04 24             	mov    %eax,(%esp)
  80044b:	e8 63 1c 00 00       	call   8020b3 <close>
				}
				close(p[1]);
  800450:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800456:	89 04 24             	mov    %eax,(%esp)
  800459:	e8 55 1c 00 00       	call   8020b3 <close>

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
  80047e:	e8 85 1c 00 00       	call   802108 <dup>
					close(p[1]);
  800483:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800489:	89 04 24             	mov    %eax,(%esp)
  80048c:	e8 22 1c 00 00       	call   8020b3 <close>
				}
				close(p[0]);
  800491:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800497:	89 04 24             	mov    %eax,(%esp)
  80049a:	e8 14 1c 00 00       	call   8020b3 <close>
				goto runit;
  80049f:	eb 25                	jmp    8004c6 <runcmd+0x2b0>
		case 0:		// String is complete
			// Run the current command!
			goto runit;

		default:
			panic("bad return %d from gettoken", c);
  8004a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004a5:	c7 44 24 08 43 38 80 	movl   $0x803843,0x8(%esp)
  8004ac:	00 
  8004ad:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8004b4:	00 
  8004b5:	c7 04 24 5f 38 80 00 	movl   $0x80385f,(%esp)
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
  8004d7:	c7 04 24 69 38 80 00 	movl   $0x803869,(%esp)
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
  80052f:	c7 04 24 78 38 80 00 	movl   $0x803878,(%esp)
  800536:	e8 85 06 00 00       	call   800bc0 <cprintf>
		for (i = 0; argv[i]; i++)
  80053b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80053e:	85 c0                	test   %eax,%eax
  800540:	74 1d                	je     80055f <runcmd+0x349>
  800542:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
  800545:	89 44 24 04          	mov    %eax,0x4(%esp)
  800549:	c7 04 24 03 39 80 00 	movl   $0x803903,(%esp)
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
  80055f:	c7 04 24 c0 37 80 00 	movl   $0x8037c0,(%esp)
  800566:	e8 55 06 00 00       	call   800bc0 <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  80056b:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80056e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800572:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	e8 03 23 00 00       	call   802880 <spawn>
  80057d:	89 c3                	mov    %eax,%ebx
  80057f:	85 c0                	test   %eax,%eax
  800581:	0f 89 c3 00 00 00    	jns    80064a <runcmd+0x434>
		cprintf("spawn %s: %e\n", argv[0], r);
  800587:	89 44 24 08          	mov    %eax,0x8(%esp)
  80058b:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800592:	c7 04 24 86 38 80 00 	movl   $0x803886,(%esp)
  800599:	e8 22 06 00 00       	call   800bc0 <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  80059e:	e8 43 1b 00 00       	call   8020e6 <close_all>
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
  8005bc:	c7 04 24 94 38 80 00 	movl   $0x803894,(%esp)
  8005c3:	e8 f8 05 00 00       	call   800bc0 <cprintf>
		wait(r);
  8005c8:	89 1c 24             	mov    %ebx,(%esp)
  8005cb:	e8 af 2c 00 00       	call   80327f <wait>
		if (debug)
  8005d0:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8005d7:	74 18                	je     8005f1 <runcmd+0x3db>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  8005d9:	a1 24 64 80 00       	mov    0x806424,%eax
  8005de:	8b 40 48             	mov    0x48(%eax),%eax
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 a9 38 80 00 	movl   $0x8038a9,(%esp)
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
  80060e:	c7 04 24 bf 38 80 00 	movl   $0x8038bf,(%esp)
  800615:	e8 a6 05 00 00       	call   800bc0 <cprintf>
		wait(pipe_child);
  80061a:	89 3c 24             	mov    %edi,(%esp)
  80061d:	e8 5d 2c 00 00       	call   80327f <wait>
		if (debug)
  800622:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800629:	74 18                	je     800643 <runcmd+0x42d>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80062b:	a1 24 64 80 00       	mov    0x806424,%eax
  800630:	8b 40 48             	mov    0x48(%eax),%eax
  800633:	89 44 24 04          	mov    %eax,0x4(%esp)
  800637:	c7 04 24 a9 38 80 00 	movl   $0x8038a9,(%esp)
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
  800650:	e8 91 1a 00 00       	call   8020e6 <close_all>
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
  800678:	c7 04 24 88 39 80 00 	movl   $0x803988,(%esp)
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
  8006a8:	e8 bf 16 00 00       	call   801d6c <argstart>
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
  8006f3:	e8 ac 16 00 00       	call   801da4 <argnext>
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
  800716:	e8 98 19 00 00       	call   8020b3 <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80071b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800722:	00 
  800723:	8b 46 04             	mov    0x4(%esi),%eax
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	e8 8a 1f 00 00       	call   8026b8 <open>
  80072e:	85 c0                	test   %eax,%eax
  800730:	79 27                	jns    800759 <umain+0xce>
			panic("open %s: %e", argv[1], r);
  800732:	89 44 24 10          	mov    %eax,0x10(%esp)
  800736:	8b 46 04             	mov    0x4(%esi),%eax
  800739:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073d:	c7 44 24 08 df 38 80 	movl   $0x8038df,0x8(%esp)
  800744:	00 
  800745:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  80074c:	00 
  80074d:	c7 04 24 5f 38 80 00 	movl   $0x80385f,(%esp)
  800754:	e8 6e 03 00 00       	call   800ac7 <_panic>
		assert(r == 0);
  800759:	85 c0                	test   %eax,%eax
  80075b:	74 24                	je     800781 <umain+0xf6>
  80075d:	c7 44 24 0c eb 38 80 	movl   $0x8038eb,0xc(%esp)
  800764:	00 
  800765:	c7 44 24 08 f2 38 80 	movl   $0x8038f2,0x8(%esp)
  80076c:	00 
  80076d:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  800774:	00 
  800775:	c7 04 24 5f 38 80 00 	movl   $0x80385f,(%esp)
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
  80079b:	ba dc 38 80 00       	mov    $0x8038dc,%edx
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
  8007ba:	c7 04 24 07 39 80 00 	movl   $0x803907,(%esp)
  8007c1:	e8 fa 03 00 00       	call   800bc0 <cprintf>
			exit();	// end of file
  8007c6:	e8 e3 02 00 00       	call   800aae <exit>
		}
		if (debug)
  8007cb:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  8007d2:	74 10                	je     8007e4 <umain+0x159>
			cprintf("LINE: %s\n", buf);
  8007d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007d8:	c7 04 24 10 39 80 00 	movl   $0x803910,(%esp)
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
  8007f3:	c7 04 24 1a 39 80 00 	movl   $0x80391a,(%esp)
  8007fa:	e8 52 20 00 00       	call   802851 <printf>
		if (debug)
  8007ff:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800806:	74 0c                	je     800814 <umain+0x189>
			cprintf("BEFORE FORK\n");
  800808:	c7 04 24 20 39 80 00 	movl   $0x803920,(%esp)
  80080f:	e8 ac 03 00 00       	call   800bc0 <cprintf>
		if ((r = fork()) < 0)
  800814:	e8 f7 12 00 00       	call   801b10 <fork>
  800819:	89 c6                	mov    %eax,%esi
  80081b:	85 c0                	test   %eax,%eax
  80081d:	79 20                	jns    80083f <umain+0x1b4>
			panic("fork: %e", r);
  80081f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800823:	c7 44 24 08 3a 38 80 	movl   $0x80383a,0x8(%esp)
  80082a:	00 
  80082b:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  800832:	00 
  800833:	c7 04 24 5f 38 80 00 	movl   $0x80385f,(%esp)
  80083a:	e8 88 02 00 00       	call   800ac7 <_panic>
		if (debug)
  80083f:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800846:	74 10                	je     800858 <umain+0x1cd>
			cprintf("FORK: %d\n", r);
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 2d 39 80 00 	movl   $0x80392d,(%esp)
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
  800871:	e8 09 2a 00 00       	call   80327f <wait>
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
  800890:	c7 44 24 04 a9 39 80 	movl   $0x8039a9,0x4(%esp)
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
  800992:	e8 7f 18 00 00       	call   802216 <read>
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
  8009bf:	e8 a7 15 00 00       	call   801f6b <fd_lookup>
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
  8009e7:	e8 0b 15 00 00       	call   801ef7 <fd_alloc>
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
  800a2b:	e8 a0 14 00 00       	call   801ed0 <fd2num>
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
  800ab4:	e8 2d 16 00 00       	call   8020e6 <close_all>
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
  800af3:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  800afa:	e8 c1 00 00 00       	call   800bc0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800aff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b03:	8b 45 10             	mov    0x10(%ebp),%eax
  800b06:	89 04 24             	mov    %eax,(%esp)
  800b09:	e8 51 00 00 00       	call   800b5f <vcprintf>
	cprintf("\n");
  800b0e:	c7 04 24 c0 37 80 00 	movl   $0x8037c0,(%esp)
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
  800c5c:	e8 9f 28 00 00       	call   803500 <__udivdi3>
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
  800cb5:	e8 76 29 00 00       	call   803630 <__umoddi3>
  800cba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cbe:	0f be 80 e3 39 80 00 	movsbl 0x8039e3(%eax),%eax
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
  800ddc:	ff 24 85 20 3b 80 00 	jmp    *0x803b20(,%eax,4)
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
  800e8f:	8b 14 85 80 3c 80 00 	mov    0x803c80(,%eax,4),%edx
  800e96:	85 d2                	test   %edx,%edx
  800e98:	75 20                	jne    800eba <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  800e9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e9e:	c7 44 24 08 fb 39 80 	movl   $0x8039fb,0x8(%esp)
  800ea5:	00 
  800ea6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ead:	89 04 24             	mov    %eax,(%esp)
  800eb0:	e8 77 fe ff ff       	call   800d2c <printfmt>
  800eb5:	e9 c3 fe ff ff       	jmp    800d7d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  800eba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ebe:	c7 44 24 08 04 39 80 	movl   $0x803904,0x8(%esp)
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
  800eed:	ba f4 39 80 00       	mov    $0x8039f4,%edx
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
  8011d4:	c7 44 24 04 04 39 80 	movl   $0x803904,0x4(%esp)
  8011db:	00 
  8011dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8011e3:	e8 48 16 00 00       	call   802830 <fprintf>
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
  801218:	c7 04 24 df 3c 80 00 	movl   $0x803cdf,(%esp)
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
  801757:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  80175e:	00 
  80175f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801766:	00 
  801767:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  8017e9:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  8017f0:	00 
  8017f1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8017f8:	00 
  8017f9:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  80183c:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  801843:	00 
  801844:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80184b:	00 
  80184c:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  80188f:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  801896:	00 
  801897:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80189e:	00 
  80189f:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  8018e2:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  8018e9:	00 
  8018ea:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018f1:	00 
  8018f2:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  801935:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  80193c:	00 
  80193d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801944:	00 
  801945:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  801988:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  80198f:	00 
  801990:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801997:	00 
  801998:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  8019fd:	c7 44 24 08 ef 3c 80 	movl   $0x803cef,0x8(%esp)
  801a04:	00 
  801a05:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a0c:	00 
  801a0d:	c7 04 24 0c 3d 80 00 	movl   $0x803d0c,(%esp)
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
  801a44:	c7 44 24 08 1c 3d 80 	movl   $0x803d1c,0x8(%esp)
  801a4b:	00 
  801a4c:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  801a53:	00 
  801a54:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
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
  801a84:	c7 44 24 08 84 3d 80 	movl   $0x803d84,0x8(%esp)
  801a8b:	00 
  801a8c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801a93:	00 
  801a94:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
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
  801aee:	c7 44 24 08 9e 3d 80 	movl   $0x803d9e,0x8(%esp)
  801af5:	00 
  801af6:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801afd:	00 
  801afe:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
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
  801b20:	e8 c6 17 00 00       	call   8032eb <set_pgfault_handler>
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
  801b33:	c7 44 24 08 b7 3d 80 	movl   $0x803db7,0x8(%esp)
  801b3a:	00 
  801b3b:	c7 44 24 04 84 00 00 	movl   $0x84,0x4(%esp)
  801b42:	00 
  801b43:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
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
  801b78:	e9 c5 01 00 00       	jmp    801d42 <fork+0x232>
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
  801b8b:	0f 84 f2 00 00 00    	je     801c83 <fork+0x173>
			continue;
		}

		if (!(uvpt[pn_beg] & (PTE_P | PTE_U))) {
  801b91:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801b98:	a8 05                	test   $0x5,%al
  801b9a:	0f 84 e3 00 00 00    	je     801c83 <fork+0x173>
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
	// get current page permitssion
	void* va = (void*)(pn * PGSIZE);
	if ((pte & PTE_W) || (pte & PTE_COW)) { // for writable or copy-on-write page
  801bac:	a9 02 08 00 00       	test   $0x802,%eax
  801bb1:	0f 84 88 00 00 00    	je     801c3f <fork+0x12f>

		// set as readonly and copy-on-write
		int perm = PTE_U | PTE_P | PTE_COW;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801bb7:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801bbe:	00 
  801bbf:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bc3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801bc7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bcb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd2:	e8 36 fc ff ff       	call   80180d <sys_page_map>
  801bd7:	85 c0                	test   %eax,%eax
  801bd9:	79 20                	jns    801bfb <fork+0xeb>
			panic("duppage:sys_page_map:1:%e", err_code);
  801bdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bdf:	c7 44 24 08 bc 3d 80 	movl   $0x803dbc,0x8(%esp)
  801be6:	00 
  801be7:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  801bee:	00 
  801bef:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801bf6:	e8 cc ee ff ff       	call   800ac7 <_panic>
		}

		// remap
		if ((err_code = sys_page_map(envid, va, 0, va, perm)) < 0) {
  801bfb:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801c02:	00 
  801c03:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c0e:	00 
  801c0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c13:	89 3c 24             	mov    %edi,(%esp)
  801c16:	e8 f2 fb ff ff       	call   80180d <sys_page_map>
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	79 64                	jns    801c83 <fork+0x173>
			panic("duppage:sys_page_map:2:%e", err_code);
  801c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c23:	c7 44 24 08 d6 3d 80 	movl   $0x803dd6,0x8(%esp)
  801c2a:	00 
  801c2b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801c32:	00 
  801c33:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801c3a:	e8 88 ee ff ff       	call   800ac7 <_panic>
		}

	} else { // read-only page
		int perm = PTE_U | PTE_P;
		if ((err_code = sys_page_map(0, va, envid, va, perm)) < 0) {
  801c3f:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801c46:	00 
  801c47:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c4b:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801c4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c5a:	e8 ae fb ff ff       	call   80180d <sys_page_map>
  801c5f:	85 c0                	test   %eax,%eax
  801c61:	79 20                	jns    801c83 <fork+0x173>
			panic("sys_page_map:3:%e", err_code);
  801c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c67:	c7 44 24 08 f0 3d 80 	movl   $0x803df0,0x8(%esp)
  801c6e:	00 
  801c6f:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  801c76:	00 
  801c77:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801c7e:	e8 44 ee ff ff       	call   800ac7 <_panic>
	}

	// copy "mapping"
	uint32_t pn_beg = UTEXT >> PTXSHIFT;
	uint32_t pn_end = USTACKTOP >> PTXSHIFT;
	for (; pn_beg < pn_end; ++pn_beg) {
  801c83:	83 c3 01             	add    $0x1,%ebx
  801c86:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801c8c:	0f 85 eb fe ff ff    	jne    801b7d <fork+0x6d>

	int err_code;

	// set child process's page fault upcall entry point
	// we don't need to install the handler since the "share mapping" !
	if ((err_code = sys_env_set_pgfault_upcall(envid, _pgfault_upcall)) < 0) {
  801c92:	c7 44 24 04 54 33 80 	movl   $0x803354,0x4(%esp)
  801c99:	00 
  801c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9d:	89 04 24             	mov    %eax,(%esp)
  801ca0:	e8 b4 fc ff ff       	call   801959 <sys_env_set_pgfault_upcall>
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	79 20                	jns    801cc9 <fork+0x1b9>
		panic("fork: sys_env_set_pgfault_upcall:%e\n", err_code);
  801ca9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cad:	c7 44 24 08 54 3d 80 	movl   $0x803d54,0x8(%esp)
  801cb4:	00 
  801cb5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  801cbc:	00 
  801cbd:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801cc4:	e8 fe ed ff ff       	call   800ac7 <_panic>
	}

	// allocate page for child's process exception stack
	if ((err_code = sys_page_alloc(envid, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801cc9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801cd0:	00 
  801cd1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801cd8:	ee 
  801cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cdc:	89 04 24             	mov    %eax,(%esp)
  801cdf:	e8 d5 fa ff ff       	call   8017b9 <sys_page_alloc>
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	79 20                	jns    801d08 <fork+0x1f8>
		panic("fork:sys_page_alloc:%e\n", err_code);
  801ce8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cec:	c7 44 24 08 02 3e 80 	movl   $0x803e02,0x8(%esp)
  801cf3:	00 
  801cf4:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  801cfb:	00 
  801cfc:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801d03:	e8 bf ed ff ff       	call   800ac7 <_panic>
	}

	if ((err_code = sys_env_set_status(envid, ENV_RUNNABLE)) < 0) {
  801d08:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801d0f:	00 
  801d10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d13:	89 04 24             	mov    %eax,(%esp)
  801d16:	e8 98 fb ff ff       	call   8018b3 <sys_env_set_status>
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	79 20                	jns    801d3f <fork+0x22f>
		panic("fork:sys_env_set_status:%e", err_code);
  801d1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d23:	c7 44 24 08 1a 3e 80 	movl   $0x803e1a,0x8(%esp)
  801d2a:	00 
  801d2b:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  801d32:	00 
  801d33:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801d3a:	e8 88 ed ff ff       	call   800ac7 <_panic>
	}

	return envid;
  801d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
  801d42:	83 c4 2c             	add    $0x2c,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    

00801d4a <sfork>:

// Challenge!
int
sfork(void)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801d50:	c7 44 24 08 35 3e 80 	movl   $0x803e35,0x8(%esp)
  801d57:	00 
  801d58:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  801d5f:	00 
  801d60:	c7 04 24 79 3d 80 00 	movl   $0x803d79,(%esp)
  801d67:	e8 5b ed ff ff       	call   800ac7 <_panic>

00801d6c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	53                   	push   %ebx
  801d70:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d76:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801d79:	89 08                	mov    %ecx,(%eax)
	args->argv = (const char **) argv;
  801d7b:	89 50 04             	mov    %edx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d83:	83 39 01             	cmpl   $0x1,(%ecx)
  801d86:	7e 0f                	jle    801d97 <argstart+0x2b>
  801d88:	85 d2                	test   %edx,%edx
  801d8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8f:	bb c1 37 80 00       	mov    $0x8037c1,%ebx
  801d94:	0f 44 da             	cmove  %edx,%ebx
  801d97:	89 58 08             	mov    %ebx,0x8(%eax)
	args->argvalue = 0;
  801d9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801da1:	5b                   	pop    %ebx
  801da2:	5d                   	pop    %ebp
  801da3:	c3                   	ret    

00801da4 <argnext>:

int
argnext(struct Argstate *args)
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
  801da7:	53                   	push   %ebx
  801da8:	83 ec 14             	sub    $0x14,%esp
  801dab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801dae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801db5:	8b 43 08             	mov    0x8(%ebx),%eax
  801db8:	85 c0                	test   %eax,%eax
  801dba:	74 71                	je     801e2d <argnext+0x89>
		return -1;

	if (!*args->curarg) {
  801dbc:	80 38 00             	cmpb   $0x0,(%eax)
  801dbf:	75 50                	jne    801e11 <argnext+0x6d>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801dc1:	8b 0b                	mov    (%ebx),%ecx
  801dc3:	83 39 01             	cmpl   $0x1,(%ecx)
  801dc6:	74 57                	je     801e1f <argnext+0x7b>
		    || args->argv[1][0] != '-'
  801dc8:	8b 53 04             	mov    0x4(%ebx),%edx
  801dcb:	8b 42 04             	mov    0x4(%edx),%eax
  801dce:	80 38 2d             	cmpb   $0x2d,(%eax)
  801dd1:	75 4c                	jne    801e1f <argnext+0x7b>
		    || args->argv[1][1] == '\0')
  801dd3:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801dd7:	74 46                	je     801e1f <argnext+0x7b>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801dd9:	83 c0 01             	add    $0x1,%eax
  801ddc:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801ddf:	8b 01                	mov    (%ecx),%eax
  801de1:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801de8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dec:	8d 42 08             	lea    0x8(%edx),%eax
  801def:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df3:	83 c2 04             	add    $0x4,%edx
  801df6:	89 14 24             	mov    %edx,(%esp)
  801df9:	e8 08 f7 ff ff       	call   801506 <memmove>
		(*args->argc)--;
  801dfe:	8b 03                	mov    (%ebx),%eax
  801e00:	83 28 01             	subl   $0x1,(%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801e03:	8b 43 08             	mov    0x8(%ebx),%eax
  801e06:	80 38 2d             	cmpb   $0x2d,(%eax)
  801e09:	75 06                	jne    801e11 <argnext+0x6d>
  801e0b:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801e0f:	74 0e                	je     801e1f <argnext+0x7b>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801e11:	8b 53 08             	mov    0x8(%ebx),%edx
  801e14:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801e17:	83 c2 01             	add    $0x1,%edx
  801e1a:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;
  801e1d:	eb 13                	jmp    801e32 <argnext+0x8e>

    endofargs:
	args->curarg = 0;
  801e1f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801e26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801e2b:	eb 05                	jmp    801e32 <argnext+0x8e>

	args->argvalue = 0;

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
		return -1;
  801e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801e32:	83 c4 14             	add    $0x14,%esp
  801e35:	5b                   	pop    %ebx
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    

00801e38 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 14             	sub    $0x14,%esp
  801e3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801e42:	8b 43 08             	mov    0x8(%ebx),%eax
  801e45:	85 c0                	test   %eax,%eax
  801e47:	74 5a                	je     801ea3 <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801e49:	80 38 00             	cmpb   $0x0,(%eax)
  801e4c:	74 0c                	je     801e5a <argnextvalue+0x22>
		args->argvalue = args->curarg;
  801e4e:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801e51:	c7 43 08 c1 37 80 00 	movl   $0x8037c1,0x8(%ebx)
  801e58:	eb 44                	jmp    801e9e <argnextvalue+0x66>
	} else if (*args->argc > 1) {
  801e5a:	8b 03                	mov    (%ebx),%eax
  801e5c:	83 38 01             	cmpl   $0x1,(%eax)
  801e5f:	7e 2f                	jle    801e90 <argnextvalue+0x58>
		args->argvalue = args->argv[1];
  801e61:	8b 53 04             	mov    0x4(%ebx),%edx
  801e64:	8b 4a 04             	mov    0x4(%edx),%ecx
  801e67:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801e6a:	8b 00                	mov    (%eax),%eax
  801e6c:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801e73:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e77:	8d 42 08             	lea    0x8(%edx),%eax
  801e7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7e:	83 c2 04             	add    $0x4,%edx
  801e81:	89 14 24             	mov    %edx,(%esp)
  801e84:	e8 7d f6 ff ff       	call   801506 <memmove>
		(*args->argc)--;
  801e89:	8b 03                	mov    (%ebx),%eax
  801e8b:	83 28 01             	subl   $0x1,(%eax)
  801e8e:	eb 0e                	jmp    801e9e <argnextvalue+0x66>
	} else {
		args->argvalue = 0;
  801e90:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801e97:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	}
	return (char*) args->argvalue;
  801e9e:	8b 43 0c             	mov    0xc(%ebx),%eax
  801ea1:	eb 05                	jmp    801ea8 <argnextvalue+0x70>

char *
argnextvalue(struct Argstate *args)
{
	if (!args->curarg)
		return 0;
  801ea3:	b8 00 00 00 00       	mov    $0x0,%eax
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
}
  801ea8:	83 c4 14             	add    $0x14,%esp
  801eab:	5b                   	pop    %ebx
  801eac:	5d                   	pop    %ebp
  801ead:	c3                   	ret    

00801eae <argvalue>:
	return -1;
}

char *
argvalue(struct Argstate *args)
{
  801eae:	55                   	push   %ebp
  801eaf:	89 e5                	mov    %esp,%ebp
  801eb1:	83 ec 18             	sub    $0x18,%esp
  801eb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801eb7:	8b 51 0c             	mov    0xc(%ecx),%edx
  801eba:	89 d0                	mov    %edx,%eax
  801ebc:	85 d2                	test   %edx,%edx
  801ebe:	75 08                	jne    801ec8 <argvalue+0x1a>
  801ec0:	89 0c 24             	mov    %ecx,(%esp)
  801ec3:	e8 70 ff ff ff       	call   801e38 <argnextvalue>
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    
  801eca:	66 90                	xchg   %ax,%ax
  801ecc:	66 90                	xchg   %ax,%ax
  801ece:	66 90                	xchg   %ax,%ax

00801ed0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed6:	05 00 00 00 30       	add    $0x30000000,%eax
  801edb:	c1 e8 0c             	shr    $0xc,%eax
}
  801ede:	5d                   	pop    %ebp
  801edf:	c3                   	ret    

00801ee0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801eeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ef0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801ef5:	5d                   	pop    %ebp
  801ef6:	c3                   	ret    

00801ef7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801efa:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801eff:	a8 01                	test   $0x1,%al
  801f01:	74 34                	je     801f37 <fd_alloc+0x40>
  801f03:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801f08:	a8 01                	test   $0x1,%al
  801f0a:	74 32                	je     801f3e <fd_alloc+0x47>
  801f0c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801f11:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801f13:	89 c2                	mov    %eax,%edx
  801f15:	c1 ea 16             	shr    $0x16,%edx
  801f18:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f1f:	f6 c2 01             	test   $0x1,%dl
  801f22:	74 1f                	je     801f43 <fd_alloc+0x4c>
  801f24:	89 c2                	mov    %eax,%edx
  801f26:	c1 ea 0c             	shr    $0xc,%edx
  801f29:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f30:	f6 c2 01             	test   $0x1,%dl
  801f33:	75 1a                	jne    801f4f <fd_alloc+0x58>
  801f35:	eb 0c                	jmp    801f43 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801f37:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801f3c:	eb 05                	jmp    801f43 <fd_alloc+0x4c>
  801f3e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	89 08                	mov    %ecx,(%eax)
			return 0;
  801f48:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4d:	eb 1a                	jmp    801f69 <fd_alloc+0x72>
  801f4f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801f54:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801f59:	75 b6                	jne    801f11 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801f64:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801f71:	83 f8 1f             	cmp    $0x1f,%eax
  801f74:	77 36                	ja     801fac <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801f76:	c1 e0 0c             	shl    $0xc,%eax
  801f79:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801f7e:	89 c2                	mov    %eax,%edx
  801f80:	c1 ea 16             	shr    $0x16,%edx
  801f83:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801f8a:	f6 c2 01             	test   $0x1,%dl
  801f8d:	74 24                	je     801fb3 <fd_lookup+0x48>
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	c1 ea 0c             	shr    $0xc,%edx
  801f94:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f9b:	f6 c2 01             	test   $0x1,%dl
  801f9e:	74 1a                	je     801fba <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	89 02                	mov    %eax,(%edx)
	return 0;
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	eb 13                	jmp    801fbf <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fb1:	eb 0c                	jmp    801fbf <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801fb3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fb8:	eb 05                	jmp    801fbf <fd_lookup+0x54>
  801fba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	53                   	push   %ebx
  801fc5:	83 ec 14             	sub    $0x14,%esp
  801fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801fce:	39 05 20 50 80 00    	cmp    %eax,0x805020
  801fd4:	75 1e                	jne    801ff4 <dev_lookup+0x33>
  801fd6:	eb 0e                	jmp    801fe6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801fd8:	b8 3c 50 80 00       	mov    $0x80503c,%eax
  801fdd:	eb 0c                	jmp    801feb <dev_lookup+0x2a>
  801fdf:	b8 00 50 80 00       	mov    $0x805000,%eax
  801fe4:	eb 05                	jmp    801feb <dev_lookup+0x2a>
  801fe6:	b8 20 50 80 00       	mov    $0x805020,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801feb:	89 03                	mov    %eax,(%ebx)
			return 0;
  801fed:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff2:	eb 38                	jmp    80202c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801ff4:	39 05 3c 50 80 00    	cmp    %eax,0x80503c
  801ffa:	74 dc                	je     801fd8 <dev_lookup+0x17>
  801ffc:	39 05 00 50 80 00    	cmp    %eax,0x805000
  802002:	74 db                	je     801fdf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802004:	8b 15 24 64 80 00    	mov    0x806424,%edx
  80200a:	8b 52 48             	mov    0x48(%edx),%edx
  80200d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802011:	89 54 24 04          	mov    %edx,0x4(%esp)
  802015:	c7 04 24 4c 3e 80 00 	movl   $0x803e4c,(%esp)
  80201c:	e8 9f eb ff ff       	call   800bc0 <cprintf>
	*dev = 0;
  802021:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  802027:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80202c:	83 c4 14             	add    $0x14,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	56                   	push   %esi
  802036:	53                   	push   %ebx
  802037:	83 ec 20             	sub    $0x20,%esp
  80203a:	8b 75 08             	mov    0x8(%ebp),%esi
  80203d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802040:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  802047:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80204d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802050:	89 04 24             	mov    %eax,(%esp)
  802053:	e8 13 ff ff ff       	call   801f6b <fd_lookup>
  802058:	85 c0                	test   %eax,%eax
  80205a:	78 05                	js     802061 <fd_close+0x2f>
	    || fd != fd2)
  80205c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80205f:	74 0c                	je     80206d <fd_close+0x3b>
		return (must_exist ? r : 0);
  802061:	84 db                	test   %bl,%bl
  802063:	ba 00 00 00 00       	mov    $0x0,%edx
  802068:	0f 44 c2             	cmove  %edx,%eax
  80206b:	eb 3f                	jmp    8020ac <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80206d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	8b 06                	mov    (%esi),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 43 ff ff ff       	call   801fc1 <dev_lookup>
  80207e:	89 c3                	mov    %eax,%ebx
  802080:	85 c0                	test   %eax,%eax
  802082:	78 16                	js     80209a <fd_close+0x68>
		if (dev->dev_close)
  802084:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802087:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80208a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80208f:	85 c0                	test   %eax,%eax
  802091:	74 07                	je     80209a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  802093:	89 34 24             	mov    %esi,(%esp)
  802096:	ff d0                	call   *%eax
  802098:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80209a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80209e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a5:	e8 b6 f7 ff ff       	call   801860 <sys_page_unmap>
	return r;
  8020aa:	89 d8                	mov    %ebx,%eax
}
  8020ac:	83 c4 20             	add    $0x20,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    

008020b3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	89 04 24             	mov    %eax,(%esp)
  8020c6:	e8 a0 fe ff ff       	call   801f6b <fd_lookup>
  8020cb:	89 c2                	mov    %eax,%edx
  8020cd:	85 d2                	test   %edx,%edx
  8020cf:	78 13                	js     8020e4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8020d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8020d8:	00 
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	89 04 24             	mov    %eax,(%esp)
  8020df:	e8 4e ff ff ff       	call   802032 <fd_close>
}
  8020e4:	c9                   	leave  
  8020e5:	c3                   	ret    

008020e6 <close_all>:

void
close_all(void)
{
  8020e6:	55                   	push   %ebp
  8020e7:	89 e5                	mov    %esp,%ebp
  8020e9:	53                   	push   %ebx
  8020ea:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8020ed:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8020f2:	89 1c 24             	mov    %ebx,(%esp)
  8020f5:	e8 b9 ff ff ff       	call   8020b3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020fa:	83 c3 01             	add    $0x1,%ebx
  8020fd:	83 fb 20             	cmp    $0x20,%ebx
  802100:	75 f0                	jne    8020f2 <close_all+0xc>
		close(i);
}
  802102:	83 c4 14             	add    $0x14,%esp
  802105:	5b                   	pop    %ebx
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	57                   	push   %edi
  80210c:	56                   	push   %esi
  80210d:	53                   	push   %ebx
  80210e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802111:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802114:	89 44 24 04          	mov    %eax,0x4(%esp)
  802118:	8b 45 08             	mov    0x8(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 48 fe ff ff       	call   801f6b <fd_lookup>
  802123:	89 c2                	mov    %eax,%edx
  802125:	85 d2                	test   %edx,%edx
  802127:	0f 88 e1 00 00 00    	js     80220e <dup+0x106>
		return r;
	close(newfdnum);
  80212d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802130:	89 04 24             	mov    %eax,(%esp)
  802133:	e8 7b ff ff ff       	call   8020b3 <close>

	newfd = INDEX2FD(newfdnum);
  802138:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80213b:	c1 e3 0c             	shl    $0xc,%ebx
  80213e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802144:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802147:	89 04 24             	mov    %eax,(%esp)
  80214a:	e8 91 fd ff ff       	call   801ee0 <fd2data>
  80214f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802151:	89 1c 24             	mov    %ebx,(%esp)
  802154:	e8 87 fd ff ff       	call   801ee0 <fd2data>
  802159:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80215b:	89 f0                	mov    %esi,%eax
  80215d:	c1 e8 16             	shr    $0x16,%eax
  802160:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802167:	a8 01                	test   $0x1,%al
  802169:	74 43                	je     8021ae <dup+0xa6>
  80216b:	89 f0                	mov    %esi,%eax
  80216d:	c1 e8 0c             	shr    $0xc,%eax
  802170:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802177:	f6 c2 01             	test   $0x1,%dl
  80217a:	74 32                	je     8021ae <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80217c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802183:	25 07 0e 00 00       	and    $0xe07,%eax
  802188:	89 44 24 10          	mov    %eax,0x10(%esp)
  80218c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802190:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802197:	00 
  802198:	89 74 24 04          	mov    %esi,0x4(%esp)
  80219c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a3:	e8 65 f6 ff ff       	call   80180d <sys_page_map>
  8021a8:	89 c6                	mov    %eax,%esi
  8021aa:	85 c0                	test   %eax,%eax
  8021ac:	78 3e                	js     8021ec <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b1:	89 c2                	mov    %eax,%edx
  8021b3:	c1 ea 0c             	shr    $0xc,%edx
  8021b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8021bd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8021c3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021c7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8021cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021d2:	00 
  8021d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021de:	e8 2a f6 ff ff       	call   80180d <sys_page_map>
  8021e3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8021e8:	85 f6                	test   %esi,%esi
  8021ea:	79 22                	jns    80220e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8021ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f7:	e8 64 f6 ff ff       	call   801860 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8021fc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802200:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802207:	e8 54 f6 ff ff       	call   801860 <sys_page_unmap>
	return r;
  80220c:	89 f0                	mov    %esi,%eax
}
  80220e:	83 c4 3c             	add    $0x3c,%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	53                   	push   %ebx
  80221a:	83 ec 24             	sub    $0x24,%esp
  80221d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802220:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802223:	89 44 24 04          	mov    %eax,0x4(%esp)
  802227:	89 1c 24             	mov    %ebx,(%esp)
  80222a:	e8 3c fd ff ff       	call   801f6b <fd_lookup>
  80222f:	89 c2                	mov    %eax,%edx
  802231:	85 d2                	test   %edx,%edx
  802233:	78 6d                	js     8022a2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802235:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80223c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223f:	8b 00                	mov    (%eax),%eax
  802241:	89 04 24             	mov    %eax,(%esp)
  802244:	e8 78 fd ff ff       	call   801fc1 <dev_lookup>
  802249:	85 c0                	test   %eax,%eax
  80224b:	78 55                	js     8022a2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80224d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802250:	8b 50 08             	mov    0x8(%eax),%edx
  802253:	83 e2 03             	and    $0x3,%edx
  802256:	83 fa 01             	cmp    $0x1,%edx
  802259:	75 23                	jne    80227e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80225b:	a1 24 64 80 00       	mov    0x806424,%eax
  802260:	8b 40 48             	mov    0x48(%eax),%eax
  802263:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802267:	89 44 24 04          	mov    %eax,0x4(%esp)
  80226b:	c7 04 24 8d 3e 80 00 	movl   $0x803e8d,(%esp)
  802272:	e8 49 e9 ff ff       	call   800bc0 <cprintf>
		return -E_INVAL;
  802277:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80227c:	eb 24                	jmp    8022a2 <read+0x8c>
	}
	if (!dev->dev_read)
  80227e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802281:	8b 52 08             	mov    0x8(%edx),%edx
  802284:	85 d2                	test   %edx,%edx
  802286:	74 15                	je     80229d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802288:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80228b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80228f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802292:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802296:	89 04 24             	mov    %eax,(%esp)
  802299:	ff d2                	call   *%edx
  80229b:	eb 05                	jmp    8022a2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80229d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8022a2:	83 c4 24             	add    $0x24,%esp
  8022a5:	5b                   	pop    %ebx
  8022a6:	5d                   	pop    %ebp
  8022a7:	c3                   	ret    

008022a8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	57                   	push   %edi
  8022ac:	56                   	push   %esi
  8022ad:	53                   	push   %ebx
  8022ae:	83 ec 1c             	sub    $0x1c,%esp
  8022b1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022b4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022b7:	85 f6                	test   %esi,%esi
  8022b9:	74 33                	je     8022ee <readn+0x46>
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8022c5:	89 f2                	mov    %esi,%edx
  8022c7:	29 c2                	sub    %eax,%edx
  8022c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cd:	03 45 0c             	add    0xc(%ebp),%eax
  8022d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d4:	89 3c 24             	mov    %edi,(%esp)
  8022d7:	e8 3a ff ff ff       	call   802216 <read>
		if (m < 0)
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	78 1b                	js     8022fb <readn+0x53>
			return m;
		if (m == 0)
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 11                	je     8022f5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8022e4:	01 c3                	add    %eax,%ebx
  8022e6:	89 d8                	mov    %ebx,%eax
  8022e8:	39 f3                	cmp    %esi,%ebx
  8022ea:	72 d9                	jb     8022c5 <readn+0x1d>
  8022ec:	eb 0b                	jmp    8022f9 <readn+0x51>
  8022ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f3:	eb 06                	jmp    8022fb <readn+0x53>
  8022f5:	89 d8                	mov    %ebx,%eax
  8022f7:	eb 02                	jmp    8022fb <readn+0x53>
  8022f9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8022fb:	83 c4 1c             	add    $0x1c,%esp
  8022fe:	5b                   	pop    %ebx
  8022ff:	5e                   	pop    %esi
  802300:	5f                   	pop    %edi
  802301:	5d                   	pop    %ebp
  802302:	c3                   	ret    

00802303 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	53                   	push   %ebx
  802307:	83 ec 24             	sub    $0x24,%esp
  80230a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802310:	89 44 24 04          	mov    %eax,0x4(%esp)
  802314:	89 1c 24             	mov    %ebx,(%esp)
  802317:	e8 4f fc ff ff       	call   801f6b <fd_lookup>
  80231c:	89 c2                	mov    %eax,%edx
  80231e:	85 d2                	test   %edx,%edx
  802320:	78 68                	js     80238a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802322:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802325:	89 44 24 04          	mov    %eax,0x4(%esp)
  802329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232c:	8b 00                	mov    (%eax),%eax
  80232e:	89 04 24             	mov    %eax,(%esp)
  802331:	e8 8b fc ff ff       	call   801fc1 <dev_lookup>
  802336:	85 c0                	test   %eax,%eax
  802338:	78 50                	js     80238a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80233a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802341:	75 23                	jne    802366 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802343:	a1 24 64 80 00       	mov    0x806424,%eax
  802348:	8b 40 48             	mov    0x48(%eax),%eax
  80234b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802353:	c7 04 24 a9 3e 80 00 	movl   $0x803ea9,(%esp)
  80235a:	e8 61 e8 ff ff       	call   800bc0 <cprintf>
		return -E_INVAL;
  80235f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802364:	eb 24                	jmp    80238a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802366:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802369:	8b 52 0c             	mov    0xc(%edx),%edx
  80236c:	85 d2                	test   %edx,%edx
  80236e:	74 15                	je     802385 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802370:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802373:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802377:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80237a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80237e:	89 04 24             	mov    %eax,(%esp)
  802381:	ff d2                	call   *%edx
  802383:	eb 05                	jmp    80238a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802385:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80238a:	83 c4 24             	add    $0x24,%esp
  80238d:	5b                   	pop    %ebx
  80238e:	5d                   	pop    %ebp
  80238f:	c3                   	ret    

00802390 <seek>:

int
seek(int fdnum, off_t offset)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802396:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	89 04 24             	mov    %eax,(%esp)
  8023a3:	e8 c3 fb ff ff       	call   801f6b <fd_lookup>
  8023a8:	85 c0                	test   %eax,%eax
  8023aa:	78 0e                	js     8023ba <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8023ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	53                   	push   %ebx
  8023c0:	83 ec 24             	sub    $0x24,%esp
  8023c3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8023c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023cd:	89 1c 24             	mov    %ebx,(%esp)
  8023d0:	e8 96 fb ff ff       	call   801f6b <fd_lookup>
  8023d5:	89 c2                	mov    %eax,%edx
  8023d7:	85 d2                	test   %edx,%edx
  8023d9:	78 61                	js     80243c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8023db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	89 04 24             	mov    %eax,(%esp)
  8023ea:	e8 d2 fb ff ff       	call   801fc1 <dev_lookup>
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 49                	js     80243c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8023f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8023fa:	75 23                	jne    80241f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8023fc:	a1 24 64 80 00       	mov    0x806424,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802401:	8b 40 48             	mov    0x48(%eax),%eax
  802404:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802408:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240c:	c7 04 24 6c 3e 80 00 	movl   $0x803e6c,(%esp)
  802413:	e8 a8 e7 ff ff       	call   800bc0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802418:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80241d:	eb 1d                	jmp    80243c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80241f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802422:	8b 52 18             	mov    0x18(%edx),%edx
  802425:	85 d2                	test   %edx,%edx
  802427:	74 0e                	je     802437 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802429:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80242c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802430:	89 04 24             	mov    %eax,(%esp)
  802433:	ff d2                	call   *%edx
  802435:	eb 05                	jmp    80243c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  802437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80243c:	83 c4 24             	add    $0x24,%esp
  80243f:	5b                   	pop    %ebx
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    

00802442 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802442:	55                   	push   %ebp
  802443:	89 e5                	mov    %esp,%ebp
  802445:	53                   	push   %ebx
  802446:	83 ec 24             	sub    $0x24,%esp
  802449:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80244c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80244f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	89 04 24             	mov    %eax,(%esp)
  802459:	e8 0d fb ff ff       	call   801f6b <fd_lookup>
  80245e:	89 c2                	mov    %eax,%edx
  802460:	85 d2                	test   %edx,%edx
  802462:	78 52                	js     8024b6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802464:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802467:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	89 04 24             	mov    %eax,(%esp)
  802473:	e8 49 fb ff ff       	call   801fc1 <dev_lookup>
  802478:	85 c0                	test   %eax,%eax
  80247a:	78 3a                	js     8024b6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802483:	74 2c                	je     8024b1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802485:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802488:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80248f:	00 00 00 
	stat->st_isdir = 0;
  802492:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802499:	00 00 00 
	stat->st_dev = dev;
  80249c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8024a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a9:	89 14 24             	mov    %edx,(%esp)
  8024ac:	ff 50 14             	call   *0x14(%eax)
  8024af:	eb 05                	jmp    8024b6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8024b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8024b6:	83 c4 24             	add    $0x24,%esp
  8024b9:	5b                   	pop    %ebx
  8024ba:	5d                   	pop    %ebp
  8024bb:	c3                   	ret    

008024bc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	56                   	push   %esi
  8024c0:	53                   	push   %ebx
  8024c1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024cb:	00 
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	89 04 24             	mov    %eax,(%esp)
  8024d2:	e8 e1 01 00 00       	call   8026b8 <open>
  8024d7:	89 c3                	mov    %eax,%ebx
  8024d9:	85 db                	test   %ebx,%ebx
  8024db:	78 1b                	js     8024f8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8024dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e4:	89 1c 24             	mov    %ebx,(%esp)
  8024e7:	e8 56 ff ff ff       	call   802442 <fstat>
  8024ec:	89 c6                	mov    %eax,%esi
	close(fd);
  8024ee:	89 1c 24             	mov    %ebx,(%esp)
  8024f1:	e8 bd fb ff ff       	call   8020b3 <close>
	return r;
  8024f6:	89 f0                	mov    %esi,%eax
}
  8024f8:	83 c4 10             	add    $0x10,%esp
  8024fb:	5b                   	pop    %ebx
  8024fc:	5e                   	pop    %esi
  8024fd:	5d                   	pop    %ebp
  8024fe:	c3                   	ret    

008024ff <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	56                   	push   %esi
  802503:	53                   	push   %ebx
  802504:	83 ec 10             	sub    $0x10,%esp
  802507:	89 c3                	mov    %eax,%ebx
  802509:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  80250b:	83 3d 20 64 80 00 00 	cmpl   $0x0,0x806420
  802512:	75 11                	jne    802525 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80251b:	e8 53 0f 00 00       	call   803473 <ipc_find_env>
  802520:	a3 20 64 80 00       	mov    %eax,0x806420

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  802525:	a1 24 64 80 00       	mov    0x806424,%eax
  80252a:	8b 40 48             	mov    0x48(%eax),%eax
  80252d:	8b 15 00 70 80 00    	mov    0x807000,%edx
  802533:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802537:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80253b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253f:	c7 04 24 c6 3e 80 00 	movl   $0x803ec6,(%esp)
  802546:	e8 75 e6 ff ff       	call   800bc0 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80254b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802552:	00 
  802553:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  80255a:	00 
  80255b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80255f:	a1 20 64 80 00       	mov    0x806420,%eax
  802564:	89 04 24             	mov    %eax,(%esp)
  802567:	e8 a1 0e 00 00       	call   80340d <ipc_send>
	cprintf("ipc_send\n");
  80256c:	c7 04 24 dc 3e 80 00 	movl   $0x803edc,(%esp)
  802573:	e8 48 e6 ff ff       	call   800bc0 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  802578:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80257f:	00 
  802580:	89 74 24 04          	mov    %esi,0x4(%esp)
  802584:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80258b:	e8 15 0e 00 00       	call   8033a5 <ipc_recv>
}
  802590:	83 c4 10             	add    $0x10,%esp
  802593:	5b                   	pop    %ebx
  802594:	5e                   	pop    %esi
  802595:	5d                   	pop    %ebp
  802596:	c3                   	ret    

00802597 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	53                   	push   %ebx
  80259b:	83 ec 14             	sub    $0x14,%esp
  80259e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8025a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a7:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8025ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8025b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8025b6:	e8 44 ff ff ff       	call   8024ff <fsipc>
  8025bb:	89 c2                	mov    %eax,%edx
  8025bd:	85 d2                	test   %edx,%edx
  8025bf:	78 2b                	js     8025ec <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8025c1:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8025c8:	00 
  8025c9:	89 1c 24             	mov    %ebx,(%esp)
  8025cc:	e8 3a ed ff ff       	call   80130b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8025d1:	a1 80 70 80 00       	mov    0x807080,%eax
  8025d6:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8025dc:	a1 84 70 80 00       	mov    0x807084,%eax
  8025e1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8025e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ec:	83 c4 14             	add    $0x14,%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    

008025f2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8025f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  802603:	ba 00 00 00 00       	mov    $0x0,%edx
  802608:	b8 06 00 00 00       	mov    $0x6,%eax
  80260d:	e8 ed fe ff ff       	call   8024ff <fsipc>
}
  802612:	c9                   	leave  
  802613:	c3                   	ret    

00802614 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802614:	55                   	push   %ebp
  802615:	89 e5                	mov    %esp,%ebp
  802617:	56                   	push   %esi
  802618:	53                   	push   %ebx
  802619:	83 ec 10             	sub    $0x10,%esp
  80261c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	8b 40 0c             	mov    0xc(%eax),%eax
  802625:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  80262a:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802630:	ba 00 00 00 00       	mov    $0x0,%edx
  802635:	b8 03 00 00 00       	mov    $0x3,%eax
  80263a:	e8 c0 fe ff ff       	call   8024ff <fsipc>
  80263f:	89 c3                	mov    %eax,%ebx
  802641:	85 c0                	test   %eax,%eax
  802643:	78 6a                	js     8026af <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802645:	39 c6                	cmp    %eax,%esi
  802647:	73 24                	jae    80266d <devfile_read+0x59>
  802649:	c7 44 24 0c e6 3e 80 	movl   $0x803ee6,0xc(%esp)
  802650:	00 
  802651:	c7 44 24 08 f2 38 80 	movl   $0x8038f2,0x8(%esp)
  802658:	00 
  802659:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802660:	00 
  802661:	c7 04 24 ed 3e 80 00 	movl   $0x803eed,(%esp)
  802668:	e8 5a e4 ff ff       	call   800ac7 <_panic>
	assert(r <= PGSIZE);
  80266d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802672:	7e 24                	jle    802698 <devfile_read+0x84>
  802674:	c7 44 24 0c f8 3e 80 	movl   $0x803ef8,0xc(%esp)
  80267b:	00 
  80267c:	c7 44 24 08 f2 38 80 	movl   $0x8038f2,0x8(%esp)
  802683:	00 
  802684:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80268b:	00 
  80268c:	c7 04 24 ed 3e 80 00 	movl   $0x803eed,(%esp)
  802693:	e8 2f e4 ff ff       	call   800ac7 <_panic>
	memmove(buf, &fsipcbuf, r);
  802698:	89 44 24 08          	mov    %eax,0x8(%esp)
  80269c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8026a3:	00 
  8026a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a7:	89 04 24             	mov    %eax,(%esp)
  8026aa:	e8 57 ee ff ff       	call   801506 <memmove>
	return r;
}
  8026af:	89 d8                	mov    %ebx,%eax
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    

008026b8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8026b8:	55                   	push   %ebp
  8026b9:	89 e5                	mov    %esp,%ebp
  8026bb:	53                   	push   %ebx
  8026bc:	83 ec 24             	sub    $0x24,%esp
  8026bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8026c2:	89 1c 24             	mov    %ebx,(%esp)
  8026c5:	e8 e6 eb ff ff       	call   8012b0 <strlen>
  8026ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8026cf:	7f 60                	jg     802731 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8026d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026d4:	89 04 24             	mov    %eax,(%esp)
  8026d7:	e8 1b f8 ff ff       	call   801ef7 <fd_alloc>
  8026dc:	89 c2                	mov    %eax,%edx
  8026de:	85 d2                	test   %edx,%edx
  8026e0:	78 54                	js     802736 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8026e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026e6:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  8026ed:	e8 19 ec ff ff       	call   80130b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8026f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f5:	a3 00 74 80 00       	mov    %eax,0x807400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8026fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802702:	e8 f8 fd ff ff       	call   8024ff <fsipc>
  802707:	89 c3                	mov    %eax,%ebx
  802709:	85 c0                	test   %eax,%eax
  80270b:	79 17                	jns    802724 <open+0x6c>
		fd_close(fd, 0);
  80270d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802714:	00 
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	89 04 24             	mov    %eax,(%esp)
  80271b:	e8 12 f9 ff ff       	call   802032 <fd_close>
		return r;
  802720:	89 d8                	mov    %ebx,%eax
  802722:	eb 12                	jmp    802736 <open+0x7e>
	}
	return fd2num(fd);
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	89 04 24             	mov    %eax,(%esp)
  80272a:	e8 a1 f7 ff ff       	call   801ed0 <fd2num>
  80272f:	eb 05                	jmp    802736 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  802731:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  802736:	83 c4 24             	add    $0x24,%esp
  802739:	5b                   	pop    %ebx
  80273a:	5d                   	pop    %ebp
  80273b:	c3                   	ret    

0080273c <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  80273c:	55                   	push   %ebp
  80273d:	89 e5                	mov    %esp,%ebp
  80273f:	53                   	push   %ebx
  802740:	83 ec 14             	sub    $0x14,%esp
  802743:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  802745:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802749:	7e 31                	jle    80277c <writebuf+0x40>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802752:	8d 43 10             	lea    0x10(%ebx),%eax
  802755:	89 44 24 04          	mov    %eax,0x4(%esp)
  802759:	8b 03                	mov    (%ebx),%eax
  80275b:	89 04 24             	mov    %eax,(%esp)
  80275e:	e8 a0 fb ff ff       	call   802303 <write>
		if (result > 0)
  802763:	85 c0                	test   %eax,%eax
  802765:	7e 03                	jle    80276a <writebuf+0x2e>
			b->result += result;
  802767:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80276a:	39 43 04             	cmp    %eax,0x4(%ebx)
  80276d:	74 0d                	je     80277c <writebuf+0x40>
			b->error = (result < 0 ? result : 0);
  80276f:	85 c0                	test   %eax,%eax
  802771:	ba 00 00 00 00       	mov    $0x0,%edx
  802776:	0f 4f c2             	cmovg  %edx,%eax
  802779:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  80277c:	83 c4 14             	add    $0x14,%esp
  80277f:	5b                   	pop    %ebx
  802780:	5d                   	pop    %ebp
  802781:	c3                   	ret    

00802782 <putch>:

static void
putch(int ch, void *thunk)
{
  802782:	55                   	push   %ebp
  802783:	89 e5                	mov    %esp,%ebp
  802785:	53                   	push   %ebx
  802786:	83 ec 04             	sub    $0x4,%esp
  802789:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  80278c:	8b 53 04             	mov    0x4(%ebx),%edx
  80278f:	8d 42 01             	lea    0x1(%edx),%eax
  802792:	89 43 04             	mov    %eax,0x4(%ebx)
  802795:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802798:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  80279c:	3d 00 01 00 00       	cmp    $0x100,%eax
  8027a1:	75 0e                	jne    8027b1 <putch+0x2f>
		writebuf(b);
  8027a3:	89 d8                	mov    %ebx,%eax
  8027a5:	e8 92 ff ff ff       	call   80273c <writebuf>
		b->idx = 0;
  8027aa:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8027b1:	83 c4 04             	add    $0x4,%esp
  8027b4:	5b                   	pop    %ebx
  8027b5:	5d                   	pop    %ebp
  8027b6:	c3                   	ret    

008027b7 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8027c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c3:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8027c9:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8027d0:	00 00 00 
	b.result = 0;
  8027d3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8027da:	00 00 00 
	b.error = 1;
  8027dd:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8027e4:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8027e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027f5:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8027fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ff:	c7 04 24 82 27 80 00 	movl   $0x802782,(%esp)
  802806:	e8 49 e5 ff ff       	call   800d54 <vprintfmt>
	if (b.idx > 0)
  80280b:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802812:	7e 0b                	jle    80281f <vfprintf+0x68>
		writebuf(&b);
  802814:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80281a:	e8 1d ff ff ff       	call   80273c <writebuf>

	return (b.result ? b.result : b.error);
  80281f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802825:	85 c0                	test   %eax,%eax
  802827:	0f 44 85 f4 fe ff ff 	cmove  -0x10c(%ebp),%eax
}
  80282e:	c9                   	leave  
  80282f:	c3                   	ret    

00802830 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
  802833:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802836:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  802839:	89 44 24 08          	mov    %eax,0x8(%esp)
  80283d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802840:	89 44 24 04          	mov    %eax,0x4(%esp)
  802844:	8b 45 08             	mov    0x8(%ebp),%eax
  802847:	89 04 24             	mov    %eax,(%esp)
  80284a:	e8 68 ff ff ff       	call   8027b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <printf>:

int
printf(const char *fmt, ...)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802857:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  80285a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80285e:	8b 45 08             	mov    0x8(%ebp),%eax
  802861:	89 44 24 04          	mov    %eax,0x4(%esp)
  802865:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80286c:	e8 46 ff ff ff       	call   8027b7 <vfprintf>
	va_end(ap);

	return cnt;
}
  802871:	c9                   	leave  
  802872:	c3                   	ret    
  802873:	66 90                	xchg   %ax,%ax
  802875:	66 90                	xchg   %ax,%ax
  802877:	66 90                	xchg   %ax,%ax
  802879:	66 90                	xchg   %ax,%ax
  80287b:	66 90                	xchg   %ax,%ax
  80287d:	66 90                	xchg   %ax,%ax
  80287f:	90                   	nop

00802880 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	57                   	push   %edi
  802884:	56                   	push   %esi
  802885:	53                   	push   %ebx
  802886:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
  80288c:	c7 04 24 04 3f 80 00 	movl   $0x803f04,(%esp)
  802893:	e8 28 e3 ff ff       	call   800bc0 <cprintf>
	if ((r = open(prog, O_RDONLY)) < 0)
  802898:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80289f:	00 
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	89 04 24             	mov    %eax,(%esp)
  8028a6:	e8 0d fe ff ff       	call   8026b8 <open>
  8028ab:	89 c7                	mov    %eax,%edi
  8028ad:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	0f 88 09 05 00 00    	js     802dc4 <spawn+0x544>
		return r;
	fd = r;

	cprintf("read elf header.\n");
  8028bb:	c7 04 24 0b 3f 80 00 	movl   $0x803f0b,(%esp)
  8028c2:	e8 f9 e2 ff ff       	call   800bc0 <cprintf>
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8028c7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8028ce:	00 
  8028cf:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8028d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d9:	89 3c 24             	mov    %edi,(%esp)
  8028dc:	e8 c7 f9 ff ff       	call   8022a8 <readn>
  8028e1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8028e6:	75 0c                	jne    8028f4 <spawn+0x74>
	    || elf->e_magic != ELF_MAGIC) {
  8028e8:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  8028ef:	45 4c 46 
  8028f2:	74 36                	je     80292a <spawn+0xaa>
		close(fd);
  8028f4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  8028fa:	89 04 24             	mov    %eax,(%esp)
  8028fd:	e8 b1 f7 ff ff       	call   8020b3 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802902:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802909:	46 
  80290a:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	c7 04 24 1d 3f 80 00 	movl   $0x803f1d,(%esp)
  80291b:	e8 a0 e2 ff ff       	call   800bc0 <cprintf>
		return -E_NOT_EXEC;
  802920:	b8 f2 ff ff ff       	mov    $0xfffffff2,%eax
  802925:	e9 f9 04 00 00       	jmp    802e23 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
  80292a:	c7 04 24 37 3f 80 00 	movl   $0x803f37,(%esp)
  802931:	e8 8a e2 ff ff       	call   800bc0 <cprintf>
  802936:	b8 07 00 00 00       	mov    $0x7,%eax
  80293b:	cd 30                	int    $0x30
  80293d:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  802943:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802949:	85 c0                	test   %eax,%eax
  80294b:	0f 88 7b 04 00 00    	js     802dcc <spawn+0x54c>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802951:	89 c6                	mov    %eax,%esi
  802953:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802959:	6b f6 7c             	imul   $0x7c,%esi,%esi
  80295c:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802962:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802968:	b9 11 00 00 00       	mov    $0x11,%ecx
  80296d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  80296f:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802975:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)

	cprintf("init_stack\n");
  80297b:	c7 04 24 44 3f 80 00 	movl   $0x803f44,(%esp)
  802982:	e8 39 e2 ff ff       	call   800bc0 <cprintf>
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	74 38                	je     8029c8 <spawn+0x148>
  802990:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  802995:	be 00 00 00 00       	mov    $0x0,%esi
  80299a:	8b 7d 0c             	mov    0xc(%ebp),%edi
	for (argc = 0; argv[argc] != 0; argc++)
		string_size += strlen(argv[argc]) + 1;
  80299d:	89 04 24             	mov    %eax,(%esp)
  8029a0:	e8 0b e9 ff ff       	call   8012b0 <strlen>
  8029a5:	8d 74 30 01          	lea    0x1(%eax,%esi,1),%esi
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8029a9:	83 c3 01             	add    $0x1,%ebx
  8029ac:	8d 0c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%ecx
  8029b3:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	75 e3                	jne    80299d <spawn+0x11d>
  8029ba:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  8029c0:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  8029c6:	eb 1e                	jmp    8029e6 <spawn+0x166>
  8029c8:	c7 85 80 fd ff ff 00 	movl   $0x0,-0x280(%ebp)
  8029cf:	00 00 00 
  8029d2:	c7 85 88 fd ff ff 00 	movl   $0x0,-0x278(%ebp)
  8029d9:	00 00 00 
  8029dc:	bb 00 00 00 00       	mov    $0x0,%ebx
	char *string_store;
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
  8029e1:	be 00 00 00 00       	mov    $0x0,%esi
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  8029e6:	bf 00 10 40 00       	mov    $0x401000,%edi
  8029eb:	29 f7                	sub    %esi,%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  8029ed:	89 fa                	mov    %edi,%edx
  8029ef:	83 e2 fc             	and    $0xfffffffc,%edx
  8029f2:	8d 04 9d 04 00 00 00 	lea    0x4(,%ebx,4),%eax
  8029f9:	29 c2                	sub    %eax,%edx
  8029fb:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802a01:	8d 42 f8             	lea    -0x8(%edx),%eax
  802a04:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802a09:	0f 86 cd 03 00 00    	jbe    802ddc <spawn+0x55c>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802a0f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802a16:	00 
  802a17:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802a1e:	00 
  802a1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a26:	e8 8e ed ff ff       	call   8017b9 <sys_page_alloc>
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 88 f0 03 00 00    	js     802e23 <spawn+0x5a3>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a33:	85 db                	test   %ebx,%ebx
  802a35:	7e 46                	jle    802a7d <spawn+0x1fd>
  802a37:	be 00 00 00 00       	mov    $0x0,%esi
  802a3c:	89 9d 8c fd ff ff    	mov    %ebx,-0x274(%ebp)
  802a42:	8b 5d 0c             	mov    0xc(%ebp),%ebx
		argv_store[i] = UTEMP2USTACK(string_store);
  802a45:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802a4b:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802a51:	89 04 b1             	mov    %eax,(%ecx,%esi,4)
		strcpy(string_store, argv[i]);
  802a54:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a5b:	89 3c 24             	mov    %edi,(%esp)
  802a5e:	e8 a8 e8 ff ff       	call   80130b <strcpy>
		string_store += strlen(argv[i]) + 1;
  802a63:	8b 04 b3             	mov    (%ebx,%esi,4),%eax
  802a66:	89 04 24             	mov    %eax,(%esp)
  802a69:	e8 42 e8 ff ff       	call   8012b0 <strlen>
  802a6e:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802a72:	83 c6 01             	add    $0x1,%esi
  802a75:	3b b5 8c fd ff ff    	cmp    -0x274(%ebp),%esi
  802a7b:	75 c8                	jne    802a45 <spawn+0x1c5>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802a7d:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802a83:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  802a89:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802a90:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802a96:	74 24                	je     802abc <spawn+0x23c>
  802a98:	c7 44 24 0c b8 3f 80 	movl   $0x803fb8,0xc(%esp)
  802a9f:	00 
  802aa0:	c7 44 24 08 f2 38 80 	movl   $0x8038f2,0x8(%esp)
  802aa7:	00 
  802aa8:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  802aaf:	00 
  802ab0:	c7 04 24 50 3f 80 00 	movl   $0x803f50,(%esp)
  802ab7:	e8 0b e0 ff ff       	call   800ac7 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802abc:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802ac2:	89 c8                	mov    %ecx,%eax
  802ac4:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802ac9:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  802acc:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802ad2:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802ad5:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  802adb:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802ae1:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802ae8:	00 
  802ae9:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802af0:	ee 
  802af1:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  802afb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b02:	00 
  802b03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b0a:	e8 fe ec ff ff       	call   80180d <sys_page_map>
  802b0f:	89 c3                	mov    %eax,%ebx
  802b11:	85 c0                	test   %eax,%eax
  802b13:	0f 88 f4 02 00 00    	js     802e0d <spawn+0x58d>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802b19:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b20:	00 
  802b21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b28:	e8 33 ed ff ff       	call   801860 <sys_page_unmap>
  802b2d:	89 c3                	mov    %eax,%ebx
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	0f 88 d6 02 00 00    	js     802e0d <spawn+0x58d>

	cprintf("init_stack\n");
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	cprintf("map_segment\n");
  802b37:	c7 04 24 5c 3f 80 00 	movl   $0x803f5c,(%esp)
  802b3e:	e8 7d e0 ff ff       	call   800bc0 <cprintf>
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802b43:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  802b49:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802b50:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802b56:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802b5d:	00 
  802b5e:	0f 84 dc 01 00 00    	je     802d40 <spawn+0x4c0>
  802b64:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802b6b:	00 00 00 
		if (ph->p_type != ELF_PROG_LOAD)
  802b6e:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802b74:	83 38 01             	cmpl   $0x1,(%eax)
  802b77:	0f 85 a2 01 00 00    	jne    802d1f <spawn+0x49f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802b7d:	89 c1                	mov    %eax,%ecx
  802b7f:	8b 40 18             	mov    0x18(%eax),%eax
  802b82:	83 e0 02             	and    $0x2,%eax
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
			continue;
		perm = PTE_P | PTE_U;
  802b85:	83 f8 01             	cmp    $0x1,%eax
  802b88:	19 c0                	sbb    %eax,%eax
  802b8a:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
  802b90:	83 a5 94 fd ff ff fe 	andl   $0xfffffffe,-0x26c(%ebp)
  802b97:	83 85 94 fd ff ff 07 	addl   $0x7,-0x26c(%ebp)
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802b9e:	89 c8                	mov    %ecx,%eax
  802ba0:	8b 51 04             	mov    0x4(%ecx),%edx
  802ba3:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  802ba9:	8b 79 10             	mov    0x10(%ecx),%edi
  802bac:	8b 49 14             	mov    0x14(%ecx),%ecx
  802baf:	89 8d 8c fd ff ff    	mov    %ecx,-0x274(%ebp)
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802bbe:	25 ff 0f 00 00       	and    $0xfff,%eax
  802bc3:	74 14                	je     802bd9 <spawn+0x359>
		va -= i;
  802bc5:	29 85 88 fd ff ff    	sub    %eax,-0x278(%ebp)
		memsz += i;
  802bcb:	01 85 8c fd ff ff    	add    %eax,-0x274(%ebp)
		filesz += i;
  802bd1:	01 c7                	add    %eax,%edi
		fileoffset -= i;
  802bd3:	29 85 80 fd ff ff    	sub    %eax,-0x280(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802bd9:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802be0:	0f 84 39 01 00 00    	je     802d1f <spawn+0x49f>
  802be6:	bb 00 00 00 00       	mov    $0x0,%ebx
  802beb:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802bf0:	39 f7                	cmp    %esi,%edi
  802bf2:	77 31                	ja     802c25 <spawn+0x3a5>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802bf4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  802bfe:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802c04:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c08:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802c0e:	89 04 24             	mov    %eax,(%esp)
  802c11:	e8 a3 eb ff ff       	call   8017b9 <sys_page_alloc>
  802c16:	85 c0                	test   %eax,%eax
  802c18:	0f 89 ed 00 00 00    	jns    802d0b <spawn+0x48b>
  802c1e:	89 c3                	mov    %eax,%ebx
  802c20:	e9 c8 01 00 00       	jmp    802ded <spawn+0x56d>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802c25:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c2c:	00 
  802c2d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c34:	00 
  802c35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c3c:	e8 78 eb ff ff       	call   8017b9 <sys_page_alloc>
  802c41:	85 c0                	test   %eax,%eax
  802c43:	0f 88 9a 01 00 00    	js     802de3 <spawn+0x563>
  802c49:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c4f:	01 d8                	add    %ebx,%eax
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c55:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c5b:	89 04 24             	mov    %eax,(%esp)
  802c5e:	e8 2d f7 ff ff       	call   802390 <seek>
  802c63:	85 c0                	test   %eax,%eax
  802c65:	0f 88 7c 01 00 00    	js     802de7 <spawn+0x567>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802c6b:	89 fa                	mov    %edi,%edx
  802c6d:	29 f2                	sub    %esi,%edx
  802c6f:	89 d0                	mov    %edx,%eax
  802c71:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
  802c77:	b9 00 10 00 00       	mov    $0x1000,%ecx
  802c7c:	0f 47 c1             	cmova  %ecx,%eax
  802c7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c83:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c8a:	00 
  802c8b:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802c91:	89 04 24             	mov    %eax,(%esp)
  802c94:	e8 0f f6 ff ff       	call   8022a8 <readn>
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	0f 88 4a 01 00 00    	js     802deb <spawn+0x56b>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802ca1:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802ca7:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cab:	03 b5 88 fd ff ff    	add    -0x278(%ebp),%esi
  802cb1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802cb5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cbf:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cc6:	00 
  802cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cce:	e8 3a eb ff ff       	call   80180d <sys_page_map>
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	79 20                	jns    802cf7 <spawn+0x477>
				panic("spawn: sys_page_map data: %e", r);
  802cd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cdb:	c7 44 24 08 69 3f 80 	movl   $0x803f69,0x8(%esp)
  802ce2:	00 
  802ce3:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  802cea:	00 
  802ceb:	c7 04 24 50 3f 80 00 	movl   $0x803f50,(%esp)
  802cf2:	e8 d0 dd ff ff       	call   800ac7 <_panic>
			sys_page_unmap(0, UTEMP);
  802cf7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802cfe:	00 
  802cff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d06:	e8 55 eb ff ff       	call   801860 <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802d0b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802d11:	89 de                	mov    %ebx,%esi
  802d13:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802d19:	0f 82 d1 fe ff ff    	jb     802bf0 <spawn+0x370>
		return r;

	cprintf("map_segment\n");
	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802d1f:	83 85 78 fd ff ff 01 	addl   $0x1,-0x288(%ebp)
  802d26:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  802d2d:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802d34:	3b 85 78 fd ff ff    	cmp    -0x288(%ebp),%eax
  802d3a:	0f 8f 2e fe ff ff    	jg     802b6e <spawn+0x2ee>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802d40:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802d46:	89 04 24             	mov    %eax,(%esp)
  802d49:	e8 65 f3 ff ff       	call   8020b3 <close>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802d4e:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d58:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d5e:	89 04 24             	mov    %eax,(%esp)
  802d61:	e8 a0 eb ff ff       	call   801906 <sys_env_set_trapframe>
  802d66:	85 c0                	test   %eax,%eax
  802d68:	79 20                	jns    802d8a <spawn+0x50a>
		panic("sys_env_set_trapframe: %e", r);
  802d6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d6e:	c7 44 24 08 86 3f 80 	movl   $0x803f86,0x8(%esp)
  802d75:	00 
  802d76:	c7 44 24 04 89 00 00 	movl   $0x89,0x4(%esp)
  802d7d:	00 
  802d7e:	c7 04 24 50 3f 80 00 	movl   $0x803f50,(%esp)
  802d85:	e8 3d dd ff ff       	call   800ac7 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802d8a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  802d91:	00 
  802d92:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802d98:	89 04 24             	mov    %eax,(%esp)
  802d9b:	e8 13 eb ff ff       	call   8018b3 <sys_env_set_status>
  802da0:	85 c0                	test   %eax,%eax
  802da2:	79 30                	jns    802dd4 <spawn+0x554>
		panic("sys_env_set_status: %e", r);
  802da4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802da8:	c7 44 24 08 a0 3f 80 	movl   $0x803fa0,0x8(%esp)
  802daf:	00 
  802db0:	c7 44 24 04 8c 00 00 	movl   $0x8c,0x4(%esp)
  802db7:	00 
  802db8:	c7 04 24 50 3f 80 00 	movl   $0x803f50,(%esp)
  802dbf:	e8 03 dd ff ff       	call   800ac7 <_panic>
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().
	cprintf("open.\n");
	if ((r = open(prog, O_RDONLY)) < 0)
		return r;
  802dc4:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802dca:	eb 57                	jmp    802e23 <spawn+0x5a3>
	}

	cprintf("sys_exofork\n");
	// Create new child environment
	if ((r = sys_exofork()) < 0)
		return r;
  802dcc:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802dd2:	eb 4f                	jmp    802e23 <spawn+0x5a3>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;
  802dd4:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802dda:	eb 47                	jmp    802e23 <spawn+0x5a3>
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
		return -E_NO_MEM;
  802ddc:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  802de1:	eb 40                	jmp    802e23 <spawn+0x5a3>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802de3:	89 c3                	mov    %eax,%ebx
  802de5:	eb 06                	jmp    802ded <spawn+0x56d>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802de7:	89 c3                	mov    %eax,%ebx
  802de9:	eb 02                	jmp    802ded <spawn+0x56d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802deb:	89 c3                	mov    %eax,%ebx
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
		panic("sys_env_set_status: %e", r);
	return child;

error:
	sys_env_destroy(child);
  802ded:	8b 85 74 fd ff ff    	mov    -0x28c(%ebp),%eax
  802df3:	89 04 24             	mov    %eax,(%esp)
  802df6:	e8 2e e9 ff ff       	call   801729 <sys_env_destroy>
	close(fd);
  802dfb:	8b 85 90 fd ff ff    	mov    -0x270(%ebp),%eax
  802e01:	89 04 24             	mov    %eax,(%esp)
  802e04:	e8 aa f2 ff ff       	call   8020b3 <close>
	return r;
  802e09:	89 d8                	mov    %ebx,%eax
  802e0b:	eb 16                	jmp    802e23 <spawn+0x5a3>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802e0d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e14:	00 
  802e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e1c:	e8 3f ea ff ff       	call   801860 <sys_page_unmap>
  802e21:	89 d8                	mov    %ebx,%eax

error:
	sys_env_destroy(child);
	close(fd);
	return r;
}
  802e23:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802e29:	5b                   	pop    %ebx
  802e2a:	5e                   	pop    %esi
  802e2b:	5f                   	pop    %edi
  802e2c:	5d                   	pop    %ebp
  802e2d:	c3                   	ret    

00802e2e <spawnl>:
// Spawn, taking command-line arguments array directly on the stack.
// NOTE: Must have a sentinal of NULL at the end of the args
// (none of the args may be NULL).
int
spawnl(const char *prog, const char *arg0, ...)
{
  802e2e:	55                   	push   %ebp
  802e2f:	89 e5                	mov    %esp,%ebp
  802e31:	57                   	push   %edi
  802e32:	56                   	push   %esi
  802e33:	53                   	push   %ebx
  802e34:	83 ec 2c             	sub    $0x2c,%esp
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802e37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802e3b:	74 61                	je     802e9e <spawnl+0x70>
  802e3d:	8d 45 14             	lea    0x14(%ebp),%eax
{
	// We calculate argc by advancing the args until we hit NULL.
	// The contract of the function guarantees that the last
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
  802e40:	ba 00 00 00 00       	mov    $0x0,%edx
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
		argc++;
  802e45:	8d 4a 01             	lea    0x1(%edx),%ecx
	// argument will always be NULL, and that none of the other
	// arguments will be NULL.
	int argc=0;
	va_list vl;
	va_start(vl, arg0);
	while(va_arg(vl, void *) != NULL)
  802e48:	83 c0 04             	add    $0x4,%eax
  802e4b:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
  802e4f:	74 04                	je     802e55 <spawnl+0x27>
		argc++;
  802e51:	89 ca                	mov    %ecx,%edx
  802e53:	eb f0                	jmp    802e45 <spawnl+0x17>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802e55:	8d 04 95 1e 00 00 00 	lea    0x1e(,%edx,4),%eax
  802e5c:	83 e0 f0             	and    $0xfffffff0,%eax
  802e5f:	29 c4                	sub    %eax,%esp
  802e61:	8d 74 24 0b          	lea    0xb(%esp),%esi
  802e65:	c1 ee 02             	shr    $0x2,%esi
  802e68:	8d 04 b5 00 00 00 00 	lea    0x0(,%esi,4),%eax
  802e6f:	89 c3                	mov    %eax,%ebx
	argv[0] = arg0;
  802e71:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e74:	89 3c b5 00 00 00 00 	mov    %edi,0x0(,%esi,4)
	argv[argc+1] = NULL;
  802e7b:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
  802e82:	00 

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802e83:	89 ce                	mov    %ecx,%esi
  802e85:	85 c9                	test   %ecx,%ecx
  802e87:	74 25                	je     802eae <spawnl+0x80>
  802e89:	b8 00 00 00 00       	mov    $0x0,%eax
		argv[i+1] = va_arg(vl, const char *);
  802e8e:	83 c0 01             	add    $0x1,%eax
  802e91:	8b 54 85 0c          	mov    0xc(%ebp,%eax,4),%edx
  802e95:	89 14 83             	mov    %edx,(%ebx,%eax,4)
	argv[0] = arg0;
	argv[argc+1] = NULL;

	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
  802e98:	39 f0                	cmp    %esi,%eax
  802e9a:	75 f2                	jne    802e8e <spawnl+0x60>
  802e9c:	eb 10                	jmp    802eae <spawnl+0x80>
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
	argv[0] = arg0;
  802e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	argv[argc+1] = NULL;
  802ea4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		argc++;
	va_end(vl);

	// Now that we have the size of the args, do a second pass
	// and store the values in a VLA, which has the format of argv
	const char *argv[argc+2];
  802eab:	8d 5d e0             	lea    -0x20(%ebp),%ebx
	va_start(vl, arg0);
	unsigned i;
	for(i=0;i<argc;i++)
		argv[i+1] = va_arg(vl, const char *);
	va_end(vl);
	return spawn(prog, argv);
  802eae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	89 04 24             	mov    %eax,(%esp)
  802eb8:	e8 c3 f9 ff ff       	call   802880 <spawn>
}
  802ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802ec0:	5b                   	pop    %ebx
  802ec1:	5e                   	pop    %esi
  802ec2:	5f                   	pop    %edi
  802ec3:	5d                   	pop    %ebp
  802ec4:	c3                   	ret    
  802ec5:	66 90                	xchg   %ax,%ax
  802ec7:	66 90                	xchg   %ax,%ax
  802ec9:	66 90                	xchg   %ax,%ax
  802ecb:	66 90                	xchg   %ax,%ax
  802ecd:	66 90                	xchg   %ax,%ax
  802ecf:	90                   	nop

00802ed0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802ed0:	55                   	push   %ebp
  802ed1:	89 e5                	mov    %esp,%ebp
  802ed3:	56                   	push   %esi
  802ed4:	53                   	push   %ebx
  802ed5:	83 ec 10             	sub    $0x10,%esp
  802ed8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	89 04 24             	mov    %eax,(%esp)
  802ee1:	e8 fa ef ff ff       	call   801ee0 <fd2data>
  802ee6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802ee8:	c7 44 24 04 de 3f 80 	movl   $0x803fde,0x4(%esp)
  802eef:	00 
  802ef0:	89 1c 24             	mov    %ebx,(%esp)
  802ef3:	e8 13 e4 ff ff       	call   80130b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802ef8:	8b 46 04             	mov    0x4(%esi),%eax
  802efb:	2b 06                	sub    (%esi),%eax
  802efd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802f03:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802f0a:	00 00 00 
	stat->st_dev = &devpipe;
  802f0d:	c7 83 88 00 00 00 3c 	movl   $0x80503c,0x88(%ebx)
  802f14:	50 80 00 
	return 0;
}
  802f17:	b8 00 00 00 00       	mov    $0x0,%eax
  802f1c:	83 c4 10             	add    $0x10,%esp
  802f1f:	5b                   	pop    %ebx
  802f20:	5e                   	pop    %esi
  802f21:	5d                   	pop    %ebp
  802f22:	c3                   	ret    

00802f23 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
  802f26:	53                   	push   %ebx
  802f27:	83 ec 14             	sub    $0x14,%esp
  802f2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802f2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802f31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f38:	e8 23 e9 ff ff       	call   801860 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802f3d:	89 1c 24             	mov    %ebx,(%esp)
  802f40:	e8 9b ef ff ff       	call   801ee0 <fd2data>
  802f45:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f50:	e8 0b e9 ff ff       	call   801860 <sys_page_unmap>
}
  802f55:	83 c4 14             	add    $0x14,%esp
  802f58:	5b                   	pop    %ebx
  802f59:	5d                   	pop    %ebp
  802f5a:	c3                   	ret    

00802f5b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802f5b:	55                   	push   %ebp
  802f5c:	89 e5                	mov    %esp,%ebp
  802f5e:	57                   	push   %edi
  802f5f:	56                   	push   %esi
  802f60:	53                   	push   %ebx
  802f61:	83 ec 2c             	sub    $0x2c,%esp
  802f64:	89 c6                	mov    %eax,%esi
  802f66:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802f69:	a1 24 64 80 00       	mov    0x806424,%eax
  802f6e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802f71:	89 34 24             	mov    %esi,(%esp)
  802f74:	e8 42 05 00 00       	call   8034bb <pageref>
  802f79:	89 c7                	mov    %eax,%edi
  802f7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7e:	89 04 24             	mov    %eax,(%esp)
  802f81:	e8 35 05 00 00       	call   8034bb <pageref>
  802f86:	39 c7                	cmp    %eax,%edi
  802f88:	0f 94 c2             	sete   %dl
  802f8b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802f8e:	8b 0d 24 64 80 00    	mov    0x806424,%ecx
  802f94:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802f97:	39 fb                	cmp    %edi,%ebx
  802f99:	74 21                	je     802fbc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802f9b:	84 d2                	test   %dl,%dl
  802f9d:	74 ca                	je     802f69 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802f9f:	8b 51 58             	mov    0x58(%ecx),%edx
  802fa2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fa6:	89 54 24 08          	mov    %edx,0x8(%esp)
  802faa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802fae:	c7 04 24 e5 3f 80 00 	movl   $0x803fe5,(%esp)
  802fb5:	e8 06 dc ff ff       	call   800bc0 <cprintf>
  802fba:	eb ad                	jmp    802f69 <_pipeisclosed+0xe>
	}
}
  802fbc:	83 c4 2c             	add    $0x2c,%esp
  802fbf:	5b                   	pop    %ebx
  802fc0:	5e                   	pop    %esi
  802fc1:	5f                   	pop    %edi
  802fc2:	5d                   	pop    %ebp
  802fc3:	c3                   	ret    

00802fc4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802fc4:	55                   	push   %ebp
  802fc5:	89 e5                	mov    %esp,%ebp
  802fc7:	57                   	push   %edi
  802fc8:	56                   	push   %esi
  802fc9:	53                   	push   %ebx
  802fca:	83 ec 1c             	sub    $0x1c,%esp
  802fcd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802fd0:	89 34 24             	mov    %esi,(%esp)
  802fd3:	e8 08 ef ff ff       	call   801ee0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fd8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fdc:	74 61                	je     80303f <devpipe_write+0x7b>
  802fde:	89 c3                	mov    %eax,%ebx
  802fe0:	bf 00 00 00 00       	mov    $0x0,%edi
  802fe5:	eb 4a                	jmp    803031 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802fe7:	89 da                	mov    %ebx,%edx
  802fe9:	89 f0                	mov    %esi,%eax
  802feb:	e8 6b ff ff ff       	call   802f5b <_pipeisclosed>
  802ff0:	85 c0                	test   %eax,%eax
  802ff2:	75 54                	jne    803048 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802ff4:	e8 a1 e7 ff ff       	call   80179a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ff9:	8b 43 04             	mov    0x4(%ebx),%eax
  802ffc:	8b 0b                	mov    (%ebx),%ecx
  802ffe:	8d 51 20             	lea    0x20(%ecx),%edx
  803001:	39 d0                	cmp    %edx,%eax
  803003:	73 e2                	jae    802fe7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803008:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80300c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80300f:	99                   	cltd   
  803010:	c1 ea 1b             	shr    $0x1b,%edx
  803013:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  803016:	83 e1 1f             	and    $0x1f,%ecx
  803019:	29 d1                	sub    %edx,%ecx
  80301b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80301f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  803023:	83 c0 01             	add    $0x1,%eax
  803026:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803029:	83 c7 01             	add    $0x1,%edi
  80302c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80302f:	74 13                	je     803044 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803031:	8b 43 04             	mov    0x4(%ebx),%eax
  803034:	8b 0b                	mov    (%ebx),%ecx
  803036:	8d 51 20             	lea    0x20(%ecx),%edx
  803039:	39 d0                	cmp    %edx,%eax
  80303b:	73 aa                	jae    802fe7 <devpipe_write+0x23>
  80303d:	eb c6                	jmp    803005 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80303f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  803044:	89 f8                	mov    %edi,%eax
  803046:	eb 05                	jmp    80304d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  803048:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80304d:	83 c4 1c             	add    $0x1c,%esp
  803050:	5b                   	pop    %ebx
  803051:	5e                   	pop    %esi
  803052:	5f                   	pop    %edi
  803053:	5d                   	pop    %ebp
  803054:	c3                   	ret    

00803055 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803055:	55                   	push   %ebp
  803056:	89 e5                	mov    %esp,%ebp
  803058:	57                   	push   %edi
  803059:	56                   	push   %esi
  80305a:	53                   	push   %ebx
  80305b:	83 ec 1c             	sub    $0x1c,%esp
  80305e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803061:	89 3c 24             	mov    %edi,(%esp)
  803064:	e8 77 ee ff ff       	call   801ee0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803069:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80306d:	74 54                	je     8030c3 <devpipe_read+0x6e>
  80306f:	89 c3                	mov    %eax,%ebx
  803071:	be 00 00 00 00       	mov    $0x0,%esi
  803076:	eb 3e                	jmp    8030b6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  803078:	89 f0                	mov    %esi,%eax
  80307a:	eb 55                	jmp    8030d1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80307c:	89 da                	mov    %ebx,%edx
  80307e:	89 f8                	mov    %edi,%eax
  803080:	e8 d6 fe ff ff       	call   802f5b <_pipeisclosed>
  803085:	85 c0                	test   %eax,%eax
  803087:	75 43                	jne    8030cc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803089:	e8 0c e7 ff ff       	call   80179a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80308e:	8b 03                	mov    (%ebx),%eax
  803090:	3b 43 04             	cmp    0x4(%ebx),%eax
  803093:	74 e7                	je     80307c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803095:	99                   	cltd   
  803096:	c1 ea 1b             	shr    $0x1b,%edx
  803099:	01 d0                	add    %edx,%eax
  80309b:	83 e0 1f             	and    $0x1f,%eax
  80309e:	29 d0                	sub    %edx,%eax
  8030a0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8030a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8030a8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8030ab:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030ae:	83 c6 01             	add    $0x1,%esi
  8030b1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8030b4:	74 12                	je     8030c8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8030b6:	8b 03                	mov    (%ebx),%eax
  8030b8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8030bb:	75 d8                	jne    803095 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8030bd:	85 f6                	test   %esi,%esi
  8030bf:	75 b7                	jne    803078 <devpipe_read+0x23>
  8030c1:	eb b9                	jmp    80307c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8030c3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8030c8:	89 f0                	mov    %esi,%eax
  8030ca:	eb 05                	jmp    8030d1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8030cc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8030d1:	83 c4 1c             	add    $0x1c,%esp
  8030d4:	5b                   	pop    %ebx
  8030d5:	5e                   	pop    %esi
  8030d6:	5f                   	pop    %edi
  8030d7:	5d                   	pop    %ebp
  8030d8:	c3                   	ret    

008030d9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8030d9:	55                   	push   %ebp
  8030da:	89 e5                	mov    %esp,%ebp
  8030dc:	56                   	push   %esi
  8030dd:	53                   	push   %ebx
  8030de:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8030e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030e4:	89 04 24             	mov    %eax,(%esp)
  8030e7:	e8 0b ee ff ff       	call   801ef7 <fd_alloc>
  8030ec:	89 c2                	mov    %eax,%edx
  8030ee:	85 d2                	test   %edx,%edx
  8030f0:	0f 88 4d 01 00 00    	js     803243 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030f6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030fd:	00 
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	89 44 24 04          	mov    %eax,0x4(%esp)
  803105:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80310c:	e8 a8 e6 ff ff       	call   8017b9 <sys_page_alloc>
  803111:	89 c2                	mov    %eax,%edx
  803113:	85 d2                	test   %edx,%edx
  803115:	0f 88 28 01 00 00    	js     803243 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80311b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80311e:	89 04 24             	mov    %eax,(%esp)
  803121:	e8 d1 ed ff ff       	call   801ef7 <fd_alloc>
  803126:	89 c3                	mov    %eax,%ebx
  803128:	85 c0                	test   %eax,%eax
  80312a:	0f 88 fe 00 00 00    	js     80322e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803130:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803137:	00 
  803138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80313f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803146:	e8 6e e6 ff ff       	call   8017b9 <sys_page_alloc>
  80314b:	89 c3                	mov    %eax,%ebx
  80314d:	85 c0                	test   %eax,%eax
  80314f:	0f 88 d9 00 00 00    	js     80322e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	89 04 24             	mov    %eax,(%esp)
  80315b:	e8 80 ed ff ff       	call   801ee0 <fd2data>
  803160:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803162:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803169:	00 
  80316a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80316e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803175:	e8 3f e6 ff ff       	call   8017b9 <sys_page_alloc>
  80317a:	89 c3                	mov    %eax,%ebx
  80317c:	85 c0                	test   %eax,%eax
  80317e:	0f 88 97 00 00 00    	js     80321b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	89 04 24             	mov    %eax,(%esp)
  80318a:	e8 51 ed ff ff       	call   801ee0 <fd2data>
  80318f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803196:	00 
  803197:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80319b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8031a2:	00 
  8031a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031ae:	e8 5a e6 ff ff       	call   80180d <sys_page_map>
  8031b3:	89 c3                	mov    %eax,%ebx
  8031b5:	85 c0                	test   %eax,%eax
  8031b7:	78 52                	js     80320b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8031b9:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8031ce:	8b 15 3c 50 80 00    	mov    0x80503c,%edx
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8031d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8031e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e6:	89 04 24             	mov    %eax,(%esp)
  8031e9:	e8 e2 ec ff ff       	call   801ed0 <fd2num>
  8031ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8031f1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8031f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f6:	89 04 24             	mov    %eax,(%esp)
  8031f9:	e8 d2 ec ff ff       	call   801ed0 <fd2num>
  8031fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803201:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803204:	b8 00 00 00 00       	mov    $0x0,%eax
  803209:	eb 38                	jmp    803243 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80320b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80320f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803216:	e8 45 e6 ff ff       	call   801860 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80321b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803222:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803229:	e8 32 e6 ff ff       	call   801860 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	89 44 24 04          	mov    %eax,0x4(%esp)
  803235:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80323c:	e8 1f e6 ff ff       	call   801860 <sys_page_unmap>
  803241:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  803243:	83 c4 30             	add    $0x30,%esp
  803246:	5b                   	pop    %ebx
  803247:	5e                   	pop    %esi
  803248:	5d                   	pop    %ebp
  803249:	c3                   	ret    

0080324a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80324a:	55                   	push   %ebp
  80324b:	89 e5                	mov    %esp,%ebp
  80324d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803250:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803253:	89 44 24 04          	mov    %eax,0x4(%esp)
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	89 04 24             	mov    %eax,(%esp)
  80325d:	e8 09 ed ff ff       	call   801f6b <fd_lookup>
  803262:	89 c2                	mov    %eax,%edx
  803264:	85 d2                	test   %edx,%edx
  803266:	78 15                	js     80327d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	89 04 24             	mov    %eax,(%esp)
  80326e:	e8 6d ec ff ff       	call   801ee0 <fd2data>
	return _pipeisclosed(fd, p);
  803273:	89 c2                	mov    %eax,%edx
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	e8 de fc ff ff       	call   802f5b <_pipeisclosed>
}
  80327d:	c9                   	leave  
  80327e:	c3                   	ret    

0080327f <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  80327f:	55                   	push   %ebp
  803280:	89 e5                	mov    %esp,%ebp
  803282:	56                   	push   %esi
  803283:	53                   	push   %ebx
  803284:	83 ec 10             	sub    $0x10,%esp
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
	const volatile struct Env *e;

	assert(envid != 0);
  80328a:	85 c0                	test   %eax,%eax
  80328c:	75 24                	jne    8032b2 <wait+0x33>
  80328e:	c7 44 24 0c fd 3f 80 	movl   $0x803ffd,0xc(%esp)
  803295:	00 
  803296:	c7 44 24 08 f2 38 80 	movl   $0x8038f2,0x8(%esp)
  80329d:	00 
  80329e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8032a5:	00 
  8032a6:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  8032ad:	e8 15 d8 ff ff       	call   800ac7 <_panic>
	e = &envs[ENVX(envid)];
  8032b2:	89 c3                	mov    %eax,%ebx
  8032b4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8032ba:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  8032bd:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8032c3:	8b 73 48             	mov    0x48(%ebx),%esi
  8032c6:	39 c6                	cmp    %eax,%esi
  8032c8:	75 1a                	jne    8032e4 <wait+0x65>
  8032ca:	8b 43 54             	mov    0x54(%ebx),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	74 13                	je     8032e4 <wait+0x65>
		sys_yield();
  8032d1:	e8 c4 e4 ff ff       	call   80179a <sys_yield>
{
	const volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8032d6:	8b 43 48             	mov    0x48(%ebx),%eax
  8032d9:	39 f0                	cmp    %esi,%eax
  8032db:	75 07                	jne    8032e4 <wait+0x65>
  8032dd:	8b 43 54             	mov    0x54(%ebx),%eax
  8032e0:	85 c0                	test   %eax,%eax
  8032e2:	75 ed                	jne    8032d1 <wait+0x52>
		sys_yield();
}
  8032e4:	83 c4 10             	add    $0x10,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5d                   	pop    %ebp
  8032ea:	c3                   	ret    

008032eb <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8032eb:	55                   	push   %ebp
  8032ec:	89 e5                	mov    %esp,%ebp
  8032ee:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  8032f1:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8032f8:	75 50                	jne    80334a <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8032fa:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803301:	00 
  803302:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803309:	ee 
  80330a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803311:	e8 a3 e4 ff ff       	call   8017b9 <sys_page_alloc>
  803316:	85 c0                	test   %eax,%eax
  803318:	79 1c                	jns    803336 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  80331a:	c7 44 24 08 14 40 80 	movl   $0x804014,0x8(%esp)
  803321:	00 
  803322:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  803329:	00 
  80332a:	c7 04 24 38 40 80 00 	movl   $0x804038,(%esp)
  803331:	e8 91 d7 ff ff       	call   800ac7 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  803336:	c7 44 24 04 54 33 80 	movl   $0x803354,0x4(%esp)
  80333d:	00 
  80333e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803345:	e8 0f e6 ff ff       	call   801959 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80334a:	8b 45 08             	mov    0x8(%ebp),%eax
  80334d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  803352:	c9                   	leave  
  803353:	c3                   	ret    

00803354 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803354:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803355:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80335a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80335c:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80335f:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  803361:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  803366:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  803369:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  80336e:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  803371:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  803373:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  803376:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  803378:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  80337a:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80337f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  803382:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  803387:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  80338a:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  80338c:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  803391:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  803394:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  803399:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  80339c:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  80339e:	83 c4 08             	add    $0x8,%esp
	popal
  8033a1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8033a2:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8033a3:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8033a4:	c3                   	ret    

008033a5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8033a5:	55                   	push   %ebp
  8033a6:	89 e5                	mov    %esp,%ebp
  8033a8:	56                   	push   %esi
  8033a9:	53                   	push   %ebx
  8033aa:	83 ec 10             	sub    $0x10,%esp
  8033ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8033b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  8033b6:	85 c0                	test   %eax,%eax
  8033b8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8033bd:	0f 44 c2             	cmove  %edx,%eax
  8033c0:	89 04 24             	mov    %eax,(%esp)
  8033c3:	e8 07 e6 ff ff       	call   8019cf <sys_ipc_recv>
	if (err_code < 0) {
  8033c8:	85 c0                	test   %eax,%eax
  8033ca:	79 16                	jns    8033e2 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8033cc:	85 f6                	test   %esi,%esi
  8033ce:	74 06                	je     8033d6 <ipc_recv+0x31>
  8033d0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8033d6:	85 db                	test   %ebx,%ebx
  8033d8:	74 2c                	je     803406 <ipc_recv+0x61>
  8033da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8033e0:	eb 24                	jmp    803406 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8033e2:	85 f6                	test   %esi,%esi
  8033e4:	74 0a                	je     8033f0 <ipc_recv+0x4b>
  8033e6:	a1 24 64 80 00       	mov    0x806424,%eax
  8033eb:	8b 40 74             	mov    0x74(%eax),%eax
  8033ee:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8033f0:	85 db                	test   %ebx,%ebx
  8033f2:	74 0a                	je     8033fe <ipc_recv+0x59>
  8033f4:	a1 24 64 80 00       	mov    0x806424,%eax
  8033f9:	8b 40 78             	mov    0x78(%eax),%eax
  8033fc:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8033fe:	a1 24 64 80 00       	mov    0x806424,%eax
  803403:	8b 40 70             	mov    0x70(%eax),%eax
}
  803406:	83 c4 10             	add    $0x10,%esp
  803409:	5b                   	pop    %ebx
  80340a:	5e                   	pop    %esi
  80340b:	5d                   	pop    %ebp
  80340c:	c3                   	ret    

0080340d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80340d:	55                   	push   %ebp
  80340e:	89 e5                	mov    %esp,%ebp
  803410:	57                   	push   %edi
  803411:	56                   	push   %esi
  803412:	53                   	push   %ebx
  803413:	83 ec 1c             	sub    $0x1c,%esp
  803416:	8b 7d 08             	mov    0x8(%ebp),%edi
  803419:	8b 75 0c             	mov    0xc(%ebp),%esi
  80341c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  80341f:	eb 25                	jmp    803446 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  803421:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803424:	74 20                	je     803446 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  803426:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80342a:	c7 44 24 08 46 40 80 	movl   $0x804046,0x8(%esp)
  803431:	00 
  803432:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  803439:	00 
  80343a:	c7 04 24 52 40 80 00 	movl   $0x804052,(%esp)
  803441:	e8 81 d6 ff ff       	call   800ac7 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  803446:	85 db                	test   %ebx,%ebx
  803448:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80344d:	0f 45 c3             	cmovne %ebx,%eax
  803450:	8b 55 14             	mov    0x14(%ebp),%edx
  803453:	89 54 24 0c          	mov    %edx,0xc(%esp)
  803457:	89 44 24 08          	mov    %eax,0x8(%esp)
  80345b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80345f:	89 3c 24             	mov    %edi,(%esp)
  803462:	e8 45 e5 ff ff       	call   8019ac <sys_ipc_try_send>
  803467:	85 c0                	test   %eax,%eax
  803469:	75 b6                	jne    803421 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  80346b:	83 c4 1c             	add    $0x1c,%esp
  80346e:	5b                   	pop    %ebx
  80346f:	5e                   	pop    %esi
  803470:	5f                   	pop    %edi
  803471:	5d                   	pop    %ebp
  803472:	c3                   	ret    

00803473 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803473:	55                   	push   %ebp
  803474:	89 e5                	mov    %esp,%ebp
  803476:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  803479:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80347e:	39 c8                	cmp    %ecx,%eax
  803480:	74 17                	je     803499 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803482:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  803487:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80348a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  803490:	8b 52 50             	mov    0x50(%edx),%edx
  803493:	39 ca                	cmp    %ecx,%edx
  803495:	75 14                	jne    8034ab <ipc_find_env+0x38>
  803497:	eb 05                	jmp    80349e <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  803499:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80349e:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8034a1:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8034a6:	8b 40 40             	mov    0x40(%eax),%eax
  8034a9:	eb 0e                	jmp    8034b9 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8034ab:	83 c0 01             	add    $0x1,%eax
  8034ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8034b3:	75 d2                	jne    803487 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8034b5:	66 b8 00 00          	mov    $0x0,%ax
}
  8034b9:	5d                   	pop    %ebp
  8034ba:	c3                   	ret    

008034bb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8034bb:	55                   	push   %ebp
  8034bc:	89 e5                	mov    %esp,%ebp
  8034be:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034c1:	89 d0                	mov    %edx,%eax
  8034c3:	c1 e8 16             	shr    $0x16,%eax
  8034c6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8034cd:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8034d2:	f6 c1 01             	test   $0x1,%cl
  8034d5:	74 1d                	je     8034f4 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8034d7:	c1 ea 0c             	shr    $0xc,%edx
  8034da:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8034e1:	f6 c2 01             	test   $0x1,%dl
  8034e4:	74 0e                	je     8034f4 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8034e6:	c1 ea 0c             	shr    $0xc,%edx
  8034e9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8034f0:	ef 
  8034f1:	0f b7 c0             	movzwl %ax,%eax
}
  8034f4:	5d                   	pop    %ebp
  8034f5:	c3                   	ret    
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	66 90                	xchg   %ax,%ax
  8034fa:	66 90                	xchg   %ax,%ax
  8034fc:	66 90                	xchg   %ax,%ax
  8034fe:	66 90                	xchg   %ax,%ax

00803500 <__udivdi3>:
  803500:	55                   	push   %ebp
  803501:	57                   	push   %edi
  803502:	56                   	push   %esi
  803503:	83 ec 0c             	sub    $0xc,%esp
  803506:	8b 44 24 28          	mov    0x28(%esp),%eax
  80350a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80350e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  803512:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  803516:	85 c0                	test   %eax,%eax
  803518:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80351c:	89 ea                	mov    %ebp,%edx
  80351e:	89 0c 24             	mov    %ecx,(%esp)
  803521:	75 2d                	jne    803550 <__udivdi3+0x50>
  803523:	39 e9                	cmp    %ebp,%ecx
  803525:	77 61                	ja     803588 <__udivdi3+0x88>
  803527:	85 c9                	test   %ecx,%ecx
  803529:	89 ce                	mov    %ecx,%esi
  80352b:	75 0b                	jne    803538 <__udivdi3+0x38>
  80352d:	b8 01 00 00 00       	mov    $0x1,%eax
  803532:	31 d2                	xor    %edx,%edx
  803534:	f7 f1                	div    %ecx
  803536:	89 c6                	mov    %eax,%esi
  803538:	31 d2                	xor    %edx,%edx
  80353a:	89 e8                	mov    %ebp,%eax
  80353c:	f7 f6                	div    %esi
  80353e:	89 c5                	mov    %eax,%ebp
  803540:	89 f8                	mov    %edi,%eax
  803542:	f7 f6                	div    %esi
  803544:	89 ea                	mov    %ebp,%edx
  803546:	83 c4 0c             	add    $0xc,%esp
  803549:	5e                   	pop    %esi
  80354a:	5f                   	pop    %edi
  80354b:	5d                   	pop    %ebp
  80354c:	c3                   	ret    
  80354d:	8d 76 00             	lea    0x0(%esi),%esi
  803550:	39 e8                	cmp    %ebp,%eax
  803552:	77 24                	ja     803578 <__udivdi3+0x78>
  803554:	0f bd e8             	bsr    %eax,%ebp
  803557:	83 f5 1f             	xor    $0x1f,%ebp
  80355a:	75 3c                	jne    803598 <__udivdi3+0x98>
  80355c:	8b 74 24 04          	mov    0x4(%esp),%esi
  803560:	39 34 24             	cmp    %esi,(%esp)
  803563:	0f 86 9f 00 00 00    	jbe    803608 <__udivdi3+0x108>
  803569:	39 d0                	cmp    %edx,%eax
  80356b:	0f 82 97 00 00 00    	jb     803608 <__udivdi3+0x108>
  803571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  803578:	31 d2                	xor    %edx,%edx
  80357a:	31 c0                	xor    %eax,%eax
  80357c:	83 c4 0c             	add    $0xc,%esp
  80357f:	5e                   	pop    %esi
  803580:	5f                   	pop    %edi
  803581:	5d                   	pop    %ebp
  803582:	c3                   	ret    
  803583:	90                   	nop
  803584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803588:	89 f8                	mov    %edi,%eax
  80358a:	f7 f1                	div    %ecx
  80358c:	31 d2                	xor    %edx,%edx
  80358e:	83 c4 0c             	add    $0xc,%esp
  803591:	5e                   	pop    %esi
  803592:	5f                   	pop    %edi
  803593:	5d                   	pop    %ebp
  803594:	c3                   	ret    
  803595:	8d 76 00             	lea    0x0(%esi),%esi
  803598:	89 e9                	mov    %ebp,%ecx
  80359a:	8b 3c 24             	mov    (%esp),%edi
  80359d:	d3 e0                	shl    %cl,%eax
  80359f:	89 c6                	mov    %eax,%esi
  8035a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8035a6:	29 e8                	sub    %ebp,%eax
  8035a8:	89 c1                	mov    %eax,%ecx
  8035aa:	d3 ef                	shr    %cl,%edi
  8035ac:	89 e9                	mov    %ebp,%ecx
  8035ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8035b2:	8b 3c 24             	mov    (%esp),%edi
  8035b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8035b9:	89 d6                	mov    %edx,%esi
  8035bb:	d3 e7                	shl    %cl,%edi
  8035bd:	89 c1                	mov    %eax,%ecx
  8035bf:	89 3c 24             	mov    %edi,(%esp)
  8035c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8035c6:	d3 ee                	shr    %cl,%esi
  8035c8:	89 e9                	mov    %ebp,%ecx
  8035ca:	d3 e2                	shl    %cl,%edx
  8035cc:	89 c1                	mov    %eax,%ecx
  8035ce:	d3 ef                	shr    %cl,%edi
  8035d0:	09 d7                	or     %edx,%edi
  8035d2:	89 f2                	mov    %esi,%edx
  8035d4:	89 f8                	mov    %edi,%eax
  8035d6:	f7 74 24 08          	divl   0x8(%esp)
  8035da:	89 d6                	mov    %edx,%esi
  8035dc:	89 c7                	mov    %eax,%edi
  8035de:	f7 24 24             	mull   (%esp)
  8035e1:	39 d6                	cmp    %edx,%esi
  8035e3:	89 14 24             	mov    %edx,(%esp)
  8035e6:	72 30                	jb     803618 <__udivdi3+0x118>
  8035e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035ec:	89 e9                	mov    %ebp,%ecx
  8035ee:	d3 e2                	shl    %cl,%edx
  8035f0:	39 c2                	cmp    %eax,%edx
  8035f2:	73 05                	jae    8035f9 <__udivdi3+0xf9>
  8035f4:	3b 34 24             	cmp    (%esp),%esi
  8035f7:	74 1f                	je     803618 <__udivdi3+0x118>
  8035f9:	89 f8                	mov    %edi,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	e9 7a ff ff ff       	jmp    80357c <__udivdi3+0x7c>
  803602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803608:	31 d2                	xor    %edx,%edx
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	e9 68 ff ff ff       	jmp    80357c <__udivdi3+0x7c>
  803614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803618:	8d 47 ff             	lea    -0x1(%edi),%eax
  80361b:	31 d2                	xor    %edx,%edx
  80361d:	83 c4 0c             	add    $0xc,%esp
  803620:	5e                   	pop    %esi
  803621:	5f                   	pop    %edi
  803622:	5d                   	pop    %ebp
  803623:	c3                   	ret    
  803624:	66 90                	xchg   %ax,%ax
  803626:	66 90                	xchg   %ax,%ax
  803628:	66 90                	xchg   %ax,%ax
  80362a:	66 90                	xchg   %ax,%ax
  80362c:	66 90                	xchg   %ax,%ax
  80362e:	66 90                	xchg   %ax,%ax

00803630 <__umoddi3>:
  803630:	55                   	push   %ebp
  803631:	57                   	push   %edi
  803632:	56                   	push   %esi
  803633:	83 ec 14             	sub    $0x14,%esp
  803636:	8b 44 24 28          	mov    0x28(%esp),%eax
  80363a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80363e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  803642:	89 c7                	mov    %eax,%edi
  803644:	89 44 24 04          	mov    %eax,0x4(%esp)
  803648:	8b 44 24 30          	mov    0x30(%esp),%eax
  80364c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  803650:	89 34 24             	mov    %esi,(%esp)
  803653:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803657:	85 c0                	test   %eax,%eax
  803659:	89 c2                	mov    %eax,%edx
  80365b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80365f:	75 17                	jne    803678 <__umoddi3+0x48>
  803661:	39 fe                	cmp    %edi,%esi
  803663:	76 4b                	jbe    8036b0 <__umoddi3+0x80>
  803665:	89 c8                	mov    %ecx,%eax
  803667:	89 fa                	mov    %edi,%edx
  803669:	f7 f6                	div    %esi
  80366b:	89 d0                	mov    %edx,%eax
  80366d:	31 d2                	xor    %edx,%edx
  80366f:	83 c4 14             	add    $0x14,%esp
  803672:	5e                   	pop    %esi
  803673:	5f                   	pop    %edi
  803674:	5d                   	pop    %ebp
  803675:	c3                   	ret    
  803676:	66 90                	xchg   %ax,%ax
  803678:	39 f8                	cmp    %edi,%eax
  80367a:	77 54                	ja     8036d0 <__umoddi3+0xa0>
  80367c:	0f bd e8             	bsr    %eax,%ebp
  80367f:	83 f5 1f             	xor    $0x1f,%ebp
  803682:	75 5c                	jne    8036e0 <__umoddi3+0xb0>
  803684:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803688:	39 3c 24             	cmp    %edi,(%esp)
  80368b:	0f 87 e7 00 00 00    	ja     803778 <__umoddi3+0x148>
  803691:	8b 7c 24 04          	mov    0x4(%esp),%edi
  803695:	29 f1                	sub    %esi,%ecx
  803697:	19 c7                	sbb    %eax,%edi
  803699:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80369d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8036a9:	83 c4 14             	add    $0x14,%esp
  8036ac:	5e                   	pop    %esi
  8036ad:	5f                   	pop    %edi
  8036ae:	5d                   	pop    %ebp
  8036af:	c3                   	ret    
  8036b0:	85 f6                	test   %esi,%esi
  8036b2:	89 f5                	mov    %esi,%ebp
  8036b4:	75 0b                	jne    8036c1 <__umoddi3+0x91>
  8036b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036bb:	31 d2                	xor    %edx,%edx
  8036bd:	f7 f6                	div    %esi
  8036bf:	89 c5                	mov    %eax,%ebp
  8036c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c5:	31 d2                	xor    %edx,%edx
  8036c7:	f7 f5                	div    %ebp
  8036c9:	89 c8                	mov    %ecx,%eax
  8036cb:	f7 f5                	div    %ebp
  8036cd:	eb 9c                	jmp    80366b <__umoddi3+0x3b>
  8036cf:	90                   	nop
  8036d0:	89 c8                	mov    %ecx,%eax
  8036d2:	89 fa                	mov    %edi,%edx
  8036d4:	83 c4 14             	add    $0x14,%esp
  8036d7:	5e                   	pop    %esi
  8036d8:	5f                   	pop    %edi
  8036d9:	5d                   	pop    %ebp
  8036da:	c3                   	ret    
  8036db:	90                   	nop
  8036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8036e0:	8b 04 24             	mov    (%esp),%eax
  8036e3:	be 20 00 00 00       	mov    $0x20,%esi
  8036e8:	89 e9                	mov    %ebp,%ecx
  8036ea:	29 ee                	sub    %ebp,%esi
  8036ec:	d3 e2                	shl    %cl,%edx
  8036ee:	89 f1                	mov    %esi,%ecx
  8036f0:	d3 e8                	shr    %cl,%eax
  8036f2:	89 e9                	mov    %ebp,%ecx
  8036f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f8:	8b 04 24             	mov    (%esp),%eax
  8036fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8036ff:	89 fa                	mov    %edi,%edx
  803701:	d3 e0                	shl    %cl,%eax
  803703:	89 f1                	mov    %esi,%ecx
  803705:	89 44 24 08          	mov    %eax,0x8(%esp)
  803709:	8b 44 24 10          	mov    0x10(%esp),%eax
  80370d:	d3 ea                	shr    %cl,%edx
  80370f:	89 e9                	mov    %ebp,%ecx
  803711:	d3 e7                	shl    %cl,%edi
  803713:	89 f1                	mov    %esi,%ecx
  803715:	d3 e8                	shr    %cl,%eax
  803717:	89 e9                	mov    %ebp,%ecx
  803719:	09 f8                	or     %edi,%eax
  80371b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80371f:	f7 74 24 04          	divl   0x4(%esp)
  803723:	d3 e7                	shl    %cl,%edi
  803725:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803729:	89 d7                	mov    %edx,%edi
  80372b:	f7 64 24 08          	mull   0x8(%esp)
  80372f:	39 d7                	cmp    %edx,%edi
  803731:	89 c1                	mov    %eax,%ecx
  803733:	89 14 24             	mov    %edx,(%esp)
  803736:	72 2c                	jb     803764 <__umoddi3+0x134>
  803738:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80373c:	72 22                	jb     803760 <__umoddi3+0x130>
  80373e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  803742:	29 c8                	sub    %ecx,%eax
  803744:	19 d7                	sbb    %edx,%edi
  803746:	89 e9                	mov    %ebp,%ecx
  803748:	89 fa                	mov    %edi,%edx
  80374a:	d3 e8                	shr    %cl,%eax
  80374c:	89 f1                	mov    %esi,%ecx
  80374e:	d3 e2                	shl    %cl,%edx
  803750:	89 e9                	mov    %ebp,%ecx
  803752:	d3 ef                	shr    %cl,%edi
  803754:	09 d0                	or     %edx,%eax
  803756:	89 fa                	mov    %edi,%edx
  803758:	83 c4 14             	add    $0x14,%esp
  80375b:	5e                   	pop    %esi
  80375c:	5f                   	pop    %edi
  80375d:	5d                   	pop    %ebp
  80375e:	c3                   	ret    
  80375f:	90                   	nop
  803760:	39 d7                	cmp    %edx,%edi
  803762:	75 da                	jne    80373e <__umoddi3+0x10e>
  803764:	8b 14 24             	mov    (%esp),%edx
  803767:	89 c1                	mov    %eax,%ecx
  803769:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80376d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  803771:	eb cb                	jmp    80373e <__umoddi3+0x10e>
  803773:	90                   	nop
  803774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803778:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80377c:	0f 82 0f ff ff ff    	jb     803691 <__umoddi3+0x61>
  803782:	e9 1a ff ff ff       	jmp    8036a1 <__umoddi3+0x71>
