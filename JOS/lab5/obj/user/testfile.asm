
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 52 07 00 00       	call   800783 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800040:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  800047:	e8 1f 0f 00 00       	call   800f6b <strcpy>
	fsipcbuf.open.req_omode = mode;
  80004c:	89 1d 00 64 80 00    	mov    %ebx,0x806400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  800052:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800059:	e8 f1 16 00 00       	call   80174f <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80005e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800065:	00 
  800066:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800075:	00 
  800076:	89 04 24             	mov    %eax,(%esp)
  800079:	e8 6b 16 00 00       	call   8016e9 <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  80007e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800085:	00 
  800086:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  80008d:	cc 
  80008e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800095:	e8 e7 15 00 00       	call   801681 <ipc_recv>
}
  80009a:	83 c4 14             	add    $0x14,%esp
  80009d:	5b                   	pop    %ebx
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <umain>:

void
umain(int argc, char **argv)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	57                   	push   %edi
  8000a4:	56                   	push   %esi
  8000a5:	53                   	push   %ebx
  8000a6:	81 ec cc 02 00 00    	sub    $0x2cc,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8000b1:	b8 20 28 80 00       	mov    $0x802820,%eax
  8000b6:	e8 78 ff ff ff       	call   800033 <xopen>
  8000bb:	85 c0                	test   %eax,%eax
  8000bd:	79 25                	jns    8000e4 <umain+0x44>
  8000bf:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000c2:	74 3c                	je     800100 <umain+0x60>
		panic("serve_open /not-found: %e", r);
  8000c4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c8:	c7 44 24 08 2b 28 80 	movl   $0x80282b,0x8(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  8000d7:	00 
  8000d8:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8000df:	e8 30 07 00 00       	call   800814 <_panic>
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  8000e4:	c7 44 24 08 e0 29 80 	movl   $0x8029e0,0x8(%esp)
  8000eb:	00 
  8000ec:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000f3:	00 
  8000f4:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8000fb:	e8 14 07 00 00       	call   800814 <_panic>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  800100:	ba 00 00 00 00       	mov    $0x0,%edx
  800105:	b8 55 28 80 00       	mov    $0x802855,%eax
  80010a:	e8 24 ff ff ff       	call   800033 <xopen>
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0x93>
		panic("serve_open /newmotd: %e", r);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 5e 28 80 	movl   $0x80285e,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80012e:	e8 e1 06 00 00       	call   800814 <_panic>
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  800133:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  80013a:	75 12                	jne    80014e <umain+0xae>
  80013c:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  800143:	75 09                	jne    80014e <umain+0xae>
  800145:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  80014c:	74 1c                	je     80016a <umain+0xca>
		panic("serve_open did not fill struct Fd correctly\n");
  80014e:	c7 44 24 08 04 2a 80 	movl   $0x802a04,0x8(%esp)
  800155:	00 
  800156:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  80015d:	00 
  80015e:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800165:	e8 aa 06 00 00       	call   800814 <_panic>
	cprintf("serve_open is good\n");
  80016a:	c7 04 24 76 28 80 00 	movl   $0x802876,(%esp)
  800171:	e8 97 07 00 00       	call   80090d <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800176:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800187:	ff 15 1c 40 80 00    	call   *0x80401c
  80018d:	85 c0                	test   %eax,%eax
  80018f:	79 20                	jns    8001b1 <umain+0x111>
		panic("file_stat: %e", r);
  800191:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800195:	c7 44 24 08 8a 28 80 	movl   $0x80288a,0x8(%esp)
  80019c:	00 
  80019d:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  8001a4:	00 
  8001a5:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8001ac:	e8 63 06 00 00       	call   800814 <_panic>
	if (strlen(msg) != st.st_size)
  8001b1:	a1 00 40 80 00       	mov    0x804000,%eax
  8001b6:	89 04 24             	mov    %eax,(%esp)
  8001b9:	e8 52 0d 00 00       	call   800f10 <strlen>
  8001be:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  8001c1:	74 34                	je     8001f7 <umain+0x157>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  8001c3:	a1 00 40 80 00       	mov    0x804000,%eax
  8001c8:	89 04 24             	mov    %eax,(%esp)
  8001cb:	e8 40 0d 00 00       	call   800f10 <strlen>
  8001d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001db:	c7 44 24 08 34 2a 80 	movl   $0x802a34,0x8(%esp)
  8001e2:	00 
  8001e3:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  8001ea:	00 
  8001eb:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8001f2:	e8 1d 06 00 00       	call   800814 <_panic>
	cprintf("file_stat is good\n");
  8001f7:	c7 04 24 98 28 80 00 	movl   $0x802898,(%esp)
  8001fe:	e8 0a 07 00 00       	call   80090d <cprintf>

	memset(buf, 0, sizeof buf);
  800203:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800212:	00 
  800213:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  800219:	89 1c 24             	mov    %ebx,(%esp)
  80021c:	e8 f8 0e 00 00       	call   801119 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800221:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800228:	00 
  800229:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022d:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800234:	ff 15 10 40 80 00    	call   *0x804010
  80023a:	85 c0                	test   %eax,%eax
  80023c:	79 20                	jns    80025e <umain+0x1be>
		panic("file_read: %e", r);
  80023e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800242:	c7 44 24 08 ab 28 80 	movl   $0x8028ab,0x8(%esp)
  800249:	00 
  80024a:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  800251:	00 
  800252:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800259:	e8 b6 05 00 00       	call   800814 <_panic>
	if (strcmp(buf, msg) != 0)
  80025e:	a1 00 40 80 00       	mov    0x804000,%eax
  800263:	89 44 24 04          	mov    %eax,0x4(%esp)
  800267:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 c0 0d 00 00       	call   801035 <strcmp>
  800275:	85 c0                	test   %eax,%eax
  800277:	74 1c                	je     800295 <umain+0x1f5>
		panic("file_read returned wrong data");
  800279:	c7 44 24 08 b9 28 80 	movl   $0x8028b9,0x8(%esp)
  800280:	00 
  800281:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800288:	00 
  800289:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800290:	e8 7f 05 00 00       	call   800814 <_panic>
	cprintf("file_read is good\n");
  800295:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  80029c:	e8 6c 06 00 00       	call   80090d <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8002a1:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8002a8:	ff 15 18 40 80 00    	call   *0x804018
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	79 20                	jns    8002d2 <umain+0x232>
		panic("file_close: %e", r);
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	c7 44 24 08 ea 28 80 	movl   $0x8028ea,0x8(%esp)
  8002bd:	00 
  8002be:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8002c5:	00 
  8002c6:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8002cd:	e8 42 05 00 00       	call   800814 <_panic>
	cprintf("file_close is good\n");
  8002d2:	c7 04 24 f9 28 80 00 	movl   $0x8028f9,(%esp)
  8002d9:	e8 2f 06 00 00       	call   80090d <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8002de:	a1 00 c0 cc cc       	mov    0xccccc000,%eax
  8002e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002e6:	a1 04 c0 cc cc       	mov    0xccccc004,%eax
  8002eb:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002ee:	a1 08 c0 cc cc       	mov    0xccccc008,%eax
  8002f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002f6:	a1 0c c0 cc cc       	mov    0xccccc00c,%eax
  8002fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	sys_page_unmap(0, FVA);
  8002fe:	c7 44 24 04 00 c0 cc 	movl   $0xccccc000,0x4(%esp)
  800305:	cc 
  800306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80030d:	e8 ae 11 00 00       	call   8014c0 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  800312:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  800319:	00 
  80031a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800320:	89 44 24 04          	mov    %eax,0x4(%esp)
  800324:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800327:	89 04 24             	mov    %eax,(%esp)
  80032a:	ff 15 10 40 80 00    	call   *0x804010
  800330:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800333:	74 20                	je     800355 <umain+0x2b5>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  800335:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800339:	c7 44 24 08 5c 2a 80 	movl   $0x802a5c,0x8(%esp)
  800340:	00 
  800341:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800348:	00 
  800349:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800350:	e8 bf 04 00 00       	call   800814 <_panic>
	cprintf("stale fileid is good\n");
  800355:	c7 04 24 0d 29 80 00 	movl   $0x80290d,(%esp)
  80035c:	e8 ac 05 00 00       	call   80090d <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800361:	ba 02 01 00 00       	mov    $0x102,%edx
  800366:	b8 23 29 80 00       	mov    $0x802923,%eax
  80036b:	e8 c3 fc ff ff       	call   800033 <xopen>
  800370:	85 c0                	test   %eax,%eax
  800372:	79 20                	jns    800394 <umain+0x2f4>
		panic("serve_open /new-file: %e", r);
  800374:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800378:	c7 44 24 08 2d 29 80 	movl   $0x80292d,0x8(%esp)
  80037f:	00 
  800380:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
  800387:	00 
  800388:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80038f:	e8 80 04 00 00       	call   800814 <_panic>

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  800394:	8b 1d 14 40 80 00    	mov    0x804014,%ebx
  80039a:	a1 00 40 80 00       	mov    0x804000,%eax
  80039f:	89 04 24             	mov    %eax,(%esp)
  8003a2:	e8 69 0b 00 00       	call   800f10 <strlen>
  8003a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ab:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003b4:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8003bb:	ff d3                	call   *%ebx
  8003bd:	89 c3                	mov    %eax,%ebx
  8003bf:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c4:	89 04 24             	mov    %eax,(%esp)
  8003c7:	e8 44 0b 00 00       	call   800f10 <strlen>
  8003cc:	39 c3                	cmp    %eax,%ebx
  8003ce:	74 20                	je     8003f0 <umain+0x350>
		panic("file_write: %e", r);
  8003d0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d4:	c7 44 24 08 46 29 80 	movl   $0x802946,0x8(%esp)
  8003db:	00 
  8003dc:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8003e3:	00 
  8003e4:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8003eb:	e8 24 04 00 00       	call   800814 <_panic>
	cprintf("file_write is good\n");
  8003f0:	c7 04 24 55 29 80 00 	movl   $0x802955,(%esp)
  8003f7:	e8 11 05 00 00       	call   80090d <cprintf>

	FVA->fd_offset = 0;
  8003fc:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800403:	00 00 00 
	memset(buf, 0, sizeof buf);
  800406:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80040d:	00 
  80040e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800415:	00 
  800416:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	e8 f5 0c 00 00       	call   801119 <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800424:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80042b:	00 
  80042c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800430:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  800437:	ff 15 10 40 80 00    	call   *0x804010
  80043d:	89 c3                	mov    %eax,%ebx
  80043f:	85 c0                	test   %eax,%eax
  800441:	79 20                	jns    800463 <umain+0x3c3>
		panic("file_read after file_write: %e", r);
  800443:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800447:	c7 44 24 08 94 2a 80 	movl   $0x802a94,0x8(%esp)
  80044e:	00 
  80044f:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  800456:	00 
  800457:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80045e:	e8 b1 03 00 00       	call   800814 <_panic>
	if (r != strlen(msg))
  800463:	a1 00 40 80 00       	mov    0x804000,%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 a0 0a 00 00       	call   800f10 <strlen>
  800470:	39 d8                	cmp    %ebx,%eax
  800472:	74 20                	je     800494 <umain+0x3f4>
		panic("file_read after file_write returned wrong length: %d", r);
  800474:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800478:	c7 44 24 08 b4 2a 80 	movl   $0x802ab4,0x8(%esp)
  80047f:	00 
  800480:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
  800487:	00 
  800488:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80048f:	e8 80 03 00 00       	call   800814 <_panic>
	if (strcmp(buf, msg) != 0)
  800494:	a1 00 40 80 00       	mov    0x804000,%eax
  800499:	89 44 24 04          	mov    %eax,0x4(%esp)
  80049d:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004a3:	89 04 24             	mov    %eax,(%esp)
  8004a6:	e8 8a 0b 00 00       	call   801035 <strcmp>
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 1c                	je     8004cb <umain+0x42b>
		panic("file_read after file_write returned wrong data");
  8004af:	c7 44 24 08 ec 2a 80 	movl   $0x802aec,0x8(%esp)
  8004b6:	00 
  8004b7:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8004be:	00 
  8004bf:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8004c6:	e8 49 03 00 00       	call   800814 <_panic>
	cprintf("file_read after file_write is good\n");
  8004cb:	c7 04 24 1c 2b 80 00 	movl   $0x802b1c,(%esp)
  8004d2:	e8 36 04 00 00       	call   80090d <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8004d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004de:	00 
  8004df:	c7 04 24 20 28 80 00 	movl   $0x802820,(%esp)
  8004e6:	e8 6b 1a 00 00       	call   801f56 <open>
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	79 25                	jns    800514 <umain+0x474>
  8004ef:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8004f2:	74 3c                	je     800530 <umain+0x490>
		panic("open /not-found: %e", r);
  8004f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f8:	c7 44 24 08 31 28 80 	movl   $0x802831,0x8(%esp)
  8004ff:	00 
  800500:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  800507:	00 
  800508:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80050f:	e8 00 03 00 00       	call   800814 <_panic>
	else if (r >= 0)
		panic("open /not-found succeeded!");
  800514:	c7 44 24 08 69 29 80 	movl   $0x802969,0x8(%esp)
  80051b:	00 
  80051c:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800523:	00 
  800524:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80052b:	e8 e4 02 00 00       	call   800814 <_panic>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  800530:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800537:	00 
  800538:	c7 04 24 55 28 80 00 	movl   $0x802855,(%esp)
  80053f:	e8 12 1a 00 00       	call   801f56 <open>
  800544:	85 c0                	test   %eax,%eax
  800546:	79 20                	jns    800568 <umain+0x4c8>
		panic("open /newmotd: %e", r);
  800548:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80054c:	c7 44 24 08 64 28 80 	movl   $0x802864,0x8(%esp)
  800553:	00 
  800554:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  80055b:	00 
  80055c:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  800563:	e8 ac 02 00 00       	call   800814 <_panic>
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800568:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80056b:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800572:	75 12                	jne    800586 <umain+0x4e6>
  800574:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80057b:	75 09                	jne    800586 <umain+0x4e6>
  80057d:	83 b8 08 00 00 d0 00 	cmpl   $0x0,-0x2ffffff8(%eax)
  800584:	74 1c                	je     8005a2 <umain+0x502>
		panic("open did not fill struct Fd correctly\n");
  800586:	c7 44 24 08 40 2b 80 	movl   $0x802b40,0x8(%esp)
  80058d:	00 
  80058e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800595:	00 
  800596:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80059d:	e8 72 02 00 00       	call   800814 <_panic>
	cprintf("open is good\n");
  8005a2:	c7 04 24 7c 28 80 00 	movl   $0x80287c,(%esp)
  8005a9:	e8 5f 03 00 00       	call   80090d <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8005ae:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
  8005b5:	00 
  8005b6:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  8005bd:	e8 94 19 00 00       	call   801f56 <open>
  8005c2:	89 c6                	mov    %eax,%esi
  8005c4:	85 c0                	test   %eax,%eax
  8005c6:	79 20                	jns    8005e8 <umain+0x548>
		panic("creat /big: %e", f);
  8005c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cc:	c7 44 24 08 89 29 80 	movl   $0x802989,0x8(%esp)
  8005d3:	00 
  8005d4:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  8005db:	00 
  8005dc:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8005e3:	e8 2c 02 00 00       	call   800814 <_panic>
	memset(buf, 0, sizeof(buf));
  8005e8:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8005f7:	00 
  8005f8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8005fe:	89 04 24             	mov    %eax,(%esp)
  800601:	e8 13 0b 00 00       	call   801119 <memset>
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800606:	bb 00 00 00 00       	mov    $0x0,%ebx
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
  80060b:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  800611:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  800617:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80061e:	00 
  80061f:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800623:	89 34 24             	mov    %esi,(%esp)
  800626:	e8 a8 15 00 00       	call   801bd3 <write>
  80062b:	85 c0                	test   %eax,%eax
  80062d:	79 24                	jns    800653 <umain+0x5b3>
			panic("write /big@%d: %e", i, r);
  80062f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800633:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800637:	c7 44 24 08 98 29 80 	movl   $0x802998,0x8(%esp)
  80063e:	00 
  80063f:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  800646:	00 
  800647:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80064e:	e8 c1 01 00 00       	call   800814 <_panic>
  800653:	8d 83 00 02 00 00    	lea    0x200(%ebx),%eax
  800659:	89 c3                	mov    %eax,%ebx

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  80065b:	3d 00 e0 01 00       	cmp    $0x1e000,%eax
  800660:	75 af                	jne    800611 <umain+0x571>
		*(int*)buf = i;
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  800662:	89 34 24             	mov    %esi,(%esp)
  800665:	e8 19 13 00 00       	call   801983 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  80066a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800671:	00 
  800672:	c7 04 24 84 29 80 00 	movl   $0x802984,(%esp)
  800679:	e8 d8 18 00 00       	call   801f56 <open>
  80067e:	89 c6                	mov    %eax,%esi
  800680:	85 c0                	test   %eax,%eax
  800682:	79 20                	jns    8006a4 <umain+0x604>
		panic("open /big: %e", f);
  800684:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800688:	c7 44 24 08 aa 29 80 	movl   $0x8029aa,0x8(%esp)
  80068f:	00 
  800690:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  800697:	00 
  800698:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80069f:	e8 70 01 00 00       	call   800814 <_panic>
		if ((r = write(f, buf, sizeof(buf))) < 0)
			panic("write /big@%d: %e", i, r);
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
  8006a4:	bb 00 00 00 00       	mov    $0x0,%ebx
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006a9:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
  8006af:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  8006b5:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8006bc:	00 
  8006bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c1:	89 34 24             	mov    %esi,(%esp)
  8006c4:	e8 af 14 00 00       	call   801b78 <readn>
  8006c9:	85 c0                	test   %eax,%eax
  8006cb:	79 24                	jns    8006f1 <umain+0x651>
			panic("read /big@%d: %e", i, r);
  8006cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006d5:	c7 44 24 08 b8 29 80 	movl   $0x8029b8,0x8(%esp)
  8006dc:	00 
  8006dd:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  8006e4:	00 
  8006e5:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  8006ec:	e8 23 01 00 00       	call   800814 <_panic>
		if (r != sizeof(buf))
  8006f1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8006f6:	74 2c                	je     800724 <umain+0x684>
			panic("read /big from %d returned %d < %d bytes",
  8006f8:	c7 44 24 14 00 02 00 	movl   $0x200,0x14(%esp)
  8006ff:	00 
  800700:	89 44 24 10          	mov    %eax,0x10(%esp)
  800704:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800708:	c7 44 24 08 68 2b 80 	movl   $0x802b68,0x8(%esp)
  80070f:	00 
  800710:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800717:	00 
  800718:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80071f:	e8 f0 00 00 00       	call   800814 <_panic>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800724:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  80072a:	39 d8                	cmp    %ebx,%eax
  80072c:	74 24                	je     800752 <umain+0x6b2>
			panic("read /big from %d returned bad data %d",
  80072e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800732:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800736:	c7 44 24 08 94 2b 80 	movl   $0x802b94,0x8(%esp)
  80073d:	00 
  80073e:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800745:	00 
  800746:	c7 04 24 45 28 80 00 	movl   $0x802845,(%esp)
  80074d:	e8 c2 00 00 00       	call   800814 <_panic>
	}
	close(f);

	if ((f = open("/big", O_RDONLY)) < 0)
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800752:	8d 98 00 02 00 00    	lea    0x200(%eax),%ebx
  800758:	81 fb ff df 01 00    	cmp    $0x1dfff,%ebx
  80075e:	0f 8e 4b ff ff ff    	jle    8006af <umain+0x60f>
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  800764:	89 34 24             	mov    %esi,(%esp)
  800767:	e8 17 12 00 00       	call   801983 <close>
	cprintf("large file is good\n");
  80076c:	c7 04 24 c9 29 80 00 	movl   $0x8029c9,(%esp)
  800773:	e8 95 01 00 00       	call   80090d <cprintf>
}
  800778:	81 c4 cc 02 00 00    	add    $0x2cc,%esp
  80077e:	5b                   	pop    %ebx
  80077f:	5e                   	pop    %esi
  800780:	5f                   	pop    %edi
  800781:	5d                   	pop    %ebp
  800782:	c3                   	ret    

00800783 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	56                   	push   %esi
  800787:	53                   	push   %ebx
  800788:	83 ec 10             	sub    $0x10,%esp
  80078b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80078e:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800791:	e8 45 0c 00 00       	call   8013db <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800796:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80079c:	39 c2                	cmp    %eax,%edx
  80079e:	74 17                	je     8007b7 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8007a0:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8007a5:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8007a8:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8007ae:	8b 49 40             	mov    0x40(%ecx),%ecx
  8007b1:	39 c1                	cmp    %eax,%ecx
  8007b3:	75 18                	jne    8007cd <libmain+0x4a>
  8007b5:	eb 05                	jmp    8007bc <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8007b7:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8007bc:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8007bf:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8007c5:	89 15 04 50 80 00    	mov    %edx,0x805004
			break;
  8007cb:	eb 0b                	jmp    8007d8 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8007cd:	83 c2 01             	add    $0x1,%edx
  8007d0:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8007d6:	75 cd                	jne    8007a5 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007d8:	85 db                	test   %ebx,%ebx
  8007da:	7e 07                	jle    8007e3 <libmain+0x60>
		binaryname = argv[0];
  8007dc:	8b 06                	mov    (%esi),%eax
  8007de:	a3 04 40 80 00       	mov    %eax,0x804004

	// call user main routine
	umain(argc, argv);
  8007e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e7:	89 1c 24             	mov    %ebx,(%esp)
  8007ea:	e8 b1 f8 ff ff       	call   8000a0 <umain>

	// exit gracefully
	exit();
  8007ef:	e8 07 00 00 00       	call   8007fb <exit>
}
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800801:	e8 b0 11 00 00       	call   8019b6 <close_all>
	sys_env_destroy(0);
  800806:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80080d:	e8 77 0b 00 00       	call   801389 <sys_env_destroy>
}
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	56                   	push   %esi
  800818:	53                   	push   %ebx
  800819:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80081c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80081f:	8b 35 04 40 80 00    	mov    0x804004,%esi
  800825:	e8 b1 0b 00 00       	call   8013db <sys_getenvid>
  80082a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082d:	89 54 24 10          	mov    %edx,0x10(%esp)
  800831:	8b 55 08             	mov    0x8(%ebp),%edx
  800834:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800838:	89 74 24 08          	mov    %esi,0x8(%esp)
  80083c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800840:	c7 04 24 ec 2b 80 00 	movl   $0x802bec,(%esp)
  800847:	e8 c1 00 00 00       	call   80090d <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80084c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	89 04 24             	mov    %eax,(%esp)
  800856:	e8 51 00 00 00       	call   8008ac <vcprintf>
	cprintf("\n");
  80085b:	c7 04 24 28 30 80 00 	movl   $0x803028,(%esp)
  800862:	e8 a6 00 00 00       	call   80090d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800867:	cc                   	int3   
  800868:	eb fd                	jmp    800867 <_panic+0x53>

