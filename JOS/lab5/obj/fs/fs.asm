
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
  80002c:	e8 ab 0b 00 00       	call   800bdc <libmain>
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
  8000bb:	c7 04 24 40 2d 80 00 	movl   $0x802d40,(%esp)
  8000c2:	e8 9f 0c 00 00       	call   800d66 <cprintf>
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
  8000dd:	c7 44 24 08 57 2d 80 	movl   $0x802d57,0x8(%esp)
  8000e4:	00 
  8000e5:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000ec:	00 
  8000ed:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  8000f4:	e8 74 0b 00 00       	call   800c6d <_panic>
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
  80011a:	c7 44 24 0c 70 2d 80 	movl   $0x802d70,0xc(%esp)
  800121:	00 
  800122:	c7 44 24 08 7d 2d 80 	movl   $0x802d7d,0x8(%esp)
  800129:	00 
  80012a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  800139:	e8 2f 0b 00 00       	call   800c6d <_panic>

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
  8001e4:	c7 44 24 0c 70 2d 80 	movl   $0x802d70,0xc(%esp)
  8001eb:	00 
  8001ec:	c7 44 24 08 7d 2d 80 	movl   $0x802d7d,0x8(%esp)
  8001f3:	00 
  8001f4:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8001fb:	00 
  8001fc:	c7 04 24 67 2d 80 00 	movl   $0x802d67,(%esp)
  800203:	e8 65 0a 00 00       	call   800c6d <_panic>

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
  8002c4:	c7 44 24 08 94 2d 80 	movl   $0x802d94,0x8(%esp)
  8002cb:	00 
  8002cc:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  8002d3:	00 
  8002d4:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  8002db:	e8 8d 09 00 00       	call   800c6d <_panic>
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
  8002f2:	c7 44 24 08 c4 2d 80 	movl   $0x802dc4,0x8(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  800301:	00 
  800302:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  800309:	e8 5f 09 00 00       	call   800c6d <_panic>
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
  800327:	e8 3d 15 00 00       	call   801869 <sys_page_alloc>
  80032c:	85 c0                	test   %eax,%eax
  80032e:	79 20                	jns    800350 <bc_pgfault+0xbc>
		panic("bc_pgfault:sys_page_alloc:%e", err_code);
  800330:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800334:	c7 44 24 08 12 2e 80 	movl   $0x802e12,0x8(%esp)
  80033b:	00 
  80033c:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  800343:	00 
  800344:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  80034b:	e8 1d 09 00 00       	call   800c6d <_panic>
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
  800371:	c7 44 24 08 2f 2e 80 	movl   $0x802e2f,0x8(%esp)
  800378:	00 
  800379:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800380:	00 
  800381:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  800388:	e8 e0 08 00 00       	call   800c6d <_panic>
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
  8003b3:	c7 44 24 08 e8 2d 80 	movl   $0x802de8,0x8(%esp)
  8003ba:	00 
  8003bb:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 0a 2e 80 00 	movl   $0x802e0a,(%esp)
  8003ca:	e8 9e 08 00 00       	call   800c6d <_panic>
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
  8003e9:	e8 e3 16 00 00       	call   801ad1 <set_pgfault_handler>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8003ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003f5:	e8 99 ff ff ff       	call   800393 <diskaddr>
  8003fa:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800401:	00 
  800402:	89 44 24 04          	mov    %eax,0x4(%esp)
  800406:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040c:	89 04 24             	mov    %eax,(%esp)
  80040f:	e8 a2 11 00 00       	call   8015b6 <memmove>
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
  800433:	c7 44 24 08 43 2e 80 	movl   $0x802e43,0x8(%esp)
  80043a:	00 
  80043b:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  800442:	00 
  800443:	c7 04 24 60 2e 80 00 	movl   $0x802e60,(%esp)
  80044a:	e8 1e 08 00 00       	call   800c6d <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  80044f:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800456:	76 1c                	jbe    800474 <check_super+0x54>
		panic("file system is too large");
  800458:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  80045f:	00 
  800460:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800467:	00 
  800468:	c7 04 24 60 2e 80 00 	movl   $0x802e60,(%esp)
  80046f:	e8 f9 07 00 00       	call   800c6d <_panic>

	cprintf("superblock is good\n");
  800474:	c7 04 24 81 2e 80 00 	movl   $0x802e81,(%esp)
  80047b:	e8 e6 08 00 00       	call   800d66 <cprintf>
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
  8005a6:	e8 0b 10 00 00       	call   8015b6 <memmove>
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
  8005e0:	c7 44 24 0c 95 2e 80 	movl   $0x802e95,0xc(%esp)
  8005e7:	00 
  8005e8:	c7 44 24 08 7d 2d 80 	movl   $0x802d7d,0x8(%esp)
  8005ef:	00 
  8005f0:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  8005f7:	00 
  8005f8:	c7 04 24 60 2e 80 00 	movl   $0x802e60,(%esp)
  8005ff:	e8 69 06 00 00       	call   800c6d <_panic>
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
  800672:	e8 0e 0e 00 00       	call   801485 <strcmp>
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
  8007af:	e8 02 0e 00 00       	call   8015b6 <memmove>
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
  800824:	e8 c1 1c 00 00       	call   8024ea <pageref>
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
  800852:	e8 12 10 00 00       	call   801869 <sys_page_alloc>
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
  80088b:	e8 d9 0c 00 00       	call   801569 <memset>
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
  8008d7:	e8 0e 1c 00 00       	call   8024ea <pageref>
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
  80090c:	53                   	push   %ebx
  80090d:	83 ec 24             	sub    $0x24,%esp
  800910:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// so filling in ret will overwrite req.
	//
	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800913:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800916:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091a:	8b 03                	mov    (%ebx),%eax
  80091c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	89 04 24             	mov    %eax,(%esp)
  800926:	e8 86 ff ff ff       	call   8008b1 <openfile_lookup>
  80092b:	89 c2                	mov    %eax,%edx
  80092d:	85 d2                	test   %edx,%edx
  80092f:	78 3d                	js     80096e <serve_read+0x65>
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  800931:	8b 45 f4             	mov    -0xc(%ebp),%eax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  800934:	8b 50 0c             	mov    0xc(%eax),%edx
  800937:	8b 52 04             	mov    0x4(%edx),%edx
  80093a:	89 54 24 0c          	mov    %edx,0xc(%esp)
			   MIN(req->req_n, sizeof ret->ret_buf),
  80093e:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  800945:	ba 00 10 00 00       	mov    $0x1000,%edx
  80094a:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  80094e:	89 54 24 08          	mov    %edx,0x8(%esp)
  800952:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800956:	8b 40 04             	mov    0x4(%eax),%eax
  800959:	89 04 24             	mov    %eax,(%esp)
  80095c:	e8 b6 fd ff ff       	call   800717 <file_read>
  800961:	85 c0                	test   %eax,%eax
  800963:	78 09                	js     80096e <serve_read+0x65>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;

	o->o_fd->fd_offset += r;
  800965:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800968:	8b 52 0c             	mov    0xc(%edx),%edx
  80096b:	01 42 04             	add    %eax,0x4(%edx)
	return r;
}
  80096e:	83 c4 24             	add    $0x24,%esp
  800971:	5b                   	pop    %ebx
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	53                   	push   %ebx
  800978:	83 ec 24             	sub    $0x24,%esp
  80097b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80097e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800981:	89 44 24 08          	mov    %eax,0x8(%esp)
  800985:	8b 03                	mov    (%ebx),%eax
  800987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	89 04 24             	mov    %eax,(%esp)
  800991:	e8 1b ff ff ff       	call   8008b1 <openfile_lookup>
  800996:	89 c2                	mov    %eax,%edx
  800998:	85 d2                	test   %edx,%edx
  80099a:	78 3f                	js     8009db <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  80099c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80099f:	8b 40 04             	mov    0x4(%eax),%eax
  8009a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a6:	89 1c 24             	mov    %ebx,(%esp)
  8009a9:	e8 0d 0a 00 00       	call   8013bb <strcpy>
	ret->ret_size = o->o_file->f_size;
  8009ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009b1:	8b 50 04             	mov    0x4(%eax),%edx
  8009b4:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8009ba:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8009c0:	8b 40 04             	mov    0x4(%eax),%eax
  8009c3:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8009ca:	0f 94 c0             	sete   %al
  8009cd:	0f b6 c0             	movzbl %al,%eax
  8009d0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8009d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009db:	83 c4 24             	add    $0x24,%esp
  8009de:	5b                   	pop    %ebx
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	56                   	push   %esi
  8009e5:	53                   	push   %ebx
  8009e6:	81 ec 20 04 00 00    	sub    $0x420,%esp
  8009ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8009ef:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  8009f6:	00 
  8009f7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009fb:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800a01:	89 04 24             	mov    %eax,(%esp)
  800a04:	e8 ad 0b 00 00       	call   8015b6 <memmove>
	path[MAXPATHLEN-1] = 0;
  800a09:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  800a0d:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800a13:	89 04 24             	mov    %eax,(%esp)
  800a16:	e8 eb fd ff ff       	call   800806 <openfile_alloc>
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	78 79                	js     800a98 <serve_open+0xb7>
			cprintf("openfile_alloc failed: %e", r);
		return r;
	}
	fileid = r;

	if (req->req_omode != 0) {
  800a1f:	8b b3 00 04 00 00    	mov    0x400(%ebx),%esi
  800a25:	85 f6                	test   %esi,%esi
  800a27:	75 73                	jne    800a9c <serve_open+0xbb>
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
	}

	if ((r = file_open(path, &f)) < 0) {
  800a29:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  800a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a33:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800a39:	89 04 24             	mov    %eax,(%esp)
  800a3c:	e8 f6 fa ff ff       	call   800537 <file_open>
  800a41:	85 c0                	test   %eax,%eax
  800a43:	78 5e                	js     800aa3 <serve_open+0xc2>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  800a45:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
  800a4b:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  800a51:	89 42 04             	mov    %eax,0x4(%edx)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  800a54:	8b 42 0c             	mov    0xc(%edx),%eax
  800a57:	8b 0a                	mov    (%edx),%ecx
  800a59:	89 48 0c             	mov    %ecx,0xc(%eax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  800a5c:	8b 42 0c             	mov    0xc(%edx),%eax
  800a5f:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  800a65:	83 e1 03             	and    $0x3,%ecx
  800a68:	89 48 08             	mov    %ecx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  800a6b:	8b 42 0c             	mov    0xc(%edx),%eax
  800a6e:	8b 15 44 80 80 00    	mov    0x808044,%edx
  800a74:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  800a76:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  800a7c:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800a82:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  800a85:	8b 50 0c             	mov    0xc(%eax),%edx
  800a88:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8b:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  800a96:	eb 0d                	jmp    800aa5 <serve_open+0xc4>

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  800a98:	89 c6                	mov    %eax,%esi
  800a9a:	eb 09                	jmp    800aa5 <serve_open+0xc4>
	fileid = r;

	if (req->req_omode != 0) {
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
  800a9c:	be fd ff ff ff       	mov    $0xfffffffd,%esi
  800aa1:	eb 02                	jmp    800aa5 <serve_open+0xc4>
	}

	if ((r = file_open(path, &f)) < 0) {
		if (debug)
			cprintf("file_open failed: %e", r);
		return r;
  800aa3:	89 c6                	mov    %eax,%esi
	// store its permission in *perm_store
	*pg_store = o->o_fd;
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;

	return 0;
}
  800aa5:	89 f0                	mov    %esi,%eax
  800aa7:	81 c4 20 04 00 00    	add    $0x420,%esp
  800aad:	5b                   	pop    %ebx
  800aae:	5e                   	pop    %esi
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	56                   	push   %esi
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800ab9:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800abc:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  800abf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800ac6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800aca:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad3:	89 34 24             	mov    %esi,(%esp)
  800ad6:	e8 b0 10 00 00       	call   801b8b <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
						req, whom, uvpt[PGNUM(fsreq)], fsreq);
		
		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  800adb:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  800adf:	75 15                	jne    800af6 <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  800ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ae8:	c7 04 24 b4 2e 80 00 	movl   $0x802eb4,(%esp)
  800aef:	e8 72 02 00 00       	call   800d66 <cprintf>
				whom);
			continue; // just leave it hanging...
  800af4:	eb c9                	jmp    800abf <serve+0xe>
		}

		pg = NULL;
  800af6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  800afd:	83 f8 01             	cmp    $0x1,%eax
  800b00:	75 21                	jne    800b23 <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800b02:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800b06:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b09:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b0d:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b19:	89 04 24             	mov    %eax,(%esp)
  800b1c:	e8 c0 fe ff ff       	call   8009e1 <serve_open>
  800b21:	eb 3f                	jmp    800b62 <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  800b23:	83 f8 06             	cmp    $0x6,%eax
  800b26:	77 1e                	ja     800b46 <serve+0x95>
  800b28:	8b 14 85 20 40 80 00 	mov    0x804020(,%eax,4),%edx
  800b2f:	85 d2                	test   %edx,%edx
  800b31:	74 13                	je     800b46 <serve+0x95>
			r = handlers[req](whom, fsreq);
  800b33:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b3f:	89 04 24             	mov    %eax,(%esp)
  800b42:	ff d2                	call   *%edx
  800b44:	eb 1c                	jmp    800b62 <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b49:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b51:	c7 04 24 e4 2e 80 00 	movl   $0x802ee4,(%esp)
  800b58:	e8 09 02 00 00       	call   800d66 <cprintf>
			r = -E_INVAL;
  800b5d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800b62:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800b65:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800b69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b77:	89 04 24             	mov    %eax,(%esp)
  800b7a:	e8 74 10 00 00       	call   801bf3 <ipc_send>
		sys_page_unmap(0, fsreq);
  800b7f:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b8f:	e8 7c 0d 00 00       	call   801910 <sys_page_unmap>
  800b94:	e9 26 ff ff ff       	jmp    800abf <serve+0xe>

00800b99 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800b9f:	c7 05 40 80 80 00 07 	movl   $0x802f07,0x808040
  800ba6:	2f 80 00 
	cprintf("FS is running\n");
  800ba9:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  800bb0:	e8 b1 01 00 00       	call   800d66 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800bb5:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800bba:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800bbf:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800bc1:	c7 04 24 19 2f 80 00 	movl   $0x802f19,(%esp)
  800bc8:	e8 99 01 00 00       	call   800d66 <cprintf>

	serve_init();
  800bcd:	e8 08 fc ff ff       	call   8007da <serve_init>
	fs_init();
  800bd2:	e8 ab f8 ff ff       	call   800482 <fs_init>
	serve();
  800bd7:	e8 d5 fe ff ff       	call   800ab1 <serve>

00800bdc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	56                   	push   %esi
  800be0:	53                   	push   %ebx
  800be1:	83 ec 10             	sub    $0x10,%esp
  800be4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800be7:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800bea:	e8 3c 0c 00 00       	call   80182b <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800bef:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800bf5:	39 c2                	cmp    %eax,%edx
  800bf7:	74 17                	je     800c10 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800bf9:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800bfe:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800c01:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800c07:	8b 49 40             	mov    0x40(%ecx),%ecx
  800c0a:	39 c1                	cmp    %eax,%ecx
  800c0c:	75 18                	jne    800c26 <libmain+0x4a>
  800c0e:	eb 05                	jmp    800c15 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800c15:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800c18:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800c1e:	89 15 0c 90 80 00    	mov    %edx,0x80900c
			break;
  800c24:	eb 0b                	jmp    800c31 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800c26:	83 c2 01             	add    $0x1,%edx
  800c29:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800c2f:	75 cd                	jne    800bfe <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800c31:	85 db                	test   %ebx,%ebx
  800c33:	7e 07                	jle    800c3c <libmain+0x60>
		binaryname = argv[0];
  800c35:	8b 06                	mov    (%esi),%eax
  800c37:	a3 40 80 80 00       	mov    %eax,0x808040

	// call user main routine
	umain(argc, argv);
  800c3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c40:	89 1c 24             	mov    %ebx,(%esp)
  800c43:	e8 51 ff ff ff       	call   800b99 <umain>

	// exit gracefully
	exit();
  800c48:	e8 07 00 00 00       	call   800c54 <exit>
}
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
  800c57:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800c5a:	e8 67 12 00 00       	call   801ec6 <close_all>
	sys_env_destroy(0);
  800c5f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c66:	e8 6e 0b 00 00       	call   8017d9 <sys_env_destroy>
}
  800c6b:	c9                   	leave  
  800c6c:	c3                   	ret    

