
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
  80002c:	e8 2b 0b 00 00       	call   800b5c <libmain>
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
  8000bb:	c7 04 24 c0 2c 80 00 	movl   $0x802cc0,(%esp)
  8000c2:	e8 1f 0c 00 00       	call   800ce6 <cprintf>
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
  8000dd:	c7 44 24 08 d7 2c 80 	movl   $0x802cd7,0x8(%esp)
  8000e4:	00 
  8000e5:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  8000ec:	00 
  8000ed:	c7 04 24 e7 2c 80 00 	movl   $0x802ce7,(%esp)
  8000f4:	e8 f4 0a 00 00       	call   800bed <_panic>
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
  80011a:	c7 44 24 0c f0 2c 80 	movl   $0x802cf0,0xc(%esp)
  800121:	00 
  800122:	c7 44 24 08 fd 2c 80 	movl   $0x802cfd,0x8(%esp)
  800129:	00 
  80012a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 e7 2c 80 00 	movl   $0x802ce7,(%esp)
  800139:	e8 af 0a 00 00       	call   800bed <_panic>

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
  8001e4:	c7 44 24 0c f0 2c 80 	movl   $0x802cf0,0xc(%esp)
  8001eb:	00 
  8001ec:	c7 44 24 08 fd 2c 80 	movl   $0x802cfd,0x8(%esp)
  8001f3:	00 
  8001f4:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8001fb:	00 
  8001fc:	c7 04 24 e7 2c 80 00 	movl   $0x802ce7,(%esp)
  800203:	e8 e5 09 00 00       	call   800bed <_panic>

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
  80029e:	8b 0a                	mov    (%edx),%ecx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8002a0:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
  8002a6:	89 c3                	mov    %eax,%ebx
  8002a8:	c1 eb 0c             	shr    $0xc,%ebx
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  8002ab:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  8002b0:	76 2e                	jbe    8002e0 <bc_pgfault+0x4c>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  8002b2:	8b 42 04             	mov    0x4(%edx),%eax
  8002b5:	89 44 24 14          	mov    %eax,0x14(%esp)
  8002b9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002bd:	8b 42 28             	mov    0x28(%edx),%eax
  8002c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c4:	c7 44 24 08 14 2d 80 	movl   $0x802d14,0x8(%esp)
  8002cb:	00 
  8002cc:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  8002d3:	00 
  8002d4:	c7 04 24 8a 2d 80 00 	movl   $0x802d8a,(%esp)
  8002db:	e8 0d 09 00 00       	call   800bed <_panic>
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  8002e0:	a1 08 90 80 00       	mov    0x809008,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 25                	je     80030e <bc_pgfault+0x7a>
  8002e9:	3b 58 04             	cmp    0x4(%eax),%ebx
  8002ec:	72 20                	jb     80030e <bc_pgfault+0x7a>
		panic("reading non-existent block %08x\n", blockno);
  8002ee:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002f2:	c7 44 24 08 44 2d 80 	movl   $0x802d44,0x8(%esp)
  8002f9:	00 
  8002fa:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  800301:	00 
  800302:	c7 04 24 8a 2d 80 00 	movl   $0x802d8a,(%esp)
  800309:	e8 df 08 00 00       	call   800bed <_panic>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	//
	// LAB 5: you code here:

}
  80030e:	83 c4 24             	add    $0x24,%esp
  800311:	5b                   	pop    %ebx
  800312:	5d                   	pop    %ebp
  800313:	c3                   	ret    

00800314 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800314:	55                   	push   %ebp
  800315:	89 e5                	mov    %esp,%ebp
  800317:	83 ec 18             	sub    $0x18,%esp
  80031a:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  80031d:	85 c0                	test   %eax,%eax
  80031f:	74 0f                	je     800330 <diskaddr+0x1c>
  800321:	8b 15 08 90 80 00    	mov    0x809008,%edx
  800327:	85 d2                	test   %edx,%edx
  800329:	74 25                	je     800350 <diskaddr+0x3c>
  80032b:	3b 42 04             	cmp    0x4(%edx),%eax
  80032e:	72 20                	jb     800350 <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  800330:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800334:	c7 44 24 08 68 2d 80 	movl   $0x802d68,0x8(%esp)
  80033b:	00 
  80033c:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800343:	00 
  800344:	c7 04 24 8a 2d 80 00 	movl   $0x802d8a,(%esp)
  80034b:	e8 9d 08 00 00       	call   800bed <_panic>
	return (char*) (DISKMAP + blockno * BLKSIZE);
  800350:	05 00 00 01 00       	add    $0x10000,%eax
  800355:	c1 e0 0c             	shl    $0xc,%eax
}
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <bc_init>:
}


void
bc_init(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  800363:	c7 04 24 94 02 80 00 	movl   $0x800294,(%esp)
  80036a:	e8 e2 16 00 00       	call   801a51 <set_pgfault_handler>

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  80036f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800376:	e8 99 ff ff ff       	call   800314 <diskaddr>
  80037b:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800382:	00 
  800383:	89 44 24 04          	mov    %eax,0x4(%esp)
  800387:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80038d:	89 04 24             	mov    %eax,(%esp)
  800390:	e8 a1 11 00 00       	call   801536 <memmove>
}
  800395:	c9                   	leave  
  800396:	c3                   	ret    
  800397:	66 90                	xchg   %ax,%ax
  800399:	66 90                	xchg   %ax,%ax
  80039b:	66 90                	xchg   %ax,%ax
  80039d:	66 90                	xchg   %ax,%ax
  80039f:	90                   	nop

008003a0 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  8003a6:	a1 08 90 80 00       	mov    0x809008,%eax
  8003ab:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8003b1:	74 1c                	je     8003cf <check_super+0x2f>
		panic("bad file system magic number");
  8003b3:	c7 44 24 08 92 2d 80 	movl   $0x802d92,0x8(%esp)
  8003ba:	00 
  8003bb:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8003ca:	e8 1e 08 00 00       	call   800bed <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8003cf:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8003d6:	76 1c                	jbe    8003f4 <check_super+0x54>
		panic("file system is too large");
  8003d8:	c7 44 24 08 b7 2d 80 	movl   $0x802db7,0x8(%esp)
  8003df:	00 
  8003e0:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  8003e7:	00 
  8003e8:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  8003ef:	e8 f9 07 00 00       	call   800bed <_panic>

	cprintf("superblock is good\n");
  8003f4:	c7 04 24 d0 2d 80 00 	movl   $0x802dd0,(%esp)
  8003fb:	e8 e6 08 00 00       	call   800ce6 <cprintf>
}
  800400:	c9                   	leave  
  800401:	c3                   	ret    

00800402 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  800408:	e8 52 fc ff ff       	call   80005f <ide_probe_disk1>
  80040d:	84 c0                	test   %al,%al
  80040f:	74 0e                	je     80041f <fs_init+0x1d>
		ide_set_disk(1);
  800411:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800418:	e8 b2 fc ff ff       	call   8000cf <ide_set_disk>
  80041d:	eb 0c                	jmp    80042b <fs_init+0x29>
	else
		ide_set_disk(0);
  80041f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800426:	e8 a4 fc ff ff       	call   8000cf <ide_set_disk>

	bc_init();
  80042b:	e8 2a ff ff ff       	call   80035a <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  800430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800437:	e8 d8 fe ff ff       	call   800314 <diskaddr>
  80043c:	a3 08 90 80 00       	mov    %eax,0x809008
	check_super();
  800441:	e8 5a ff ff ff       	call   8003a0 <check_super>
}
  800446:	c9                   	leave  
  800447:	c3                   	ret    

00800448 <file_get_block>:
//	-E_NO_DISK if a block needed to be allocated but the disk is full.
//	-E_INVAL if filebno is out of range.
//
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	53                   	push   %ebx
  80044c:	83 ec 14             	sub    $0x14,%esp
  80044f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
	int r;
	uint32_t *ptr;
	char *blk;

	if (filebno < NDIRECT)
  800452:	83 fb 09             	cmp    $0x9,%ebx
  800455:	77 0c                	ja     800463 <file_get_block+0x1b>
		ptr = &f->f_direct[filebno];
  800457:	8b 45 08             	mov    0x8(%ebp),%eax
  80045a:	8d 84 98 88 00 00 00 	lea    0x88(%eax,%ebx,4),%eax
  800461:	eb 21                	jmp    800484 <file_get_block+0x3c>
	else if (filebno < NDIRECT + NINDIRECT) {
  800463:	81 fb 09 04 00 00    	cmp    $0x409,%ebx
  800469:	77 3a                	ja     8004a5 <file_get_block+0x5d>
		if (f->f_indirect == 0) {
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	74 34                	je     8004ac <file_get_block+0x64>
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
  800478:	89 04 24             	mov    %eax,(%esp)
  80047b:	e8 94 fe ff ff       	call   800314 <diskaddr>
  800480:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
  800484:	8b 00                	mov    (%eax),%eax
  800486:	85 c0                	test   %eax,%eax
  800488:	74 14                	je     80049e <file_get_block+0x56>
		return -E_NOT_FOUND;
	}
	*blk = diskaddr(*ptr);
  80048a:	89 04 24             	mov    %eax,(%esp)
  80048d:	e8 82 fe ff ff       	call   800314 <diskaddr>
  800492:	8b 55 10             	mov    0x10(%ebp),%edx
  800495:	89 02                	mov    %eax,(%edx)
	return 0;
  800497:	b8 00 00 00 00       	mov    $0x0,%eax
  80049c:	eb 13                	jmp    8004b1 <file_get_block+0x69>
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 1)) < 0)
		return r;
	if (*ptr == 0) {
		return -E_NOT_FOUND;
  80049e:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8004a3:	eb 0c                	jmp    8004b1 <file_get_block+0x69>
		if (f->f_indirect == 0) {
			return -E_NOT_FOUND;
		}
		ptr = (uint32_t*)diskaddr(f->f_indirect) + filebno - NDIRECT;
	} else
		return -E_INVAL;
  8004a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004aa:	eb 05                	jmp    8004b1 <file_get_block+0x69>

	if (filebno < NDIRECT)
		ptr = &f->f_direct[filebno];
	else if (filebno < NDIRECT + NINDIRECT) {
		if (f->f_indirect == 0) {
			return -E_NOT_FOUND;
  8004ac:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
	if (*ptr == 0) {
		return -E_NOT_FOUND;
	}
	*blk = diskaddr(*ptr);
	return 0;
}
  8004b1:	83 c4 14             	add    $0x14,%esp
  8004b4:	5b                   	pop    %ebx
  8004b5:	5d                   	pop    %ebp
  8004b6:	c3                   	ret    

008004b7 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	57                   	push   %edi
  8004bb:	56                   	push   %esi
  8004bc:	53                   	push   %ebx
  8004bd:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  8004c3:	8b 55 08             	mov    0x8(%ebp),%edx

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8004c6:	80 3a 2f             	cmpb   $0x2f,(%edx)
  8004c9:	75 08                	jne    8004d3 <file_open+0x1c>
		p++;
  8004cb:	83 c2 01             	add    $0x1,%edx

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8004ce:	80 3a 2f             	cmpb   $0x2f,(%edx)
  8004d1:	74 f8                	je     8004cb <file_open+0x14>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  8004d3:	a1 08 90 80 00       	mov    0x809008,%eax
  8004d8:	83 c0 08             	add    $0x8,%eax
  8004db:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
	dir = 0;
	name[0] = 0;
  8004e1:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
		*pdir = 0;
	*pf = 0;
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8004f1:	e9 45 01 00 00       	jmp    80063b <file_open+0x184>
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  8004f6:	83 c7 01             	add    $0x1,%edi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  8004f9:	0f b6 07             	movzbl (%edi),%eax
  8004fc:	84 c0                	test   %al,%al
  8004fe:	74 08                	je     800508 <file_open+0x51>
  800500:	3c 2f                	cmp    $0x2f,%al
  800502:	75 f2                	jne    8004f6 <file_open+0x3f>
  800504:	eb 02                	jmp    800508 <file_open+0x51>
  800506:	89 d7                	mov    %edx,%edi
			path++;
		if (path - p >= MAXNAMELEN)
  800508:	89 fb                	mov    %edi,%ebx
  80050a:	29 d3                	sub    %edx,%ebx
  80050c:	83 fb 7f             	cmp    $0x7f,%ebx
  80050f:	0f 8f 4e 01 00 00    	jg     800663 <file_open+0x1ac>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800515:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800519:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	e8 0b 10 00 00       	call   801536 <memmove>
		name[path - p] = '\0';
  80052b:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800532:	00 

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800533:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800536:	75 08                	jne    800540 <file_open+0x89>
		p++;
  800538:	83 c7 01             	add    $0x1,%edi

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  80053b:	80 3f 2f             	cmpb   $0x2f,(%edi)
  80053e:	74 f8                	je     800538 <file_open+0x81>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
  800540:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800546:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80054d:	0f 85 17 01 00 00    	jne    80066a <file_open+0x1b3>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800553:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800559:	a9 ff 0f 00 00       	test   $0xfff,%eax
  80055e:	74 24                	je     800584 <file_open+0xcd>
  800560:	c7 44 24 0c e4 2d 80 	movl   $0x802de4,0xc(%esp)
  800567:	00 
  800568:	c7 44 24 08 fd 2c 80 	movl   $0x802cfd,0x8(%esp)
  80056f:	00 
  800570:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
  800577:	00 
  800578:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  80057f:	e8 69 06 00 00       	call   800bed <_panic>
	nblock = dir->f_size / BLKSIZE;
  800584:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80058a:	85 c0                	test   %eax,%eax
  80058c:	0f 48 c2             	cmovs  %edx,%eax
  80058f:	c1 f8 0c             	sar    $0xc,%eax
  800592:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	for (i = 0; i < nblock; i++) {
  800598:	85 c0                	test   %eax,%eax
  80059a:	0f 84 81 00 00 00    	je     800621 <file_open+0x16a>
  8005a0:	c7 85 54 ff ff ff 00 	movl   $0x0,-0xac(%ebp)
  8005a7:	00 00 00 
  8005aa:	89 bd 48 ff ff ff    	mov    %edi,-0xb8(%ebp)
		if ((r = file_get_block(dir, i, &blk)) < 0)
  8005b0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  8005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005ba:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8005c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c4:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  8005ca:	89 04 24             	mov    %eax,(%esp)
  8005cd:	e8 76 fe ff ff       	call   800448 <file_get_block>
  8005d2:	85 c0                	test   %eax,%eax
  8005d4:	0f 88 a7 00 00 00    	js     800681 <file_open+0x1ca>
  8005da:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
			return r;
		f = (struct File*) blk;
  8005e0:	be 10 00 00 00       	mov    $0x10,%esi
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  8005e5:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8005eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ef:	89 1c 24             	mov    %ebx,(%esp)
  8005f2:	e8 0e 0e 00 00       	call   801405 <strcmp>
  8005f7:	85 c0                	test   %eax,%eax
  8005f9:	74 76                	je     800671 <file_open+0x1ba>
  8005fb:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800601:	83 ee 01             	sub    $0x1,%esi
  800604:	75 df                	jne    8005e5 <file_open+0x12e>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800606:	83 85 54 ff ff ff 01 	addl   $0x1,-0xac(%ebp)
  80060d:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800613:	39 85 4c ff ff ff    	cmp    %eax,-0xb4(%ebp)
  800619:	75 95                	jne    8005b0 <file_open+0xf9>
  80061b:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
			}
			return r;
  800621:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800626:	80 3f 00             	cmpb   $0x0,(%edi)
  800629:	75 61                	jne    80068c <file_open+0x1d5>
				if (pdir)
					*pdir = dir;
				if (lastelem)
					strcpy(lastelem, name);
				*pf = 0;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  800634:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800639:	eb 51                	jmp    80068c <file_open+0x1d5>
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  80063b:	0f b6 02             	movzbl (%edx),%eax
  80063e:	84 c0                	test   %al,%al
  800640:	74 0f                	je     800651 <file_open+0x19a>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800642:	3c 2f                	cmp    $0x2f,%al
  800644:	0f 84 bc fe ff ff    	je     800506 <file_open+0x4f>
  80064a:	89 d7                	mov    %edx,%edi
  80064c:	e9 a5 fe ff ff       	jmp    8004f6 <file_open+0x3f>
		}
	}

	if (pdir)
		*pdir = dir;
	*pf = f;
  800651:	8b 45 0c             	mov    0xc(%ebp),%eax
  800654:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  80065a:	89 08                	mov    %ecx,(%eax)
	return 0;
  80065c:	b8 00 00 00 00       	mov    $0x0,%eax
  800661:	eb 29                	jmp    80068c <file_open+0x1d5>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
		if (path - p >= MAXNAMELEN)
			return -E_BAD_PATH;
  800663:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800668:	eb 22                	jmp    80068c <file_open+0x1d5>
		memmove(name, p, path - p);
		name[path - p] = '\0';
		path = skip_slash(path);

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;
  80066a:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  80066f:	eb 1b                	jmp    80068c <file_open+0x1d5>
  800671:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800677:	89 9d 50 ff ff ff    	mov    %ebx,-0xb0(%ebp)
  80067d:	89 fa                	mov    %edi,%edx
  80067f:	eb ba                	jmp    80063b <file_open+0x184>
  800681:	8b bd 48 ff ff ff    	mov    -0xb8(%ebp),%edi

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800687:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80068a:	74 95                	je     800621 <file_open+0x16a>
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
	return walk_path(path, 0, pf, 0);
}
  80068c:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  800692:	5b                   	pop    %ebx
  800693:	5e                   	pop    %esi
  800694:	5f                   	pop    %edi
  800695:	5d                   	pop    %ebp
  800696:	c3                   	ret    