0080086a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	53                   	push   %ebx
  80086e:	83 ec 14             	sub    $0x14,%esp
  800871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800874:	8b 13                	mov    (%ebx),%edx
  800876:	8d 42 01             	lea    0x1(%edx),%eax
  800879:	89 03                	mov    %eax,(%ebx)
  80087b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800882:	3d ff 00 00 00       	cmp    $0xff,%eax
  800887:	75 19                	jne    8008a2 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800889:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800890:	00 
  800891:	8d 43 08             	lea    0x8(%ebx),%eax
  800894:	89 04 24             	mov    %eax,(%esp)
  800897:	e8 b0 0a 00 00       	call   80134c <sys_cputs>
		b->idx = 0;
  80089c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8008a2:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8008a6:	83 c4 14             	add    $0x14,%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5d                   	pop    %ebp
  8008ab:	c3                   	ret    

008008ac <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8008b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8008bc:	00 00 00 
	b.cnt = 0;
  8008bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8008c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8008dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e1:	c7 04 24 6a 08 80 00 	movl   $0x80086a,(%esp)
  8008e8:	e8 b7 01 00 00       	call   800aa4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8008ed:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8008f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8008fd:	89 04 24             	mov    %eax,(%esp)
  800900:	e8 47 0a 00 00       	call   80134c <sys_cputs>

	return b.cnt;
}
  800905:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80090b:	c9                   	leave  
  80090c:	c3                   	ret    

0080090d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800913:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800916:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	89 04 24             	mov    %eax,(%esp)
  800920:	e8 87 ff ff ff       	call   8008ac <vcprintf>
	va_end(ap);

	return cnt;
}
  800925:	c9                   	leave  
  800926:	c3                   	ret    
  800927:	66 90                	xchg   %ax,%ax
  800929:	66 90                	xchg   %ax,%ax
  80092b:	66 90                	xchg   %ax,%ax
  80092d:	66 90                	xchg   %ax,%ax
  80092f:	90                   	nop

00800930 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	57                   	push   %edi
  800934:	56                   	push   %esi
  800935:	53                   	push   %ebx
  800936:	83 ec 3c             	sub    $0x3c,%esp
  800939:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80093c:	89 d7                	mov    %edx,%edi
  80093e:	8b 45 08             	mov    0x8(%ebp),%eax
  800941:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800944:	8b 75 0c             	mov    0xc(%ebp),%esi
  800947:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80094a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80094d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800952:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800955:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800958:	39 f1                	cmp    %esi,%ecx
  80095a:	72 14                	jb     800970 <printnum+0x40>
  80095c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80095f:	76 0f                	jbe    800970 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800961:	8b 45 14             	mov    0x14(%ebp),%eax
  800964:	8d 70 ff             	lea    -0x1(%eax),%esi
  800967:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80096a:	85 f6                	test   %esi,%esi
  80096c:	7f 60                	jg     8009ce <printnum+0x9e>
  80096e:	eb 72                	jmp    8009e2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800970:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800973:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800977:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80097a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80097d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800981:	89 44 24 08          	mov    %eax,0x8(%esp)
  800985:	8b 44 24 08          	mov    0x8(%esp),%eax
  800989:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80098d:	89 c3                	mov    %eax,%ebx
  80098f:	89 d6                	mov    %edx,%esi
  800991:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800994:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800997:	89 54 24 08          	mov    %edx,0x8(%esp)
  80099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80099f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009a2:	89 04 24             	mov    %eax,(%esp)
  8009a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ac:	e8 df 1b 00 00       	call   802590 <__udivdi3>
  8009b1:	89 d9                	mov    %ebx,%ecx
  8009b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009bb:	89 04 24             	mov    %eax,(%esp)
  8009be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009c2:	89 fa                	mov    %edi,%edx
  8009c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c7:	e8 64 ff ff ff       	call   800930 <printnum>
  8009cc:	eb 14                	jmp    8009e2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8009ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8009d5:	89 04 24             	mov    %eax,(%esp)
  8009d8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8009da:	83 ee 01             	sub    $0x1,%esi
  8009dd:	75 ef                	jne    8009ce <printnum+0x9e>
  8009df:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8009e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009e6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8009ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8009ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8009f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009fb:	89 04 24             	mov    %eax,(%esp)
  8009fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a05:	e8 b6 1c 00 00       	call   8026c0 <__umoddi3>
  800a0a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a0e:	0f be 80 0f 2c 80 00 	movsbl 0x802c0f(%eax),%eax
  800a15:	89 04 24             	mov    %eax,(%esp)
  800a18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
}
  800a1d:	83 c4 3c             	add    $0x3c,%esp
  800a20:	5b                   	pop    %ebx
  800a21:	5e                   	pop    %esi
  800a22:	5f                   	pop    %edi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a28:	83 fa 01             	cmp    $0x1,%edx
  800a2b:	7e 0e                	jle    800a3b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800a2d:	8b 10                	mov    (%eax),%edx
  800a2f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800a32:	89 08                	mov    %ecx,(%eax)
  800a34:	8b 02                	mov    (%edx),%eax
  800a36:	8b 52 04             	mov    0x4(%edx),%edx
  800a39:	eb 22                	jmp    800a5d <getuint+0x38>
	else if (lflag)
  800a3b:	85 d2                	test   %edx,%edx
  800a3d:	74 10                	je     800a4f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800a3f:	8b 10                	mov    (%eax),%edx
  800a41:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a44:	89 08                	mov    %ecx,(%eax)
  800a46:	8b 02                	mov    (%edx),%eax
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	eb 0e                	jmp    800a5d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800a4f:	8b 10                	mov    (%eax),%edx
  800a51:	8d 4a 04             	lea    0x4(%edx),%ecx
  800a54:	89 08                	mov    %ecx,(%eax)
  800a56:	8b 02                	mov    (%edx),%eax
  800a58:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800a5d:	5d                   	pop    %ebp
  800a5e:	c3                   	ret    