00800c6d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	56                   	push   %esi
  800c71:	53                   	push   %ebx
  800c72:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800c75:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800c78:	8b 35 40 80 80 00    	mov    0x808040,%esi
  800c7e:	e8 a8 0b 00 00       	call   80182b <sys_getenvid>
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c91:	89 74 24 08          	mov    %esi,0x8(%esp)
  800c95:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c99:	c7 04 24 34 2f 80 00 	movl   $0x802f34,(%esp)
  800ca0:	e8 c1 00 00 00       	call   800d66 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800ca5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	89 04 24             	mov    %eax,(%esp)
  800caf:	e8 51 00 00 00       	call   800d05 <vcprintf>
	cprintf("\n");
  800cb4:	c7 04 24 26 2f 80 00 	movl   $0x802f26,(%esp)
  800cbb:	e8 a6 00 00 00       	call   800d66 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800cc0:	cc                   	int3   
  800cc1:	eb fd                	jmp    800cc0 <_panic+0x53>

00800cc3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 14             	sub    $0x14,%esp
  800cca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800ccd:	8b 13                	mov    (%ebx),%edx
  800ccf:	8d 42 01             	lea    0x1(%edx),%eax
  800cd2:	89 03                	mov    %eax,(%ebx)
  800cd4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cd7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800cdb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ce0:	75 19                	jne    800cfb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800ce2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800ce9:	00 
  800cea:	8d 43 08             	lea    0x8(%ebx),%eax
  800ced:	89 04 24             	mov    %eax,(%esp)
  800cf0:	e8 a7 0a 00 00       	call   80179c <sys_cputs>
		b->idx = 0;
  800cf5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800cfb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800cff:	83 c4 14             	add    $0x14,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800d0e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d15:	00 00 00 
	b.cnt = 0;
  800d18:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800d1f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d3a:	c7 04 24 c3 0c 80 00 	movl   $0x800cc3,(%esp)
  800d41:	e8 ae 01 00 00       	call   800ef4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800d46:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d50:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800d56:	89 04 24             	mov    %eax,(%esp)
  800d59:	e8 3e 0a 00 00       	call   80179c <sys_cputs>

	return b.cnt;
}
  800d5e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d6c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	89 04 24             	mov    %eax,(%esp)
  800d79:	e8 87 ff ff ff       	call   800d05 <vcprintf>
	va_end(ap);

	return cnt;
}
  800d7e:	c9                   	leave  
  800d7f:	c3                   	ret    

00800d80 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 3c             	sub    $0x3c,%esp
  800d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d8c:	89 d7                	mov    %edx,%edi
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d94:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d97:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800d9a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800da5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800da8:	39 f1                	cmp    %esi,%ecx
  800daa:	72 14                	jb     800dc0 <printnum+0x40>
  800dac:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800daf:	76 0f                	jbe    800dc0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800db1:	8b 45 14             	mov    0x14(%ebp),%eax
  800db4:	8d 70 ff             	lea    -0x1(%eax),%esi
  800db7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800dba:	85 f6                	test   %esi,%esi
  800dbc:	7f 60                	jg     800e1e <printnum+0x9e>
  800dbe:	eb 72                	jmp    800e32 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800dc0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800dc3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800dc7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800dca:	8d 51 ff             	lea    -0x1(%ecx),%edx
  800dcd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dd5:	8b 44 24 08          	mov    0x8(%esp),%eax
  800dd9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800ddd:	89 c3                	mov    %eax,%ebx
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800de4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800de7:	89 54 24 08          	mov    %edx,0x8(%esp)
  800deb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800def:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800df2:	89 04 24             	mov    %eax,(%esp)
  800df5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dfc:	e8 9f 1c 00 00       	call   802aa0 <__udivdi3>
  800e01:	89 d9                	mov    %ebx,%ecx
  800e03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800e07:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800e0b:	89 04 24             	mov    %eax,(%esp)
  800e0e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e12:	89 fa                	mov    %edi,%edx
  800e14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e17:	e8 64 ff ff ff       	call   800d80 <printnum>
  800e1c:	eb 14                	jmp    800e32 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e22:	8b 45 18             	mov    0x18(%ebp),%eax
  800e25:	89 04 24             	mov    %eax,(%esp)
  800e28:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e2a:	83 ee 01             	sub    $0x1,%esi
  800e2d:	75 ef                	jne    800e1e <printnum+0x9e>
  800e2f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e32:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e36:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800e3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e40:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e44:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800e48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e4b:	89 04 24             	mov    %eax,(%esp)
  800e4e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e55:	e8 76 1d 00 00       	call   802bd0 <__umoddi3>
  800e5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e5e:	0f be 80 57 2f 80 00 	movsbl 0x802f57(%eax),%eax
  800e65:	89 04 24             	mov    %eax,(%esp)
  800e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e6b:	ff d0                	call   *%eax
}
  800e6d:	83 c4 3c             	add    $0x3c,%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e78:	83 fa 01             	cmp    $0x1,%edx
  800e7b:	7e 0e                	jle    800e8b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800e7d:	8b 10                	mov    (%eax),%edx
  800e7f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800e82:	89 08                	mov    %ecx,(%eax)
  800e84:	8b 02                	mov    (%edx),%eax
  800e86:	8b 52 04             	mov    0x4(%edx),%edx
  800e89:	eb 22                	jmp    800ead <getuint+0x38>
	else if (lflag)
  800e8b:	85 d2                	test   %edx,%edx
  800e8d:	74 10                	je     800e9f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800e8f:	8b 10                	mov    (%eax),%edx
  800e91:	8d 4a 04             	lea    0x4(%edx),%ecx
  800e94:	89 08                	mov    %ecx,(%eax)
  800e96:	8b 02                	mov    (%edx),%eax
  800e98:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9d:	eb 0e                	jmp    800ead <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800e9f:	8b 10                	mov    (%eax),%edx
  800ea1:	8d 4a 04             	lea    0x4(%edx),%ecx
  800ea4:	89 08                	mov    %ecx,(%eax)
  800ea6:	8b 02                	mov    (%edx),%eax
  800ea8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ead:	5d                   	pop    %ebp
  800eae:	c3                   	ret    

00800eaf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800eaf:	55                   	push   %ebp
  800eb0:	89 e5                	mov    %esp,%ebp
  800eb2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800eb5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800eb9:	8b 10                	mov    (%eax),%edx
  800ebb:	3b 50 04             	cmp    0x4(%eax),%edx
  800ebe:	73 0a                	jae    800eca <sprintputch+0x1b>
		*b->buf++ = ch;
  800ec0:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec3:	89 08                	mov    %ecx,(%eax)
  800ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec8:	88 02                	mov    %al,(%edx)
}
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ed2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800ed5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  800edc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eea:	89 04 24             	mov    %eax,(%esp)
  800eed:	e8 02 00 00 00       	call   800ef4 <vprintfmt>
	va_end(ap);
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	57                   	push   %edi
  800ef8:	56                   	push   %esi
  800ef9:	53                   	push   %ebx
  800efa:	83 ec 3c             	sub    $0x3c,%esp
  800efd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f03:	eb 18                	jmp    800f1d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800f05:	85 c0                	test   %eax,%eax
  800f07:	0f 84 c3 03 00 00    	je     8012d0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  800f0d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f11:	89 04 24             	mov    %eax,(%esp)
  800f14:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f17:	89 f3                	mov    %esi,%ebx
  800f19:	eb 02                	jmp    800f1d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f1b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f1d:	8d 73 01             	lea    0x1(%ebx),%esi
  800f20:	0f b6 03             	movzbl (%ebx),%eax
  800f23:	83 f8 25             	cmp    $0x25,%eax
  800f26:	75 dd                	jne    800f05 <vprintfmt+0x11>
  800f28:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  800f2c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800f33:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800f3a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800f41:	ba 00 00 00 00       	mov    $0x0,%edx
  800f46:	eb 1d                	jmp    800f65 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f48:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800f4a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  800f4e:	eb 15                	jmp    800f65 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f50:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f52:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800f56:	eb 0d                	jmp    800f65 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800f58:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f5e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f65:	8d 5e 01             	lea    0x1(%esi),%ebx
  800f68:	0f b6 06             	movzbl (%esi),%eax
  800f6b:	0f b6 c8             	movzbl %al,%ecx
  800f6e:	83 e8 23             	sub    $0x23,%eax
  800f71:	3c 55                	cmp    $0x55,%al
  800f73:	0f 87 2f 03 00 00    	ja     8012a8 <vprintfmt+0x3b4>
  800f79:	0f b6 c0             	movzbl %al,%eax
  800f7c:	ff 24 85 a0 30 80 00 	jmp    *0x8030a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800f83:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800f86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800f89:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800f8d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800f90:	83 f9 09             	cmp    $0x9,%ecx
  800f93:	77 50                	ja     800fe5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f9a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800f9d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800fa0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800fa4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800fa7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800faa:	83 fb 09             	cmp    $0x9,%ebx
  800fad:	76 eb                	jbe    800f9a <vprintfmt+0xa6>
  800faf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800fb2:	eb 33                	jmp    800fe7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb7:	8d 48 04             	lea    0x4(%eax),%ecx
  800fba:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800fbd:	8b 00                	mov    (%eax),%eax
  800fbf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fc2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800fc4:	eb 21                	jmp    800fe7 <vprintfmt+0xf3>
  800fc6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800fc9:	85 c9                	test   %ecx,%ecx
  800fcb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd0:	0f 49 c1             	cmovns %ecx,%eax
  800fd3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fd6:	89 de                	mov    %ebx,%esi
  800fd8:	eb 8b                	jmp    800f65 <vprintfmt+0x71>
  800fda:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800fdc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800fe3:	eb 80                	jmp    800f65 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800fe5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800fe7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800feb:	0f 89 74 ff ff ff    	jns    800f65 <vprintfmt+0x71>
  800ff1:	e9 62 ff ff ff       	jmp    800f58 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ff6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ff9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800ffb:	e9 65 ff ff ff       	jmp    800f65 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801000:	8b 45 14             	mov    0x14(%ebp),%eax
  801003:	8d 50 04             	lea    0x4(%eax),%edx
  801006:	89 55 14             	mov    %edx,0x14(%ebp)
  801009:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80100d:	8b 00                	mov    (%eax),%eax
  80100f:	89 04 24             	mov    %eax,(%esp)
  801012:	ff 55 08             	call   *0x8(%ebp)
			break;
  801015:	e9 03 ff ff ff       	jmp    800f1d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80101a:	8b 45 14             	mov    0x14(%ebp),%eax
  80101d:	8d 50 04             	lea    0x4(%eax),%edx
  801020:	89 55 14             	mov    %edx,0x14(%ebp)
  801023:	8b 00                	mov    (%eax),%eax
  801025:	99                   	cltd   
  801026:	31 d0                	xor    %edx,%eax
  801028:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80102a:	83 f8 0f             	cmp    $0xf,%eax
  80102d:	7f 0b                	jg     80103a <vprintfmt+0x146>
  80102f:	8b 14 85 00 32 80 00 	mov    0x803200(,%eax,4),%edx
  801036:	85 d2                	test   %edx,%edx
  801038:	75 20                	jne    80105a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80103a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80103e:	c7 44 24 08 6f 2f 80 	movl   $0x802f6f,0x8(%esp)
  801045:	00 
  801046:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	89 04 24             	mov    %eax,(%esp)
  801050:	e8 77 fe ff ff       	call   800ecc <printfmt>
  801055:	e9 c3 fe ff ff       	jmp    800f1d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80105a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80105e:	c7 44 24 08 8f 2d 80 	movl   $0x802d8f,0x8(%esp)
  801065:	00 
  801066:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80106a:	8b 45 08             	mov    0x8(%ebp),%eax
  80106d:	89 04 24             	mov    %eax,(%esp)
  801070:	e8 57 fe ff ff       	call   800ecc <printfmt>
  801075:	e9 a3 fe ff ff       	jmp    800f1d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80107a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80107d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801080:	8b 45 14             	mov    0x14(%ebp),%eax
  801083:	8d 50 04             	lea    0x4(%eax),%edx
  801086:	89 55 14             	mov    %edx,0x14(%ebp)
  801089:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80108b:	85 c0                	test   %eax,%eax
  80108d:	ba 68 2f 80 00       	mov    $0x802f68,%edx
  801092:	0f 45 d0             	cmovne %eax,%edx
  801095:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801098:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80109c:	74 04                	je     8010a2 <vprintfmt+0x1ae>
  80109e:	85 f6                	test   %esi,%esi
  8010a0:	7f 19                	jg     8010bb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010a5:	8d 70 01             	lea    0x1(%eax),%esi
  8010a8:	0f b6 10             	movzbl (%eax),%edx
  8010ab:	0f be c2             	movsbl %dl,%eax
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	0f 85 95 00 00 00    	jne    80114b <vprintfmt+0x257>
  8010b6:	e9 85 00 00 00       	jmp    801140 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010bf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8010c2:	89 04 24             	mov    %eax,(%esp)
  8010c5:	e8 b8 02 00 00       	call   801382 <strnlen>
  8010ca:	29 c6                	sub    %eax,%esi
  8010cc:	89 f0                	mov    %esi,%eax
  8010ce:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8010d1:	85 f6                	test   %esi,%esi
  8010d3:	7e cd                	jle    8010a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8010d5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8010d9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010dc:	89 c3                	mov    %eax,%ebx
  8010de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010e2:	89 34 24             	mov    %esi,(%esp)
  8010e5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8010e8:	83 eb 01             	sub    $0x1,%ebx
  8010eb:	75 f1                	jne    8010de <vprintfmt+0x1ea>
  8010ed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8010f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f3:	eb ad                	jmp    8010a2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8010f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8010f9:	74 1e                	je     801119 <vprintfmt+0x225>
  8010fb:	0f be d2             	movsbl %dl,%edx
  8010fe:	83 ea 20             	sub    $0x20,%edx
  801101:	83 fa 5e             	cmp    $0x5e,%edx
  801104:	76 13                	jbe    801119 <vprintfmt+0x225>
					putch('?', putdat);
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801114:	ff 55 08             	call   *0x8(%ebp)
  801117:	eb 0d                	jmp    801126 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801120:	89 04 24             	mov    %eax,(%esp)
  801123:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801126:	83 ef 01             	sub    $0x1,%edi
  801129:	83 c6 01             	add    $0x1,%esi
  80112c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801130:	0f be c2             	movsbl %dl,%eax
  801133:	85 c0                	test   %eax,%eax
  801135:	75 20                	jne    801157 <vprintfmt+0x263>
  801137:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80113a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80113d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801140:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801144:	7f 25                	jg     80116b <vprintfmt+0x277>
  801146:	e9 d2 fd ff ff       	jmp    800f1d <vprintfmt+0x29>
  80114b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80114e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801151:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801154:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801157:	85 db                	test   %ebx,%ebx
  801159:	78 9a                	js     8010f5 <vprintfmt+0x201>
  80115b:	83 eb 01             	sub    $0x1,%ebx
  80115e:	79 95                	jns    8010f5 <vprintfmt+0x201>
  801160:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801163:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801166:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801169:	eb d5                	jmp    801140 <vprintfmt+0x24c>
  80116b:	8b 75 08             	mov    0x8(%ebp),%esi
  80116e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801171:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801174:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801178:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80117f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801181:	83 eb 01             	sub    $0x1,%ebx
  801184:	75 ee                	jne    801174 <vprintfmt+0x280>
  801186:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801189:	e9 8f fd ff ff       	jmp    800f1d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80118e:	83 fa 01             	cmp    $0x1,%edx
  801191:	7e 16                	jle    8011a9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801193:	8b 45 14             	mov    0x14(%ebp),%eax
  801196:	8d 50 08             	lea    0x8(%eax),%edx
  801199:	89 55 14             	mov    %edx,0x14(%ebp)
  80119c:	8b 50 04             	mov    0x4(%eax),%edx
  80119f:	8b 00                	mov    (%eax),%eax
  8011a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8011a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8011a7:	eb 32                	jmp    8011db <vprintfmt+0x2e7>
	else if (lflag)
  8011a9:	85 d2                	test   %edx,%edx
  8011ab:	74 18                	je     8011c5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8011ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b0:	8d 50 04             	lea    0x4(%eax),%edx
  8011b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8011b6:	8b 30                	mov    (%eax),%esi
  8011b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8011bb:	89 f0                	mov    %esi,%eax
  8011bd:	c1 f8 1f             	sar    $0x1f,%eax
  8011c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8011c3:	eb 16                	jmp    8011db <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8011c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c8:	8d 50 04             	lea    0x4(%eax),%edx
  8011cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8011ce:	8b 30                	mov    (%eax),%esi
  8011d0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8011d3:	89 f0                	mov    %esi,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8011db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8011de:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8011e1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8011e6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8011ea:	0f 89 80 00 00 00    	jns    801270 <vprintfmt+0x37c>
				putch('-', putdat);
  8011f0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011f4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8011fb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8011fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801201:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801204:	f7 d8                	neg    %eax
  801206:	83 d2 00             	adc    $0x0,%edx
  801209:	f7 da                	neg    %edx
			}
			base = 10;
  80120b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801210:	eb 5e                	jmp    801270 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801212:	8d 45 14             	lea    0x14(%ebp),%eax
  801215:	e8 5b fc ff ff       	call   800e75 <getuint>
			base = 10;
  80121a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80121f:	eb 4f                	jmp    801270 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801221:	8d 45 14             	lea    0x14(%ebp),%eax
  801224:	e8 4c fc ff ff       	call   800e75 <getuint>
			base = 8;
  801229:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80122e:	eb 40                	jmp    801270 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801230:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801234:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80123b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80123e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801242:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801249:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80124c:	8b 45 14             	mov    0x14(%ebp),%eax
  80124f:	8d 50 04             	lea    0x4(%eax),%edx
  801252:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801255:	8b 00                	mov    (%eax),%eax
  801257:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80125c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801261:	eb 0d                	jmp    801270 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801263:	8d 45 14             	lea    0x14(%ebp),%eax
  801266:	e8 0a fc ff ff       	call   800e75 <getuint>
			base = 16;
  80126b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801270:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801274:	89 74 24 10          	mov    %esi,0x10(%esp)
  801278:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80127b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80127f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801283:	89 04 24             	mov    %eax,(%esp)
  801286:	89 54 24 04          	mov    %edx,0x4(%esp)
  80128a:	89 fa                	mov    %edi,%edx
  80128c:	8b 45 08             	mov    0x8(%ebp),%eax
  80128f:	e8 ec fa ff ff       	call   800d80 <printnum>
			break;
  801294:	e9 84 fc ff ff       	jmp    800f1d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801299:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80129d:	89 0c 24             	mov    %ecx,(%esp)
  8012a0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8012a3:	e9 75 fc ff ff       	jmp    800f1d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012a8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8012b3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012b6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8012ba:	0f 84 5b fc ff ff    	je     800f1b <vprintfmt+0x27>
  8012c0:	89 f3                	mov    %esi,%ebx
  8012c2:	83 eb 01             	sub    $0x1,%ebx
  8012c5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8012c9:	75 f7                	jne    8012c2 <vprintfmt+0x3ce>
  8012cb:	e9 4d fc ff ff       	jmp    800f1d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8012d0:	83 c4 3c             	add    $0x3c,%esp
  8012d3:	5b                   	pop    %ebx
  8012d4:	5e                   	pop    %esi
  8012d5:	5f                   	pop    %edi
  8012d6:	5d                   	pop    %ebp
  8012d7:	c3                   	ret    

