
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 8a 0c 00 00       	call   800cbb <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800039:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80003e:	ec                   	in     (%dx),%al
  80003f:	89 c3                	mov    %eax,%ebx
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  800041:	83 e0 c0             	and    $0xffffffc0,%eax
  800044:	3c 40                	cmp    $0x40,%al
  800046:	75 f6                	jne    80003e <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
		return -1;
	return 0;
  800048:	b8 00 00 00 00       	mov    $0x0,%eax
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80004d:	84 c9                	test   %cl,%cl
  80004f:	74 0b                	je     80005c <ide_wait_ready+0x29>
  800051:	f6 c3 21             	test   $0x21,%bl
  800054:	0f 95 c0             	setne  %al
  800057:	0f b6 c0             	movzbl %al,%eax
  80005a:	f7 d8                	neg    %eax
		return -1;
	return 0;
}
  80005c:	5b                   	pop    %ebx
  80005d:	5d                   	pop    %ebp
  80005e:	c3                   	ret    

0080005f <ide_probe_disk1>:

bool
ide_probe_disk1(void)
{
  80005f:	55                   	push   %ebp
  800060:	89 e5                	mov    %esp,%ebp
  800062:	53                   	push   %ebx
  800063:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  800066:	b8 00 00 00 00       	mov    $0x0,%eax
  80006b:	e8 c3 ff ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800070:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80007a:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  80007b:	b2 f7                	mov    $0xf7,%dl
  80007d:	ec                   	in     (%dx),%al
	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  80007e:	a8 a1                	test   $0xa1,%al
  800080:	74 19                	je     80009b <ide_probe_disk1+0x3c>
	     x++)
  800082:	b9 01 00 00 00       	mov    $0x1,%ecx
  800087:	eb 0b                	jmp    800094 <ide_probe_disk1+0x35>
  800089:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80008c:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800092:	74 0c                	je     8000a0 <ide_probe_disk1+0x41>
  800094:	ec                   	in     (%dx),%al
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0;
  800095:	a8 a1                	test   $0xa1,%al
  800097:	75 f0                	jne    800089 <ide_probe_disk1+0x2a>
  800099:	eb 05                	jmp    8000a0 <ide_probe_disk1+0x41>

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0;
  80009b:	b9 00 00 00 00       	mov    $0x0,%ecx
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000a0:	ba f6 01 00 00       	mov    $0x1f6,%edx
  8000a5:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  8000aa:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  8000ab:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  8000b1:	0f 9e c3             	setle  %bl
  8000b4:	0f b6 c3             	movzbl %bl,%eax
  8000b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bb:	c7 04 24 40 2e 80 00 	movl   $0x802e40,(%esp)
  8000c2:	e8 7e 0d 00 00       	call   800e45 <cprintf>
	return (x < 1000);
}
  8000c7:	89 d8                	mov    %ebx,%eax
  8000c9:	83 c4 14             	add    $0x14,%esp
  8000cc:	5b                   	pop    %ebx
  8000cd:	5d                   	pop    %ebp
  8000ce:	c3                   	ret    

008000cf <ide_set_disk>:

void
ide_set_disk(int d)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	83 ec 18             	sub    $0x18,%esp
  8000d5:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8000d8:	83 f8 01             	cmp    $0x1,%eax
  8000db:	76 1c                	jbe    8000f9 <ide_set_disk+0x2a>
		panic("bad disk number");
  8000dd:	c7 44 24 08 57 2e 80 	movl   $0x802e57,0x8(%esp)
  8000e4:	00 
  8000e5:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000ec:	00 
  8000ed:	c7 04 24 67 2e 80 00 	movl   $0x802e67,(%esp)
  8000f4:	e8 53 0c 00 00       	call   800d4c <_panic>
	diskno = d;
  8000f9:	a3 00 40 80 00       	mov    %eax,0x804000
}
  8000fe:	c9                   	leave  
  8000ff:	c3                   	ret    

00800100 <ide_read>:

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800100:	55                   	push   %ebp
  800101:	89 e5                	mov    %esp,%ebp
  800103:	57                   	push   %edi
  800104:	56                   	push   %esi
  800105:	53                   	push   %ebx
  800106:	83 ec 1c             	sub    $0x1c,%esp
  800109:	8b 7d 08             	mov    0x8(%ebp),%edi
  80010c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80010f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  800112:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  800118:	76 24                	jbe    80013e <ide_read+0x3e>
  80011a:	c7 44 24 0c 70 2e 80 	movl   $0x802e70,0xc(%esp)
  800121:	00 
  800122:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  800129:	00 
  80012a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 67 2e 80 00 	movl   $0x802e67,(%esp)
  800139:	e8 0e 0c 00 00       	call   800d4c <_panic>

	ide_wait_ready(0);
  80013e:	b8 00 00 00 00       	mov    $0x0,%eax
  800143:	e8 eb fe ff ff       	call   800033 <ide_wait_ready>
  800148:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80014d:	89 d8                	mov    %ebx,%eax
  80014f:	ee                   	out    %al,(%dx)
  800150:	b2 f3                	mov    $0xf3,%dl
  800152:	89 f8                	mov    %edi,%eax
  800154:	ee                   	out    %al,(%dx)
  800155:	89 f8                	mov    %edi,%eax
  800157:	0f b6 c4             	movzbl %ah,%eax
  80015a:	b2 f4                	mov    $0xf4,%dl
  80015c:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  80015d:	89 f8                	mov    %edi,%eax
  80015f:	c1 e8 10             	shr    $0x10,%eax
  800162:	b2 f5                	mov    $0xf5,%dl
  800164:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  800165:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
  80016c:	83 e0 01             	and    $0x1,%eax
  80016f:	c1 e0 04             	shl    $0x4,%eax
  800172:	83 c8 e0             	or     $0xffffffe0,%eax
  800175:	c1 ef 18             	shr    $0x18,%edi
  800178:	83 e7 0f             	and    $0xf,%edi
  80017b:	09 f8                	or     %edi,%eax
  80017d:	b2 f6                	mov    $0xf6,%dl
  80017f:	ee                   	out    %al,(%dx)
  800180:	b2 f7                	mov    $0xf7,%dl
  800182:	b8 20 00 00 00       	mov    $0x20,%eax
  800187:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  800188:	85 db                	test   %ebx,%ebx
  80018a:	74 2a                	je     8001b6 <ide_read+0xb6>
		if ((r = ide_wait_ready(1)) < 0)
  80018c:	b8 01 00 00 00       	mov    $0x1,%eax
  800191:	e8 9d fe ff ff       	call   800033 <ide_wait_ready>
  800196:	85 c0                	test   %eax,%eax
  800198:	78 28                	js     8001c2 <ide_read+0xc2>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  80019a:	89 f7                	mov    %esi,%edi
  80019c:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001a1:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001a6:	fc                   	cld    
  8001a7:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001a9:	81 c6 00 02 00 00    	add    $0x200,%esi
  8001af:	83 eb 01             	sub    $0x1,%ebx
  8001b2:	75 d8                	jne    80018c <ide_read+0x8c>
  8001b4:	eb 07                	jmp    8001bd <ide_read+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}

	return 0;
  8001b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001bb:	eb 05                	jmp    8001c2 <ide_read+0xc2>
  8001bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8001c2:	83 c4 1c             	add    $0x1c,%esp
  8001c5:	5b                   	pop    %ebx
  8001c6:	5e                   	pop    %esi
  8001c7:	5f                   	pop    %edi
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <ide_write>:

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 1c             	sub    $0x1c,%esp
  8001d3:	8b 75 08             	mov    0x8(%ebp),%esi
  8001d6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8001d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int r;

	assert(nsecs <= 256);
  8001dc:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
  8001e2:	76 24                	jbe    800208 <ide_write+0x3e>
  8001e4:	c7 44 24 0c 70 2e 80 	movl   $0x802e70,0xc(%esp)
  8001eb:	00 
  8001ec:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  8001f3:	00 
  8001f4:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8001fb:	00 
  8001fc:	c7 04 24 67 2e 80 00 	movl   $0x802e67,(%esp)
  800203:	e8 44 0b 00 00       	call   800d4c <_panic>

	ide_wait_ready(0);
  800208:	b8 00 00 00 00       	mov    $0x0,%eax
  80020d:	e8 21 fe ff ff       	call   800033 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800212:	ba f2 01 00 00       	mov    $0x1f2,%edx
  800217:	89 d8                	mov    %ebx,%eax
  800219:	ee                   	out    %al,(%dx)
  80021a:	b2 f3                	mov    $0xf3,%dl
  80021c:	89 f0                	mov    %esi,%eax
  80021e:	ee                   	out    %al,(%dx)
  80021f:	89 f0                	mov    %esi,%eax
  800221:	0f b6 c4             	movzbl %ah,%eax
  800224:	b2 f4                	mov    $0xf4,%dl
  800226:	ee                   	out    %al,(%dx)

	outb(0x1F2, nsecs);
	outb(0x1F3, secno & 0xFF);
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
  800227:	89 f0                	mov    %esi,%eax
  800229:	c1 e8 10             	shr    $0x10,%eax
  80022c:	b2 f5                	mov    $0xf5,%dl
  80022e:	ee                   	out    %al,(%dx)
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
  80022f:	0f b6 05 00 40 80 00 	movzbl 0x804000,%eax
  800236:	83 e0 01             	and    $0x1,%eax
  800239:	c1 e0 04             	shl    $0x4,%eax
  80023c:	83 c8 e0             	or     $0xffffffe0,%eax
  80023f:	c1 ee 18             	shr    $0x18,%esi
  800242:	83 e6 0f             	and    $0xf,%esi
  800245:	09 f0                	or     %esi,%eax
  800247:	b2 f6                	mov    $0xf6,%dl
  800249:	ee                   	out    %al,(%dx)
  80024a:	b2 f7                	mov    $0xf7,%dl
  80024c:	b8 30 00 00 00       	mov    $0x30,%eax
  800251:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800252:	85 db                	test   %ebx,%ebx
  800254:	74 2a                	je     800280 <ide_write+0xb6>
		if ((r = ide_wait_ready(1)) < 0)
  800256:	b8 01 00 00 00       	mov    $0x1,%eax
  80025b:	e8 d3 fd ff ff       	call   800033 <ide_wait_ready>
  800260:	85 c0                	test   %eax,%eax
  800262:	78 28                	js     80028c <ide_write+0xc2>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800264:	89 fe                	mov    %edi,%esi
  800266:	b9 80 00 00 00       	mov    $0x80,%ecx
  80026b:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800270:	fc                   	cld    
  800271:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800273:	81 c7 00 02 00 00    	add    $0x200,%edi
  800279:	83 eb 01             	sub    $0x1,%ebx
  80027c:	75 d8                	jne    800256 <ide_write+0x8c>
  80027e:	eb 07                	jmp    800287 <ide_write+0xbd>
		if ((r = ide_wait_ready(1)) < 0)
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
  800280:	b8 00 00 00 00       	mov    $0x0,%eax
  800285:	eb 05                	jmp    80028c <ide_write+0xc2>
  800287:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80028c:	83 c4 1c             	add    $0x1c,%esp
  80028f:	5b                   	pop    %ebx
  800290:	5e                   	pop    %esi
  800291:	5f                   	pop    %edi
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	53                   	push   %ebx
  800298:	83 ec 24             	sub    $0x24,%esp
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  80029e:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8002a0:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  8002a6:	89 c1                	mov    %eax,%ecx
  8002a8:	c1 e9 0c             	shr    $0xc,%ecx
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE)) {
  8002ab:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8002b0:	76 2e                	jbe    8002e0 <bc_pgfault+0x4c>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002b2:	8b 42 04             	mov    0x4(%edx),%eax
  8002b5:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002b9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  8002bd:	8b 42 28             	mov    0x28(%edx),%eax
  8002c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c4:	c7 44 24 08 94 2e 80 	movl   $0x802e94,0x8(%esp)
  8002cb:	00 
  8002cc:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  8002d3:	00 
  8002d4:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  8002db:	e8 6c 0a 00 00       	call   800d4c <_panic>
		      utf->utf_eip, addr, utf->utf_err);
	}

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002e0:	a1 08 90 80 00       	mov    0x809008,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 25                	je     80030e <bc_pgfault+0x7a>
  8002e9:	3b 48 04             	cmp    0x4(%eax),%ecx
  8002ec:	72 20                	jb     80030e <bc_pgfault+0x7a>
		panic("reading non-existent block %08x\n", blockno);
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	c7 44 24 08 c4 2e 80 	movl   $0x802ec4,0x8(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800301:	00 
  800302:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  800309:	e8 3e 0a 00 00       	call   800d4c <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: you code here:
	// allocate a page in the fault addr
	void *round_addr = ROUNDDOWN(addr, PGSIZE);
  80030e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	int err_code;
	if ((err_code = sys_page_alloc(0, round_addr, PTE_P | PTE_U | PTE_W)) < 0) {
  800314:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80031b:	00 
  80031c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800320:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800327:	e8 1d 16 00 00       	call   801949 <sys_page_alloc>
  80032c:	85 c0                	test   %eax,%eax
  80032e:	79 20                	jns    800350 <bc_pgfault+0xbc>
		panic("bc_pgfault:sys_page_alloc:%e", err_code);
  800330:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800334:	c7 44 24 08 12 2f 80 	movl   $0x802f12,0x8(%esp)
  80033b:	00 
  80033c:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  800343:	00 
  800344:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  80034b:	e8 fc 09 00 00       	call   800d4c <_panic>
	}
	// load page from disk to the new allocated memory page
	uint32_t secno = ((uint32_t)round_addr - DISKMAP) / SECTSIZE;
	if ((err_code = ide_read(secno, round_addr, BLKSECTS)) < 0) {
  800350:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800357:	00 
  800358:	89 5c 24 04          	mov    %ebx,0x4(%esp)
	int err_code;
	if ((err_code = sys_page_alloc(0, round_addr, PTE_P | PTE_U | PTE_W)) < 0) {
		panic("bc_pgfault:sys_page_alloc:%e", err_code);
	}
	// load page from disk to the new allocated memory page
	uint32_t secno = ((uint32_t)round_addr - DISKMAP) / SECTSIZE;
  80035c:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  800362:	c1 eb 09             	shr    $0x9,%ebx
	if ((err_code = ide_read(secno, round_addr, BLKSECTS)) < 0) {
  800365:	89 1c 24             	mov    %ebx,(%esp)
  800368:	e8 93 fd ff ff       	call   800100 <ide_read>
  80036d:	85 c0                	test   %eax,%eax
  80036f:	79 1c                	jns    80038d <bc_pgfault+0xf9>
		panic("bc_pgfault:ide_read");
  800371:	c7 44 24 08 2f 2f 80 	movl   $0x802f2f,0x8(%esp)
  800378:	00 
  800379:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800380:	00 
  800381:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  800388:	e8 bf 09 00 00       	call   800d4c <_panic>
	}
}
  80038d:	83 c4 24             	add    $0x24,%esp
  800390:	5b                   	pop    %ebx
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 18             	sub    $0x18,%esp
  800399:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  80039c:	85 c0                	test   %eax,%eax
  80039e:	74 0f                	je     8003af <diskaddr+0x1c>
  8003a0:	8b 15 08 90 80 00    	mov    0x809008,%edx
  8003a6:	85 d2                	test   %edx,%edx
  8003a8:	74 25                	je     8003cf <diskaddr+0x3c>
  8003aa:	3b 42 04             	cmp    0x4(%edx),%eax
  8003ad:	72 20                	jb     8003cf <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  8003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003b3:	c7 44 24 08 e8 2e 80 	movl   $0x802ee8,0x8(%esp)
  8003ba:	00 
  8003bb:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  8003ca:	e8 7d 09 00 00       	call   800d4c <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  8003cf:	05 00 00 01 00       	add    $0x10000,%eax
  8003d4:	c1 e0 0c             	shl    $0xc,%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <bc_init>:
}


void
bc_init(void)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8003e2:	c7 04 24 94 02 80 00 	movl   $0x800294,(%esp)
  8003e9:	e8 c3 17 00 00       	call   801bb1 <set_pgfault_handler>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8003ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003f5:	e8 99 ff ff ff       	call   800393 <diskaddr>
  8003fa:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800401:	00 
  800402:	89 44 24 04          	mov    %eax,0x4(%esp)
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	89 04 24             	mov    %eax,(%esp)
  80040f:	e8 82 12 00 00       	call   801696 <memmove>
}
  800414:	c9                   	leave  
  800415:	c3                   	ret    
  800416:	66 90                	xchg   %ax,%ax
  800418:	66 90                	xchg   %ax,%ax
  80041a:	66 90                	xchg   %ax,%ax
  80041c:	66 90                	xchg   %ax,%ax
  80041e:	66 90                	xchg   %ax,%ax

00800420 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  800426:	a1 08 90 80 00       	mov    0x809008,%eax
  80042b:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800431:	74 1c                	je     80044f <check_super+0x2f>
		panic("bad file system magic number");
  800433:	c7 44 24 08 43 2f 80 	movl   $0x802f43,0x8(%esp)
  80043a:	00 
  80043b:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800442:	00 
  800443:	c7 04 24 60 2f 80 00 	movl   $0x802f60,(%esp)
  80044a:	e8 fd 08 00 00       	call   800d4c <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80044f:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800456:	76 1c                	jbe    800474 <check_super+0x54>
		panic("file system is too large");
  800458:	c7 44 24 08 68 2f 80 	movl   $0x802f68,0x8(%esp)
  80045f:	00 
  800460:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800467:	00 
  800468:	c7 04 24 60 2f 80 00 	movl   $0x802f60,(%esp)
  80046f:	e8 d8 08 00 00       	call   800d4c <_panic>

	cprintf("superblock is good\n");
  800474:	c7 04 24 81 2f 80 00 	movl   $0x802f81,(%esp)
  80047b:	e8 c5 09 00 00       	call   800e45 <cprintf>
}
  800480:	c9                   	leave  
  800481:	c3                   	ret    