00800a5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a5f:	55                   	push   %ebp
  800a60:	89 e5                	mov    %esp,%ebp
  800a62:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800a65:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800a69:	8b 10                	mov    (%eax),%edx
  800a6b:	3b 50 04             	cmp    0x4(%eax),%edx
  800a6e:	73 0a                	jae    800a7a <sprintputch+0x1b>
		*b->buf++ = ch;
  800a70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a73:	89 08                	mov    %ecx,(%eax)
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	88 02                	mov    %al,(%edx)
}
  800a7a:	5d                   	pop    %ebp
  800a7b:	c3                   	ret    

00800a7c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a82:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800a85:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a89:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	89 04 24             	mov    %eax,(%esp)
  800a9d:	e8 02 00 00 00       	call   800aa4 <vprintfmt>
	va_end(ap);
}
  800aa2:	c9                   	leave  
  800aa3:	c3                   	ret    

00800aa4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800aa4:	55                   	push   %ebp
  800aa5:	89 e5                	mov    %esp,%ebp
  800aa7:	57                   	push   %edi
  800aa8:	56                   	push   %esi
  800aa9:	53                   	push   %ebx
  800aaa:	83 ec 3c             	sub    $0x3c,%esp
  800aad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ab3:	eb 18                	jmp    800acd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800ab5:	85 c0                	test   %eax,%eax
  800ab7:	0f 84 c3 03 00 00    	je     800e80 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  800abd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ac1:	89 04 24             	mov    %eax,(%esp)
  800ac4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ac7:	89 f3                	mov    %esi,%ebx
  800ac9:	eb 02                	jmp    800acd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  800acb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800acd:	8d 73 01             	lea    0x1(%ebx),%esi
  800ad0:	0f b6 03             	movzbl (%ebx),%eax
  800ad3:	83 f8 25             	cmp    $0x25,%eax
  800ad6:	75 dd                	jne    800ab5 <vprintfmt+0x11>
  800ad8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  800adc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800ae3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800aea:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800af1:	ba 00 00 00 00       	mov    $0x0,%edx
  800af6:	eb 1d                	jmp    800b15 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800af8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800afa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  800afe:	eb 15                	jmp    800b15 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b00:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800b02:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800b06:	eb 0d                	jmp    800b15 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800b08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b0e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b15:	8d 5e 01             	lea    0x1(%esi),%ebx
  800b18:	0f b6 06             	movzbl (%esi),%eax
  800b1b:	0f b6 c8             	movzbl %al,%ecx
  800b1e:	83 e8 23             	sub    $0x23,%eax
  800b21:	3c 55                	cmp    $0x55,%al
  800b23:	0f 87 2f 03 00 00    	ja     800e58 <vprintfmt+0x3b4>
  800b29:	0f b6 c0             	movzbl %al,%eax
  800b2c:	ff 24 85 60 2d 80 00 	jmp    *0x802d60(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800b33:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800b36:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800b39:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800b3d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800b40:	83 f9 09             	cmp    $0x9,%ecx
  800b43:	77 50                	ja     800b95 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b45:	89 de                	mov    %ebx,%esi
  800b47:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800b4a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800b4d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800b50:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800b54:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800b57:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800b5a:	83 fb 09             	cmp    $0x9,%ebx
  800b5d:	76 eb                	jbe    800b4a <vprintfmt+0xa6>
  800b5f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b62:	eb 33                	jmp    800b97 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	8d 48 04             	lea    0x4(%eax),%ecx
  800b6a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b72:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800b74:	eb 21                	jmp    800b97 <vprintfmt+0xf3>
  800b76:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800b79:	85 c9                	test   %ecx,%ecx
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
  800b80:	0f 49 c1             	cmovns %ecx,%eax
  800b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b86:	89 de                	mov    %ebx,%esi
  800b88:	eb 8b                	jmp    800b15 <vprintfmt+0x71>
  800b8a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800b8c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800b93:	eb 80                	jmp    800b15 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b9b:	0f 89 74 ff ff ff    	jns    800b15 <vprintfmt+0x71>
  800ba1:	e9 62 ff ff ff       	jmp    800b08 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ba6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ba9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800bab:	e9 65 ff ff ff       	jmp    800b15 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800bb0:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb3:	8d 50 04             	lea    0x4(%eax),%edx
  800bb6:	89 55 14             	mov    %edx,0x14(%ebp)
  800bb9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bbd:	8b 00                	mov    (%eax),%eax
  800bbf:	89 04 24             	mov    %eax,(%esp)
  800bc2:	ff 55 08             	call   *0x8(%ebp)
			break;
  800bc5:	e9 03 ff ff ff       	jmp    800acd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800bca:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcd:	8d 50 04             	lea    0x4(%eax),%edx
  800bd0:	89 55 14             	mov    %edx,0x14(%ebp)
  800bd3:	8b 00                	mov    (%eax),%eax
  800bd5:	99                   	cltd   
  800bd6:	31 d0                	xor    %edx,%eax
  800bd8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800bda:	83 f8 0f             	cmp    $0xf,%eax
  800bdd:	7f 0b                	jg     800bea <vprintfmt+0x146>
  800bdf:	8b 14 85 c0 2e 80 00 	mov    0x802ec0(,%eax,4),%edx
  800be6:	85 d2                	test   %edx,%edx
  800be8:	75 20                	jne    800c0a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  800bea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800bee:	c7 44 24 08 27 2c 80 	movl   $0x802c27,0x8(%esp)
  800bf5:	00 
  800bf6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	89 04 24             	mov    %eax,(%esp)
  800c00:	e8 77 fe ff ff       	call   800a7c <printfmt>
  800c05:	e9 c3 fe ff ff       	jmp    800acd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  800c0a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c0e:	c7 44 24 08 f6 2f 80 	movl   $0x802ff6,0x8(%esp)
  800c15:	00 
  800c16:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	89 04 24             	mov    %eax,(%esp)
  800c20:	e8 57 fe ff ff       	call   800a7c <printfmt>
  800c25:	e9 a3 fe ff ff       	jmp    800acd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c2a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800c2d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800c30:	8b 45 14             	mov    0x14(%ebp),%eax
  800c33:	8d 50 04             	lea    0x4(%eax),%edx
  800c36:	89 55 14             	mov    %edx,0x14(%ebp)
  800c39:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  800c3b:	85 c0                	test   %eax,%eax
  800c3d:	ba 20 2c 80 00       	mov    $0x802c20,%edx
  800c42:	0f 45 d0             	cmovne %eax,%edx
  800c45:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800c48:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  800c4c:	74 04                	je     800c52 <vprintfmt+0x1ae>
  800c4e:	85 f6                	test   %esi,%esi
  800c50:	7f 19                	jg     800c6b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c52:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c55:	8d 70 01             	lea    0x1(%eax),%esi
  800c58:	0f b6 10             	movzbl (%eax),%edx
  800c5b:	0f be c2             	movsbl %dl,%eax
  800c5e:	85 c0                	test   %eax,%eax
  800c60:	0f 85 95 00 00 00    	jne    800cfb <vprintfmt+0x257>
  800c66:	e9 85 00 00 00       	jmp    800cf0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c6b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800c6f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c72:	89 04 24             	mov    %eax,(%esp)
  800c75:	e8 b8 02 00 00       	call   800f32 <strnlen>
  800c7a:	29 c6                	sub    %eax,%esi
  800c7c:	89 f0                	mov    %esi,%eax
  800c7e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800c81:	85 f6                	test   %esi,%esi
  800c83:	7e cd                	jle    800c52 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800c85:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800c89:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c8c:	89 c3                	mov    %eax,%ebx
  800c8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c92:	89 34 24             	mov    %esi,(%esp)
  800c95:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c98:	83 eb 01             	sub    $0x1,%ebx
  800c9b:	75 f1                	jne    800c8e <vprintfmt+0x1ea>
  800c9d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800ca0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ca3:	eb ad                	jmp    800c52 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ca5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ca9:	74 1e                	je     800cc9 <vprintfmt+0x225>
  800cab:	0f be d2             	movsbl %dl,%edx
  800cae:	83 ea 20             	sub    $0x20,%edx
  800cb1:	83 fa 5e             	cmp    $0x5e,%edx
  800cb4:	76 13                	jbe    800cc9 <vprintfmt+0x225>
					putch('?', putdat);
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cbd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800cc4:	ff 55 08             	call   *0x8(%ebp)
  800cc7:	eb 0d                	jmp    800cd6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800cc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ccc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cd0:	89 04 24             	mov    %eax,(%esp)
  800cd3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800cd6:	83 ef 01             	sub    $0x1,%edi
  800cd9:	83 c6 01             	add    $0x1,%esi
  800cdc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800ce0:	0f be c2             	movsbl %dl,%eax
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	75 20                	jne    800d07 <vprintfmt+0x263>
  800ce7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800cea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ced:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800cf0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf4:	7f 25                	jg     800d1b <vprintfmt+0x277>
  800cf6:	e9 d2 fd ff ff       	jmp    800acd <vprintfmt+0x29>
  800cfb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800cfe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d01:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d04:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d07:	85 db                	test   %ebx,%ebx
  800d09:	78 9a                	js     800ca5 <vprintfmt+0x201>
  800d0b:	83 eb 01             	sub    $0x1,%ebx
  800d0e:	79 95                	jns    800ca5 <vprintfmt+0x201>
  800d10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800d13:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	eb d5                	jmp    800cf0 <vprintfmt+0x24c>
  800d1b:	8b 75 08             	mov    0x8(%ebp),%esi
  800d1e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800d21:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800d24:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d28:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800d2f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d31:	83 eb 01             	sub    $0x1,%ebx
  800d34:	75 ee                	jne    800d24 <vprintfmt+0x280>
  800d36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d39:	e9 8f fd ff ff       	jmp    800acd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800d3e:	83 fa 01             	cmp    $0x1,%edx
  800d41:	7e 16                	jle    800d59 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800d43:	8b 45 14             	mov    0x14(%ebp),%eax
  800d46:	8d 50 08             	lea    0x8(%eax),%edx
  800d49:	89 55 14             	mov    %edx,0x14(%ebp)
  800d4c:	8b 50 04             	mov    0x4(%eax),%edx
  800d4f:	8b 00                	mov    (%eax),%eax
  800d51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d54:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800d57:	eb 32                	jmp    800d8b <vprintfmt+0x2e7>
	else if (lflag)
  800d59:	85 d2                	test   %edx,%edx
  800d5b:	74 18                	je     800d75 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	89 55 14             	mov    %edx,0x14(%ebp)
  800d66:	8b 30                	mov    (%eax),%esi
  800d68:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d6b:	89 f0                	mov    %esi,%eax
  800d6d:	c1 f8 1f             	sar    $0x1f,%eax
  800d70:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d73:	eb 16                	jmp    800d8b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 14             	mov    0x14(%ebp),%eax
  800d78:	8d 50 04             	lea    0x4(%eax),%edx
  800d7b:	89 55 14             	mov    %edx,0x14(%ebp)
  800d7e:	8b 30                	mov    (%eax),%esi
  800d80:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800d83:	89 f0                	mov    %esi,%eax
  800d85:	c1 f8 1f             	sar    $0x1f,%eax
  800d88:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d8b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800d8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800d91:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800d96:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9a:	0f 89 80 00 00 00    	jns    800e20 <vprintfmt+0x37c>
				putch('-', putdat);
  800da0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800dab:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800dae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800db1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800db4:	f7 d8                	neg    %eax
  800db6:	83 d2 00             	adc    $0x0,%edx
  800db9:	f7 da                	neg    %edx
			}
			base = 10;
  800dbb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800dc0:	eb 5e                	jmp    800e20 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800dc2:	8d 45 14             	lea    0x14(%ebp),%eax
  800dc5:	e8 5b fc ff ff       	call   800a25 <getuint>
			base = 10;
  800dca:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800dcf:	eb 4f                	jmp    800e20 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800dd1:	8d 45 14             	lea    0x14(%ebp),%eax
  800dd4:	e8 4c fc ff ff       	call   800a25 <getuint>
			base = 8;
  800dd9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800dde:	eb 40                	jmp    800e20 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800de0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800de4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800deb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800dee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800df2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800df9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800dfc:	8b 45 14             	mov    0x14(%ebp),%eax
  800dff:	8d 50 04             	lea    0x4(%eax),%edx
  800e02:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800e0c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800e11:	eb 0d                	jmp    800e20 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e13:	8d 45 14             	lea    0x14(%ebp),%eax
  800e16:	e8 0a fc ff ff       	call   800a25 <getuint>
			base = 16;
  800e1b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800e20:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800e24:	89 74 24 10          	mov    %esi,0x10(%esp)
  800e28:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800e2b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800e2f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e33:	89 04 24             	mov    %eax,(%esp)
  800e36:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e3a:	89 fa                	mov    %edi,%edx
  800e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3f:	e8 ec fa ff ff       	call   800930 <printnum>
			break;
  800e44:	e9 84 fc ff ff       	jmp    800acd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800e49:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e4d:	89 0c 24             	mov    %ecx,(%esp)
  800e50:	ff 55 08             	call   *0x8(%ebp)
			break;
  800e53:	e9 75 fc ff ff       	jmp    800acd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800e58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e5c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800e63:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e66:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800e6a:	0f 84 5b fc ff ff    	je     800acb <vprintfmt+0x27>
  800e70:	89 f3                	mov    %esi,%ebx
  800e72:	83 eb 01             	sub    $0x1,%ebx
  800e75:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800e79:	75 f7                	jne    800e72 <vprintfmt+0x3ce>
  800e7b:	e9 4d fc ff ff       	jmp    800acd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800e80:	83 c4 3c             	add    $0x3c,%esp
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 28             	sub    $0x28,%esp
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e97:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e9b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	74 30                	je     800ed9 <vsnprintf+0x51>
  800ea9:	85 d2                	test   %edx,%edx
  800eab:	7e 2c                	jle    800ed9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ead:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ebb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec2:	c7 04 24 5f 0a 80 00 	movl   $0x800a5f,(%esp)
  800ec9:	e8 d6 fb ff ff       	call   800aa4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed7:	eb 05                	jmp    800ede <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ed9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ee6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ee9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800eed:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 04 24             	mov    %eax,(%esp)
  800f01:	e8 82 ff ff ff       	call   800e88 <vsnprintf>
	va_end(ap);

	return rc;
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    
  800f08:	66 90                	xchg   %ax,%ax
  800f0a:	66 90                	xchg   %ax,%ax
  800f0c:	66 90                	xchg   %ax,%ax
  800f0e:	66 90                	xchg   %ax,%ax