00800697 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800697:	55                   	push   %ebp
  800698:	89 e5                	mov    %esp,%ebp
  80069a:	57                   	push   %edi
  80069b:	56                   	push   %esi
  80069c:	53                   	push   %ebx
  80069d:	83 ec 3c             	sub    $0x3c,%esp
  8006a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006a3:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8006a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a9:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
		return 0;
  8006af:	b8 00 00 00 00       	mov    $0x0,%eax
{
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  8006b4:	39 da                	cmp    %ebx,%edx
  8006b6:	0f 8e 86 00 00 00    	jle    800742 <file_read+0xab>
		return 0;

	count = MIN(count, f->f_size - offset);
  8006bc:	29 da                	sub    %ebx,%edx
  8006be:	3b 55 10             	cmp    0x10(%ebp),%edx
  8006c1:	0f 47 55 10          	cmova  0x10(%ebp),%edx
  8006c5:	89 55 d0             	mov    %edx,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  8006c8:	89 de                	mov    %ebx,%esi
  8006ca:	8d 04 1a             	lea    (%edx,%ebx,1),%eax
  8006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8006d0:	39 c3                	cmp    %eax,%ebx
  8006d2:	73 6b                	jae    80073f <file_read+0xa8>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  8006d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006db:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	0f 49 c3             	cmovns %ebx,%eax
  8006e6:	c1 f8 0c             	sar    $0xc,%eax
  8006e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 04 24             	mov    %eax,(%esp)
  8006f3:	e8 50 fd ff ff       	call   800448 <file_get_block>
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	78 46                	js     800742 <file_read+0xab>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  8006fc:	89 da                	mov    %ebx,%edx
  8006fe:	c1 fa 1f             	sar    $0x1f,%edx
  800701:	c1 ea 14             	shr    $0x14,%edx
  800704:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800707:	25 ff 0f 00 00       	and    $0xfff,%eax
  80070c:	29 d0                	sub    %edx,%eax
  80070e:	b9 00 10 00 00       	mov    $0x1000,%ecx
  800713:	29 c1                	sub    %eax,%ecx
  800715:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800718:	29 f2                	sub    %esi,%edx
  80071a:	39 d1                	cmp    %edx,%ecx
  80071c:	89 d6                	mov    %edx,%esi
  80071e:	0f 46 f1             	cmovbe %ecx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800721:	89 74 24 08          	mov    %esi,0x8(%esp)
  800725:	03 45 e4             	add    -0x1c(%ebp),%eax
  800728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072c:	89 3c 24             	mov    %edi,(%esp)
  80072f:	e8 02 0e 00 00       	call   801536 <memmove>
		pos += bn;
  800734:	01 f3                	add    %esi,%ebx
		buf += bn;
  800736:	01 f7                	add    %esi,%edi
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800738:	89 de                	mov    %ebx,%esi
  80073a:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
  80073d:	72 95                	jb     8006d4 <file_read+0x3d>
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
	}

	return count;
  80073f:	8b 45 d0             	mov    -0x30(%ebp),%eax
}
  800742:	83 c4 3c             	add    $0x3c,%esp
  800745:	5b                   	pop    %ebx
  800746:	5e                   	pop    %esi
  800747:	5f                   	pop    %edi
  800748:	5d                   	pop    %ebp
  800749:	c3                   	ret    
  80074a:	66 90                	xchg   %ax,%ax
  80074c:	66 90                	xchg   %ax,%ax
  80074e:	66 90                	xchg   %ax,%ax

00800750 <serve_flush>:


// Our read-only file system do nothing for flush
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
	return 0;
}
  800753:	b8 00 00 00 00       	mov    $0x0,%eax
  800758:	5d                   	pop    %ebp
  800759:	c3                   	ret    

0080075a <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	ba 40 40 80 00       	mov    $0x804040,%edx
	int i;
	uintptr_t va = FILEVA;
  800762:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800767:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  80076c:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  80076e:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  800771:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  800777:	83 c0 01             	add    $0x1,%eax
  80077a:	83 c2 10             	add    $0x10,%edx
  80077d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800782:	75 e8                	jne    80076c <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <openfile_alloc>:

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	56                   	push   %esi
  80078a:	53                   	push   %ebx
  80078b:	83 ec 10             	sub    $0x10,%esp
  80078e:	8b 75 08             	mov    0x8(%ebp),%esi
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800791:	bb 00 00 00 00       	mov    $0x0,%ebx
  800796:	89 d8                	mov    %ebx,%eax
  800798:	c1 e0 04             	shl    $0x4,%eax
		switch (pageref(opentab[i].o_fd)) {
  80079b:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  8007a1:	89 04 24             	mov    %eax,(%esp)
  8007a4:	e8 c1 1c 00 00       	call   80246a <pageref>
  8007a9:	85 c0                	test   %eax,%eax
  8007ab:	74 07                	je     8007b4 <openfile_alloc+0x2e>
  8007ad:	83 f8 01             	cmp    $0x1,%eax
  8007b0:	74 2b                	je     8007dd <openfile_alloc+0x57>
  8007b2:	eb 62                	jmp    800816 <openfile_alloc+0x90>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  8007b4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8007bb:	00 
  8007bc:	89 d8                	mov    %ebx,%eax
  8007be:	c1 e0 04             	shl    $0x4,%eax
  8007c1:	8b 80 4c 40 80 00    	mov    0x80404c(%eax),%eax
  8007c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007d2:	e8 12 10 00 00       	call   8017e9 <sys_page_alloc>
  8007d7:	89 c2                	mov    %eax,%edx
  8007d9:	85 d2                	test   %edx,%edx
  8007db:	78 4d                	js     80082a <openfile_alloc+0xa4>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  8007dd:	c1 e3 04             	shl    $0x4,%ebx
  8007e0:	8d 83 40 40 80 00    	lea    0x804040(%ebx),%eax
  8007e6:	81 83 40 40 80 00 00 	addl   $0x400,0x804040(%ebx)
  8007ed:	04 00 00 
			*o = &opentab[i];
  8007f0:	89 06                	mov    %eax,(%esi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8007f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8007f9:	00 
  8007fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800801:	00 
  800802:	8b 83 4c 40 80 00    	mov    0x80404c(%ebx),%eax
  800808:	89 04 24             	mov    %eax,(%esp)
  80080b:	e8 d9 0c 00 00       	call   8014e9 <memset>
			return (*o)->o_fileid;
  800810:	8b 06                	mov    (%esi),%eax
  800812:	8b 00                	mov    (%eax),%eax
  800814:	eb 14                	jmp    80082a <openfile_alloc+0xa4>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  800816:	83 c3 01             	add    $0x1,%ebx
  800819:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80081f:	0f 85 71 ff ff ff    	jne    800796 <openfile_alloc+0x10>
			*o = &opentab[i];
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
  800825:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  80082a:	83 c4 10             	add    $0x10,%esp
  80082d:	5b                   	pop    %ebx
  80082e:	5e                   	pop    %esi
  80082f:	5d                   	pop    %ebp
  800830:	c3                   	ret    

00800831 <openfile_lookup>:

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	57                   	push   %edi
  800835:	56                   	push   %esi
  800836:	53                   	push   %ebx
  800837:	83 ec 1c             	sub    $0x1c,%esp
  80083a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  80083d:	89 de                	mov    %ebx,%esi
  80083f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800845:	c1 e6 04             	shl    $0x4,%esi
  800848:	8d be 40 40 80 00    	lea    0x804040(%esi),%edi
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80084e:	8b 86 4c 40 80 00    	mov    0x80404c(%esi),%eax
  800854:	89 04 24             	mov    %eax,(%esp)
  800857:	e8 0e 1c 00 00       	call   80246a <pageref>
  80085c:	83 f8 01             	cmp    $0x1,%eax
  80085f:	74 14                	je     800875 <openfile_lookup+0x44>
  800861:	39 9e 40 40 80 00    	cmp    %ebx,0x804040(%esi)
  800867:	75 13                	jne    80087c <openfile_lookup+0x4b>
		return -E_INVAL;
	*po = o;
  800869:	8b 45 10             	mov    0x10(%ebp),%eax
  80086c:	89 38                	mov    %edi,(%eax)
	return 0;
  80086e:	b8 00 00 00 00       	mov    $0x0,%eax
  800873:	eb 0c                	jmp    800881 <openfile_lookup+0x50>
{
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
		return -E_INVAL;
  800875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087a:	eb 05                	jmp    800881 <openfile_lookup+0x50>
  80087c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	*po = o;
	return 0;
}
  800881:	83 c4 1c             	add    $0x1c,%esp
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5f                   	pop    %edi
  800887:	5d                   	pop    %ebp
  800888:	c3                   	ret    

00800889 <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  800889:	55                   	push   %ebp
  80088a:	89 e5                	mov    %esp,%ebp
  80088c:	53                   	push   %ebx
  80088d:	83 ec 24             	sub    $0x24,%esp
  800890:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// so filling in ret will overwrite req.
	//
	struct OpenFile *o;
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  800893:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800896:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089a:	8b 03                	mov    (%ebx),%eax
  80089c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	89 04 24             	mov    %eax,(%esp)
  8008a6:	e8 86 ff ff ff       	call   800831 <openfile_lookup>
  8008ab:	89 c2                	mov    %eax,%edx
  8008ad:	85 d2                	test   %edx,%edx
  8008af:	78 3d                	js     8008ee <serve_read+0x65>
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
  8008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8008b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8008b7:	8b 52 04             	mov    0x4(%edx),%edx
  8008ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
			   MIN(req->req_n, sizeof ret->ret_buf),
  8008be:	81 7b 04 00 10 00 00 	cmpl   $0x1000,0x4(%ebx)
  8008c5:	ba 00 10 00 00       	mov    $0x1000,%edx
  8008ca:	0f 46 53 04          	cmovbe 0x4(%ebx),%edx
	int r;

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
		return r;

	if ((r = file_read(o->o_file, ret->ret_buf,
  8008ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8008d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008d6:	8b 40 04             	mov    0x4(%eax),%eax
  8008d9:	89 04 24             	mov    %eax,(%esp)
  8008dc:	e8 b6 fd ff ff       	call   800697 <file_read>
  8008e1:	85 c0                	test   %eax,%eax
  8008e3:	78 09                	js     8008ee <serve_read+0x65>
			   MIN(req->req_n, sizeof ret->ret_buf),
			   o->o_fd->fd_offset)) < 0)
		return r;

	o->o_fd->fd_offset += r;
  8008e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e8:	8b 52 0c             	mov    0xc(%edx),%edx
  8008eb:	01 42 04             	add    %eax,0x4(%edx)
	return r;
}
  8008ee:	83 c4 24             	add    $0x24,%esp
  8008f1:	5b                   	pop    %ebx
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	53                   	push   %ebx
  8008f8:	83 ec 24             	sub    $0x24,%esp
  8008fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8008fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800901:	89 44 24 08          	mov    %eax,0x8(%esp)
  800905:	8b 03                	mov    (%ebx),%eax
  800907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 04 24             	mov    %eax,(%esp)
  800911:	e8 1b ff ff ff       	call   800831 <openfile_lookup>
  800916:	89 c2                	mov    %eax,%edx
  800918:	85 d2                	test   %edx,%edx
  80091a:	78 3f                	js     80095b <serve_stat+0x67>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  80091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091f:	8b 40 04             	mov    0x4(%eax),%eax
  800922:	89 44 24 04          	mov    %eax,0x4(%esp)
  800926:	89 1c 24             	mov    %ebx,(%esp)
  800929:	e8 0d 0a 00 00       	call   80133b <strcpy>
	ret->ret_size = o->o_file->f_size;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	8b 50 04             	mov    0x4(%eax),%edx
  800934:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  80093a:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  800940:	8b 40 04             	mov    0x4(%eax),%eax
  800943:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  80094a:	0f 94 c0             	sete   %al
  80094d:	0f b6 c0             	movzbl %al,%eax
  800950:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800956:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095b:	83 c4 24             	add    $0x24,%esp
  80095e:	5b                   	pop    %ebx
  80095f:	5d                   	pop    %ebp
  800960:	c3                   	ret    

00800961 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	56                   	push   %esi
  800965:	53                   	push   %ebx
  800966:	81 ec 20 04 00 00    	sub    $0x420,%esp
  80096c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  80096f:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  800976:	00 
  800977:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80097b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  800981:	89 04 24             	mov    %eax,(%esp)
  800984:	e8 ad 0b 00 00       	call   801536 <memmove>
	path[MAXPATHLEN-1] = 0;
  800989:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80098d:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  800993:	89 04 24             	mov    %eax,(%esp)
  800996:	e8 eb fd ff ff       	call   800786 <openfile_alloc>
  80099b:	85 c0                	test   %eax,%eax
  80099d:	78 79                	js     800a18 <serve_open+0xb7>
			cprintf("openfile_alloc failed: %e", r);
		return r;
	}
	fileid = r;

	if (req->req_omode != 0) {
  80099f:	8b b3 00 04 00 00    	mov    0x400(%ebx),%esi
  8009a5:	85 f6                	test   %esi,%esi
  8009a7:	75 73                	jne    800a1c <serve_open+0xbb>
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
	}

	if ((r = file_open(path, &f)) < 0) {
  8009a9:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8009af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b3:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8009b9:	89 04 24             	mov    %eax,(%esp)
  8009bc:	e8 f6 fa ff ff       	call   8004b7 <file_open>
  8009c1:	85 c0                	test   %eax,%eax
  8009c3:	78 5e                	js     800a23 <serve_open+0xc2>
			cprintf("file_open failed: %e", r);
		return r;
	}

	// Save the file pointer
	o->o_file = f;
  8009c5:	8b 95 f0 fb ff ff    	mov    -0x410(%ebp),%edx
  8009cb:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8009d1:	89 42 04             	mov    %eax,0x4(%edx)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8009d4:	8b 42 0c             	mov    0xc(%edx),%eax
  8009d7:	8b 0a                	mov    (%edx),%ecx
  8009d9:	89 48 0c             	mov    %ecx,0xc(%eax)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8009dc:	8b 42 0c             	mov    0xc(%edx),%eax
  8009df:	8b 8b 00 04 00 00    	mov    0x400(%ebx),%ecx
  8009e5:	83 e1 03             	and    $0x3,%ecx
  8009e8:	89 48 08             	mov    %ecx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  8009eb:	8b 42 0c             	mov    0xc(%edx),%eax
  8009ee:	8b 15 44 80 80 00    	mov    0x808044,%edx
  8009f4:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  8009f6:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8009fc:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  800a02:	89 50 08             	mov    %edx,0x8(%eax)
	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller by setting *pg_store,
	// store its permission in *perm_store
	*pg_store = o->o_fd;
  800a05:	8b 50 0c             	mov    0xc(%eax),%edx
  800a08:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0b:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	c7 00 07 04 00 00    	movl   $0x407,(%eax)

	return 0;
  800a16:	eb 0d                	jmp    800a25 <serve_open+0xc4>

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
		if (debug)
			cprintf("openfile_alloc failed: %e", r);
		return r;
  800a18:	89 c6                	mov    %eax,%esi
  800a1a:	eb 09                	jmp    800a25 <serve_open+0xc4>
	fileid = r;

	if (req->req_omode != 0) {
		if (debug)
			cprintf("file_open omode 0x%x unsupported", req->req_omode);
		return -E_INVAL;
  800a1c:	be fd ff ff ff       	mov    $0xfffffffd,%esi
  800a21:	eb 02                	jmp    800a25 <serve_open+0xc4>
	}

	if ((r = file_open(path, &f)) < 0) {
		if (debug)
			cprintf("file_open failed: %e", r);
		return r;
  800a23:	89 c6                	mov    %eax,%esi
	// store its permission in *perm_store
	*pg_store = o->o_fd;
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;

	return 0;
}
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	81 c4 20 04 00 00    	add    $0x420,%esp
  800a2d:	5b                   	pop    %ebx
  800a2e:	5e                   	pop    %esi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	56                   	push   %esi
  800a35:	53                   	push   %ebx
  800a36:	83 ec 20             	sub    $0x20,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800a39:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  800a3c:	8d 75 f4             	lea    -0xc(%ebp),%esi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  800a3f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  800a46:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a4a:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a53:	89 34 24             	mov    %esi,(%esp)
  800a56:	e8 b0 10 00 00       	call   801b0b <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  800a5b:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  800a5f:	75 15                	jne    800a76 <serve+0x45>
			cprintf("Invalid request from %08x: no argument page\n",
  800a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a68:	c7 04 24 04 2e 80 00 	movl   $0x802e04,(%esp)
  800a6f:	e8 72 02 00 00       	call   800ce6 <cprintf>
				whom);
			continue; // just leave it hanging...
  800a74:	eb c9                	jmp    800a3f <serve+0xe>
		}

		pg = NULL;
  800a76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  800a7d:	83 f8 01             	cmp    $0x1,%eax
  800a80:	75 21                	jne    800aa3 <serve+0x72>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  800a82:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800a86:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a89:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a8d:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a99:	89 04 24             	mov    %eax,(%esp)
  800a9c:	e8 c0 fe ff ff       	call   800961 <serve_open>
  800aa1:	eb 3f                	jmp    800ae2 <serve+0xb1>
		} else if (req < NHANDLERS && handlers[req]) {
  800aa3:	83 f8 06             	cmp    $0x6,%eax
  800aa6:	77 1e                	ja     800ac6 <serve+0x95>
  800aa8:	8b 14 85 20 40 80 00 	mov    0x804020(,%eax,4),%edx
  800aaf:	85 d2                	test   %edx,%edx
  800ab1:	74 13                	je     800ac6 <serve+0x95>
			r = handlers[req](whom, fsreq);
  800ab3:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800abf:	89 04 24             	mov    %eax,(%esp)
  800ac2:	ff d2                	call   *%edx
  800ac4:	eb 1c                	jmp    800ae2 <serve+0xb1>
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  800ac6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac9:	89 54 24 08          	mov    %edx,0x8(%esp)
  800acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad1:	c7 04 24 34 2e 80 00 	movl   $0x802e34,(%esp)
  800ad8:	e8 09 02 00 00       	call   800ce6 <cprintf>
			r = -E_INVAL;
  800add:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  800ae2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ae5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ae9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800aec:	89 54 24 08          	mov    %edx,0x8(%esp)
  800af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800af7:	89 04 24             	mov    %eax,(%esp)
  800afa:	e8 76 10 00 00       	call   801b75 <ipc_send>
		sys_page_unmap(0, fsreq);
  800aff:	a1 3c 40 80 00       	mov    0x80403c,%eax
  800b04:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b0f:	e8 7c 0d 00 00       	call   801890 <sys_page_unmap>
  800b14:	e9 26 ff ff ff       	jmp    800a3f <serve+0xe>

00800b19 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  800b19:	55                   	push   %ebp
  800b1a:	89 e5                	mov    %esp,%ebp
  800b1c:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  800b1f:	c7 05 40 80 80 00 57 	movl   $0x802e57,0x808040
  800b26:	2e 80 00 
	cprintf("FS is running\n");
  800b29:	c7 04 24 5a 2e 80 00 	movl   $0x802e5a,(%esp)
  800b30:	e8 b1 01 00 00       	call   800ce6 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  800b35:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  800b3a:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  800b3f:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  800b41:	c7 04 24 69 2e 80 00 	movl   $0x802e69,(%esp)
  800b48:	e8 99 01 00 00       	call   800ce6 <cprintf>

	serve_init();
  800b4d:	e8 08 fc ff ff       	call   80075a <serve_init>
	fs_init();
  800b52:	e8 ab f8 ff ff       	call   800402 <fs_init>
	serve();
  800b57:	e8 d5 fe ff ff       	call   800a31 <serve>

00800b5c <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	83 ec 10             	sub    $0x10,%esp
  800b64:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b67:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800b6a:	e8 3c 0c 00 00       	call   8017ab <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800b6f:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	74 17                	je     800b90 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800b79:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800b7e:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800b81:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800b87:	8b 49 40             	mov    0x40(%ecx),%ecx
  800b8a:	39 c1                	cmp    %eax,%ecx
  800b8c:	75 18                	jne    800ba6 <libmain+0x4a>
  800b8e:	eb 05                	jmp    800b95 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800b90:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800b95:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800b98:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800b9e:	89 15 0c 90 80 00    	mov    %edx,0x80900c
			break;
  800ba4:	eb 0b                	jmp    800bb1 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800ba6:	83 c2 01             	add    $0x1,%edx
  800ba9:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800baf:	75 cd                	jne    800b7e <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800bb1:	85 db                	test   %ebx,%ebx
  800bb3:	7e 07                	jle    800bbc <libmain+0x60>
		binaryname = argv[0];
  800bb5:	8b 06                	mov    (%esi),%eax
  800bb7:	a3 40 80 80 00       	mov    %eax,0x808040

	// call user main routine
	umain(argc, argv);
  800bbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bc0:	89 1c 24             	mov    %ebx,(%esp)
  800bc3:	e8 51 ff ff ff       	call   800b19 <umain>

	// exit gracefully
	exit();
  800bc8:	e8 07 00 00 00       	call   800bd4 <exit>
}
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	5b                   	pop    %ebx
  800bd1:	5e                   	pop    %esi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800bda:	e8 67 12 00 00       	call   801e46 <close_all>
	sys_env_destroy(0);
  800bdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800be6:	e8 6e 0b 00 00       	call   801759 <sys_env_destroy>
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800bf5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800bf8:	8b 35 40 80 80 00    	mov    0x808040,%esi
  800bfe:	e8 a8 0b 00 00       	call   8017ab <sys_getenvid>
  800c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c06:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c11:	89 74 24 08          	mov    %esi,0x8(%esp)
  800c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c19:	c7 04 24 84 2e 80 00 	movl   $0x802e84,(%esp)
  800c20:	e8 c1 00 00 00       	call   800ce6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  800c25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c29:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2c:	89 04 24             	mov    %eax,(%esp)
  800c2f:	e8 51 00 00 00       	call   800c85 <vcprintf>
	cprintf("\n");
  800c34:	c7 04 24 76 2e 80 00 	movl   $0x802e76,(%esp)
  800c3b:	e8 a6 00 00 00       	call   800ce6 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800c40:	cc                   	int3   
  800c41:	eb fd                	jmp    800c40 <_panic+0x53>