00800482 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800488:	e8 d2 fb ff ff       	call   80005f <ide_probe_disk1>
  80048d:	84 c0                	test   %al,%al
  80048f:	74 0e                	je     80049f <fs_init+0x1d>
		ide_set_disk(1);
  800491:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800498:	e8 32 fc ff ff       	call   8000cf <ide_set_disk>
  80049d:	eb 0c                	jmp    8004ab <fs_init+0x29>
	else
		ide_set_disk(0);
  80049f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004a6:	e8 24 fc ff ff       	call   8000cf <ide_set_disk>

	bc_init();
  8004ab:	e8 29 ff ff ff       	call   8003d9 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8004b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004b7:	e8 d7 fe ff ff       	call   800393 <diskaddr>
  8004bc:	a3 08 90 80 00       	mov    %eax,0x809008
	check_super();
  8004c1:	e8 5a ff ff ff       	call   800420 <check_super>
}
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	53                   	push   %ebx
  8004cc:	83 ec 14             	sub    $0x14,%esp
  8004cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  8004d2:	83 fb 09             	cmp    $0x9,%ebx
  8004d5:	77 0c                	ja     8004e3 <file_get_block+0x1b>
		ptr = &f->f_direct[filebno];
  8004d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004da:	8d 84 98 88 00 00 00 	lea    0x88(%eax,%ebx,4),%eax
  8004e1:	eb 21                	jmp    800504 <file_get_block+0x3c>
	else if (filebno < NDIRECT + NINDIRECT) {
  8004e3:	81 fb 09 04 00 00    	cmp    $0x409,%ebx
  8004e9:	77 3a                	ja     800525 <file_get_block+0x5d>
		if (f->f_indirect == 0) {
  8004eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ee:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  8004f4:	85 c0                	test   %eax,%eax
  8004f6:	74 34                	je     80052c <file_get_block+0x64>
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  8004f8:	89 04 24             	mov    %eax,(%esp)
  8004fb:	e8 93 fe ff ff       	call   800393 <diskaddr>
  800500:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
  800504:	8b 00                	mov    (%eax),%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 14                	je     80051e <file_get_block+0x56>
		return -E_NOT_FOUND;
	}
	*blk = diskaddr(*ptr);
  80050a:	89 04 24             	mov    %eax,(%esp)
  80050d:	e8 81 fe ff ff       	call   800393 <diskaddr>
  800512:	8b 55 10             	mov    0x10(%ebp),%edx
  800515:	89 02                	mov    %eax,(%edx)
	return 0;
  800517:	b8 00 00 00 00       	mov    $0x0,%eax
  80051c:	eb 13                	jmp    800531 <file_get_block+0x69>
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
		return -E_NOT_FOUND;
  80051e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800523:	eb 0c                	jmp    800531 <file_get_block+0x69>
		if (f->f_indirect == 0) {
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	} else
		return -E_INVAL;
  800525:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80052a:	eb 05                	jmp    800531 <file_get_block+0x69>

	if (filebno < NDIRECT)
		ptr = &f->f_direct[filebno];
	else if (filebno < NDIRECT + NINDIRECT) {
		if (f->f_indirect == 0) {
			return -E_NOT_FOUND;
  80052c:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
	if (*ptr == 0) {
		return -E_NOT_FOUND;
	}
	*blk = diskaddr(*ptr);
	return 0;
}
  800531:	83 c4 14             	add    $0x14,%esp
  800534:	5b                   	pop    %ebx
  800535:	5d                   	pop    %ebp
  800536:	c3                   	ret    

00800537 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800537:	55                   	push   %ebp
  800538:	89 e5                	mov    %esp,%ebp
  80053a:	57                   	push   %edi
  80053b:	56                   	push   %esi
  80053c:	53                   	push   %ebx
  80053d:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800543:	8b 55 08             	mov    0x8(%ebp),%edx

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800546:	80 3a 2f             	cmpb   $0x2f,(%edx)
  800549:	75 08                	jne    800553 <file_open+0x1c>
		p++;
  80054b:	83 c2 01             	add    $0x1,%edx

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80054e:	80 3a 2f             	cmpb   $0x2f,(%edx)
  800551:	74 f8                	je     80054b <file_open+0x14>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800553:	a1 08 90 80 00       	mov    0x809008,%eax
  800558:	83 c0 08             	add    $0x8,%eax
  80055b:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  800561:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
		*pdir = 0;
	*pf = 0;
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800571:	e9 45 01 00 00       	jmp    8006bb <file_open+0x184>
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800576:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800579:	0f b6 07             	movzbl (%edi),%eax
  80057c:	84 c0                	test   %al,%al
  80057e:	74 08                	je     800588 <file_open+0x51>
  800580:	3c 2f                	cmp    $0x2f,%al
  800582:	75 f2                	jne    800576 <file_open+0x3f>
  800584:	eb 02                	jmp    800588 <file_open+0x51>
  800586:	89 d7                	mov    %edx,%edi
			path++;
		if (path - p >= MAXNAMELEN)
  800588:	89 fb                	mov    %edi,%ebx
  80058a:	29 d3                	sub    %edx,%ebx
  80058c:	83 fb 7f             	cmp    $0x7f,%ebx
  80058f:	0f 8f 4e 01 00 00    	jg     8006e3 <file_open+0x1ac>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800595:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800599:	89 54 24 04          	mov    %edx,0x4(%esp)
  80059d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8005a3:	89 04 24             	mov    %eax,(%esp)
  8005a6:	e8 eb 10 00 00       	call   801696 <memmove>
		name[path - p] = '\0';
  8005ab:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  8005b2:	00 

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8005b3:	80 3f 2f             	cmpb   $0x2f,(%edi)
  8005b6:	75 08                	jne    8005c0 <file_open+0x89>
		p++;
  8005b8:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8005bb:	80 3f 2f             	cmpb   $0x2f,(%edi)
  8005be:	74 f8                	je     8005b8 <file_open+0x81>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  8005c0:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005c6:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8005cd:	0f 85 17 01 00 00    	jne    8006ea <file_open+0x1b3>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  8005d3:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8005d9:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8005de:	74 24                	je     800604 <file_open+0xcd>
  8005e0:	c7 44 24 0c 95 2f 80 	movl   $0x802f95,0xc(%esp)
  8005e7:	00 
  8005e8:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  8005f7:	00 
  8005f8:	c7 04 24 60 2f 80 00 	movl   $0x802f60,(%esp)
  8005ff:	e8 48 07 00 00       	call   800d4c <_panic>
	nblock = dir->f_size / BLKSIZE;
  800604:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80060a:	85 c0                	test   %eax,%eax
  80060c:	0f 48 c2             	cmovs  %edx,%eax
  80060f:	c1 f8 0c             	sar    $0xc,%eax
  800612:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800618:	85 c0                	test   %eax,%eax
  80061a:	0f 84 81 00 00 00    	je     8006a1 <file_open+0x16a>
  800620:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  800627:	00 00 00 
  80062a:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800630:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800636:	89 44 24 08          	mov    %eax,0x8(%esp)
  80063a:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800640:	89 44 24 04          	mov    %eax,0x4(%esp)
  800644:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  80064a:	89 04 24             	mov    %eax,(%esp)
  80064d:	e8 76 fe ff ff       	call   8004c8 <file_get_block>
  800652:	85 c0                	test   %eax,%eax
  800654:	0f 88 a7 00 00 00    	js     800701 <file_open+0x1ca>
  80065a:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  800660:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800665:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  80066b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80066f:	89 1c 24             	mov    %ebx,(%esp)
  800672:	e8 ee 0e 00 00       	call   801565 <strcmp>
  800677:	85 c0                	test   %eax,%eax
  800679:	74 76                	je     8006f1 <file_open+0x1ba>
  80067b:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800681:	83 ee 01             	sub    $0x1,%esi
  800684:	75 df                	jne    800665 <file_open+0x12e>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800686:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  80068d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800693:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800699:	75 95                	jne    800630 <file_open+0xf9>
  80069b:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  8006a1:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  8006a6:	80 3f 00             	cmpb   $0x0,(%edi)
  8006a9:	75 61                	jne    80070c <file_open+0x1d5>
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  8006b4:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8006b9:	eb 51                	jmp    80070c <file_open+0x1d5>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8006bb:	0f b6 02             	movzbl (%edx),%eax
  8006be:	84 c0                	test   %al,%al
  8006c0:	74 0f                	je     8006d1 <file_open+0x19a>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  8006c2:	3c 2f                	cmp    $0x2f,%al
  8006c4:	0f 84 bc fe ff ff    	je     800586 <file_open+0x4f>
  8006ca:	89 d7                	mov    %edx,%edi
  8006cc:	e9 a5 fe ff ff       	jmp    800576 <file_open+0x3f>
		}
	}

	if (pdir)
		*pdir = dir;
	*pf = f;
  8006d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d4:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  8006da:	89 08                	mov    %ecx,(%eax)
	return 0;
  8006dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8006e1:	eb 29                	jmp    80070c <file_open+0x1d5>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  8006e3:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8006e8:	eb 22                	jmp    80070c <file_open+0x1d5>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  8006ea:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8006ef:	eb 1b                	jmp    80070c <file_open+0x1d5>
  8006f1:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  8006f7:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  8006fd:	89 fa                	mov    %edi,%edx
  8006ff:	eb ba                	jmp    8006bb <file_open+0x184>
  800701:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800707:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80070a:	74 95                	je     8006a1 <file_open+0x16a>
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
	return walk_path(path, 0, pf, 0);
}
  80070c:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  800712:	5b                   	pop    %ebx
  800713:	5e                   	pop    %esi
  800714:	5f                   	pop    %edi
  800715:	5d                   	pop    %ebp
  800716:	c3                   	ret    

00800717 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	57                   	push   %edi
  80071b:	56                   	push   %esi
  80071c:	53                   	push   %ebx
  80071d:	83 ec 3c             	sub    $0x3c,%esp
  800720:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800723:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  80072f:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800734:	39 da                	cmp    %ebx,%edx
  800736:	0f 8e 86 00 00 00    	jle    8007c2 <file_read+0xab>
		return 0;

	count = MIN(count, f->f_size - offset);
  80073c:	29 da                	sub    %ebx,%edx
  80073e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800741:	0f 47 55 10          	cmova  0x10(%ebp),%edx
  800745:	89 55 d0             	mov    %edx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800748:	89 de                	mov    %ebx,%esi
  80074a:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  80074d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800750:	39 c3                	cmp    %eax,%ebx
  800752:	73 6b                	jae    8007bf <file_read+0xa8>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800754:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800757:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075b:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800761:	85 db                	test   %ebx,%ebx
  800763:	0f 49 c3             	cmovns %ebx,%eax
  800766:	c1 f8 0c             	sar    $0xc,%eax
  800769:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	89 04 24             	mov    %eax,(%esp)
  800773:	e8 50 fd ff ff       	call   8004c8 <file_get_block>
  800778:	85 c0                	test   %eax,%eax
  80077a:	78 46                	js     8007c2 <file_read+0xab>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  80077c:	89 da                	mov    %ebx,%edx
  80077e:	c1 fa 1f             	sar    $0x1f,%edx
  800781:	c1 ea 14             	shr    $0x14,%edx
  800784:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800787:	25 ff 0f 00 00       	and    $0xfff,%eax
  80078c:	29 d0                	sub    %edx,%eax
  80078e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800793:	29 c1                	sub    %eax,%ecx
  800795:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800798:	29 f2                	sub    %esi,%edx
  80079a:	39 d1                	cmp    %edx,%ecx
  80079c:	89 d6                	mov    %edx,%esi
  80079e:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  8007a1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8007a5:	03 45 e4             	add    -0x1c(%ebp),%eax
  8007a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ac:	89 3c 24             	mov    %edi,(%esp)
  8007af:	e8 e2 0e 00 00       	call   801696 <memmove>
		pos += bn;
  8007b4:	01 f3                	add    %esi,%ebx
		buf += bn;
  8007b6:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  8007b8:	89 de                	mov    %ebx,%esi
  8007ba:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  8007bd:	72 95                	jb     800754 <file_read+0x3d>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  8007bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  8007c2:	83 c4 3c             	add    $0x3c,%esp
  8007c5:	5b                   	pop    %ebx
  8007c6:	5e                   	pop    %esi
  8007c7:	5f                   	pop    %edi
  8007c8:	5d                   	pop    %ebp
  8007c9:	c3                   	ret    
  8007ca:	66 90                	xchg   %ax,%ax
  8007cc:	66 90                	xchg   %ax,%ax
  8007ce:	66 90                	xchg   %ax,%ax

008007d0 <serve_flush>:


// Our read-only file system do nothing for flush
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
	return 0;
}
  8007d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d8:	5d                   	pop    %ebp
  8007d9:	c3                   	ret    

008007da <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  8007da:	55                   	push   %ebp
  8007db:	89 e5                	mov    %esp,%ebp
  8007dd:	ba 40 40 80 00       	mov    $0x804040,%edx
	int i;
	uintptr_t va = FILEVA;
  8007e2:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  8007e7:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  8007ec:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8007ee:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8007f1:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  8007f7:	83 c0 01             	add    $0x1,%eax
  8007fa:	83 c2 10             	add    $0x10,%edx
  8007fd:	3d 00 04 00 00       	cmp    $0x400,%eax
  800802:	75 e8                	jne    8007ec <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	56                   	push   %esi
  80080a:	53                   	push   %ebx
  80080b:	83 ec 10             	sub    $0x10,%esp
  80080e:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800811:	bb 00 00 00 00       	mov    $0x0,%ebx
  800816:	89 d8                	mov    %ebx,%eax
  800818:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  80081b:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  800821:	89 04 24             	mov    %eax,(%esp)
  800824:	e8 d3 1d 00 00       	call   8025fc <pageref>
  800829:	85 c0                	test   %eax,%eax
  80082b:	74 07                	je     800834 <openfile_alloc+0x2e>
  80082d:	83 f8 01             	cmp    $0x1,%eax
  800830:	74 2b                	je     80085d <openfile_alloc+0x57>
  800832:	eb 62                	jmp    800896 <openfile_alloc+0x90>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  800834:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80083b:	00 
  80083c:	89 d8                	mov    %ebx,%eax
  80083e:	c1 e0 04             	shl    $0x4,%eax
  800841:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  800847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800852:	e8 f2 10 00 00       	call   801949 <sys_page_alloc>
  800857:	89 c2                	mov    %eax,%edx
  800859:	85 d2                	test   %edx,%edx
  80085b:	78 4d                	js     8008aa <openfile_alloc+0xa4>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  80085d:	c1 e3 04             	shl    $0x4,%ebx
  800860:	8d 83 40 40 80 00    	lea    0x804040(%ebx),%eax
  800866:	81 83 40 40 80 00 00 	addl   $0x400,0x804040(%ebx)
  80086d:	04 00 00 
			*o = &opentab[i];
  800870:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  800872:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800879:	00 
  80087a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800881:	00 
  800882:	8b 83 4c 40 80 00    	mov    0x80404c(%ebx),%eax
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	e8 b9 0d 00 00       	call   801649 <memset>
			return (*o)->o_fileid;
  800890:	8b 06                	mov    (%esi),%eax
  800892:	8b 00                	mov    (%eax),%eax
  800894:	eb 14                	jmp    8008aa <openfile_alloc+0xa4>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800896:	83 c3 01             	add    $0x1,%ebx
  800899:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80089f:	0f 85 71 ff ff ff    	jne    800816 <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  8008a5:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8008aa:	83 c4 10             	add    $0x10,%esp
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	57                   	push   %edi
  8008b5:	56                   	push   %esi
  8008b6:	53                   	push   %ebx
  8008b7:	83 ec 1c             	sub    $0x1c,%esp
  8008ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8008bd:	89 de                	mov    %ebx,%esi
  8008bf:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  8008c5:	c1 e6 04             	shl    $0x4,%esi
  8008c8:	8d be 40 40 80 00    	lea    0x804040(%esi),%edi
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  8008ce:	8b 86 4c 40 80 00    	mov    0x80404c(%esi),%eax
  8008d4:	89 04 24             	mov    %eax,(%esp)
  8008d7:	e8 20 1d 00 00       	call   8025fc <pageref>
  8008dc:	83 f8 01             	cmp    $0x1,%eax
  8008df:	74 14                	je     8008f5 <openfile_lookup+0x44>
  8008e1:	39 9e 40 40 80 00    	cmp    %ebx,0x804040(%esi)
  8008e7:	75 13                	jne    8008fc <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  8008e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ec:	89 38                	mov    %edi,(%eax)
	return 0;
  8008ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f3:	eb 0c                	jmp    800901 <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
		return -E_INVAL;
  8008f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fa:	eb 05                	jmp    800901 <openfile_lookup+0x50>
  8008fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  800901:	83 c4 1c             	add    $0x1c,%esp
  800904:	5b                   	pop    %ebx
  800905:	5e                   	pop    %esi
  800906:	5f                   	pop    %edi
  800907:	5d                   	pop    %ebp
  800908:	c3                   	ret    

00800909 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	56                   	push   %esi
  80090d:	53                   	push   %ebx
  80090e:	83 ec 20             	sub    $0x20,%esp
  800911:	8b 75 08             	mov    0x8(%ebp),%esi
  800914:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fsreq_read *req = &ipc->read;
	struct Fsret_read *ret = &ipc->readRet;

	if (debug)
		cprintf("serve_read %08x %08x %08x\n", envid, req->req_fileid, req->req_n);
  800917:	8b 43 04             	mov    0x4(%ebx),%eax
  80091a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091e:	8b 03                	mov    (%ebx),%eax
  800920:	89 44 24 08          	mov    %eax,0x8(%esp)
  800924:	89 74 24 04          	mov    %esi,0x4(%esp)
  800928:	c7 04 24 b2 2f 80 00 	movl   $0x802fb2,(%esp)
  80092f:	e8 11 05 00 00       	call   800e45 <cprintf>
	// so filling in ret will overwrite req.
	//
	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800934:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800937:	89 44 24 08          	mov    %eax,0x8(%esp)
  80093b:	8b 03                	mov    (%ebx),%eax
  80093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800941:	89 34 24             	mov    %esi,(%esp)
  800944:	e8 68 ff ff ff       	call   8008b1 <openfile_lookup>
  800949:	89 c2                	mov    %eax,%edx
  80094b:	85 d2                	test   %edx,%edx
  80094d:	78 3d                	js     80098c <serve_read+0x83>
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  80094f:	8b 45 f4             	mov    -0xc(%ebp),%eax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  800952:	8b 50 0c             	mov    0xc(%eax),%edx
  800955:	8b 52 04             	mov    0x4(%edx),%edx
  800958:	89 54 24 0c          	mov    %edx,0xc(%esp)
			   MIN(req->req_n, sizeof ret->ret_buf),
  80095c:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  800963:	ba 00 10 00 00       	mov    $0x1000,%edx
  800968:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  80096c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800970:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800974:	8b 40 04             	mov    0x4(%eax),%eax
  800977:	89 04 24             	mov    %eax,(%esp)
  80097a:	e8 98 fd ff ff       	call   800717 <file_read>
  80097f:	85 c0                	test   %eax,%eax
  800981:	78 09                	js     80098c <serve_read+0x83>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;

	o->o_fd->fd_offset += r;
  800983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800986:	8b 52 0c             	mov    0xc(%edx),%edx
  800989:	01 42 04             	add    %eax,0x4(%edx)
	return r;
}
  80098c:	83 c4 20             	add    $0x20,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5e                   	pop    %esi
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	56                   	push   %esi
  800997:	53                   	push   %ebx
  800998:	83 ec 20             	sub    $0x20,%esp
  80099b:	8b 75 08             	mov    0x8(%ebp),%esi
  80099e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fsret_stat *ret = &ipc->statRet;
	struct OpenFile *o;
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);
  8009a1:	8b 03                	mov    (%ebx),%eax
  8009a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ab:	c7 04 24 cd 2f 80 00 	movl   $0x802fcd,(%esp)
  8009b2:	e8 8e 04 00 00       	call   800e45 <cprintf>

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8009b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009be:	8b 03                	mov    (%ebx),%eax
  8009c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c4:	89 34 24             	mov    %esi,(%esp)
  8009c7:	e8 e5 fe ff ff       	call   8008b1 <openfile_lookup>
  8009cc:	89 c2                	mov    %eax,%edx
  8009ce:	85 d2                	test   %edx,%edx
  8009d0:	78 3f                	js     800a11 <serve_stat+0x7e>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  8009d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009dc:	89 1c 24             	mov    %ebx,(%esp)
  8009df:	e8 b7 0a 00 00       	call   80149b <strcpy>
	ret->ret_size = o->o_file->f_size;
  8009e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e7:	8b 50 04             	mov    0x4(%eax),%edx
  8009ea:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8009f0:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8009f6:	8b 40 04             	mov    0x4(%eax),%eax
  8009f9:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  800a00:	0f 94 c0             	sete   %al
  800a03:	0f b6 c0             	movzbl %al,%eax
  800a06:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a11:	83 c4 20             	add    $0x20,%esp
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	57                   	push   %edi
  800a1c:	56                   	push   %esi
  800a1d:	53                   	push   %ebx
  800a1e:	81 ec 2c 04 00 00    	sub    $0x42c,%esp
  800a24:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int fileid;
	int r;
	struct OpenFile *o;

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);
  800a27:	8b 83 00 04 00 00    	mov    0x400(%ebx),%eax
  800a2d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a31:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a35:	8b 45 08             	mov    0x8(%ebp),%eax
  800a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3c:	c7 04 24 e3 2f 80 00 	movl   $0x802fe3,(%esp)
  800a43:	e8 fd 03 00 00       	call   800e45 <cprintf>

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  800a48:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  800a4f:	00 
  800a50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a54:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
  800a5a:	89 04 24             	mov    %eax,(%esp)
  800a5d:	e8 34 0c 00 00       	call   801696 <memmove>
	path[MAXPATHLEN-1] = 0;
  800a62:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  800a66:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
  800a6c:	89 04 24             	mov    %eax,(%esp)
  800a6f:	e8 92 fd ff ff       	call   800806 <openfile_alloc>
  800a74:	89 c6                	mov    %eax,%esi
  800a76:	85 c0                	test   %eax,%eax
  800a78:	79 15                	jns    800a8f <serve_open+0x77>
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
  800a7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7e:	c7 04 24 fc 2f 80 00 	movl   $0x802ffc,(%esp)
  800a85:	e8 bb 03 00 00       	call   800e45 <cprintf>
		return r;
  800a8a:	e9 c0 00 00 00       	jmp    800b4f <serve_open+0x137>
	}
	fileid = r;

	if (req->req_omode != 0) {
  800a8f:	8b b3 00 04 00 00    	mov    0x400(%ebx),%esi
  800a95:	85 f6                	test   %esi,%esi
  800a97:	74 1a                	je     800ab3 <serve_open+0x9b>
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
  800a99:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a9d:	c7 04 24 68 30 80 00 	movl   $0x803068,(%esp)
  800aa4:	e8 9c 03 00 00       	call   800e45 <cprintf>
		return -E_INVAL;
  800aa9:	be fd ff ff ff       	mov    $0xfffffffd,%esi
  800aae:	e9 9c 00 00 00       	jmp    800b4f <serve_open+0x137>
	}

	if ((r = file_open(path, &f)) < 0) {
  800ab3:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
  800ab9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abd:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
  800ac3:	89 04 24             	mov    %eax,(%esp)
  800ac6:	e8 6c fa ff ff       	call   800537 <file_open>
  800acb:	89 c7                	mov    %eax,%edi
  800acd:	85 c0                	test   %eax,%eax
  800acf:	79 14                	jns    800ae5 <serve_open+0xcd>
		if (debug)
			cprintf("file_open failed: %e", r);
  800ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad5:	c7 04 24 16 30 80 00 	movl   $0x803016,(%esp)
  800adc:	e8 64 03 00 00       	call   800e45 <cprintf>
		return r;
  800ae1:	89 fe                	mov    %edi,%esi
  800ae3:	eb 6a                	jmp    800b4f <serve_open+0x137>
	}

	// Save the file pointer
	o->o_file = f;
  800ae5:	8b 95 e0 fb ff ff    	mov    -0x420(%ebp),%edx
  800aeb:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
  800af1:	89 42 04             	mov    %eax,0x4(%edx)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  800af4:	8b 42 0c             	mov    0xc(%edx),%eax
  800af7:	8b 0a                	mov    (%edx),%ecx
  800af9:	89 48 0c             	mov    %ecx,0xc(%eax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  800afc:	8b 42 0c             	mov    0xc(%edx),%eax
  800aff:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  800b05:	83 e1 03             	and    $0x3,%ecx
  800b08:	89 48 08             	mov    %ecx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  800b0b:	8b 42 0c             	mov    0xc(%edx),%eax
  800b0e:	8b 15 44 80 80 00    	mov    0x808044,%edx
  800b14:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  800b16:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
  800b1c:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800b22:	89 50 08             	mov    %edx,0x8(%eax)

	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);
  800b25:	8b 40 0c             	mov    0xc(%eax),%eax
  800b28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2c:	c7 04 24 2b 30 80 00 	movl   $0x80302b,(%esp)
  800b33:	e8 0d 03 00 00       	call   800e45 <cprintf>

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  800b38:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
  800b3e:	8b 50 0c             	mov    0xc(%eax),%edx
  800b41:	8b 45 10             	mov    0x10(%ebp),%eax
  800b44:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800b46:	8b 45 14             	mov    0x14(%ebp),%eax
  800b49:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
}
  800b4f:	89 f0                	mov    %esi,%eax
  800b51:	81 c4 2c 04 00 00    	add    $0x42c,%esp
  800b57:	5b                   	pop    %ebx
  800b58:	5e                   	pop    %esi
  800b59:	5f                   	pop    %edi
  800b5a:	5d                   	pop    %ebp
  800b5b:	c3                   	ret    