00800f10 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800f16:	80 3a 00             	cmpb   $0x0,(%edx)
  800f19:	74 10                	je     800f2b <strlen+0x1b>
  800f1b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800f20:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800f23:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800f27:	75 f7                	jne    800f20 <strlen+0x10>
  800f29:	eb 05                	jmp    800f30 <strlen+0x20>
  800f2b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    

00800f32 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	53                   	push   %ebx
  800f36:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f3c:	85 c9                	test   %ecx,%ecx
  800f3e:	74 1c                	je     800f5c <strnlen+0x2a>
  800f40:	80 3b 00             	cmpb   $0x0,(%ebx)
  800f43:	74 1e                	je     800f63 <strnlen+0x31>
  800f45:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800f4a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f4c:	39 ca                	cmp    %ecx,%edx
  800f4e:	74 18                	je     800f68 <strnlen+0x36>
  800f50:	83 c2 01             	add    $0x1,%edx
  800f53:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800f58:	75 f0                	jne    800f4a <strnlen+0x18>
  800f5a:	eb 0c                	jmp    800f68 <strnlen+0x36>
  800f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f61:	eb 05                	jmp    800f68 <strnlen+0x36>
  800f63:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800f68:	5b                   	pop    %ebx
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	53                   	push   %ebx
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800f75:	89 c2                	mov    %eax,%edx
  800f77:	83 c2 01             	add    $0x1,%edx
  800f7a:	83 c1 01             	add    $0x1,%ecx
  800f7d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800f81:	88 5a ff             	mov    %bl,-0x1(%edx)
  800f84:	84 db                	test   %bl,%bl
  800f86:	75 ef                	jne    800f77 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800f88:	5b                   	pop    %ebx
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800f95:	89 1c 24             	mov    %ebx,(%esp)
  800f98:	e8 73 ff ff ff       	call   800f10 <strlen>
	strcpy(dst + len, src);
  800f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fa0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fa4:	01 d8                	add    %ebx,%eax
  800fa6:	89 04 24             	mov    %eax,(%esp)
  800fa9:	e8 bd ff ff ff       	call   800f6b <strcpy>
	return dst;
}
  800fae:	89 d8                	mov    %ebx,%eax
  800fb0:	83 c4 08             	add    $0x8,%esp
  800fb3:	5b                   	pop    %ebx
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	8b 75 08             	mov    0x8(%ebp),%esi
  800fbe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fc4:	85 db                	test   %ebx,%ebx
  800fc6:	74 17                	je     800fdf <strncpy+0x29>
  800fc8:	01 f3                	add    %esi,%ebx
  800fca:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800fcc:	83 c1 01             	add    $0x1,%ecx
  800fcf:	0f b6 02             	movzbl (%edx),%eax
  800fd2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800fd5:	80 3a 01             	cmpb   $0x1,(%edx)
  800fd8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800fdb:	39 d9                	cmp    %ebx,%ecx
  800fdd:	75 ed                	jne    800fcc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800fdf:	89 f0                	mov    %esi,%eax
  800fe1:	5b                   	pop    %ebx
  800fe2:	5e                   	pop    %esi
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ff1:	8b 75 10             	mov    0x10(%ebp),%esi
  800ff4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ff6:	85 f6                	test   %esi,%esi
  800ff8:	74 34                	je     80102e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800ffa:	83 fe 01             	cmp    $0x1,%esi
  800ffd:	74 26                	je     801025 <strlcpy+0x40>
  800fff:	0f b6 0b             	movzbl (%ebx),%ecx
  801002:	84 c9                	test   %cl,%cl
  801004:	74 23                	je     801029 <strlcpy+0x44>
  801006:	83 ee 02             	sub    $0x2,%esi
  801009:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80100e:	83 c0 01             	add    $0x1,%eax
  801011:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801014:	39 f2                	cmp    %esi,%edx
  801016:	74 13                	je     80102b <strlcpy+0x46>
  801018:	83 c2 01             	add    $0x1,%edx
  80101b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80101f:	84 c9                	test   %cl,%cl
  801021:	75 eb                	jne    80100e <strlcpy+0x29>
  801023:	eb 06                	jmp    80102b <strlcpy+0x46>
  801025:	89 f8                	mov    %edi,%eax
  801027:	eb 02                	jmp    80102b <strlcpy+0x46>
  801029:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80102b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80102e:	29 f8                	sub    %edi,%eax
}
  801030:	5b                   	pop    %ebx
  801031:	5e                   	pop    %esi
  801032:	5f                   	pop    %edi
  801033:	5d                   	pop    %ebp
  801034:	c3                   	ret    

00801035 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801035:	55                   	push   %ebp
  801036:	89 e5                	mov    %esp,%ebp
  801038:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80103e:	0f b6 01             	movzbl (%ecx),%eax
  801041:	84 c0                	test   %al,%al
  801043:	74 15                	je     80105a <strcmp+0x25>
  801045:	3a 02                	cmp    (%edx),%al
  801047:	75 11                	jne    80105a <strcmp+0x25>
		p++, q++;
  801049:	83 c1 01             	add    $0x1,%ecx
  80104c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80104f:	0f b6 01             	movzbl (%ecx),%eax
  801052:	84 c0                	test   %al,%al
  801054:	74 04                	je     80105a <strcmp+0x25>
  801056:	3a 02                	cmp    (%edx),%al
  801058:	74 ef                	je     801049 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80105a:	0f b6 c0             	movzbl %al,%eax
  80105d:	0f b6 12             	movzbl (%edx),%edx
  801060:	29 d0                	sub    %edx,%eax
}
  801062:	5d                   	pop    %ebp
  801063:	c3                   	ret    

00801064 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	56                   	push   %esi
  801068:	53                   	push   %ebx
  801069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80106c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801072:	85 f6                	test   %esi,%esi
  801074:	74 29                	je     80109f <strncmp+0x3b>
  801076:	0f b6 03             	movzbl (%ebx),%eax
  801079:	84 c0                	test   %al,%al
  80107b:	74 30                	je     8010ad <strncmp+0x49>
  80107d:	3a 02                	cmp    (%edx),%al
  80107f:	75 2c                	jne    8010ad <strncmp+0x49>
  801081:	8d 43 01             	lea    0x1(%ebx),%eax
  801084:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801086:	89 c3                	mov    %eax,%ebx
  801088:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80108b:	39 f0                	cmp    %esi,%eax
  80108d:	74 17                	je     8010a6 <strncmp+0x42>
  80108f:	0f b6 08             	movzbl (%eax),%ecx
  801092:	84 c9                	test   %cl,%cl
  801094:	74 17                	je     8010ad <strncmp+0x49>
  801096:	83 c0 01             	add    $0x1,%eax
  801099:	3a 0a                	cmp    (%edx),%cl
  80109b:	74 e9                	je     801086 <strncmp+0x22>
  80109d:	eb 0e                	jmp    8010ad <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80109f:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a4:	eb 0f                	jmp    8010b5 <strncmp+0x51>
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010ab:	eb 08                	jmp    8010b5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8010ad:	0f b6 03             	movzbl (%ebx),%eax
  8010b0:	0f b6 12             	movzbl (%edx),%edx
  8010b3:	29 d0                	sub    %edx,%eax
}
  8010b5:	5b                   	pop    %ebx
  8010b6:	5e                   	pop    %esi
  8010b7:	5d                   	pop    %ebp
  8010b8:	c3                   	ret    

008010b9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8010b9:	55                   	push   %ebp
  8010ba:	89 e5                	mov    %esp,%ebp
  8010bc:	53                   	push   %ebx
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8010c3:	0f b6 18             	movzbl (%eax),%ebx
  8010c6:	84 db                	test   %bl,%bl
  8010c8:	74 1d                	je     8010e7 <strchr+0x2e>
  8010ca:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8010cc:	38 d3                	cmp    %dl,%bl
  8010ce:	75 06                	jne    8010d6 <strchr+0x1d>
  8010d0:	eb 1a                	jmp    8010ec <strchr+0x33>
  8010d2:	38 ca                	cmp    %cl,%dl
  8010d4:	74 16                	je     8010ec <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8010d6:	83 c0 01             	add    $0x1,%eax
  8010d9:	0f b6 10             	movzbl (%eax),%edx
  8010dc:	84 d2                	test   %dl,%dl
  8010de:	75 f2                	jne    8010d2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e5:	eb 05                	jmp    8010ec <strchr+0x33>
  8010e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ec:	5b                   	pop    %ebx
  8010ed:	5d                   	pop    %ebp
  8010ee:	c3                   	ret    

008010ef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	53                   	push   %ebx
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8010f9:	0f b6 18             	movzbl (%eax),%ebx
  8010fc:	84 db                	test   %bl,%bl
  8010fe:	74 16                	je     801116 <strfind+0x27>
  801100:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801102:	38 d3                	cmp    %dl,%bl
  801104:	75 06                	jne    80110c <strfind+0x1d>
  801106:	eb 0e                	jmp    801116 <strfind+0x27>
  801108:	38 ca                	cmp    %cl,%dl
  80110a:	74 0a                	je     801116 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80110c:	83 c0 01             	add    $0x1,%eax
  80110f:	0f b6 10             	movzbl (%eax),%edx
  801112:	84 d2                	test   %dl,%dl
  801114:	75 f2                	jne    801108 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801116:	5b                   	pop    %ebx
  801117:	5d                   	pop    %ebp
  801118:	c3                   	ret    

00801119 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801122:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801125:	85 c9                	test   %ecx,%ecx
  801127:	74 36                	je     80115f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801129:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80112f:	75 28                	jne    801159 <memset+0x40>
  801131:	f6 c1 03             	test   $0x3,%cl
  801134:	75 23                	jne    801159 <memset+0x40>
		c &= 0xFF;
  801136:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80113a:	89 d3                	mov    %edx,%ebx
  80113c:	c1 e3 08             	shl    $0x8,%ebx
  80113f:	89 d6                	mov    %edx,%esi
  801141:	c1 e6 18             	shl    $0x18,%esi
  801144:	89 d0                	mov    %edx,%eax
  801146:	c1 e0 10             	shl    $0x10,%eax
  801149:	09 f0                	or     %esi,%eax
  80114b:	09 c2                	or     %eax,%edx
  80114d:	89 d0                	mov    %edx,%eax
  80114f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801151:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801154:	fc                   	cld    
  801155:	f3 ab                	rep stos %eax,%es:(%edi)
  801157:	eb 06                	jmp    80115f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	fc                   	cld    
  80115d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80115f:	89 f8                	mov    %edi,%eax
  801161:	5b                   	pop    %ebx
  801162:	5e                   	pop    %esi
  801163:	5f                   	pop    %edi
  801164:	5d                   	pop    %ebp
  801165:	c3                   	ret    

00801166 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801171:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801174:	39 c6                	cmp    %eax,%esi
  801176:	73 35                	jae    8011ad <memmove+0x47>
  801178:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80117b:	39 d0                	cmp    %edx,%eax
  80117d:	73 2e                	jae    8011ad <memmove+0x47>
		s += n;
		d += n;
  80117f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801182:	89 d6                	mov    %edx,%esi
  801184:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801186:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80118c:	75 13                	jne    8011a1 <memmove+0x3b>
  80118e:	f6 c1 03             	test   $0x3,%cl
  801191:	75 0e                	jne    8011a1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801193:	83 ef 04             	sub    $0x4,%edi
  801196:	8d 72 fc             	lea    -0x4(%edx),%esi
  801199:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80119c:	fd                   	std    
  80119d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80119f:	eb 09                	jmp    8011aa <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8011a1:	83 ef 01             	sub    $0x1,%edi
  8011a4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8011a7:	fd                   	std    
  8011a8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8011aa:	fc                   	cld    
  8011ab:	eb 1d                	jmp    8011ca <memmove+0x64>
  8011ad:	89 f2                	mov    %esi,%edx
  8011af:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8011b1:	f6 c2 03             	test   $0x3,%dl
  8011b4:	75 0f                	jne    8011c5 <memmove+0x5f>
  8011b6:	f6 c1 03             	test   $0x3,%cl
  8011b9:	75 0a                	jne    8011c5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8011bb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8011be:	89 c7                	mov    %eax,%edi
  8011c0:	fc                   	cld    
  8011c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8011c3:	eb 05                	jmp    8011ca <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8011c5:	89 c7                	mov    %eax,%edi
  8011c7:	fc                   	cld    
  8011c8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8011ca:	5e                   	pop    %esi
  8011cb:	5f                   	pop    %edi
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	89 04 24             	mov    %eax,(%esp)
  8011e8:	e8 79 ff ff ff       	call   801166 <memmove>
}
  8011ed:	c9                   	leave  
  8011ee:	c3                   	ret    