00800c43 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	53                   	push   %ebx
  800c47:	83 ec 14             	sub    $0x14,%esp
  800c4a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800c4d:	8b 13                	mov    (%ebx),%edx
  800c4f:	8d 42 01             	lea    0x1(%edx),%eax
  800c52:	89 03                	mov    %eax,(%ebx)
  800c54:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c57:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800c5b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c60:	75 19                	jne    800c7b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800c62:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800c69:	00 
  800c6a:	8d 43 08             	lea    0x8(%ebx),%eax
  800c6d:	89 04 24             	mov    %eax,(%esp)
  800c70:	e8 a7 0a 00 00       	call   80171c <sys_cputs>
		b->idx = 0;
  800c75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800c7b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800c7f:	83 c4 14             	add    $0x14,%esp
  800c82:	5b                   	pop    %ebx
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800c8e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c95:	00 00 00 
	b.cnt = 0;
  800c98:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c9f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cac:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cba:	c7 04 24 43 0c 80 00 	movl   $0x800c43,(%esp)
  800cc1:	e8 ae 01 00 00       	call   800e74 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800cc6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd0:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800cd6:	89 04 24             	mov    %eax,(%esp)
  800cd9:	e8 3e 0a 00 00       	call   80171c <sys_cputs>

	return b.cnt;
}
  800cde:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800ce4:	c9                   	leave  
  800ce5:	c3                   	ret    

00800ce6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800cec:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800cef:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	89 04 24             	mov    %eax,(%esp)
  800cf9:	e8 87 ff ff ff       	call   800c85 <vcprintf>
	va_end(ap);

	return cnt;
}
  800cfe:	c9                   	leave  
  800cff:	c3                   	ret    

00800d00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d00:	55                   	push   %ebp
  800d01:	89 e5                	mov    %esp,%ebp
  800d03:	57                   	push   %edi
  800d04:	56                   	push   %esi
  800d05:	53                   	push   %ebx
  800d06:	83 ec 3c             	sub    $0x3c,%esp
  800d09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d0c:	89 d7                	mov    %edx,%edi
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d14:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d17:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  800d1a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800d25:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800d28:	39 f1                	cmp    %esi,%ecx
  800d2a:	72 14                	jb     800d40 <printnum+0x40>
  800d2c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800d2f:	76 0f                	jbe    800d40 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d31:	8b 45 14             	mov    0x14(%ebp),%eax
  800d34:	8d 70 ff             	lea    -0x1(%eax),%esi
  800d37:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800d3a:	85 f6                	test   %esi,%esi
  800d3c:	7f 60                	jg     800d9e <printnum+0x9e>
  800d3e:	eb 72                	jmp    800db2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d40:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d43:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800d47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  800d4a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  800d4d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800d51:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d55:	8b 44 24 08          	mov    0x8(%esp),%eax
  800d59:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800d5d:	89 c3                	mov    %eax,%ebx
  800d5f:	89 d6                	mov    %edx,%esi
  800d61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800d64:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800d67:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d6b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800d6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d72:	89 04 24             	mov    %eax,(%esp)
  800d75:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d7c:	e8 9f 1c 00 00       	call   802a20 <__udivdi3>
  800d81:	89 d9                	mov    %ebx,%ecx
  800d83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d87:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800d8b:	89 04 24             	mov    %eax,(%esp)
  800d8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  800d92:	89 fa                	mov    %edi,%edx
  800d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d97:	e8 64 ff ff ff       	call   800d00 <printnum>
  800d9c:	eb 14                	jmp    800db2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800da2:	8b 45 18             	mov    0x18(%ebp),%eax
  800da5:	89 04 24             	mov    %eax,(%esp)
  800da8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800daa:	83 ee 01             	sub    $0x1,%esi
  800dad:	75 ef                	jne    800d9e <printnum+0x9e>
  800daf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800db2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800db6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800dbd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800dc0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dc4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dcb:	89 04 24             	mov    %eax,(%esp)
  800dce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd5:	e8 76 1d 00 00       	call   802b50 <__umoddi3>
  800dda:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dde:	0f be 80 a7 2e 80 00 	movsbl 0x802ea7(%eax),%eax
  800de5:	89 04 24             	mov    %eax,(%esp)
  800de8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800deb:	ff d0                	call   *%eax
}
  800ded:	83 c4 3c             	add    $0x3c,%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800df8:	83 fa 01             	cmp    $0x1,%edx
  800dfb:	7e 0e                	jle    800e0b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800dfd:	8b 10                	mov    (%eax),%edx
  800dff:	8d 4a 08             	lea    0x8(%edx),%ecx
  800e02:	89 08                	mov    %ecx,(%eax)
  800e04:	8b 02                	mov    (%edx),%eax
  800e06:	8b 52 04             	mov    0x4(%edx),%edx
  800e09:	eb 22                	jmp    800e2d <getuint+0x38>
	else if (lflag)
  800e0b:	85 d2                	test   %edx,%edx
  800e0d:	74 10                	je     800e1f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800e0f:	8b 10                	mov    (%eax),%edx
  800e11:	8d 4a 04             	lea    0x4(%edx),%ecx
  800e14:	89 08                	mov    %ecx,(%eax)
  800e16:	8b 02                	mov    (%edx),%eax
  800e18:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1d:	eb 0e                	jmp    800e2d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800e1f:	8b 10                	mov    (%eax),%edx
  800e21:	8d 4a 04             	lea    0x4(%edx),%ecx
  800e24:	89 08                	mov    %ecx,(%eax)
  800e26:	8b 02                	mov    (%edx),%eax
  800e28:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800e35:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800e39:	8b 10                	mov    (%eax),%edx
  800e3b:	3b 50 04             	cmp    0x4(%eax),%edx
  800e3e:	73 0a                	jae    800e4a <sprintputch+0x1b>
		*b->buf++ = ch;
  800e40:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e43:	89 08                	mov    %ecx,(%eax)
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	88 02                	mov    %al,(%edx)
}
  800e4a:	5d                   	pop    %ebp
  800e4b:	c3                   	ret    

00800e4c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e52:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800e59:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	89 04 24             	mov    %eax,(%esp)
  800e6d:	e8 02 00 00 00       	call   800e74 <vprintfmt>
	va_end(ap);
}
  800e72:	c9                   	leave  
  800e73:	c3                   	ret    

00800e74 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	57                   	push   %edi
  800e78:	56                   	push   %esi
  800e79:	53                   	push   %ebx
  800e7a:	83 ec 3c             	sub    $0x3c,%esp
  800e7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e83:	eb 18                	jmp    800e9d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800e85:	85 c0                	test   %eax,%eax
  800e87:	0f 84 c3 03 00 00    	je     801250 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  800e8d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e91:	89 04 24             	mov    %eax,(%esp)
  800e94:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e97:	89 f3                	mov    %esi,%ebx
  800e99:	eb 02                	jmp    800e9d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  800e9b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e9d:	8d 73 01             	lea    0x1(%ebx),%esi
  800ea0:	0f b6 03             	movzbl (%ebx),%eax
  800ea3:	83 f8 25             	cmp    $0x25,%eax
  800ea6:	75 dd                	jne    800e85 <vprintfmt+0x11>
  800ea8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  800eac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800eb3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800eba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec6:	eb 1d                	jmp    800ee5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ec8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800eca:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  800ece:	eb 15                	jmp    800ee5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ed0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ed2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800ed6:	eb 0d                	jmp    800ee5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800ed8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ede:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ee5:	8d 5e 01             	lea    0x1(%esi),%ebx
  800ee8:	0f b6 06             	movzbl (%esi),%eax
  800eeb:	0f b6 c8             	movzbl %al,%ecx
  800eee:	83 e8 23             	sub    $0x23,%eax
  800ef1:	3c 55                	cmp    $0x55,%al
  800ef3:	0f 87 2f 03 00 00    	ja     801228 <vprintfmt+0x3b4>
  800ef9:	0f b6 c0             	movzbl %al,%eax
  800efc:	ff 24 85 e0 2f 80 00 	jmp    *0x802fe0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800f03:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800f06:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800f09:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  800f0d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800f10:	83 f9 09             	cmp    $0x9,%ecx
  800f13:	77 50                	ja     800f65 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f15:	89 de                	mov    %ebx,%esi
  800f17:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f1a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  800f1d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800f20:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800f24:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800f27:	8d 58 d0             	lea    -0x30(%eax),%ebx
  800f2a:	83 fb 09             	cmp    $0x9,%ebx
  800f2d:	76 eb                	jbe    800f1a <vprintfmt+0xa6>
  800f2f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f32:	eb 33                	jmp    800f67 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f34:	8b 45 14             	mov    0x14(%ebp),%eax
  800f37:	8d 48 04             	lea    0x4(%eax),%ecx
  800f3a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800f3d:	8b 00                	mov    (%eax),%eax
  800f3f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f42:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800f44:	eb 21                	jmp    800f67 <vprintfmt+0xf3>
  800f46:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800f49:	85 c9                	test   %ecx,%ecx
  800f4b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f50:	0f 49 c1             	cmovns %ecx,%eax
  800f53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f56:	89 de                	mov    %ebx,%esi
  800f58:	eb 8b                	jmp    800ee5 <vprintfmt+0x71>
  800f5a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800f5c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800f63:	eb 80                	jmp    800ee5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f65:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f6b:	0f 89 74 ff ff ff    	jns    800ee5 <vprintfmt+0x71>
  800f71:	e9 62 ff ff ff       	jmp    800ed8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f76:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f79:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  800f7b:	e9 65 ff ff ff       	jmp    800ee5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f80:	8b 45 14             	mov    0x14(%ebp),%eax
  800f83:	8d 50 04             	lea    0x4(%eax),%edx
  800f86:	89 55 14             	mov    %edx,0x14(%ebp)
  800f89:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f8d:	8b 00                	mov    (%eax),%eax
  800f8f:	89 04 24             	mov    %eax,(%esp)
  800f92:	ff 55 08             	call   *0x8(%ebp)
			break;
  800f95:	e9 03 ff ff ff       	jmp    800e9d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9d:	8d 50 04             	lea    0x4(%eax),%edx
  800fa0:	89 55 14             	mov    %edx,0x14(%ebp)
  800fa3:	8b 00                	mov    (%eax),%eax
  800fa5:	99                   	cltd   
  800fa6:	31 d0                	xor    %edx,%eax
  800fa8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800faa:	83 f8 0f             	cmp    $0xf,%eax
  800fad:	7f 0b                	jg     800fba <vprintfmt+0x146>
  800faf:	8b 14 85 40 31 80 00 	mov    0x803140(,%eax,4),%edx
  800fb6:	85 d2                	test   %edx,%edx
  800fb8:	75 20                	jne    800fda <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  800fba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fbe:	c7 44 24 08 bf 2e 80 	movl   $0x802ebf,0x8(%esp)
  800fc5:	00 
  800fc6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	89 04 24             	mov    %eax,(%esp)
  800fd0:	e8 77 fe ff ff       	call   800e4c <printfmt>
  800fd5:	e9 c3 fe ff ff       	jmp    800e9d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  800fda:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800fde:	c7 44 24 08 0f 2d 80 	movl   $0x802d0f,0x8(%esp)
  800fe5:	00 
  800fe6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fea:	8b 45 08             	mov    0x8(%ebp),%eax
  800fed:	89 04 24             	mov    %eax,(%esp)
  800ff0:	e8 57 fe ff ff       	call   800e4c <printfmt>
  800ff5:	e9 a3 fe ff ff       	jmp    800e9d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800ffa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800ffd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801000:	8b 45 14             	mov    0x14(%ebp),%eax
  801003:	8d 50 04             	lea    0x4(%eax),%edx
  801006:	89 55 14             	mov    %edx,0x14(%ebp)
  801009:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80100b:	85 c0                	test   %eax,%eax
  80100d:	ba b8 2e 80 00       	mov    $0x802eb8,%edx
  801012:	0f 45 d0             	cmovne %eax,%edx
  801015:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801018:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80101c:	74 04                	je     801022 <vprintfmt+0x1ae>
  80101e:	85 f6                	test   %esi,%esi
  801020:	7f 19                	jg     80103b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801022:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801025:	8d 70 01             	lea    0x1(%eax),%esi
  801028:	0f b6 10             	movzbl (%eax),%edx
  80102b:	0f be c2             	movsbl %dl,%eax
  80102e:	85 c0                	test   %eax,%eax
  801030:	0f 85 95 00 00 00    	jne    8010cb <vprintfmt+0x257>
  801036:	e9 85 00 00 00       	jmp    8010c0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80103b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80103f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801042:	89 04 24             	mov    %eax,(%esp)
  801045:	e8 b8 02 00 00       	call   801302 <strnlen>
  80104a:	29 c6                	sub    %eax,%esi
  80104c:	89 f0                	mov    %esi,%eax
  80104e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801051:	85 f6                	test   %esi,%esi
  801053:	7e cd                	jle    801022 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801055:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801059:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80105c:	89 c3                	mov    %eax,%ebx
  80105e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801062:	89 34 24             	mov    %esi,(%esp)
  801065:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801068:	83 eb 01             	sub    $0x1,%ebx
  80106b:	75 f1                	jne    80105e <vprintfmt+0x1ea>
  80106d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801070:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801073:	eb ad                	jmp    801022 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801075:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801079:	74 1e                	je     801099 <vprintfmt+0x225>
  80107b:	0f be d2             	movsbl %dl,%edx
  80107e:	83 ea 20             	sub    $0x20,%edx
  801081:	83 fa 5e             	cmp    $0x5e,%edx
  801084:	76 13                	jbe    801099 <vprintfmt+0x225>
					putch('?', putdat);
  801086:	8b 45 0c             	mov    0xc(%ebp),%eax
  801089:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801094:	ff 55 08             	call   *0x8(%ebp)
  801097:	eb 0d                	jmp    8010a6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8010a0:	89 04 24             	mov    %eax,(%esp)
  8010a3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010a6:	83 ef 01             	sub    $0x1,%edi
  8010a9:	83 c6 01             	add    $0x1,%esi
  8010ac:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8010b0:	0f be c2             	movsbl %dl,%eax
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	75 20                	jne    8010d7 <vprintfmt+0x263>
  8010b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8010ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010c4:	7f 25                	jg     8010eb <vprintfmt+0x277>
  8010c6:	e9 d2 fd ff ff       	jmp    800e9d <vprintfmt+0x29>
  8010cb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8010ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8010d1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010d4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010d7:	85 db                	test   %ebx,%ebx
  8010d9:	78 9a                	js     801075 <vprintfmt+0x201>
  8010db:	83 eb 01             	sub    $0x1,%ebx
  8010de:	79 95                	jns    801075 <vprintfmt+0x201>
  8010e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8010e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8010e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e9:	eb d5                	jmp    8010c0 <vprintfmt+0x24c>
  8010eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8010ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8010f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8010f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8010f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8010ff:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801101:	83 eb 01             	sub    $0x1,%ebx
  801104:	75 ee                	jne    8010f4 <vprintfmt+0x280>
  801106:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801109:	e9 8f fd ff ff       	jmp    800e9d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80110e:	83 fa 01             	cmp    $0x1,%edx
  801111:	7e 16                	jle    801129 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	8d 50 08             	lea    0x8(%eax),%edx
  801119:	89 55 14             	mov    %edx,0x14(%ebp)
  80111c:	8b 50 04             	mov    0x4(%eax),%edx
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801124:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801127:	eb 32                	jmp    80115b <vprintfmt+0x2e7>
	else if (lflag)
  801129:	85 d2                	test   %edx,%edx
  80112b:	74 18                	je     801145 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80112d:	8b 45 14             	mov    0x14(%ebp),%eax
  801130:	8d 50 04             	lea    0x4(%eax),%edx
  801133:	89 55 14             	mov    %edx,0x14(%ebp)
  801136:	8b 30                	mov    (%eax),%esi
  801138:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80113b:	89 f0                	mov    %esi,%eax
  80113d:	c1 f8 1f             	sar    $0x1f,%eax
  801140:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801143:	eb 16                	jmp    80115b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801145:	8b 45 14             	mov    0x14(%ebp),%eax
  801148:	8d 50 04             	lea    0x4(%eax),%edx
  80114b:	89 55 14             	mov    %edx,0x14(%ebp)
  80114e:	8b 30                	mov    (%eax),%esi
  801150:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801153:	89 f0                	mov    %esi,%eax
  801155:	c1 f8 1f             	sar    $0x1f,%eax
  801158:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80115b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80115e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801161:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801166:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80116a:	0f 89 80 00 00 00    	jns    8011f0 <vprintfmt+0x37c>
				putch('-', putdat);
  801170:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801174:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80117b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80117e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801181:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801184:	f7 d8                	neg    %eax
  801186:	83 d2 00             	adc    $0x0,%edx
  801189:	f7 da                	neg    %edx
			}
			base = 10;
  80118b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801190:	eb 5e                	jmp    8011f0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801192:	8d 45 14             	lea    0x14(%ebp),%eax
  801195:	e8 5b fc ff ff       	call   800df5 <getuint>
			base = 10;
  80119a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80119f:	eb 4f                	jmp    8011f0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8011a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8011a4:	e8 4c fc ff ff       	call   800df5 <getuint>
			base = 8;
  8011a9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8011ae:	eb 40                	jmp    8011f0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8011b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011b4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8011bb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8011be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8011c2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8011c9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8011cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cf:	8d 50 04             	lea    0x4(%eax),%edx
  8011d2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011d5:	8b 00                	mov    (%eax),%eax
  8011d7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8011dc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8011e1:	eb 0d                	jmp    8011f0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e6:	e8 0a fc ff ff       	call   800df5 <getuint>
			base = 16;
  8011eb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011f0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8011f4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8011f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8011fb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801203:	89 04 24             	mov    %eax,(%esp)
  801206:	89 54 24 04          	mov    %edx,0x4(%esp)
  80120a:	89 fa                	mov    %edi,%edx
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	e8 ec fa ff ff       	call   800d00 <printnum>
			break;
  801214:	e9 84 fc ff ff       	jmp    800e9d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801219:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80121d:	89 0c 24             	mov    %ecx,(%esp)
  801220:	ff 55 08             	call   *0x8(%ebp)
			break;
  801223:	e9 75 fc ff ff       	jmp    800e9d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801228:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80122c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801233:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801236:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80123a:	0f 84 5b fc ff ff    	je     800e9b <vprintfmt+0x27>
  801240:	89 f3                	mov    %esi,%ebx
  801242:	83 eb 01             	sub    $0x1,%ebx
  801245:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801249:	75 f7                	jne    801242 <vprintfmt+0x3ce>
  80124b:	e9 4d fc ff ff       	jmp    800e9d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801250:	83 c4 3c             	add    $0x3c,%esp
  801253:	5b                   	pop    %ebx
  801254:	5e                   	pop    %esi
  801255:	5f                   	pop    %edi
  801256:	5d                   	pop    %ebp
  801257:	c3                   	ret    