00800b5c <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	57                   	push   %edi
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 3c             	sub    $0x3c,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800b65:	8d 75 e0             	lea    -0x20(%ebp),%esi
  800b68:	8d 7d e4             	lea    -0x1c(%ebp),%edi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  800b6b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800b72:	89 74 24 08          	mov    %esi,0x8(%esp)
  800b76:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	89 3c 24             	mov    %edi,(%esp)
  800b82:	e8 e4 10 00 00       	call   801c6b <ipc_recv>
  800b87:	89 c3                	mov    %eax,%ebx
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
						req, whom, uvpt[PGNUM(fsreq)], fsreq);
  800b89:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b8e:	89 c2                	mov    %eax,%edx
  800b90:	c1 ea 0c             	shr    $0xc,%edx

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
  800b93:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800b9a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b9e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ba5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bad:	c7 04 24 8c 30 80 00 	movl   $0x80308c,(%esp)
  800bb4:	e8 8c 02 00 00       	call   800e45 <cprintf>
						req, whom, uvpt[PGNUM(fsreq)], fsreq);
		
		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  800bb9:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  800bbd:	75 15                	jne    800bd4 <serve+0x78>
			cprintf("Invalid request from %08x: no argument page\n",
  800bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc6:	c7 04 24 b4 30 80 00 	movl   $0x8030b4,(%esp)
  800bcd:	e8 73 02 00 00       	call   800e45 <cprintf>
				whom);
			continue; // just leave it hanging...
  800bd2:	eb 97                	jmp    800b6b <serve+0xf>
		}

		pg = NULL;
  800bd4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		if (req == FSREQ_OPEN) {
  800bdb:	83 fb 01             	cmp    $0x1,%ebx
  800bde:	75 21                	jne    800c01 <serve+0xa5>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800be0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800be4:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800be7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800beb:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bf7:	89 04 24             	mov    %eax,(%esp)
  800bfa:	e8 19 fe ff ff       	call   800a18 <serve_open>
  800bff:	eb 40                	jmp    800c41 <serve+0xe5>
		} else if (req < NHANDLERS && handlers[req]) {
  800c01:	83 fb 06             	cmp    $0x6,%ebx
  800c04:	77 1f                	ja     800c25 <serve+0xc9>
  800c06:	8b 04 9d 20 40 80 00 	mov    0x804020(,%ebx,4),%eax
  800c0d:	85 c0                	test   %eax,%eax
  800c0f:	74 14                	je     800c25 <serve+0xc9>
			r = handlers[req](whom, fsreq);
  800c11:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  800c17:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c1b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c1e:	89 14 24             	mov    %edx,(%esp)
  800c21:	ff d0                	call   *%eax
  800c23:	eb 1c                	jmp    800c41 <serve+0xe5>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800c25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c30:	c7 04 24 e4 30 80 00 	movl   $0x8030e4,(%esp)
  800c37:	e8 09 02 00 00       	call   800e45 <cprintf>
			r = -E_INVAL;
  800c3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800c41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c44:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c48:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800c56:	89 04 24             	mov    %eax,(%esp)
  800c59:	e8 75 10 00 00       	call   801cd3 <ipc_send>
		sys_page_unmap(0, fsreq);
  800c5e:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c6e:	e8 7d 0d 00 00       	call   8019f0 <sys_page_unmap>
  800c73:	e9 f3 fe ff ff       	jmp    800b6b <serve+0xf>

00800c78 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800c7e:	c7 05 40 80 80 00 47 	movl   $0x803047,0x808040
  800c85:	30 80 00 
	cprintf("FS is running\n");
  800c88:	c7 04 24 4a 30 80 00 	movl   $0x80304a,(%esp)
  800c8f:	e8 b1 01 00 00       	call   800e45 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800c94:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800c99:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800c9e:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800ca0:	c7 04 24 59 30 80 00 	movl   $0x803059,(%esp)
  800ca7:	e8 99 01 00 00       	call   800e45 <cprintf>

	serve_init();
  800cac:	e8 29 fb ff ff       	call   8007da <serve_init>
	fs_init();
  800cb1:	e8 cc f7 ff ff       	call   800482 <fs_init>
	serve();
  800cb6:	e8 a1 fe ff ff       	call   800b5c <serve>

00800cbb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	56                   	push   %esi
  800cbf:	53                   	push   %ebx
  800cc0:	83 ec 10             	sub    $0x10,%esp
  800cc3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800cc6:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800cc9:	e8 3d 0c 00 00       	call   80190b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800cce:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800cd4:	39 c2                	cmp    %eax,%edx
  800cd6:	74 17                	je     800cef <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800cd8:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800cdd:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800ce0:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800ce6:	8b 49 40             	mov    0x40(%ecx),%ecx
  800ce9:	39 c1                	cmp    %eax,%ecx
  800ceb:	75 18                	jne    800d05 <libmain+0x4a>
  800ced:	eb 05                	jmp    800cf4 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800cef:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800cf4:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800cf7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800cfd:	89 15 0c 90 80 00    	mov    %edx,0x80900c
			break;
  800d03:	eb 0b                	jmp    800d10 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800d05:	83 c2 01             	add    $0x1,%edx
  800d08:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800d0e:	75 cd                	jne    800cdd <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800d10:	85 db                	test   %ebx,%ebx
  800d12:	7e 07                	jle    800d1b <libmain+0x60>
		binaryname = argv[0];
  800d14:	8b 06                	mov    (%esi),%eax
  800d16:	a3 40 80 80 00       	mov    %eax,0x808040

	// call user main routine
	umain(argc, argv);
  800d1b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d1f:	89 1c 24             	mov    %ebx,(%esp)
  800d22:	e8 51 ff ff ff       	call   800c78 <umain>

	// exit gracefully
	exit();
  800d27:	e8 07 00 00 00       	call   800d33 <exit>
}
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800d39:	e8 68 12 00 00       	call   801fa6 <close_all>
	sys_env_destroy(0);
  800d3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d45:	e8 6f 0b 00 00       	call   8018b9 <sys_env_destroy>
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	56                   	push   %esi
  800d50:	53                   	push   %ebx
  800d51:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800d54:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800d57:	8b 35 40 80 80 00    	mov    0x808040,%esi
  800d5d:	e8 a9 0b 00 00       	call   80190b <sys_getenvid>
  800d62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d65:	89 54 24 10          	mov    %edx,0x10(%esp)
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d70:	89 74 24 08          	mov    %esi,0x8(%esp)
  800d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d78:	c7 04 24 14 31 80 00 	movl   $0x803114,(%esp)
  800d7f:	e8 c1 00 00 00       	call   800e45 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800d84:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d88:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8b:	89 04 24             	mov    %eax,(%esp)
  800d8e:	e8 51 00 00 00       	call   800de4 <vcprintf>
	cprintf("\n");
  800d93:	c7 04 24 66 30 80 00 	movl   $0x803066,(%esp)
  800d9a:	e8 a6 00 00 00       	call   800e45 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800d9f:	cc                   	int3   
  800da0:	eb fd                	jmp    800d9f <_panic+0x53>

00800da2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	53                   	push   %ebx
  800da6:	83 ec 14             	sub    $0x14,%esp
  800da9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800dac:	8b 13                	mov    (%ebx),%edx
  800dae:	8d 42 01             	lea    0x1(%edx),%eax
  800db1:	89 03                	mov    %eax,(%ebx)
  800db3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800db6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800dba:	3d ff 00 00 00       	cmp    $0xff,%eax
  800dbf:	75 19                	jne    800dda <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800dc1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800dc8:	00 
  800dc9:	8d 43 08             	lea    0x8(%ebx),%eax
  800dcc:	89 04 24             	mov    %eax,(%esp)
  800dcf:	e8 a8 0a 00 00       	call   80187c <sys_cputs>
		b->idx = 0;
  800dd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800dda:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800dde:	83 c4 14             	add    $0x14,%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800ded:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800df4:	00 00 00 
	b.cnt = 0;
  800df7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800dfe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e0f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e19:	c7 04 24 a2 0d 80 00 	movl   $0x800da2,(%esp)
  800e20:	e8 af 01 00 00       	call   800fd4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800e25:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e2f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800e35:	89 04 24             	mov    %eax,(%esp)
  800e38:	e8 3f 0a 00 00       	call   80187c <sys_cputs>

	return b.cnt;
}
  800e3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800e43:	c9                   	leave  
  800e44:	c3                   	ret    

00800e45 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800e4b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800e4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 04 24             	mov    %eax,(%esp)
  800e58:	e8 87 ff ff ff       	call   800de4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    
  800e5f:	90                   	nop

00800e60 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	57                   	push   %edi
  800e64:	56                   	push   %esi
  800e65:	53                   	push   %ebx
  800e66:	83 ec 3c             	sub    $0x3c,%esp
  800e69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e6c:	89 d7                	mov    %edx,%edi
  800e6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e74:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e77:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800e7d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e82:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800e85:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800e88:	39 f1                	cmp    %esi,%ecx
  800e8a:	72 14                	jb     800ea0 <printnum+0x40>
  800e8c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800e8f:	76 0f                	jbe    800ea0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e91:	8b 45 14             	mov    0x14(%ebp),%eax
  800e94:	8d 70 ff             	lea    -0x1(%eax),%esi
  800e97:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800e9a:	85 f6                	test   %esi,%esi
  800e9c:	7f 60                	jg     800efe <printnum+0x9e>
  800e9e:	eb 72                	jmp    800f12 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ea0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ea3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800ea7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800eaa:	8d 51 ff             	lea    -0x1(%ecx),%edx
  800ead:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800eb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eb5:	8b 44 24 08          	mov    0x8(%esp),%eax
  800eb9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800ebd:	89 c3                	mov    %eax,%ebx
  800ebf:	89 d6                	mov    %edx,%esi
  800ec1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ec4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ec7:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ecb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800ecf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ed2:	89 04 24             	mov    %eax,(%esp)
  800ed5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edc:	e8 cf 1c 00 00       	call   802bb0 <__udivdi3>
  800ee1:	89 d9                	mov    %ebx,%ecx
  800ee3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ee7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800eeb:	89 04 24             	mov    %eax,(%esp)
  800eee:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ef2:	89 fa                	mov    %edi,%edx
  800ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ef7:	e8 64 ff ff ff       	call   800e60 <printnum>
  800efc:	eb 14                	jmp    800f12 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800efe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f02:	8b 45 18             	mov    0x18(%ebp),%eax
  800f05:	89 04 24             	mov    %eax,(%esp)
  800f08:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800f0a:	83 ee 01             	sub    $0x1,%esi
  800f0d:	75 ef                	jne    800efe <printnum+0x9e>
  800f0f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800f12:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f16:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800f1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800f1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800f20:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f24:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800f28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f2b:	89 04 24             	mov    %eax,(%esp)
  800f2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f35:	e8 a6 1d 00 00       	call   802ce0 <__umoddi3>
  800f3a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f3e:	0f be 80 37 31 80 00 	movsbl 0x803137(%eax),%eax
  800f45:	89 04 24             	mov    %eax,(%esp)
  800f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f4b:	ff d0                	call   *%eax
}
  800f4d:	83 c4 3c             	add    $0x3c,%esp
  800f50:	5b                   	pop    %ebx
  800f51:	5e                   	pop    %esi
  800f52:	5f                   	pop    %edi
  800f53:	5d                   	pop    %ebp
  800f54:	c3                   	ret    

00800f55 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800f58:	83 fa 01             	cmp    $0x1,%edx
  800f5b:	7e 0e                	jle    800f6b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800f5d:	8b 10                	mov    (%eax),%edx
  800f5f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800f62:	89 08                	mov    %ecx,(%eax)
  800f64:	8b 02                	mov    (%edx),%eax
  800f66:	8b 52 04             	mov    0x4(%edx),%edx
  800f69:	eb 22                	jmp    800f8d <getuint+0x38>
	else if (lflag)
  800f6b:	85 d2                	test   %edx,%edx
  800f6d:	74 10                	je     800f7f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800f6f:	8b 10                	mov    (%eax),%edx
  800f71:	8d 4a 04             	lea    0x4(%edx),%ecx
  800f74:	89 08                	mov    %ecx,(%eax)
  800f76:	8b 02                	mov    (%edx),%eax
  800f78:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7d:	eb 0e                	jmp    800f8d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800f7f:	8b 10                	mov    (%eax),%edx
  800f81:	8d 4a 04             	lea    0x4(%edx),%ecx
  800f84:	89 08                	mov    %ecx,(%eax)
  800f86:	8b 02                	mov    (%edx),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800f8d:	5d                   	pop    %ebp
  800f8e:	c3                   	ret    

00800f8f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f8f:	55                   	push   %ebp
  800f90:	89 e5                	mov    %esp,%ebp
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800f95:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800f99:	8b 10                	mov    (%eax),%edx
  800f9b:	3b 50 04             	cmp    0x4(%eax),%edx
  800f9e:	73 0a                	jae    800faa <sprintputch+0x1b>
		*b->buf++ = ch;
  800fa0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fa3:	89 08                	mov    %ecx,(%eax)
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	88 02                	mov    %al,(%edx)
}
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800fb5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	89 04 24             	mov    %eax,(%esp)
  800fcd:	e8 02 00 00 00       	call   800fd4 <vprintfmt>
	va_end(ap);
}
  800fd2:	c9                   	leave  
  800fd3:	c3                   	ret    