008011ef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8011ef:	55                   	push   %ebp
  8011f0:	89 e5                	mov    %esp,%ebp
  8011f2:	57                   	push   %edi
  8011f3:	56                   	push   %esi
  8011f4:	53                   	push   %ebx
  8011f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8011f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011fb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8011fe:	8d 78 ff             	lea    -0x1(%eax),%edi
  801201:	85 c0                	test   %eax,%eax
  801203:	74 36                	je     80123b <memcmp+0x4c>
		if (*s1 != *s2)
  801205:	0f b6 03             	movzbl (%ebx),%eax
  801208:	0f b6 0e             	movzbl (%esi),%ecx
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
  801210:	38 c8                	cmp    %cl,%al
  801212:	74 1c                	je     801230 <memcmp+0x41>
  801214:	eb 10                	jmp    801226 <memcmp+0x37>
  801216:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  80121b:	83 c2 01             	add    $0x1,%edx
  80121e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801222:	38 c8                	cmp    %cl,%al
  801224:	74 0a                	je     801230 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801226:	0f b6 c0             	movzbl %al,%eax
  801229:	0f b6 c9             	movzbl %cl,%ecx
  80122c:	29 c8                	sub    %ecx,%eax
  80122e:	eb 10                	jmp    801240 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801230:	39 fa                	cmp    %edi,%edx
  801232:	75 e2                	jne    801216 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
  801239:	eb 05                	jmp    801240 <memcmp+0x51>
  80123b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801240:	5b                   	pop    %ebx
  801241:	5e                   	pop    %esi
  801242:	5f                   	pop    %edi
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    

00801245 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	53                   	push   %ebx
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80124f:	89 c2                	mov    %eax,%edx
  801251:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801254:	39 d0                	cmp    %edx,%eax
  801256:	73 13                	jae    80126b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801258:	89 d9                	mov    %ebx,%ecx
  80125a:	38 18                	cmp    %bl,(%eax)
  80125c:	75 06                	jne    801264 <memfind+0x1f>
  80125e:	eb 0b                	jmp    80126b <memfind+0x26>
  801260:	38 08                	cmp    %cl,(%eax)
  801262:	74 07                	je     80126b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801264:	83 c0 01             	add    $0x1,%eax
  801267:	39 d0                	cmp    %edx,%eax
  801269:	75 f5                	jne    801260 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80126b:	5b                   	pop    %ebx
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	57                   	push   %edi
  801272:	56                   	push   %esi
  801273:	53                   	push   %ebx
  801274:	8b 55 08             	mov    0x8(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80127a:	0f b6 0a             	movzbl (%edx),%ecx
  80127d:	80 f9 09             	cmp    $0x9,%cl
  801280:	74 05                	je     801287 <strtol+0x19>
  801282:	80 f9 20             	cmp    $0x20,%cl
  801285:	75 10                	jne    801297 <strtol+0x29>
		s++;
  801287:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80128a:	0f b6 0a             	movzbl (%edx),%ecx
  80128d:	80 f9 09             	cmp    $0x9,%cl
  801290:	74 f5                	je     801287 <strtol+0x19>
  801292:	80 f9 20             	cmp    $0x20,%cl
  801295:	74 f0                	je     801287 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801297:	80 f9 2b             	cmp    $0x2b,%cl
  80129a:	75 0a                	jne    8012a6 <strtol+0x38>
		s++;
  80129c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80129f:	bf 00 00 00 00       	mov    $0x0,%edi
  8012a4:	eb 11                	jmp    8012b7 <strtol+0x49>
  8012a6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8012ab:	80 f9 2d             	cmp    $0x2d,%cl
  8012ae:	75 07                	jne    8012b7 <strtol+0x49>
		s++, neg = 1;
  8012b0:	83 c2 01             	add    $0x1,%edx
  8012b3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8012b7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8012bc:	75 15                	jne    8012d3 <strtol+0x65>
  8012be:	80 3a 30             	cmpb   $0x30,(%edx)
  8012c1:	75 10                	jne    8012d3 <strtol+0x65>
  8012c3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8012c7:	75 0a                	jne    8012d3 <strtol+0x65>
		s += 2, base = 16;
  8012c9:	83 c2 02             	add    $0x2,%edx
  8012cc:	b8 10 00 00 00       	mov    $0x10,%eax
  8012d1:	eb 10                	jmp    8012e3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	75 0c                	jne    8012e3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8012d7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8012d9:	80 3a 30             	cmpb   $0x30,(%edx)
  8012dc:	75 05                	jne    8012e3 <strtol+0x75>
		s++, base = 8;
  8012de:	83 c2 01             	add    $0x1,%edx
  8012e1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8012e3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012e8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012eb:	0f b6 0a             	movzbl (%edx),%ecx
  8012ee:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8012f1:	89 f0                	mov    %esi,%eax
  8012f3:	3c 09                	cmp    $0x9,%al
  8012f5:	77 08                	ja     8012ff <strtol+0x91>
			dig = *s - '0';
  8012f7:	0f be c9             	movsbl %cl,%ecx
  8012fa:	83 e9 30             	sub    $0x30,%ecx
  8012fd:	eb 20                	jmp    80131f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  8012ff:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801302:	89 f0                	mov    %esi,%eax
  801304:	3c 19                	cmp    $0x19,%al
  801306:	77 08                	ja     801310 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801308:	0f be c9             	movsbl %cl,%ecx
  80130b:	83 e9 57             	sub    $0x57,%ecx
  80130e:	eb 0f                	jmp    80131f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801310:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801313:	89 f0                	mov    %esi,%eax
  801315:	3c 19                	cmp    $0x19,%al
  801317:	77 16                	ja     80132f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801319:	0f be c9             	movsbl %cl,%ecx
  80131c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80131f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801322:	7d 0f                	jge    801333 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801324:	83 c2 01             	add    $0x1,%edx
  801327:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  80132b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  80132d:	eb bc                	jmp    8012eb <strtol+0x7d>
  80132f:	89 d8                	mov    %ebx,%eax
  801331:	eb 02                	jmp    801335 <strtol+0xc7>
  801333:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801335:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801339:	74 05                	je     801340 <strtol+0xd2>
		*endptr = (char *) s;
  80133b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80133e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801340:	f7 d8                	neg    %eax
  801342:	85 ff                	test   %edi,%edi
  801344:	0f 44 c3             	cmove  %ebx,%eax
}
  801347:	5b                   	pop    %ebx
  801348:	5e                   	pop    %esi
  801349:	5f                   	pop    %edi
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801352:	b8 00 00 00 00       	mov    $0x0,%eax
  801357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135a:	8b 55 08             	mov    0x8(%ebp),%edx
  80135d:	89 c3                	mov    %eax,%ebx
  80135f:	89 c7                	mov    %eax,%edi
  801361:	89 c6                	mov    %eax,%esi
  801363:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801365:	5b                   	pop    %ebx
  801366:	5e                   	pop    %esi
  801367:	5f                   	pop    %edi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <sys_cgetc>:

int
sys_cgetc(void)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	57                   	push   %edi
  80136e:	56                   	push   %esi
  80136f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	b8 01 00 00 00       	mov    $0x1,%eax
  80137a:	89 d1                	mov    %edx,%ecx
  80137c:	89 d3                	mov    %edx,%ebx
  80137e:	89 d7                	mov    %edx,%edi
  801380:	89 d6                	mov    %edx,%esi
  801382:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801384:	5b                   	pop    %ebx
  801385:	5e                   	pop    %esi
  801386:	5f                   	pop    %edi
  801387:	5d                   	pop    %ebp
  801388:	c3                   	ret    

00801389 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
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
  801392:	b9 00 00 00 00       	mov    $0x0,%ecx
  801397:	b8 03 00 00 00       	mov    $0x3,%eax
  80139c:	8b 55 08             	mov    0x8(%ebp),%edx
  80139f:	89 cb                	mov    %ecx,%ebx
  8013a1:	89 cf                	mov    %ecx,%edi
  8013a3:	89 ce                	mov    %ecx,%esi
  8013a5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013a7:	85 c0                	test   %eax,%eax
  8013a9:	7e 28                	jle    8013d3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013af:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013b6:	00 
  8013b7:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  8013be:	00 
  8013bf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013c6:	00 
  8013c7:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8013ce:	e8 41 f4 ff ff       	call   800814 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8013d3:	83 c4 2c             	add    $0x2c,%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5f                   	pop    %edi
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	57                   	push   %edi
  8013df:	56                   	push   %esi
  8013e0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e6:	b8 02 00 00 00       	mov    $0x2,%eax
  8013eb:	89 d1                	mov    %edx,%ecx
  8013ed:	89 d3                	mov    %edx,%ebx
  8013ef:	89 d7                	mov    %edx,%edi
  8013f1:	89 d6                	mov    %edx,%esi
  8013f3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5f                   	pop    %edi
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <sys_yield>:

void
sys_yield(void)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	57                   	push   %edi
  8013fe:	56                   	push   %esi
  8013ff:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801400:	ba 00 00 00 00       	mov    $0x0,%edx
  801405:	b8 0b 00 00 00       	mov    $0xb,%eax
  80140a:	89 d1                	mov    %edx,%ecx
  80140c:	89 d3                	mov    %edx,%ebx
  80140e:	89 d7                	mov    %edx,%edi
  801410:	89 d6                	mov    %edx,%esi
  801412:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	57                   	push   %edi
  80141d:	56                   	push   %esi
  80141e:	53                   	push   %ebx
  80141f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801422:	be 00 00 00 00       	mov    $0x0,%esi
  801427:	b8 04 00 00 00       	mov    $0x4,%eax
  80142c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142f:	8b 55 08             	mov    0x8(%ebp),%edx
  801432:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801435:	89 f7                	mov    %esi,%edi
  801437:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801439:	85 c0                	test   %eax,%eax
  80143b:	7e 28                	jle    801465 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80143d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801441:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801448:	00 
  801449:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  801450:	00 
  801451:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801458:	00 
  801459:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  801460:	e8 af f3 ff ff       	call   800814 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801465:	83 c4 2c             	add    $0x2c,%esp
  801468:	5b                   	pop    %ebx
  801469:	5e                   	pop    %esi
  80146a:	5f                   	pop    %edi
  80146b:	5d                   	pop    %ebp
  80146c:	c3                   	ret    

0080146d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	57                   	push   %edi
  801471:	56                   	push   %esi
  801472:	53                   	push   %ebx
  801473:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801476:	b8 05 00 00 00       	mov    $0x5,%eax
  80147b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801484:	8b 7d 14             	mov    0x14(%ebp),%edi
  801487:	8b 75 18             	mov    0x18(%ebp),%esi
  80148a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80148c:	85 c0                	test   %eax,%eax
  80148e:	7e 28                	jle    8014b8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801490:	89 44 24 10          	mov    %eax,0x10(%esp)
  801494:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80149b:	00 
  80149c:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  8014a3:	00 
  8014a4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8014ab:	00 
  8014ac:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8014b3:	e8 5c f3 ff ff       	call   800814 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014b8:	83 c4 2c             	add    $0x2c,%esp
  8014bb:	5b                   	pop    %ebx
  8014bc:	5e                   	pop    %esi
  8014bd:	5f                   	pop    %edi
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8014d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d9:	89 df                	mov    %ebx,%edi
  8014db:	89 de                	mov    %ebx,%esi
  8014dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	7e 28                	jle    80150b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014e7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8014ee:	00 
  8014ef:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  8014f6:	00 
  8014f7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8014fe:	00 
  8014ff:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  801506:	e8 09 f3 ff ff       	call   800814 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80150b:	83 c4 2c             	add    $0x2c,%esp
  80150e:	5b                   	pop    %ebx
  80150f:	5e                   	pop    %esi
  801510:	5f                   	pop    %edi
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	57                   	push   %edi
  801517:	56                   	push   %esi
  801518:	53                   	push   %ebx
  801519:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80151c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801521:	b8 08 00 00 00       	mov    $0x8,%eax
  801526:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801529:	8b 55 08             	mov    0x8(%ebp),%edx
  80152c:	89 df                	mov    %ebx,%edi
  80152e:	89 de                	mov    %ebx,%esi
  801530:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801532:	85 c0                	test   %eax,%eax
  801534:	7e 28                	jle    80155e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801536:	89 44 24 10          	mov    %eax,0x10(%esp)
  80153a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801541:	00 
  801542:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  801549:	00 
  80154a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801551:	00 
  801552:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  801559:	e8 b6 f2 ff ff       	call   800814 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80155e:	83 c4 2c             	add    $0x2c,%esp
  801561:	5b                   	pop    %ebx
  801562:	5e                   	pop    %esi
  801563:	5f                   	pop    %edi
  801564:	5d                   	pop    %ebp
  801565:	c3                   	ret    

00801566 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	57                   	push   %edi
  80156a:	56                   	push   %esi
  80156b:	53                   	push   %ebx
  80156c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80156f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801574:	b8 09 00 00 00       	mov    $0x9,%eax
  801579:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157c:	8b 55 08             	mov    0x8(%ebp),%edx
  80157f:	89 df                	mov    %ebx,%edi
  801581:	89 de                	mov    %ebx,%esi
  801583:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801585:	85 c0                	test   %eax,%eax
  801587:	7e 28                	jle    8015b1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801589:	89 44 24 10          	mov    %eax,0x10(%esp)
  80158d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801594:	00 
  801595:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  80159c:	00 
  80159d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8015a4:	00 
  8015a5:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8015ac:	e8 63 f2 ff ff       	call   800814 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8015b1:	83 c4 2c             	add    $0x2c,%esp
  8015b4:	5b                   	pop    %ebx
  8015b5:	5e                   	pop    %esi
  8015b6:	5f                   	pop    %edi
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    