00801258 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	83 ec 28             	sub    $0x28,%esp
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801264:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801267:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80126b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80126e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801275:	85 c0                	test   %eax,%eax
  801277:	74 30                	je     8012a9 <vsnprintf+0x51>
  801279:	85 d2                	test   %edx,%edx
  80127b:	7e 2c                	jle    8012a9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80127d:	8b 45 14             	mov    0x14(%ebp),%eax
  801280:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801284:	8b 45 10             	mov    0x10(%ebp),%eax
  801287:	89 44 24 08          	mov    %eax,0x8(%esp)
  80128b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80128e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801292:	c7 04 24 2f 0e 80 00 	movl   $0x800e2f,(%esp)
  801299:	e8 d6 fb ff ff       	call   800e74 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80129e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a7:	eb 05                	jmp    8012ae <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8012a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8012ae:	c9                   	leave  
  8012af:	c3                   	ret    

008012b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8012b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ce:	89 04 24             	mov    %eax,(%esp)
  8012d1:	e8 82 ff ff ff       	call   801258 <vsnprintf>
	va_end(ap);

	return rc;
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    
  8012d8:	66 90                	xchg   %ax,%ax
  8012da:	66 90                	xchg   %ax,%ax
  8012dc:	66 90                	xchg   %ax,%ax
  8012de:	66 90                	xchg   %ax,%ax

008012e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8012e6:	80 3a 00             	cmpb   $0x0,(%edx)
  8012e9:	74 10                	je     8012fb <strlen+0x1b>
  8012eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8012f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8012f7:	75 f7                	jne    8012f0 <strlen+0x10>
  8012f9:	eb 05                	jmp    801300 <strlen+0x20>
  8012fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801300:	5d                   	pop    %ebp
  801301:	c3                   	ret    

00801302 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801302:	55                   	push   %ebp
  801303:	89 e5                	mov    %esp,%ebp
  801305:	53                   	push   %ebx
  801306:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801309:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80130c:	85 c9                	test   %ecx,%ecx
  80130e:	74 1c                	je     80132c <strnlen+0x2a>
  801310:	80 3b 00             	cmpb   $0x0,(%ebx)
  801313:	74 1e                	je     801333 <strnlen+0x31>
  801315:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80131a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80131c:	39 ca                	cmp    %ecx,%edx
  80131e:	74 18                	je     801338 <strnlen+0x36>
  801320:	83 c2 01             	add    $0x1,%edx
  801323:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801328:	75 f0                	jne    80131a <strnlen+0x18>
  80132a:	eb 0c                	jmp    801338 <strnlen+0x36>
  80132c:	b8 00 00 00 00       	mov    $0x0,%eax
  801331:	eb 05                	jmp    801338 <strnlen+0x36>
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801338:	5b                   	pop    %ebx
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	53                   	push   %ebx
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801345:	89 c2                	mov    %eax,%edx
  801347:	83 c2 01             	add    $0x1,%edx
  80134a:	83 c1 01             	add    $0x1,%ecx
  80134d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801351:	88 5a ff             	mov    %bl,-0x1(%edx)
  801354:	84 db                	test   %bl,%bl
  801356:	75 ef                	jne    801347 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801358:	5b                   	pop    %ebx
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801365:	89 1c 24             	mov    %ebx,(%esp)
  801368:	e8 73 ff ff ff       	call   8012e0 <strlen>
	strcpy(dst + len, src);
  80136d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801370:	89 54 24 04          	mov    %edx,0x4(%esp)
  801374:	01 d8                	add    %ebx,%eax
  801376:	89 04 24             	mov    %eax,(%esp)
  801379:	e8 bd ff ff ff       	call   80133b <strcpy>
	return dst;
}
  80137e:	89 d8                	mov    %ebx,%eax
  801380:	83 c4 08             	add    $0x8,%esp
  801383:	5b                   	pop    %ebx
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	56                   	push   %esi
  80138a:	53                   	push   %ebx
  80138b:	8b 75 08             	mov    0x8(%ebp),%esi
  80138e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801391:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801394:	85 db                	test   %ebx,%ebx
  801396:	74 17                	je     8013af <strncpy+0x29>
  801398:	01 f3                	add    %esi,%ebx
  80139a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80139c:	83 c1 01             	add    $0x1,%ecx
  80139f:	0f b6 02             	movzbl (%edx),%eax
  8013a2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8013a5:	80 3a 01             	cmpb   $0x1,(%edx)
  8013a8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ab:	39 d9                	cmp    %ebx,%ecx
  8013ad:	75 ed                	jne    80139c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8013af:	89 f0                	mov    %esi,%eax
  8013b1:	5b                   	pop    %ebx
  8013b2:	5e                   	pop    %esi
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	57                   	push   %edi
  8013b9:	56                   	push   %esi
  8013ba:	53                   	push   %ebx
  8013bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8013c1:	8b 75 10             	mov    0x10(%ebp),%esi
  8013c4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8013c6:	85 f6                	test   %esi,%esi
  8013c8:	74 34                	je     8013fe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8013ca:	83 fe 01             	cmp    $0x1,%esi
  8013cd:	74 26                	je     8013f5 <strlcpy+0x40>
  8013cf:	0f b6 0b             	movzbl (%ebx),%ecx
  8013d2:	84 c9                	test   %cl,%cl
  8013d4:	74 23                	je     8013f9 <strlcpy+0x44>
  8013d6:	83 ee 02             	sub    $0x2,%esi
  8013d9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8013de:	83 c0 01             	add    $0x1,%eax
  8013e1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e4:	39 f2                	cmp    %esi,%edx
  8013e6:	74 13                	je     8013fb <strlcpy+0x46>
  8013e8:	83 c2 01             	add    $0x1,%edx
  8013eb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8013ef:	84 c9                	test   %cl,%cl
  8013f1:	75 eb                	jne    8013de <strlcpy+0x29>
  8013f3:	eb 06                	jmp    8013fb <strlcpy+0x46>
  8013f5:	89 f8                	mov    %edi,%eax
  8013f7:	eb 02                	jmp    8013fb <strlcpy+0x46>
  8013f9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8013fb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013fe:	29 f8                	sub    %edi,%eax
}
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80140e:	0f b6 01             	movzbl (%ecx),%eax
  801411:	84 c0                	test   %al,%al
  801413:	74 15                	je     80142a <strcmp+0x25>
  801415:	3a 02                	cmp    (%edx),%al
  801417:	75 11                	jne    80142a <strcmp+0x25>
		p++, q++;
  801419:	83 c1 01             	add    $0x1,%ecx
  80141c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80141f:	0f b6 01             	movzbl (%ecx),%eax
  801422:	84 c0                	test   %al,%al
  801424:	74 04                	je     80142a <strcmp+0x25>
  801426:	3a 02                	cmp    (%edx),%al
  801428:	74 ef                	je     801419 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80142a:	0f b6 c0             	movzbl %al,%eax
  80142d:	0f b6 12             	movzbl (%edx),%edx
  801430:	29 d0                	sub    %edx,%eax
}
  801432:	5d                   	pop    %ebp
  801433:	c3                   	ret    

00801434 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80143c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80143f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801442:	85 f6                	test   %esi,%esi
  801444:	74 29                	je     80146f <strncmp+0x3b>
  801446:	0f b6 03             	movzbl (%ebx),%eax
  801449:	84 c0                	test   %al,%al
  80144b:	74 30                	je     80147d <strncmp+0x49>
  80144d:	3a 02                	cmp    (%edx),%al
  80144f:	75 2c                	jne    80147d <strncmp+0x49>
  801451:	8d 43 01             	lea    0x1(%ebx),%eax
  801454:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801456:	89 c3                	mov    %eax,%ebx
  801458:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80145b:	39 f0                	cmp    %esi,%eax
  80145d:	74 17                	je     801476 <strncmp+0x42>
  80145f:	0f b6 08             	movzbl (%eax),%ecx
  801462:	84 c9                	test   %cl,%cl
  801464:	74 17                	je     80147d <strncmp+0x49>
  801466:	83 c0 01             	add    $0x1,%eax
  801469:	3a 0a                	cmp    (%edx),%cl
  80146b:	74 e9                	je     801456 <strncmp+0x22>
  80146d:	eb 0e                	jmp    80147d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
  801474:	eb 0f                	jmp    801485 <strncmp+0x51>
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 08                	jmp    801485 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80147d:	0f b6 03             	movzbl (%ebx),%eax
  801480:	0f b6 12             	movzbl (%edx),%edx
  801483:	29 d0                	sub    %edx,%eax
}
  801485:	5b                   	pop    %ebx
  801486:	5e                   	pop    %esi
  801487:	5d                   	pop    %ebp
  801488:	c3                   	ret    

00801489 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	53                   	push   %ebx
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801493:	0f b6 18             	movzbl (%eax),%ebx
  801496:	84 db                	test   %bl,%bl
  801498:	74 1d                	je     8014b7 <strchr+0x2e>
  80149a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  80149c:	38 d3                	cmp    %dl,%bl
  80149e:	75 06                	jne    8014a6 <strchr+0x1d>
  8014a0:	eb 1a                	jmp    8014bc <strchr+0x33>
  8014a2:	38 ca                	cmp    %cl,%dl
  8014a4:	74 16                	je     8014bc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014a6:	83 c0 01             	add    $0x1,%eax
  8014a9:	0f b6 10             	movzbl (%eax),%edx
  8014ac:	84 d2                	test   %dl,%dl
  8014ae:	75 f2                	jne    8014a2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  8014b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b5:	eb 05                	jmp    8014bc <strchr+0x33>
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014bc:	5b                   	pop    %ebx
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    

008014bf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014bf:	55                   	push   %ebp
  8014c0:	89 e5                	mov    %esp,%ebp
  8014c2:	53                   	push   %ebx
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  8014c9:	0f b6 18             	movzbl (%eax),%ebx
  8014cc:	84 db                	test   %bl,%bl
  8014ce:	74 16                	je     8014e6 <strfind+0x27>
  8014d0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  8014d2:	38 d3                	cmp    %dl,%bl
  8014d4:	75 06                	jne    8014dc <strfind+0x1d>
  8014d6:	eb 0e                	jmp    8014e6 <strfind+0x27>
  8014d8:	38 ca                	cmp    %cl,%dl
  8014da:	74 0a                	je     8014e6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014dc:	83 c0 01             	add    $0x1,%eax
  8014df:	0f b6 10             	movzbl (%eax),%edx
  8014e2:	84 d2                	test   %dl,%dl
  8014e4:	75 f2                	jne    8014d8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  8014e6:	5b                   	pop    %ebx
  8014e7:	5d                   	pop    %ebp
  8014e8:	c3                   	ret    

008014e9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014e9:	55                   	push   %ebp
  8014ea:	89 e5                	mov    %esp,%ebp
  8014ec:	57                   	push   %edi
  8014ed:	56                   	push   %esi
  8014ee:	53                   	push   %ebx
  8014ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8014f5:	85 c9                	test   %ecx,%ecx
  8014f7:	74 36                	je     80152f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8014f9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8014ff:	75 28                	jne    801529 <memset+0x40>
  801501:	f6 c1 03             	test   $0x3,%cl
  801504:	75 23                	jne    801529 <memset+0x40>
		c &= 0xFF;
  801506:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80150a:	89 d3                	mov    %edx,%ebx
  80150c:	c1 e3 08             	shl    $0x8,%ebx
  80150f:	89 d6                	mov    %edx,%esi
  801511:	c1 e6 18             	shl    $0x18,%esi
  801514:	89 d0                	mov    %edx,%eax
  801516:	c1 e0 10             	shl    $0x10,%eax
  801519:	09 f0                	or     %esi,%eax
  80151b:	09 c2                	or     %eax,%edx
  80151d:	89 d0                	mov    %edx,%eax
  80151f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801521:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801524:	fc                   	cld    
  801525:	f3 ab                	rep stos %eax,%es:(%edi)
  801527:	eb 06                	jmp    80152f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80152c:	fc                   	cld    
  80152d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80152f:	89 f8                	mov    %edi,%eax
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5f                   	pop    %edi
  801534:	5d                   	pop    %ebp
  801535:	c3                   	ret    

00801536 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	57                   	push   %edi
  80153a:	56                   	push   %esi
  80153b:	8b 45 08             	mov    0x8(%ebp),%eax
  80153e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801541:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801544:	39 c6                	cmp    %eax,%esi
  801546:	73 35                	jae    80157d <memmove+0x47>
  801548:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80154b:	39 d0                	cmp    %edx,%eax
  80154d:	73 2e                	jae    80157d <memmove+0x47>
		s += n;
		d += n;
  80154f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801552:	89 d6                	mov    %edx,%esi
  801554:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801556:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80155c:	75 13                	jne    801571 <memmove+0x3b>
  80155e:	f6 c1 03             	test   $0x3,%cl
  801561:	75 0e                	jne    801571 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801563:	83 ef 04             	sub    $0x4,%edi
  801566:	8d 72 fc             	lea    -0x4(%edx),%esi
  801569:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80156c:	fd                   	std    
  80156d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80156f:	eb 09                	jmp    80157a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801571:	83 ef 01             	sub    $0x1,%edi
  801574:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801577:	fd                   	std    
  801578:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80157a:	fc                   	cld    
  80157b:	eb 1d                	jmp    80159a <memmove+0x64>
  80157d:	89 f2                	mov    %esi,%edx
  80157f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801581:	f6 c2 03             	test   $0x3,%dl
  801584:	75 0f                	jne    801595 <memmove+0x5f>
  801586:	f6 c1 03             	test   $0x3,%cl
  801589:	75 0a                	jne    801595 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80158b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  80158e:	89 c7                	mov    %eax,%edi
  801590:	fc                   	cld    
  801591:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801593:	eb 05                	jmp    80159a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801595:	89 c7                	mov    %eax,%edi
  801597:	fc                   	cld    
  801598:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80159a:	5e                   	pop    %esi
  80159b:	5f                   	pop    %edi
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	89 04 24             	mov    %eax,(%esp)
  8015b8:	e8 79 ff ff ff       	call   801536 <memmove>
}
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	57                   	push   %edi
  8015c3:	56                   	push   %esi
  8015c4:	53                   	push   %ebx
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015cb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ce:	8d 78 ff             	lea    -0x1(%eax),%edi
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	74 36                	je     80160b <memcmp+0x4c>
		if (*s1 != *s2)
  8015d5:	0f b6 03             	movzbl (%ebx),%eax
  8015d8:	0f b6 0e             	movzbl (%esi),%ecx
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	38 c8                	cmp    %cl,%al
  8015e2:	74 1c                	je     801600 <memcmp+0x41>
  8015e4:	eb 10                	jmp    8015f6 <memcmp+0x37>
  8015e6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  8015eb:	83 c2 01             	add    $0x1,%edx
  8015ee:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  8015f2:	38 c8                	cmp    %cl,%al
  8015f4:	74 0a                	je     801600 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  8015f6:	0f b6 c0             	movzbl %al,%eax
  8015f9:	0f b6 c9             	movzbl %cl,%ecx
  8015fc:	29 c8                	sub    %ecx,%eax
  8015fe:	eb 10                	jmp    801610 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801600:	39 fa                	cmp    %edi,%edx
  801602:	75 e2                	jne    8015e6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
  801609:	eb 05                	jmp    801610 <memcmp+0x51>
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801610:	5b                   	pop    %ebx
  801611:	5e                   	pop    %esi
  801612:	5f                   	pop    %edi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	53                   	push   %ebx
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80161f:	89 c2                	mov    %eax,%edx
  801621:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801624:	39 d0                	cmp    %edx,%eax
  801626:	73 13                	jae    80163b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801628:	89 d9                	mov    %ebx,%ecx
  80162a:	38 18                	cmp    %bl,(%eax)
  80162c:	75 06                	jne    801634 <memfind+0x1f>
  80162e:	eb 0b                	jmp    80163b <memfind+0x26>
  801630:	38 08                	cmp    %cl,(%eax)
  801632:	74 07                	je     80163b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801634:	83 c0 01             	add    $0x1,%eax
  801637:	39 d0                	cmp    %edx,%eax
  801639:	75 f5                	jne    801630 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80163b:	5b                   	pop    %ebx
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	57                   	push   %edi
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	8b 55 08             	mov    0x8(%ebp),%edx
  801647:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164a:	0f b6 0a             	movzbl (%edx),%ecx
  80164d:	80 f9 09             	cmp    $0x9,%cl
  801650:	74 05                	je     801657 <strtol+0x19>
  801652:	80 f9 20             	cmp    $0x20,%cl
  801655:	75 10                	jne    801667 <strtol+0x29>
		s++;
  801657:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80165a:	0f b6 0a             	movzbl (%edx),%ecx
  80165d:	80 f9 09             	cmp    $0x9,%cl
  801660:	74 f5                	je     801657 <strtol+0x19>
  801662:	80 f9 20             	cmp    $0x20,%cl
  801665:	74 f0                	je     801657 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801667:	80 f9 2b             	cmp    $0x2b,%cl
  80166a:	75 0a                	jne    801676 <strtol+0x38>
		s++;
  80166c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  80166f:	bf 00 00 00 00       	mov    $0x0,%edi
  801674:	eb 11                	jmp    801687 <strtol+0x49>
  801676:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  80167b:	80 f9 2d             	cmp    $0x2d,%cl
  80167e:	75 07                	jne    801687 <strtol+0x49>
		s++, neg = 1;
  801680:	83 c2 01             	add    $0x1,%edx
  801683:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801687:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  80168c:	75 15                	jne    8016a3 <strtol+0x65>
  80168e:	80 3a 30             	cmpb   $0x30,(%edx)
  801691:	75 10                	jne    8016a3 <strtol+0x65>
  801693:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801697:	75 0a                	jne    8016a3 <strtol+0x65>
		s += 2, base = 16;
  801699:	83 c2 02             	add    $0x2,%edx
  80169c:	b8 10 00 00 00       	mov    $0x10,%eax
  8016a1:	eb 10                	jmp    8016b3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	75 0c                	jne    8016b3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8016a7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016a9:	80 3a 30             	cmpb   $0x30,(%edx)
  8016ac:	75 05                	jne    8016b3 <strtol+0x75>
		s++, base = 8;
  8016ae:	83 c2 01             	add    $0x1,%edx
  8016b1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8016b3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016b8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bb:	0f b6 0a             	movzbl (%edx),%ecx
  8016be:	8d 71 d0             	lea    -0x30(%ecx),%esi
  8016c1:	89 f0                	mov    %esi,%eax
  8016c3:	3c 09                	cmp    $0x9,%al
  8016c5:	77 08                	ja     8016cf <strtol+0x91>
			dig = *s - '0';
  8016c7:	0f be c9             	movsbl %cl,%ecx
  8016ca:	83 e9 30             	sub    $0x30,%ecx
  8016cd:	eb 20                	jmp    8016ef <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  8016cf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  8016d2:	89 f0                	mov    %esi,%eax
  8016d4:	3c 19                	cmp    $0x19,%al
  8016d6:	77 08                	ja     8016e0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  8016d8:	0f be c9             	movsbl %cl,%ecx
  8016db:	83 e9 57             	sub    $0x57,%ecx
  8016de:	eb 0f                	jmp    8016ef <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  8016e0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  8016e3:	89 f0                	mov    %esi,%eax
  8016e5:	3c 19                	cmp    $0x19,%al
  8016e7:	77 16                	ja     8016ff <strtol+0xc1>
			dig = *s - 'A' + 10;
  8016e9:	0f be c9             	movsbl %cl,%ecx
  8016ec:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8016ef:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  8016f2:	7d 0f                	jge    801703 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  8016f4:	83 c2 01             	add    $0x1,%edx
  8016f7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  8016fb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  8016fd:	eb bc                	jmp    8016bb <strtol+0x7d>
  8016ff:	89 d8                	mov    %ebx,%eax
  801701:	eb 02                	jmp    801705 <strtol+0xc7>
  801703:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801705:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801709:	74 05                	je     801710 <strtol+0xd2>
		*endptr = (char *) s;
  80170b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80170e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801710:	f7 d8                	neg    %eax
  801712:	85 ff                	test   %edi,%edi
  801714:	0f 44 c3             	cmove  %ebx,%eax
}
  801717:	5b                   	pop    %ebx
  801718:	5e                   	pop    %esi
  801719:	5f                   	pop    %edi
  80171a:	5d                   	pop    %ebp
  80171b:	c3                   	ret    