008012d8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 28             	sub    $0x28,%esp
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012e7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8012eb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8012ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	74 30                	je     801329 <vsnprintf+0x51>
  8012f9:	85 d2                	test   %edx,%edx
  8012fb:	7e 2c                	jle    801329 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801304:	8b 45 10             	mov    0x10(%ebp),%eax
  801307:	89 44 24 08          	mov    %eax,0x8(%esp)
  80130b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80130e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801312:	c7 04 24 af 0e 80 00 	movl   $0x800eaf,(%esp)
  801319:	e8 d6 fb ff ff       	call   800ef4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80131e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801321:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801327:	eb 05                	jmp    80132e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801329:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80132e:	c9                   	leave  
  80132f:	c3                   	ret    

00801330 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801336:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801339:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80133d:	8b 45 10             	mov    0x10(%ebp),%eax
  801340:	89 44 24 08          	mov    %eax,0x8(%esp)
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134b:	8b 45 08             	mov    0x8(%ebp),%eax
  80134e:	89 04 24             	mov    %eax,(%esp)
  801351:	e8 82 ff ff ff       	call   8012d8 <vsnprintf>
	va_end(ap);

	return rc;
}
  801356:	c9                   	leave  
  801357:	c3                   	ret    
  801358:	66 90                	xchg   %ax,%ax
  80135a:	66 90                	xchg   %ax,%ax
  80135c:	66 90                	xchg   %ax,%ax
  80135e:	66 90                	xchg   %ax,%ax

00801360 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801366:	80 3a 00             	cmpb   $0x0,(%edx)
  801369:	74 10                	je     80137b <strlen+0x1b>
  80136b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801370:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801373:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801377:	75 f7                	jne    801370 <strlen+0x10>
  801379:	eb 05                	jmp    801380 <strlen+0x20>
  80137b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801380:	5d                   	pop    %ebp
  801381:	c3                   	ret    

00801382 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	53                   	push   %ebx
  801386:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80138c:	85 c9                	test   %ecx,%ecx
  80138e:	74 1c                	je     8013ac <strnlen+0x2a>
  801390:	80 3b 00             	cmpb   $0x0,(%ebx)
  801393:	74 1e                	je     8013b3 <strnlen+0x31>
  801395:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80139a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80139c:	39 ca                	cmp    %ecx,%edx
  80139e:	74 18                	je     8013b8 <strnlen+0x36>
  8013a0:	83 c2 01             	add    $0x1,%edx
  8013a3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8013a8:	75 f0                	jne    80139a <strnlen+0x18>
  8013aa:	eb 0c                	jmp    8013b8 <strnlen+0x36>
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b1:	eb 05                	jmp    8013b8 <strnlen+0x36>
  8013b3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8013b8:	5b                   	pop    %ebx
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	53                   	push   %ebx
  8013bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8013c5:	89 c2                	mov    %eax,%edx
  8013c7:	83 c2 01             	add    $0x1,%edx
  8013ca:	83 c1 01             	add    $0x1,%ecx
  8013cd:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8013d1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8013d4:	84 db                	test   %bl,%bl
  8013d6:	75 ef                	jne    8013c7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8013d8:	5b                   	pop    %ebx
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <strcat>:

char *
strcat(char *dst, const char *src)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	53                   	push   %ebx
  8013df:	83 ec 08             	sub    $0x8,%esp
  8013e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8013e5:	89 1c 24             	mov    %ebx,(%esp)
  8013e8:	e8 73 ff ff ff       	call   801360 <strlen>
	strcpy(dst + len, src);
  8013ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013f4:	01 d8                	add    %ebx,%eax
  8013f6:	89 04 24             	mov    %eax,(%esp)
  8013f9:	e8 bd ff ff ff       	call   8013bb <strcpy>
	return dst;
}
  8013fe:	89 d8                	mov    %ebx,%eax
  801400:	83 c4 08             	add    $0x8,%esp
  801403:	5b                   	pop    %ebx
  801404:	5d                   	pop    %ebp
  801405:	c3                   	ret    

00801406 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801406:	55                   	push   %ebp
  801407:	89 e5                	mov    %esp,%ebp
  801409:	56                   	push   %esi
  80140a:	53                   	push   %ebx
  80140b:	8b 75 08             	mov    0x8(%ebp),%esi
  80140e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801411:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801414:	85 db                	test   %ebx,%ebx
  801416:	74 17                	je     80142f <strncpy+0x29>
  801418:	01 f3                	add    %esi,%ebx
  80141a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80141c:	83 c1 01             	add    $0x1,%ecx
  80141f:	0f b6 02             	movzbl (%edx),%eax
  801422:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801425:	80 3a 01             	cmpb   $0x1,(%edx)
  801428:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80142b:	39 d9                	cmp    %ebx,%ecx
  80142d:	75 ed                	jne    80141c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80142f:	89 f0                	mov    %esi,%eax
  801431:	5b                   	pop    %ebx
  801432:	5e                   	pop    %esi
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	57                   	push   %edi
  801439:	56                   	push   %esi
  80143a:	53                   	push   %ebx
  80143b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80143e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801441:	8b 75 10             	mov    0x10(%ebp),%esi
  801444:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801446:	85 f6                	test   %esi,%esi
  801448:	74 34                	je     80147e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80144a:	83 fe 01             	cmp    $0x1,%esi
  80144d:	74 26                	je     801475 <strlcpy+0x40>
  80144f:	0f b6 0b             	movzbl (%ebx),%ecx
  801452:	84 c9                	test   %cl,%cl
  801454:	74 23                	je     801479 <strlcpy+0x44>
  801456:	83 ee 02             	sub    $0x2,%esi
  801459:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80145e:	83 c0 01             	add    $0x1,%eax
  801461:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801464:	39 f2                	cmp    %esi,%edx
  801466:	74 13                	je     80147b <strlcpy+0x46>
  801468:	83 c2 01             	add    $0x1,%edx
  80146b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80146f:	84 c9                	test   %cl,%cl
  801471:	75 eb                	jne    80145e <strlcpy+0x29>
  801473:	eb 06                	jmp    80147b <strlcpy+0x46>
  801475:	89 f8                	mov    %edi,%eax
  801477:	eb 02                	jmp    80147b <strlcpy+0x46>
  801479:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  80147b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80147e:	29 f8                	sub    %edi,%eax
}
  801480:	5b                   	pop    %ebx
  801481:	5e                   	pop    %esi
  801482:	5f                   	pop    %edi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80148e:	0f b6 01             	movzbl (%ecx),%eax
  801491:	84 c0                	test   %al,%al
  801493:	74 15                	je     8014aa <strcmp+0x25>
  801495:	3a 02                	cmp    (%edx),%al
  801497:	75 11                	jne    8014aa <strcmp+0x25>
		p++, q++;
  801499:	83 c1 01             	add    $0x1,%ecx
  80149c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80149f:	0f b6 01             	movzbl (%ecx),%eax
  8014a2:	84 c0                	test   %al,%al
  8014a4:	74 04                	je     8014aa <strcmp+0x25>
  8014a6:	3a 02                	cmp    (%edx),%al
  8014a8:	74 ef                	je     801499 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014aa:	0f b6 c0             	movzbl %al,%eax
  8014ad:	0f b6 12             	movzbl (%edx),%edx
  8014b0:	29 d0                	sub    %edx,%eax
}
  8014b2:	5d                   	pop    %ebp
  8014b3:	c3                   	ret    

008014b4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014bf:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  8014c2:	85 f6                	test   %esi,%esi
  8014c4:	74 29                	je     8014ef <strncmp+0x3b>
  8014c6:	0f b6 03             	movzbl (%ebx),%eax
  8014c9:	84 c0                	test   %al,%al
  8014cb:	74 30                	je     8014fd <strncmp+0x49>
  8014cd:	3a 02                	cmp    (%edx),%al
  8014cf:	75 2c                	jne    8014fd <strncmp+0x49>
  8014d1:	8d 43 01             	lea    0x1(%ebx),%eax
  8014d4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  8014d6:	89 c3                	mov    %eax,%ebx
  8014d8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8014db:	39 f0                	cmp    %esi,%eax
  8014dd:	74 17                	je     8014f6 <strncmp+0x42>
  8014df:	0f b6 08             	movzbl (%eax),%ecx
  8014e2:	84 c9                	test   %cl,%cl
  8014e4:	74 17                	je     8014fd <strncmp+0x49>
  8014e6:	83 c0 01             	add    $0x1,%eax
  8014e9:	3a 0a                	cmp    (%edx),%cl
  8014eb:	74 e9                	je     8014d6 <strncmp+0x22>
  8014ed:	eb 0e                	jmp    8014fd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  8014ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f4:	eb 0f                	jmp    801505 <strncmp+0x51>
  8014f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014fb:	eb 08                	jmp    801505 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fd:	0f b6 03             	movzbl (%ebx),%eax
  801500:	0f b6 12             	movzbl (%edx),%edx
  801503:	29 d0                	sub    %edx,%eax
}
  801505:	5b                   	pop    %ebx
  801506:	5e                   	pop    %esi
  801507:	5d                   	pop    %ebp
  801508:	c3                   	ret    

00801509 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	53                   	push   %ebx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801513:	0f b6 18             	movzbl (%eax),%ebx
  801516:	84 db                	test   %bl,%bl
  801518:	74 1d                	je     801537 <strchr+0x2e>
  80151a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80151c:	38 d3                	cmp    %dl,%bl
  80151e:	75 06                	jne    801526 <strchr+0x1d>
  801520:	eb 1a                	jmp    80153c <strchr+0x33>
  801522:	38 ca                	cmp    %cl,%dl
  801524:	74 16                	je     80153c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801526:	83 c0 01             	add    $0x1,%eax
  801529:	0f b6 10             	movzbl (%eax),%edx
  80152c:	84 d2                	test   %dl,%dl
  80152e:	75 f2                	jne    801522 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	eb 05                	jmp    80153c <strchr+0x33>
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153c:	5b                   	pop    %ebx
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	53                   	push   %ebx
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801549:	0f b6 18             	movzbl (%eax),%ebx
  80154c:	84 db                	test   %bl,%bl
  80154e:	74 16                	je     801566 <strfind+0x27>
  801550:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801552:	38 d3                	cmp    %dl,%bl
  801554:	75 06                	jne    80155c <strfind+0x1d>
  801556:	eb 0e                	jmp    801566 <strfind+0x27>
  801558:	38 ca                	cmp    %cl,%dl
  80155a:	74 0a                	je     801566 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80155c:	83 c0 01             	add    $0x1,%eax
  80155f:	0f b6 10             	movzbl (%eax),%edx
  801562:	84 d2                	test   %dl,%dl
  801564:	75 f2                	jne    801558 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801566:	5b                   	pop    %ebx
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	57                   	push   %edi
  80156d:	56                   	push   %esi
  80156e:	53                   	push   %ebx
  80156f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801572:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801575:	85 c9                	test   %ecx,%ecx
  801577:	74 36                	je     8015af <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801579:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80157f:	75 28                	jne    8015a9 <memset+0x40>
  801581:	f6 c1 03             	test   $0x3,%cl
  801584:	75 23                	jne    8015a9 <memset+0x40>
		c &= 0xFF;
  801586:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80158a:	89 d3                	mov    %edx,%ebx
  80158c:	c1 e3 08             	shl    $0x8,%ebx
  80158f:	89 d6                	mov    %edx,%esi
  801591:	c1 e6 18             	shl    $0x18,%esi
  801594:	89 d0                	mov    %edx,%eax
  801596:	c1 e0 10             	shl    $0x10,%eax
  801599:	09 f0                	or     %esi,%eax
  80159b:	09 c2                	or     %eax,%edx
  80159d:	89 d0                	mov    %edx,%eax
  80159f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8015a1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8015a4:	fc                   	cld    
  8015a5:	f3 ab                	rep stos %eax,%es:(%edi)
  8015a7:	eb 06                	jmp    8015af <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ac:	fc                   	cld    
  8015ad:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8015af:	89 f8                	mov    %edi,%eax
  8015b1:	5b                   	pop    %ebx
  8015b2:	5e                   	pop    %esi
  8015b3:	5f                   	pop    %edi
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    