008015b9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	57                   	push   %edi
  8015bd:	56                   	push   %esi
  8015be:	53                   	push   %ebx
  8015bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015c7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d2:	89 df                	mov    %ebx,%edi
  8015d4:	89 de                	mov    %ebx,%esi
  8015d6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8015d8:	85 c0                	test   %eax,%eax
  8015da:	7e 28                	jle    801604 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015e0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8015e7:	00 
  8015e8:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  8015ef:	00 
  8015f0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8015f7:	00 
  8015f8:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  8015ff:	e8 10 f2 ff ff       	call   800814 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801604:	83 c4 2c             	add    $0x2c,%esp
  801607:	5b                   	pop    %ebx
  801608:	5e                   	pop    %esi
  801609:	5f                   	pop    %edi
  80160a:	5d                   	pop    %ebp
  80160b:	c3                   	ret    

0080160c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	57                   	push   %edi
  801610:	56                   	push   %esi
  801611:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801612:	be 00 00 00 00       	mov    $0x0,%esi
  801617:	b8 0c 00 00 00       	mov    $0xc,%eax
  80161c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80161f:	8b 55 08             	mov    0x8(%ebp),%edx
  801622:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801625:	8b 7d 14             	mov    0x14(%ebp),%edi
  801628:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80162a:	5b                   	pop    %ebx
  80162b:	5e                   	pop    %esi
  80162c:	5f                   	pop    %edi
  80162d:	5d                   	pop    %ebp
  80162e:	c3                   	ret    

0080162f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	57                   	push   %edi
  801633:	56                   	push   %esi
  801634:	53                   	push   %ebx
  801635:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801638:	b9 00 00 00 00       	mov    $0x0,%ecx
  80163d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801642:	8b 55 08             	mov    0x8(%ebp),%edx
  801645:	89 cb                	mov    %ecx,%ebx
  801647:	89 cf                	mov    %ecx,%edi
  801649:	89 ce                	mov    %ecx,%esi
  80164b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80164d:	85 c0                	test   %eax,%eax
  80164f:	7e 28                	jle    801679 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801651:	89 44 24 10          	mov    %eax,0x10(%esp)
  801655:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80165c:	00 
  80165d:	c7 44 24 08 1f 2f 80 	movl   $0x802f1f,0x8(%esp)
  801664:	00 
  801665:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80166c:	00 
  80166d:	c7 04 24 3c 2f 80 00 	movl   $0x802f3c,(%esp)
  801674:	e8 9b f1 ff ff       	call   800814 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801679:	83 c4 2c             	add    $0x2c,%esp
  80167c:	5b                   	pop    %ebx
  80167d:	5e                   	pop    %esi
  80167e:	5f                   	pop    %edi
  80167f:	5d                   	pop    %ebp
  801680:	c3                   	ret    

00801681 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	56                   	push   %esi
  801685:	53                   	push   %ebx
  801686:	83 ec 10             	sub    $0x10,%esp
  801689:	8b 75 08             	mov    0x8(%ebp),%esi
  80168c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801692:	85 c0                	test   %eax,%eax
  801694:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801699:	0f 44 c2             	cmove  %edx,%eax
  80169c:	89 04 24             	mov    %eax,(%esp)
  80169f:	e8 8b ff ff ff       	call   80162f <sys_ipc_recv>
	if (err_code < 0) {
  8016a4:	85 c0                	test   %eax,%eax
  8016a6:	79 16                	jns    8016be <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  8016a8:	85 f6                	test   %esi,%esi
  8016aa:	74 06                	je     8016b2 <ipc_recv+0x31>
  8016ac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  8016b2:	85 db                	test   %ebx,%ebx
  8016b4:	74 2c                	je     8016e2 <ipc_recv+0x61>
  8016b6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016bc:	eb 24                	jmp    8016e2 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  8016be:	85 f6                	test   %esi,%esi
  8016c0:	74 0a                	je     8016cc <ipc_recv+0x4b>
  8016c2:	a1 04 50 80 00       	mov    0x805004,%eax
  8016c7:	8b 40 74             	mov    0x74(%eax),%eax
  8016ca:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  8016cc:	85 db                	test   %ebx,%ebx
  8016ce:	74 0a                	je     8016da <ipc_recv+0x59>
  8016d0:	a1 04 50 80 00       	mov    0x805004,%eax
  8016d5:	8b 40 78             	mov    0x78(%eax),%eax
  8016d8:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  8016da:	a1 04 50 80 00       	mov    0x805004,%eax
  8016df:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    

008016e9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	57                   	push   %edi
  8016ed:	56                   	push   %esi
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 1c             	sub    $0x1c,%esp
  8016f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  8016fb:	eb 25                	jmp    801722 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  8016fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801700:	74 20                	je     801722 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801702:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801706:	c7 44 24 08 4a 2f 80 	movl   $0x802f4a,0x8(%esp)
  80170d:	00 
  80170e:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801715:	00 
  801716:	c7 04 24 56 2f 80 00 	movl   $0x802f56,(%esp)
  80171d:	e8 f2 f0 ff ff       	call   800814 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801722:	85 db                	test   %ebx,%ebx
  801724:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801729:	0f 45 c3             	cmovne %ebx,%eax
  80172c:	8b 55 14             	mov    0x14(%ebp),%edx
  80172f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801733:	89 44 24 08          	mov    %eax,0x8(%esp)
  801737:	89 74 24 04          	mov    %esi,0x4(%esp)
  80173b:	89 3c 24             	mov    %edi,(%esp)
  80173e:	e8 c9 fe ff ff       	call   80160c <sys_ipc_try_send>
  801743:	85 c0                	test   %eax,%eax
  801745:	75 b6                	jne    8016fd <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801747:	83 c4 1c             	add    $0x1c,%esp
  80174a:	5b                   	pop    %ebx
  80174b:	5e                   	pop    %esi
  80174c:	5f                   	pop    %edi
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801755:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  80175a:	39 c8                	cmp    %ecx,%eax
  80175c:	74 17                	je     801775 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80175e:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801763:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801766:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80176c:	8b 52 50             	mov    0x50(%edx),%edx
  80176f:	39 ca                	cmp    %ecx,%edx
  801771:	75 14                	jne    801787 <ipc_find_env+0x38>
  801773:	eb 05                	jmp    80177a <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  80177a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80177d:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801782:	8b 40 40             	mov    0x40(%eax),%eax
  801785:	eb 0e                	jmp    801795 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801787:	83 c0 01             	add    $0x1,%eax
  80178a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80178f:	75 d2                	jne    801763 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801791:	66 b8 00 00          	mov    $0x0,%ax
}
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    
  801797:	66 90                	xchg   %ax,%ax
  801799:	66 90                	xchg   %ax,%ax
  80179b:	66 90                	xchg   %ax,%ax
  80179d:	66 90                	xchg   %ax,%ax
  80179f:	90                   	nop

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
  80189e:	39 05 08 40 80 00    	cmp    %eax,0x804008
  8018a4:	75 1e                	jne    8018c4 <dev_lookup+0x33>
  8018a6:	eb 0e                	jmp    8018b6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8018a8:	b8 24 40 80 00       	mov    $0x804024,%eax
  8018ad:	eb 0c                	jmp    8018bb <dev_lookup+0x2a>
  8018af:	b8 40 40 80 00       	mov    $0x804040,%eax
  8018b4:	eb 05                	jmp    8018bb <dev_lookup+0x2a>
  8018b6:	b8 08 40 80 00       	mov    $0x804008,%eax
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
  8018c4:	39 05 24 40 80 00    	cmp    %eax,0x804024
  8018ca:	74 dc                	je     8018a8 <dev_lookup+0x17>
  8018cc:	39 05 40 40 80 00    	cmp    %eax,0x804040
  8018d2:	74 db                	je     8018af <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8018d4:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8018da:	8b 52 48             	mov    0x48(%edx),%edx
  8018dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018e5:	c7 04 24 60 2f 80 00 	movl   $0x802f60,(%esp)
  8018ec:	e8 1c f0 ff ff       	call   80090d <cprintf>
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
  801975:	e8 46 fb ff ff       	call   8014c0 <sys_page_unmap>
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
  801a73:	e8 f5 f9 ff ff       	call   80146d <sys_page_map>
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
  801aae:	e8 ba f9 ff ff       	call   80146d <sys_page_map>
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
  801ac7:	e8 f4 f9 ff ff       	call   8014c0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801acc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801ad0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad7:	e8 e4 f9 ff ff       	call   8014c0 <sys_page_unmap>
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
  801b3b:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  801b42:	e8 c6 ed ff ff       	call   80090d <cprintf>
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
  801c23:	c7 04 24 c0 2f 80 00 	movl   $0x802fc0,(%esp)
  801c2a:	e8 de ec ff ff       	call   80090d <cprintf>
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
  801cdc:	c7 04 24 80 2f 80 00 	movl   $0x802f80,(%esp)
  801ce3:	e8 25 ec ff ff       	call   80090d <cprintf>
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
  801deb:	e8 5f f9 ff ff       	call   80174f <ipc_find_env>
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
  801e11:	e8 d3 f8 ff ff       	call   8016e9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e1d:	00 
  801e1e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e29:	e8 53 f8 ff ff       	call   801681 <ipc_recv>
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
  801e6a:	e8 fc f0 ff ff       	call   800f6b <strcpy>
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
  801ee7:	c7 44 24 0c dd 2f 80 	movl   $0x802fdd,0xc(%esp)
  801eee:	00 
  801eef:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801ef6:	00 
  801ef7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801efe:	00 
  801eff:	c7 04 24 f9 2f 80 00 	movl   $0x802ff9,(%esp)
  801f06:	e8 09 e9 ff ff       	call   800814 <_panic>
	assert(r <= PGSIZE);
  801f0b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801f10:	7e 24                	jle    801f36 <devfile_read+0x84>
  801f12:	c7 44 24 0c 04 30 80 	movl   $0x803004,0xc(%esp)
  801f19:	00 
  801f1a:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  801f21:	00 
  801f22:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801f29:	00 
  801f2a:	c7 04 24 f9 2f 80 00 	movl   $0x802ff9,(%esp)
  801f31:	e8 de e8 ff ff       	call   800814 <_panic>
	memmove(buf, &fsipcbuf, r);
  801f36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f3a:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801f41:	00 
  801f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f45:	89 04 24             	mov    %eax,(%esp)
  801f48:	e8 19 f2 ff ff       	call   801166 <memmove>
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
  801f63:	e8 a8 ef ff ff       	call   800f10 <strlen>
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
  801f8b:	e8 db ef ff ff       	call   800f6b <strcpy>
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
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
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

00801fe0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	56                   	push   %esi
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 10             	sub    $0x10,%esp
  801fe8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	89 04 24             	mov    %eax,(%esp)
  801ff1:	e8 ba f7 ff ff       	call   8017b0 <fd2data>
  801ff6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ff8:	c7 44 24 04 10 30 80 	movl   $0x803010,0x4(%esp)
  801fff:	00 
  802000:	89 1c 24             	mov    %ebx,(%esp)
  802003:	e8 63 ef ff ff       	call   800f6b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802008:	8b 46 04             	mov    0x4(%esi),%eax
  80200b:	2b 06                	sub    (%esi),%eax
  80200d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802013:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80201a:	00 00 00 
	stat->st_dev = &devpipe;
  80201d:	c7 83 88 00 00 00 24 	movl   $0x804024,0x88(%ebx)
  802024:	40 80 00 
	return 0;
}
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	83 c4 10             	add    $0x10,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    

00802033 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802033:	55                   	push   %ebp
  802034:	89 e5                	mov    %esp,%ebp
  802036:	53                   	push   %ebx
  802037:	83 ec 14             	sub    $0x14,%esp
  80203a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80203d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802048:	e8 73 f4 ff ff       	call   8014c0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80204d:	89 1c 24             	mov    %ebx,(%esp)
  802050:	e8 5b f7 ff ff       	call   8017b0 <fd2data>
  802055:	89 44 24 04          	mov    %eax,0x4(%esp)
  802059:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802060:	e8 5b f4 ff ff       	call   8014c0 <sys_page_unmap>
}
  802065:	83 c4 14             	add    $0x14,%esp
  802068:	5b                   	pop    %ebx
  802069:	5d                   	pop    %ebp
  80206a:	c3                   	ret    

0080206b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	57                   	push   %edi
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	83 ec 2c             	sub    $0x2c,%esp
  802074:	89 c6                	mov    %eax,%esi
  802076:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802079:	a1 04 50 80 00       	mov    0x805004,%eax
  80207e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802081:	89 34 24             	mov    %esi,(%esp)
  802084:	e8 bd 04 00 00       	call   802546 <pageref>
  802089:	89 c7                	mov    %eax,%edi
  80208b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80208e:	89 04 24             	mov    %eax,(%esp)
  802091:	e8 b0 04 00 00       	call   802546 <pageref>
  802096:	39 c7                	cmp    %eax,%edi
  802098:	0f 94 c2             	sete   %dl
  80209b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80209e:	8b 0d 04 50 80 00    	mov    0x805004,%ecx
  8020a4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8020a7:	39 fb                	cmp    %edi,%ebx
  8020a9:	74 21                	je     8020cc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8020ab:	84 d2                	test   %dl,%dl
  8020ad:	74 ca                	je     802079 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8020af:	8b 51 58             	mov    0x58(%ecx),%edx
  8020b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020be:	c7 04 24 17 30 80 00 	movl   $0x803017,(%esp)
  8020c5:	e8 43 e8 ff ff       	call   80090d <cprintf>
  8020ca:	eb ad                	jmp    802079 <_pipeisclosed+0xe>
	}
}
  8020cc:	83 c4 2c             	add    $0x2c,%esp
  8020cf:	5b                   	pop    %ebx
  8020d0:	5e                   	pop    %esi
  8020d1:	5f                   	pop    %edi
  8020d2:	5d                   	pop    %ebp
  8020d3:	c3                   	ret    