00800fd4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 3c             	sub    $0x3c,%esp
  800fdd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800fe0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe3:	eb 18                	jmp    800ffd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800fe5:	85 c0                	test   %eax,%eax
  800fe7:	0f 84 c3 03 00 00    	je     8013b0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  800fed:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ff1:	89 04 24             	mov    %eax,(%esp)
  800ff4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ff7:	89 f3                	mov    %esi,%ebx
  800ff9:	eb 02                	jmp    800ffd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ffb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ffd:	8d 73 01             	lea    0x1(%ebx),%esi
  801000:	0f b6 03             	movzbl (%ebx),%eax
  801003:	83 f8 25             	cmp    $0x25,%eax
  801006:	75 dd                	jne    800fe5 <vprintfmt+0x11>
  801008:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80100c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801013:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80101a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801021:	ba 00 00 00 00       	mov    $0x0,%edx
  801026:	eb 1d                	jmp    801045 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801028:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80102a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80102e:	eb 15                	jmp    801045 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801030:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801032:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  801036:	eb 0d                	jmp    801045 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801038:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80103b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80103e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801045:	8d 5e 01             	lea    0x1(%esi),%ebx
  801048:	0f b6 06             	movzbl (%esi),%eax
  80104b:	0f b6 c8             	movzbl %al,%ecx
  80104e:	83 e8 23             	sub    $0x23,%eax
  801051:	3c 55                	cmp    $0x55,%al
  801053:	0f 87 2f 03 00 00    	ja     801388 <vprintfmt+0x3b4>
  801059:	0f b6 c0             	movzbl %al,%eax
  80105c:	ff 24 85 80 32 80 00 	jmp    *0x803280(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801063:	8d 41 d0             	lea    -0x30(%ecx),%eax
  801066:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  801069:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80106d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801070:	83 f9 09             	cmp    $0x9,%ecx
  801073:	77 50                	ja     8010c5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801075:	89 de                	mov    %ebx,%esi
  801077:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80107a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80107d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801080:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801084:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801087:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80108a:	83 fb 09             	cmp    $0x9,%ebx
  80108d:	76 eb                	jbe    80107a <vprintfmt+0xa6>
  80108f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801092:	eb 33                	jmp    8010c7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801094:	8b 45 14             	mov    0x14(%ebp),%eax
  801097:	8d 48 04             	lea    0x4(%eax),%ecx
  80109a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80109d:	8b 00                	mov    (%eax),%eax
  80109f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8010a2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8010a4:	eb 21                	jmp    8010c7 <vprintfmt+0xf3>
  8010a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8010a9:	85 c9                	test   %ecx,%ecx
  8010ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b0:	0f 49 c1             	cmovns %ecx,%eax
  8010b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8010b6:	89 de                	mov    %ebx,%esi
  8010b8:	eb 8b                	jmp    801045 <vprintfmt+0x71>
  8010ba:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8010bc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8010c3:	eb 80                	jmp    801045 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8010c5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8010c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010cb:	0f 89 74 ff ff ff    	jns    801045 <vprintfmt+0x71>
  8010d1:	e9 62 ff ff ff       	jmp    801038 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8010d6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8010d9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8010db:	e9 65 ff ff ff       	jmp    801045 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8010e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010e3:	8d 50 04             	lea    0x4(%eax),%edx
  8010e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8010e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010ed:	8b 00                	mov    (%eax),%eax
  8010ef:	89 04 24             	mov    %eax,(%esp)
  8010f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8010f5:	e9 03 ff ff ff       	jmp    800ffd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8010fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010fd:	8d 50 04             	lea    0x4(%eax),%edx
  801100:	89 55 14             	mov    %edx,0x14(%ebp)
  801103:	8b 00                	mov    (%eax),%eax
  801105:	99                   	cltd   
  801106:	31 d0                	xor    %edx,%eax
  801108:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80110a:	83 f8 0f             	cmp    $0xf,%eax
  80110d:	7f 0b                	jg     80111a <vprintfmt+0x146>
  80110f:	8b 14 85 e0 33 80 00 	mov    0x8033e0(,%eax,4),%edx
  801116:	85 d2                	test   %edx,%edx
  801118:	75 20                	jne    80113a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80111a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80111e:	c7 44 24 08 4f 31 80 	movl   $0x80314f,0x8(%esp)
  801125:	00 
  801126:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	89 04 24             	mov    %eax,(%esp)
  801130:	e8 77 fe ff ff       	call   800fac <printfmt>
  801135:	e9 c3 fe ff ff       	jmp    800ffd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80113a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80113e:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  801145:	00 
  801146:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	89 04 24             	mov    %eax,(%esp)
  801150:	e8 57 fe ff ff       	call   800fac <printfmt>
  801155:	e9 a3 fe ff ff       	jmp    800ffd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80115a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80115d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801160:	8b 45 14             	mov    0x14(%ebp),%eax
  801163:	8d 50 04             	lea    0x4(%eax),%edx
  801166:	89 55 14             	mov    %edx,0x14(%ebp)
  801169:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80116b:	85 c0                	test   %eax,%eax
  80116d:	ba 48 31 80 00       	mov    $0x803148,%edx
  801172:	0f 45 d0             	cmovne %eax,%edx
  801175:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801178:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80117c:	74 04                	je     801182 <vprintfmt+0x1ae>
  80117e:	85 f6                	test   %esi,%esi
  801180:	7f 19                	jg     80119b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801182:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801185:	8d 70 01             	lea    0x1(%eax),%esi
  801188:	0f b6 10             	movzbl (%eax),%edx
  80118b:	0f be c2             	movsbl %dl,%eax
  80118e:	85 c0                	test   %eax,%eax
  801190:	0f 85 95 00 00 00    	jne    80122b <vprintfmt+0x257>
  801196:	e9 85 00 00 00       	jmp    801220 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80119b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80119f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011a2:	89 04 24             	mov    %eax,(%esp)
  8011a5:	e8 b8 02 00 00       	call   801462 <strnlen>
  8011aa:	29 c6                	sub    %eax,%esi
  8011ac:	89 f0                	mov    %esi,%eax
  8011ae:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8011b1:	85 f6                	test   %esi,%esi
  8011b3:	7e cd                	jle    801182 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8011b5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8011b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8011bc:	89 c3                	mov    %eax,%ebx
  8011be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011c2:	89 34 24             	mov    %esi,(%esp)
  8011c5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8011c8:	83 eb 01             	sub    $0x1,%ebx
  8011cb:	75 f1                	jne    8011be <vprintfmt+0x1ea>
  8011cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8011d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011d3:	eb ad                	jmp    801182 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8011d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8011d9:	74 1e                	je     8011f9 <vprintfmt+0x225>
  8011db:	0f be d2             	movsbl %dl,%edx
  8011de:	83 ea 20             	sub    $0x20,%edx
  8011e1:	83 fa 5e             	cmp    $0x5e,%edx
  8011e4:	76 13                	jbe    8011f9 <vprintfmt+0x225>
					putch('?', putdat);
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011ed:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8011f4:	ff 55 08             	call   *0x8(%ebp)
  8011f7:	eb 0d                	jmp    801206 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8011f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801200:	89 04 24             	mov    %eax,(%esp)
  801203:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801206:	83 ef 01             	sub    $0x1,%edi
  801209:	83 c6 01             	add    $0x1,%esi
  80120c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801210:	0f be c2             	movsbl %dl,%eax
  801213:	85 c0                	test   %eax,%eax
  801215:	75 20                	jne    801237 <vprintfmt+0x263>
  801217:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80121a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80121d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801220:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801224:	7f 25                	jg     80124b <vprintfmt+0x277>
  801226:	e9 d2 fd ff ff       	jmp    800ffd <vprintfmt+0x29>
  80122b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80122e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801231:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801234:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801237:	85 db                	test   %ebx,%ebx
  801239:	78 9a                	js     8011d5 <vprintfmt+0x201>
  80123b:	83 eb 01             	sub    $0x1,%ebx
  80123e:	79 95                	jns    8011d5 <vprintfmt+0x201>
  801240:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801243:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801246:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801249:	eb d5                	jmp    801220 <vprintfmt+0x24c>
  80124b:	8b 75 08             	mov    0x8(%ebp),%esi
  80124e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801251:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801254:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801258:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80125f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801261:	83 eb 01             	sub    $0x1,%ebx
  801264:	75 ee                	jne    801254 <vprintfmt+0x280>
  801266:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801269:	e9 8f fd ff ff       	jmp    800ffd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80126e:	83 fa 01             	cmp    $0x1,%edx
  801271:	7e 16                	jle    801289 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801273:	8b 45 14             	mov    0x14(%ebp),%eax
  801276:	8d 50 08             	lea    0x8(%eax),%edx
  801279:	89 55 14             	mov    %edx,0x14(%ebp)
  80127c:	8b 50 04             	mov    0x4(%eax),%edx
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801284:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801287:	eb 32                	jmp    8012bb <vprintfmt+0x2e7>
	else if (lflag)
  801289:	85 d2                	test   %edx,%edx
  80128b:	74 18                	je     8012a5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80128d:	8b 45 14             	mov    0x14(%ebp),%eax
  801290:	8d 50 04             	lea    0x4(%eax),%edx
  801293:	89 55 14             	mov    %edx,0x14(%ebp)
  801296:	8b 30                	mov    (%eax),%esi
  801298:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80129b:	89 f0                	mov    %esi,%eax
  80129d:	c1 f8 1f             	sar    $0x1f,%eax
  8012a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8012a3:	eb 16                	jmp    8012bb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8012a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a8:	8d 50 04             	lea    0x4(%eax),%edx
  8012ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8012ae:	8b 30                	mov    (%eax),%esi
  8012b0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8012b3:	89 f0                	mov    %esi,%eax
  8012b5:	c1 f8 1f             	sar    $0x1f,%eax
  8012b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8012bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8012c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8012c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012ca:	0f 89 80 00 00 00    	jns    801350 <vprintfmt+0x37c>
				putch('-', putdat);
  8012d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012d4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8012db:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8012de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012e4:	f7 d8                	neg    %eax
  8012e6:	83 d2 00             	adc    $0x0,%edx
  8012e9:	f7 da                	neg    %edx
			}
			base = 10;
  8012eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012f0:	eb 5e                	jmp    801350 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8012f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8012f5:	e8 5b fc ff ff       	call   800f55 <getuint>
			base = 10;
  8012fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8012ff:	eb 4f                	jmp    801350 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801301:	8d 45 14             	lea    0x14(%ebp),%eax
  801304:	e8 4c fc ff ff       	call   800f55 <getuint>
			base = 8;
  801309:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80130e:	eb 40                	jmp    801350 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801310:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801314:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80131b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80131e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801322:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801329:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80132c:	8b 45 14             	mov    0x14(%ebp),%eax
  80132f:	8d 50 04             	lea    0x4(%eax),%edx
  801332:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801335:	8b 00                	mov    (%eax),%eax
  801337:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80133c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801341:	eb 0d                	jmp    801350 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801343:	8d 45 14             	lea    0x14(%ebp),%eax
  801346:	e8 0a fc ff ff       	call   800f55 <getuint>
			base = 16;
  80134b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801350:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801354:	89 74 24 10          	mov    %esi,0x10(%esp)
  801358:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80135b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80135f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801363:	89 04 24             	mov    %eax,(%esp)
  801366:	89 54 24 04          	mov    %edx,0x4(%esp)
  80136a:	89 fa                	mov    %edi,%edx
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	e8 ec fa ff ff       	call   800e60 <printnum>
			break;
  801374:	e9 84 fc ff ff       	jmp    800ffd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801379:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80137d:	89 0c 24             	mov    %ecx,(%esp)
  801380:	ff 55 08             	call   *0x8(%ebp)
			break;
  801383:	e9 75 fc ff ff       	jmp    800ffd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801388:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80138c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801393:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801396:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80139a:	0f 84 5b fc ff ff    	je     800ffb <vprintfmt+0x27>
  8013a0:	89 f3                	mov    %esi,%ebx
  8013a2:	83 eb 01             	sub    $0x1,%ebx
  8013a5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8013a9:	75 f7                	jne    8013a2 <vprintfmt+0x3ce>
  8013ab:	e9 4d fc ff ff       	jmp    800ffd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8013b0:	83 c4 3c             	add    $0x3c,%esp
  8013b3:	5b                   	pop    %ebx
  8013b4:	5e                   	pop    %esi
  8013b5:	5f                   	pop    %edi
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	83 ec 28             	sub    $0x28,%esp
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8013c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013c7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8013cb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8013ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 30                	je     801409 <vsnprintf+0x51>
  8013d9:	85 d2                	test   %edx,%edx
  8013db:	7e 2c                	jle    801409 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8013dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8013ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f2:	c7 04 24 8f 0f 80 00 	movl   $0x800f8f,(%esp)
  8013f9:	e8 d6 fb ff ff       	call   800fd4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8013fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801401:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801407:	eb 05                	jmp    80140e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801409:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801416:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801419:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80141d:	8b 45 10             	mov    0x10(%ebp),%eax
  801420:	89 44 24 08          	mov    %eax,0x8(%esp)
  801424:	8b 45 0c             	mov    0xc(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	89 04 24             	mov    %eax,(%esp)
  801431:	e8 82 ff ff ff       	call   8013b8 <vsnprintf>
	va_end(ap);

	return rc;
}
  801436:	c9                   	leave  
  801437:	c3                   	ret    
  801438:	66 90                	xchg   %ax,%ax
  80143a:	66 90                	xchg   %ax,%ax
  80143c:	66 90                	xchg   %ax,%ax
  80143e:	66 90                	xchg   %ax,%ax

00801440 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801446:	80 3a 00             	cmpb   $0x0,(%edx)
  801449:	74 10                	je     80145b <strlen+0x1b>
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801450:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801453:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801457:	75 f7                	jne    801450 <strlen+0x10>
  801459:	eb 05                	jmp    801460 <strlen+0x20>
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801460:	5d                   	pop    %ebp
  801461:	c3                   	ret    

00801462 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	53                   	push   %ebx
  801466:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801469:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80146c:	85 c9                	test   %ecx,%ecx
  80146e:	74 1c                	je     80148c <strnlen+0x2a>
  801470:	80 3b 00             	cmpb   $0x0,(%ebx)
  801473:	74 1e                	je     801493 <strnlen+0x31>
  801475:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80147a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80147c:	39 ca                	cmp    %ecx,%edx
  80147e:	74 18                	je     801498 <strnlen+0x36>
  801480:	83 c2 01             	add    $0x1,%edx
  801483:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801488:	75 f0                	jne    80147a <strnlen+0x18>
  80148a:	eb 0c                	jmp    801498 <strnlen+0x36>
  80148c:	b8 00 00 00 00       	mov    $0x0,%eax
  801491:	eb 05                	jmp    801498 <strnlen+0x36>
  801493:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801498:	5b                   	pop    %ebx
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	53                   	push   %ebx
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8014a5:	89 c2                	mov    %eax,%edx
  8014a7:	83 c2 01             	add    $0x1,%edx
  8014aa:	83 c1 01             	add    $0x1,%ecx
  8014ad:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8014b1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8014b4:	84 db                	test   %bl,%bl
  8014b6:	75 ef                	jne    8014a7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8014b8:	5b                   	pop    %ebx
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8014c5:	89 1c 24             	mov    %ebx,(%esp)
  8014c8:	e8 73 ff ff ff       	call   801440 <strlen>
	strcpy(dst + len, src);
  8014cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014d4:	01 d8                	add    %ebx,%eax
  8014d6:	89 04 24             	mov    %eax,(%esp)
  8014d9:	e8 bd ff ff ff       	call   80149b <strcpy>
	return dst;
}
  8014de:	89 d8                	mov    %ebx,%eax
  8014e0:	83 c4 08             	add    $0x8,%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	56                   	push   %esi
  8014ea:	53                   	push   %ebx
  8014eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014f4:	85 db                	test   %ebx,%ebx
  8014f6:	74 17                	je     80150f <strncpy+0x29>
  8014f8:	01 f3                	add    %esi,%ebx
  8014fa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8014fc:	83 c1 01             	add    $0x1,%ecx
  8014ff:	0f b6 02             	movzbl (%edx),%eax
  801502:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801505:	80 3a 01             	cmpb   $0x1,(%edx)
  801508:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80150b:	39 d9                	cmp    %ebx,%ecx
  80150d:	75 ed                	jne    8014fc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80150f:	89 f0                	mov    %esi,%eax
  801511:	5b                   	pop    %ebx
  801512:	5e                   	pop    %esi
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    

00801515 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	57                   	push   %edi
  801519:	56                   	push   %esi
  80151a:	53                   	push   %ebx
  80151b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80151e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801521:	8b 75 10             	mov    0x10(%ebp),%esi
  801524:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801526:	85 f6                	test   %esi,%esi
  801528:	74 34                	je     80155e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80152a:	83 fe 01             	cmp    $0x1,%esi
  80152d:	74 26                	je     801555 <strlcpy+0x40>
  80152f:	0f b6 0b             	movzbl (%ebx),%ecx
  801532:	84 c9                	test   %cl,%cl
  801534:	74 23                	je     801559 <strlcpy+0x44>
  801536:	83 ee 02             	sub    $0x2,%esi
  801539:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80153e:	83 c0 01             	add    $0x1,%eax
  801541:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801544:	39 f2                	cmp    %esi,%edx
  801546:	74 13                	je     80155b <strlcpy+0x46>
  801548:	83 c2 01             	add    $0x1,%edx
  80154b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80154f:	84 c9                	test   %cl,%cl
  801551:	75 eb                	jne    80153e <strlcpy+0x29>
  801553:	eb 06                	jmp    80155b <strlcpy+0x46>
  801555:	89 f8                	mov    %edi,%eax
  801557:	eb 02                	jmp    80155b <strlcpy+0x46>
  801559:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80155b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80155e:	29 f8                	sub    %edi,%eax
}
  801560:	5b                   	pop    %ebx
  801561:	5e                   	pop    %esi
  801562:	5f                   	pop    %edi
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80156b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80156e:	0f b6 01             	movzbl (%ecx),%eax
  801571:	84 c0                	test   %al,%al
  801573:	74 15                	je     80158a <strcmp+0x25>
  801575:	3a 02                	cmp    (%edx),%al
  801577:	75 11                	jne    80158a <strcmp+0x25>
		p++, q++;
  801579:	83 c1 01             	add    $0x1,%ecx
  80157c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80157f:	0f b6 01             	movzbl (%ecx),%eax
  801582:	84 c0                	test   %al,%al
  801584:	74 04                	je     80158a <strcmp+0x25>
  801586:	3a 02                	cmp    (%edx),%al
  801588:	74 ef                	je     801579 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80158a:	0f b6 c0             	movzbl %al,%eax
  80158d:	0f b6 12             	movzbl (%edx),%edx
  801590:	29 d0                	sub    %edx,%eax
}
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	56                   	push   %esi
  801598:	53                   	push   %ebx
  801599:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80159c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80159f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8015a2:	85 f6                	test   %esi,%esi
  8015a4:	74 29                	je     8015cf <strncmp+0x3b>
  8015a6:	0f b6 03             	movzbl (%ebx),%eax
  8015a9:	84 c0                	test   %al,%al
  8015ab:	74 30                	je     8015dd <strncmp+0x49>
  8015ad:	3a 02                	cmp    (%edx),%al
  8015af:	75 2c                	jne    8015dd <strncmp+0x49>
  8015b1:	8d 43 01             	lea    0x1(%ebx),%eax
  8015b4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8015bb:	39 f0                	cmp    %esi,%eax
  8015bd:	74 17                	je     8015d6 <strncmp+0x42>
  8015bf:	0f b6 08             	movzbl (%eax),%ecx
  8015c2:	84 c9                	test   %cl,%cl
  8015c4:	74 17                	je     8015dd <strncmp+0x49>
  8015c6:	83 c0 01             	add    $0x1,%eax
  8015c9:	3a 0a                	cmp    (%edx),%cl
  8015cb:	74 e9                	je     8015b6 <strncmp+0x22>
  8015cd:	eb 0e                	jmp    8015dd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8015cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d4:	eb 0f                	jmp    8015e5 <strncmp+0x51>
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	eb 08                	jmp    8015e5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015dd:	0f b6 03             	movzbl (%ebx),%eax
  8015e0:	0f b6 12             	movzbl (%edx),%edx
  8015e3:	29 d0                	sub    %edx,%eax
}
  8015e5:	5b                   	pop    %ebx
  8015e6:	5e                   	pop    %esi
  8015e7:	5d                   	pop    %ebp
  8015e8:	c3                   	ret    

008015e9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	53                   	push   %ebx
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8015f3:	0f b6 18             	movzbl (%eax),%ebx
  8015f6:	84 db                	test   %bl,%bl
  8015f8:	74 1d                	je     801617 <strchr+0x2e>
  8015fa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8015fc:	38 d3                	cmp    %dl,%bl
  8015fe:	75 06                	jne    801606 <strchr+0x1d>
  801600:	eb 1a                	jmp    80161c <strchr+0x33>
  801602:	38 ca                	cmp    %cl,%dl
  801604:	74 16                	je     80161c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801606:	83 c0 01             	add    $0x1,%eax
  801609:	0f b6 10             	movzbl (%eax),%edx
  80160c:	84 d2                	test   %dl,%dl
  80160e:	75 f2                	jne    801602 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801610:	b8 00 00 00 00       	mov    $0x0,%eax
  801615:	eb 05                	jmp    80161c <strchr+0x33>
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161c:	5b                   	pop    %ebx
  80161d:	5d                   	pop    %ebp
  80161e:	c3                   	ret    

0080161f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	53                   	push   %ebx
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801629:	0f b6 18             	movzbl (%eax),%ebx
  80162c:	84 db                	test   %bl,%bl
  80162e:	74 16                	je     801646 <strfind+0x27>
  801630:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801632:	38 d3                	cmp    %dl,%bl
  801634:	75 06                	jne    80163c <strfind+0x1d>
  801636:	eb 0e                	jmp    801646 <strfind+0x27>
  801638:	38 ca                	cmp    %cl,%dl
  80163a:	74 0a                	je     801646 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80163c:	83 c0 01             	add    $0x1,%eax
  80163f:	0f b6 10             	movzbl (%eax),%edx
  801642:	84 d2                	test   %dl,%dl
  801644:	75 f2                	jne    801638 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801646:	5b                   	pop    %ebx
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	57                   	push   %edi
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801652:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801655:	85 c9                	test   %ecx,%ecx
  801657:	74 36                	je     80168f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801659:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80165f:	75 28                	jne    801689 <memset+0x40>
  801661:	f6 c1 03             	test   $0x3,%cl
  801664:	75 23                	jne    801689 <memset+0x40>
		c &= 0xFF;
  801666:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80166a:	89 d3                	mov    %edx,%ebx
  80166c:	c1 e3 08             	shl    $0x8,%ebx
  80166f:	89 d6                	mov    %edx,%esi
  801671:	c1 e6 18             	shl    $0x18,%esi
  801674:	89 d0                	mov    %edx,%eax
  801676:	c1 e0 10             	shl    $0x10,%eax
  801679:	09 f0                	or     %esi,%eax
  80167b:	09 c2                	or     %eax,%edx
  80167d:	89 d0                	mov    %edx,%eax
  80167f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801681:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801684:	fc                   	cld    
  801685:	f3 ab                	rep stos %eax,%es:(%edi)
  801687:	eb 06                	jmp    80168f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80168c:	fc                   	cld    
  80168d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80168f:	89 f8                	mov    %edi,%eax
  801691:	5b                   	pop    %ebx
  801692:	5e                   	pop    %esi
  801693:	5f                   	pop    %edi
  801694:	5d                   	pop    %ebp
  801695:	c3                   	ret    