008015b6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	57                   	push   %edi
  8015ba:	56                   	push   %esi
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015c4:	39 c6                	cmp    %eax,%esi
  8015c6:	73 35                	jae    8015fd <memmove+0x47>
  8015c8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8015cb:	39 d0                	cmp    %edx,%eax
  8015cd:	73 2e                	jae    8015fd <memmove+0x47>
		s += n;
		d += n;
  8015cf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8015d2:	89 d6                	mov    %edx,%esi
  8015d4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015d6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8015dc:	75 13                	jne    8015f1 <memmove+0x3b>
  8015de:	f6 c1 03             	test   $0x3,%cl
  8015e1:	75 0e                	jne    8015f1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8015e3:	83 ef 04             	sub    $0x4,%edi
  8015e6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8015e9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8015ec:	fd                   	std    
  8015ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8015ef:	eb 09                	jmp    8015fa <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8015f1:	83 ef 01             	sub    $0x1,%edi
  8015f4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8015f7:	fd                   	std    
  8015f8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8015fa:	fc                   	cld    
  8015fb:	eb 1d                	jmp    80161a <memmove+0x64>
  8015fd:	89 f2                	mov    %esi,%edx
  8015ff:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801601:	f6 c2 03             	test   $0x3,%dl
  801604:	75 0f                	jne    801615 <memmove+0x5f>
  801606:	f6 c1 03             	test   $0x3,%cl
  801609:	75 0a                	jne    801615 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80160b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80160e:	89 c7                	mov    %eax,%edi
  801610:	fc                   	cld    
  801611:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801613:	eb 05                	jmp    80161a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801615:	89 c7                	mov    %eax,%edi
  801617:	fc                   	cld    
  801618:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80161a:	5e                   	pop    %esi
  80161b:	5f                   	pop    %edi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801624:	8b 45 10             	mov    0x10(%ebp),%eax
  801627:	89 44 24 08          	mov    %eax,0x8(%esp)
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	89 04 24             	mov    %eax,(%esp)
  801638:	e8 79 ff ff ff       	call   8015b6 <memmove>
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	57                   	push   %edi
  801643:	56                   	push   %esi
  801644:	53                   	push   %ebx
  801645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801648:	8b 75 0c             	mov    0xc(%ebp),%esi
  80164b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80164e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801651:	85 c0                	test   %eax,%eax
  801653:	74 36                	je     80168b <memcmp+0x4c>
		if (*s1 != *s2)
  801655:	0f b6 03             	movzbl (%ebx),%eax
  801658:	0f b6 0e             	movzbl (%esi),%ecx
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	38 c8                	cmp    %cl,%al
  801662:	74 1c                	je     801680 <memcmp+0x41>
  801664:	eb 10                	jmp    801676 <memcmp+0x37>
  801666:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  80166b:	83 c2 01             	add    $0x1,%edx
  80166e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801672:	38 c8                	cmp    %cl,%al
  801674:	74 0a                	je     801680 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801676:	0f b6 c0             	movzbl %al,%eax
  801679:	0f b6 c9             	movzbl %cl,%ecx
  80167c:	29 c8                	sub    %ecx,%eax
  80167e:	eb 10                	jmp    801690 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801680:	39 fa                	cmp    %edi,%edx
  801682:	75 e2                	jne    801666 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
  801689:	eb 05                	jmp    801690 <memcmp+0x51>
  80168b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801690:	5b                   	pop    %ebx
  801691:	5e                   	pop    %esi
  801692:	5f                   	pop    %edi
  801693:	5d                   	pop    %ebp
  801694:	c3                   	ret    

00801695 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	53                   	push   %ebx
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
  80169c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8016a4:	39 d0                	cmp    %edx,%eax
  8016a6:	73 13                	jae    8016bb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  8016a8:	89 d9                	mov    %ebx,%ecx
  8016aa:	38 18                	cmp    %bl,(%eax)
  8016ac:	75 06                	jne    8016b4 <memfind+0x1f>
  8016ae:	eb 0b                	jmp    8016bb <memfind+0x26>
  8016b0:	38 08                	cmp    %cl,(%eax)
  8016b2:	74 07                	je     8016bb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8016b4:	83 c0 01             	add    $0x1,%eax
  8016b7:	39 d0                	cmp    %edx,%eax
  8016b9:	75 f5                	jne    8016b0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8016bb:	5b                   	pop    %ebx
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	57                   	push   %edi
  8016c2:	56                   	push   %esi
  8016c3:	53                   	push   %ebx
  8016c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016ca:	0f b6 0a             	movzbl (%edx),%ecx
  8016cd:	80 f9 09             	cmp    $0x9,%cl
  8016d0:	74 05                	je     8016d7 <strtol+0x19>
  8016d2:	80 f9 20             	cmp    $0x20,%cl
  8016d5:	75 10                	jne    8016e7 <strtol+0x29>
		s++;
  8016d7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016da:	0f b6 0a             	movzbl (%edx),%ecx
  8016dd:	80 f9 09             	cmp    $0x9,%cl
  8016e0:	74 f5                	je     8016d7 <strtol+0x19>
  8016e2:	80 f9 20             	cmp    $0x20,%cl
  8016e5:	74 f0                	je     8016d7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016e7:	80 f9 2b             	cmp    $0x2b,%cl
  8016ea:	75 0a                	jne    8016f6 <strtol+0x38>
		s++;
  8016ec:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8016ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8016f4:	eb 11                	jmp    801707 <strtol+0x49>
  8016f6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8016fb:	80 f9 2d             	cmp    $0x2d,%cl
  8016fe:	75 07                	jne    801707 <strtol+0x49>
		s++, neg = 1;
  801700:	83 c2 01             	add    $0x1,%edx
  801703:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801707:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80170c:	75 15                	jne    801723 <strtol+0x65>
  80170e:	80 3a 30             	cmpb   $0x30,(%edx)
  801711:	75 10                	jne    801723 <strtol+0x65>
  801713:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801717:	75 0a                	jne    801723 <strtol+0x65>
		s += 2, base = 16;
  801719:	83 c2 02             	add    $0x2,%edx
  80171c:	b8 10 00 00 00       	mov    $0x10,%eax
  801721:	eb 10                	jmp    801733 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801723:	85 c0                	test   %eax,%eax
  801725:	75 0c                	jne    801733 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801727:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801729:	80 3a 30             	cmpb   $0x30,(%edx)
  80172c:	75 05                	jne    801733 <strtol+0x75>
		s++, base = 8;
  80172e:	83 c2 01             	add    $0x1,%edx
  801731:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801733:	bb 00 00 00 00       	mov    $0x0,%ebx
  801738:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80173b:	0f b6 0a             	movzbl (%edx),%ecx
  80173e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801741:	89 f0                	mov    %esi,%eax
  801743:	3c 09                	cmp    $0x9,%al
  801745:	77 08                	ja     80174f <strtol+0x91>
			dig = *s - '0';
  801747:	0f be c9             	movsbl %cl,%ecx
  80174a:	83 e9 30             	sub    $0x30,%ecx
  80174d:	eb 20                	jmp    80176f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  80174f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801752:	89 f0                	mov    %esi,%eax
  801754:	3c 19                	cmp    $0x19,%al
  801756:	77 08                	ja     801760 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801758:	0f be c9             	movsbl %cl,%ecx
  80175b:	83 e9 57             	sub    $0x57,%ecx
  80175e:	eb 0f                	jmp    80176f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801760:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801763:	89 f0                	mov    %esi,%eax
  801765:	3c 19                	cmp    $0x19,%al
  801767:	77 16                	ja     80177f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801769:	0f be c9             	movsbl %cl,%ecx
  80176c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80176f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801772:	7d 0f                	jge    801783 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801774:	83 c2 01             	add    $0x1,%edx
  801777:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  80177b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  80177d:	eb bc                	jmp    80173b <strtol+0x7d>
  80177f:	89 d8                	mov    %ebx,%eax
  801781:	eb 02                	jmp    801785 <strtol+0xc7>
  801783:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801785:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801789:	74 05                	je     801790 <strtol+0xd2>
		*endptr = (char *) s;
  80178b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80178e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801790:	f7 d8                	neg    %eax
  801792:	85 ff                	test   %edi,%edi
  801794:	0f 44 c3             	cmove  %ebx,%eax
}
  801797:	5b                   	pop    %ebx
  801798:	5e                   	pop    %esi
  801799:	5f                   	pop    %edi
  80179a:	5d                   	pop    %ebp
  80179b:	c3                   	ret    

0080179c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	57                   	push   %edi
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ad:	89 c3                	mov    %eax,%ebx
  8017af:	89 c7                	mov    %eax,%edi
  8017b1:	89 c6                	mov    %eax,%esi
  8017b3:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5f                   	pop    %edi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	57                   	push   %edi
  8017be:	56                   	push   %esi
  8017bf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8017ca:	89 d1                	mov    %edx,%ecx
  8017cc:	89 d3                	mov    %edx,%ebx
  8017ce:	89 d7                	mov    %edx,%edi
  8017d0:	89 d6                	mov    %edx,%esi
  8017d2:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8017d4:	5b                   	pop    %ebx
  8017d5:	5e                   	pop    %esi
  8017d6:	5f                   	pop    %edi
  8017d7:	5d                   	pop    %ebp
  8017d8:	c3                   	ret    

008017d9 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	57                   	push   %edi
  8017dd:	56                   	push   %esi
  8017de:	53                   	push   %ebx
  8017df:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017e7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8017ef:	89 cb                	mov    %ecx,%ebx
  8017f1:	89 cf                	mov    %ecx,%edi
  8017f3:	89 ce                	mov    %ecx,%esi
  8017f5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	7e 28                	jle    801823 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017ff:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801806:	00 
  801807:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  80180e:	00 
  80180f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801816:	00 
  801817:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  80181e:	e8 4a f4 ff ff       	call   800c6d <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801823:	83 c4 2c             	add    $0x2c,%esp
  801826:	5b                   	pop    %ebx
  801827:	5e                   	pop    %esi
  801828:	5f                   	pop    %edi
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

0080182b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	57                   	push   %edi
  80182f:	56                   	push   %esi
  801830:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801831:	ba 00 00 00 00       	mov    $0x0,%edx
  801836:	b8 02 00 00 00       	mov    $0x2,%eax
  80183b:	89 d1                	mov    %edx,%ecx
  80183d:	89 d3                	mov    %edx,%ebx
  80183f:	89 d7                	mov    %edx,%edi
  801841:	89 d6                	mov    %edx,%esi
  801843:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801845:	5b                   	pop    %ebx
  801846:	5e                   	pop    %esi
  801847:	5f                   	pop    %edi
  801848:	5d                   	pop    %ebp
  801849:	c3                   	ret    

0080184a <sys_yield>:

void
sys_yield(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	57                   	push   %edi
  80184e:	56                   	push   %esi
  80184f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801850:	ba 00 00 00 00       	mov    $0x0,%edx
  801855:	b8 0b 00 00 00       	mov    $0xb,%eax
  80185a:	89 d1                	mov    %edx,%ecx
  80185c:	89 d3                	mov    %edx,%ebx
  80185e:	89 d7                	mov    %edx,%edi
  801860:	89 d6                	mov    %edx,%esi
  801862:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801864:	5b                   	pop    %ebx
  801865:	5e                   	pop    %esi
  801866:	5f                   	pop    %edi
  801867:	5d                   	pop    %ebp
  801868:	c3                   	ret    

00801869 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	57                   	push   %edi
  80186d:	56                   	push   %esi
  80186e:	53                   	push   %ebx
  80186f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801872:	be 00 00 00 00       	mov    $0x0,%esi
  801877:	b8 04 00 00 00       	mov    $0x4,%eax
  80187c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187f:	8b 55 08             	mov    0x8(%ebp),%edx
  801882:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801885:	89 f7                	mov    %esi,%edi
  801887:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801889:	85 c0                	test   %eax,%eax
  80188b:	7e 28                	jle    8018b5 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80188d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801891:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801898:	00 
  801899:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  8018a0:	00 
  8018a1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018a8:	00 
  8018a9:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  8018b0:	e8 b8 f3 ff ff       	call   800c6d <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8018b5:	83 c4 2c             	add    $0x2c,%esp
  8018b8:	5b                   	pop    %ebx
  8018b9:	5e                   	pop    %esi
  8018ba:	5f                   	pop    %edi
  8018bb:	5d                   	pop    %ebp
  8018bc:	c3                   	ret    

008018bd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	57                   	push   %edi
  8018c1:	56                   	push   %esi
  8018c2:	53                   	push   %ebx
  8018c3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c6:	b8 05 00 00 00       	mov    $0x5,%eax
  8018cb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018d7:	8b 75 18             	mov    0x18(%ebp),%esi
  8018da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	7e 28                	jle    801908 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018e4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8018eb:	00 
  8018ec:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  8018f3:	00 
  8018f4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018fb:	00 
  8018fc:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  801903:	e8 65 f3 ff ff       	call   800c6d <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801908:	83 c4 2c             	add    $0x2c,%esp
  80190b:	5b                   	pop    %ebx
  80190c:	5e                   	pop    %esi
  80190d:	5f                   	pop    %edi
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    

00801910 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	57                   	push   %edi
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801919:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191e:	b8 06 00 00 00       	mov    $0x6,%eax
  801923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801926:	8b 55 08             	mov    0x8(%ebp),%edx
  801929:	89 df                	mov    %ebx,%edi
  80192b:	89 de                	mov    %ebx,%esi
  80192d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80192f:	85 c0                	test   %eax,%eax
  801931:	7e 28                	jle    80195b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801933:	89 44 24 10          	mov    %eax,0x10(%esp)
  801937:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80193e:	00 
  80193f:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  801946:	00 
  801947:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80194e:	00 
  80194f:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  801956:	e8 12 f3 ff ff       	call   800c6d <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80195b:	83 c4 2c             	add    $0x2c,%esp
  80195e:	5b                   	pop    %ebx
  80195f:	5e                   	pop    %esi
  801960:	5f                   	pop    %edi
  801961:	5d                   	pop    %ebp
  801962:	c3                   	ret    

00801963 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	57                   	push   %edi
  801967:	56                   	push   %esi
  801968:	53                   	push   %ebx
  801969:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80196c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801971:	b8 08 00 00 00       	mov    $0x8,%eax
  801976:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801979:	8b 55 08             	mov    0x8(%ebp),%edx
  80197c:	89 df                	mov    %ebx,%edi
  80197e:	89 de                	mov    %ebx,%esi
  801980:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801982:	85 c0                	test   %eax,%eax
  801984:	7e 28                	jle    8019ae <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801986:	89 44 24 10          	mov    %eax,0x10(%esp)
  80198a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801991:	00 
  801992:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  801999:	00 
  80199a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019a1:	00 
  8019a2:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  8019a9:	e8 bf f2 ff ff       	call   800c6d <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8019ae:	83 c4 2c             	add    $0x2c,%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5f                   	pop    %edi
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    

008019b6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	53                   	push   %ebx
  8019bc:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019c4:	b8 09 00 00 00       	mov    $0x9,%eax
  8019c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8019cf:	89 df                	mov    %ebx,%edi
  8019d1:	89 de                	mov    %ebx,%esi
  8019d3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	7e 28                	jle    801a01 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019dd:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8019e4:	00 
  8019e5:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  8019ec:	00 
  8019ed:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019f4:	00 
  8019f5:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  8019fc:	e8 6c f2 ff ff       	call   800c6d <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801a01:	83 c4 2c             	add    $0x2c,%esp
  801a04:	5b                   	pop    %ebx
  801a05:	5e                   	pop    %esi
  801a06:	5f                   	pop    %edi
  801a07:	5d                   	pop    %ebp
  801a08:	c3                   	ret    

00801a09 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
  801a0c:	57                   	push   %edi
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
  801a0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a12:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a17:	b8 0a 00 00 00       	mov    $0xa,%eax
  801a1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a22:	89 df                	mov    %ebx,%edi
  801a24:	89 de                	mov    %ebx,%esi
  801a26:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	7e 28                	jle    801a54 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a2c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a30:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801a37:	00 
  801a38:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  801a3f:	00 
  801a40:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a47:	00 
  801a48:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  801a4f:	e8 19 f2 ff ff       	call   800c6d <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801a54:	83 c4 2c             	add    $0x2c,%esp
  801a57:	5b                   	pop    %ebx
  801a58:	5e                   	pop    %esi
  801a59:	5f                   	pop    %edi
  801a5a:	5d                   	pop    %ebp
  801a5b:	c3                   	ret    

00801a5c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
  801a5f:	57                   	push   %edi
  801a60:	56                   	push   %esi
  801a61:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
  801a67:	b8 0c 00 00 00       	mov    $0xc,%eax
  801a6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a6f:	8b 55 08             	mov    0x8(%ebp),%edx
  801a72:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a75:	8b 7d 14             	mov    0x14(%ebp),%edi
  801a78:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801a7a:	5b                   	pop    %ebx
  801a7b:	5e                   	pop    %esi
  801a7c:	5f                   	pop    %edi
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	57                   	push   %edi
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a88:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a8d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a92:	8b 55 08             	mov    0x8(%ebp),%edx
  801a95:	89 cb                	mov    %ecx,%ebx
  801a97:	89 cf                	mov    %ecx,%edi
  801a99:	89 ce                	mov    %ecx,%esi
  801a9b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	7e 28                	jle    801ac9 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801aa1:	89 44 24 10          	mov    %eax,0x10(%esp)
  801aa5:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801aac:	00 
  801aad:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  801ab4:	00 
  801ab5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801abc:	00 
  801abd:	c7 04 24 7c 32 80 00 	movl   $0x80327c,(%esp)
  801ac4:	e8 a4 f1 ff ff       	call   800c6d <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801ac9:	83 c4 2c             	add    $0x2c,%esp
  801acc:	5b                   	pop    %ebx
  801acd:	5e                   	pop    %esi
  801ace:	5f                   	pop    %edi
  801acf:	5d                   	pop    %ebp
  801ad0:	c3                   	ret    

00801ad1 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801ad7:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  801ade:	75 50                	jne    801b30 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801ae0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ae7:	00 
  801ae8:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801aef:	ee 
  801af0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801af7:	e8 6d fd ff ff       	call   801869 <sys_page_alloc>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	79 1c                	jns    801b1c <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801b00:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  801b07:	00 
  801b08:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801b0f:	00 
  801b10:	c7 04 24 b0 32 80 00 	movl   $0x8032b0,(%esp)
  801b17:	e8 51 f1 ff ff       	call   800c6d <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801b1c:	c7 44 24 04 3a 1b 80 	movl   $0x801b3a,0x4(%esp)
  801b23:	00 
  801b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2b:	e8 d9 fe ff ff       	call   801a09 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	a3 10 90 80 00       	mov    %eax,0x809010
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801b3a:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801b3b:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  801b40:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801b42:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801b45:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801b47:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  801b4c:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  801b4f:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801b54:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801b57:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801b59:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  801b5c:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  801b5e:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801b60:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801b65:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801b68:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  801b6d:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801b70:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801b72:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801b77:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  801b7a:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  801b7f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  801b82:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  801b84:	83 c4 08             	add    $0x8,%esp
	popal
  801b87:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801b88:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801b89:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801b8a:	c3                   	ret    

00801b8b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 10             	sub    $0x10,%esp
  801b93:	8b 75 08             	mov    0x8(%ebp),%esi
  801b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b99:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801ba3:	0f 44 c2             	cmove  %edx,%eax
  801ba6:	89 04 24             	mov    %eax,(%esp)
  801ba9:	e8 d1 fe ff ff       	call   801a7f <sys_ipc_recv>
	if (err_code < 0) {
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	79 16                	jns    801bc8 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801bb2:	85 f6                	test   %esi,%esi
  801bb4:	74 06                	je     801bbc <ipc_recv+0x31>
  801bb6:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801bbc:	85 db                	test   %ebx,%ebx
  801bbe:	74 2c                	je     801bec <ipc_recv+0x61>
  801bc0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801bc6:	eb 24                	jmp    801bec <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801bc8:	85 f6                	test   %esi,%esi
  801bca:	74 0a                	je     801bd6 <ipc_recv+0x4b>
  801bcc:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801bd1:	8b 40 74             	mov    0x74(%eax),%eax
  801bd4:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801bd6:	85 db                	test   %ebx,%ebx
  801bd8:	74 0a                	je     801be4 <ipc_recv+0x59>
  801bda:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801bdf:	8b 40 78             	mov    0x78(%eax),%eax
  801be2:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801be4:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801be9:	8b 40 70             	mov    0x70(%eax),%eax
}
  801bec:	83 c4 10             	add    $0x10,%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	57                   	push   %edi
  801bf7:	56                   	push   %esi
  801bf8:	53                   	push   %ebx
  801bf9:	83 ec 1c             	sub    $0x1c,%esp
  801bfc:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bff:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801c05:	eb 25                	jmp    801c2c <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801c07:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c0a:	74 20                	je     801c2c <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801c0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c10:	c7 44 24 08 be 32 80 	movl   $0x8032be,0x8(%esp)
  801c17:	00 
  801c18:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801c1f:	00 
  801c20:	c7 04 24 ca 32 80 00 	movl   $0x8032ca,(%esp)
  801c27:	e8 41 f0 ff ff       	call   800c6d <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801c2c:	85 db                	test   %ebx,%ebx
  801c2e:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801c33:	0f 45 c3             	cmovne %ebx,%eax
  801c36:	8b 55 14             	mov    0x14(%ebp),%edx
  801c39:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801c3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c41:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c45:	89 3c 24             	mov    %edi,(%esp)
  801c48:	e8 0f fe ff ff       	call   801a5c <sys_ipc_try_send>
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	75 b6                	jne    801c07 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801c51:	83 c4 1c             	add    $0x1c,%esp
  801c54:	5b                   	pop    %ebx
  801c55:	5e                   	pop    %esi
  801c56:	5f                   	pop    %edi
  801c57:	5d                   	pop    %ebp
  801c58:	c3                   	ret    

00801c59 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801c5f:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801c64:	39 c8                	cmp    %ecx,%eax
  801c66:	74 17                	je     801c7f <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c68:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801c6d:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801c70:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801c76:	8b 52 50             	mov    0x50(%edx),%edx
  801c79:	39 ca                	cmp    %ecx,%edx
  801c7b:	75 14                	jne    801c91 <ipc_find_env+0x38>
  801c7d:	eb 05                	jmp    801c84 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801c84:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c87:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801c8c:	8b 40 40             	mov    0x40(%eax),%eax
  801c8f:	eb 0e                	jmp    801c9f <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c91:	83 c0 01             	add    $0x1,%eax
  801c94:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c99:	75 d2                	jne    801c6d <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801c9b:	66 b8 00 00          	mov    $0x0,%ax
}
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
  801ca1:	66 90                	xchg   %ax,%ax
  801ca3:	66 90                	xchg   %ax,%ax
  801ca5:	66 90                	xchg   %ax,%ax
  801ca7:	66 90                	xchg   %ax,%ax
  801ca9:	66 90                	xchg   %ax,%ax
  801cab:	66 90                	xchg   %ax,%ax
  801cad:	66 90                	xchg   %ax,%ax
  801caf:	90                   	nop

00801cb0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	05 00 00 00 30       	add    $0x30000000,%eax
  801cbb:	c1 e8 0c             	shr    $0xc,%eax
}
  801cbe:	5d                   	pop    %ebp
  801cbf:	c3                   	ret    

00801cc0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801ccb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cd0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801cd5:	5d                   	pop    %ebp
  801cd6:	c3                   	ret    

00801cd7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cda:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801cdf:	a8 01                	test   $0x1,%al
  801ce1:	74 34                	je     801d17 <fd_alloc+0x40>
  801ce3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801ce8:	a8 01                	test   $0x1,%al
  801cea:	74 32                	je     801d1e <fd_alloc+0x47>
  801cec:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801cf1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801cf3:	89 c2                	mov    %eax,%edx
  801cf5:	c1 ea 16             	shr    $0x16,%edx
  801cf8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cff:	f6 c2 01             	test   $0x1,%dl
  801d02:	74 1f                	je     801d23 <fd_alloc+0x4c>
  801d04:	89 c2                	mov    %eax,%edx
  801d06:	c1 ea 0c             	shr    $0xc,%edx
  801d09:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d10:	f6 c2 01             	test   $0x1,%dl
  801d13:	75 1a                	jne    801d2f <fd_alloc+0x58>
  801d15:	eb 0c                	jmp    801d23 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801d17:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801d1c:	eb 05                	jmp    801d23 <fd_alloc+0x4c>
  801d1e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	89 08                	mov    %ecx,(%eax)
			return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2d:	eb 1a                	jmp    801d49 <fd_alloc+0x72>
  801d2f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801d34:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d39:	75 b6                	jne    801cf1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801d44:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801d49:	5d                   	pop    %ebp
  801d4a:	c3                   	ret    

00801d4b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d51:	83 f8 1f             	cmp    $0x1f,%eax
  801d54:	77 36                	ja     801d8c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d56:	c1 e0 0c             	shl    $0xc,%eax
  801d59:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d5e:	89 c2                	mov    %eax,%edx
  801d60:	c1 ea 16             	shr    $0x16,%edx
  801d63:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d6a:	f6 c2 01             	test   $0x1,%dl
  801d6d:	74 24                	je     801d93 <fd_lookup+0x48>
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	c1 ea 0c             	shr    $0xc,%edx
  801d74:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d7b:	f6 c2 01             	test   $0x1,%dl
  801d7e:	74 1a                	je     801d9a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	89 02                	mov    %eax,(%edx)
	return 0;
  801d85:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8a:	eb 13                	jmp    801d9f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d8c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d91:	eb 0c                	jmp    801d9f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d93:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d98:	eb 05                	jmp    801d9f <fd_lookup+0x54>
  801d9a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	53                   	push   %ebx
  801da5:	83 ec 14             	sub    $0x14,%esp
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801dae:	39 05 44 80 80 00    	cmp    %eax,0x808044
  801db4:	75 1e                	jne    801dd4 <dev_lookup+0x33>
  801db6:	eb 0e                	jmp    801dc6 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801db8:	b8 60 80 80 00       	mov    $0x808060,%eax
  801dbd:	eb 0c                	jmp    801dcb <dev_lookup+0x2a>
  801dbf:	b8 7c 80 80 00       	mov    $0x80807c,%eax
  801dc4:	eb 05                	jmp    801dcb <dev_lookup+0x2a>
  801dc6:	b8 44 80 80 00       	mov    $0x808044,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801dcb:	89 03                	mov    %eax,(%ebx)
			return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd2:	eb 38                	jmp    801e0c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801dd4:	39 05 60 80 80 00    	cmp    %eax,0x808060
  801dda:	74 dc                	je     801db8 <dev_lookup+0x17>
  801ddc:	39 05 7c 80 80 00    	cmp    %eax,0x80807c
  801de2:	74 db                	je     801dbf <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801de4:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  801dea:	8b 52 48             	mov    0x48(%edx),%edx
  801ded:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801df5:	c7 04 24 d4 32 80 00 	movl   $0x8032d4,(%esp)
  801dfc:	e8 65 ef ff ff       	call   800d66 <cprintf>
	*dev = 0;
  801e01:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801e07:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801e0c:	83 c4 14             	add    $0x14,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	56                   	push   %esi
  801e16:	53                   	push   %ebx
  801e17:	83 ec 20             	sub    $0x20,%esp
  801e1a:	8b 75 08             	mov    0x8(%ebp),%esi
  801e1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e23:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e27:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801e2d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e30:	89 04 24             	mov    %eax,(%esp)
  801e33:	e8 13 ff ff ff       	call   801d4b <fd_lookup>
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	78 05                	js     801e41 <fd_close+0x2f>
	    || fd != fd2)
  801e3c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801e3f:	74 0c                	je     801e4d <fd_close+0x3b>
		return (must_exist ? r : 0);
  801e41:	84 db                	test   %bl,%bl
  801e43:	ba 00 00 00 00       	mov    $0x0,%edx
  801e48:	0f 44 c2             	cmove  %edx,%eax
  801e4b:	eb 3f                	jmp    801e8c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e54:	8b 06                	mov    (%esi),%eax
  801e56:	89 04 24             	mov    %eax,(%esp)
  801e59:	e8 43 ff ff ff       	call   801da1 <dev_lookup>
  801e5e:	89 c3                	mov    %eax,%ebx
  801e60:	85 c0                	test   %eax,%eax
  801e62:	78 16                	js     801e7a <fd_close+0x68>
		if (dev->dev_close)
  801e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e67:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801e6a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	74 07                	je     801e7a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801e73:	89 34 24             	mov    %esi,(%esp)
  801e76:	ff d0                	call   *%eax
  801e78:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e7a:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e85:	e8 86 fa ff ff       	call   801910 <sys_page_unmap>
	return r;
  801e8a:	89 d8                	mov    %ebx,%eax
}
  801e8c:	83 c4 20             	add    $0x20,%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5d                   	pop    %ebp
  801e92:	c3                   	ret    

00801e93 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	89 04 24             	mov    %eax,(%esp)
  801ea6:	e8 a0 fe ff ff       	call   801d4b <fd_lookup>
  801eab:	89 c2                	mov    %eax,%edx
  801ead:	85 d2                	test   %edx,%edx
  801eaf:	78 13                	js     801ec4 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801eb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801eb8:	00 
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 4e ff ff ff       	call   801e12 <fd_close>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <close_all>:

void
close_all(void)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ecd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ed2:	89 1c 24             	mov    %ebx,(%esp)
  801ed5:	e8 b9 ff ff ff       	call   801e93 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801eda:	83 c3 01             	add    $0x1,%ebx
  801edd:	83 fb 20             	cmp    $0x20,%ebx
  801ee0:	75 f0                	jne    801ed2 <close_all+0xc>
		close(i);
}
  801ee2:	83 c4 14             	add    $0x14,%esp
  801ee5:	5b                   	pop    %ebx
  801ee6:	5d                   	pop    %ebp
  801ee7:	c3                   	ret    

00801ee8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	57                   	push   %edi
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ef1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	89 04 24             	mov    %eax,(%esp)
  801efe:	e8 48 fe ff ff       	call   801d4b <fd_lookup>
  801f03:	89 c2                	mov    %eax,%edx
  801f05:	85 d2                	test   %edx,%edx
  801f07:	0f 88 e1 00 00 00    	js     801fee <dup+0x106>
		return r;
	close(newfdnum);
  801f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f10:	89 04 24             	mov    %eax,(%esp)
  801f13:	e8 7b ff ff ff       	call   801e93 <close>

	newfd = INDEX2FD(newfdnum);
  801f18:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801f1b:	c1 e3 0c             	shl    $0xc,%ebx
  801f1e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f27:	89 04 24             	mov    %eax,(%esp)
  801f2a:	e8 91 fd ff ff       	call   801cc0 <fd2data>
  801f2f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801f31:	89 1c 24             	mov    %ebx,(%esp)
  801f34:	e8 87 fd ff ff       	call   801cc0 <fd2data>
  801f39:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f3b:	89 f0                	mov    %esi,%eax
  801f3d:	c1 e8 16             	shr    $0x16,%eax
  801f40:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f47:	a8 01                	test   $0x1,%al
  801f49:	74 43                	je     801f8e <dup+0xa6>
  801f4b:	89 f0                	mov    %esi,%eax
  801f4d:	c1 e8 0c             	shr    $0xc,%eax
  801f50:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f57:	f6 c2 01             	test   $0x1,%dl
  801f5a:	74 32                	je     801f8e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f5c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f63:	25 07 0e 00 00       	and    $0xe07,%eax
  801f68:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f6c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f77:	00 
  801f78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f83:	e8 35 f9 ff ff       	call   8018bd <sys_page_map>
  801f88:	89 c6                	mov    %eax,%esi
  801f8a:	85 c0                	test   %eax,%eax
  801f8c:	78 3e                	js     801fcc <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f91:	89 c2                	mov    %eax,%edx
  801f93:	c1 ea 0c             	shr    $0xc,%edx
  801f96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f9d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801fa3:	89 54 24 10          	mov    %edx,0x10(%esp)
  801fa7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fb2:	00 
  801fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fbe:	e8 fa f8 ff ff       	call   8018bd <sys_page_map>
  801fc3:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801fc8:	85 f6                	test   %esi,%esi
  801fca:	79 22                	jns    801fee <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801fcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd7:	e8 34 f9 ff ff       	call   801910 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801fdc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801fe0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe7:	e8 24 f9 ff ff       	call   801910 <sys_page_unmap>
	return r;
  801fec:	89 f0                	mov    %esi,%eax
}
  801fee:	83 c4 3c             	add    $0x3c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    