008020d4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
  8020d7:	57                   	push   %edi
  8020d8:	56                   	push   %esi
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 1c             	sub    $0x1c,%esp
  8020dd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8020e0:	89 34 24             	mov    %esi,(%esp)
  8020e3:	e8 c8 f6 ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020ec:	74 61                	je     80214f <devpipe_write+0x7b>
  8020ee:	89 c3                	mov    %eax,%ebx
  8020f0:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f5:	eb 4a                	jmp    802141 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8020f7:	89 da                	mov    %ebx,%edx
  8020f9:	89 f0                	mov    %esi,%eax
  8020fb:	e8 6b ff ff ff       	call   80206b <_pipeisclosed>
  802100:	85 c0                	test   %eax,%eax
  802102:	75 54                	jne    802158 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802104:	e8 f1 f2 ff ff       	call   8013fa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802109:	8b 43 04             	mov    0x4(%ebx),%eax
  80210c:	8b 0b                	mov    (%ebx),%ecx
  80210e:	8d 51 20             	lea    0x20(%ecx),%edx
  802111:	39 d0                	cmp    %edx,%eax
  802113:	73 e2                	jae    8020f7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802118:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80211c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80211f:	99                   	cltd   
  802120:	c1 ea 1b             	shr    $0x1b,%edx
  802123:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802126:	83 e1 1f             	and    $0x1f,%ecx
  802129:	29 d1                	sub    %edx,%ecx
  80212b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80212f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802133:	83 c0 01             	add    $0x1,%eax
  802136:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802139:	83 c7 01             	add    $0x1,%edi
  80213c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80213f:	74 13                	je     802154 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802141:	8b 43 04             	mov    0x4(%ebx),%eax
  802144:	8b 0b                	mov    (%ebx),%ecx
  802146:	8d 51 20             	lea    0x20(%ecx),%edx
  802149:	39 d0                	cmp    %edx,%eax
  80214b:	73 aa                	jae    8020f7 <devpipe_write+0x23>
  80214d:	eb c6                	jmp    802115 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80214f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802154:	89 f8                	mov    %edi,%eax
  802156:	eb 05                	jmp    80215d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    

00802165 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	57                   	push   %edi
  802169:	56                   	push   %esi
  80216a:	53                   	push   %ebx
  80216b:	83 ec 1c             	sub    $0x1c,%esp
  80216e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802171:	89 3c 24             	mov    %edi,(%esp)
  802174:	e8 37 f6 ff ff       	call   8017b0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802179:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217d:	74 54                	je     8021d3 <devpipe_read+0x6e>
  80217f:	89 c3                	mov    %eax,%ebx
  802181:	be 00 00 00 00       	mov    $0x0,%esi
  802186:	eb 3e                	jmp    8021c6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802188:	89 f0                	mov    %esi,%eax
  80218a:	eb 55                	jmp    8021e1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80218c:	89 da                	mov    %ebx,%edx
  80218e:	89 f8                	mov    %edi,%eax
  802190:	e8 d6 fe ff ff       	call   80206b <_pipeisclosed>
  802195:	85 c0                	test   %eax,%eax
  802197:	75 43                	jne    8021dc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802199:	e8 5c f2 ff ff       	call   8013fa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80219e:	8b 03                	mov    (%ebx),%eax
  8021a0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021a3:	74 e7                	je     80218c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021a5:	99                   	cltd   
  8021a6:	c1 ea 1b             	shr    $0x1b,%edx
  8021a9:	01 d0                	add    %edx,%eax
  8021ab:	83 e0 1f             	and    $0x1f,%eax
  8021ae:	29 d0                	sub    %edx,%eax
  8021b0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8021b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021b8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8021bb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021be:	83 c6 01             	add    $0x1,%esi
  8021c1:	3b 75 10             	cmp    0x10(%ebp),%esi
  8021c4:	74 12                	je     8021d8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  8021c6:	8b 03                	mov    (%ebx),%eax
  8021c8:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021cb:	75 d8                	jne    8021a5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8021cd:	85 f6                	test   %esi,%esi
  8021cf:	75 b7                	jne    802188 <devpipe_read+0x23>
  8021d1:	eb b9                	jmp    80218c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021d3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8021d8:	89 f0                	mov    %esi,%eax
  8021da:	eb 05                	jmp    8021e1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8021dc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8021e1:	83 c4 1c             	add    $0x1c,%esp
  8021e4:	5b                   	pop    %ebx
  8021e5:	5e                   	pop    %esi
  8021e6:	5f                   	pop    %edi
  8021e7:	5d                   	pop    %ebp
  8021e8:	c3                   	ret    

008021e9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
  8021ec:	56                   	push   %esi
  8021ed:	53                   	push   %ebx
  8021ee:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8021f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021f4:	89 04 24             	mov    %eax,(%esp)
  8021f7:	e8 cb f5 ff ff       	call   8017c7 <fd_alloc>
  8021fc:	89 c2                	mov    %eax,%edx
  8021fe:	85 d2                	test   %edx,%edx
  802200:	0f 88 4d 01 00 00    	js     802353 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802206:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80220d:	00 
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	89 44 24 04          	mov    %eax,0x4(%esp)
  802215:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80221c:	e8 f8 f1 ff ff       	call   801419 <sys_page_alloc>
  802221:	89 c2                	mov    %eax,%edx
  802223:	85 d2                	test   %edx,%edx
  802225:	0f 88 28 01 00 00    	js     802353 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80222b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80222e:	89 04 24             	mov    %eax,(%esp)
  802231:	e8 91 f5 ff ff       	call   8017c7 <fd_alloc>
  802236:	89 c3                	mov    %eax,%ebx
  802238:	85 c0                	test   %eax,%eax
  80223a:	0f 88 fe 00 00 00    	js     80233e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802240:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802247:	00 
  802248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802256:	e8 be f1 ff ff       	call   801419 <sys_page_alloc>
  80225b:	89 c3                	mov    %eax,%ebx
  80225d:	85 c0                	test   %eax,%eax
  80225f:	0f 88 d9 00 00 00    	js     80233e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	89 04 24             	mov    %eax,(%esp)
  80226b:	e8 40 f5 ff ff       	call   8017b0 <fd2data>
  802270:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802272:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802279:	00 
  80227a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80227e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802285:	e8 8f f1 ff ff       	call   801419 <sys_page_alloc>
  80228a:	89 c3                	mov    %eax,%ebx
  80228c:	85 c0                	test   %eax,%eax
  80228e:	0f 88 97 00 00 00    	js     80232b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802297:	89 04 24             	mov    %eax,(%esp)
  80229a:	e8 11 f5 ff ff       	call   8017b0 <fd2data>
  80229f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8022a6:	00 
  8022a7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022b2:	00 
  8022b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022be:	e8 aa f1 ff ff       	call   80146d <sys_page_map>
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	85 c0                	test   %eax,%eax
  8022c7:	78 52                	js     80231b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8022c9:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8022de:	8b 15 24 40 80 00    	mov    0x804024,%edx
  8022e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8022e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 a2 f4 ff ff       	call   8017a0 <fd2num>
  8022fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802301:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	89 04 24             	mov    %eax,(%esp)
  802309:	e8 92 f4 ff ff       	call   8017a0 <fd2num>
  80230e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802311:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802314:	b8 00 00 00 00       	mov    $0x0,%eax
  802319:	eb 38                	jmp    802353 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80231b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80231f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802326:	e8 95 f1 ff ff       	call   8014c0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802339:	e8 82 f1 ff ff       	call   8014c0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	89 44 24 04          	mov    %eax,0x4(%esp)
  802345:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80234c:	e8 6f f1 ff ff       	call   8014c0 <sys_page_unmap>
  802351:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802353:	83 c4 30             	add    $0x30,%esp
  802356:	5b                   	pop    %ebx
  802357:	5e                   	pop    %esi
  802358:	5d                   	pop    %ebp
  802359:	c3                   	ret    

0080235a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
  80235d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802360:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802363:	89 44 24 04          	mov    %eax,0x4(%esp)
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	89 04 24             	mov    %eax,(%esp)
  80236d:	e8 c9 f4 ff ff       	call   80183b <fd_lookup>
  802372:	89 c2                	mov    %eax,%edx
  802374:	85 d2                	test   %edx,%edx
  802376:	78 15                	js     80238d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	89 04 24             	mov    %eax,(%esp)
  80237e:	e8 2d f4 ff ff       	call   8017b0 <fd2data>
	return _pipeisclosed(fd, p);
  802383:	89 c2                	mov    %eax,%edx
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	e8 de fc ff ff       	call   80206b <_pipeisclosed>
}
  80238d:	c9                   	leave  
  80238e:	c3                   	ret    
  80238f:	90                   	nop

00802390 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802393:	b8 00 00 00 00       	mov    $0x0,%eax
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    

0080239a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
  80239d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8023a0:	c7 44 24 04 2f 30 80 	movl   $0x80302f,0x4(%esp)
  8023a7:	00 
  8023a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023ab:	89 04 24             	mov    %eax,(%esp)
  8023ae:	e8 b8 eb ff ff       	call   800f6b <strcpy>
	return 0;
}
  8023b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	57                   	push   %edi
  8023be:	56                   	push   %esi
  8023bf:	53                   	push   %ebx
  8023c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8023c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8023ca:	74 4a                	je     802416 <devcons_write+0x5c>
  8023cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023dc:	8b 75 10             	mov    0x10(%ebp),%esi
  8023df:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8023e1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8023e4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8023e9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8023ec:	89 74 24 08          	mov    %esi,0x8(%esp)
  8023f0:	03 45 0c             	add    0xc(%ebp),%eax
  8023f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f7:	89 3c 24             	mov    %edi,(%esp)
  8023fa:	e8 67 ed ff ff       	call   801166 <memmove>
		sys_cputs(buf, m);
  8023ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  802403:	89 3c 24             	mov    %edi,(%esp)
  802406:	e8 41 ef ff ff       	call   80134c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80240b:	01 f3                	add    %esi,%ebx
  80240d:	89 d8                	mov    %ebx,%eax
  80240f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802412:	72 c8                	jb     8023dc <devcons_write+0x22>
  802414:	eb 05                	jmp    80241b <devcons_write+0x61>
  802416:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80241b:	89 d8                	mov    %ebx,%eax
  80241d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802423:	5b                   	pop    %ebx
  802424:	5e                   	pop    %esi
  802425:	5f                   	pop    %edi
  802426:	5d                   	pop    %ebp
  802427:	c3                   	ret    

00802428 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80242e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802433:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802437:	75 07                	jne    802440 <devcons_read+0x18>
  802439:	eb 28                	jmp    802463 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80243b:	e8 ba ef ff ff       	call   8013fa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802440:	e8 25 ef ff ff       	call   80136a <sys_cgetc>
  802445:	85 c0                	test   %eax,%eax
  802447:	74 f2                	je     80243b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802449:	85 c0                	test   %eax,%eax
  80244b:	78 16                	js     802463 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80244d:	83 f8 04             	cmp    $0x4,%eax
  802450:	74 0c                	je     80245e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802452:	8b 55 0c             	mov    0xc(%ebp),%edx
  802455:	88 02                	mov    %al,(%edx)
	return 1;
  802457:	b8 01 00 00 00       	mov    $0x1,%eax
  80245c:	eb 05                	jmp    802463 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80245e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
  802468:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80246b:	8b 45 08             	mov    0x8(%ebp),%eax
  80246e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802471:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802478:	00 
  802479:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80247c:	89 04 24             	mov    %eax,(%esp)
  80247f:	e8 c8 ee ff ff       	call   80134c <sys_cputs>
}
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <getchar>:

int
getchar(void)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80248c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802493:	00 
  802494:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802497:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a2:	e8 3f f6 ff ff       	call   801ae6 <read>
	if (r < 0)
  8024a7:	85 c0                	test   %eax,%eax
  8024a9:	78 0f                	js     8024ba <getchar+0x34>
		return r;
	if (r < 1)
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	7e 06                	jle    8024b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8024af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8024b3:	eb 05                	jmp    8024ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8024b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	89 04 24             	mov    %eax,(%esp)
  8024cf:	e8 67 f3 ff ff       	call   80183b <fd_lookup>
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 11                	js     8024e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8024e1:	39 10                	cmp    %edx,(%eax)
  8024e3:	0f 94 c0             	sete   %al
  8024e6:	0f b6 c0             	movzbl %al,%eax
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <opencons>:

int
opencons(void)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
  8024ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f4:	89 04 24             	mov    %eax,(%esp)
  8024f7:	e8 cb f2 ff ff       	call   8017c7 <fd_alloc>
		return r;
  8024fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 40                	js     802542 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802502:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802509:	00 
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802518:	e8 fc ee ff ff       	call   801419 <sys_page_alloc>
		return r;
  80251d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 1f                	js     802542 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802523:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802538:	89 04 24             	mov    %eax,(%esp)
  80253b:	e8 60 f2 ff ff       	call   8017a0 <fd2num>
  802540:	89 c2                	mov    %eax,%edx
}
  802542:	89 d0                	mov    %edx,%eax
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80254c:	89 d0                	mov    %edx,%eax
  80254e:	c1 e8 16             	shr    $0x16,%eax
  802551:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802558:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80255d:	f6 c1 01             	test   $0x1,%cl
  802560:	74 1d                	je     80257f <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802562:	c1 ea 0c             	shr    $0xc,%edx
  802565:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80256c:	f6 c2 01             	test   $0x1,%dl
  80256f:	74 0e                	je     80257f <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802571:	c1 ea 0c             	shr    $0xc,%edx
  802574:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80257b:	ef 
  80257c:	0f b7 c0             	movzwl %ax,%eax
}
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    
  802581:	66 90                	xchg   %ax,%ax
  802583:	66 90                	xchg   %ax,%ax
  802585:	66 90                	xchg   %ax,%ax
  802587:	66 90                	xchg   %ax,%ax
  802589:	66 90                	xchg   %ax,%ax
  80258b:	66 90                	xchg   %ax,%ax
  80258d:	66 90                	xchg   %ax,%ax
  80258f:	90                   	nop