0080171c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	57                   	push   %edi
  801720:	56                   	push   %esi
  801721:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
  801727:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80172a:	8b 55 08             	mov    0x8(%ebp),%edx
  80172d:	89 c3                	mov    %eax,%ebx
  80172f:	89 c7                	mov    %eax,%edi
  801731:	89 c6                	mov    %eax,%esi
  801733:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801735:	5b                   	pop    %ebx
  801736:	5e                   	pop    %esi
  801737:	5f                   	pop    %edi
  801738:	5d                   	pop    %ebp
  801739:	c3                   	ret    

0080173a <sys_cgetc>:

int
sys_cgetc(void)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	57                   	push   %edi
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801740:	ba 00 00 00 00       	mov    $0x0,%edx
  801745:	b8 01 00 00 00       	mov    $0x1,%eax
  80174a:	89 d1                	mov    %edx,%ecx
  80174c:	89 d3                	mov    %edx,%ebx
  80174e:	89 d7                	mov    %edx,%edi
  801750:	89 d6                	mov    %edx,%esi
  801752:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801754:	5b                   	pop    %ebx
  801755:	5e                   	pop    %esi
  801756:	5f                   	pop    %edi
  801757:	5d                   	pop    %ebp
  801758:	c3                   	ret    

00801759 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	57                   	push   %edi
  80175d:	56                   	push   %esi
  80175e:	53                   	push   %ebx
  80175f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801762:	b9 00 00 00 00       	mov    $0x0,%ecx
  801767:	b8 03 00 00 00       	mov    $0x3,%eax
  80176c:	8b 55 08             	mov    0x8(%ebp),%edx
  80176f:	89 cb                	mov    %ecx,%ebx
  801771:	89 cf                	mov    %ecx,%edi
  801773:	89 ce                	mov    %ecx,%esi
  801775:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801777:	85 c0                	test   %eax,%eax
  801779:	7e 28                	jle    8017a3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80177b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80177f:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801786:	00 
  801787:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  80178e:	00 
  80178f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801796:	00 
  801797:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  80179e:	e8 4a f4 ff ff       	call   800bed <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8017a3:	83 c4 2c             	add    $0x2c,%esp
  8017a6:	5b                   	pop    %ebx
  8017a7:	5e                   	pop    %esi
  8017a8:	5f                   	pop    %edi
  8017a9:	5d                   	pop    %ebp
  8017aa:	c3                   	ret    

008017ab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	57                   	push   %edi
  8017af:	56                   	push   %esi
  8017b0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b6:	b8 02 00 00 00       	mov    $0x2,%eax
  8017bb:	89 d1                	mov    %edx,%ecx
  8017bd:	89 d3                	mov    %edx,%ebx
  8017bf:	89 d7                	mov    %edx,%edi
  8017c1:	89 d6                	mov    %edx,%esi
  8017c3:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8017c5:	5b                   	pop    %ebx
  8017c6:	5e                   	pop    %esi
  8017c7:	5f                   	pop    %edi
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <sys_yield>:

void
sys_yield(void)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	57                   	push   %edi
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	b8 0b 00 00 00       	mov    $0xb,%eax
  8017da:	89 d1                	mov    %edx,%ecx
  8017dc:	89 d3                	mov    %edx,%ebx
  8017de:	89 d7                	mov    %edx,%edi
  8017e0:	89 d6                	mov    %edx,%esi
  8017e2:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8017e4:	5b                   	pop    %ebx
  8017e5:	5e                   	pop    %esi
  8017e6:	5f                   	pop    %edi
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    

008017e9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	57                   	push   %edi
  8017ed:	56                   	push   %esi
  8017ee:	53                   	push   %ebx
  8017ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f2:	be 00 00 00 00       	mov    $0x0,%esi
  8017f7:	b8 04 00 00 00       	mov    $0x4,%eax
  8017fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801802:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801805:	89 f7                	mov    %esi,%edi
  801807:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801809:	85 c0                	test   %eax,%eax
  80180b:	7e 28                	jle    801835 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80180d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801811:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801818:	00 
  801819:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801820:	00 
  801821:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801828:	00 
  801829:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801830:	e8 b8 f3 ff ff       	call   800bed <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801835:	83 c4 2c             	add    $0x2c,%esp
  801838:	5b                   	pop    %ebx
  801839:	5e                   	pop    %esi
  80183a:	5f                   	pop    %edi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    

0080183d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	57                   	push   %edi
  801841:	56                   	push   %esi
  801842:	53                   	push   %ebx
  801843:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801846:	b8 05 00 00 00       	mov    $0x5,%eax
  80184b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80184e:	8b 55 08             	mov    0x8(%ebp),%edx
  801851:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801854:	8b 7d 14             	mov    0x14(%ebp),%edi
  801857:	8b 75 18             	mov    0x18(%ebp),%esi
  80185a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80185c:	85 c0                	test   %eax,%eax
  80185e:	7e 28                	jle    801888 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801860:	89 44 24 10          	mov    %eax,0x10(%esp)
  801864:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80186b:	00 
  80186c:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801873:	00 
  801874:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80187b:	00 
  80187c:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801883:	e8 65 f3 ff ff       	call   800bed <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801888:	83 c4 2c             	add    $0x2c,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5f                   	pop    %edi
  80188e:	5d                   	pop    %ebp
  80188f:	c3                   	ret    

00801890 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	57                   	push   %edi
  801894:	56                   	push   %esi
  801895:	53                   	push   %ebx
  801896:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801899:	bb 00 00 00 00       	mov    $0x0,%ebx
  80189e:	b8 06 00 00 00       	mov    $0x6,%eax
  8018a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a9:	89 df                	mov    %ebx,%edi
  8018ab:	89 de                	mov    %ebx,%esi
  8018ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	7e 28                	jle    8018db <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018b7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8018be:	00 
  8018bf:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  8018c6:	00 
  8018c7:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018ce:	00 
  8018cf:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  8018d6:	e8 12 f3 ff ff       	call   800bed <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8018db:	83 c4 2c             	add    $0x2c,%esp
  8018de:	5b                   	pop    %ebx
  8018df:	5e                   	pop    %esi
  8018e0:	5f                   	pop    %edi
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	57                   	push   %edi
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ec:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8018f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fc:	89 df                	mov    %ebx,%edi
  8018fe:	89 de                	mov    %ebx,%esi
  801900:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801902:	85 c0                	test   %eax,%eax
  801904:	7e 28                	jle    80192e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801906:	89 44 24 10          	mov    %eax,0x10(%esp)
  80190a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801911:	00 
  801912:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801919:	00 
  80191a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801921:	00 
  801922:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801929:	e8 bf f2 ff ff       	call   800bed <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80192e:	83 c4 2c             	add    $0x2c,%esp
  801931:	5b                   	pop    %ebx
  801932:	5e                   	pop    %esi
  801933:	5f                   	pop    %edi
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	57                   	push   %edi
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
  80193c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801944:	b8 09 00 00 00       	mov    $0x9,%eax
  801949:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80194c:	8b 55 08             	mov    0x8(%ebp),%edx
  80194f:	89 df                	mov    %ebx,%edi
  801951:	89 de                	mov    %ebx,%esi
  801953:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801955:	85 c0                	test   %eax,%eax
  801957:	7e 28                	jle    801981 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801959:	89 44 24 10          	mov    %eax,0x10(%esp)
  80195d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801964:	00 
  801965:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  80196c:	00 
  80196d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801974:	00 
  801975:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  80197c:	e8 6c f2 ff ff       	call   800bed <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801981:	83 c4 2c             	add    $0x2c,%esp
  801984:	5b                   	pop    %ebx
  801985:	5e                   	pop    %esi
  801986:	5f                   	pop    %edi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	57                   	push   %edi
  80198d:	56                   	push   %esi
  80198e:	53                   	push   %ebx
  80198f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801992:	bb 00 00 00 00       	mov    $0x0,%ebx
  801997:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80199f:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a2:	89 df                	mov    %ebx,%edi
  8019a4:	89 de                	mov    %ebx,%esi
  8019a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8019a8:	85 c0                	test   %eax,%eax
  8019aa:	7e 28                	jle    8019d4 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019b0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8019b7:	00 
  8019b8:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  8019bf:	00 
  8019c0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8019c7:	00 
  8019c8:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  8019cf:	e8 19 f2 ff ff       	call   800bed <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019d4:	83 c4 2c             	add    $0x2c,%esp
  8019d7:	5b                   	pop    %ebx
  8019d8:	5e                   	pop    %esi
  8019d9:	5f                   	pop    %edi
  8019da:	5d                   	pop    %ebp
  8019db:	c3                   	ret    

008019dc <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	57                   	push   %edi
  8019e0:	56                   	push   %esi
  8019e1:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019e2:	be 00 00 00 00       	mov    $0x0,%esi
  8019e7:	b8 0c 00 00 00       	mov    $0xc,%eax
  8019ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019f5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8019f8:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5f                   	pop    %edi
  8019fd:	5d                   	pop    %ebp
  8019fe:	c3                   	ret    

008019ff <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	57                   	push   %edi
  801a03:	56                   	push   %esi
  801a04:	53                   	push   %ebx
  801a05:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a08:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a0d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801a12:	8b 55 08             	mov    0x8(%ebp),%edx
  801a15:	89 cb                	mov    %ecx,%ebx
  801a17:	89 cf                	mov    %ecx,%edi
  801a19:	89 ce                	mov    %ecx,%esi
  801a1b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801a1d:	85 c0                	test   %eax,%eax
  801a1f:	7e 28                	jle    801a49 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a21:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a25:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801a2c:	00 
  801a2d:	c7 44 24 08 9f 31 80 	movl   $0x80319f,0x8(%esp)
  801a34:	00 
  801a35:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801a3c:	00 
  801a3d:	c7 04 24 bc 31 80 00 	movl   $0x8031bc,(%esp)
  801a44:	e8 a4 f1 ff ff       	call   800bed <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801a49:	83 c4 2c             	add    $0x2c,%esp
  801a4c:	5b                   	pop    %ebx
  801a4d:	5e                   	pop    %esi
  801a4e:	5f                   	pop    %edi
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801a57:	83 3d 10 90 80 00 00 	cmpl   $0x0,0x809010
  801a5e:	75 50                	jne    801ab0 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801a60:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a67:	00 
  801a68:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a6f:	ee 
  801a70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a77:	e8 6d fd ff ff       	call   8017e9 <sys_page_alloc>
  801a7c:	85 c0                	test   %eax,%eax
  801a7e:	79 1c                	jns    801a9c <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801a80:	c7 44 24 08 cc 31 80 	movl   $0x8031cc,0x8(%esp)
  801a87:	00 
  801a88:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801a8f:	00 
  801a90:	c7 04 24 f0 31 80 00 	movl   $0x8031f0,(%esp)
  801a97:	e8 51 f1 ff ff       	call   800bed <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801a9c:	c7 44 24 04 ba 1a 80 	movl   $0x801aba,0x4(%esp)
  801aa3:	00 
  801aa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aab:	e8 d9 fe ff ff       	call   801989 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	a3 10 90 80 00       	mov    %eax,0x809010
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801aba:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801abb:	a1 10 90 80 00       	mov    0x809010,%eax
	call *%eax
  801ac0:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801ac2:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801ac5:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801ac7:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  801acc:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  801acf:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801ad4:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801ad7:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801ad9:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  801adc:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  801ade:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801ae0:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801ae5:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801ae8:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  801aed:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801af0:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801af2:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801af7:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  801afa:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  801aff:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  801b02:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  801b04:	83 c4 08             	add    $0x8,%esp
	popal
  801b07:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801b08:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801b09:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801b0a:	c3                   	ret    

00801b0b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
  801b0e:	56                   	push   %esi
  801b0f:	53                   	push   %ebx
  801b10:	83 ec 10             	sub    $0x10,%esp
  801b13:	8b 75 08             	mov    0x8(%ebp),%esi
  801b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b19:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801b1c:	83 f8 01             	cmp    $0x1,%eax
  801b1f:	19 c0                	sbb    %eax,%eax
  801b21:	f7 d0                	not    %eax
  801b23:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801b28:	89 04 24             	mov    %eax,(%esp)
  801b2b:	e8 cf fe ff ff       	call   8019ff <sys_ipc_recv>
	if (err_code < 0) {
  801b30:	85 c0                	test   %eax,%eax
  801b32:	79 16                	jns    801b4a <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801b34:	85 f6                	test   %esi,%esi
  801b36:	74 06                	je     801b3e <ipc_recv+0x33>
  801b38:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801b3e:	85 db                	test   %ebx,%ebx
  801b40:	74 2c                	je     801b6e <ipc_recv+0x63>
  801b42:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b48:	eb 24                	jmp    801b6e <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801b4a:	85 f6                	test   %esi,%esi
  801b4c:	74 0a                	je     801b58 <ipc_recv+0x4d>
  801b4e:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801b53:	8b 40 74             	mov    0x74(%eax),%eax
  801b56:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801b58:	85 db                	test   %ebx,%ebx
  801b5a:	74 0a                	je     801b66 <ipc_recv+0x5b>
  801b5c:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801b61:	8b 40 78             	mov    0x78(%eax),%eax
  801b64:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801b66:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801b6b:	8b 40 70             	mov    0x70(%eax),%eax
}
  801b6e:	83 c4 10             	add    $0x10,%esp
  801b71:	5b                   	pop    %ebx
  801b72:	5e                   	pop    %esi
  801b73:	5d                   	pop    %ebp
  801b74:	c3                   	ret    

00801b75 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
  801b78:	57                   	push   %edi
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 1c             	sub    $0x1c,%esp
  801b7e:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b81:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801b87:	eb 25                	jmp    801bae <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801b89:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b8c:	74 20                	je     801bae <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801b8e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b92:	c7 44 24 08 fe 31 80 	movl   $0x8031fe,0x8(%esp)
  801b99:	00 
  801b9a:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801ba1:	00 
  801ba2:	c7 04 24 0a 32 80 00 	movl   $0x80320a,(%esp)
  801ba9:	e8 3f f0 ff ff       	call   800bed <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801bae:	85 db                	test   %ebx,%ebx
  801bb0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801bb5:	0f 45 c3             	cmovne %ebx,%eax
  801bb8:	8b 55 14             	mov    0x14(%ebp),%edx
  801bbb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801bbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bc7:	89 3c 24             	mov    %edi,(%esp)
  801bca:	e8 0d fe ff ff       	call   8019dc <sys_ipc_try_send>
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	75 b6                	jne    801b89 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801bd3:	83 c4 1c             	add    $0x1c,%esp
  801bd6:	5b                   	pop    %ebx
  801bd7:	5e                   	pop    %esi
  801bd8:	5f                   	pop    %edi
  801bd9:	5d                   	pop    %ebp
  801bda:	c3                   	ret    

00801bdb <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801be1:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801be6:	39 c8                	cmp    %ecx,%eax
  801be8:	74 17                	je     801c01 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801bea:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801bef:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801bf2:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801bf8:	8b 52 50             	mov    0x50(%edx),%edx
  801bfb:	39 ca                	cmp    %ecx,%edx
  801bfd:	75 14                	jne    801c13 <ipc_find_env+0x38>
  801bff:	eb 05                	jmp    801c06 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c01:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801c06:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c09:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801c0e:	8b 40 40             	mov    0x40(%eax),%eax
  801c11:	eb 0e                	jmp    801c21 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801c13:	83 c0 01             	add    $0x1,%eax
  801c16:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c1b:	75 d2                	jne    801bef <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801c1d:	66 b8 00 00          	mov    $0x0,%ax
}
  801c21:	5d                   	pop    %ebp
  801c22:	c3                   	ret    
  801c23:	66 90                	xchg   %ax,%ax
  801c25:	66 90                	xchg   %ax,%ax
  801c27:	66 90                	xchg   %ax,%ax
  801c29:	66 90                	xchg   %ax,%ax
  801c2b:	66 90                	xchg   %ax,%ax
  801c2d:	66 90                	xchg   %ax,%ax
  801c2f:	90                   	nop

00801c30 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	05 00 00 00 30       	add    $0x30000000,%eax
  801c3b:	c1 e8 0c             	shr    $0xc,%eax
}
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  801c4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c50:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    

00801c57 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c5a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801c5f:	a8 01                	test   $0x1,%al
  801c61:	74 34                	je     801c97 <fd_alloc+0x40>
  801c63:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801c68:	a8 01                	test   $0x1,%al
  801c6a:	74 32                	je     801c9e <fd_alloc+0x47>
  801c6c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801c71:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801c73:	89 c2                	mov    %eax,%edx
  801c75:	c1 ea 16             	shr    $0x16,%edx
  801c78:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c7f:	f6 c2 01             	test   $0x1,%dl
  801c82:	74 1f                	je     801ca3 <fd_alloc+0x4c>
  801c84:	89 c2                	mov    %eax,%edx
  801c86:	c1 ea 0c             	shr    $0xc,%edx
  801c89:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c90:	f6 c2 01             	test   $0x1,%dl
  801c93:	75 1a                	jne    801caf <fd_alloc+0x58>
  801c95:	eb 0c                	jmp    801ca3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801c97:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  801c9c:	eb 05                	jmp    801ca3 <fd_alloc+0x4c>
  801c9e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	89 08                	mov    %ecx,(%eax)
			return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cad:	eb 1a                	jmp    801cc9 <fd_alloc+0x72>
  801caf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801cb4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801cb9:	75 b6                	jne    801c71 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801cc4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801cd1:	83 f8 1f             	cmp    $0x1f,%eax
  801cd4:	77 36                	ja     801d0c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801cd6:	c1 e0 0c             	shl    $0xc,%eax
  801cd9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801cde:	89 c2                	mov    %eax,%edx
  801ce0:	c1 ea 16             	shr    $0x16,%edx
  801ce3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801cea:	f6 c2 01             	test   $0x1,%dl
  801ced:	74 24                	je     801d13 <fd_lookup+0x48>
  801cef:	89 c2                	mov    %eax,%edx
  801cf1:	c1 ea 0c             	shr    $0xc,%edx
  801cf4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cfb:	f6 c2 01             	test   $0x1,%dl
  801cfe:	74 1a                	je     801d1a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d03:	89 02                	mov    %eax,(%edx)
	return 0;
  801d05:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0a:	eb 13                	jmp    801d1f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d0c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d11:	eb 0c                	jmp    801d1f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801d13:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801d18:	eb 05                	jmp    801d1f <fd_lookup+0x54>
  801d1a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  801d1f:	5d                   	pop    %ebp
  801d20:	c3                   	ret    