00801ff6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
  801ff9:	53                   	push   %ebx
  801ffa:	83 ec 24             	sub    $0x24,%esp
  801ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802000:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	89 1c 24             	mov    %ebx,(%esp)
  80200a:	e8 3c fd ff ff       	call   801d4b <fd_lookup>
  80200f:	89 c2                	mov    %eax,%edx
  802011:	85 d2                	test   %edx,%edx
  802013:	78 6d                	js     802082 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802015:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802018:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201f:	8b 00                	mov    (%eax),%eax
  802021:	89 04 24             	mov    %eax,(%esp)
  802024:	e8 78 fd ff ff       	call   801da1 <dev_lookup>
  802029:	85 c0                	test   %eax,%eax
  80202b:	78 55                	js     802082 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80202d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802030:	8b 50 08             	mov    0x8(%eax),%edx
  802033:	83 e2 03             	and    $0x3,%edx
  802036:	83 fa 01             	cmp    $0x1,%edx
  802039:	75 23                	jne    80205e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80203b:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802040:	8b 40 48             	mov    0x48(%eax),%eax
  802043:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204b:	c7 04 24 18 33 80 00 	movl   $0x803318,(%esp)
  802052:	e8 0f ed ff ff       	call   800d66 <cprintf>
		return -E_INVAL;
  802057:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80205c:	eb 24                	jmp    802082 <read+0x8c>
	}
	if (!dev->dev_read)
  80205e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802061:	8b 52 08             	mov    0x8(%edx),%edx
  802064:	85 d2                	test   %edx,%edx
  802066:	74 15                	je     80207d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802068:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80206f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802072:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	ff d2                	call   *%edx
  80207b:	eb 05                	jmp    802082 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80207d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802082:	83 c4 24             	add    $0x24,%esp
  802085:	5b                   	pop    %ebx
  802086:	5d                   	pop    %ebp
  802087:	c3                   	ret    

00802088 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
  80208b:	57                   	push   %edi
  80208c:	56                   	push   %esi
  80208d:	53                   	push   %ebx
  80208e:	83 ec 1c             	sub    $0x1c,%esp
  802091:	8b 7d 08             	mov    0x8(%ebp),%edi
  802094:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802097:	85 f6                	test   %esi,%esi
  802099:	74 33                	je     8020ce <readn+0x46>
  80209b:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8020a5:	89 f2                	mov    %esi,%edx
  8020a7:	29 c2                	sub    %eax,%edx
  8020a9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020ad:	03 45 0c             	add    0xc(%ebp),%eax
  8020b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b4:	89 3c 24             	mov    %edi,(%esp)
  8020b7:	e8 3a ff ff ff       	call   801ff6 <read>
		if (m < 0)
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	78 1b                	js     8020db <readn+0x53>
			return m;
		if (m == 0)
  8020c0:	85 c0                	test   %eax,%eax
  8020c2:	74 11                	je     8020d5 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8020c4:	01 c3                	add    %eax,%ebx
  8020c6:	89 d8                	mov    %ebx,%eax
  8020c8:	39 f3                	cmp    %esi,%ebx
  8020ca:	72 d9                	jb     8020a5 <readn+0x1d>
  8020cc:	eb 0b                	jmp    8020d9 <readn+0x51>
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	eb 06                	jmp    8020db <readn+0x53>
  8020d5:	89 d8                	mov    %ebx,%eax
  8020d7:	eb 02                	jmp    8020db <readn+0x53>
  8020d9:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8020db:	83 c4 1c             	add    $0x1c,%esp
  8020de:	5b                   	pop    %ebx
  8020df:	5e                   	pop    %esi
  8020e0:	5f                   	pop    %edi
  8020e1:	5d                   	pop    %ebp
  8020e2:	c3                   	ret    

008020e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	53                   	push   %ebx
  8020e7:	83 ec 24             	sub    $0x24,%esp
  8020ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	89 1c 24             	mov    %ebx,(%esp)
  8020f7:	e8 4f fc ff ff       	call   801d4b <fd_lookup>
  8020fc:	89 c2                	mov    %eax,%edx
  8020fe:	85 d2                	test   %edx,%edx
  802100:	78 68                	js     80216a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802102:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802105:	89 44 24 04          	mov    %eax,0x4(%esp)
  802109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80210c:	8b 00                	mov    (%eax),%eax
  80210e:	89 04 24             	mov    %eax,(%esp)
  802111:	e8 8b fc ff ff       	call   801da1 <dev_lookup>
  802116:	85 c0                	test   %eax,%eax
  802118:	78 50                	js     80216a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802121:	75 23                	jne    802146 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802123:	a1 0c 90 80 00       	mov    0x80900c,%eax
  802128:	8b 40 48             	mov    0x48(%eax),%eax
  80212b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80212f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802133:	c7 04 24 34 33 80 00 	movl   $0x803334,(%esp)
  80213a:	e8 27 ec ff ff       	call   800d66 <cprintf>
		return -E_INVAL;
  80213f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802144:	eb 24                	jmp    80216a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802146:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802149:	8b 52 0c             	mov    0xc(%edx),%edx
  80214c:	85 d2                	test   %edx,%edx
  80214e:	74 15                	je     802165 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802150:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802153:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80215a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80215e:	89 04 24             	mov    %eax,(%esp)
  802161:	ff d2                	call   *%edx
  802163:	eb 05                	jmp    80216a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  802165:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80216a:	83 c4 24             	add    $0x24,%esp
  80216d:	5b                   	pop    %ebx
  80216e:	5d                   	pop    %ebp
  80216f:	c3                   	ret    

00802170 <seek>:

int
seek(int fdnum, off_t offset)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802176:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802179:	89 44 24 04          	mov    %eax,0x4(%esp)
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 04 24             	mov    %eax,(%esp)
  802183:	e8 c3 fb ff ff       	call   801d4b <fd_lookup>
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 0e                	js     80219a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80218c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802192:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802195:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	53                   	push   %ebx
  8021a0:	83 ec 24             	sub    $0x24,%esp
  8021a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ad:	89 1c 24             	mov    %ebx,(%esp)
  8021b0:	e8 96 fb ff ff       	call   801d4b <fd_lookup>
  8021b5:	89 c2                	mov    %eax,%edx
  8021b7:	85 d2                	test   %edx,%edx
  8021b9:	78 61                	js     80221c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	89 04 24             	mov    %eax,(%esp)
  8021ca:	e8 d2 fb ff ff       	call   801da1 <dev_lookup>
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	78 49                	js     80221c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d6:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8021da:	75 23                	jne    8021ff <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8021dc:	a1 0c 90 80 00       	mov    0x80900c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021e1:	8b 40 48             	mov    0x48(%eax),%eax
  8021e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ec:	c7 04 24 f4 32 80 00 	movl   $0x8032f4,(%esp)
  8021f3:	e8 6e eb ff ff       	call   800d66 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8021f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021fd:	eb 1d                	jmp    80221c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8021ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802202:	8b 52 18             	mov    0x18(%edx),%edx
  802205:	85 d2                	test   %edx,%edx
  802207:	74 0e                	je     802217 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802209:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80220c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802210:	89 04 24             	mov    %eax,(%esp)
  802213:	ff d2                	call   *%edx
  802215:	eb 05                	jmp    80221c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  802217:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80221c:	83 c4 24             	add    $0x24,%esp
  80221f:	5b                   	pop    %ebx
  802220:	5d                   	pop    %ebp
  802221:	c3                   	ret    

00802222 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	53                   	push   %ebx
  802226:	83 ec 24             	sub    $0x24,%esp
  802229:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80222c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80222f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802233:	8b 45 08             	mov    0x8(%ebp),%eax
  802236:	89 04 24             	mov    %eax,(%esp)
  802239:	e8 0d fb ff ff       	call   801d4b <fd_lookup>
  80223e:	89 c2                	mov    %eax,%edx
  802240:	85 d2                	test   %edx,%edx
  802242:	78 52                	js     802296 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	89 04 24             	mov    %eax,(%esp)
  802253:	e8 49 fb ff ff       	call   801da1 <dev_lookup>
  802258:	85 c0                	test   %eax,%eax
  80225a:	78 3a                	js     802296 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  80225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802263:	74 2c                	je     802291 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802265:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802268:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80226f:	00 00 00 
	stat->st_isdir = 0;
  802272:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802279:	00 00 00 
	stat->st_dev = dev;
  80227c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802286:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802289:	89 14 24             	mov    %edx,(%esp)
  80228c:	ff 50 14             	call   *0x14(%eax)
  80228f:	eb 05                	jmp    802296 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802291:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  802296:	83 c4 24             	add    $0x24,%esp
  802299:	5b                   	pop    %ebx
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	56                   	push   %esi
  8022a0:	53                   	push   %ebx
  8022a1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8022a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022ab:	00 
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	89 04 24             	mov    %eax,(%esp)
  8022b2:	e8 af 01 00 00       	call   802466 <open>
  8022b7:	89 c3                	mov    %eax,%ebx
  8022b9:	85 db                	test   %ebx,%ebx
  8022bb:	78 1b                	js     8022d8 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c4:	89 1c 24             	mov    %ebx,(%esp)
  8022c7:	e8 56 ff ff ff       	call   802222 <fstat>
  8022cc:	89 c6                	mov    %eax,%esi
	close(fd);
  8022ce:	89 1c 24             	mov    %ebx,(%esp)
  8022d1:	e8 bd fb ff ff       	call   801e93 <close>
	return r;
  8022d6:	89 f0                	mov    %esi,%eax
}
  8022d8:	83 c4 10             	add    $0x10,%esp
  8022db:	5b                   	pop    %ebx
  8022dc:	5e                   	pop    %esi
  8022dd:	5d                   	pop    %ebp
  8022de:	c3                   	ret    

008022df <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8022df:	55                   	push   %ebp
  8022e0:	89 e5                	mov    %esp,%ebp
  8022e2:	56                   	push   %esi
  8022e3:	53                   	push   %ebx
  8022e4:	83 ec 10             	sub    $0x10,%esp
  8022e7:	89 c6                	mov    %eax,%esi
  8022e9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8022eb:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  8022f2:	75 11                	jne    802305 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8022f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8022fb:	e8 59 f9 ff ff       	call   801c59 <ipc_find_env>
  802300:	a3 00 90 80 00       	mov    %eax,0x809000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802305:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80230c:	00 
  80230d:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  802314:	00 
  802315:	89 74 24 04          	mov    %esi,0x4(%esp)
  802319:	a1 00 90 80 00       	mov    0x809000,%eax
  80231e:	89 04 24             	mov    %eax,(%esp)
  802321:	e8 cd f8 ff ff       	call   801bf3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802326:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80232d:	00 
  80232e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802332:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802339:	e8 4d f8 ff ff       	call   801b8b <ipc_recv>
}
  80233e:	83 c4 10             	add    $0x10,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5d                   	pop    %ebp
  802344:	c3                   	ret    

00802345 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802345:	55                   	push   %ebp
  802346:	89 e5                	mov    %esp,%ebp
  802348:	53                   	push   %ebx
  802349:	83 ec 14             	sub    $0x14,%esp
  80234c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	8b 40 0c             	mov    0xc(%eax),%eax
  802355:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80235a:	ba 00 00 00 00       	mov    $0x0,%edx
  80235f:	b8 05 00 00 00       	mov    $0x5,%eax
  802364:	e8 76 ff ff ff       	call   8022df <fsipc>
  802369:	89 c2                	mov    %eax,%edx
  80236b:	85 d2                	test   %edx,%edx
  80236d:	78 2b                	js     80239a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80236f:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802376:	00 
  802377:	89 1c 24             	mov    %ebx,(%esp)
  80237a:	e8 3c f0 ff ff       	call   8013bb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80237f:	a1 80 a0 80 00       	mov    0x80a080,%eax
  802384:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80238a:	a1 84 a0 80 00       	mov    0x80a084,%eax
  80238f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239a:	83 c4 14             	add    $0x14,%esp
  80239d:	5b                   	pop    %ebx
  80239e:	5d                   	pop    %ebp
  80239f:	c3                   	ret    

008023a0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8023a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ac:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  8023b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8023b6:	b8 06 00 00 00       	mov    $0x6,%eax
  8023bb:	e8 1f ff ff ff       	call   8022df <fsipc>
}
  8023c0:	c9                   	leave  
  8023c1:	c3                   	ret    

008023c2 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8023c2:	55                   	push   %ebp
  8023c3:	89 e5                	mov    %esp,%ebp
  8023c5:	56                   	push   %esi
  8023c6:	53                   	push   %ebx
  8023c7:	83 ec 10             	sub    $0x10,%esp
  8023ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d3:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  8023d8:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8023de:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e3:	b8 03 00 00 00       	mov    $0x3,%eax
  8023e8:	e8 f2 fe ff ff       	call   8022df <fsipc>
  8023ed:	89 c3                	mov    %eax,%ebx
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	78 6a                	js     80245d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  8023f3:	39 c6                	cmp    %eax,%esi
  8023f5:	73 24                	jae    80241b <devfile_read+0x59>
  8023f7:	c7 44 24 0c 51 33 80 	movl   $0x803351,0xc(%esp)
  8023fe:	00 
  8023ff:	c7 44 24 08 7d 2d 80 	movl   $0x802d7d,0x8(%esp)
  802406:	00 
  802407:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  80240e:	00 
  80240f:	c7 04 24 58 33 80 00 	movl   $0x803358,(%esp)
  802416:	e8 52 e8 ff ff       	call   800c6d <_panic>
	assert(r <= PGSIZE);
  80241b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802420:	7e 24                	jle    802446 <devfile_read+0x84>
  802422:	c7 44 24 0c 63 33 80 	movl   $0x803363,0xc(%esp)
  802429:	00 
  80242a:	c7 44 24 08 7d 2d 80 	movl   $0x802d7d,0x8(%esp)
  802431:	00 
  802432:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  802439:	00 
  80243a:	c7 04 24 58 33 80 00 	movl   $0x803358,(%esp)
  802441:	e8 27 e8 ff ff       	call   800c6d <_panic>
	memmove(buf, &fsipcbuf, r);
  802446:	89 44 24 08          	mov    %eax,0x8(%esp)
  80244a:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  802451:	00 
  802452:	8b 45 0c             	mov    0xc(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 59 f1 ff ff       	call   8015b6 <memmove>
	return r;
}
  80245d:	89 d8                	mov    %ebx,%eax
  80245f:	83 c4 10             	add    $0x10,%esp
  802462:	5b                   	pop    %ebx
  802463:	5e                   	pop    %esi
  802464:	5d                   	pop    %ebp
  802465:	c3                   	ret    

00802466 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	53                   	push   %ebx
  80246a:	83 ec 24             	sub    $0x24,%esp
  80246d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  802470:	89 1c 24             	mov    %ebx,(%esp)
  802473:	e8 e8 ee ff ff       	call   801360 <strlen>
  802478:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80247d:	7f 60                	jg     8024df <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80247f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802482:	89 04 24             	mov    %eax,(%esp)
  802485:	e8 4d f8 ff ff       	call   801cd7 <fd_alloc>
  80248a:	89 c2                	mov    %eax,%edx
  80248c:	85 d2                	test   %edx,%edx
  80248e:	78 54                	js     8024e4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802490:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802494:	c7 04 24 00 a0 80 00 	movl   $0x80a000,(%esp)
  80249b:	e8 1b ef ff ff       	call   8013bb <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a3:	a3 00 a4 80 00       	mov    %eax,0x80a400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b0:	e8 2a fe ff ff       	call   8022df <fsipc>
  8024b5:	89 c3                	mov    %eax,%ebx
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	79 17                	jns    8024d2 <open+0x6c>
		fd_close(fd, 0);
  8024bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024c2:	00 
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	89 04 24             	mov    %eax,(%esp)
  8024c9:	e8 44 f9 ff ff       	call   801e12 <fd_close>
		return r;
  8024ce:	89 d8                	mov    %ebx,%eax
  8024d0:	eb 12                	jmp    8024e4 <open+0x7e>
	}
	return fd2num(fd);
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	89 04 24             	mov    %eax,(%esp)
  8024d8:	e8 d3 f7 ff ff       	call   801cb0 <fd2num>
  8024dd:	eb 05                	jmp    8024e4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  8024df:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  8024e4:	83 c4 24             	add    $0x24,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5d                   	pop    %ebp
  8024e9:	c3                   	ret    