00801696 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	57                   	push   %edi
  80169a:	56                   	push   %esi
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8016a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016a4:	39 c6                	cmp    %eax,%esi
  8016a6:	73 35                	jae    8016dd <memmove+0x47>
  8016a8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8016ab:	39 d0                	cmp    %edx,%eax
  8016ad:	73 2e                	jae    8016dd <memmove+0x47>
		s += n;
		d += n;
  8016af:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8016b2:	89 d6                	mov    %edx,%esi
  8016b4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8016b6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8016bc:	75 13                	jne    8016d1 <memmove+0x3b>
  8016be:	f6 c1 03             	test   $0x3,%cl
  8016c1:	75 0e                	jne    8016d1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8016c3:	83 ef 04             	sub    $0x4,%edi
  8016c6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8016c9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8016cc:	fd                   	std    
  8016cd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8016cf:	eb 09                	jmp    8016da <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8016d1:	83 ef 01             	sub    $0x1,%edi
  8016d4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8016d7:	fd                   	std    
  8016d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8016da:	fc                   	cld    
  8016db:	eb 1d                	jmp    8016fa <memmove+0x64>
  8016dd:	89 f2                	mov    %esi,%edx
  8016df:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8016e1:	f6 c2 03             	test   $0x3,%dl
  8016e4:	75 0f                	jne    8016f5 <memmove+0x5f>
  8016e6:	f6 c1 03             	test   $0x3,%cl
  8016e9:	75 0a                	jne    8016f5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8016eb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8016ee:	89 c7                	mov    %eax,%edi
  8016f0:	fc                   	cld    
  8016f1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8016f3:	eb 05                	jmp    8016fa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8016f5:	89 c7                	mov    %eax,%edi
  8016f7:	fc                   	cld    
  8016f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8016fa:	5e                   	pop    %esi
  8016fb:	5f                   	pop    %edi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801704:	8b 45 10             	mov    0x10(%ebp),%eax
  801707:	89 44 24 08          	mov    %eax,0x8(%esp)
  80170b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	89 04 24             	mov    %eax,(%esp)
  801718:	e8 79 ff ff ff       	call   801696 <memmove>
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	57                   	push   %edi
  801723:	56                   	push   %esi
  801724:	53                   	push   %ebx
  801725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801728:	8b 75 0c             	mov    0xc(%ebp),%esi
  80172b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80172e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801731:	85 c0                	test   %eax,%eax
  801733:	74 36                	je     80176b <memcmp+0x4c>
		if (*s1 != *s2)
  801735:	0f b6 03             	movzbl (%ebx),%eax
  801738:	0f b6 0e             	movzbl (%esi),%ecx
  80173b:	ba 00 00 00 00       	mov    $0x0,%edx
  801740:	38 c8                	cmp    %cl,%al
  801742:	74 1c                	je     801760 <memcmp+0x41>
  801744:	eb 10                	jmp    801756 <memcmp+0x37>
  801746:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  80174b:	83 c2 01             	add    $0x1,%edx
  80174e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801752:	38 c8                	cmp    %cl,%al
  801754:	74 0a                	je     801760 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801756:	0f b6 c0             	movzbl %al,%eax
  801759:	0f b6 c9             	movzbl %cl,%ecx
  80175c:	29 c8                	sub    %ecx,%eax
  80175e:	eb 10                	jmp    801770 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801760:	39 fa                	cmp    %edi,%edx
  801762:	75 e2                	jne    801746 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	eb 05                	jmp    801770 <memcmp+0x51>
  80176b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5f                   	pop    %edi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	53                   	push   %ebx
  801779:	8b 45 08             	mov    0x8(%ebp),%eax
  80177c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80177f:	89 c2                	mov    %eax,%edx
  801781:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801784:	39 d0                	cmp    %edx,%eax
  801786:	73 13                	jae    80179b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801788:	89 d9                	mov    %ebx,%ecx
  80178a:	38 18                	cmp    %bl,(%eax)
  80178c:	75 06                	jne    801794 <memfind+0x1f>
  80178e:	eb 0b                	jmp    80179b <memfind+0x26>
  801790:	38 08                	cmp    %cl,(%eax)
  801792:	74 07                	je     80179b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801794:	83 c0 01             	add    $0x1,%eax
  801797:	39 d0                	cmp    %edx,%eax
  801799:	75 f5                	jne    801790 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80179b:	5b                   	pop    %ebx
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	57                   	push   %edi
  8017a2:	56                   	push   %esi
  8017a3:	53                   	push   %ebx
  8017a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8017a7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017aa:	0f b6 0a             	movzbl (%edx),%ecx
  8017ad:	80 f9 09             	cmp    $0x9,%cl
  8017b0:	74 05                	je     8017b7 <strtol+0x19>
  8017b2:	80 f9 20             	cmp    $0x20,%cl
  8017b5:	75 10                	jne    8017c7 <strtol+0x29>
		s++;
  8017b7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017ba:	0f b6 0a             	movzbl (%edx),%ecx
  8017bd:	80 f9 09             	cmp    $0x9,%cl
  8017c0:	74 f5                	je     8017b7 <strtol+0x19>
  8017c2:	80 f9 20             	cmp    $0x20,%cl
  8017c5:	74 f0                	je     8017b7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c7:	80 f9 2b             	cmp    $0x2b,%cl
  8017ca:	75 0a                	jne    8017d6 <strtol+0x38>
		s++;
  8017cc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8017cf:	bf 00 00 00 00       	mov    $0x0,%edi
  8017d4:	eb 11                	jmp    8017e7 <strtol+0x49>
  8017d6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8017db:	80 f9 2d             	cmp    $0x2d,%cl
  8017de:	75 07                	jne    8017e7 <strtol+0x49>
		s++, neg = 1;
  8017e0:	83 c2 01             	add    $0x1,%edx
  8017e3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8017ec:	75 15                	jne    801803 <strtol+0x65>
  8017ee:	80 3a 30             	cmpb   $0x30,(%edx)
  8017f1:	75 10                	jne    801803 <strtol+0x65>
  8017f3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8017f7:	75 0a                	jne    801803 <strtol+0x65>
		s += 2, base = 16;
  8017f9:	83 c2 02             	add    $0x2,%edx
  8017fc:	b8 10 00 00 00       	mov    $0x10,%eax
  801801:	eb 10                	jmp    801813 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801803:	85 c0                	test   %eax,%eax
  801805:	75 0c                	jne    801813 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801807:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801809:	80 3a 30             	cmpb   $0x30,(%edx)
  80180c:	75 05                	jne    801813 <strtol+0x75>
		s++, base = 8;
  80180e:	83 c2 01             	add    $0x1,%edx
  801811:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801813:	bb 00 00 00 00       	mov    $0x0,%ebx
  801818:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80181b:	0f b6 0a             	movzbl (%edx),%ecx
  80181e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801821:	89 f0                	mov    %esi,%eax
  801823:	3c 09                	cmp    $0x9,%al
  801825:	77 08                	ja     80182f <strtol+0x91>
			dig = *s - '0';
  801827:	0f be c9             	movsbl %cl,%ecx
  80182a:	83 e9 30             	sub    $0x30,%ecx
  80182d:	eb 20                	jmp    80184f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  80182f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801832:	89 f0                	mov    %esi,%eax
  801834:	3c 19                	cmp    $0x19,%al
  801836:	77 08                	ja     801840 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801838:	0f be c9             	movsbl %cl,%ecx
  80183b:	83 e9 57             	sub    $0x57,%ecx
  80183e:	eb 0f                	jmp    80184f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801840:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801843:	89 f0                	mov    %esi,%eax
  801845:	3c 19                	cmp    $0x19,%al
  801847:	77 16                	ja     80185f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801849:	0f be c9             	movsbl %cl,%ecx
  80184c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80184f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801852:	7d 0f                	jge    801863 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801854:	83 c2 01             	add    $0x1,%edx
  801857:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  80185b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  80185d:	eb bc                	jmp    80181b <strtol+0x7d>
  80185f:	89 d8                	mov    %ebx,%eax
  801861:	eb 02                	jmp    801865 <strtol+0xc7>
  801863:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801865:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801869:	74 05                	je     801870 <strtol+0xd2>
		*endptr = (char *) s;
  80186b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80186e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801870:	f7 d8                	neg    %eax
  801872:	85 ff                	test   %edi,%edi
  801874:	0f 44 c3             	cmove  %ebx,%eax
}
  801877:	5b                   	pop    %ebx
  801878:	5e                   	pop    %esi
  801879:	5f                   	pop    %edi
  80187a:	5d                   	pop    %ebp
  80187b:	c3                   	ret    

0080187c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	57                   	push   %edi
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801882:	b8 00 00 00 00       	mov    $0x0,%eax
  801887:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188a:	8b 55 08             	mov    0x8(%ebp),%edx
  80188d:	89 c3                	mov    %eax,%ebx
  80188f:	89 c7                	mov    %eax,%edi
  801891:	89 c6                	mov    %eax,%esi
  801893:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5f                   	pop    %edi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    

0080189a <sys_cgetc>:

int
sys_cgetc(void)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	57                   	push   %edi
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8018aa:	89 d1                	mov    %edx,%ecx
  8018ac:	89 d3                	mov    %edx,%ebx
  8018ae:	89 d7                	mov    %edx,%edi
  8018b0:	89 d6                	mov    %edx,%esi
  8018b2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8018b4:	5b                   	pop    %ebx
  8018b5:	5e                   	pop    %esi
  8018b6:	5f                   	pop    %edi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    

008018b9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	57                   	push   %edi
  8018bd:	56                   	push   %esi
  8018be:	53                   	push   %ebx
  8018bf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018c7:	b8 03 00 00 00       	mov    $0x3,%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 cb                	mov    %ecx,%ebx
  8018d1:	89 cf                	mov    %ecx,%edi
  8018d3:	89 ce                	mov    %ecx,%esi
  8018d5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	7e 28                	jle    801903 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018df:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8018e6:	00 
  8018e7:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  8018ee:	00 
  8018ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018f6:	00 
  8018f7:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  8018fe:	e8 49 f4 ff ff       	call   800d4c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801903:	83 c4 2c             	add    $0x2c,%esp
  801906:	5b                   	pop    %ebx
  801907:	5e                   	pop    %esi
  801908:	5f                   	pop    %edi
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	57                   	push   %edi
  80190f:	56                   	push   %esi
  801910:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801911:	ba 00 00 00 00       	mov    $0x0,%edx
  801916:	b8 02 00 00 00       	mov    $0x2,%eax
  80191b:	89 d1                	mov    %edx,%ecx
  80191d:	89 d3                	mov    %edx,%ebx
  80191f:	89 d7                	mov    %edx,%edi
  801921:	89 d6                	mov    %edx,%esi
  801923:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <sys_yield>:

void
sys_yield(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
  80192d:	57                   	push   %edi
  80192e:	56                   	push   %esi
  80192f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801930:	ba 00 00 00 00       	mov    $0x0,%edx
  801935:	b8 0b 00 00 00       	mov    $0xb,%eax
  80193a:	89 d1                	mov    %edx,%ecx
  80193c:	89 d3                	mov    %edx,%ebx
  80193e:	89 d7                	mov    %edx,%edi
  801940:	89 d6                	mov    %edx,%esi
  801942:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801944:	5b                   	pop    %ebx
  801945:	5e                   	pop    %esi
  801946:	5f                   	pop    %edi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	57                   	push   %edi
  80194d:	56                   	push   %esi
  80194e:	53                   	push   %ebx
  80194f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801952:	be 00 00 00 00       	mov    $0x0,%esi
  801957:	b8 04 00 00 00       	mov    $0x4,%eax
  80195c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80195f:	8b 55 08             	mov    0x8(%ebp),%edx
  801962:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801965:	89 f7                	mov    %esi,%edi
  801967:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801969:	85 c0                	test   %eax,%eax
  80196b:	7e 28                	jle    801995 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80196d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801971:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801978:	00 
  801979:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801980:	00 
  801981:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801988:	00 
  801989:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801990:	e8 b7 f3 ff ff       	call   800d4c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801995:	83 c4 2c             	add    $0x2c,%esp
  801998:	5b                   	pop    %ebx
  801999:	5e                   	pop    %esi
  80199a:	5f                   	pop    %edi
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    

0080199d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	57                   	push   %edi
  8019a1:	56                   	push   %esi
  8019a2:	53                   	push   %ebx
  8019a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019a6:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8019b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019b7:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	7e 28                	jle    8019e8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019c4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8019cb:	00 
  8019cc:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  8019d3:	00 
  8019d4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019db:	00 
  8019dc:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  8019e3:	e8 64 f3 ff ff       	call   800d4c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8019e8:	83 c4 2c             	add    $0x2c,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5e                   	pop    %esi
  8019ed:	5f                   	pop    %edi
  8019ee:	5d                   	pop    %ebp
  8019ef:	c3                   	ret    

008019f0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	57                   	push   %edi
  8019f4:	56                   	push   %esi
  8019f5:	53                   	push   %ebx
  8019f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019fe:	b8 06 00 00 00       	mov    $0x6,%eax
  801a03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a06:	8b 55 08             	mov    0x8(%ebp),%edx
  801a09:	89 df                	mov    %ebx,%edi
  801a0b:	89 de                	mov    %ebx,%esi
  801a0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a0f:	85 c0                	test   %eax,%eax
  801a11:	7e 28                	jle    801a3b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a13:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a17:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801a1e:	00 
  801a1f:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801a26:	00 
  801a27:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a2e:	00 
  801a2f:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801a36:	e8 11 f3 ff ff       	call   800d4c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801a3b:	83 c4 2c             	add    $0x2c,%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5e                   	pop    %esi
  801a40:	5f                   	pop    %edi
  801a41:	5d                   	pop    %ebp
  801a42:	c3                   	ret    

00801a43 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	57                   	push   %edi
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a51:	b8 08 00 00 00       	mov    $0x8,%eax
  801a56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a59:	8b 55 08             	mov    0x8(%ebp),%edx
  801a5c:	89 df                	mov    %ebx,%edi
  801a5e:	89 de                	mov    %ebx,%esi
  801a60:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a62:	85 c0                	test   %eax,%eax
  801a64:	7e 28                	jle    801a8e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a66:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a6a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801a71:	00 
  801a72:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801a79:	00 
  801a7a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a81:	00 
  801a82:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801a89:	e8 be f2 ff ff       	call   800d4c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801a8e:	83 c4 2c             	add    $0x2c,%esp
  801a91:	5b                   	pop    %ebx
  801a92:	5e                   	pop    %esi
  801a93:	5f                   	pop    %edi
  801a94:	5d                   	pop    %ebp
  801a95:	c3                   	ret    

00801a96 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	57                   	push   %edi
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
  801a9c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aa4:	b8 09 00 00 00       	mov    $0x9,%eax
  801aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aac:	8b 55 08             	mov    0x8(%ebp),%edx
  801aaf:	89 df                	mov    %ebx,%edi
  801ab1:	89 de                	mov    %ebx,%esi
  801ab3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	7e 28                	jle    801ae1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ab9:	89 44 24 10          	mov    %eax,0x10(%esp)
  801abd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801ac4:	00 
  801ac5:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801acc:	00 
  801acd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801ad4:	00 
  801ad5:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801adc:	e8 6b f2 ff ff       	call   800d4c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801ae1:	83 c4 2c             	add    $0x2c,%esp
  801ae4:	5b                   	pop    %ebx
  801ae5:	5e                   	pop    %esi
  801ae6:	5f                   	pop    %edi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	57                   	push   %edi
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
  801aef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801af2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801af7:	b8 0a 00 00 00       	mov    $0xa,%eax
  801afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aff:	8b 55 08             	mov    0x8(%ebp),%edx
  801b02:	89 df                	mov    %ebx,%edi
  801b04:	89 de                	mov    %ebx,%esi
  801b06:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	7e 28                	jle    801b34 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b10:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801b17:	00 
  801b18:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801b1f:	00 
  801b20:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801b27:	00 
  801b28:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801b2f:	e8 18 f2 ff ff       	call   800d4c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801b34:	83 c4 2c             	add    $0x2c,%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5f                   	pop    %edi
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	57                   	push   %edi
  801b40:	56                   	push   %esi
  801b41:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b42:	be 00 00 00 00       	mov    $0x0,%esi
  801b47:	b8 0c 00 00 00       	mov    $0xc,%eax
  801b4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b4f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b55:	8b 7d 14             	mov    0x14(%ebp),%edi
  801b58:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    

00801b5f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	57                   	push   %edi
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
  801b65:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b68:	b9 00 00 00 00       	mov    $0x0,%ecx
  801b6d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801b72:	8b 55 08             	mov    0x8(%ebp),%edx
  801b75:	89 cb                	mov    %ecx,%ebx
  801b77:	89 cf                	mov    %ecx,%edi
  801b79:	89 ce                	mov    %ecx,%esi
  801b7b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801b7d:	85 c0                	test   %eax,%eax
  801b7f:	7e 28                	jle    801ba9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b81:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b85:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801b8c:	00 
  801b8d:	c7 44 24 08 3f 34 80 	movl   $0x80343f,0x8(%esp)
  801b94:	00 
  801b95:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801b9c:	00 
  801b9d:	c7 04 24 5c 34 80 00 	movl   $0x80345c,(%esp)
  801ba4:	e8 a3 f1 ff ff       	call   800d4c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801ba9:	83 c4 2c             	add    $0x2c,%esp
  801bac:	5b                   	pop    %ebx
  801bad:	5e                   	pop    %esi
  801bae:	5f                   	pop    %edi
  801baf:	5d                   	pop    %ebp
  801bb0:	c3                   	ret    

00801bb1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801bb7:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  801bbe:	75 50                	jne    801c10 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801bc0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bc7:	00 
  801bc8:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801bcf:	ee 
  801bd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd7:	e8 6d fd ff ff       	call   801949 <sys_page_alloc>
  801bdc:	85 c0                	test   %eax,%eax
  801bde:	79 1c                	jns    801bfc <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801be0:	c7 44 24 08 6c 34 80 	movl   $0x80346c,0x8(%esp)
  801be7:	00 
  801be8:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801bef:	00 
  801bf0:	c7 04 24 90 34 80 00 	movl   $0x803490,(%esp)
  801bf7:	e8 50 f1 ff ff       	call   800d4c <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801bfc:	c7 44 24 04 1a 1c 80 	movl   $0x801c1a,0x4(%esp)
  801c03:	00 
  801c04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0b:	e8 d9 fe ff ff       	call   801ae9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801c10:	8b 45 08             	mov    0x8(%ebp),%eax
  801c13:	a3 10 90 80 00       	mov    %eax,0x809010
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801c1a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801c1b:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  801c20:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801c22:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801c25:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801c27:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  801c2c:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  801c2f:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801c34:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801c37:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801c39:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  801c3c:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  801c3e:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801c40:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801c45:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801c48:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  801c4d:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801c50:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801c52:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801c57:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  801c5a:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  801c5f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  801c62:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  801c64:	83 c4 08             	add    $0x8,%esp
	popal
  801c67:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801c68:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801c69:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801c6a:	c3                   	ret    

00801c6b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	83 ec 10             	sub    $0x10,%esp
  801c73:	8b 75 08             	mov    0x8(%ebp),%esi
  801c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c79:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801c83:	0f 44 c2             	cmove  %edx,%eax
  801c86:	89 04 24             	mov    %eax,(%esp)
  801c89:	e8 d1 fe ff ff       	call   801b5f <sys_ipc_recv>
	if (err_code < 0) {
  801c8e:	85 c0                	test   %eax,%eax
  801c90:	79 16                	jns    801ca8 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801c92:	85 f6                	test   %esi,%esi
  801c94:	74 06                	je     801c9c <ipc_recv+0x31>
  801c96:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801c9c:	85 db                	test   %ebx,%ebx
  801c9e:	74 2c                	je     801ccc <ipc_recv+0x61>
  801ca0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ca6:	eb 24                	jmp    801ccc <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801ca8:	85 f6                	test   %esi,%esi
  801caa:	74 0a                	je     801cb6 <ipc_recv+0x4b>
  801cac:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801cb1:	8b 40 74             	mov    0x74(%eax),%eax
  801cb4:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801cb6:	85 db                	test   %ebx,%ebx
  801cb8:	74 0a                	je     801cc4 <ipc_recv+0x59>
  801cba:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801cbf:	8b 40 78             	mov    0x78(%eax),%eax
  801cc2:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801cc4:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801cc9:	8b 40 70             	mov    0x70(%eax),%eax
}
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	5b                   	pop    %ebx
  801cd0:	5e                   	pop    %esi
  801cd1:	5d                   	pop    %ebp
  801cd2:	c3                   	ret    

00801cd3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	57                   	push   %edi
  801cd7:	56                   	push   %esi
  801cd8:	53                   	push   %ebx
  801cd9:	83 ec 1c             	sub    $0x1c,%esp
  801cdc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801cdf:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801ce5:	eb 25                	jmp    801d0c <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801ce7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cea:	74 20                	je     801d0c <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801cec:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf0:	c7 44 24 08 9e 34 80 	movl   $0x80349e,0x8(%esp)
  801cf7:	00 
  801cf8:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801cff:	00 
  801d00:	c7 04 24 aa 34 80 00 	movl   $0x8034aa,(%esp)
  801d07:	e8 40 f0 ff ff       	call   800d4c <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d0c:	85 db                	test   %ebx,%ebx
  801d0e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d13:	0f 45 c3             	cmovne %ebx,%eax
  801d16:	8b 55 14             	mov    0x14(%ebp),%edx
  801d19:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d21:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d25:	89 3c 24             	mov    %edi,(%esp)
  801d28:	e8 0f fe ff ff       	call   801b3c <sys_ipc_try_send>
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	75 b6                	jne    801ce7 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    

00801d39 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d39:	55                   	push   %ebp
  801d3a:	89 e5                	mov    %esp,%ebp
  801d3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801d3f:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801d44:	39 c8                	cmp    %ecx,%eax
  801d46:	74 17                	je     801d5f <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d48:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801d4d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801d50:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801d56:	8b 52 50             	mov    0x50(%edx),%edx
  801d59:	39 ca                	cmp    %ecx,%edx
  801d5b:	75 14                	jne    801d71 <ipc_find_env+0x38>
  801d5d:	eb 05                	jmp    801d64 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801d64:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801d67:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801d6c:	8b 40 40             	mov    0x40(%eax),%eax
  801d6f:	eb 0e                	jmp    801d7f <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801d71:	83 c0 01             	add    $0x1,%eax
  801d74:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d79:	75 d2                	jne    801d4d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801d7b:	66 b8 00 00          	mov    $0x0,%ax
}
  801d7f:	5d                   	pop    %ebp
  801d80:	c3                   	ret    
  801d81:	66 90                	xchg   %ax,%ax
  801d83:	66 90                	xchg   %ax,%ax
  801d85:	66 90                	xchg   %ax,%ax
  801d87:	66 90                	xchg   %ax,%ax
  801d89:	66 90                	xchg   %ax,%ax
  801d8b:	66 90                	xchg   %ax,%ax
  801d8d:	66 90                	xchg   %ax,%ax
  801d8f:	90                   	nop