00801d21 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	53                   	push   %ebx
  801d25:	83 ec 14             	sub    $0x14,%esp
  801d28:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801d2e:	39 05 44 80 80 00    	cmp    %eax,0x808044
  801d34:	75 1e                	jne    801d54 <dev_lookup+0x33>
  801d36:	eb 0e                	jmp    801d46 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d38:	b8 60 80 80 00       	mov    $0x808060,%eax
  801d3d:	eb 0c                	jmp    801d4b <dev_lookup+0x2a>
  801d3f:	b8 7c 80 80 00       	mov    $0x80807c,%eax
  801d44:	eb 05                	jmp    801d4b <dev_lookup+0x2a>
  801d46:	b8 44 80 80 00       	mov    $0x808044,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  801d4b:	89 03                	mov    %eax,(%ebx)
			return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	eb 38                	jmp    801d8c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801d54:	39 05 60 80 80 00    	cmp    %eax,0x808060
  801d5a:	74 dc                	je     801d38 <dev_lookup+0x17>
  801d5c:	39 05 7c 80 80 00    	cmp    %eax,0x80807c
  801d62:	74 db                	je     801d3f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801d64:	8b 15 0c 90 80 00    	mov    0x80900c,%edx
  801d6a:	8b 52 48             	mov    0x48(%edx),%edx
  801d6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d71:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d75:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801d7c:	e8 65 ef ff ff       	call   800ce6 <cprintf>
	*dev = 0;
  801d81:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  801d87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801d8c:	83 c4 14             	add    $0x14,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5d                   	pop    %ebp
  801d91:	c3                   	ret    

00801d92 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	56                   	push   %esi
  801d96:	53                   	push   %ebx
  801d97:	83 ec 20             	sub    $0x20,%esp
  801d9a:	8b 75 08             	mov    0x8(%ebp),%esi
  801d9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801da3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801da7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801dad:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801db0:	89 04 24             	mov    %eax,(%esp)
  801db3:	e8 13 ff ff ff       	call   801ccb <fd_lookup>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 05                	js     801dc1 <fd_close+0x2f>
	    || fd != fd2)
  801dbc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801dbf:	74 0c                	je     801dcd <fd_close+0x3b>
		return (must_exist ? r : 0);
  801dc1:	84 db                	test   %bl,%bl
  801dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc8:	0f 44 c2             	cmove  %edx,%eax
  801dcb:	eb 3f                	jmp    801e0c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dcd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	8b 06                	mov    (%esi),%eax
  801dd6:	89 04 24             	mov    %eax,(%esp)
  801dd9:	e8 43 ff ff ff       	call   801d21 <dev_lookup>
  801dde:	89 c3                	mov    %eax,%ebx
  801de0:	85 c0                	test   %eax,%eax
  801de2:	78 16                	js     801dfa <fd_close+0x68>
		if (dev->dev_close)
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  801dea:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801def:	85 c0                	test   %eax,%eax
  801df1:	74 07                	je     801dfa <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801df3:	89 34 24             	mov    %esi,(%esp)
  801df6:	ff d0                	call   *%eax
  801df8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801dfa:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dfe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e05:	e8 86 fa ff ff       	call   801890 <sys_page_unmap>
	return r;
  801e0a:	89 d8                	mov    %ebx,%eax
}
  801e0c:	83 c4 20             	add    $0x20,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5d                   	pop    %ebp
  801e12:	c3                   	ret    

00801e13 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	89 04 24             	mov    %eax,(%esp)
  801e26:	e8 a0 fe ff ff       	call   801ccb <fd_lookup>
  801e2b:	89 c2                	mov    %eax,%edx
  801e2d:	85 d2                	test   %edx,%edx
  801e2f:	78 13                	js     801e44 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801e31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e38:	00 
  801e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3c:	89 04 24             	mov    %eax,(%esp)
  801e3f:	e8 4e ff ff ff       	call   801d92 <fd_close>
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <close_all>:

void
close_all(void)
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	53                   	push   %ebx
  801e4a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801e52:	89 1c 24             	mov    %ebx,(%esp)
  801e55:	e8 b9 ff ff ff       	call   801e13 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801e5a:	83 c3 01             	add    $0x1,%ebx
  801e5d:	83 fb 20             	cmp    $0x20,%ebx
  801e60:	75 f0                	jne    801e52 <close_all+0xc>
		close(i);
}
  801e62:	83 c4 14             	add    $0x14,%esp
  801e65:	5b                   	pop    %ebx
  801e66:	5d                   	pop    %ebp
  801e67:	c3                   	ret    

00801e68 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	57                   	push   %edi
  801e6c:	56                   	push   %esi
  801e6d:	53                   	push   %ebx
  801e6e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801e71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e78:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7b:	89 04 24             	mov    %eax,(%esp)
  801e7e:	e8 48 fe ff ff       	call   801ccb <fd_lookup>
  801e83:	89 c2                	mov    %eax,%edx
  801e85:	85 d2                	test   %edx,%edx
  801e87:	0f 88 e1 00 00 00    	js     801f6e <dup+0x106>
		return r;
	close(newfdnum);
  801e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e90:	89 04 24             	mov    %eax,(%esp)
  801e93:	e8 7b ff ff ff       	call   801e13 <close>

	newfd = INDEX2FD(newfdnum);
  801e98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801e9b:	c1 e3 0c             	shl    $0xc,%ebx
  801e9e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801ea4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ea7:	89 04 24             	mov    %eax,(%esp)
  801eaa:	e8 91 fd ff ff       	call   801c40 <fd2data>
  801eaf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801eb1:	89 1c 24             	mov    %ebx,(%esp)
  801eb4:	e8 87 fd ff ff       	call   801c40 <fd2data>
  801eb9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801ebb:	89 f0                	mov    %esi,%eax
  801ebd:	c1 e8 16             	shr    $0x16,%eax
  801ec0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ec7:	a8 01                	test   $0x1,%al
  801ec9:	74 43                	je     801f0e <dup+0xa6>
  801ecb:	89 f0                	mov    %esi,%eax
  801ecd:	c1 e8 0c             	shr    $0xc,%eax
  801ed0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801ed7:	f6 c2 01             	test   $0x1,%dl
  801eda:	74 32                	je     801f0e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801edc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ee3:	25 07 0e 00 00       	and    $0xe07,%eax
  801ee8:	89 44 24 10          	mov    %eax,0x10(%esp)
  801eec:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ef0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ef7:	00 
  801ef8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801efc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f03:	e8 35 f9 ff ff       	call   80183d <sys_page_map>
  801f08:	89 c6                	mov    %eax,%esi
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	78 3e                	js     801f4c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f11:	89 c2                	mov    %eax,%edx
  801f13:	c1 ea 0c             	shr    $0xc,%edx
  801f16:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f1d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801f23:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f27:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f32:	00 
  801f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f3e:	e8 fa f8 ff ff       	call   80183d <sys_page_map>
  801f43:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801f45:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f48:	85 f6                	test   %esi,%esi
  801f4a:	79 22                	jns    801f6e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801f4c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f57:	e8 34 f9 ff ff       	call   801890 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801f5c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f60:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f67:	e8 24 f9 ff ff       	call   801890 <sys_page_unmap>
	return r;
  801f6c:	89 f0                	mov    %esi,%eax
}
  801f6e:	83 c4 3c             	add    $0x3c,%esp
  801f71:	5b                   	pop    %ebx
  801f72:	5e                   	pop    %esi
  801f73:	5f                   	pop    %edi
  801f74:	5d                   	pop    %ebp
  801f75:	c3                   	ret    

00801f76 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	53                   	push   %ebx
  801f7a:	83 ec 24             	sub    $0x24,%esp
  801f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801f80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f87:	89 1c 24             	mov    %ebx,(%esp)
  801f8a:	e8 3c fd ff ff       	call   801ccb <fd_lookup>
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	85 d2                	test   %edx,%edx
  801f93:	78 6d                	js     802002 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801f95:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9f:	8b 00                	mov    (%eax),%eax
  801fa1:	89 04 24             	mov    %eax,(%esp)
  801fa4:	e8 78 fd ff ff       	call   801d21 <dev_lookup>
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	78 55                	js     802002 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb0:	8b 50 08             	mov    0x8(%eax),%edx
  801fb3:	83 e2 03             	and    $0x3,%edx
  801fb6:	83 fa 01             	cmp    $0x1,%edx
  801fb9:	75 23                	jne    801fde <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801fbb:	a1 0c 90 80 00       	mov    0x80900c,%eax
  801fc0:	8b 40 48             	mov    0x48(%eax),%eax
  801fc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcb:	c7 04 24 58 32 80 00 	movl   $0x803258,(%esp)
  801fd2:	e8 0f ed ff ff       	call   800ce6 <cprintf>
		return -E_INVAL;
  801fd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fdc:	eb 24                	jmp    802002 <read+0x8c>
	}
	if (!dev->dev_read)
  801fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe1:	8b 52 08             	mov    0x8(%edx),%edx
  801fe4:	85 d2                	test   %edx,%edx
  801fe6:	74 15                	je     801ffd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801fe8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801feb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ff2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ff6:	89 04 24             	mov    %eax,(%esp)
  801ff9:	ff d2                	call   *%edx
  801ffb:	eb 05                	jmp    802002 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801ffd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  802002:	83 c4 24             	add    $0x24,%esp
  802005:	5b                   	pop    %ebx
  802006:	5d                   	pop    %ebp
  802007:	c3                   	ret    

00802008 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
  80200b:	57                   	push   %edi
  80200c:	56                   	push   %esi
  80200d:	53                   	push   %ebx
  80200e:	83 ec 1c             	sub    $0x1c,%esp
  802011:	8b 7d 08             	mov    0x8(%ebp),%edi
  802014:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802017:	85 f6                	test   %esi,%esi
  802019:	74 33                	je     80204e <readn+0x46>
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
  802020:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  802025:	89 f2                	mov    %esi,%edx
  802027:	29 c2                	sub    %eax,%edx
  802029:	89 54 24 08          	mov    %edx,0x8(%esp)
  80202d:	03 45 0c             	add    0xc(%ebp),%eax
  802030:	89 44 24 04          	mov    %eax,0x4(%esp)
  802034:	89 3c 24             	mov    %edi,(%esp)
  802037:	e8 3a ff ff ff       	call   801f76 <read>
		if (m < 0)
  80203c:	85 c0                	test   %eax,%eax
  80203e:	78 1b                	js     80205b <readn+0x53>
			return m;
		if (m == 0)
  802040:	85 c0                	test   %eax,%eax
  802042:	74 11                	je     802055 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802044:	01 c3                	add    %eax,%ebx
  802046:	89 d8                	mov    %ebx,%eax
  802048:	39 f3                	cmp    %esi,%ebx
  80204a:	72 d9                	jb     802025 <readn+0x1d>
  80204c:	eb 0b                	jmp    802059 <readn+0x51>
  80204e:	b8 00 00 00 00       	mov    $0x0,%eax
  802053:	eb 06                	jmp    80205b <readn+0x53>
  802055:	89 d8                	mov    %ebx,%eax
  802057:	eb 02                	jmp    80205b <readn+0x53>
  802059:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80205b:	83 c4 1c             	add    $0x1c,%esp
  80205e:	5b                   	pop    %ebx
  80205f:	5e                   	pop    %esi
  802060:	5f                   	pop    %edi
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    

00802063 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 24             	sub    $0x24,%esp
  80206a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80206d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	89 1c 24             	mov    %ebx,(%esp)
  802077:	e8 4f fc ff ff       	call   801ccb <fd_lookup>
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	85 d2                	test   %edx,%edx
  802080:	78 68                	js     8020ea <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802082:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802085:	89 44 24 04          	mov    %eax,0x4(%esp)
  802089:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208c:	8b 00                	mov    (%eax),%eax
  80208e:	89 04 24             	mov    %eax,(%esp)
  802091:	e8 8b fc ff ff       	call   801d21 <dev_lookup>
  802096:	85 c0                	test   %eax,%eax
  802098:	78 50                	js     8020ea <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020a1:	75 23                	jne    8020c6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020a3:	a1 0c 90 80 00       	mov    0x80900c,%eax
  8020a8:	8b 40 48             	mov    0x48(%eax),%eax
  8020ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b3:	c7 04 24 74 32 80 00 	movl   $0x803274,(%esp)
  8020ba:	e8 27 ec ff ff       	call   800ce6 <cprintf>
		return -E_INVAL;
  8020bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8020c4:	eb 24                	jmp    8020ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	8b 52 0c             	mov    0xc(%edx),%edx
  8020cc:	85 d2                	test   %edx,%edx
  8020ce:	74 15                	je     8020e5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8020d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8020da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020de:	89 04 24             	mov    %eax,(%esp)
  8020e1:	ff d2                	call   *%edx
  8020e3:	eb 05                	jmp    8020ea <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8020e5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8020ea:	83 c4 24             	add    $0x24,%esp
  8020ed:	5b                   	pop    %ebx
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    

008020f0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8020f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	89 04 24             	mov    %eax,(%esp)
  802103:	e8 c3 fb ff ff       	call   801ccb <fd_lookup>
  802108:	85 c0                	test   %eax,%eax
  80210a:	78 0e                	js     80211a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80210c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802112:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	53                   	push   %ebx
  802120:	83 ec 24             	sub    $0x24,%esp
  802123:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802126:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802129:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212d:	89 1c 24             	mov    %ebx,(%esp)
  802130:	e8 96 fb ff ff       	call   801ccb <fd_lookup>
  802135:	89 c2                	mov    %eax,%edx
  802137:	85 d2                	test   %edx,%edx
  802139:	78 61                	js     80219c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80213b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802145:	8b 00                	mov    (%eax),%eax
  802147:	89 04 24             	mov    %eax,(%esp)
  80214a:	e8 d2 fb ff ff       	call   801d21 <dev_lookup>
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 49                	js     80219c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802153:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802156:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80215a:	75 23                	jne    80217f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80215c:	a1 0c 90 80 00       	mov    0x80900c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802161:	8b 40 48             	mov    0x48(%eax),%eax
  802164:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802168:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216c:	c7 04 24 34 32 80 00 	movl   $0x803234,(%esp)
  802173:	e8 6e eb ff ff       	call   800ce6 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  802178:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80217d:	eb 1d                	jmp    80219c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80217f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802182:	8b 52 18             	mov    0x18(%edx),%edx
  802185:	85 d2                	test   %edx,%edx
  802187:	74 0e                	je     802197 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802189:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80218c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802190:	89 04 24             	mov    %eax,(%esp)
  802193:	ff d2                	call   *%edx
  802195:	eb 05                	jmp    80219c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  802197:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80219c:	83 c4 24             	add    $0x24,%esp
  80219f:	5b                   	pop    %ebx
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    

008021a2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	53                   	push   %ebx
  8021a6:	83 ec 24             	sub    $0x24,%esp
  8021a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 0d fb ff ff       	call   801ccb <fd_lookup>
  8021be:	89 c2                	mov    %eax,%edx
  8021c0:	85 d2                	test   %edx,%edx
  8021c2:	78 52                	js     802216 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	89 04 24             	mov    %eax,(%esp)
  8021d3:	e8 49 fb ff ff       	call   801d21 <dev_lookup>
  8021d8:	85 c0                	test   %eax,%eax
  8021da:	78 3a                	js     802216 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8021dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8021e3:	74 2c                	je     802211 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8021e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8021e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8021ef:	00 00 00 
	stat->st_isdir = 0;
  8021f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021f9:	00 00 00 
	stat->st_dev = dev;
  8021fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802202:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802206:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802209:	89 14 24             	mov    %edx,(%esp)
  80220c:	ff 50 14             	call   *0x14(%eax)
  80220f:	eb 05                	jmp    802216 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  802211:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  802216:	83 c4 24             	add    $0x24,%esp
  802219:	5b                   	pop    %ebx
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    

0080221c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	56                   	push   %esi
  802220:	53                   	push   %ebx
  802221:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802224:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80222b:	00 
  80222c:	8b 45 08             	mov    0x8(%ebp),%eax
  80222f:	89 04 24             	mov    %eax,(%esp)
  802232:	e8 af 01 00 00       	call   8023e6 <open>
  802237:	89 c3                	mov    %eax,%ebx
  802239:	85 db                	test   %ebx,%ebx
  80223b:	78 1b                	js     802258 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  80223d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802240:	89 44 24 04          	mov    %eax,0x4(%esp)
  802244:	89 1c 24             	mov    %ebx,(%esp)
  802247:	e8 56 ff ff ff       	call   8021a2 <fstat>
  80224c:	89 c6                	mov    %eax,%esi
	close(fd);
  80224e:	89 1c 24             	mov    %ebx,(%esp)
  802251:	e8 bd fb ff ff       	call   801e13 <close>
	return r;
  802256:	89 f0                	mov    %esi,%eax
}
  802258:	83 c4 10             	add    $0x10,%esp
  80225b:	5b                   	pop    %ebx
  80225c:	5e                   	pop    %esi
  80225d:	5d                   	pop    %ebp
  80225e:	c3                   	ret    

0080225f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	56                   	push   %esi
  802263:	53                   	push   %ebx
  802264:	83 ec 10             	sub    $0x10,%esp
  802267:	89 c6                	mov    %eax,%esi
  802269:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80226b:	83 3d 00 90 80 00 00 	cmpl   $0x0,0x809000
  802272:	75 11                	jne    802285 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802274:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80227b:	e8 5b f9 ff ff       	call   801bdb <ipc_find_env>
  802280:	a3 00 90 80 00       	mov    %eax,0x809000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802285:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80228c:	00 
  80228d:	c7 44 24 08 00 a0 80 	movl   $0x80a000,0x8(%esp)
  802294:	00 
  802295:	89 74 24 04          	mov    %esi,0x4(%esp)
  802299:	a1 00 90 80 00       	mov    0x809000,%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 cf f8 ff ff       	call   801b75 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8022a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ad:	00 
  8022ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b9:	e8 4d f8 ff ff       	call   801b0b <ipc_recv>
}
  8022be:	83 c4 10             	add    $0x10,%esp
  8022c1:	5b                   	pop    %ebx
  8022c2:	5e                   	pop    %esi
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	53                   	push   %ebx
  8022c9:	83 ec 14             	sub    $0x14,%esp
  8022cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8022d5:	a3 00 a0 80 00       	mov    %eax,0x80a000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8022da:	ba 00 00 00 00       	mov    $0x0,%edx
  8022df:	b8 05 00 00 00       	mov    $0x5,%eax
  8022e4:	e8 76 ff ff ff       	call   80225f <fsipc>
  8022e9:	89 c2                	mov    %eax,%edx
  8022eb:	85 d2                	test   %edx,%edx
  8022ed:	78 2b                	js     80231a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8022ef:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  8022f6:	00 
  8022f7:	89 1c 24             	mov    %ebx,(%esp)
  8022fa:	e8 3c f0 ff ff       	call   80133b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8022ff:	a1 80 a0 80 00       	mov    0x80a080,%eax
  802304:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80230a:	a1 84 a0 80 00       	mov    0x80a084,%eax
  80230f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80231a:	83 c4 14             	add    $0x14,%esp
  80231d:	5b                   	pop    %ebx
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    