00802590 <__udivdi3>:
  802590:	55                   	push   %ebp
  802591:	57                   	push   %edi
  802592:	56                   	push   %esi
  802593:	83 ec 0c             	sub    $0xc,%esp
  802596:	8b 44 24 28          	mov    0x28(%esp),%eax
  80259a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80259e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8025a2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025ac:	89 ea                	mov    %ebp,%edx
  8025ae:	89 0c 24             	mov    %ecx,(%esp)
  8025b1:	75 2d                	jne    8025e0 <__udivdi3+0x50>
  8025b3:	39 e9                	cmp    %ebp,%ecx
  8025b5:	77 61                	ja     802618 <__udivdi3+0x88>
  8025b7:	85 c9                	test   %ecx,%ecx
  8025b9:	89 ce                	mov    %ecx,%esi
  8025bb:	75 0b                	jne    8025c8 <__udivdi3+0x38>
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	31 d2                	xor    %edx,%edx
  8025c4:	f7 f1                	div    %ecx
  8025c6:	89 c6                	mov    %eax,%esi
  8025c8:	31 d2                	xor    %edx,%edx
  8025ca:	89 e8                	mov    %ebp,%eax
  8025cc:	f7 f6                	div    %esi
  8025ce:	89 c5                	mov    %eax,%ebp
  8025d0:	89 f8                	mov    %edi,%eax
  8025d2:	f7 f6                	div    %esi
  8025d4:	89 ea                	mov    %ebp,%edx
  8025d6:	83 c4 0c             	add    $0xc,%esp
  8025d9:	5e                   	pop    %esi
  8025da:	5f                   	pop    %edi
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	39 e8                	cmp    %ebp,%eax
  8025e2:	77 24                	ja     802608 <__udivdi3+0x78>
  8025e4:	0f bd e8             	bsr    %eax,%ebp
  8025e7:	83 f5 1f             	xor    $0x1f,%ebp
  8025ea:	75 3c                	jne    802628 <__udivdi3+0x98>
  8025ec:	8b 74 24 04          	mov    0x4(%esp),%esi
  8025f0:	39 34 24             	cmp    %esi,(%esp)
  8025f3:	0f 86 9f 00 00 00    	jbe    802698 <__udivdi3+0x108>
  8025f9:	39 d0                	cmp    %edx,%eax
  8025fb:	0f 82 97 00 00 00    	jb     802698 <__udivdi3+0x108>
  802601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802608:	31 d2                	xor    %edx,%edx
  80260a:	31 c0                	xor    %eax,%eax
  80260c:	83 c4 0c             	add    $0xc,%esp
  80260f:	5e                   	pop    %esi
  802610:	5f                   	pop    %edi
  802611:	5d                   	pop    %ebp
  802612:	c3                   	ret    
  802613:	90                   	nop
  802614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802618:	89 f8                	mov    %edi,%eax
  80261a:	f7 f1                	div    %ecx
  80261c:	31 d2                	xor    %edx,%edx
  80261e:	83 c4 0c             	add    $0xc,%esp
  802621:	5e                   	pop    %esi
  802622:	5f                   	pop    %edi
  802623:	5d                   	pop    %ebp
  802624:	c3                   	ret    
  802625:	8d 76 00             	lea    0x0(%esi),%esi
  802628:	89 e9                	mov    %ebp,%ecx
  80262a:	8b 3c 24             	mov    (%esp),%edi
  80262d:	d3 e0                	shl    %cl,%eax
  80262f:	89 c6                	mov    %eax,%esi
  802631:	b8 20 00 00 00       	mov    $0x20,%eax
  802636:	29 e8                	sub    %ebp,%eax
  802638:	89 c1                	mov    %eax,%ecx
  80263a:	d3 ef                	shr    %cl,%edi
  80263c:	89 e9                	mov    %ebp,%ecx
  80263e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802642:	8b 3c 24             	mov    (%esp),%edi
  802645:	09 74 24 08          	or     %esi,0x8(%esp)
  802649:	89 d6                	mov    %edx,%esi
  80264b:	d3 e7                	shl    %cl,%edi
  80264d:	89 c1                	mov    %eax,%ecx
  80264f:	89 3c 24             	mov    %edi,(%esp)
  802652:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802656:	d3 ee                	shr    %cl,%esi
  802658:	89 e9                	mov    %ebp,%ecx
  80265a:	d3 e2                	shl    %cl,%edx
  80265c:	89 c1                	mov    %eax,%ecx
  80265e:	d3 ef                	shr    %cl,%edi
  802660:	09 d7                	or     %edx,%edi
  802662:	89 f2                	mov    %esi,%edx
  802664:	89 f8                	mov    %edi,%eax
  802666:	f7 74 24 08          	divl   0x8(%esp)
  80266a:	89 d6                	mov    %edx,%esi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	f7 24 24             	mull   (%esp)
  802671:	39 d6                	cmp    %edx,%esi
  802673:	89 14 24             	mov    %edx,(%esp)
  802676:	72 30                	jb     8026a8 <__udivdi3+0x118>
  802678:	8b 54 24 04          	mov    0x4(%esp),%edx
  80267c:	89 e9                	mov    %ebp,%ecx
  80267e:	d3 e2                	shl    %cl,%edx
  802680:	39 c2                	cmp    %eax,%edx
  802682:	73 05                	jae    802689 <__udivdi3+0xf9>
  802684:	3b 34 24             	cmp    (%esp),%esi
  802687:	74 1f                	je     8026a8 <__udivdi3+0x118>
  802689:	89 f8                	mov    %edi,%eax
  80268b:	31 d2                	xor    %edx,%edx
  80268d:	e9 7a ff ff ff       	jmp    80260c <__udivdi3+0x7c>
  802692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802698:	31 d2                	xor    %edx,%edx
  80269a:	b8 01 00 00 00       	mov    $0x1,%eax
  80269f:	e9 68 ff ff ff       	jmp    80260c <__udivdi3+0x7c>
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	83 c4 0c             	add    $0xc,%esp
  8026b0:	5e                   	pop    %esi
  8026b1:	5f                   	pop    %edi
  8026b2:	5d                   	pop    %ebp
  8026b3:	c3                   	ret    
  8026b4:	66 90                	xchg   %ax,%ax
  8026b6:	66 90                	xchg   %ax,%ax
  8026b8:	66 90                	xchg   %ax,%ax
  8026ba:	66 90                	xchg   %ax,%ax
  8026bc:	66 90                	xchg   %ax,%ax
  8026be:	66 90                	xchg   %ax,%ax

008026c0 <__umoddi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	57                   	push   %edi
  8026c2:	56                   	push   %esi
  8026c3:	83 ec 14             	sub    $0x14,%esp
  8026c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8026ca:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8026ce:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8026d2:	89 c7                	mov    %eax,%edi
  8026d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8026dc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8026e0:	89 34 24             	mov    %esi,(%esp)
  8026e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	89 c2                	mov    %eax,%edx
  8026eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026ef:	75 17                	jne    802708 <__umoddi3+0x48>
  8026f1:	39 fe                	cmp    %edi,%esi
  8026f3:	76 4b                	jbe    802740 <__umoddi3+0x80>
  8026f5:	89 c8                	mov    %ecx,%eax
  8026f7:	89 fa                	mov    %edi,%edx
  8026f9:	f7 f6                	div    %esi
  8026fb:	89 d0                	mov    %edx,%eax
  8026fd:	31 d2                	xor    %edx,%edx
  8026ff:	83 c4 14             	add    $0x14,%esp
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    
  802706:	66 90                	xchg   %ax,%ax
  802708:	39 f8                	cmp    %edi,%eax
  80270a:	77 54                	ja     802760 <__umoddi3+0xa0>
  80270c:	0f bd e8             	bsr    %eax,%ebp
  80270f:	83 f5 1f             	xor    $0x1f,%ebp
  802712:	75 5c                	jne    802770 <__umoddi3+0xb0>
  802714:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802718:	39 3c 24             	cmp    %edi,(%esp)
  80271b:	0f 87 e7 00 00 00    	ja     802808 <__umoddi3+0x148>
  802721:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802725:	29 f1                	sub    %esi,%ecx
  802727:	19 c7                	sbb    %eax,%edi
  802729:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80272d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802731:	8b 44 24 08          	mov    0x8(%esp),%eax
  802735:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802739:	83 c4 14             	add    $0x14,%esp
  80273c:	5e                   	pop    %esi
  80273d:	5f                   	pop    %edi
  80273e:	5d                   	pop    %ebp
  80273f:	c3                   	ret    
  802740:	85 f6                	test   %esi,%esi
  802742:	89 f5                	mov    %esi,%ebp
  802744:	75 0b                	jne    802751 <__umoddi3+0x91>
  802746:	b8 01 00 00 00       	mov    $0x1,%eax
  80274b:	31 d2                	xor    %edx,%edx
  80274d:	f7 f6                	div    %esi
  80274f:	89 c5                	mov    %eax,%ebp
  802751:	8b 44 24 04          	mov    0x4(%esp),%eax
  802755:	31 d2                	xor    %edx,%edx
  802757:	f7 f5                	div    %ebp
  802759:	89 c8                	mov    %ecx,%eax
  80275b:	f7 f5                	div    %ebp
  80275d:	eb 9c                	jmp    8026fb <__umoddi3+0x3b>
  80275f:	90                   	nop
  802760:	89 c8                	mov    %ecx,%eax
  802762:	89 fa                	mov    %edi,%edx
  802764:	83 c4 14             	add    $0x14,%esp
  802767:	5e                   	pop    %esi
  802768:	5f                   	pop    %edi
  802769:	5d                   	pop    %ebp
  80276a:	c3                   	ret    
  80276b:	90                   	nop
  80276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802770:	8b 04 24             	mov    (%esp),%eax
  802773:	be 20 00 00 00       	mov    $0x20,%esi
  802778:	89 e9                	mov    %ebp,%ecx
  80277a:	29 ee                	sub    %ebp,%esi
  80277c:	d3 e2                	shl    %cl,%edx
  80277e:	89 f1                	mov    %esi,%ecx
  802780:	d3 e8                	shr    %cl,%eax
  802782:	89 e9                	mov    %ebp,%ecx
  802784:	89 44 24 04          	mov    %eax,0x4(%esp)
  802788:	8b 04 24             	mov    (%esp),%eax
  80278b:	09 54 24 04          	or     %edx,0x4(%esp)
  80278f:	89 fa                	mov    %edi,%edx
  802791:	d3 e0                	shl    %cl,%eax
  802793:	89 f1                	mov    %esi,%ecx
  802795:	89 44 24 08          	mov    %eax,0x8(%esp)
  802799:	8b 44 24 10          	mov    0x10(%esp),%eax
  80279d:	d3 ea                	shr    %cl,%edx
  80279f:	89 e9                	mov    %ebp,%ecx
  8027a1:	d3 e7                	shl    %cl,%edi
  8027a3:	89 f1                	mov    %esi,%ecx
  8027a5:	d3 e8                	shr    %cl,%eax
  8027a7:	89 e9                	mov    %ebp,%ecx
  8027a9:	09 f8                	or     %edi,%eax
  8027ab:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8027af:	f7 74 24 04          	divl   0x4(%esp)
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027b9:	89 d7                	mov    %edx,%edi
  8027bb:	f7 64 24 08          	mull   0x8(%esp)
  8027bf:	39 d7                	cmp    %edx,%edi
  8027c1:	89 c1                	mov    %eax,%ecx
  8027c3:	89 14 24             	mov    %edx,(%esp)
  8027c6:	72 2c                	jb     8027f4 <__umoddi3+0x134>
  8027c8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8027cc:	72 22                	jb     8027f0 <__umoddi3+0x130>
  8027ce:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8027d2:	29 c8                	sub    %ecx,%eax
  8027d4:	19 d7                	sbb    %edx,%edi
  8027d6:	89 e9                	mov    %ebp,%ecx
  8027d8:	89 fa                	mov    %edi,%edx
  8027da:	d3 e8                	shr    %cl,%eax
  8027dc:	89 f1                	mov    %esi,%ecx
  8027de:	d3 e2                	shl    %cl,%edx
  8027e0:	89 e9                	mov    %ebp,%ecx
  8027e2:	d3 ef                	shr    %cl,%edi
  8027e4:	09 d0                	or     %edx,%eax
  8027e6:	89 fa                	mov    %edi,%edx
  8027e8:	83 c4 14             	add    $0x14,%esp
  8027eb:	5e                   	pop    %esi
  8027ec:	5f                   	pop    %edi
  8027ed:	5d                   	pop    %ebp
  8027ee:	c3                   	ret    
  8027ef:	90                   	nop
  8027f0:	39 d7                	cmp    %edx,%edi
  8027f2:	75 da                	jne    8027ce <__umoddi3+0x10e>
  8027f4:	8b 14 24             	mov    (%esp),%edx
  8027f7:	89 c1                	mov    %eax,%ecx
  8027f9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8027fd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802801:	eb cb                	jmp    8027ce <__umoddi3+0x10e>
  802803:	90                   	nop
  802804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802808:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80280c:	0f 82 0f ff ff ff    	jb     802721 <__umoddi3+0x61>
  802812:	e9 1a ff ff ff       	jmp    802731 <__umoddi3+0x71>