00801d90 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	05 00 00 00 30       	add    $0x30000000,%eax
  801d9b:	c1 e8 0c             	shr    $0xc,%eax
}
  801d9e:	5d                   	pop    %ebp
  801d9f:	c3                   	ret    

00801da0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da3:	8b 45 08             	mov    0x8(%ebp),%eax
  801da6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801dab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801db0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    

00801db7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dba:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801dbf:	a8 01                	test   $0x1,%al
  801dc1:	74 34                	je     801df7 <fd_alloc+0x40>
  801dc3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801dc8:	a8 01                	test   $0x1,%al
  801dca:	74 32                	je     801dfe <fd_alloc+0x47>
  801dcc:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801dd1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801dd3:	89 c2                	mov    %eax,%edx
  801dd5:	c1 ea 16             	shr    $0x16,%edx
  801dd8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801ddf:	f6 c2 01             	test   $0x1,%dl
  801de2:	74 1f                	je     801e03 <fd_alloc+0x4c>
  801de4:	89 c2                	mov    %eax,%edx
  801de6:	c1 ea 0c             	shr    $0xc,%edx
  801de9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801df0:	f6 c2 01             	test   $0x1,%dl
  801df3:	75 1a                	jne    801e0f <fd_alloc+0x58>
  801df5:	eb 0c                	jmp    801e03 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801df7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801dfc:	eb 05                	jmp    801e03 <fd_alloc+0x4c>
  801dfe:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801e03:	8b 45 08             	mov    0x8(%ebp),%eax
  801e06:	89 08                	mov    %ecx,(%eax)
			return 0;
  801e08:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0d:	eb 1a                	jmp    801e29 <fd_alloc+0x72>
  801e0f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801e14:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801e19:	75 b6                	jne    801dd1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801e24:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801e29:	5d                   	pop    %ebp
  801e2a:	c3                   	ret    

00801e2b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801e31:	83 f8 1f             	cmp    $0x1f,%eax
  801e34:	77 36                	ja     801e6c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801e36:	c1 e0 0c             	shl    $0xc,%eax
  801e39:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801e3e:	89 c2                	mov    %eax,%edx
  801e40:	c1 ea 16             	shr    $0x16,%edx
  801e43:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801e4a:	f6 c2 01             	test   $0x1,%dl
  801e4d:	74 24                	je     801e73 <fd_lookup+0x48>
  801e4f:	89 c2                	mov    %eax,%edx
  801e51:	c1 ea 0c             	shr    $0xc,%edx
  801e54:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801e5b:	f6 c2 01             	test   $0x1,%dl
  801e5e:	74 1a                	je     801e7a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801e60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e63:	89 02                	mov    %eax,(%edx)
	return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	eb 13                	jmp    801e7f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e71:	eb 0c                	jmp    801e7f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801e73:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801e78:	eb 05                	jmp    801e7f <fd_lookup+0x54>
  801e7a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801e7f:	5d                   	pop    %ebp
  801e80:	c3                   	ret    

00801e81 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801e81:	55                   	push   %ebp
  801e82:	89 e5                	mov    %esp,%ebp
  801e84:	53                   	push   %ebx
  801e85:	83 ec 14             	sub    $0x14,%esp
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801e8e:	39 05 44 80 80 00    	cmp    %eax,0x808044
  801e94:	75 1e                	jne    801eb4 <dev_lookup+0x33>
  801e96:	eb 0e                	jmp    801ea6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801e98:	b8 60 80 80 00       	mov    $0x808060,%eax
  801e9d:	eb 0c                	jmp    801eab <dev_lookup+0x2a>
  801e9f:	b8 7c 80 80 00       	mov    $0x80807c,%eax
  801ea4:	eb 05                	jmp    801eab <dev_lookup+0x2a>
  801ea6:	b8 44 80 80 00       	mov    $0x808044,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801eab:	89 03                	mov    %eax,(%ebx)
			return 0;
  801ead:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb2:	eb 38                	jmp    801eec <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801eb4:	39 05 60 80 80 00    	cmp    %eax,0x808060
  801eba:	74 dc                	je     801e98 <dev_lookup+0x17>
  801ebc:	39 05 7c 80 80 00    	cmp    %eax,0x80807c
  801ec2:	74 db                	je     801e9f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801ec4:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  801eca:	8b 52 48             	mov    0x48(%edx),%edx
  801ecd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed5:	c7 04 24 b4 34 80 00 	movl   $0x8034b4,(%esp)
  801edc:	e8 64 ef ff ff       	call   800e45 <cprintf>
	*dev = 0;
  801ee1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801ee7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801eec:	83 c4 14             	add    $0x14,%esp
  801eef:	5b                   	pop    %ebx
  801ef0:	5d                   	pop    %ebp
  801ef1:	c3                   	ret    

00801ef2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	56                   	push   %esi
  801ef6:	53                   	push   %ebx
  801ef7:	83 ec 20             	sub    $0x20,%esp
  801efa:	8b 75 08             	mov    0x8(%ebp),%esi
  801efd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f03:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801f07:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801f0d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801f10:	89 04 24             	mov    %eax,(%esp)
  801f13:	e8 13 ff ff ff       	call   801e2b <fd_lookup>
  801f18:	85 c0                	test   %eax,%eax
  801f1a:	78 05                	js     801f21 <fd_close+0x2f>
	    || fd != fd2)
  801f1c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801f1f:	74 0c                	je     801f2d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801f21:	84 db                	test   %bl,%bl
  801f23:	ba 00 00 00 00       	mov    $0x0,%edx
  801f28:	0f 44 c2             	cmove  %edx,%eax
  801f2b:	eb 3f                	jmp    801f6c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801f2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f30:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f34:	8b 06                	mov    (%esi),%eax
  801f36:	89 04 24             	mov    %eax,(%esp)
  801f39:	e8 43 ff ff ff       	call   801e81 <dev_lookup>
  801f3e:	89 c3                	mov    %eax,%ebx
  801f40:	85 c0                	test   %eax,%eax
  801f42:	78 16                	js     801f5a <fd_close+0x68>
		if (dev->dev_close)
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801f4a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801f4f:	85 c0                	test   %eax,%eax
  801f51:	74 07                	je     801f5a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801f53:	89 34 24             	mov    %esi,(%esp)
  801f56:	ff d0                	call   *%eax
  801f58:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f5a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f5e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f65:	e8 86 fa ff ff       	call   8019f0 <sys_page_unmap>
	return r;
  801f6a:	89 d8                	mov    %ebx,%eax
}
  801f6c:	83 c4 20             	add    $0x20,%esp
  801f6f:	5b                   	pop    %ebx
  801f70:	5e                   	pop    %esi
  801f71:	5d                   	pop    %ebp
  801f72:	c3                   	ret    

00801f73 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	8b 45 08             	mov    0x8(%ebp),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	e8 a0 fe ff ff       	call   801e2b <fd_lookup>
  801f8b:	89 c2                	mov    %eax,%edx
  801f8d:	85 d2                	test   %edx,%edx
  801f8f:	78 13                	js     801fa4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801f91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f98:	00 
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 04 24             	mov    %eax,(%esp)
  801f9f:	e8 4e ff ff ff       	call   801ef2 <fd_close>
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <close_all>:

void
close_all(void)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	53                   	push   %ebx
  801faa:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801fad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801fb2:	89 1c 24             	mov    %ebx,(%esp)
  801fb5:	e8 b9 ff ff ff       	call   801f73 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fba:	83 c3 01             	add    $0x1,%ebx
  801fbd:	83 fb 20             	cmp    $0x20,%ebx
  801fc0:	75 f0                	jne    801fb2 <close_all+0xc>
		close(i);
}
  801fc2:	83 c4 14             	add    $0x14,%esp
  801fc5:	5b                   	pop    %ebx
  801fc6:	5d                   	pop    %ebp
  801fc7:	c3                   	ret    

00801fc8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	57                   	push   %edi
  801fcc:	56                   	push   %esi
  801fcd:	53                   	push   %ebx
  801fce:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fd1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	89 04 24             	mov    %eax,(%esp)
  801fde:	e8 48 fe ff ff       	call   801e2b <fd_lookup>
  801fe3:	89 c2                	mov    %eax,%edx
  801fe5:	85 d2                	test   %edx,%edx
  801fe7:	0f 88 e1 00 00 00    	js     8020ce <dup+0x106>
		return r;
	close(newfdnum);
  801fed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff0:	89 04 24             	mov    %eax,(%esp)
  801ff3:	e8 7b ff ff ff       	call   801f73 <close>

	newfd = INDEX2FD(newfdnum);
  801ff8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801ffb:	c1 e3 0c             	shl    $0xc,%ebx
  801ffe:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  802004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802007:	89 04 24             	mov    %eax,(%esp)
  80200a:	e8 91 fd ff ff       	call   801da0 <fd2data>
  80200f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  802011:	89 1c 24             	mov    %ebx,(%esp)
  802014:	e8 87 fd ff ff       	call   801da0 <fd2data>
  802019:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80201b:	89 f0                	mov    %esi,%eax
  80201d:	c1 e8 16             	shr    $0x16,%eax
  802020:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802027:	a8 01                	test   $0x1,%al
  802029:	74 43                	je     80206e <dup+0xa6>
  80202b:	89 f0                	mov    %esi,%eax
  80202d:	c1 e8 0c             	shr    $0xc,%eax
  802030:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802037:	f6 c2 01             	test   $0x1,%dl
  80203a:	74 32                	je     80206e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80203c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802043:	25 07 0e 00 00       	and    $0xe07,%eax
  802048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80204c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802050:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802057:	00 
  802058:	89 74 24 04          	mov    %esi,0x4(%esp)
  80205c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802063:	e8 35 f9 ff ff       	call   80199d <sys_page_map>
  802068:	89 c6                	mov    %eax,%esi
  80206a:	85 c0                	test   %eax,%eax
  80206c:	78 3e                	js     8020ac <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80206e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802071:	89 c2                	mov    %eax,%edx
  802073:	c1 ea 0c             	shr    $0xc,%edx
  802076:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80207d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  802083:	89 54 24 10          	mov    %edx,0x10(%esp)
  802087:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80208b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802092:	00 
  802093:	89 44 24 04          	mov    %eax,0x4(%esp)
  802097:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209e:	e8 fa f8 ff ff       	call   80199d <sys_page_map>
  8020a3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8020a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8020a8:	85 f6                	test   %esi,%esi
  8020aa:	79 22                	jns    8020ce <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8020ac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b7:	e8 34 f9 ff ff       	call   8019f0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020bc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c7:	e8 24 f9 ff ff       	call   8019f0 <sys_page_unmap>
	return r;
  8020cc:	89 f0                	mov    %esi,%eax
}
  8020ce:	83 c4 3c             	add    $0x3c,%esp
  8020d1:	5b                   	pop    %ebx
  8020d2:	5e                   	pop    %esi
  8020d3:	5f                   	pop    %edi
  8020d4:	5d                   	pop    %ebp
  8020d5:	c3                   	ret    

008020d6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
  8020d9:	53                   	push   %ebx
  8020da:	83 ec 24             	sub    $0x24,%esp
  8020dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e7:	89 1c 24             	mov    %ebx,(%esp)
  8020ea:	e8 3c fd ff ff       	call   801e2b <fd_lookup>
  8020ef:	89 c2                	mov    %eax,%edx
  8020f1:	85 d2                	test   %edx,%edx
  8020f3:	78 6d                	js     802162 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ff:	8b 00                	mov    (%eax),%eax
  802101:	89 04 24             	mov    %eax,(%esp)
  802104:	e8 78 fd ff ff       	call   801e81 <dev_lookup>
  802109:	85 c0                	test   %eax,%eax
  80210b:	78 55                	js     802162 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80210d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802110:	8b 50 08             	mov    0x8(%eax),%edx
  802113:	83 e2 03             	and    $0x3,%edx
  802116:	83 fa 01             	cmp    $0x1,%edx
  802119:	75 23                	jne    80213e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80211b:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802120:	8b 40 48             	mov    0x48(%eax),%eax
  802123:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  802132:	e8 0e ed ff ff       	call   800e45 <cprintf>
		return -E_INVAL;
  802137:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80213c:	eb 24                	jmp    802162 <read+0x8c>
	}
	if (!dev->dev_read)
  80213e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802141:	8b 52 08             	mov    0x8(%edx),%edx
  802144:	85 d2                	test   %edx,%edx
  802146:	74 15                	je     80215d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802148:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80214b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80214f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802152:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802156:	89 04 24             	mov    %eax,(%esp)
  802159:	ff d2                	call   *%edx
  80215b:	eb 05                	jmp    802162 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80215d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802162:	83 c4 24             	add    $0x24,%esp
  802165:	5b                   	pop    %ebx
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    

00802168 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	57                   	push   %edi
  80216c:	56                   	push   %esi
  80216d:	53                   	push   %ebx
  80216e:	83 ec 1c             	sub    $0x1c,%esp
  802171:	8b 7d 08             	mov    0x8(%ebp),%edi
  802174:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802177:	85 f6                	test   %esi,%esi
  802179:	74 33                	je     8021ae <readn+0x46>
  80217b:	b8 00 00 00 00       	mov    $0x0,%eax
  802180:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  802185:	89 f2                	mov    %esi,%edx
  802187:	29 c2                	sub    %eax,%edx
  802189:	89 54 24 08          	mov    %edx,0x8(%esp)
  80218d:	03 45 0c             	add    0xc(%ebp),%eax
  802190:	89 44 24 04          	mov    %eax,0x4(%esp)
  802194:	89 3c 24             	mov    %edi,(%esp)
  802197:	e8 3a ff ff ff       	call   8020d6 <read>
		if (m < 0)
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 1b                	js     8021bb <readn+0x53>
			return m;
		if (m == 0)
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 11                	je     8021b5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8021a4:	01 c3                	add    %eax,%ebx
  8021a6:	89 d8                	mov    %ebx,%eax
  8021a8:	39 f3                	cmp    %esi,%ebx
  8021aa:	72 d9                	jb     802185 <readn+0x1d>
  8021ac:	eb 0b                	jmp    8021b9 <readn+0x51>
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b3:	eb 06                	jmp    8021bb <readn+0x53>
  8021b5:	89 d8                	mov    %ebx,%eax
  8021b7:	eb 02                	jmp    8021bb <readn+0x53>
  8021b9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8021bb:	83 c4 1c             	add    $0x1c,%esp
  8021be:	5b                   	pop    %ebx
  8021bf:	5e                   	pop    %esi
  8021c0:	5f                   	pop    %edi
  8021c1:	5d                   	pop    %ebp
  8021c2:	c3                   	ret    

008021c3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	53                   	push   %ebx
  8021c7:	83 ec 24             	sub    $0x24,%esp
  8021ca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d4:	89 1c 24             	mov    %ebx,(%esp)
  8021d7:	e8 4f fc ff ff       	call   801e2b <fd_lookup>
  8021dc:	89 c2                	mov    %eax,%edx
  8021de:	85 d2                	test   %edx,%edx
  8021e0:	78 68                	js     80224a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ec:	8b 00                	mov    (%eax),%eax
  8021ee:	89 04 24             	mov    %eax,(%esp)
  8021f1:	e8 8b fc ff ff       	call   801e81 <dev_lookup>
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	78 50                	js     80224a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802201:	75 23                	jne    802226 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802203:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802208:	8b 40 48             	mov    0x48(%eax),%eax
  80220b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80220f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802213:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  80221a:	e8 26 ec ff ff       	call   800e45 <cprintf>
		return -E_INVAL;
  80221f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802224:	eb 24                	jmp    80224a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802226:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802229:	8b 52 0c             	mov    0xc(%edx),%edx
  80222c:	85 d2                	test   %edx,%edx
  80222e:	74 15                	je     802245 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802230:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80223a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	ff d2                	call   *%edx
  802243:	eb 05                	jmp    80224a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802245:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80224a:	83 c4 24             	add    $0x24,%esp
  80224d:	5b                   	pop    %ebx
  80224e:	5d                   	pop    %ebp
  80224f:	c3                   	ret    

00802250 <seek>:

int
seek(int fdnum, off_t offset)
{
  802250:	55                   	push   %ebp
  802251:	89 e5                	mov    %esp,%ebp
  802253:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802256:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802259:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	89 04 24             	mov    %eax,(%esp)
  802263:	e8 c3 fb ff ff       	call   801e2b <fd_lookup>
  802268:	85 c0                	test   %eax,%eax
  80226a:	78 0e                	js     80227a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80226c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80226f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802275:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80227a:	c9                   	leave  
  80227b:	c3                   	ret    

0080227c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
  80227f:	53                   	push   %ebx
  802280:	83 ec 24             	sub    $0x24,%esp
  802283:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802286:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802289:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228d:	89 1c 24             	mov    %ebx,(%esp)
  802290:	e8 96 fb ff ff       	call   801e2b <fd_lookup>
  802295:	89 c2                	mov    %eax,%edx
  802297:	85 d2                	test   %edx,%edx
  802299:	78 61                	js     8022fc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80229b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80229e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022a5:	8b 00                	mov    (%eax),%eax
  8022a7:	89 04 24             	mov    %eax,(%esp)
  8022aa:	e8 d2 fb ff ff       	call   801e81 <dev_lookup>
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 49                	js     8022fc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8022ba:	75 23                	jne    8022df <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8022bc:	a1 0c 90 80 00       	mov    0x80900c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8022c1:	8b 40 48             	mov    0x48(%eax),%eax
  8022c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cc:	c7 04 24 d4 34 80 00 	movl   $0x8034d4,(%esp)
  8022d3:	e8 6d eb ff ff       	call   800e45 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8022d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8022dd:	eb 1d                	jmp    8022fc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8022df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e2:	8b 52 18             	mov    0x18(%edx),%edx
  8022e5:	85 d2                	test   %edx,%edx
  8022e7:	74 0e                	je     8022f7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ec:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022f0:	89 04 24             	mov    %eax,(%esp)
  8022f3:	ff d2                	call   *%edx
  8022f5:	eb 05                	jmp    8022fc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8022f7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8022fc:	83 c4 24             	add    $0x24,%esp
  8022ff:	5b                   	pop    %ebx
  802300:	5d                   	pop    %ebp
  802301:	c3                   	ret    

00802302 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	53                   	push   %ebx
  802306:	83 ec 24             	sub    $0x24,%esp
  802309:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80230c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80230f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802313:	8b 45 08             	mov    0x8(%ebp),%eax
  802316:	89 04 24             	mov    %eax,(%esp)
  802319:	e8 0d fb ff ff       	call   801e2b <fd_lookup>
  80231e:	89 c2                	mov    %eax,%edx
  802320:	85 d2                	test   %edx,%edx
  802322:	78 52                	js     802376 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802327:	89 44 24 04          	mov    %eax,0x4(%esp)
  80232b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232e:	8b 00                	mov    (%eax),%eax
  802330:	89 04 24             	mov    %eax,(%esp)
  802333:	e8 49 fb ff ff       	call   801e81 <dev_lookup>
  802338:	85 c0                	test   %eax,%eax
  80233a:	78 3a                	js     802376 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802343:	74 2c                	je     802371 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802345:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802348:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80234f:	00 00 00 
	stat->st_isdir = 0;
  802352:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802359:	00 00 00 
	stat->st_dev = dev;
  80235c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802362:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802366:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802369:	89 14 24             	mov    %edx,(%esp)
  80236c:	ff 50 14             	call   *0x14(%eax)
  80236f:	eb 05                	jmp    802376 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802371:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  802376:	83 c4 24             	add    $0x24,%esp
  802379:	5b                   	pop    %ebx
  80237a:	5d                   	pop    %ebp
  80237b:	c3                   	ret    

0080237c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	56                   	push   %esi
  802380:	53                   	push   %ebx
  802381:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802384:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80238b:	00 
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	89 04 24             	mov    %eax,(%esp)
  802392:	e8 e1 01 00 00       	call   802578 <open>
  802397:	89 c3                	mov    %eax,%ebx
  802399:	85 db                	test   %ebx,%ebx
  80239b:	78 1b                	js     8023b8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a4:	89 1c 24             	mov    %ebx,(%esp)
  8023a7:	e8 56 ff ff ff       	call   802302 <fstat>
  8023ac:	89 c6                	mov    %eax,%esi
	close(fd);
  8023ae:	89 1c 24             	mov    %ebx,(%esp)
  8023b1:	e8 bd fb ff ff       	call   801f73 <close>
	return r;
  8023b6:	89 f0                	mov    %esi,%eax
}
  8023b8:	83 c4 10             	add    $0x10,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 10             	sub    $0x10,%esp
  8023c7:	89 c3                	mov    %eax,%ebx
  8023c9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  8023cb:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8023d2:	75 11                	jne    8023e5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8023d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8023db:	e8 59 f9 ff ff       	call   801d39 <ipc_find_env>
  8023e0:	a3 00 90 80 00       	mov    %eax,0x809000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  8023e5:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8023ea:	8b 40 48             	mov    0x48(%eax),%eax
  8023ed:	8b 15 00 a0 80 00    	mov    0x80a000,%edx
  8023f3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ff:	c7 04 24 31 35 80 00 	movl   $0x803531,(%esp)
  802406:	e8 3a ea ff ff       	call   800e45 <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80240b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802412:	00 
  802413:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  80241a:	00 
  80241b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80241f:	a1 00 90 80 00       	mov    0x809000,%eax
  802424:	89 04 24             	mov    %eax,(%esp)
  802427:	e8 a7 f8 ff ff       	call   801cd3 <ipc_send>
	cprintf("ipc_send\n");
  80242c:	c7 04 24 47 35 80 00 	movl   $0x803547,(%esp)
  802433:	e8 0d ea ff ff       	call   800e45 <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  802438:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80243f:	00 
  802440:	89 74 24 04          	mov    %esi,0x4(%esp)
  802444:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244b:	e8 1b f8 ff ff       	call   801c6b <ipc_recv>
}
  802450:	83 c4 10             	add    $0x10,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5d                   	pop    %ebp
  802456:	c3                   	ret    

00802457 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802457:	55                   	push   %ebp
  802458:	89 e5                	mov    %esp,%ebp
  80245a:	53                   	push   %ebx
  80245b:	83 ec 14             	sub    $0x14,%esp
  80245e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80246c:	ba 00 00 00 00       	mov    $0x0,%edx
  802471:	b8 05 00 00 00       	mov    $0x5,%eax
  802476:	e8 44 ff ff ff       	call   8023bf <fsipc>
  80247b:	89 c2                	mov    %eax,%edx
  80247d:	85 d2                	test   %edx,%edx
  80247f:	78 2b                	js     8024ac <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802481:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802488:	00 
  802489:	89 1c 24             	mov    %ebx,(%esp)
  80248c:	e8 0a f0 ff ff       	call   80149b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802491:	a1 80 a0 80 00       	mov    0x80a080,%eax
  802496:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80249c:	a1 84 a0 80 00       	mov    0x80a084,%eax
  8024a1:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8024a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ac:	83 c4 14             	add    $0x14,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    

008024b2 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024be:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  8024c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8024c8:	b8 06 00 00 00       	mov    $0x6,%eax
  8024cd:	e8 ed fe ff ff       	call   8023bf <fsipc>
}
  8024d2:	c9                   	leave  
  8024d3:	c3                   	ret    

008024d4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8024d4:	55                   	push   %ebp
  8024d5:	89 e5                	mov    %esp,%ebp
  8024d7:	56                   	push   %esi
  8024d8:	53                   	push   %ebx
  8024d9:	83 ec 10             	sub    $0x10,%esp
  8024dc:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8024df:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  8024ea:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8024f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8024f5:	b8 03 00 00 00       	mov    $0x3,%eax
  8024fa:	e8 c0 fe ff ff       	call   8023bf <fsipc>
  8024ff:	89 c3                	mov    %eax,%ebx
  802501:	85 c0                	test   %eax,%eax
  802503:	78 6a                	js     80256f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802505:	39 c6                	cmp    %eax,%esi
  802507:	73 24                	jae    80252d <devfile_read+0x59>
  802509:	c7 44 24 0c 51 35 80 	movl   $0x803551,0xc(%esp)
  802510:	00 
  802511:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  802518:	00 
  802519:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802520:	00 
  802521:	c7 04 24 58 35 80 00 	movl   $0x803558,(%esp)
  802528:	e8 1f e8 ff ff       	call   800d4c <_panic>
	assert(r <= PGSIZE);
  80252d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802532:	7e 24                	jle    802558 <devfile_read+0x84>
  802534:	c7 44 24 0c 63 35 80 	movl   $0x803563,0xc(%esp)
  80253b:	00 
  80253c:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  802543:	00 
  802544:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  80254b:	00 
  80254c:	c7 04 24 58 35 80 00 	movl   $0x803558,(%esp)
  802553:	e8 f4 e7 ff ff       	call   800d4c <_panic>
	memmove(buf, &fsipcbuf, r);
  802558:	89 44 24 08          	mov    %eax,0x8(%esp)
  80255c:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802563:	00 
  802564:	8b 45 0c             	mov    0xc(%ebp),%eax
  802567:	89 04 24             	mov    %eax,(%esp)
  80256a:	e8 27 f1 ff ff       	call   801696 <memmove>
	return r;
}
  80256f:	89 d8                	mov    %ebx,%eax
  802571:	83 c4 10             	add    $0x10,%esp
  802574:	5b                   	pop    %ebx
  802575:	5e                   	pop    %esi
  802576:	5d                   	pop    %ebp
  802577:	c3                   	ret    

00802578 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	53                   	push   %ebx
  80257c:	83 ec 24             	sub    $0x24,%esp
  80257f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802582:	89 1c 24             	mov    %ebx,(%esp)
  802585:	e8 b6 ee ff ff       	call   801440 <strlen>
  80258a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80258f:	7f 60                	jg     8025f1 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  802591:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802594:	89 04 24             	mov    %eax,(%esp)
  802597:	e8 1b f8 ff ff       	call   801db7 <fd_alloc>
  80259c:	89 c2                	mov    %eax,%edx
  80259e:	85 d2                	test   %edx,%edx
  8025a0:	78 54                	js     8025f6 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8025a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025a6:	c7 04 24 00 a0 80 00 	movl   $0x80a000,(%esp)
  8025ad:	e8 e9 ee ff ff       	call   80149b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8025b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b5:	a3 00 a4 80 00       	mov    %eax,0x80a400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8025ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c2:	e8 f8 fd ff ff       	call   8023bf <fsipc>
  8025c7:	89 c3                	mov    %eax,%ebx
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	79 17                	jns    8025e4 <open+0x6c>
		fd_close(fd, 0);
  8025cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8025d4:	00 
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	89 04 24             	mov    %eax,(%esp)
  8025db:	e8 12 f9 ff ff       	call   801ef2 <fd_close>
		return r;
  8025e0:	89 d8                	mov    %ebx,%eax
  8025e2:	eb 12                	jmp    8025f6 <open+0x7e>
	}
	return fd2num(fd);
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	89 04 24             	mov    %eax,(%esp)
  8025ea:	e8 a1 f7 ff ff       	call   801d90 <fd2num>
  8025ef:	eb 05                	jmp    8025f6 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8025f1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8025f6:	83 c4 24             	add    $0x24,%esp
  8025f9:	5b                   	pop    %ebx
  8025fa:	5d                   	pop    %ebp
  8025fb:	c3                   	ret    

008025fc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802602:	89 d0                	mov    %edx,%eax
  802604:	c1 e8 16             	shr    $0x16,%eax
  802607:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80260e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802613:	f6 c1 01             	test   $0x1,%cl
  802616:	74 1d                	je     802635 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802618:	c1 ea 0c             	shr    $0xc,%edx
  80261b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802622:	f6 c2 01             	test   $0x1,%dl
  802625:	74 0e                	je     802635 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802627:	c1 ea 0c             	shr    $0xc,%edx
  80262a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802631:	ef 
  802632:	0f b7 c0             	movzwl %ax,%eax
}
  802635:	5d                   	pop    %ebp
  802636:	c3                   	ret    
  802637:	66 90                	xchg   %ax,%ax
  802639:	66 90                	xchg   %ax,%ax
  80263b:	66 90                	xchg   %ax,%ax
  80263d:	66 90                	xchg   %ax,%ax
  80263f:	90                   	nop

00802640 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	56                   	push   %esi
  802644:	53                   	push   %ebx
  802645:	83 ec 10             	sub    $0x10,%esp
  802648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80264b:	8b 45 08             	mov    0x8(%ebp),%eax
  80264e:	89 04 24             	mov    %eax,(%esp)
  802651:	e8 4a f7 ff ff       	call   801da0 <fd2data>
  802656:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802658:	c7 44 24 04 6f 35 80 	movl   $0x80356f,0x4(%esp)
  80265f:	00 
  802660:	89 1c 24             	mov    %ebx,(%esp)
  802663:	e8 33 ee ff ff       	call   80149b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802668:	8b 46 04             	mov    0x4(%esi),%eax
  80266b:	2b 06                	sub    (%esi),%eax
  80266d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802673:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80267a:	00 00 00 
	stat->st_dev = &devpipe;
  80267d:	c7 83 88 00 00 00 60 	movl   $0x808060,0x88(%ebx)
  802684:	80 80 00 
	return 0;
}
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	83 c4 10             	add    $0x10,%esp
  80268f:	5b                   	pop    %ebx
  802690:	5e                   	pop    %esi
  802691:	5d                   	pop    %ebp
  802692:	c3                   	ret    

00802693 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802693:	55                   	push   %ebp
  802694:	89 e5                	mov    %esp,%ebp
  802696:	53                   	push   %ebx
  802697:	83 ec 14             	sub    $0x14,%esp
  80269a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80269d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a8:	e8 43 f3 ff ff       	call   8019f0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026ad:	89 1c 24             	mov    %ebx,(%esp)
  8026b0:	e8 eb f6 ff ff       	call   801da0 <fd2data>
  8026b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c0:	e8 2b f3 ff ff       	call   8019f0 <sys_page_unmap>
}
  8026c5:	83 c4 14             	add    $0x14,%esp
  8026c8:	5b                   	pop    %ebx
  8026c9:	5d                   	pop    %ebp
  8026ca:	c3                   	ret    

008026cb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	57                   	push   %edi
  8026cf:	56                   	push   %esi
  8026d0:	53                   	push   %ebx
  8026d1:	83 ec 2c             	sub    $0x2c,%esp
  8026d4:	89 c6                	mov    %eax,%esi
  8026d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8026d9:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8026de:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026e1:	89 34 24             	mov    %esi,(%esp)
  8026e4:	e8 13 ff ff ff       	call   8025fc <pageref>
  8026e9:	89 c7                	mov    %eax,%edi
  8026eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ee:	89 04 24             	mov    %eax,(%esp)
  8026f1:	e8 06 ff ff ff       	call   8025fc <pageref>
  8026f6:	39 c7                	cmp    %eax,%edi
  8026f8:	0f 94 c2             	sete   %dl
  8026fb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8026fe:	8b 0d 0c 90 80 00    	mov    0x80900c,%ecx
  802704:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802707:	39 fb                	cmp    %edi,%ebx
  802709:	74 21                	je     80272c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80270b:	84 d2                	test   %dl,%dl
  80270d:	74 ca                	je     8026d9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80270f:	8b 51 58             	mov    0x58(%ecx),%edx
  802712:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802716:	89 54 24 08          	mov    %edx,0x8(%esp)
  80271a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80271e:	c7 04 24 76 35 80 00 	movl   $0x803576,(%esp)
  802725:	e8 1b e7 ff ff       	call   800e45 <cprintf>
  80272a:	eb ad                	jmp    8026d9 <_pipeisclosed+0xe>
	}
}
  80272c:	83 c4 2c             	add    $0x2c,%esp
  80272f:	5b                   	pop    %ebx
  802730:	5e                   	pop    %esi
  802731:	5f                   	pop    %edi
  802732:	5d                   	pop    %ebp
  802733:	c3                   	ret    

00802734 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	57                   	push   %edi
  802738:	56                   	push   %esi
  802739:	53                   	push   %ebx
  80273a:	83 ec 1c             	sub    $0x1c,%esp
  80273d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802740:	89 34 24             	mov    %esi,(%esp)
  802743:	e8 58 f6 ff ff       	call   801da0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802748:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80274c:	74 61                	je     8027af <devpipe_write+0x7b>
  80274e:	89 c3                	mov    %eax,%ebx
  802750:	bf 00 00 00 00       	mov    $0x0,%edi
  802755:	eb 4a                	jmp    8027a1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802757:	89 da                	mov    %ebx,%edx
  802759:	89 f0                	mov    %esi,%eax
  80275b:	e8 6b ff ff ff       	call   8026cb <_pipeisclosed>
  802760:	85 c0                	test   %eax,%eax
  802762:	75 54                	jne    8027b8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802764:	e8 c1 f1 ff ff       	call   80192a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802769:	8b 43 04             	mov    0x4(%ebx),%eax
  80276c:	8b 0b                	mov    (%ebx),%ecx
  80276e:	8d 51 20             	lea    0x20(%ecx),%edx
  802771:	39 d0                	cmp    %edx,%eax
  802773:	73 e2                	jae    802757 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802775:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802778:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80277c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80277f:	99                   	cltd   
  802780:	c1 ea 1b             	shr    $0x1b,%edx
  802783:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802786:	83 e1 1f             	and    $0x1f,%ecx
  802789:	29 d1                	sub    %edx,%ecx
  80278b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80278f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802793:	83 c0 01             	add    $0x1,%eax
  802796:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802799:	83 c7 01             	add    $0x1,%edi
  80279c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80279f:	74 13                	je     8027b4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8027a4:	8b 0b                	mov    (%ebx),%ecx
  8027a6:	8d 51 20             	lea    0x20(%ecx),%edx
  8027a9:	39 d0                	cmp    %edx,%eax
  8027ab:	73 aa                	jae    802757 <devpipe_write+0x23>
  8027ad:	eb c6                	jmp    802775 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8027b4:	89 f8                	mov    %edi,%eax
  8027b6:	eb 05                	jmp    8027bd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8027b8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8027bd:	83 c4 1c             	add    $0x1c,%esp
  8027c0:	5b                   	pop    %ebx
  8027c1:	5e                   	pop    %esi
  8027c2:	5f                   	pop    %edi
  8027c3:	5d                   	pop    %ebp
  8027c4:	c3                   	ret    

008027c5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027c5:	55                   	push   %ebp
  8027c6:	89 e5                	mov    %esp,%ebp
  8027c8:	57                   	push   %edi
  8027c9:	56                   	push   %esi
  8027ca:	53                   	push   %ebx
  8027cb:	83 ec 1c             	sub    $0x1c,%esp
  8027ce:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027d1:	89 3c 24             	mov    %edi,(%esp)
  8027d4:	e8 c7 f5 ff ff       	call   801da0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027dd:	74 54                	je     802833 <devpipe_read+0x6e>
  8027df:	89 c3                	mov    %eax,%ebx
  8027e1:	be 00 00 00 00       	mov    $0x0,%esi
  8027e6:	eb 3e                	jmp    802826 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027e8:	89 f0                	mov    %esi,%eax
  8027ea:	eb 55                	jmp    802841 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027ec:	89 da                	mov    %ebx,%edx
  8027ee:	89 f8                	mov    %edi,%eax
  8027f0:	e8 d6 fe ff ff       	call   8026cb <_pipeisclosed>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	75 43                	jne    80283c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027f9:	e8 2c f1 ff ff       	call   80192a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027fe:	8b 03                	mov    (%ebx),%eax
  802800:	3b 43 04             	cmp    0x4(%ebx),%eax
  802803:	74 e7                	je     8027ec <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802805:	99                   	cltd   
  802806:	c1 ea 1b             	shr    $0x1b,%edx
  802809:	01 d0                	add    %edx,%eax
  80280b:	83 e0 1f             	and    $0x1f,%eax
  80280e:	29 d0                	sub    %edx,%eax
  802810:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802815:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802818:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80281b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80281e:	83 c6 01             	add    $0x1,%esi
  802821:	3b 75 10             	cmp    0x10(%ebp),%esi
  802824:	74 12                	je     802838 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802826:	8b 03                	mov    (%ebx),%eax
  802828:	3b 43 04             	cmp    0x4(%ebx),%eax
  80282b:	75 d8                	jne    802805 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80282d:	85 f6                	test   %esi,%esi
  80282f:	75 b7                	jne    8027e8 <devpipe_read+0x23>
  802831:	eb b9                	jmp    8027ec <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802833:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802838:	89 f0                	mov    %esi,%eax
  80283a:	eb 05                	jmp    802841 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802841:	83 c4 1c             	add    $0x1c,%esp
  802844:	5b                   	pop    %ebx
  802845:	5e                   	pop    %esi
  802846:	5f                   	pop    %edi
  802847:	5d                   	pop    %ebp
  802848:	c3                   	ret    

00802849 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	56                   	push   %esi
  80284d:	53                   	push   %ebx
  80284e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802851:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802854:	89 04 24             	mov    %eax,(%esp)
  802857:	e8 5b f5 ff ff       	call   801db7 <fd_alloc>
  80285c:	89 c2                	mov    %eax,%edx
  80285e:	85 d2                	test   %edx,%edx
  802860:	0f 88 4d 01 00 00    	js     8029b3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802866:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80286d:	00 
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	89 44 24 04          	mov    %eax,0x4(%esp)
  802875:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80287c:	e8 c8 f0 ff ff       	call   801949 <sys_page_alloc>
  802881:	89 c2                	mov    %eax,%edx
  802883:	85 d2                	test   %edx,%edx
  802885:	0f 88 28 01 00 00    	js     8029b3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80288b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80288e:	89 04 24             	mov    %eax,(%esp)
  802891:	e8 21 f5 ff ff       	call   801db7 <fd_alloc>
  802896:	89 c3                	mov    %eax,%ebx
  802898:	85 c0                	test   %eax,%eax
  80289a:	0f 88 fe 00 00 00    	js     80299e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028a7:	00 
  8028a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b6:	e8 8e f0 ff ff       	call   801949 <sys_page_alloc>
  8028bb:	89 c3                	mov    %eax,%ebx
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	0f 88 d9 00 00 00    	js     80299e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c8:	89 04 24             	mov    %eax,(%esp)
  8028cb:	e8 d0 f4 ff ff       	call   801da0 <fd2data>
  8028d0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028d9:	00 
  8028da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e5:	e8 5f f0 ff ff       	call   801949 <sys_page_alloc>
  8028ea:	89 c3                	mov    %eax,%ebx
  8028ec:	85 c0                	test   %eax,%eax
  8028ee:	0f 88 97 00 00 00    	js     80298b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	89 04 24             	mov    %eax,(%esp)
  8028fa:	e8 a1 f4 ff ff       	call   801da0 <fd2data>
  8028ff:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802906:	00 
  802907:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80290b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802912:	00 
  802913:	89 74 24 04          	mov    %esi,0x4(%esp)
  802917:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291e:	e8 7a f0 ff ff       	call   80199d <sys_page_map>
  802923:	89 c3                	mov    %eax,%ebx
  802925:	85 c0                	test   %eax,%eax
  802927:	78 52                	js     80297b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802929:	8b 15 60 80 80 00    	mov    0x808060,%edx
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80293e:	8b 15 60 80 80 00    	mov    0x808060,%edx
  802944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802947:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802956:	89 04 24             	mov    %eax,(%esp)
  802959:	e8 32 f4 ff ff       	call   801d90 <fd2num>
  80295e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802961:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	89 04 24             	mov    %eax,(%esp)
  802969:	e8 22 f4 ff ff       	call   801d90 <fd2num>
  80296e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802971:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	eb 38                	jmp    8029b3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80297b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80297f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802986:	e8 65 f0 ff ff       	call   8019f0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802992:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802999:	e8 52 f0 ff ff       	call   8019f0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80299e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ac:	e8 3f f0 ff ff       	call   8019f0 <sys_page_unmap>
  8029b1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8029b3:	83 c4 30             	add    $0x30,%esp
  8029b6:	5b                   	pop    %ebx
  8029b7:	5e                   	pop    %esi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    