00802320 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8b 40 0c             	mov    0xc(%eax),%eax
  80232c:	a3 00 a0 80 00       	mov    %eax,0x80a000
	return fsipc(FSREQ_FLUSH, NULL);
  802331:	ba 00 00 00 00       	mov    $0x0,%edx
  802336:	b8 06 00 00 00       	mov    $0x6,%eax
  80233b:	e8 1f ff ff ff       	call   80225f <fsipc>
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	56                   	push   %esi
  802346:	53                   	push   %ebx
  802347:	83 ec 10             	sub    $0x10,%esp
  80234a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	8b 40 0c             	mov    0xc(%eax),%eax
  802353:	a3 00 a0 80 00       	mov    %eax,0x80a000
	fsipcbuf.read.req_n = n;
  802358:	89 35 04 a0 80 00    	mov    %esi,0x80a004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80235e:	ba 00 00 00 00       	mov    $0x0,%edx
  802363:	b8 03 00 00 00       	mov    $0x3,%eax
  802368:	e8 f2 fe ff ff       	call   80225f <fsipc>
  80236d:	89 c3                	mov    %eax,%ebx
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 6a                	js     8023dd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  802373:	39 c6                	cmp    %eax,%esi
  802375:	73 24                	jae    80239b <devfile_read+0x59>
  802377:	c7 44 24 0c 91 32 80 	movl   $0x803291,0xc(%esp)
  80237e:	00 
  80237f:	c7 44 24 08 fd 2c 80 	movl   $0x802cfd,0x8(%esp)
  802386:	00 
  802387:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  80238e:	00 
  80238f:	c7 04 24 98 32 80 00 	movl   $0x803298,(%esp)
  802396:	e8 52 e8 ff ff       	call   800bed <_panic>
	assert(r <= PGSIZE);
  80239b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8023a0:	7e 24                	jle    8023c6 <devfile_read+0x84>
  8023a2:	c7 44 24 0c a3 32 80 	movl   $0x8032a3,0xc(%esp)
  8023a9:	00 
  8023aa:	c7 44 24 08 fd 2c 80 	movl   $0x802cfd,0x8(%esp)
  8023b1:	00 
  8023b2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  8023b9:	00 
  8023ba:	c7 04 24 98 32 80 00 	movl   $0x803298,(%esp)
  8023c1:	e8 27 e8 ff ff       	call   800bed <_panic>
	memmove(buf, &fsipcbuf, r);
  8023c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ca:	c7 44 24 04 00 a0 80 	movl   $0x80a000,0x4(%esp)
  8023d1:	00 
  8023d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d5:	89 04 24             	mov    %eax,(%esp)
  8023d8:	e8 59 f1 ff ff       	call   801536 <memmove>
	return r;
}
  8023dd:	89 d8                	mov    %ebx,%eax
  8023df:	83 c4 10             	add    $0x10,%esp
  8023e2:	5b                   	pop    %ebx
  8023e3:	5e                   	pop    %esi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    

008023e6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	53                   	push   %ebx
  8023ea:	83 ec 24             	sub    $0x24,%esp
  8023ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8023f0:	89 1c 24             	mov    %ebx,(%esp)
  8023f3:	e8 e8 ee ff ff       	call   8012e0 <strlen>
  8023f8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023fd:	7f 60                	jg     80245f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8023ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802402:	89 04 24             	mov    %eax,(%esp)
  802405:	e8 4d f8 ff ff       	call   801c57 <fd_alloc>
  80240a:	89 c2                	mov    %eax,%edx
  80240c:	85 d2                	test   %edx,%edx
  80240e:	78 54                	js     802464 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  802410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802414:	c7 04 24 00 a0 80 00 	movl   $0x80a000,(%esp)
  80241b:	e8 1b ef ff ff       	call   80133b <strcpy>
	fsipcbuf.open.req_omode = mode;
  802420:	8b 45 0c             	mov    0xc(%ebp),%eax
  802423:	a3 00 a4 80 00       	mov    %eax,0x80a400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	b8 01 00 00 00       	mov    $0x1,%eax
  802430:	e8 2a fe ff ff       	call   80225f <fsipc>
  802435:	89 c3                	mov    %eax,%ebx
  802437:	85 c0                	test   %eax,%eax
  802439:	79 17                	jns    802452 <open+0x6c>
		fd_close(fd, 0);
  80243b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802442:	00 
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 44 f9 ff ff       	call   801d92 <fd_close>
		return r;
  80244e:	89 d8                	mov    %ebx,%eax
  802450:	eb 12                	jmp    802464 <open+0x7e>
	}

	return fd2num(fd);
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 d3 f7 ff ff       	call   801c30 <fd2num>
  80245d:	eb 05                	jmp    802464 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80245f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  802464:	83 c4 24             	add    $0x24,%esp
  802467:	5b                   	pop    %ebx
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    

0080246a <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802470:	89 d0                	mov    %edx,%eax
  802472:	c1 e8 16             	shr    $0x16,%eax
  802475:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802481:	f6 c1 01             	test   $0x1,%cl
  802484:	74 1d                	je     8024a3 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802486:	c1 ea 0c             	shr    $0xc,%edx
  802489:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802490:	f6 c2 01             	test   $0x1,%dl
  802493:	74 0e                	je     8024a3 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802495:	c1 ea 0c             	shr    $0xc,%edx
  802498:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80249f:	ef 
  8024a0:	0f b7 c0             	movzwl %ax,%eax
}
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	66 90                	xchg   %ax,%ax
  8024a7:	66 90                	xchg   %ax,%ax
  8024a9:	66 90                	xchg   %ax,%ax
  8024ab:	66 90                	xchg   %ax,%ax
  8024ad:	66 90                	xchg   %ax,%ax
  8024af:	90                   	nop

008024b0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	56                   	push   %esi
  8024b4:	53                   	push   %ebx
  8024b5:	83 ec 10             	sub    $0x10,%esp
  8024b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	89 04 24             	mov    %eax,(%esp)
  8024c1:	e8 7a f7 ff ff       	call   801c40 <fd2data>
  8024c6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8024c8:	c7 44 24 04 af 32 80 	movl   $0x8032af,0x4(%esp)
  8024cf:	00 
  8024d0:	89 1c 24             	mov    %ebx,(%esp)
  8024d3:	e8 63 ee ff ff       	call   80133b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8024d8:	8b 46 04             	mov    0x4(%esi),%eax
  8024db:	2b 06                	sub    (%esi),%eax
  8024dd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8024e3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8024ea:	00 00 00 
	stat->st_dev = &devpipe;
  8024ed:	c7 83 88 00 00 00 60 	movl   $0x808060,0x88(%ebx)
  8024f4:	80 80 00 
	return 0;
}
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5d                   	pop    %ebp
  802502:	c3                   	ret    

00802503 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802503:	55                   	push   %ebp
  802504:	89 e5                	mov    %esp,%ebp
  802506:	53                   	push   %ebx
  802507:	83 ec 14             	sub    $0x14,%esp
  80250a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80250d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802511:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802518:	e8 73 f3 ff ff       	call   801890 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80251d:	89 1c 24             	mov    %ebx,(%esp)
  802520:	e8 1b f7 ff ff       	call   801c40 <fd2data>
  802525:	89 44 24 04          	mov    %eax,0x4(%esp)
  802529:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802530:	e8 5b f3 ff ff       	call   801890 <sys_page_unmap>
}
  802535:	83 c4 14             	add    $0x14,%esp
  802538:	5b                   	pop    %ebx
  802539:	5d                   	pop    %ebp
  80253a:	c3                   	ret    

0080253b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	57                   	push   %edi
  80253f:	56                   	push   %esi
  802540:	53                   	push   %ebx
  802541:	83 ec 2c             	sub    $0x2c,%esp
  802544:	89 c6                	mov    %eax,%esi
  802546:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802549:	a1 0c 90 80 00       	mov    0x80900c,%eax
  80254e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802551:	89 34 24             	mov    %esi,(%esp)
  802554:	e8 11 ff ff ff       	call   80246a <pageref>
  802559:	89 c7                	mov    %eax,%edi
  80255b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255e:	89 04 24             	mov    %eax,(%esp)
  802561:	e8 04 ff ff ff       	call   80246a <pageref>
  802566:	39 c7                	cmp    %eax,%edi
  802568:	0f 94 c2             	sete   %dl
  80256b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  80256e:	8b 0d 0c 90 80 00    	mov    0x80900c,%ecx
  802574:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  802577:	39 fb                	cmp    %edi,%ebx
  802579:	74 21                	je     80259c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  80257b:	84 d2                	test   %dl,%dl
  80257d:	74 ca                	je     802549 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80257f:	8b 51 58             	mov    0x58(%ecx),%edx
  802582:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802586:	89 54 24 08          	mov    %edx,0x8(%esp)
  80258a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80258e:	c7 04 24 b6 32 80 00 	movl   $0x8032b6,(%esp)
  802595:	e8 4c e7 ff ff       	call   800ce6 <cprintf>
  80259a:	eb ad                	jmp    802549 <_pipeisclosed+0xe>
	}
}
  80259c:	83 c4 2c             	add    $0x2c,%esp
  80259f:	5b                   	pop    %ebx
  8025a0:	5e                   	pop    %esi
  8025a1:	5f                   	pop    %edi
  8025a2:	5d                   	pop    %ebp
  8025a3:	c3                   	ret    

008025a4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025a4:	55                   	push   %ebp
  8025a5:	89 e5                	mov    %esp,%ebp
  8025a7:	57                   	push   %edi
  8025a8:	56                   	push   %esi
  8025a9:	53                   	push   %ebx
  8025aa:	83 ec 1c             	sub    $0x1c,%esp
  8025ad:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8025b0:	89 34 24             	mov    %esi,(%esp)
  8025b3:	e8 88 f6 ff ff       	call   801c40 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025bc:	74 61                	je     80261f <devpipe_write+0x7b>
  8025be:	89 c3                	mov    %eax,%ebx
  8025c0:	bf 00 00 00 00       	mov    $0x0,%edi
  8025c5:	eb 4a                	jmp    802611 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8025c7:	89 da                	mov    %ebx,%edx
  8025c9:	89 f0                	mov    %esi,%eax
  8025cb:	e8 6b ff ff ff       	call   80253b <_pipeisclosed>
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	75 54                	jne    802628 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8025d4:	e8 f1 f1 ff ff       	call   8017ca <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025d9:	8b 43 04             	mov    0x4(%ebx),%eax
  8025dc:	8b 0b                	mov    (%ebx),%ecx
  8025de:	8d 51 20             	lea    0x20(%ecx),%edx
  8025e1:	39 d0                	cmp    %edx,%eax
  8025e3:	73 e2                	jae    8025c7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8025e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025e8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8025ec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8025ef:	99                   	cltd   
  8025f0:	c1 ea 1b             	shr    $0x1b,%edx
  8025f3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8025f6:	83 e1 1f             	and    $0x1f,%ecx
  8025f9:	29 d1                	sub    %edx,%ecx
  8025fb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8025ff:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802603:	83 c0 01             	add    $0x1,%eax
  802606:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802609:	83 c7 01             	add    $0x1,%edi
  80260c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80260f:	74 13                	je     802624 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802611:	8b 43 04             	mov    0x4(%ebx),%eax
  802614:	8b 0b                	mov    (%ebx),%ecx
  802616:	8d 51 20             	lea    0x20(%ecx),%edx
  802619:	39 d0                	cmp    %edx,%eax
  80261b:	73 aa                	jae    8025c7 <devpipe_write+0x23>
  80261d:	eb c6                	jmp    8025e5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80261f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802624:	89 f8                	mov    %edi,%eax
  802626:	eb 05                	jmp    80262d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802628:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80262d:	83 c4 1c             	add    $0x1c,%esp
  802630:	5b                   	pop    %ebx
  802631:	5e                   	pop    %esi
  802632:	5f                   	pop    %edi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    

00802635 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	57                   	push   %edi
  802639:	56                   	push   %esi
  80263a:	53                   	push   %ebx
  80263b:	83 ec 1c             	sub    $0x1c,%esp
  80263e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802641:	89 3c 24             	mov    %edi,(%esp)
  802644:	e8 f7 f5 ff ff       	call   801c40 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802649:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80264d:	74 54                	je     8026a3 <devpipe_read+0x6e>
  80264f:	89 c3                	mov    %eax,%ebx
  802651:	be 00 00 00 00       	mov    $0x0,%esi
  802656:	eb 3e                	jmp    802696 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802658:	89 f0                	mov    %esi,%eax
  80265a:	eb 55                	jmp    8026b1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80265c:	89 da                	mov    %ebx,%edx
  80265e:	89 f8                	mov    %edi,%eax
  802660:	e8 d6 fe ff ff       	call   80253b <_pipeisclosed>
  802665:	85 c0                	test   %eax,%eax
  802667:	75 43                	jne    8026ac <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802669:	e8 5c f1 ff ff       	call   8017ca <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80266e:	8b 03                	mov    (%ebx),%eax
  802670:	3b 43 04             	cmp    0x4(%ebx),%eax
  802673:	74 e7                	je     80265c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802675:	99                   	cltd   
  802676:	c1 ea 1b             	shr    $0x1b,%edx
  802679:	01 d0                	add    %edx,%eax
  80267b:	83 e0 1f             	and    $0x1f,%eax
  80267e:	29 d0                	sub    %edx,%eax
  802680:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802685:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802688:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  80268b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80268e:	83 c6 01             	add    $0x1,%esi
  802691:	3b 75 10             	cmp    0x10(%ebp),%esi
  802694:	74 12                	je     8026a8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  802696:	8b 03                	mov    (%ebx),%eax
  802698:	3b 43 04             	cmp    0x4(%ebx),%eax
  80269b:	75 d8                	jne    802675 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  80269d:	85 f6                	test   %esi,%esi
  80269f:	75 b7                	jne    802658 <devpipe_read+0x23>
  8026a1:	eb b9                	jmp    80265c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026a3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8026a8:	89 f0                	mov    %esi,%eax
  8026aa:	eb 05                	jmp    8026b1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8026ac:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8026b1:	83 c4 1c             	add    $0x1c,%esp
  8026b4:	5b                   	pop    %ebx
  8026b5:	5e                   	pop    %esi
  8026b6:	5f                   	pop    %edi
  8026b7:	5d                   	pop    %ebp
  8026b8:	c3                   	ret    

008026b9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026b9:	55                   	push   %ebp
  8026ba:	89 e5                	mov    %esp,%ebp
  8026bc:	56                   	push   %esi
  8026bd:	53                   	push   %ebx
  8026be:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026c4:	89 04 24             	mov    %eax,(%esp)
  8026c7:	e8 8b f5 ff ff       	call   801c57 <fd_alloc>
  8026cc:	89 c2                	mov    %eax,%edx
  8026ce:	85 d2                	test   %edx,%edx
  8026d0:	0f 88 4d 01 00 00    	js     802823 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026dd:	00 
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026ec:	e8 f8 f0 ff ff       	call   8017e9 <sys_page_alloc>
  8026f1:	89 c2                	mov    %eax,%edx
  8026f3:	85 d2                	test   %edx,%edx
  8026f5:	0f 88 28 01 00 00    	js     802823 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8026fe:	89 04 24             	mov    %eax,(%esp)
  802701:	e8 51 f5 ff ff       	call   801c57 <fd_alloc>
  802706:	89 c3                	mov    %eax,%ebx
  802708:	85 c0                	test   %eax,%eax
  80270a:	0f 88 fe 00 00 00    	js     80280e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802710:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802717:	00 
  802718:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802726:	e8 be f0 ff ff       	call   8017e9 <sys_page_alloc>
  80272b:	89 c3                	mov    %eax,%ebx
  80272d:	85 c0                	test   %eax,%eax
  80272f:	0f 88 d9 00 00 00    	js     80280e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	89 04 24             	mov    %eax,(%esp)
  80273b:	e8 00 f5 ff ff       	call   801c40 <fd2data>
  802740:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802742:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802749:	00 
  80274a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80274e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802755:	e8 8f f0 ff ff       	call   8017e9 <sys_page_alloc>
  80275a:	89 c3                	mov    %eax,%ebx
  80275c:	85 c0                	test   %eax,%eax
  80275e:	0f 88 97 00 00 00    	js     8027fb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	89 04 24             	mov    %eax,(%esp)
  80276a:	e8 d1 f4 ff ff       	call   801c40 <fd2data>
  80276f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802776:	00 
  802777:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80277b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802782:	00 
  802783:	89 74 24 04          	mov    %esi,0x4(%esp)
  802787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80278e:	e8 aa f0 ff ff       	call   80183d <sys_page_map>
  802793:	89 c3                	mov    %eax,%ebx
  802795:	85 c0                	test   %eax,%eax
  802797:	78 52                	js     8027eb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802799:	8b 15 60 80 80 00    	mov    0x808060,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8027ae:	8b 15 60 80 80 00    	mov    0x808060,%edx
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	89 04 24             	mov    %eax,(%esp)
  8027c9:	e8 62 f4 ff ff       	call   801c30 <fd2num>
  8027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027d1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8027d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d6:	89 04 24             	mov    %eax,(%esp)
  8027d9:	e8 52 f4 ff ff       	call   801c30 <fd2num>
  8027de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8027e1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8027e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e9:	eb 38                	jmp    802823 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8027eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f6:	e8 95 f0 ff ff       	call   801890 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802802:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802809:	e8 82 f0 ff ff       	call   801890 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	89 44 24 04          	mov    %eax,0x4(%esp)
  802815:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80281c:	e8 6f f0 ff ff       	call   801890 <sys_page_unmap>
  802821:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802823:	83 c4 30             	add    $0x30,%esp
  802826:	5b                   	pop    %ebx
  802827:	5e                   	pop    %esi
  802828:	5d                   	pop    %ebp
  802829:	c3                   	ret    

0080282a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802830:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802833:	89 44 24 04          	mov    %eax,0x4(%esp)
  802837:	8b 45 08             	mov    0x8(%ebp),%eax
  80283a:	89 04 24             	mov    %eax,(%esp)
  80283d:	e8 89 f4 ff ff       	call   801ccb <fd_lookup>
  802842:	89 c2                	mov    %eax,%edx
  802844:	85 d2                	test   %edx,%edx
  802846:	78 15                	js     80285d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	89 04 24             	mov    %eax,(%esp)
  80284e:	e8 ed f3 ff ff       	call   801c40 <fd2data>
	return _pipeisclosed(fd, p);
  802853:	89 c2                	mov    %eax,%edx
  802855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802858:	e8 de fc ff ff       	call   80253b <_pipeisclosed>
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    
  80285f:	90                   	nop