008024ea <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8024f0:	89 d0                	mov    %edx,%eax
  8024f2:	c1 e8 16             	shr    $0x16,%eax
  8024f5:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8024fc:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802501:	f6 c1 01             	test   $0x1,%cl
  802504:	74 1d                	je     802523 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802506:	c1 ea 0c             	shr    $0xc,%edx
  802509:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802510:	f6 c2 01             	test   $0x1,%dl
  802513:	74 0e                	je     802523 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802515:	c1 ea 0c             	shr    $0xc,%edx
  802518:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80251f:	ef 
  802520:	0f b7 c0             	movzwl %ax,%eax
}
  802523:	5d                   	pop    %ebp
  802524:	c3                   	ret    
  802525:	66 90                	xchg   %ax,%ax
  802527:	66 90                	xchg   %ax,%ax
  802529:	66 90                	xchg   %ax,%ax
  80252b:	66 90                	xchg   %ax,%ax
  80252d:	66 90                	xchg   %ax,%ax
  80252f:	90                   	nop

00802530 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	56                   	push   %esi
  802534:	53                   	push   %ebx
  802535:	83 ec 10             	sub    $0x10,%esp
  802538:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	89 04 24             	mov    %eax,(%esp)
  802541:	e8 7a f7 ff ff       	call   801cc0 <fd2data>
  802546:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802548:	c7 44 24 04 6f 33 80 	movl   $0x80336f,0x4(%esp)
  80254f:	00 
  802550:	89 1c 24             	mov    %ebx,(%esp)
  802553:	e8 63 ee ff ff       	call   8013bb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802558:	8b 46 04             	mov    0x4(%esi),%eax
  80255b:	2b 06                	sub    (%esi),%eax
  80255d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  802563:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80256a:	00 00 00 
	stat->st_dev = &devpipe;
  80256d:	c7 83 88 00 00 00 60 	movl   $0x808060,0x88(%ebx)
  802574:	80 80 00 
	return 0;
}
  802577:	b8 00 00 00 00       	mov    $0x0,%eax
  80257c:	83 c4 10             	add    $0x10,%esp
  80257f:	5b                   	pop    %ebx
  802580:	5e                   	pop    %esi
  802581:	5d                   	pop    %ebp
  802582:	c3                   	ret    

00802583 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
  802586:	53                   	push   %ebx
  802587:	83 ec 14             	sub    $0x14,%esp
  80258a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80258d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802591:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802598:	e8 73 f3 ff ff       	call   801910 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80259d:	89 1c 24             	mov    %ebx,(%esp)
  8025a0:	e8 1b f7 ff ff       	call   801cc0 <fd2data>
  8025a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025b0:	e8 5b f3 ff ff       	call   801910 <sys_page_unmap>
}
  8025b5:	83 c4 14             	add    $0x14,%esp
  8025b8:	5b                   	pop    %ebx
  8025b9:	5d                   	pop    %ebp
  8025ba:	c3                   	ret    

008025bb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	57                   	push   %edi
  8025bf:	56                   	push   %esi
  8025c0:	53                   	push   %ebx
  8025c1:	83 ec 2c             	sub    $0x2c,%esp
  8025c4:	89 c6                	mov    %eax,%esi
  8025c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8025c9:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8025ce:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025d1:	89 34 24             	mov    %esi,(%esp)
  8025d4:	e8 11 ff ff ff       	call   8024ea <pageref>
  8025d9:	89 c7                	mov    %eax,%edi
  8025db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025de:	89 04 24             	mov    %eax,(%esp)
  8025e1:	e8 04 ff ff ff       	call   8024ea <pageref>
  8025e6:	39 c7                	cmp    %eax,%edi
  8025e8:	0f 94 c2             	sete   %dl
  8025eb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8025ee:	8b 0d 0c 90 80 00    	mov    0x80900c,%ecx
  8025f4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8025f7:	39 fb                	cmp    %edi,%ebx
  8025f9:	74 21                	je     80261c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8025fb:	84 d2                	test   %dl,%dl
  8025fd:	74 ca                	je     8025c9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8025ff:	8b 51 58             	mov    0x58(%ecx),%edx
  802602:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802606:	89 54 24 08          	mov    %edx,0x8(%esp)
  80260a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80260e:	c7 04 24 76 33 80 00 	movl   $0x803376,(%esp)
  802615:	e8 4c e7 ff ff       	call   800d66 <cprintf>
  80261a:	eb ad                	jmp    8025c9 <_pipeisclosed+0xe>
	}
}
  80261c:	83 c4 2c             	add    $0x2c,%esp
  80261f:	5b                   	pop    %ebx
  802620:	5e                   	pop    %esi
  802621:	5f                   	pop    %edi
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    

00802624 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
  802627:	57                   	push   %edi
  802628:	56                   	push   %esi
  802629:	53                   	push   %ebx
  80262a:	83 ec 1c             	sub    $0x1c,%esp
  80262d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802630:	89 34 24             	mov    %esi,(%esp)
  802633:	e8 88 f6 ff ff       	call   801cc0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802638:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263c:	74 61                	je     80269f <devpipe_write+0x7b>
  80263e:	89 c3                	mov    %eax,%ebx
  802640:	bf 00 00 00 00       	mov    $0x0,%edi
  802645:	eb 4a                	jmp    802691 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802647:	89 da                	mov    %ebx,%edx
  802649:	89 f0                	mov    %esi,%eax
  80264b:	e8 6b ff ff ff       	call   8025bb <_pipeisclosed>
  802650:	85 c0                	test   %eax,%eax
  802652:	75 54                	jne    8026a8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802654:	e8 f1 f1 ff ff       	call   80184a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802659:	8b 43 04             	mov    0x4(%ebx),%eax
  80265c:	8b 0b                	mov    (%ebx),%ecx
  80265e:	8d 51 20             	lea    0x20(%ecx),%edx
  802661:	39 d0                	cmp    %edx,%eax
  802663:	73 e2                	jae    802647 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802668:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80266c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  80266f:	99                   	cltd   
  802670:	c1 ea 1b             	shr    $0x1b,%edx
  802673:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802676:	83 e1 1f             	and    $0x1f,%ecx
  802679:	29 d1                	sub    %edx,%ecx
  80267b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  80267f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802683:	83 c0 01             	add    $0x1,%eax
  802686:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802689:	83 c7 01             	add    $0x1,%edi
  80268c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80268f:	74 13                	je     8026a4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802691:	8b 43 04             	mov    0x4(%ebx),%eax
  802694:	8b 0b                	mov    (%ebx),%ecx
  802696:	8d 51 20             	lea    0x20(%ecx),%edx
  802699:	39 d0                	cmp    %edx,%eax
  80269b:	73 aa                	jae    802647 <devpipe_write+0x23>
  80269d:	eb c6                	jmp    802665 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80269f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8026a4:	89 f8                	mov    %edi,%eax
  8026a6:	eb 05                	jmp    8026ad <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026a8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8026ad:	83 c4 1c             	add    $0x1c,%esp
  8026b0:	5b                   	pop    %ebx
  8026b1:	5e                   	pop    %esi
  8026b2:	5f                   	pop    %edi
  8026b3:	5d                   	pop    %ebp
  8026b4:	c3                   	ret    

008026b5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026b5:	55                   	push   %ebp
  8026b6:	89 e5                	mov    %esp,%ebp
  8026b8:	57                   	push   %edi
  8026b9:	56                   	push   %esi
  8026ba:	53                   	push   %ebx
  8026bb:	83 ec 1c             	sub    $0x1c,%esp
  8026be:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026c1:	89 3c 24             	mov    %edi,(%esp)
  8026c4:	e8 f7 f5 ff ff       	call   801cc0 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026cd:	74 54                	je     802723 <devpipe_read+0x6e>
  8026cf:	89 c3                	mov    %eax,%ebx
  8026d1:	be 00 00 00 00       	mov    $0x0,%esi
  8026d6:	eb 3e                	jmp    802716 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8026d8:	89 f0                	mov    %esi,%eax
  8026da:	eb 55                	jmp    802731 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026dc:	89 da                	mov    %ebx,%edx
  8026de:	89 f8                	mov    %edi,%eax
  8026e0:	e8 d6 fe ff ff       	call   8025bb <_pipeisclosed>
  8026e5:	85 c0                	test   %eax,%eax
  8026e7:	75 43                	jne    80272c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026e9:	e8 5c f1 ff ff       	call   80184a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026ee:	8b 03                	mov    (%ebx),%eax
  8026f0:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026f3:	74 e7                	je     8026dc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026f5:	99                   	cltd   
  8026f6:	c1 ea 1b             	shr    $0x1b,%edx
  8026f9:	01 d0                	add    %edx,%eax
  8026fb:	83 e0 1f             	and    $0x1f,%eax
  8026fe:	29 d0                	sub    %edx,%eax
  802700:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802705:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802708:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80270b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270e:	83 c6 01             	add    $0x1,%esi
  802711:	3b 75 10             	cmp    0x10(%ebp),%esi
  802714:	74 12                	je     802728 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802716:	8b 03                	mov    (%ebx),%eax
  802718:	3b 43 04             	cmp    0x4(%ebx),%eax
  80271b:	75 d8                	jne    8026f5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80271d:	85 f6                	test   %esi,%esi
  80271f:	75 b7                	jne    8026d8 <devpipe_read+0x23>
  802721:	eb b9                	jmp    8026dc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802723:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802728:	89 f0                	mov    %esi,%eax
  80272a:	eb 05                	jmp    802731 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  802731:	83 c4 1c             	add    $0x1c,%esp
  802734:	5b                   	pop    %ebx
  802735:	5e                   	pop    %esi
  802736:	5f                   	pop    %edi
  802737:	5d                   	pop    %ebp
  802738:	c3                   	ret    

00802739 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	56                   	push   %esi
  80273d:	53                   	push   %ebx
  80273e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802741:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802744:	89 04 24             	mov    %eax,(%esp)
  802747:	e8 8b f5 ff ff       	call   801cd7 <fd_alloc>
  80274c:	89 c2                	mov    %eax,%edx
  80274e:	85 d2                	test   %edx,%edx
  802750:	0f 88 4d 01 00 00    	js     8028a3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802756:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80275d:	00 
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	89 44 24 04          	mov    %eax,0x4(%esp)
  802765:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80276c:	e8 f8 f0 ff ff       	call   801869 <sys_page_alloc>
  802771:	89 c2                	mov    %eax,%edx
  802773:	85 d2                	test   %edx,%edx
  802775:	0f 88 28 01 00 00    	js     8028a3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  80277b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80277e:	89 04 24             	mov    %eax,(%esp)
  802781:	e8 51 f5 ff ff       	call   801cd7 <fd_alloc>
  802786:	89 c3                	mov    %eax,%ebx
  802788:	85 c0                	test   %eax,%eax
  80278a:	0f 88 fe 00 00 00    	js     80288e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802790:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802797:	00 
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a6:	e8 be f0 ff ff       	call   801869 <sys_page_alloc>
  8027ab:	89 c3                	mov    %eax,%ebx
  8027ad:	85 c0                	test   %eax,%eax
  8027af:	0f 88 d9 00 00 00    	js     80288e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	89 04 24             	mov    %eax,(%esp)
  8027bb:	e8 00 f5 ff ff       	call   801cc0 <fd2data>
  8027c0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027c2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c9:	00 
  8027ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d5:	e8 8f f0 ff ff       	call   801869 <sys_page_alloc>
  8027da:	89 c3                	mov    %eax,%ebx
  8027dc:	85 c0                	test   %eax,%eax
  8027de:	0f 88 97 00 00 00    	js     80287b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	89 04 24             	mov    %eax,(%esp)
  8027ea:	e8 d1 f4 ff ff       	call   801cc0 <fd2data>
  8027ef:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8027f6:	00 
  8027f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802802:	00 
  802803:	89 74 24 04          	mov    %esi,0x4(%esp)
  802807:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80280e:	e8 aa f0 ff ff       	call   8018bd <sys_page_map>
  802813:	89 c3                	mov    %eax,%ebx
  802815:	85 c0                	test   %eax,%eax
  802817:	78 52                	js     80286b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802819:	8b 15 60 80 80 00    	mov    0x808060,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80282e:	8b 15 60 80 80 00    	mov    0x808060,%edx
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  802843:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802846:	89 04 24             	mov    %eax,(%esp)
  802849:	e8 62 f4 ff ff       	call   801cb0 <fd2num>
  80284e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802851:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802853:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802856:	89 04 24             	mov    %eax,(%esp)
  802859:	e8 52 f4 ff ff       	call   801cb0 <fd2num>
  80285e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802861:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	eb 38                	jmp    8028a3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80286b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80286f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802876:	e8 95 f0 ff ff       	call   801910 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80287b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802882:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802889:	e8 82 f0 ff ff       	call   801910 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 44 24 04          	mov    %eax,0x4(%esp)
  802895:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289c:	e8 6f f0 ff ff       	call   801910 <sys_page_unmap>
  8028a1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8028a3:	83 c4 30             	add    $0x30,%esp
  8028a6:	5b                   	pop    %ebx
  8028a7:	5e                   	pop    %esi
  8028a8:	5d                   	pop    %ebp
  8028a9:	c3                   	ret    

008028aa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8028aa:	55                   	push   %ebp
  8028ab:	89 e5                	mov    %esp,%ebp
  8028ad:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	89 04 24             	mov    %eax,(%esp)
  8028bd:	e8 89 f4 ff ff       	call   801d4b <fd_lookup>
  8028c2:	89 c2                	mov    %eax,%edx
  8028c4:	85 d2                	test   %edx,%edx
  8028c6:	78 15                	js     8028dd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	89 04 24             	mov    %eax,(%esp)
  8028ce:	e8 ed f3 ff ff       	call   801cc0 <fd2data>
	return _pipeisclosed(fd, p);
  8028d3:	89 c2                	mov    %eax,%edx
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	e8 de fc ff ff       	call   8025bb <_pipeisclosed>
}
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    
  8028df:	90                   	nop

008028e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

008028ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028f0:	c7 44 24 04 8e 33 80 	movl   $0x80338e,0x4(%esp)
  8028f7:	00 
  8028f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fb:	89 04 24             	mov    %eax,(%esp)
  8028fe:	e8 b8 ea ff ff       	call   8013bb <strcpy>
	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	57                   	push   %edi
  80290e:	56                   	push   %esi
  80290f:	53                   	push   %ebx
  802910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802916:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80291a:	74 4a                	je     802966 <devcons_write+0x5c>
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
  802921:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802926:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80292c:	8b 75 10             	mov    0x10(%ebp),%esi
  80292f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802931:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802934:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802939:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80293c:	89 74 24 08          	mov    %esi,0x8(%esp)
  802940:	03 45 0c             	add    0xc(%ebp),%eax
  802943:	89 44 24 04          	mov    %eax,0x4(%esp)
  802947:	89 3c 24             	mov    %edi,(%esp)
  80294a:	e8 67 ec ff ff       	call   8015b6 <memmove>
		sys_cputs(buf, m);
  80294f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802953:	89 3c 24             	mov    %edi,(%esp)
  802956:	e8 41 ee ff ff       	call   80179c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80295b:	01 f3                	add    %esi,%ebx
  80295d:	89 d8                	mov    %ebx,%eax
  80295f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802962:	72 c8                	jb     80292c <devcons_write+0x22>
  802964:	eb 05                	jmp    80296b <devcons_write+0x61>
  802966:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80296b:	89 d8                	mov    %ebx,%eax
  80296d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802973:	5b                   	pop    %ebx
  802974:	5e                   	pop    %esi
  802975:	5f                   	pop    %edi
  802976:	5d                   	pop    %ebp
  802977:	c3                   	ret    

00802978 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802978:	55                   	push   %ebp
  802979:	89 e5                	mov    %esp,%ebp
  80297b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802983:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802987:	75 07                	jne    802990 <devcons_read+0x18>
  802989:	eb 28                	jmp    8029b3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80298b:	e8 ba ee ff ff       	call   80184a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802990:	e8 25 ee ff ff       	call   8017ba <sys_cgetc>
  802995:	85 c0                	test   %eax,%eax
  802997:	74 f2                	je     80298b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802999:	85 c0                	test   %eax,%eax
  80299b:	78 16                	js     8029b3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80299d:	83 f8 04             	cmp    $0x4,%eax
  8029a0:	74 0c                	je     8029ae <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8029a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029a5:	88 02                	mov    %al,(%edx)
	return 1;
  8029a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ac:	eb 05                	jmp    8029b3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8029ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029c8:	00 
  8029c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029cc:	89 04 24             	mov    %eax,(%esp)
  8029cf:	e8 c8 ed ff ff       	call   80179c <sys_cputs>
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <getchar>:

int
getchar(void)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029e3:	00 
  8029e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029f2:	e8 ff f5 ff ff       	call   801ff6 <read>
	if (r < 0)
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	78 0f                	js     802a0a <getchar+0x34>
		return r;
	if (r < 1)
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	7e 06                	jle    802a05 <getchar+0x2f>
		return -E_EOF;
	return c;
  8029ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802a03:	eb 05                	jmp    802a0a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802a05:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  802a0a:	c9                   	leave  
  802a0b:	c3                   	ret    

00802a0c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
  802a0f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a12:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 27 f3 ff ff       	call   801d4b <fd_lookup>
  802a24:	85 c0                	test   %eax,%eax
  802a26:	78 11                	js     802a39 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802a31:	39 10                	cmp    %edx,(%eax)
  802a33:	0f 94 c0             	sete   %al
  802a36:	0f b6 c0             	movzbl %al,%eax
}
  802a39:	c9                   	leave  
  802a3a:	c3                   	ret    

00802a3b <opencons>:

int
opencons(void)
{
  802a3b:	55                   	push   %ebp
  802a3c:	89 e5                	mov    %esp,%ebp
  802a3e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a41:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a44:	89 04 24             	mov    %eax,(%esp)
  802a47:	e8 8b f2 ff ff       	call   801cd7 <fd_alloc>
		return r;
  802a4c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	78 40                	js     802a92 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a52:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a59:	00 
  802a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a68:	e8 fc ed ff ff       	call   801869 <sys_page_alloc>
		return r;
  802a6d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	78 1f                	js     802a92 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a73:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a88:	89 04 24             	mov    %eax,(%esp)
  802a8b:	e8 20 f2 ff ff       	call   801cb0 <fd2num>
  802a90:	89 c2                	mov    %eax,%edx
}
  802a92:	89 d0                	mov    %edx,%eax
  802a94:	c9                   	leave  
  802a95:	c3                   	ret    
  802a96:	66 90                	xchg   %ax,%ax
  802a98:	66 90                	xchg   %ax,%ax
  802a9a:	66 90                	xchg   %ax,%ax
  802a9c:	66 90                	xchg   %ax,%ax
  802a9e:	66 90                	xchg   %ax,%ax

00802aa0 <__udivdi3>:
  802aa0:	55                   	push   %ebp
  802aa1:	57                   	push   %edi
  802aa2:	56                   	push   %esi
  802aa3:	83 ec 0c             	sub    $0xc,%esp
  802aa6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802aaa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802aae:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802ab2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802abc:	89 ea                	mov    %ebp,%edx
  802abe:	89 0c 24             	mov    %ecx,(%esp)
  802ac1:	75 2d                	jne    802af0 <__udivdi3+0x50>
  802ac3:	39 e9                	cmp    %ebp,%ecx
  802ac5:	77 61                	ja     802b28 <__udivdi3+0x88>
  802ac7:	85 c9                	test   %ecx,%ecx
  802ac9:	89 ce                	mov    %ecx,%esi
  802acb:	75 0b                	jne    802ad8 <__udivdi3+0x38>
  802acd:	b8 01 00 00 00       	mov    $0x1,%eax
  802ad2:	31 d2                	xor    %edx,%edx
  802ad4:	f7 f1                	div    %ecx
  802ad6:	89 c6                	mov    %eax,%esi
  802ad8:	31 d2                	xor    %edx,%edx
  802ada:	89 e8                	mov    %ebp,%eax
  802adc:	f7 f6                	div    %esi
  802ade:	89 c5                	mov    %eax,%ebp
  802ae0:	89 f8                	mov    %edi,%eax
  802ae2:	f7 f6                	div    %esi
  802ae4:	89 ea                	mov    %ebp,%edx
  802ae6:	83 c4 0c             	add    $0xc,%esp
  802ae9:	5e                   	pop    %esi
  802aea:	5f                   	pop    %edi
  802aeb:	5d                   	pop    %ebp
  802aec:	c3                   	ret    
  802aed:	8d 76 00             	lea    0x0(%esi),%esi
  802af0:	39 e8                	cmp    %ebp,%eax
  802af2:	77 24                	ja     802b18 <__udivdi3+0x78>
  802af4:	0f bd e8             	bsr    %eax,%ebp
  802af7:	83 f5 1f             	xor    $0x1f,%ebp
  802afa:	75 3c                	jne    802b38 <__udivdi3+0x98>
  802afc:	8b 74 24 04          	mov    0x4(%esp),%esi
  802b00:	39 34 24             	cmp    %esi,(%esp)
  802b03:	0f 86 9f 00 00 00    	jbe    802ba8 <__udivdi3+0x108>
  802b09:	39 d0                	cmp    %edx,%eax
  802b0b:	0f 82 97 00 00 00    	jb     802ba8 <__udivdi3+0x108>
  802b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802b18:	31 d2                	xor    %edx,%edx
  802b1a:	31 c0                	xor    %eax,%eax
  802b1c:	83 c4 0c             	add    $0xc,%esp
  802b1f:	5e                   	pop    %esi
  802b20:	5f                   	pop    %edi
  802b21:	5d                   	pop    %ebp
  802b22:	c3                   	ret    
  802b23:	90                   	nop
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	89 f8                	mov    %edi,%eax
  802b2a:	f7 f1                	div    %ecx
  802b2c:	31 d2                	xor    %edx,%edx
  802b2e:	83 c4 0c             	add    $0xc,%esp
  802b31:	5e                   	pop    %esi
  802b32:	5f                   	pop    %edi
  802b33:	5d                   	pop    %ebp
  802b34:	c3                   	ret    
  802b35:	8d 76 00             	lea    0x0(%esi),%esi
  802b38:	89 e9                	mov    %ebp,%ecx
  802b3a:	8b 3c 24             	mov    (%esp),%edi
  802b3d:	d3 e0                	shl    %cl,%eax
  802b3f:	89 c6                	mov    %eax,%esi
  802b41:	b8 20 00 00 00       	mov    $0x20,%eax
  802b46:	29 e8                	sub    %ebp,%eax
  802b48:	89 c1                	mov    %eax,%ecx
  802b4a:	d3 ef                	shr    %cl,%edi
  802b4c:	89 e9                	mov    %ebp,%ecx
  802b4e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b52:	8b 3c 24             	mov    (%esp),%edi
  802b55:	09 74 24 08          	or     %esi,0x8(%esp)
  802b59:	89 d6                	mov    %edx,%esi
  802b5b:	d3 e7                	shl    %cl,%edi
  802b5d:	89 c1                	mov    %eax,%ecx
  802b5f:	89 3c 24             	mov    %edi,(%esp)
  802b62:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b66:	d3 ee                	shr    %cl,%esi
  802b68:	89 e9                	mov    %ebp,%ecx
  802b6a:	d3 e2                	shl    %cl,%edx
  802b6c:	89 c1                	mov    %eax,%ecx
  802b6e:	d3 ef                	shr    %cl,%edi
  802b70:	09 d7                	or     %edx,%edi
  802b72:	89 f2                	mov    %esi,%edx
  802b74:	89 f8                	mov    %edi,%eax
  802b76:	f7 74 24 08          	divl   0x8(%esp)
  802b7a:	89 d6                	mov    %edx,%esi
  802b7c:	89 c7                	mov    %eax,%edi
  802b7e:	f7 24 24             	mull   (%esp)
  802b81:	39 d6                	cmp    %edx,%esi
  802b83:	89 14 24             	mov    %edx,(%esp)
  802b86:	72 30                	jb     802bb8 <__udivdi3+0x118>
  802b88:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b8c:	89 e9                	mov    %ebp,%ecx
  802b8e:	d3 e2                	shl    %cl,%edx
  802b90:	39 c2                	cmp    %eax,%edx
  802b92:	73 05                	jae    802b99 <__udivdi3+0xf9>
  802b94:	3b 34 24             	cmp    (%esp),%esi
  802b97:	74 1f                	je     802bb8 <__udivdi3+0x118>
  802b99:	89 f8                	mov    %edi,%eax
  802b9b:	31 d2                	xor    %edx,%edx
  802b9d:	e9 7a ff ff ff       	jmp    802b1c <__udivdi3+0x7c>
  802ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ba8:	31 d2                	xor    %edx,%edx
  802baa:	b8 01 00 00 00       	mov    $0x1,%eax
  802baf:	e9 68 ff ff ff       	jmp    802b1c <__udivdi3+0x7c>
  802bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb8:	8d 47 ff             	lea    -0x1(%edi),%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	83 c4 0c             	add    $0xc,%esp
  802bc0:	5e                   	pop    %esi
  802bc1:	5f                   	pop    %edi
  802bc2:	5d                   	pop    %ebp
  802bc3:	c3                   	ret    
  802bc4:	66 90                	xchg   %ax,%ax
  802bc6:	66 90                	xchg   %ax,%ax
  802bc8:	66 90                	xchg   %ax,%ax
  802bca:	66 90                	xchg   %ax,%ax
  802bcc:	66 90                	xchg   %ax,%ax
  802bce:	66 90                	xchg   %ax,%ax

00802bd0 <__umoddi3>:
  802bd0:	55                   	push   %ebp
  802bd1:	57                   	push   %edi
  802bd2:	56                   	push   %esi
  802bd3:	83 ec 14             	sub    $0x14,%esp
  802bd6:	8b 44 24 28          	mov    0x28(%esp),%eax
  802bda:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802bde:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802be2:	89 c7                	mov    %eax,%edi
  802be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802be8:	8b 44 24 30          	mov    0x30(%esp),%eax
  802bec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802bf0:	89 34 24             	mov    %esi,(%esp)
  802bf3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bf7:	85 c0                	test   %eax,%eax
  802bf9:	89 c2                	mov    %eax,%edx
  802bfb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bff:	75 17                	jne    802c18 <__umoddi3+0x48>
  802c01:	39 fe                	cmp    %edi,%esi
  802c03:	76 4b                	jbe    802c50 <__umoddi3+0x80>
  802c05:	89 c8                	mov    %ecx,%eax
  802c07:	89 fa                	mov    %edi,%edx
  802c09:	f7 f6                	div    %esi
  802c0b:	89 d0                	mov    %edx,%eax
  802c0d:	31 d2                	xor    %edx,%edx
  802c0f:	83 c4 14             	add    $0x14,%esp
  802c12:	5e                   	pop    %esi
  802c13:	5f                   	pop    %edi
  802c14:	5d                   	pop    %ebp
  802c15:	c3                   	ret    
  802c16:	66 90                	xchg   %ax,%ax
  802c18:	39 f8                	cmp    %edi,%eax
  802c1a:	77 54                	ja     802c70 <__umoddi3+0xa0>
  802c1c:	0f bd e8             	bsr    %eax,%ebp
  802c1f:	83 f5 1f             	xor    $0x1f,%ebp
  802c22:	75 5c                	jne    802c80 <__umoddi3+0xb0>
  802c24:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c28:	39 3c 24             	cmp    %edi,(%esp)
  802c2b:	0f 87 e7 00 00 00    	ja     802d18 <__umoddi3+0x148>
  802c31:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802c35:	29 f1                	sub    %esi,%ecx
  802c37:	19 c7                	sbb    %eax,%edi
  802c39:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802c3d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c41:	8b 44 24 08          	mov    0x8(%esp),%eax
  802c45:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802c49:	83 c4 14             	add    $0x14,%esp
  802c4c:	5e                   	pop    %esi
  802c4d:	5f                   	pop    %edi
  802c4e:	5d                   	pop    %ebp
  802c4f:	c3                   	ret    
  802c50:	85 f6                	test   %esi,%esi
  802c52:	89 f5                	mov    %esi,%ebp
  802c54:	75 0b                	jne    802c61 <__umoddi3+0x91>
  802c56:	b8 01 00 00 00       	mov    $0x1,%eax
  802c5b:	31 d2                	xor    %edx,%edx
  802c5d:	f7 f6                	div    %esi
  802c5f:	89 c5                	mov    %eax,%ebp
  802c61:	8b 44 24 04          	mov    0x4(%esp),%eax
  802c65:	31 d2                	xor    %edx,%edx
  802c67:	f7 f5                	div    %ebp
  802c69:	89 c8                	mov    %ecx,%eax
  802c6b:	f7 f5                	div    %ebp
  802c6d:	eb 9c                	jmp    802c0b <__umoddi3+0x3b>
  802c6f:	90                   	nop
  802c70:	89 c8                	mov    %ecx,%eax
  802c72:	89 fa                	mov    %edi,%edx
  802c74:	83 c4 14             	add    $0x14,%esp
  802c77:	5e                   	pop    %esi
  802c78:	5f                   	pop    %edi
  802c79:	5d                   	pop    %ebp
  802c7a:	c3                   	ret    
  802c7b:	90                   	nop
  802c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c80:	8b 04 24             	mov    (%esp),%eax
  802c83:	be 20 00 00 00       	mov    $0x20,%esi
  802c88:	89 e9                	mov    %ebp,%ecx
  802c8a:	29 ee                	sub    %ebp,%esi
  802c8c:	d3 e2                	shl    %cl,%edx
  802c8e:	89 f1                	mov    %esi,%ecx
  802c90:	d3 e8                	shr    %cl,%eax
  802c92:	89 e9                	mov    %ebp,%ecx
  802c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c98:	8b 04 24             	mov    (%esp),%eax
  802c9b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c9f:	89 fa                	mov    %edi,%edx
  802ca1:	d3 e0                	shl    %cl,%eax
  802ca3:	89 f1                	mov    %esi,%ecx
  802ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ca9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802cad:	d3 ea                	shr    %cl,%edx
  802caf:	89 e9                	mov    %ebp,%ecx
  802cb1:	d3 e7                	shl    %cl,%edi
  802cb3:	89 f1                	mov    %esi,%ecx
  802cb5:	d3 e8                	shr    %cl,%eax
  802cb7:	89 e9                	mov    %ebp,%ecx
  802cb9:	09 f8                	or     %edi,%eax
  802cbb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802cbf:	f7 74 24 04          	divl   0x4(%esp)
  802cc3:	d3 e7                	shl    %cl,%edi
  802cc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802cc9:	89 d7                	mov    %edx,%edi
  802ccb:	f7 64 24 08          	mull   0x8(%esp)
  802ccf:	39 d7                	cmp    %edx,%edi
  802cd1:	89 c1                	mov    %eax,%ecx
  802cd3:	89 14 24             	mov    %edx,(%esp)
  802cd6:	72 2c                	jb     802d04 <__umoddi3+0x134>
  802cd8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802cdc:	72 22                	jb     802d00 <__umoddi3+0x130>
  802cde:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802ce2:	29 c8                	sub    %ecx,%eax
  802ce4:	19 d7                	sbb    %edx,%edi
  802ce6:	89 e9                	mov    %ebp,%ecx
  802ce8:	89 fa                	mov    %edi,%edx
  802cea:	d3 e8                	shr    %cl,%eax
  802cec:	89 f1                	mov    %esi,%ecx
  802cee:	d3 e2                	shl    %cl,%edx
  802cf0:	89 e9                	mov    %ebp,%ecx
  802cf2:	d3 ef                	shr    %cl,%edi
  802cf4:	09 d0                	or     %edx,%eax
  802cf6:	89 fa                	mov    %edi,%edx
  802cf8:	83 c4 14             	add    $0x14,%esp
  802cfb:	5e                   	pop    %esi
  802cfc:	5f                   	pop    %edi
  802cfd:	5d                   	pop    %ebp
  802cfe:	c3                   	ret    
  802cff:	90                   	nop
  802d00:	39 d7                	cmp    %edx,%edi
  802d02:	75 da                	jne    802cde <__umoddi3+0x10e>
  802d04:	8b 14 24             	mov    (%esp),%edx
  802d07:	89 c1                	mov    %eax,%ecx
  802d09:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802d0d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802d11:	eb cb                	jmp    802cde <__umoddi3+0x10e>
  802d13:	90                   	nop
  802d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d18:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802d1c:	0f 82 0f ff ff ff    	jb     802c31 <__umoddi3+0x61>
  802d22:	e9 1a ff ff ff       	jmp    802c41 <__umoddi3+0x71>