008029ba <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8029c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	89 04 24             	mov    %eax,(%esp)
  8029cd:	e8 59 f4 ff ff       	call   801e2b <fd_lookup>
  8029d2:	89 c2                	mov    %eax,%edx
  8029d4:	85 d2                	test   %edx,%edx
  8029d6:	78 15                	js     8029ed <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	89 04 24             	mov    %eax,(%esp)
  8029de:	e8 bd f3 ff ff       	call   801da0 <fd2data>
	return _pipeisclosed(fd, p);
  8029e3:	89 c2                	mov    %eax,%edx
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	e8 de fc ff ff       	call   8026cb <_pipeisclosed>
}
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    
  8029ef:	90                   	nop

008029f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    

008029fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a00:	c7 44 24 04 8e 35 80 	movl   $0x80358e,0x4(%esp)
  802a07:	00 
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	89 04 24             	mov    %eax,(%esp)
  802a0e:	e8 88 ea ff ff       	call   80149b <strcpy>
	return 0;
}
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	57                   	push   %edi
  802a1e:	56                   	push   %esi
  802a1f:	53                   	push   %ebx
  802a20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a2a:	74 4a                	je     802a76 <devcons_write+0x5c>
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a31:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a36:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a3c:	8b 75 10             	mov    0x10(%ebp),%esi
  802a3f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802a41:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a44:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802a49:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a4c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802a50:	03 45 0c             	add    0xc(%ebp),%eax
  802a53:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a57:	89 3c 24             	mov    %edi,(%esp)
  802a5a:	e8 37 ec ff ff       	call   801696 <memmove>
		sys_cputs(buf, m);
  802a5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a63:	89 3c 24             	mov    %edi,(%esp)
  802a66:	e8 11 ee ff ff       	call   80187c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a6b:	01 f3                	add    %esi,%ebx
  802a6d:	89 d8                	mov    %ebx,%eax
  802a6f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802a72:	72 c8                	jb     802a3c <devcons_write+0x22>
  802a74:	eb 05                	jmp    802a7b <devcons_write+0x61>
  802a76:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a7b:	89 d8                	mov    %ebx,%eax
  802a7d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a83:	5b                   	pop    %ebx
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    

00802a88 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a88:	55                   	push   %ebp
  802a89:	89 e5                	mov    %esp,%ebp
  802a8b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  802a8e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802a93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a97:	75 07                	jne    802aa0 <devcons_read+0x18>
  802a99:	eb 28                	jmp    802ac3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a9b:	e8 8a ee ff ff       	call   80192a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802aa0:	e8 f5 ed ff ff       	call   80189a <sys_cgetc>
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 f2                	je     802a9b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	78 16                	js     802ac3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802aad:	83 f8 04             	cmp    $0x4,%eax
  802ab0:	74 0c                	je     802abe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802ab2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab5:	88 02                	mov    %al,(%edx)
	return 1;
  802ab7:	b8 01 00 00 00       	mov    $0x1,%eax
  802abc:	eb 05                	jmp    802ac3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  802abe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802ac3:	c9                   	leave  
  802ac4:	c3                   	ret    

00802ac5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ac5:	55                   	push   %ebp
  802ac6:	89 e5                	mov    %esp,%ebp
  802ac8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ad1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ad8:	00 
  802ad9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802adc:	89 04 24             	mov    %eax,(%esp)
  802adf:	e8 98 ed ff ff       	call   80187c <sys_cputs>
}
  802ae4:	c9                   	leave  
  802ae5:	c3                   	ret    

00802ae6 <getchar>:

int
getchar(void)
{
  802ae6:	55                   	push   %ebp
  802ae7:	89 e5                	mov    %esp,%ebp
  802ae9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802aec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802af3:	00 
  802af4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  802afb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b02:	e8 cf f5 ff ff       	call   8020d6 <read>
	if (r < 0)
  802b07:	85 c0                	test   %eax,%eax
  802b09:	78 0f                	js     802b1a <getchar+0x34>
		return r;
	if (r < 1)
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	7e 06                	jle    802b15 <getchar+0x2f>
		return -E_EOF;
	return c;
  802b0f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802b13:	eb 05                	jmp    802b1a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802b15:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802b1a:	c9                   	leave  
  802b1b:	c3                   	ret    

00802b1c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b1c:	55                   	push   %ebp
  802b1d:	89 e5                	mov    %esp,%ebp
  802b1f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b22:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	89 04 24             	mov    %eax,(%esp)
  802b2f:	e8 f7 f2 ff ff       	call   801e2b <fd_lookup>
  802b34:	85 c0                	test   %eax,%eax
  802b36:	78 11                	js     802b49 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802b41:	39 10                	cmp    %edx,(%eax)
  802b43:	0f 94 c0             	sete   %al
  802b46:	0f b6 c0             	movzbl %al,%eax
}
  802b49:	c9                   	leave  
  802b4a:	c3                   	ret    

00802b4b <opencons>:

int
opencons(void)
{
  802b4b:	55                   	push   %ebp
  802b4c:	89 e5                	mov    %esp,%ebp
  802b4e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b54:	89 04 24             	mov    %eax,(%esp)
  802b57:	e8 5b f2 ff ff       	call   801db7 <fd_alloc>
		return r;
  802b5c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	78 40                	js     802ba2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b62:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b69:	00 
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b78:	e8 cc ed ff ff       	call   801949 <sys_page_alloc>
		return r;
  802b7d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b7f:	85 c0                	test   %eax,%eax
  802b81:	78 1f                	js     802ba2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b83:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b98:	89 04 24             	mov    %eax,(%esp)
  802b9b:	e8 f0 f1 ff ff       	call   801d90 <fd2num>
  802ba0:	89 c2                	mov    %eax,%edx
}
  802ba2:	89 d0                	mov    %edx,%eax
  802ba4:	c9                   	leave  
  802ba5:	c3                   	ret    
  802ba6:	66 90                	xchg   %ax,%ax
  802ba8:	66 90                	xchg   %ax,%ax
  802baa:	66 90                	xchg   %ax,%ax
  802bac:	66 90                	xchg   %ax,%ax
  802bae:	66 90                	xchg   %ax,%ax

00802bb0 <__udivdi3>:
  802bb0:	55                   	push   %ebp
  802bb1:	57                   	push   %edi
  802bb2:	56                   	push   %esi
  802bb3:	83 ec 0c             	sub    $0xc,%esp
  802bb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802bbe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802bc2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bcc:	89 ea                	mov    %ebp,%edx
  802bce:	89 0c 24             	mov    %ecx,(%esp)
  802bd1:	75 2d                	jne    802c00 <__udivdi3+0x50>
  802bd3:	39 e9                	cmp    %ebp,%ecx
  802bd5:	77 61                	ja     802c38 <__udivdi3+0x88>
  802bd7:	85 c9                	test   %ecx,%ecx
  802bd9:	89 ce                	mov    %ecx,%esi
  802bdb:	75 0b                	jne    802be8 <__udivdi3+0x38>
  802bdd:	b8 01 00 00 00       	mov    $0x1,%eax
  802be2:	31 d2                	xor    %edx,%edx
  802be4:	f7 f1                	div    %ecx
  802be6:	89 c6                	mov    %eax,%esi
  802be8:	31 d2                	xor    %edx,%edx
  802bea:	89 e8                	mov    %ebp,%eax
  802bec:	f7 f6                	div    %esi
  802bee:	89 c5                	mov    %eax,%ebp
  802bf0:	89 f8                	mov    %edi,%eax
  802bf2:	f7 f6                	div    %esi
  802bf4:	89 ea                	mov    %ebp,%edx
  802bf6:	83 c4 0c             	add    $0xc,%esp
  802bf9:	5e                   	pop    %esi
  802bfa:	5f                   	pop    %edi
  802bfb:	5d                   	pop    %ebp
  802bfc:	c3                   	ret    
  802bfd:	8d 76 00             	lea    0x0(%esi),%esi
  802c00:	39 e8                	cmp    %ebp,%eax
  802c02:	77 24                	ja     802c28 <__udivdi3+0x78>
  802c04:	0f bd e8             	bsr    %eax,%ebp
  802c07:	83 f5 1f             	xor    $0x1f,%ebp
  802c0a:	75 3c                	jne    802c48 <__udivdi3+0x98>
  802c0c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c10:	39 34 24             	cmp    %esi,(%esp)
  802c13:	0f 86 9f 00 00 00    	jbe    802cb8 <__udivdi3+0x108>
  802c19:	39 d0                	cmp    %edx,%eax
  802c1b:	0f 82 97 00 00 00    	jb     802cb8 <__udivdi3+0x108>
  802c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802c28:	31 d2                	xor    %edx,%edx
  802c2a:	31 c0                	xor    %eax,%eax
  802c2c:	83 c4 0c             	add    $0xc,%esp
  802c2f:	5e                   	pop    %esi
  802c30:	5f                   	pop    %edi
  802c31:	5d                   	pop    %ebp
  802c32:	c3                   	ret    
  802c33:	90                   	nop
  802c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c38:	89 f8                	mov    %edi,%eax
  802c3a:	f7 f1                	div    %ecx
  802c3c:	31 d2                	xor    %edx,%edx
  802c3e:	83 c4 0c             	add    $0xc,%esp
  802c41:	5e                   	pop    %esi
  802c42:	5f                   	pop    %edi
  802c43:	5d                   	pop    %ebp
  802c44:	c3                   	ret    
  802c45:	8d 76 00             	lea    0x0(%esi),%esi
  802c48:	89 e9                	mov    %ebp,%ecx
  802c4a:	8b 3c 24             	mov    (%esp),%edi
  802c4d:	d3 e0                	shl    %cl,%eax
  802c4f:	89 c6                	mov    %eax,%esi
  802c51:	b8 20 00 00 00       	mov    $0x20,%eax
  802c56:	29 e8                	sub    %ebp,%eax
  802c58:	89 c1                	mov    %eax,%ecx
  802c5a:	d3 ef                	shr    %cl,%edi
  802c5c:	89 e9                	mov    %ebp,%ecx
  802c5e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802c62:	8b 3c 24             	mov    (%esp),%edi
  802c65:	09 74 24 08          	or     %esi,0x8(%esp)
  802c69:	89 d6                	mov    %edx,%esi
  802c6b:	d3 e7                	shl    %cl,%edi
  802c6d:	89 c1                	mov    %eax,%ecx
  802c6f:	89 3c 24             	mov    %edi,(%esp)
  802c72:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c76:	d3 ee                	shr    %cl,%esi
  802c78:	89 e9                	mov    %ebp,%ecx
  802c7a:	d3 e2                	shl    %cl,%edx
  802c7c:	89 c1                	mov    %eax,%ecx
  802c7e:	d3 ef                	shr    %cl,%edi
  802c80:	09 d7                	or     %edx,%edi
  802c82:	89 f2                	mov    %esi,%edx
  802c84:	89 f8                	mov    %edi,%eax
  802c86:	f7 74 24 08          	divl   0x8(%esp)
  802c8a:	89 d6                	mov    %edx,%esi
  802c8c:	89 c7                	mov    %eax,%edi
  802c8e:	f7 24 24             	mull   (%esp)
  802c91:	39 d6                	cmp    %edx,%esi
  802c93:	89 14 24             	mov    %edx,(%esp)
  802c96:	72 30                	jb     802cc8 <__udivdi3+0x118>
  802c98:	8b 54 24 04          	mov    0x4(%esp),%edx
  802c9c:	89 e9                	mov    %ebp,%ecx
  802c9e:	d3 e2                	shl    %cl,%edx
  802ca0:	39 c2                	cmp    %eax,%edx
  802ca2:	73 05                	jae    802ca9 <__udivdi3+0xf9>
  802ca4:	3b 34 24             	cmp    (%esp),%esi
  802ca7:	74 1f                	je     802cc8 <__udivdi3+0x118>
  802ca9:	89 f8                	mov    %edi,%eax
  802cab:	31 d2                	xor    %edx,%edx
  802cad:	e9 7a ff ff ff       	jmp    802c2c <__udivdi3+0x7c>
  802cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cb8:	31 d2                	xor    %edx,%edx
  802cba:	b8 01 00 00 00       	mov    $0x1,%eax
  802cbf:	e9 68 ff ff ff       	jmp    802c2c <__udivdi3+0x7c>
  802cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802ccb:	31 d2                	xor    %edx,%edx
  802ccd:	83 c4 0c             	add    $0xc,%esp
  802cd0:	5e                   	pop    %esi
  802cd1:	5f                   	pop    %edi
  802cd2:	5d                   	pop    %ebp
  802cd3:	c3                   	ret    
  802cd4:	66 90                	xchg   %ax,%ax
  802cd6:	66 90                	xchg   %ax,%ax
  802cd8:	66 90                	xchg   %ax,%ax
  802cda:	66 90                	xchg   %ax,%ax
  802cdc:	66 90                	xchg   %ax,%ax
  802cde:	66 90                	xchg   %ax,%ax

00802ce0 <__umoddi3>:
  802ce0:	55                   	push   %ebp
  802ce1:	57                   	push   %edi
  802ce2:	56                   	push   %esi
  802ce3:	83 ec 14             	sub    $0x14,%esp
  802ce6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802cea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802cee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802cf2:	89 c7                	mov    %eax,%edi
  802cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802cfc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802d00:	89 34 24             	mov    %esi,(%esp)
  802d03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d07:	85 c0                	test   %eax,%eax
  802d09:	89 c2                	mov    %eax,%edx
  802d0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d0f:	75 17                	jne    802d28 <__umoddi3+0x48>
  802d11:	39 fe                	cmp    %edi,%esi
  802d13:	76 4b                	jbe    802d60 <__umoddi3+0x80>
  802d15:	89 c8                	mov    %ecx,%eax
  802d17:	89 fa                	mov    %edi,%edx
  802d19:	f7 f6                	div    %esi
  802d1b:	89 d0                	mov    %edx,%eax
  802d1d:	31 d2                	xor    %edx,%edx
  802d1f:	83 c4 14             	add    $0x14,%esp
  802d22:	5e                   	pop    %esi
  802d23:	5f                   	pop    %edi
  802d24:	5d                   	pop    %ebp
  802d25:	c3                   	ret    
  802d26:	66 90                	xchg   %ax,%ax
  802d28:	39 f8                	cmp    %edi,%eax
  802d2a:	77 54                	ja     802d80 <__umoddi3+0xa0>
  802d2c:	0f bd e8             	bsr    %eax,%ebp
  802d2f:	83 f5 1f             	xor    $0x1f,%ebp
  802d32:	75 5c                	jne    802d90 <__umoddi3+0xb0>
  802d34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d38:	39 3c 24             	cmp    %edi,(%esp)
  802d3b:	0f 87 e7 00 00 00    	ja     802e28 <__umoddi3+0x148>
  802d41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802d45:	29 f1                	sub    %esi,%ecx
  802d47:	19 c7                	sbb    %eax,%edi
  802d49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802d4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802d51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802d55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802d59:	83 c4 14             	add    $0x14,%esp
  802d5c:	5e                   	pop    %esi
  802d5d:	5f                   	pop    %edi
  802d5e:	5d                   	pop    %ebp
  802d5f:	c3                   	ret    
  802d60:	85 f6                	test   %esi,%esi
  802d62:	89 f5                	mov    %esi,%ebp
  802d64:	75 0b                	jne    802d71 <__umoddi3+0x91>
  802d66:	b8 01 00 00 00       	mov    $0x1,%eax
  802d6b:	31 d2                	xor    %edx,%edx
  802d6d:	f7 f6                	div    %esi
  802d6f:	89 c5                	mov    %eax,%ebp
  802d71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802d75:	31 d2                	xor    %edx,%edx
  802d77:	f7 f5                	div    %ebp
  802d79:	89 c8                	mov    %ecx,%eax
  802d7b:	f7 f5                	div    %ebp
  802d7d:	eb 9c                	jmp    802d1b <__umoddi3+0x3b>
  802d7f:	90                   	nop
  802d80:	89 c8                	mov    %ecx,%eax
  802d82:	89 fa                	mov    %edi,%edx
  802d84:	83 c4 14             	add    $0x14,%esp
  802d87:	5e                   	pop    %esi
  802d88:	5f                   	pop    %edi
  802d89:	5d                   	pop    %ebp
  802d8a:	c3                   	ret    
  802d8b:	90                   	nop
  802d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d90:	8b 04 24             	mov    (%esp),%eax
  802d93:	be 20 00 00 00       	mov    $0x20,%esi
  802d98:	89 e9                	mov    %ebp,%ecx
  802d9a:	29 ee                	sub    %ebp,%esi
  802d9c:	d3 e2                	shl    %cl,%edx
  802d9e:	89 f1                	mov    %esi,%ecx
  802da0:	d3 e8                	shr    %cl,%eax
  802da2:	89 e9                	mov    %ebp,%ecx
  802da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802da8:	8b 04 24             	mov    (%esp),%eax
  802dab:	09 54 24 04          	or     %edx,0x4(%esp)
  802daf:	89 fa                	mov    %edi,%edx
  802db1:	d3 e0                	shl    %cl,%eax
  802db3:	89 f1                	mov    %esi,%ecx
  802db5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802db9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802dbd:	d3 ea                	shr    %cl,%edx
  802dbf:	89 e9                	mov    %ebp,%ecx
  802dc1:	d3 e7                	shl    %cl,%edi
  802dc3:	89 f1                	mov    %esi,%ecx
  802dc5:	d3 e8                	shr    %cl,%eax
  802dc7:	89 e9                	mov    %ebp,%ecx
  802dc9:	09 f8                	or     %edi,%eax
  802dcb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802dcf:	f7 74 24 04          	divl   0x4(%esp)
  802dd3:	d3 e7                	shl    %cl,%edi
  802dd5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802dd9:	89 d7                	mov    %edx,%edi
  802ddb:	f7 64 24 08          	mull   0x8(%esp)
  802ddf:	39 d7                	cmp    %edx,%edi
  802de1:	89 c1                	mov    %eax,%ecx
  802de3:	89 14 24             	mov    %edx,(%esp)
  802de6:	72 2c                	jb     802e14 <__umoddi3+0x134>
  802de8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802dec:	72 22                	jb     802e10 <__umoddi3+0x130>
  802dee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802df2:	29 c8                	sub    %ecx,%eax
  802df4:	19 d7                	sbb    %edx,%edi
  802df6:	89 e9                	mov    %ebp,%ecx
  802df8:	89 fa                	mov    %edi,%edx
  802dfa:	d3 e8                	shr    %cl,%eax
  802dfc:	89 f1                	mov    %esi,%ecx
  802dfe:	d3 e2                	shl    %cl,%edx
  802e00:	89 e9                	mov    %ebp,%ecx
  802e02:	d3 ef                	shr    %cl,%edi
  802e04:	09 d0                	or     %edx,%eax
  802e06:	89 fa                	mov    %edi,%edx
  802e08:	83 c4 14             	add    $0x14,%esp
  802e0b:	5e                   	pop    %esi
  802e0c:	5f                   	pop    %edi
  802e0d:	5d                   	pop    %ebp
  802e0e:	c3                   	ret    
  802e0f:	90                   	nop
  802e10:	39 d7                	cmp    %edx,%edi
  802e12:	75 da                	jne    802dee <__umoddi3+0x10e>
  802e14:	8b 14 24             	mov    (%esp),%edx
  802e17:	89 c1                	mov    %eax,%ecx
  802e19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802e1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802e21:	eb cb                	jmp    802dee <__umoddi3+0x10e>
  802e23:	90                   	nop
  802e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802e2c:	0f 82 0f ff ff ff    	jb     802d41 <__umoddi3+0x61>
  802e32:	e9 1a ff ff ff       	jmp    802d51 <__umoddi3+0x71>