00802860 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802863:	b8 00 00 00 00       	mov    $0x0,%eax
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    

0080286a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802870:	c7 44 24 04 ce 32 80 	movl   $0x8032ce,0x4(%esp)
  802877:	00 
  802878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287b:	89 04 24             	mov    %eax,(%esp)
  80287e:	e8 b8 ea ff ff       	call   80133b <strcpy>
	return 0;
}
  802883:	b8 00 00 00 00       	mov    $0x0,%eax
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	57                   	push   %edi
  80288e:	56                   	push   %esi
  80288f:	53                   	push   %ebx
  802890:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802896:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80289a:	74 4a                	je     8028e6 <devcons_write+0x5c>
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028ac:	8b 75 10             	mov    0x10(%ebp),%esi
  8028af:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8028b1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8028b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8028b9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8028bc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8028c0:	03 45 0c             	add    0xc(%ebp),%eax
  8028c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c7:	89 3c 24             	mov    %edi,(%esp)
  8028ca:	e8 67 ec ff ff       	call   801536 <memmove>
		sys_cputs(buf, m);
  8028cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028d3:	89 3c 24             	mov    %edi,(%esp)
  8028d6:	e8 41 ee ff ff       	call   80171c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028db:	01 f3                	add    %esi,%ebx
  8028dd:	89 d8                	mov    %ebx,%eax
  8028df:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8028e2:	72 c8                	jb     8028ac <devcons_write+0x22>
  8028e4:	eb 05                	jmp    8028eb <devcons_write+0x61>
  8028e6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028eb:	89 d8                	mov    %ebx,%eax
  8028ed:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028f3:	5b                   	pop    %ebx
  8028f4:	5e                   	pop    %esi
  8028f5:	5f                   	pop    %edi
  8028f6:	5d                   	pop    %ebp
  8028f7:	c3                   	ret    

008028f8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028f8:	55                   	push   %ebp
  8028f9:	89 e5                	mov    %esp,%ebp
  8028fb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802903:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802907:	75 07                	jne    802910 <devcons_read+0x18>
  802909:	eb 28                	jmp    802933 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80290b:	e8 ba ee ff ff       	call   8017ca <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802910:	e8 25 ee ff ff       	call   80173a <sys_cgetc>
  802915:	85 c0                	test   %eax,%eax
  802917:	74 f2                	je     80290b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802919:	85 c0                	test   %eax,%eax
  80291b:	78 16                	js     802933 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80291d:	83 f8 04             	cmp    $0x4,%eax
  802920:	74 0c                	je     80292e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802922:	8b 55 0c             	mov    0xc(%ebp),%edx
  802925:	88 02                	mov    %al,(%edx)
	return 1;
  802927:	b8 01 00 00 00       	mov    $0x1,%eax
  80292c:	eb 05                	jmp    802933 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80292e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802933:	c9                   	leave  
  802934:	c3                   	ret    

00802935 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802935:	55                   	push   %ebp
  802936:	89 e5                	mov    %esp,%ebp
  802938:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802941:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802948:	00 
  802949:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80294c:	89 04 24             	mov    %eax,(%esp)
  80294f:	e8 c8 ed ff ff       	call   80171c <sys_cputs>
}
  802954:	c9                   	leave  
  802955:	c3                   	ret    

00802956 <getchar>:

int
getchar(void)
{
  802956:	55                   	push   %ebp
  802957:	89 e5                	mov    %esp,%ebp
  802959:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80295c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802963:	00 
  802964:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802972:	e8 ff f5 ff ff       	call   801f76 <read>
	if (r < 0)
  802977:	85 c0                	test   %eax,%eax
  802979:	78 0f                	js     80298a <getchar+0x34>
		return r;
	if (r < 1)
  80297b:	85 c0                	test   %eax,%eax
  80297d:	7e 06                	jle    802985 <getchar+0x2f>
		return -E_EOF;
	return c;
  80297f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802983:	eb 05                	jmp    80298a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802985:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80298a:	c9                   	leave  
  80298b:	c3                   	ret    

0080298c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802992:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802995:	89 44 24 04          	mov    %eax,0x4(%esp)
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	89 04 24             	mov    %eax,(%esp)
  80299f:	e8 27 f3 ff ff       	call   801ccb <fd_lookup>
  8029a4:	85 c0                	test   %eax,%eax
  8029a6:	78 11                	js     8029b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  8029b1:	39 10                	cmp    %edx,(%eax)
  8029b3:	0f 94 c0             	sete   %al
  8029b6:	0f b6 c0             	movzbl %al,%eax
}
  8029b9:	c9                   	leave  
  8029ba:	c3                   	ret    

008029bb <opencons>:

int
opencons(void)
{
  8029bb:	55                   	push   %ebp
  8029bc:	89 e5                	mov    %esp,%ebp
  8029be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029c4:	89 04 24             	mov    %eax,(%esp)
  8029c7:	e8 8b f2 ff ff       	call   801c57 <fd_alloc>
		return r;
  8029cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	78 40                	js     802a12 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029d9:	00 
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029e8:	e8 fc ed ff ff       	call   8017e9 <sys_page_alloc>
		return r;
  8029ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	78 1f                	js     802a12 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8029f3:	8b 15 7c 80 80 00    	mov    0x80807c,%edx
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a08:	89 04 24             	mov    %eax,(%esp)
  802a0b:	e8 20 f2 ff ff       	call   801c30 <fd2num>
  802a10:	89 c2                	mov    %eax,%edx
}
  802a12:	89 d0                	mov    %edx,%eax
  802a14:	c9                   	leave  
  802a15:	c3                   	ret    
  802a16:	66 90                	xchg   %ax,%ax
  802a18:	66 90                	xchg   %ax,%ax
  802a1a:	66 90                	xchg   %ax,%ax
  802a1c:	66 90                	xchg   %ax,%ax
  802a1e:	66 90                	xchg   %ax,%ax

00802a20 <__udivdi3>:
  802a20:	55                   	push   %ebp
  802a21:	57                   	push   %edi
  802a22:	56                   	push   %esi
  802a23:	83 ec 0c             	sub    $0xc,%esp
  802a26:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a2a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a2e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a32:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a36:	85 c0                	test   %eax,%eax
  802a38:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a3c:	89 ea                	mov    %ebp,%edx
  802a3e:	89 0c 24             	mov    %ecx,(%esp)
  802a41:	75 2d                	jne    802a70 <__udivdi3+0x50>
  802a43:	39 e9                	cmp    %ebp,%ecx
  802a45:	77 61                	ja     802aa8 <__udivdi3+0x88>
  802a47:	85 c9                	test   %ecx,%ecx
  802a49:	89 ce                	mov    %ecx,%esi
  802a4b:	75 0b                	jne    802a58 <__udivdi3+0x38>
  802a4d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a52:	31 d2                	xor    %edx,%edx
  802a54:	f7 f1                	div    %ecx
  802a56:	89 c6                	mov    %eax,%esi
  802a58:	31 d2                	xor    %edx,%edx
  802a5a:	89 e8                	mov    %ebp,%eax
  802a5c:	f7 f6                	div    %esi
  802a5e:	89 c5                	mov    %eax,%ebp
  802a60:	89 f8                	mov    %edi,%eax
  802a62:	f7 f6                	div    %esi
  802a64:	89 ea                	mov    %ebp,%edx
  802a66:	83 c4 0c             	add    $0xc,%esp
  802a69:	5e                   	pop    %esi
  802a6a:	5f                   	pop    %edi
  802a6b:	5d                   	pop    %ebp
  802a6c:	c3                   	ret    
  802a6d:	8d 76 00             	lea    0x0(%esi),%esi
  802a70:	39 e8                	cmp    %ebp,%eax
  802a72:	77 24                	ja     802a98 <__udivdi3+0x78>
  802a74:	0f bd e8             	bsr    %eax,%ebp
  802a77:	83 f5 1f             	xor    $0x1f,%ebp
  802a7a:	75 3c                	jne    802ab8 <__udivdi3+0x98>
  802a7c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a80:	39 34 24             	cmp    %esi,(%esp)
  802a83:	0f 86 9f 00 00 00    	jbe    802b28 <__udivdi3+0x108>
  802a89:	39 d0                	cmp    %edx,%eax
  802a8b:	0f 82 97 00 00 00    	jb     802b28 <__udivdi3+0x108>
  802a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a98:	31 d2                	xor    %edx,%edx
  802a9a:	31 c0                	xor    %eax,%eax
  802a9c:	83 c4 0c             	add    $0xc,%esp
  802a9f:	5e                   	pop    %esi
  802aa0:	5f                   	pop    %edi
  802aa1:	5d                   	pop    %ebp
  802aa2:	c3                   	ret    
  802aa3:	90                   	nop
  802aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa8:	89 f8                	mov    %edi,%eax
  802aaa:	f7 f1                	div    %ecx
  802aac:	31 d2                	xor    %edx,%edx
  802aae:	83 c4 0c             	add    $0xc,%esp
  802ab1:	5e                   	pop    %esi
  802ab2:	5f                   	pop    %edi
  802ab3:	5d                   	pop    %ebp
  802ab4:	c3                   	ret    
  802ab5:	8d 76 00             	lea    0x0(%esi),%esi
  802ab8:	89 e9                	mov    %ebp,%ecx
  802aba:	8b 3c 24             	mov    (%esp),%edi
  802abd:	d3 e0                	shl    %cl,%eax
  802abf:	89 c6                	mov    %eax,%esi
  802ac1:	b8 20 00 00 00       	mov    $0x20,%eax
  802ac6:	29 e8                	sub    %ebp,%eax
  802ac8:	89 c1                	mov    %eax,%ecx
  802aca:	d3 ef                	shr    %cl,%edi
  802acc:	89 e9                	mov    %ebp,%ecx
  802ace:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ad2:	8b 3c 24             	mov    (%esp),%edi
  802ad5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ad9:	89 d6                	mov    %edx,%esi
  802adb:	d3 e7                	shl    %cl,%edi
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	89 3c 24             	mov    %edi,(%esp)
  802ae2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ae6:	d3 ee                	shr    %cl,%esi
  802ae8:	89 e9                	mov    %ebp,%ecx
  802aea:	d3 e2                	shl    %cl,%edx
  802aec:	89 c1                	mov    %eax,%ecx
  802aee:	d3 ef                	shr    %cl,%edi
  802af0:	09 d7                	or     %edx,%edi
  802af2:	89 f2                	mov    %esi,%edx
  802af4:	89 f8                	mov    %edi,%eax
  802af6:	f7 74 24 08          	divl   0x8(%esp)
  802afa:	89 d6                	mov    %edx,%esi
  802afc:	89 c7                	mov    %eax,%edi
  802afe:	f7 24 24             	mull   (%esp)
  802b01:	39 d6                	cmp    %edx,%esi
  802b03:	89 14 24             	mov    %edx,(%esp)
  802b06:	72 30                	jb     802b38 <__udivdi3+0x118>
  802b08:	8b 54 24 04          	mov    0x4(%esp),%edx
  802b0c:	89 e9                	mov    %ebp,%ecx
  802b0e:	d3 e2                	shl    %cl,%edx
  802b10:	39 c2                	cmp    %eax,%edx
  802b12:	73 05                	jae    802b19 <__udivdi3+0xf9>
  802b14:	3b 34 24             	cmp    (%esp),%esi
  802b17:	74 1f                	je     802b38 <__udivdi3+0x118>
  802b19:	89 f8                	mov    %edi,%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	e9 7a ff ff ff       	jmp    802a9c <__udivdi3+0x7c>
  802b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b28:	31 d2                	xor    %edx,%edx
  802b2a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b2f:	e9 68 ff ff ff       	jmp    802a9c <__udivdi3+0x7c>
  802b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b38:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b3b:	31 d2                	xor    %edx,%edx
  802b3d:	83 c4 0c             	add    $0xc,%esp
  802b40:	5e                   	pop    %esi
  802b41:	5f                   	pop    %edi
  802b42:	5d                   	pop    %ebp
  802b43:	c3                   	ret    
  802b44:	66 90                	xchg   %ax,%ax
  802b46:	66 90                	xchg   %ax,%ax
  802b48:	66 90                	xchg   %ax,%ax
  802b4a:	66 90                	xchg   %ax,%ax
  802b4c:	66 90                	xchg   %ax,%ax
  802b4e:	66 90                	xchg   %ax,%ax

00802b50 <__umoddi3>:
  802b50:	55                   	push   %ebp
  802b51:	57                   	push   %edi
  802b52:	56                   	push   %esi
  802b53:	83 ec 14             	sub    $0x14,%esp
  802b56:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b5a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b5e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b62:	89 c7                	mov    %eax,%edi
  802b64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b68:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b6c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b70:	89 34 24             	mov    %esi,(%esp)
  802b73:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b77:	85 c0                	test   %eax,%eax
  802b79:	89 c2                	mov    %eax,%edx
  802b7b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b7f:	75 17                	jne    802b98 <__umoddi3+0x48>
  802b81:	39 fe                	cmp    %edi,%esi
  802b83:	76 4b                	jbe    802bd0 <__umoddi3+0x80>
  802b85:	89 c8                	mov    %ecx,%eax
  802b87:	89 fa                	mov    %edi,%edx
  802b89:	f7 f6                	div    %esi
  802b8b:	89 d0                	mov    %edx,%eax
  802b8d:	31 d2                	xor    %edx,%edx
  802b8f:	83 c4 14             	add    $0x14,%esp
  802b92:	5e                   	pop    %esi
  802b93:	5f                   	pop    %edi
  802b94:	5d                   	pop    %ebp
  802b95:	c3                   	ret    
  802b96:	66 90                	xchg   %ax,%ax
  802b98:	39 f8                	cmp    %edi,%eax
  802b9a:	77 54                	ja     802bf0 <__umoddi3+0xa0>
  802b9c:	0f bd e8             	bsr    %eax,%ebp
  802b9f:	83 f5 1f             	xor    $0x1f,%ebp
  802ba2:	75 5c                	jne    802c00 <__umoddi3+0xb0>
  802ba4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802ba8:	39 3c 24             	cmp    %edi,(%esp)
  802bab:	0f 87 e7 00 00 00    	ja     802c98 <__umoddi3+0x148>
  802bb1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802bb5:	29 f1                	sub    %esi,%ecx
  802bb7:	19 c7                	sbb    %eax,%edi
  802bb9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802bbd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802bc1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802bc5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802bc9:	83 c4 14             	add    $0x14,%esp
  802bcc:	5e                   	pop    %esi
  802bcd:	5f                   	pop    %edi
  802bce:	5d                   	pop    %ebp
  802bcf:	c3                   	ret    
  802bd0:	85 f6                	test   %esi,%esi
  802bd2:	89 f5                	mov    %esi,%ebp
  802bd4:	75 0b                	jne    802be1 <__umoddi3+0x91>
  802bd6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bdb:	31 d2                	xor    %edx,%edx
  802bdd:	f7 f6                	div    %esi
  802bdf:	89 c5                	mov    %eax,%ebp
  802be1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802be5:	31 d2                	xor    %edx,%edx
  802be7:	f7 f5                	div    %ebp
  802be9:	89 c8                	mov    %ecx,%eax
  802beb:	f7 f5                	div    %ebp
  802bed:	eb 9c                	jmp    802b8b <__umoddi3+0x3b>
  802bef:	90                   	nop
  802bf0:	89 c8                	mov    %ecx,%eax
  802bf2:	89 fa                	mov    %edi,%edx
  802bf4:	83 c4 14             	add    $0x14,%esp
  802bf7:	5e                   	pop    %esi
  802bf8:	5f                   	pop    %edi
  802bf9:	5d                   	pop    %ebp
  802bfa:	c3                   	ret    
  802bfb:	90                   	nop
  802bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c00:	8b 04 24             	mov    (%esp),%eax
  802c03:	be 20 00 00 00       	mov    $0x20,%esi
  802c08:	89 e9                	mov    %ebp,%ecx
  802c0a:	29 ee                	sub    %ebp,%esi
  802c0c:	d3 e2                	shl    %cl,%edx
  802c0e:	89 f1                	mov    %esi,%ecx
  802c10:	d3 e8                	shr    %cl,%eax
  802c12:	89 e9                	mov    %ebp,%ecx
  802c14:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c18:	8b 04 24             	mov    (%esp),%eax
  802c1b:	09 54 24 04          	or     %edx,0x4(%esp)
  802c1f:	89 fa                	mov    %edi,%edx
  802c21:	d3 e0                	shl    %cl,%eax
  802c23:	89 f1                	mov    %esi,%ecx
  802c25:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c29:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c2d:	d3 ea                	shr    %cl,%edx
  802c2f:	89 e9                	mov    %ebp,%ecx
  802c31:	d3 e7                	shl    %cl,%edi
  802c33:	89 f1                	mov    %esi,%ecx
  802c35:	d3 e8                	shr    %cl,%eax
  802c37:	89 e9                	mov    %ebp,%ecx
  802c39:	09 f8                	or     %edi,%eax
  802c3b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c3f:	f7 74 24 04          	divl   0x4(%esp)
  802c43:	d3 e7                	shl    %cl,%edi
  802c45:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c49:	89 d7                	mov    %edx,%edi
  802c4b:	f7 64 24 08          	mull   0x8(%esp)
  802c4f:	39 d7                	cmp    %edx,%edi
  802c51:	89 c1                	mov    %eax,%ecx
  802c53:	89 14 24             	mov    %edx,(%esp)
  802c56:	72 2c                	jb     802c84 <__umoddi3+0x134>
  802c58:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c5c:	72 22                	jb     802c80 <__umoddi3+0x130>
  802c5e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c62:	29 c8                	sub    %ecx,%eax
  802c64:	19 d7                	sbb    %edx,%edi
  802c66:	89 e9                	mov    %ebp,%ecx
  802c68:	89 fa                	mov    %edi,%edx
  802c6a:	d3 e8                	shr    %cl,%eax
  802c6c:	89 f1                	mov    %esi,%ecx
  802c6e:	d3 e2                	shl    %cl,%edx
  802c70:	89 e9                	mov    %ebp,%ecx
  802c72:	d3 ef                	shr    %cl,%edi
  802c74:	09 d0                	or     %edx,%eax
  802c76:	89 fa                	mov    %edi,%edx
  802c78:	83 c4 14             	add    $0x14,%esp
  802c7b:	5e                   	pop    %esi
  802c7c:	5f                   	pop    %edi
  802c7d:	5d                   	pop    %ebp
  802c7e:	c3                   	ret    
  802c7f:	90                   	nop
  802c80:	39 d7                	cmp    %edx,%edi
  802c82:	75 da                	jne    802c5e <__umoddi3+0x10e>
  802c84:	8b 14 24             	mov    (%esp),%edx
  802c87:	89 c1                	mov    %eax,%ecx
  802c89:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c8d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c91:	eb cb                	jmp    802c5e <__umoddi3+0x10e>
  802c93:	90                   	nop
  802c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c98:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c9c:	0f 82 0f ff ff ff    	jb     802bb1 <__umoddi3+0x61>
  802ca2:	e9 1a ff ff ff       	jmp    802bc1 <__umoddi3+0x71>
