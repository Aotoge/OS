
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 64 05 00 00       	call   800595 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	8b 45 08             	mov    0x8(%ebp),%eax
  800043:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800047:	89 54 24 08          	mov    %edx,0x8(%esp)
  80004b:	c7 44 24 04 11 27 80 	movl   $0x802711,0x4(%esp)
  800052:	00 
  800053:	c7 04 24 e0 26 80 00 	movl   $0x8026e0,(%esp)
  80005a:	e8 c0 06 00 00       	call   80071f <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  80005f:	8b 03                	mov    (%ebx),%eax
  800061:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800065:	8b 06                	mov    (%esi),%eax
  800067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80006b:	c7 44 24 04 f0 26 80 	movl   $0x8026f0,0x4(%esp)
  800072:	00 
  800073:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  80007a:	e8 a0 06 00 00       	call   80071f <cprintf>
  80007f:	8b 03                	mov    (%ebx),%eax
  800081:	39 06                	cmp    %eax,(%esi)
  800083:	75 13                	jne    800098 <check_regs+0x65>
  800085:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  80008c:	e8 8e 06 00 00       	call   80071f <cprintf>

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
	int mismatch = 0;
  800091:	bf 00 00 00 00       	mov    $0x0,%edi
  800096:	eb 11                	jmp    8000a9 <check_regs+0x76>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800098:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  80009f:	e8 7b 06 00 00       	call   80071f <cprintf>
  8000a4:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  8000a9:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	8b 46 04             	mov    0x4(%esi),%eax
  8000b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000b7:	c7 44 24 04 12 27 80 	movl   $0x802712,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  8000c6:	e8 54 06 00 00       	call   80071f <cprintf>
  8000cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8000ce:	39 46 04             	cmp    %eax,0x4(%esi)
  8000d1:	75 0e                	jne    8000e1 <check_regs+0xae>
  8000d3:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  8000da:	e8 40 06 00 00       	call   80071f <cprintf>
  8000df:	eb 11                	jmp    8000f2 <check_regs+0xbf>
  8000e1:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  8000e8:	e8 32 06 00 00       	call   80071f <cprintf>
  8000ed:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000f2:	8b 43 08             	mov    0x8(%ebx),%eax
  8000f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f9:	8b 46 08             	mov    0x8(%esi),%eax
  8000fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800100:	c7 44 24 04 16 27 80 	movl   $0x802716,0x4(%esp)
  800107:	00 
  800108:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  80010f:	e8 0b 06 00 00       	call   80071f <cprintf>
  800114:	8b 43 08             	mov    0x8(%ebx),%eax
  800117:	39 46 08             	cmp    %eax,0x8(%esi)
  80011a:	75 0e                	jne    80012a <check_regs+0xf7>
  80011c:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800123:	e8 f7 05 00 00       	call   80071f <cprintf>
  800128:	eb 11                	jmp    80013b <check_regs+0x108>
  80012a:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  800131:	e8 e9 05 00 00       	call   80071f <cprintf>
  800136:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  80013b:	8b 43 10             	mov    0x10(%ebx),%eax
  80013e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800142:	8b 46 10             	mov    0x10(%esi),%eax
  800145:	89 44 24 08          	mov    %eax,0x8(%esp)
  800149:	c7 44 24 04 1a 27 80 	movl   $0x80271a,0x4(%esp)
  800150:	00 
  800151:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  800158:	e8 c2 05 00 00       	call   80071f <cprintf>
  80015d:	8b 43 10             	mov    0x10(%ebx),%eax
  800160:	39 46 10             	cmp    %eax,0x10(%esi)
  800163:	75 0e                	jne    800173 <check_regs+0x140>
  800165:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  80016c:	e8 ae 05 00 00       	call   80071f <cprintf>
  800171:	eb 11                	jmp    800184 <check_regs+0x151>
  800173:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  80017a:	e8 a0 05 00 00       	call   80071f <cprintf>
  80017f:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800184:	8b 43 14             	mov    0x14(%ebx),%eax
  800187:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018b:	8b 46 14             	mov    0x14(%esi),%eax
  80018e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800192:	c7 44 24 04 1e 27 80 	movl   $0x80271e,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  8001a1:	e8 79 05 00 00       	call   80071f <cprintf>
  8001a6:	8b 43 14             	mov    0x14(%ebx),%eax
  8001a9:	39 46 14             	cmp    %eax,0x14(%esi)
  8001ac:	75 0e                	jne    8001bc <check_regs+0x189>
  8001ae:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  8001b5:	e8 65 05 00 00       	call   80071f <cprintf>
  8001ba:	eb 11                	jmp    8001cd <check_regs+0x19a>
  8001bc:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  8001c3:	e8 57 05 00 00       	call   80071f <cprintf>
  8001c8:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  8001cd:	8b 43 18             	mov    0x18(%ebx),%eax
  8001d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d4:	8b 46 18             	mov    0x18(%esi),%eax
  8001d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001db:	c7 44 24 04 22 27 80 	movl   $0x802722,0x4(%esp)
  8001e2:	00 
  8001e3:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  8001ea:	e8 30 05 00 00       	call   80071f <cprintf>
  8001ef:	8b 43 18             	mov    0x18(%ebx),%eax
  8001f2:	39 46 18             	cmp    %eax,0x18(%esi)
  8001f5:	75 0e                	jne    800205 <check_regs+0x1d2>
  8001f7:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  8001fe:	e8 1c 05 00 00       	call   80071f <cprintf>
  800203:	eb 11                	jmp    800216 <check_regs+0x1e3>
  800205:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  80020c:	e8 0e 05 00 00       	call   80071f <cprintf>
  800211:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  800216:	8b 43 1c             	mov    0x1c(%ebx),%eax
  800219:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80021d:	8b 46 1c             	mov    0x1c(%esi),%eax
  800220:	89 44 24 08          	mov    %eax,0x8(%esp)
  800224:	c7 44 24 04 26 27 80 	movl   $0x802726,0x4(%esp)
  80022b:	00 
  80022c:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  800233:	e8 e7 04 00 00       	call   80071f <cprintf>
  800238:	8b 43 1c             	mov    0x1c(%ebx),%eax
  80023b:	39 46 1c             	cmp    %eax,0x1c(%esi)
  80023e:	75 0e                	jne    80024e <check_regs+0x21b>
  800240:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800247:	e8 d3 04 00 00       	call   80071f <cprintf>
  80024c:	eb 11                	jmp    80025f <check_regs+0x22c>
  80024e:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  800255:	e8 c5 04 00 00       	call   80071f <cprintf>
  80025a:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  80025f:	8b 43 20             	mov    0x20(%ebx),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 46 20             	mov    0x20(%esi),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	c7 44 24 04 2a 27 80 	movl   $0x80272a,0x4(%esp)
  800274:	00 
  800275:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  80027c:	e8 9e 04 00 00       	call   80071f <cprintf>
  800281:	8b 43 20             	mov    0x20(%ebx),%eax
  800284:	39 46 20             	cmp    %eax,0x20(%esi)
  800287:	75 0e                	jne    800297 <check_regs+0x264>
  800289:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800290:	e8 8a 04 00 00       	call   80071f <cprintf>
  800295:	eb 11                	jmp    8002a8 <check_regs+0x275>
  800297:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  80029e:	e8 7c 04 00 00       	call   80071f <cprintf>
  8002a3:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  8002a8:	8b 43 24             	mov    0x24(%ebx),%eax
  8002ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002af:	8b 46 24             	mov    0x24(%esi),%eax
  8002b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b6:	c7 44 24 04 2e 27 80 	movl   $0x80272e,0x4(%esp)
  8002bd:	00 
  8002be:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  8002c5:	e8 55 04 00 00       	call   80071f <cprintf>
  8002ca:	8b 43 24             	mov    0x24(%ebx),%eax
  8002cd:	39 46 24             	cmp    %eax,0x24(%esi)
  8002d0:	75 0e                	jne    8002e0 <check_regs+0x2ad>
  8002d2:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  8002d9:	e8 41 04 00 00       	call   80071f <cprintf>
  8002de:	eb 11                	jmp    8002f1 <check_regs+0x2be>
  8002e0:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  8002e7:	e8 33 04 00 00       	call   80071f <cprintf>
  8002ec:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esp, esp);
  8002f1:	8b 43 28             	mov    0x28(%ebx),%eax
  8002f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f8:	8b 46 28             	mov    0x28(%esi),%eax
  8002fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ff:	c7 44 24 04 35 27 80 	movl   $0x802735,0x4(%esp)
  800306:	00 
  800307:	c7 04 24 f4 26 80 00 	movl   $0x8026f4,(%esp)
  80030e:	e8 0c 04 00 00       	call   80071f <cprintf>
  800313:	8b 43 28             	mov    0x28(%ebx),%eax
  800316:	39 46 28             	cmp    %eax,0x28(%esi)
  800319:	75 25                	jne    800340 <check_regs+0x30d>
  80031b:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800322:	e8 f8 03 00 00       	call   80071f <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032e:	c7 04 24 39 27 80 00 	movl   $0x802739,(%esp)
  800335:	e8 e5 03 00 00       	call   80071f <cprintf>
	if (!mismatch)
  80033a:	85 ff                	test   %edi,%edi
  80033c:	74 23                	je     800361 <check_regs+0x32e>
  80033e:	eb 2f                	jmp    80036f <check_regs+0x33c>
	CHECK(edx, regs.reg_edx);
	CHECK(ecx, regs.reg_ecx);
	CHECK(eax, regs.reg_eax);
	CHECK(eip, eip);
	CHECK(eflags, eflags);
	CHECK(esp, esp);
  800340:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  800347:	e8 d3 03 00 00       	call   80071f <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 39 27 80 00 	movl   $0x802739,(%esp)
  80035a:	e8 c0 03 00 00       	call   80071f <cprintf>
  80035f:	eb 0e                	jmp    80036f <check_regs+0x33c>
	if (!mismatch)
		cprintf("OK\n");
  800361:	c7 04 24 04 27 80 00 	movl   $0x802704,(%esp)
  800368:	e8 b2 03 00 00       	call   80071f <cprintf>
  80036d:	eb 0c                	jmp    80037b <check_regs+0x348>
	else
		cprintf("MISMATCH\n");
  80036f:	c7 04 24 08 27 80 00 	movl   $0x802708,(%esp)
  800376:	e8 a4 03 00 00       	call   80071f <cprintf>
}
  80037b:	83 c4 1c             	add    $0x1c,%esp
  80037e:	5b                   	pop    %ebx
  80037f:	5e                   	pop    %esi
  800380:	5f                   	pop    %edi
  800381:	5d                   	pop    %ebp
  800382:	c3                   	ret    

00800383 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  800383:	55                   	push   %ebp
  800384:	89 e5                	mov    %esp,%ebp
  800386:	83 ec 28             	sub    $0x28,%esp
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  80038c:	8b 10                	mov    (%eax),%edx
  80038e:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  800394:	74 27                	je     8003bd <pgfault+0x3a>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800396:	8b 40 28             	mov    0x28(%eax),%eax
  800399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003a1:	c7 44 24 08 a0 27 80 	movl   $0x8027a0,0x8(%esp)
  8003a8:	00 
  8003a9:	c7 44 24 04 51 00 00 	movl   $0x51,0x4(%esp)
  8003b0:	00 
  8003b1:	c7 04 24 47 27 80 00 	movl   $0x802747,(%esp)
  8003b8:	e8 69 02 00 00       	call   800626 <_panic>
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003bd:	8b 50 08             	mov    0x8(%eax),%edx
  8003c0:	89 15 40 40 80 00    	mov    %edx,0x804040
  8003c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8003c9:	89 15 44 40 80 00    	mov    %edx,0x804044
  8003cf:	8b 50 10             	mov    0x10(%eax),%edx
  8003d2:	89 15 48 40 80 00    	mov    %edx,0x804048
  8003d8:	8b 50 14             	mov    0x14(%eax),%edx
  8003db:	89 15 4c 40 80 00    	mov    %edx,0x80404c
  8003e1:	8b 50 18             	mov    0x18(%eax),%edx
  8003e4:	89 15 50 40 80 00    	mov    %edx,0x804050
  8003ea:	8b 50 1c             	mov    0x1c(%eax),%edx
  8003ed:	89 15 54 40 80 00    	mov    %edx,0x804054
  8003f3:	8b 50 20             	mov    0x20(%eax),%edx
  8003f6:	89 15 58 40 80 00    	mov    %edx,0x804058
  8003fc:	8b 50 24             	mov    0x24(%eax),%edx
  8003ff:	89 15 5c 40 80 00    	mov    %edx,0x80405c
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  800417:	8b 40 30             	mov    0x30(%eax),%eax
  80041a:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  80041f:	c7 44 24 04 5f 27 80 	movl   $0x80275f,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 6d 27 80 00 	movl   $0x80276d,(%esp)
  80042e:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800433:	ba 58 27 80 00       	mov    $0x802758,%edx
  800438:	b8 80 40 80 00       	mov    $0x804080,%eax
  80043d:	e8 f1 fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800442:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800449:	00 
  80044a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  800451:	00 
  800452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800459:	e8 cb 0d 00 00       	call   801229 <sys_page_alloc>
  80045e:	85 c0                	test   %eax,%eax
  800460:	79 20                	jns    800482 <pgfault+0xff>
		panic("sys_page_alloc: %e", r);
  800462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800466:	c7 44 24 08 74 27 80 	movl   $0x802774,0x8(%esp)
  80046d:	00 
  80046e:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800475:	00 
  800476:	c7 04 24 47 27 80 00 	movl   $0x802747,(%esp)
  80047d:	e8 a4 01 00 00       	call   800626 <_panic>
}
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <umain>:

void
umain(int argc, char **argv)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(pgfault);
  80048a:	c7 04 24 83 03 80 00 	movl   $0x800383,(%esp)
  800491:	e8 fb 0f 00 00       	call   801491 <set_pgfault_handler>

	__asm __volatile(
  800496:	50                   	push   %eax
  800497:	9c                   	pushf  
  800498:	58                   	pop    %eax
  800499:	0d d5 08 00 00       	or     $0x8d5,%eax
  80049e:	50                   	push   %eax
  80049f:	9d                   	popf   
  8004a0:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004a5:	8d 05 e0 04 80 00    	lea    0x8004e0,%eax
  8004ab:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004b0:	58                   	pop    %eax
  8004b1:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004b7:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004bd:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  8004c3:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  8004c9:	89 15 94 40 80 00    	mov    %edx,0x804094
  8004cf:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  8004d5:	a3 9c 40 80 00       	mov    %eax,0x80409c
  8004da:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  8004e0:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004e7:	00 00 00 
  8004ea:	89 3d 00 40 80 00    	mov    %edi,0x804000
  8004f0:	89 35 04 40 80 00    	mov    %esi,0x804004
  8004f6:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  8004fc:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  800502:	89 15 14 40 80 00    	mov    %edx,0x804014
  800508:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  80050e:	a3 1c 40 80 00       	mov    %eax,0x80401c
  800513:	89 25 28 40 80 00    	mov    %esp,0x804028
  800519:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  80051f:	8b 35 84 40 80 00    	mov    0x804084,%esi
  800525:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  80052b:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  800531:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800537:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  80053d:	a1 9c 40 80 00       	mov    0x80409c,%eax
  800542:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  800548:	50                   	push   %eax
  800549:	9c                   	pushf  
  80054a:	58                   	pop    %eax
  80054b:	a3 24 40 80 00       	mov    %eax,0x804024
  800550:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  800551:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800558:	74 0c                	je     800566 <umain+0xe2>
		cprintf("EIP after page-fault MISMATCH\n");
  80055a:	c7 04 24 d4 27 80 00 	movl   $0x8027d4,(%esp)
  800561:	e8 b9 01 00 00       	call   80071f <cprintf>
	after.eip = before.eip;
  800566:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  80056b:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800570:	c7 44 24 04 87 27 80 	movl   $0x802787,0x4(%esp)
  800577:	00 
  800578:	c7 04 24 98 27 80 00 	movl   $0x802798,(%esp)
  80057f:	b9 00 40 80 00       	mov    $0x804000,%ecx
  800584:	ba 58 27 80 00       	mov    $0x802758,%edx
  800589:	b8 80 40 80 00       	mov    $0x804080,%eax
  80058e:	e8 a0 fa ff ff       	call   800033 <check_regs>
}
  800593:	c9                   	leave  
  800594:	c3                   	ret    

00800595 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800595:	55                   	push   %ebp
  800596:	89 e5                	mov    %esp,%ebp
  800598:	56                   	push   %esi
  800599:	53                   	push   %ebx
  80059a:	83 ec 10             	sub    $0x10,%esp
  80059d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005a0:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  8005a3:	e8 43 0c 00 00       	call   8011eb <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  8005a8:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  8005ae:	39 c2                	cmp    %eax,%edx
  8005b0:	74 17                	je     8005c9 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8005b2:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  8005b7:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  8005ba:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8005c0:	8b 49 40             	mov    0x40(%ecx),%ecx
  8005c3:	39 c1                	cmp    %eax,%ecx
  8005c5:	75 18                	jne    8005df <libmain+0x4a>
  8005c7:	eb 05                	jmp    8005ce <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8005ce:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8005d1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8005d7:	89 15 b0 40 80 00    	mov    %edx,0x8040b0
			break;
  8005dd:	eb 0b                	jmp    8005ea <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8005df:	83 c2 01             	add    $0x1,%edx
  8005e2:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8005e8:	75 cd                	jne    8005b7 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ea:	85 db                	test   %ebx,%ebx
  8005ec:	7e 07                	jle    8005f5 <libmain+0x60>
		binaryname = argv[0];
  8005ee:	8b 06                	mov    (%esi),%eax
  8005f0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8005f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005f9:	89 1c 24             	mov    %ebx,(%esp)
  8005fc:	e8 83 fe ff ff       	call   800484 <umain>

	// exit gracefully
	exit();
  800601:	e8 07 00 00 00       	call   80060d <exit>
}
  800606:	83 c4 10             	add    $0x10,%esp
  800609:	5b                   	pop    %ebx
  80060a:	5e                   	pop    %esi
  80060b:	5d                   	pop    %ebp
  80060c:	c3                   	ret    

0080060d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80060d:	55                   	push   %ebp
  80060e:	89 e5                	mov    %esp,%ebp
  800610:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800613:	e8 4e 11 00 00       	call   801766 <close_all>
	sys_env_destroy(0);
  800618:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80061f:	e8 75 0b 00 00       	call   801199 <sys_env_destroy>
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	56                   	push   %esi
  80062a:	53                   	push   %ebx
  80062b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80062e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800631:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800637:	e8 af 0b 00 00       	call   8011eb <sys_getenvid>
  80063c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80063f:	89 54 24 10          	mov    %edx,0x10(%esp)
  800643:	8b 55 08             	mov    0x8(%ebp),%edx
  800646:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80064a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80064e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800652:	c7 04 24 00 28 80 00 	movl   $0x802800,(%esp)
  800659:	e8 c1 00 00 00       	call   80071f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80065e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800662:	8b 45 10             	mov    0x10(%ebp),%eax
  800665:	89 04 24             	mov    %eax,(%esp)
  800668:	e8 51 00 00 00       	call   8006be <vcprintf>
	cprintf("\n");
  80066d:	c7 04 24 10 27 80 00 	movl   $0x802710,(%esp)
  800674:	e8 a6 00 00 00       	call   80071f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800679:	cc                   	int3   
  80067a:	eb fd                	jmp    800679 <_panic+0x53>

0080067c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	53                   	push   %ebx
  800680:	83 ec 14             	sub    $0x14,%esp
  800683:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800686:	8b 13                	mov    (%ebx),%edx
  800688:	8d 42 01             	lea    0x1(%edx),%eax
  80068b:	89 03                	mov    %eax,(%ebx)
  80068d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800690:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800694:	3d ff 00 00 00       	cmp    $0xff,%eax
  800699:	75 19                	jne    8006b4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80069b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8006a2:	00 
  8006a3:	8d 43 08             	lea    0x8(%ebx),%eax
  8006a6:	89 04 24             	mov    %eax,(%esp)
  8006a9:	e8 ae 0a 00 00       	call   80115c <sys_cputs>
		b->idx = 0;
  8006ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8006b4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8006b8:	83 c4 14             	add    $0x14,%esp
  8006bb:	5b                   	pop    %ebx
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006ce:	00 00 00 
	b.cnt = 0;
  8006d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f3:	c7 04 24 7c 06 80 00 	movl   $0x80067c,(%esp)
  8006fa:	e8 b5 01 00 00       	call   8008b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800705:	89 44 24 04          	mov    %eax,0x4(%esp)
  800709:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80070f:	89 04 24             	mov    %eax,(%esp)
  800712:	e8 45 0a 00 00       	call   80115c <sys_cputs>

	return b.cnt;
}
  800717:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800725:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800728:	89 44 24 04          	mov    %eax,0x4(%esp)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	e8 87 ff ff ff       	call   8006be <vcprintf>
	va_end(ap);

	return cnt;
}
  800737:	c9                   	leave  
  800738:	c3                   	ret    
  800739:	66 90                	xchg   %ax,%ax
  80073b:	66 90                	xchg   %ax,%ax
  80073d:	66 90                	xchg   %ax,%ax
  80073f:	90                   	nop

00800740 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	57                   	push   %edi
  800744:	56                   	push   %esi
  800745:	53                   	push   %ebx
  800746:	83 ec 3c             	sub    $0x3c,%esp
  800749:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074c:	89 d7                	mov    %edx,%edi
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800754:	8b 75 0c             	mov    0xc(%ebp),%esi
  800757:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80075a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80075d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800762:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800765:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800768:	39 f1                	cmp    %esi,%ecx
  80076a:	72 14                	jb     800780 <printnum+0x40>
  80076c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80076f:	76 0f                	jbe    800780 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8d 70 ff             	lea    -0x1(%eax),%esi
  800777:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80077a:	85 f6                	test   %esi,%esi
  80077c:	7f 60                	jg     8007de <printnum+0x9e>
  80077e:	eb 72                	jmp    8007f2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800780:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800783:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  800787:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80078a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80078d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800791:	89 44 24 08          	mov    %eax,0x8(%esp)
  800795:	8b 44 24 08          	mov    0x8(%esp),%eax
  800799:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80079d:	89 c3                	mov    %eax,%ebx
  80079f:	89 d6                	mov    %edx,%esi
  8007a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8007a7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8007ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007b2:	89 04 24             	mov    %eax,(%esp)
  8007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bc:	e8 8f 1c 00 00       	call   802450 <__udivdi3>
  8007c1:	89 d9                	mov    %ebx,%ecx
  8007c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007c7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007cb:	89 04 24             	mov    %eax,(%esp)
  8007ce:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007d2:	89 fa                	mov    %edi,%edx
  8007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d7:	e8 64 ff ff ff       	call   800740 <printnum>
  8007dc:	eb 14                	jmp    8007f2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007de:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e2:	8b 45 18             	mov    0x18(%ebp),%eax
  8007e5:	89 04 24             	mov    %eax,(%esp)
  8007e8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007ea:	83 ee 01             	sub    $0x1,%esi
  8007ed:	75 ef                	jne    8007de <printnum+0x9e>
  8007ef:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8007fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800800:	89 44 24 08          	mov    %eax,0x8(%esp)
  800804:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800808:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80080b:	89 04 24             	mov    %eax,(%esp)
  80080e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800811:	89 44 24 04          	mov    %eax,0x4(%esp)
  800815:	e8 66 1d 00 00       	call   802580 <__umoddi3>
  80081a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80081e:	0f be 80 23 28 80 00 	movsbl 0x802823(%eax),%eax
  800825:	89 04 24             	mov    %eax,(%esp)
  800828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80082b:	ff d0                	call   *%eax
}
  80082d:	83 c4 3c             	add    $0x3c,%esp
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5f                   	pop    %edi
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800838:	83 fa 01             	cmp    $0x1,%edx
  80083b:	7e 0e                	jle    80084b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80083d:	8b 10                	mov    (%eax),%edx
  80083f:	8d 4a 08             	lea    0x8(%edx),%ecx
  800842:	89 08                	mov    %ecx,(%eax)
  800844:	8b 02                	mov    (%edx),%eax
  800846:	8b 52 04             	mov    0x4(%edx),%edx
  800849:	eb 22                	jmp    80086d <getuint+0x38>
	else if (lflag)
  80084b:	85 d2                	test   %edx,%edx
  80084d:	74 10                	je     80085f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80084f:	8b 10                	mov    (%eax),%edx
  800851:	8d 4a 04             	lea    0x4(%edx),%ecx
  800854:	89 08                	mov    %ecx,(%eax)
  800856:	8b 02                	mov    (%edx),%eax
  800858:	ba 00 00 00 00       	mov    $0x0,%edx
  80085d:	eb 0e                	jmp    80086d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80085f:	8b 10                	mov    (%eax),%edx
  800861:	8d 4a 04             	lea    0x4(%edx),%ecx
  800864:	89 08                	mov    %ecx,(%eax)
  800866:	8b 02                	mov    (%edx),%eax
  800868:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80086d:	5d                   	pop    %ebp
  80086e:	c3                   	ret    

0080086f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
  800872:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800875:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800879:	8b 10                	mov    (%eax),%edx
  80087b:	3b 50 04             	cmp    0x4(%eax),%edx
  80087e:	73 0a                	jae    80088a <sprintputch+0x1b>
		*b->buf++ = ch;
  800880:	8d 4a 01             	lea    0x1(%edx),%ecx
  800883:	89 08                	mov    %ecx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	88 02                	mov    %al,(%edx)
}
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800892:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800895:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800899:	8b 45 10             	mov    0x10(%ebp),%eax
  80089c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	89 04 24             	mov    %eax,(%esp)
  8008ad:	e8 02 00 00 00       	call   8008b4 <vprintfmt>
	va_end(ap);
}
  8008b2:	c9                   	leave  
  8008b3:	c3                   	ret    

008008b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	57                   	push   %edi
  8008b8:	56                   	push   %esi
  8008b9:	53                   	push   %ebx
  8008ba:	83 ec 3c             	sub    $0x3c,%esp
  8008bd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008c3:	eb 18                	jmp    8008dd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8008c5:	85 c0                	test   %eax,%eax
  8008c7:	0f 84 c3 03 00 00    	je     800c90 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8008cd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008d1:	89 04 24             	mov    %eax,(%esp)
  8008d4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008d7:	89 f3                	mov    %esi,%ebx
  8008d9:	eb 02                	jmp    8008dd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008db:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008dd:	8d 73 01             	lea    0x1(%ebx),%esi
  8008e0:	0f b6 03             	movzbl (%ebx),%eax
  8008e3:	83 f8 25             	cmp    $0x25,%eax
  8008e6:	75 dd                	jne    8008c5 <vprintfmt+0x11>
  8008e8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8008ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8008f3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8008fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	eb 1d                	jmp    800925 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800908:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80090a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80090e:	eb 15                	jmp    800925 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800910:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800912:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  800916:	eb 0d                	jmp    800925 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  800918:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80091e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800925:	8d 5e 01             	lea    0x1(%esi),%ebx
  800928:	0f b6 06             	movzbl (%esi),%eax
  80092b:	0f b6 c8             	movzbl %al,%ecx
  80092e:	83 e8 23             	sub    $0x23,%eax
  800931:	3c 55                	cmp    $0x55,%al
  800933:	0f 87 2f 03 00 00    	ja     800c68 <vprintfmt+0x3b4>
  800939:	0f b6 c0             	movzbl %al,%eax
  80093c:	ff 24 85 60 29 80 00 	jmp    *0x802960(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800943:	8d 41 d0             	lea    -0x30(%ecx),%eax
  800946:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  800949:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80094d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  800950:	83 f9 09             	cmp    $0x9,%ecx
  800953:	77 50                	ja     8009a5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800955:	89 de                	mov    %ebx,%esi
  800957:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80095d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800960:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800964:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  800967:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80096a:	83 fb 09             	cmp    $0x9,%ebx
  80096d:	76 eb                	jbe    80095a <vprintfmt+0xa6>
  80096f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800972:	eb 33                	jmp    8009a7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	8d 48 04             	lea    0x4(%eax),%ecx
  80097a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80097d:	8b 00                	mov    (%eax),%eax
  80097f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800982:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800984:	eb 21                	jmp    8009a7 <vprintfmt+0xf3>
  800986:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800989:	85 c9                	test   %ecx,%ecx
  80098b:	b8 00 00 00 00       	mov    $0x0,%eax
  800990:	0f 49 c1             	cmovns %ecx,%eax
  800993:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800996:	89 de                	mov    %ebx,%esi
  800998:	eb 8b                	jmp    800925 <vprintfmt+0x71>
  80099a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80099c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8009a3:	eb 80                	jmp    800925 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009a5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	0f 89 74 ff ff ff    	jns    800925 <vprintfmt+0x71>
  8009b1:	e9 62 ff ff ff       	jmp    800918 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009b6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8009bb:	e9 65 ff ff ff       	jmp    800925 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8009c9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 04 24             	mov    %eax,(%esp)
  8009d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009d5:	e9 03 ff ff ff       	jmp    8008dd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009da:	8b 45 14             	mov    0x14(%ebp),%eax
  8009dd:	8d 50 04             	lea    0x4(%eax),%edx
  8009e0:	89 55 14             	mov    %edx,0x14(%ebp)
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	99                   	cltd   
  8009e6:	31 d0                	xor    %edx,%eax
  8009e8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009ea:	83 f8 0f             	cmp    $0xf,%eax
  8009ed:	7f 0b                	jg     8009fa <vprintfmt+0x146>
  8009ef:	8b 14 85 c0 2a 80 00 	mov    0x802ac0(,%eax,4),%edx
  8009f6:	85 d2                	test   %edx,%edx
  8009f8:	75 20                	jne    800a1a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8009fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009fe:	c7 44 24 08 3b 28 80 	movl   $0x80283b,0x8(%esp)
  800a05:	00 
  800a06:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	89 04 24             	mov    %eax,(%esp)
  800a10:	e8 77 fe ff ff       	call   80088c <printfmt>
  800a15:	e9 c3 fe ff ff       	jmp    8008dd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  800a1a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a1e:	c7 44 24 08 16 2c 80 	movl   $0x802c16,0x8(%esp)
  800a25:	00 
  800a26:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	89 04 24             	mov    %eax,(%esp)
  800a30:	e8 57 fe ff ff       	call   80088c <printfmt>
  800a35:	e9 a3 fe ff ff       	jmp    8008dd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a3a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800a3d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 50 04             	lea    0x4(%eax),%edx
  800a46:	89 55 14             	mov    %edx,0x14(%ebp)
  800a49:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  800a4b:	85 c0                	test   %eax,%eax
  800a4d:	ba 34 28 80 00       	mov    $0x802834,%edx
  800a52:	0f 45 d0             	cmovne %eax,%edx
  800a55:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  800a58:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  800a5c:	74 04                	je     800a62 <vprintfmt+0x1ae>
  800a5e:	85 f6                	test   %esi,%esi
  800a60:	7f 19                	jg     800a7b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a62:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a65:	8d 70 01             	lea    0x1(%eax),%esi
  800a68:	0f b6 10             	movzbl (%eax),%edx
  800a6b:	0f be c2             	movsbl %dl,%eax
  800a6e:	85 c0                	test   %eax,%eax
  800a70:	0f 85 95 00 00 00    	jne    800b0b <vprintfmt+0x257>
  800a76:	e9 85 00 00 00       	jmp    800b00 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a7b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a7f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a82:	89 04 24             	mov    %eax,(%esp)
  800a85:	e8 b8 02 00 00       	call   800d42 <strnlen>
  800a8a:	29 c6                	sub    %eax,%esi
  800a8c:	89 f0                	mov    %esi,%eax
  800a8e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800a91:	85 f6                	test   %esi,%esi
  800a93:	7e cd                	jle    800a62 <vprintfmt+0x1ae>
					putch(padc, putdat);
  800a95:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800a99:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800a9c:	89 c3                	mov    %eax,%ebx
  800a9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa2:	89 34 24             	mov    %esi,(%esp)
  800aa5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800aa8:	83 eb 01             	sub    $0x1,%ebx
  800aab:	75 f1                	jne    800a9e <vprintfmt+0x1ea>
  800aad:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800ab0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ab3:	eb ad                	jmp    800a62 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ab5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ab9:	74 1e                	je     800ad9 <vprintfmt+0x225>
  800abb:	0f be d2             	movsbl %dl,%edx
  800abe:	83 ea 20             	sub    $0x20,%edx
  800ac1:	83 fa 5e             	cmp    $0x5e,%edx
  800ac4:	76 13                	jbe    800ad9 <vprintfmt+0x225>
					putch('?', putdat);
  800ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ad4:	ff 55 08             	call   *0x8(%ebp)
  800ad7:	eb 0d                	jmp    800ae6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  800ad9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800adc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800ae0:	89 04 24             	mov    %eax,(%esp)
  800ae3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae6:	83 ef 01             	sub    $0x1,%edi
  800ae9:	83 c6 01             	add    $0x1,%esi
  800aec:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  800af0:	0f be c2             	movsbl %dl,%eax
  800af3:	85 c0                	test   %eax,%eax
  800af5:	75 20                	jne    800b17 <vprintfmt+0x263>
  800af7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800afa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800afd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b04:	7f 25                	jg     800b2b <vprintfmt+0x277>
  800b06:	e9 d2 fd ff ff       	jmp    8008dd <vprintfmt+0x29>
  800b0b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  800b0e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800b11:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b14:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b17:	85 db                	test   %ebx,%ebx
  800b19:	78 9a                	js     800ab5 <vprintfmt+0x201>
  800b1b:	83 eb 01             	sub    $0x1,%ebx
  800b1e:	79 95                	jns    800ab5 <vprintfmt+0x201>
  800b20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  800b23:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b26:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b29:	eb d5                	jmp    800b00 <vprintfmt+0x24c>
  800b2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800b2e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b31:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800b34:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b38:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b3f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b41:	83 eb 01             	sub    $0x1,%ebx
  800b44:	75 ee                	jne    800b34 <vprintfmt+0x280>
  800b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b49:	e9 8f fd ff ff       	jmp    8008dd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b4e:	83 fa 01             	cmp    $0x1,%edx
  800b51:	7e 16                	jle    800b69 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	89 55 14             	mov    %edx,0x14(%ebp)
  800b5c:	8b 50 04             	mov    0x4(%eax),%edx
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b64:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b67:	eb 32                	jmp    800b9b <vprintfmt+0x2e7>
	else if (lflag)
  800b69:	85 d2                	test   %edx,%edx
  800b6b:	74 18                	je     800b85 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	8d 50 04             	lea    0x4(%eax),%edx
  800b73:	89 55 14             	mov    %edx,0x14(%ebp)
  800b76:	8b 30                	mov    (%eax),%esi
  800b78:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b7b:	89 f0                	mov    %esi,%eax
  800b7d:	c1 f8 1f             	sar    $0x1f,%eax
  800b80:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b83:	eb 16                	jmp    800b9b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  800b85:	8b 45 14             	mov    0x14(%ebp),%eax
  800b88:	8d 50 04             	lea    0x4(%eax),%edx
  800b8b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b8e:	8b 30                	mov    (%eax),%esi
  800b90:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b93:	89 f0                	mov    %esi,%eax
  800b95:	c1 f8 1f             	sar    $0x1f,%eax
  800b98:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800ba1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800ba6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800baa:	0f 89 80 00 00 00    	jns    800c30 <vprintfmt+0x37c>
				putch('-', putdat);
  800bb0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bb4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800bbb:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800bbe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800bc4:	f7 d8                	neg    %eax
  800bc6:	83 d2 00             	adc    $0x0,%edx
  800bc9:	f7 da                	neg    %edx
			}
			base = 10;
  800bcb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800bd0:	eb 5e                	jmp    800c30 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	e8 5b fc ff ff       	call   800835 <getuint>
			base = 10;
  800bda:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800bdf:	eb 4f                	jmp    800c30 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  800be1:	8d 45 14             	lea    0x14(%ebp),%eax
  800be4:	e8 4c fc ff ff       	call   800835 <getuint>
			base = 8;
  800be9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800bee:	eb 40                	jmp    800c30 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  800bf0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bf4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800bfb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800bfe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c02:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800c09:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  800c0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0f:	8d 50 04             	lea    0x4(%eax),%edx
  800c12:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  800c1c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800c21:	eb 0d                	jmp    800c30 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c23:	8d 45 14             	lea    0x14(%ebp),%eax
  800c26:	e8 0a fc ff ff       	call   800835 <getuint>
			base = 16;
  800c2b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c30:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  800c34:	89 74 24 10          	mov    %esi,0x10(%esp)
  800c38:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  800c3b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800c3f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c43:	89 04 24             	mov    %eax,(%esp)
  800c46:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c4a:	89 fa                	mov    %edi,%edx
  800c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4f:	e8 ec fa ff ff       	call   800740 <printnum>
			break;
  800c54:	e9 84 fc ff ff       	jmp    8008dd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c59:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c5d:	89 0c 24             	mov    %ecx,(%esp)
  800c60:	ff 55 08             	call   *0x8(%ebp)
			break;
  800c63:	e9 75 fc ff ff       	jmp    8008dd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c6c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c73:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c76:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  800c7a:	0f 84 5b fc ff ff    	je     8008db <vprintfmt+0x27>
  800c80:	89 f3                	mov    %esi,%ebx
  800c82:	83 eb 01             	sub    $0x1,%ebx
  800c85:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800c89:	75 f7                	jne    800c82 <vprintfmt+0x3ce>
  800c8b:	e9 4d fc ff ff       	jmp    8008dd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  800c90:	83 c4 3c             	add    $0x3c,%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
  800c9b:	83 ec 28             	sub    $0x28,%esp
  800c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ca4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800cab:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800cae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	74 30                	je     800ce9 <vsnprintf+0x51>
  800cb9:	85 d2                	test   %edx,%edx
  800cbb:	7e 2c                	jle    800ce9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ccb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd2:	c7 04 24 6f 08 80 00 	movl   $0x80086f,(%esp)
  800cd9:	e8 d6 fb ff ff       	call   8008b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ce7:	eb 05                	jmp    800cee <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800ce9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800cee:	c9                   	leave  
  800cef:	c3                   	ret    

00800cf0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cf6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800cf9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800cfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800d00:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0e:	89 04 24             	mov    %eax,(%esp)
  800d11:	e8 82 ff ff ff       	call   800c98 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d16:	c9                   	leave  
  800d17:	c3                   	ret    
  800d18:	66 90                	xchg   %ax,%ax
  800d1a:	66 90                	xchg   %ax,%ax
  800d1c:	66 90                	xchg   %ax,%ax
  800d1e:	66 90                	xchg   %ax,%ax

00800d20 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d20:	55                   	push   %ebp
  800d21:	89 e5                	mov    %esp,%ebp
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d26:	80 3a 00             	cmpb   $0x0,(%edx)
  800d29:	74 10                	je     800d3b <strlen+0x1b>
  800d2b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800d30:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d33:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d37:	75 f7                	jne    800d30 <strlen+0x10>
  800d39:	eb 05                	jmp    800d40 <strlen+0x20>
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	53                   	push   %ebx
  800d46:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d4c:	85 c9                	test   %ecx,%ecx
  800d4e:	74 1c                	je     800d6c <strnlen+0x2a>
  800d50:	80 3b 00             	cmpb   $0x0,(%ebx)
  800d53:	74 1e                	je     800d73 <strnlen+0x31>
  800d55:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  800d5a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5c:	39 ca                	cmp    %ecx,%edx
  800d5e:	74 18                	je     800d78 <strnlen+0x36>
  800d60:	83 c2 01             	add    $0x1,%edx
  800d63:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  800d68:	75 f0                	jne    800d5a <strnlen+0x18>
  800d6a:	eb 0c                	jmp    800d78 <strnlen+0x36>
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d71:	eb 05                	jmp    800d78 <strnlen+0x36>
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800d78:	5b                   	pop    %ebx
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	53                   	push   %ebx
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d85:	89 c2                	mov    %eax,%edx
  800d87:	83 c2 01             	add    $0x1,%edx
  800d8a:	83 c1 01             	add    $0x1,%ecx
  800d8d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800d91:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d94:	84 db                	test   %bl,%bl
  800d96:	75 ef                	jne    800d87 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d98:	5b                   	pop    %ebx
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 08             	sub    $0x8,%esp
  800da2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800da5:	89 1c 24             	mov    %ebx,(%esp)
  800da8:	e8 73 ff ff ff       	call   800d20 <strlen>
	strcpy(dst + len, src);
  800dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800db4:	01 d8                	add    %ebx,%eax
  800db6:	89 04 24             	mov    %eax,(%esp)
  800db9:	e8 bd ff ff ff       	call   800d7b <strcpy>
	return dst;
}
  800dbe:	89 d8                	mov    %ebx,%eax
  800dc0:	83 c4 08             	add    $0x8,%esp
  800dc3:	5b                   	pop    %ebx
  800dc4:	5d                   	pop    %ebp
  800dc5:	c3                   	ret    

00800dc6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	8b 75 08             	mov    0x8(%ebp),%esi
  800dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd4:	85 db                	test   %ebx,%ebx
  800dd6:	74 17                	je     800def <strncpy+0x29>
  800dd8:	01 f3                	add    %esi,%ebx
  800dda:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  800ddc:	83 c1 01             	add    $0x1,%ecx
  800ddf:	0f b6 02             	movzbl (%edx),%eax
  800de2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800de5:	80 3a 01             	cmpb   $0x1,(%edx)
  800de8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800deb:	39 d9                	cmp    %ebx,%ecx
  800ded:	75 ed                	jne    800ddc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800def:	89 f0                	mov    %esi,%eax
  800df1:	5b                   	pop    %ebx
  800df2:	5e                   	pop    %esi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	8b 7d 08             	mov    0x8(%ebp),%edi
  800dfe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e01:	8b 75 10             	mov    0x10(%ebp),%esi
  800e04:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e06:	85 f6                	test   %esi,%esi
  800e08:	74 34                	je     800e3e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  800e0a:	83 fe 01             	cmp    $0x1,%esi
  800e0d:	74 26                	je     800e35 <strlcpy+0x40>
  800e0f:	0f b6 0b             	movzbl (%ebx),%ecx
  800e12:	84 c9                	test   %cl,%cl
  800e14:	74 23                	je     800e39 <strlcpy+0x44>
  800e16:	83 ee 02             	sub    $0x2,%esi
  800e19:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  800e1e:	83 c0 01             	add    $0x1,%eax
  800e21:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e24:	39 f2                	cmp    %esi,%edx
  800e26:	74 13                	je     800e3b <strlcpy+0x46>
  800e28:	83 c2 01             	add    $0x1,%edx
  800e2b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800e2f:	84 c9                	test   %cl,%cl
  800e31:	75 eb                	jne    800e1e <strlcpy+0x29>
  800e33:	eb 06                	jmp    800e3b <strlcpy+0x46>
  800e35:	89 f8                	mov    %edi,%eax
  800e37:	eb 02                	jmp    800e3b <strlcpy+0x46>
  800e39:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800e3b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e3e:	29 f8                	sub    %edi,%eax
}
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e4b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e4e:	0f b6 01             	movzbl (%ecx),%eax
  800e51:	84 c0                	test   %al,%al
  800e53:	74 15                	je     800e6a <strcmp+0x25>
  800e55:	3a 02                	cmp    (%edx),%al
  800e57:	75 11                	jne    800e6a <strcmp+0x25>
		p++, q++;
  800e59:	83 c1 01             	add    $0x1,%ecx
  800e5c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e5f:	0f b6 01             	movzbl (%ecx),%eax
  800e62:	84 c0                	test   %al,%al
  800e64:	74 04                	je     800e6a <strcmp+0x25>
  800e66:	3a 02                	cmp    (%edx),%al
  800e68:	74 ef                	je     800e59 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e6a:	0f b6 c0             	movzbl %al,%eax
  800e6d:	0f b6 12             	movzbl (%edx),%edx
  800e70:	29 d0                	sub    %edx,%eax
}
  800e72:	5d                   	pop    %ebp
  800e73:	c3                   	ret    

00800e74 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e74:	55                   	push   %ebp
  800e75:	89 e5                	mov    %esp,%ebp
  800e77:	56                   	push   %esi
  800e78:	53                   	push   %ebx
  800e79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  800e82:	85 f6                	test   %esi,%esi
  800e84:	74 29                	je     800eaf <strncmp+0x3b>
  800e86:	0f b6 03             	movzbl (%ebx),%eax
  800e89:	84 c0                	test   %al,%al
  800e8b:	74 30                	je     800ebd <strncmp+0x49>
  800e8d:	3a 02                	cmp    (%edx),%al
  800e8f:	75 2c                	jne    800ebd <strncmp+0x49>
  800e91:	8d 43 01             	lea    0x1(%ebx),%eax
  800e94:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  800e96:	89 c3                	mov    %eax,%ebx
  800e98:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e9b:	39 f0                	cmp    %esi,%eax
  800e9d:	74 17                	je     800eb6 <strncmp+0x42>
  800e9f:	0f b6 08             	movzbl (%eax),%ecx
  800ea2:	84 c9                	test   %cl,%cl
  800ea4:	74 17                	je     800ebd <strncmp+0x49>
  800ea6:	83 c0 01             	add    $0x1,%eax
  800ea9:	3a 0a                	cmp    (%edx),%cl
  800eab:	74 e9                	je     800e96 <strncmp+0x22>
  800ead:	eb 0e                	jmp    800ebd <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  800eaf:	b8 00 00 00 00       	mov    $0x0,%eax
  800eb4:	eb 0f                	jmp    800ec5 <strncmp+0x51>
  800eb6:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebb:	eb 08                	jmp    800ec5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ebd:	0f b6 03             	movzbl (%ebx),%eax
  800ec0:	0f b6 12             	movzbl (%edx),%edx
  800ec3:	29 d0                	sub    %edx,%eax
}
  800ec5:	5b                   	pop    %ebx
  800ec6:	5e                   	pop    %esi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	53                   	push   %ebx
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800ed3:	0f b6 18             	movzbl (%eax),%ebx
  800ed6:	84 db                	test   %bl,%bl
  800ed8:	74 1d                	je     800ef7 <strchr+0x2e>
  800eda:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800edc:	38 d3                	cmp    %dl,%bl
  800ede:	75 06                	jne    800ee6 <strchr+0x1d>
  800ee0:	eb 1a                	jmp    800efc <strchr+0x33>
  800ee2:	38 ca                	cmp    %cl,%dl
  800ee4:	74 16                	je     800efc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee6:	83 c0 01             	add    $0x1,%eax
  800ee9:	0f b6 10             	movzbl (%eax),%edx
  800eec:	84 d2                	test   %dl,%dl
  800eee:	75 f2                	jne    800ee2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  800ef5:	eb 05                	jmp    800efc <strchr+0x33>
  800ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800efc:	5b                   	pop    %ebx
  800efd:	5d                   	pop    %ebp
  800efe:	c3                   	ret    

00800eff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eff:	55                   	push   %ebp
  800f00:	89 e5                	mov    %esp,%ebp
  800f02:	53                   	push   %ebx
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  800f09:	0f b6 18             	movzbl (%eax),%ebx
  800f0c:	84 db                	test   %bl,%bl
  800f0e:	74 16                	je     800f26 <strfind+0x27>
  800f10:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  800f12:	38 d3                	cmp    %dl,%bl
  800f14:	75 06                	jne    800f1c <strfind+0x1d>
  800f16:	eb 0e                	jmp    800f26 <strfind+0x27>
  800f18:	38 ca                	cmp    %cl,%dl
  800f1a:	74 0a                	je     800f26 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f1c:	83 c0 01             	add    $0x1,%eax
  800f1f:	0f b6 10             	movzbl (%eax),%edx
  800f22:	84 d2                	test   %dl,%dl
  800f24:	75 f2                	jne    800f18 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  800f26:	5b                   	pop    %ebx
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
  800f2f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f32:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f35:	85 c9                	test   %ecx,%ecx
  800f37:	74 36                	je     800f6f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f39:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f3f:	75 28                	jne    800f69 <memset+0x40>
  800f41:	f6 c1 03             	test   $0x3,%cl
  800f44:	75 23                	jne    800f69 <memset+0x40>
		c &= 0xFF;
  800f46:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f4a:	89 d3                	mov    %edx,%ebx
  800f4c:	c1 e3 08             	shl    $0x8,%ebx
  800f4f:	89 d6                	mov    %edx,%esi
  800f51:	c1 e6 18             	shl    $0x18,%esi
  800f54:	89 d0                	mov    %edx,%eax
  800f56:	c1 e0 10             	shl    $0x10,%eax
  800f59:	09 f0                	or     %esi,%eax
  800f5b:	09 c2                	or     %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
  800f5f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800f61:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800f64:	fc                   	cld    
  800f65:	f3 ab                	rep stos %eax,%es:(%edi)
  800f67:	eb 06                	jmp    800f6f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	fc                   	cld    
  800f6d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f6f:	89 f8                	mov    %edi,%eax
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f81:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f84:	39 c6                	cmp    %eax,%esi
  800f86:	73 35                	jae    800fbd <memmove+0x47>
  800f88:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f8b:	39 d0                	cmp    %edx,%eax
  800f8d:	73 2e                	jae    800fbd <memmove+0x47>
		s += n;
		d += n;
  800f8f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800f92:	89 d6                	mov    %edx,%esi
  800f94:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f9c:	75 13                	jne    800fb1 <memmove+0x3b>
  800f9e:	f6 c1 03             	test   $0x3,%cl
  800fa1:	75 0e                	jne    800fb1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800fa3:	83 ef 04             	sub    $0x4,%edi
  800fa6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fa9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800fac:	fd                   	std    
  800fad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800faf:	eb 09                	jmp    800fba <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800fb1:	83 ef 01             	sub    $0x1,%edi
  800fb4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800fb7:	fd                   	std    
  800fb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fba:	fc                   	cld    
  800fbb:	eb 1d                	jmp    800fda <memmove+0x64>
  800fbd:	89 f2                	mov    %esi,%edx
  800fbf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fc1:	f6 c2 03             	test   $0x3,%dl
  800fc4:	75 0f                	jne    800fd5 <memmove+0x5f>
  800fc6:	f6 c1 03             	test   $0x3,%cl
  800fc9:	75 0a                	jne    800fd5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fcb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800fce:	89 c7                	mov    %eax,%edi
  800fd0:	fc                   	cld    
  800fd1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fd3:	eb 05                	jmp    800fda <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800fd5:	89 c7                	mov    %eax,%edi
  800fd7:	fc                   	cld    
  800fd8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fda:	5e                   	pop    %esi
  800fdb:	5f                   	pop    %edi
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fe4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800feb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	89 04 24             	mov    %eax,(%esp)
  800ff8:	e8 79 ff ff ff       	call   800f76 <memmove>
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    

00800fff <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
  801005:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801008:	8b 75 0c             	mov    0xc(%ebp),%esi
  80100b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80100e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801011:	85 c0                	test   %eax,%eax
  801013:	74 36                	je     80104b <memcmp+0x4c>
		if (*s1 != *s2)
  801015:	0f b6 03             	movzbl (%ebx),%eax
  801018:	0f b6 0e             	movzbl (%esi),%ecx
  80101b:	ba 00 00 00 00       	mov    $0x0,%edx
  801020:	38 c8                	cmp    %cl,%al
  801022:	74 1c                	je     801040 <memcmp+0x41>
  801024:	eb 10                	jmp    801036 <memcmp+0x37>
  801026:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  80102b:	83 c2 01             	add    $0x1,%edx
  80102e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801032:	38 c8                	cmp    %cl,%al
  801034:	74 0a                	je     801040 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801036:	0f b6 c0             	movzbl %al,%eax
  801039:	0f b6 c9             	movzbl %cl,%ecx
  80103c:	29 c8                	sub    %ecx,%eax
  80103e:	eb 10                	jmp    801050 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801040:	39 fa                	cmp    %edi,%edx
  801042:	75 e2                	jne    801026 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801044:	b8 00 00 00 00       	mov    $0x0,%eax
  801049:	eb 05                	jmp    801050 <memcmp+0x51>
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	53                   	push   %ebx
  801059:	8b 45 08             	mov    0x8(%ebp),%eax
  80105c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  80105f:	89 c2                	mov    %eax,%edx
  801061:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801064:	39 d0                	cmp    %edx,%eax
  801066:	73 13                	jae    80107b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801068:	89 d9                	mov    %ebx,%ecx
  80106a:	38 18                	cmp    %bl,(%eax)
  80106c:	75 06                	jne    801074 <memfind+0x1f>
  80106e:	eb 0b                	jmp    80107b <memfind+0x26>
  801070:	38 08                	cmp    %cl,(%eax)
  801072:	74 07                	je     80107b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801074:	83 c0 01             	add    $0x1,%eax
  801077:	39 d0                	cmp    %edx,%eax
  801079:	75 f5                	jne    801070 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  80107b:	5b                   	pop    %ebx
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	57                   	push   %edi
  801082:	56                   	push   %esi
  801083:	53                   	push   %ebx
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108a:	0f b6 0a             	movzbl (%edx),%ecx
  80108d:	80 f9 09             	cmp    $0x9,%cl
  801090:	74 05                	je     801097 <strtol+0x19>
  801092:	80 f9 20             	cmp    $0x20,%cl
  801095:	75 10                	jne    8010a7 <strtol+0x29>
		s++;
  801097:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109a:	0f b6 0a             	movzbl (%edx),%ecx
  80109d:	80 f9 09             	cmp    $0x9,%cl
  8010a0:	74 f5                	je     801097 <strtol+0x19>
  8010a2:	80 f9 20             	cmp    $0x20,%cl
  8010a5:	74 f0                	je     801097 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a7:	80 f9 2b             	cmp    $0x2b,%cl
  8010aa:	75 0a                	jne    8010b6 <strtol+0x38>
		s++;
  8010ac:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  8010af:	bf 00 00 00 00       	mov    $0x0,%edi
  8010b4:	eb 11                	jmp    8010c7 <strtol+0x49>
  8010b6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  8010bb:	80 f9 2d             	cmp    $0x2d,%cl
  8010be:	75 07                	jne    8010c7 <strtol+0x49>
		s++, neg = 1;
  8010c0:	83 c2 01             	add    $0x1,%edx
  8010c3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  8010cc:	75 15                	jne    8010e3 <strtol+0x65>
  8010ce:	80 3a 30             	cmpb   $0x30,(%edx)
  8010d1:	75 10                	jne    8010e3 <strtol+0x65>
  8010d3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8010d7:	75 0a                	jne    8010e3 <strtol+0x65>
		s += 2, base = 16;
  8010d9:	83 c2 02             	add    $0x2,%edx
  8010dc:	b8 10 00 00 00       	mov    $0x10,%eax
  8010e1:	eb 10                	jmp    8010f3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	75 0c                	jne    8010f3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8010e7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010e9:	80 3a 30             	cmpb   $0x30,(%edx)
  8010ec:	75 05                	jne    8010f3 <strtol+0x75>
		s++, base = 8;
  8010ee:	83 c2 01             	add    $0x1,%edx
  8010f1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  8010f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010fb:	0f b6 0a             	movzbl (%edx),%ecx
  8010fe:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801101:	89 f0                	mov    %esi,%eax
  801103:	3c 09                	cmp    $0x9,%al
  801105:	77 08                	ja     80110f <strtol+0x91>
			dig = *s - '0';
  801107:	0f be c9             	movsbl %cl,%ecx
  80110a:	83 e9 30             	sub    $0x30,%ecx
  80110d:	eb 20                	jmp    80112f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  80110f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801112:	89 f0                	mov    %esi,%eax
  801114:	3c 19                	cmp    $0x19,%al
  801116:	77 08                	ja     801120 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801118:	0f be c9             	movsbl %cl,%ecx
  80111b:	83 e9 57             	sub    $0x57,%ecx
  80111e:	eb 0f                	jmp    80112f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801120:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801123:	89 f0                	mov    %esi,%eax
  801125:	3c 19                	cmp    $0x19,%al
  801127:	77 16                	ja     80113f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801129:	0f be c9             	movsbl %cl,%ecx
  80112c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80112f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801132:	7d 0f                	jge    801143 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801134:	83 c2 01             	add    $0x1,%edx
  801137:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  80113b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  80113d:	eb bc                	jmp    8010fb <strtol+0x7d>
  80113f:	89 d8                	mov    %ebx,%eax
  801141:	eb 02                	jmp    801145 <strtol+0xc7>
  801143:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801145:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801149:	74 05                	je     801150 <strtol+0xd2>
		*endptr = (char *) s;
  80114b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80114e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801150:	f7 d8                	neg    %eax
  801152:	85 ff                	test   %edi,%edi
  801154:	0f 44 c3             	cmove  %ebx,%eax
}
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    

0080115c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	57                   	push   %edi
  801160:	56                   	push   %esi
  801161:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801162:	b8 00 00 00 00       	mov    $0x0,%eax
  801167:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116a:	8b 55 08             	mov    0x8(%ebp),%edx
  80116d:	89 c3                	mov    %eax,%ebx
  80116f:	89 c7                	mov    %eax,%edi
  801171:	89 c6                	mov    %eax,%esi
  801173:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801175:	5b                   	pop    %ebx
  801176:	5e                   	pop    %esi
  801177:	5f                   	pop    %edi
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    

0080117a <sys_cgetc>:

int
sys_cgetc(void)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	57                   	push   %edi
  80117e:	56                   	push   %esi
  80117f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801180:	ba 00 00 00 00       	mov    $0x0,%edx
  801185:	b8 01 00 00 00       	mov    $0x1,%eax
  80118a:	89 d1                	mov    %edx,%ecx
  80118c:	89 d3                	mov    %edx,%ebx
  80118e:	89 d7                	mov    %edx,%edi
  801190:	89 d6                	mov    %edx,%esi
  801192:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	57                   	push   %edi
  80119d:	56                   	push   %esi
  80119e:	53                   	push   %ebx
  80119f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a7:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8011af:	89 cb                	mov    %ecx,%ebx
  8011b1:	89 cf                	mov    %ecx,%edi
  8011b3:	89 ce                	mov    %ecx,%esi
  8011b5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011b7:	85 c0                	test   %eax,%eax
  8011b9:	7e 28                	jle    8011e3 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011bb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bf:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011c6:	00 
  8011c7:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  8011ce:	00 
  8011cf:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8011d6:	00 
  8011d7:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  8011de:	e8 43 f4 ff ff       	call   800626 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011e3:	83 c4 2c             	add    $0x2c,%esp
  8011e6:	5b                   	pop    %ebx
  8011e7:	5e                   	pop    %esi
  8011e8:	5f                   	pop    %edi
  8011e9:	5d                   	pop    %ebp
  8011ea:	c3                   	ret    

008011eb <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	57                   	push   %edi
  8011ef:	56                   	push   %esi
  8011f0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8011fb:	89 d1                	mov    %edx,%ecx
  8011fd:	89 d3                	mov    %edx,%ebx
  8011ff:	89 d7                	mov    %edx,%edi
  801201:	89 d6                	mov    %edx,%esi
  801203:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801205:	5b                   	pop    %ebx
  801206:	5e                   	pop    %esi
  801207:	5f                   	pop    %edi
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    

0080120a <sys_yield>:

void
sys_yield(void)
{
  80120a:	55                   	push   %ebp
  80120b:	89 e5                	mov    %esp,%ebp
  80120d:	57                   	push   %edi
  80120e:	56                   	push   %esi
  80120f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801210:	ba 00 00 00 00       	mov    $0x0,%edx
  801215:	b8 0b 00 00 00       	mov    $0xb,%eax
  80121a:	89 d1                	mov    %edx,%ecx
  80121c:	89 d3                	mov    %edx,%ebx
  80121e:	89 d7                	mov    %edx,%edi
  801220:	89 d6                	mov    %edx,%esi
  801222:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801224:	5b                   	pop    %ebx
  801225:	5e                   	pop    %esi
  801226:	5f                   	pop    %edi
  801227:	5d                   	pop    %ebp
  801228:	c3                   	ret    

00801229 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	57                   	push   %edi
  80122d:	56                   	push   %esi
  80122e:	53                   	push   %ebx
  80122f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801232:	be 00 00 00 00       	mov    $0x0,%esi
  801237:	b8 04 00 00 00       	mov    $0x4,%eax
  80123c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123f:	8b 55 08             	mov    0x8(%ebp),%edx
  801242:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801245:	89 f7                	mov    %esi,%edi
  801247:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801249:	85 c0                	test   %eax,%eax
  80124b:	7e 28                	jle    801275 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801251:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801258:	00 
  801259:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  801260:	00 
  801261:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801268:	00 
  801269:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801270:	e8 b1 f3 ff ff       	call   800626 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801275:	83 c4 2c             	add    $0x2c,%esp
  801278:	5b                   	pop    %ebx
  801279:	5e                   	pop    %esi
  80127a:	5f                   	pop    %edi
  80127b:	5d                   	pop    %ebp
  80127c:	c3                   	ret    

0080127d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	57                   	push   %edi
  801281:	56                   	push   %esi
  801282:	53                   	push   %ebx
  801283:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801286:	b8 05 00 00 00       	mov    $0x5,%eax
  80128b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80128e:	8b 55 08             	mov    0x8(%ebp),%edx
  801291:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801294:	8b 7d 14             	mov    0x14(%ebp),%edi
  801297:	8b 75 18             	mov    0x18(%ebp),%esi
  80129a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80129c:	85 c0                	test   %eax,%eax
  80129e:	7e 28                	jle    8012c8 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012a4:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012ab:	00 
  8012ac:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8012bb:	00 
  8012bc:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  8012c3:	e8 5e f3 ff ff       	call   800626 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012c8:	83 c4 2c             	add    $0x2c,%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	57                   	push   %edi
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012de:	b8 06 00 00 00       	mov    $0x6,%eax
  8012e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e9:	89 df                	mov    %ebx,%edi
  8012eb:	89 de                	mov    %ebx,%esi
  8012ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	7e 28                	jle    80131b <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012fe:	00 
  8012ff:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  801306:	00 
  801307:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80130e:	00 
  80130f:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801316:	e8 0b f3 ff ff       	call   800626 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80131b:	83 c4 2c             	add    $0x2c,%esp
  80131e:	5b                   	pop    %ebx
  80131f:	5e                   	pop    %esi
  801320:	5f                   	pop    %edi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    

00801323 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801323:	55                   	push   %ebp
  801324:	89 e5                	mov    %esp,%ebp
  801326:	57                   	push   %edi
  801327:	56                   	push   %esi
  801328:	53                   	push   %ebx
  801329:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801331:	b8 08 00 00 00       	mov    $0x8,%eax
  801336:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801339:	8b 55 08             	mov    0x8(%ebp),%edx
  80133c:	89 df                	mov    %ebx,%edi
  80133e:	89 de                	mov    %ebx,%esi
  801340:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801342:	85 c0                	test   %eax,%eax
  801344:	7e 28                	jle    80136e <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801346:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801351:	00 
  801352:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  801359:	00 
  80135a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801361:	00 
  801362:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801369:	e8 b8 f2 ff ff       	call   800626 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80136e:	83 c4 2c             	add    $0x2c,%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    

00801376 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801376:	55                   	push   %ebp
  801377:	89 e5                	mov    %esp,%ebp
  801379:	57                   	push   %edi
  80137a:	56                   	push   %esi
  80137b:	53                   	push   %ebx
  80137c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801384:	b8 09 00 00 00       	mov    $0x9,%eax
  801389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	89 df                	mov    %ebx,%edi
  801391:	89 de                	mov    %ebx,%esi
  801393:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801395:	85 c0                	test   %eax,%eax
  801397:	7e 28                	jle    8013c1 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139d:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8013a4:	00 
  8013a5:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  8013ac:	00 
  8013ad:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013b4:	00 
  8013b5:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  8013bc:	e8 65 f2 ff ff       	call   800626 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013c1:	83 c4 2c             	add    $0x2c,%esp
  8013c4:	5b                   	pop    %ebx
  8013c5:	5e                   	pop    %esi
  8013c6:	5f                   	pop    %edi
  8013c7:	5d                   	pop    %ebp
  8013c8:	c3                   	ret    

008013c9 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013c9:	55                   	push   %ebp
  8013ca:	89 e5                	mov    %esp,%ebp
  8013cc:	57                   	push   %edi
  8013cd:	56                   	push   %esi
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013d7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8013dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013df:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e2:	89 df                	mov    %ebx,%edi
  8013e4:	89 de                	mov    %ebx,%esi
  8013e6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	7e 28                	jle    801414 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f0:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8013f7:	00 
  8013f8:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  8013ff:	00 
  801400:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801407:	00 
  801408:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  80140f:	e8 12 f2 ff ff       	call   800626 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801414:	83 c4 2c             	add    $0x2c,%esp
  801417:	5b                   	pop    %ebx
  801418:	5e                   	pop    %esi
  801419:	5f                   	pop    %edi
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801422:	be 00 00 00 00       	mov    $0x0,%esi
  801427:	b8 0c 00 00 00       	mov    $0xc,%eax
  80142c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80142f:	8b 55 08             	mov    0x8(%ebp),%edx
  801432:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801435:	8b 7d 14             	mov    0x14(%ebp),%edi
  801438:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80143a:	5b                   	pop    %ebx
  80143b:	5e                   	pop    %esi
  80143c:	5f                   	pop    %edi
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    

0080143f <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	57                   	push   %edi
  801443:	56                   	push   %esi
  801444:	53                   	push   %ebx
  801445:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801448:	b9 00 00 00 00       	mov    $0x0,%ecx
  80144d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801452:	8b 55 08             	mov    0x8(%ebp),%edx
  801455:	89 cb                	mov    %ecx,%ebx
  801457:	89 cf                	mov    %ecx,%edi
  801459:	89 ce                	mov    %ecx,%esi
  80145b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80145d:	85 c0                	test   %eax,%eax
  80145f:	7e 28                	jle    801489 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  801461:	89 44 24 10          	mov    %eax,0x10(%esp)
  801465:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80146c:	00 
  80146d:	c7 44 24 08 1f 2b 80 	movl   $0x802b1f,0x8(%esp)
  801474:	00 
  801475:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80147c:	00 
  80147d:	c7 04 24 3c 2b 80 00 	movl   $0x802b3c,(%esp)
  801484:	e8 9d f1 ff ff       	call   800626 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801489:	83 c4 2c             	add    $0x2c,%esp
  80148c:	5b                   	pop    %ebx
  80148d:	5e                   	pop    %esi
  80148e:	5f                   	pop    %edi
  80148f:	5d                   	pop    %ebp
  801490:	c3                   	ret    

00801491 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801491:	55                   	push   %ebp
  801492:	89 e5                	mov    %esp,%ebp
  801494:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801497:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  80149e:	75 50                	jne    8014f0 <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  8014a0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014a7:	00 
  8014a8:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014af:	ee 
  8014b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b7:	e8 6d fd ff ff       	call   801229 <sys_page_alloc>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	79 1c                	jns    8014dc <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  8014c0:	c7 44 24 08 4c 2b 80 	movl   $0x802b4c,0x8(%esp)
  8014c7:	00 
  8014c8:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  8014cf:	00 
  8014d0:	c7 04 24 70 2b 80 00 	movl   $0x802b70,(%esp)
  8014d7:	e8 4a f1 ff ff       	call   800626 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  8014dc:	c7 44 24 04 fa 14 80 	movl   $0x8014fa,0x4(%esp)
  8014e3:	00 
  8014e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014eb:	e8 d9 fe ff ff       	call   8013c9 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8014fa:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8014fb:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  801500:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801502:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  801505:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  801507:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  80150c:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  80150f:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  801514:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  801517:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  801519:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  80151c:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  80151e:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  801520:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  801525:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  801528:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  80152d:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  801530:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  801532:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  801537:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80153a:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  80153f:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  801542:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  801544:	83 c4 08             	add    $0x8,%esp
	popal
  801547:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801548:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801549:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80154a:	c3                   	ret    
  80154b:	66 90                	xchg   %ax,%ax
  80154d:	66 90                	xchg   %ax,%ax
  80154f:	90                   	nop

00801550 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	05 00 00 00 30       	add    $0x30000000,%eax
  80155b:	c1 e8 0c             	shr    $0xc,%eax
}
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80156b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801570:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80157a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80157f:	a8 01                	test   $0x1,%al
  801581:	74 34                	je     8015b7 <fd_alloc+0x40>
  801583:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801588:	a8 01                	test   $0x1,%al
  80158a:	74 32                	je     8015be <fd_alloc+0x47>
  80158c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  801591:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801593:	89 c2                	mov    %eax,%edx
  801595:	c1 ea 16             	shr    $0x16,%edx
  801598:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	74 1f                	je     8015c3 <fd_alloc+0x4c>
  8015a4:	89 c2                	mov    %eax,%edx
  8015a6:	c1 ea 0c             	shr    $0xc,%edx
  8015a9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b0:	f6 c2 01             	test   $0x1,%dl
  8015b3:	75 1a                	jne    8015cf <fd_alloc+0x58>
  8015b5:	eb 0c                	jmp    8015c3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8015b7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8015bc:	eb 05                	jmp    8015c3 <fd_alloc+0x4c>
  8015be:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	eb 1a                	jmp    8015e9 <fd_alloc+0x72>
  8015cf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015d4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015d9:	75 b6                	jne    801591 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8015e4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015e9:	5d                   	pop    %ebp
  8015ea:	c3                   	ret    

008015eb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015eb:	55                   	push   %ebp
  8015ec:	89 e5                	mov    %esp,%ebp
  8015ee:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015f1:	83 f8 1f             	cmp    $0x1f,%eax
  8015f4:	77 36                	ja     80162c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f6:	c1 e0 0c             	shl    $0xc,%eax
  8015f9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015fe:	89 c2                	mov    %eax,%edx
  801600:	c1 ea 16             	shr    $0x16,%edx
  801603:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80160a:	f6 c2 01             	test   $0x1,%dl
  80160d:	74 24                	je     801633 <fd_lookup+0x48>
  80160f:	89 c2                	mov    %eax,%edx
  801611:	c1 ea 0c             	shr    $0xc,%edx
  801614:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80161b:	f6 c2 01             	test   $0x1,%dl
  80161e:	74 1a                	je     80163a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801620:	8b 55 0c             	mov    0xc(%ebp),%edx
  801623:	89 02                	mov    %eax,(%edx)
	return 0;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
  80162a:	eb 13                	jmp    80163f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80162c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801631:	eb 0c                	jmp    80163f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801633:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801638:	eb 05                	jmp    80163f <fd_lookup+0x54>
  80163a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80163f:	5d                   	pop    %ebp
  801640:	c3                   	ret    

00801641 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	53                   	push   %ebx
  801645:	83 ec 14             	sub    $0x14,%esp
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80164e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  801654:	75 1e                	jne    801674 <dev_lookup+0x33>
  801656:	eb 0e                	jmp    801666 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801658:	b8 20 30 80 00       	mov    $0x803020,%eax
  80165d:	eb 0c                	jmp    80166b <dev_lookup+0x2a>
  80165f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  801664:	eb 05                	jmp    80166b <dev_lookup+0x2a>
  801666:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80166b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
  801672:	eb 38                	jmp    8016ac <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  801674:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80167a:	74 dc                	je     801658 <dev_lookup+0x17>
  80167c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  801682:	74 db                	je     80165f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801684:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  80168a:	8b 52 48             	mov    0x48(%edx),%edx
  80168d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801691:	89 54 24 04          	mov    %edx,0x4(%esp)
  801695:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  80169c:	e8 7e f0 ff ff       	call   80071f <cprintf>
	*dev = 0;
  8016a1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8016a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016ac:	83 c4 14             	add    $0x14,%esp
  8016af:	5b                   	pop    %ebx
  8016b0:	5d                   	pop    %ebp
  8016b1:	c3                   	ret    

008016b2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 20             	sub    $0x20,%esp
  8016ba:	8b 75 08             	mov    0x8(%ebp),%esi
  8016bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016c7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016cd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	e8 13 ff ff ff       	call   8015eb <fd_lookup>
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	78 05                	js     8016e1 <fd_close+0x2f>
	    || fd != fd2)
  8016dc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016df:	74 0c                	je     8016ed <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016e1:	84 db                	test   %bl,%bl
  8016e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e8:	0f 44 c2             	cmove  %edx,%eax
  8016eb:	eb 3f                	jmp    80172c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f4:	8b 06                	mov    (%esi),%eax
  8016f6:	89 04 24             	mov    %eax,(%esp)
  8016f9:	e8 43 ff ff ff       	call   801641 <dev_lookup>
  8016fe:	89 c3                	mov    %eax,%ebx
  801700:	85 c0                	test   %eax,%eax
  801702:	78 16                	js     80171a <fd_close+0x68>
		if (dev->dev_close)
  801704:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801707:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80170a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80170f:	85 c0                	test   %eax,%eax
  801711:	74 07                	je     80171a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801713:	89 34 24             	mov    %esi,(%esp)
  801716:	ff d0                	call   *%eax
  801718:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80171a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80171e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801725:	e8 a6 fb ff ff       	call   8012d0 <sys_page_unmap>
	return r;
  80172a:	89 d8                	mov    %ebx,%eax
}
  80172c:	83 c4 20             	add    $0x20,%esp
  80172f:	5b                   	pop    %ebx
  801730:	5e                   	pop    %esi
  801731:	5d                   	pop    %ebp
  801732:	c3                   	ret    

00801733 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801739:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	89 04 24             	mov    %eax,(%esp)
  801746:	e8 a0 fe ff ff       	call   8015eb <fd_lookup>
  80174b:	89 c2                	mov    %eax,%edx
  80174d:	85 d2                	test   %edx,%edx
  80174f:	78 13                	js     801764 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801751:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801758:	00 
  801759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175c:	89 04 24             	mov    %eax,(%esp)
  80175f:	e8 4e ff ff ff       	call   8016b2 <fd_close>
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <close_all>:

void
close_all(void)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	53                   	push   %ebx
  80176a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80176d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801772:	89 1c 24             	mov    %ebx,(%esp)
  801775:	e8 b9 ff ff ff       	call   801733 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80177a:	83 c3 01             	add    $0x1,%ebx
  80177d:	83 fb 20             	cmp    $0x20,%ebx
  801780:	75 f0                	jne    801772 <close_all+0xc>
		close(i);
}
  801782:	83 c4 14             	add    $0x14,%esp
  801785:	5b                   	pop    %ebx
  801786:	5d                   	pop    %ebp
  801787:	c3                   	ret    

00801788 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	57                   	push   %edi
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801791:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801794:	89 44 24 04          	mov    %eax,0x4(%esp)
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
  80179b:	89 04 24             	mov    %eax,(%esp)
  80179e:	e8 48 fe ff ff       	call   8015eb <fd_lookup>
  8017a3:	89 c2                	mov    %eax,%edx
  8017a5:	85 d2                	test   %edx,%edx
  8017a7:	0f 88 e1 00 00 00    	js     80188e <dup+0x106>
		return r;
	close(newfdnum);
  8017ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b0:	89 04 24             	mov    %eax,(%esp)
  8017b3:	e8 7b ff ff ff       	call   801733 <close>

	newfd = INDEX2FD(newfdnum);
  8017b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8017bb:	c1 e3 0c             	shl    $0xc,%ebx
  8017be:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8017c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 91 fd ff ff       	call   801560 <fd2data>
  8017cf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8017d1:	89 1c 24             	mov    %ebx,(%esp)
  8017d4:	e8 87 fd ff ff       	call   801560 <fd2data>
  8017d9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017db:	89 f0                	mov    %esi,%eax
  8017dd:	c1 e8 16             	shr    $0x16,%eax
  8017e0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017e7:	a8 01                	test   $0x1,%al
  8017e9:	74 43                	je     80182e <dup+0xa6>
  8017eb:	89 f0                	mov    %esi,%eax
  8017ed:	c1 e8 0c             	shr    $0xc,%eax
  8017f0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017f7:	f6 c2 01             	test   $0x1,%dl
  8017fa:	74 32                	je     80182e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801803:	25 07 0e 00 00       	and    $0xe07,%eax
  801808:	89 44 24 10          	mov    %eax,0x10(%esp)
  80180c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801810:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801817:	00 
  801818:	89 74 24 04          	mov    %esi,0x4(%esp)
  80181c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801823:	e8 55 fa ff ff       	call   80127d <sys_page_map>
  801828:	89 c6                	mov    %eax,%esi
  80182a:	85 c0                	test   %eax,%eax
  80182c:	78 3e                	js     80186c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80182e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801831:	89 c2                	mov    %eax,%edx
  801833:	c1 ea 0c             	shr    $0xc,%edx
  801836:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80183d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801843:	89 54 24 10          	mov    %edx,0x10(%esp)
  801847:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80184b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801852:	00 
  801853:	89 44 24 04          	mov    %eax,0x4(%esp)
  801857:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185e:	e8 1a fa ff ff       	call   80127d <sys_page_map>
  801863:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801868:	85 f6                	test   %esi,%esi
  80186a:	79 22                	jns    80188e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80186c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801870:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801877:	e8 54 fa ff ff       	call   8012d0 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80187c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801880:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801887:	e8 44 fa ff ff       	call   8012d0 <sys_page_unmap>
	return r;
  80188c:	89 f0                	mov    %esi,%eax
}
  80188e:	83 c4 3c             	add    $0x3c,%esp
  801891:	5b                   	pop    %ebx
  801892:	5e                   	pop    %esi
  801893:	5f                   	pop    %edi
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    

00801896 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	53                   	push   %ebx
  80189a:	83 ec 24             	sub    $0x24,%esp
  80189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a7:	89 1c 24             	mov    %ebx,(%esp)
  8018aa:	e8 3c fd ff ff       	call   8015eb <fd_lookup>
  8018af:	89 c2                	mov    %eax,%edx
  8018b1:	85 d2                	test   %edx,%edx
  8018b3:	78 6d                	js     801922 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bf:	8b 00                	mov    (%eax),%eax
  8018c1:	89 04 24             	mov    %eax,(%esp)
  8018c4:	e8 78 fd ff ff       	call   801641 <dev_lookup>
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 55                	js     801922 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	8b 50 08             	mov    0x8(%eax),%edx
  8018d3:	83 e2 03             	and    $0x3,%edx
  8018d6:	83 fa 01             	cmp    $0x1,%edx
  8018d9:	75 23                	jne    8018fe <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018db:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8018e0:	8b 40 48             	mov    0x48(%eax),%eax
  8018e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018eb:	c7 04 24 c4 2b 80 00 	movl   $0x802bc4,(%esp)
  8018f2:	e8 28 ee ff ff       	call   80071f <cprintf>
		return -E_INVAL;
  8018f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018fc:	eb 24                	jmp    801922 <read+0x8c>
	}
	if (!dev->dev_read)
  8018fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801901:	8b 52 08             	mov    0x8(%edx),%edx
  801904:	85 d2                	test   %edx,%edx
  801906:	74 15                	je     80191d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801908:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80190f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801912:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	ff d2                	call   *%edx
  80191b:	eb 05                	jmp    801922 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80191d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801922:	83 c4 24             	add    $0x24,%esp
  801925:	5b                   	pop    %ebx
  801926:	5d                   	pop    %ebp
  801927:	c3                   	ret    

00801928 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	57                   	push   %edi
  80192c:	56                   	push   %esi
  80192d:	53                   	push   %ebx
  80192e:	83 ec 1c             	sub    $0x1c,%esp
  801931:	8b 7d 08             	mov    0x8(%ebp),%edi
  801934:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801937:	85 f6                	test   %esi,%esi
  801939:	74 33                	je     80196e <readn+0x46>
  80193b:	b8 00 00 00 00       	mov    $0x0,%eax
  801940:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  801945:	89 f2                	mov    %esi,%edx
  801947:	29 c2                	sub    %eax,%edx
  801949:	89 54 24 08          	mov    %edx,0x8(%esp)
  80194d:	03 45 0c             	add    0xc(%ebp),%eax
  801950:	89 44 24 04          	mov    %eax,0x4(%esp)
  801954:	89 3c 24             	mov    %edi,(%esp)
  801957:	e8 3a ff ff ff       	call   801896 <read>
		if (m < 0)
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 1b                	js     80197b <readn+0x53>
			return m;
		if (m == 0)
  801960:	85 c0                	test   %eax,%eax
  801962:	74 11                	je     801975 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801964:	01 c3                	add    %eax,%ebx
  801966:	89 d8                	mov    %ebx,%eax
  801968:	39 f3                	cmp    %esi,%ebx
  80196a:	72 d9                	jb     801945 <readn+0x1d>
  80196c:	eb 0b                	jmp    801979 <readn+0x51>
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	eb 06                	jmp    80197b <readn+0x53>
  801975:	89 d8                	mov    %ebx,%eax
  801977:	eb 02                	jmp    80197b <readn+0x53>
  801979:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80197b:	83 c4 1c             	add    $0x1c,%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5e                   	pop    %esi
  801980:	5f                   	pop    %edi
  801981:	5d                   	pop    %ebp
  801982:	c3                   	ret    

00801983 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	53                   	push   %ebx
  801987:	83 ec 24             	sub    $0x24,%esp
  80198a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801990:	89 44 24 04          	mov    %eax,0x4(%esp)
  801994:	89 1c 24             	mov    %ebx,(%esp)
  801997:	e8 4f fc ff ff       	call   8015eb <fd_lookup>
  80199c:	89 c2                	mov    %eax,%edx
  80199e:	85 d2                	test   %edx,%edx
  8019a0:	78 68                	js     801a0a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	8b 00                	mov    (%eax),%eax
  8019ae:	89 04 24             	mov    %eax,(%esp)
  8019b1:	e8 8b fc ff ff       	call   801641 <dev_lookup>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 50                	js     801a0a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019bd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019c1:	75 23                	jne    8019e6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8019c3:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8019c8:	8b 40 48             	mov    0x48(%eax),%eax
  8019cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	c7 04 24 e0 2b 80 00 	movl   $0x802be0,(%esp)
  8019da:	e8 40 ed ff ff       	call   80071f <cprintf>
		return -E_INVAL;
  8019df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e4:	eb 24                	jmp    801a0a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ec:	85 d2                	test   %edx,%edx
  8019ee:	74 15                	je     801a05 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	ff d2                	call   *%edx
  801a03:	eb 05                	jmp    801a0a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801a05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801a0a:	83 c4 24             	add    $0x24,%esp
  801a0d:	5b                   	pop    %ebx
  801a0e:	5d                   	pop    %ebp
  801a0f:	c3                   	ret    

00801a10 <seek>:

int
seek(int fdnum, off_t offset)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a16:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a20:	89 04 24             	mov    %eax,(%esp)
  801a23:	e8 c3 fb ff ff       	call   8015eb <fd_lookup>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 0e                	js     801a3a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a32:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3a:	c9                   	leave  
  801a3b:	c3                   	ret    

00801a3c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801a3c:	55                   	push   %ebp
  801a3d:	89 e5                	mov    %esp,%ebp
  801a3f:	53                   	push   %ebx
  801a40:	83 ec 24             	sub    $0x24,%esp
  801a43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a46:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4d:	89 1c 24             	mov    %ebx,(%esp)
  801a50:	e8 96 fb ff ff       	call   8015eb <fd_lookup>
  801a55:	89 c2                	mov    %eax,%edx
  801a57:	85 d2                	test   %edx,%edx
  801a59:	78 61                	js     801abc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	89 04 24             	mov    %eax,(%esp)
  801a6a:	e8 d2 fb ff ff       	call   801641 <dev_lookup>
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 49                	js     801abc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a76:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a7a:	75 23                	jne    801a9f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a7c:	a1 b0 40 80 00       	mov    0x8040b0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a81:	8b 40 48             	mov    0x48(%eax),%eax
  801a84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8c:	c7 04 24 a0 2b 80 00 	movl   $0x802ba0,(%esp)
  801a93:	e8 87 ec ff ff       	call   80071f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a9d:	eb 1d                	jmp    801abc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aa2:	8b 52 18             	mov    0x18(%edx),%edx
  801aa5:	85 d2                	test   %edx,%edx
  801aa7:	74 0e                	je     801ab7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ab0:	89 04 24             	mov    %eax,(%esp)
  801ab3:	ff d2                	call   *%edx
  801ab5:	eb 05                	jmp    801abc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801ab7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801abc:	83 c4 24             	add    $0x24,%esp
  801abf:	5b                   	pop    %ebx
  801ac0:	5d                   	pop    %ebp
  801ac1:	c3                   	ret    

00801ac2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	53                   	push   %ebx
  801ac6:	83 ec 24             	sub    $0x24,%esp
  801ac9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801acc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	89 04 24             	mov    %eax,(%esp)
  801ad9:	e8 0d fb ff ff       	call   8015eb <fd_lookup>
  801ade:	89 c2                	mov    %eax,%edx
  801ae0:	85 d2                	test   %edx,%edx
  801ae2:	78 52                	js     801b36 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aee:	8b 00                	mov    (%eax),%eax
  801af0:	89 04 24             	mov    %eax,(%esp)
  801af3:	e8 49 fb ff ff       	call   801641 <dev_lookup>
  801af8:	85 c0                	test   %eax,%eax
  801afa:	78 3a                	js     801b36 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aff:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801b03:	74 2c                	je     801b31 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b05:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b08:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b0f:	00 00 00 
	stat->st_isdir = 0;
  801b12:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b19:	00 00 00 
	stat->st_dev = dev;
  801b1c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801b22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b29:	89 14 24             	mov    %edx,(%esp)
  801b2c:	ff 50 14             	call   *0x14(%eax)
  801b2f:	eb 05                	jmp    801b36 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801b31:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801b36:	83 c4 24             	add    $0x24,%esp
  801b39:	5b                   	pop    %ebx
  801b3a:	5d                   	pop    %ebp
  801b3b:	c3                   	ret    

00801b3c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
  801b3f:	56                   	push   %esi
  801b40:	53                   	push   %ebx
  801b41:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b4b:	00 
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	89 04 24             	mov    %eax,(%esp)
  801b52:	e8 af 01 00 00       	call   801d06 <open>
  801b57:	89 c3                	mov    %eax,%ebx
  801b59:	85 db                	test   %ebx,%ebx
  801b5b:	78 1b                	js     801b78 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b64:	89 1c 24             	mov    %ebx,(%esp)
  801b67:	e8 56 ff ff ff       	call   801ac2 <fstat>
  801b6c:	89 c6                	mov    %eax,%esi
	close(fd);
  801b6e:	89 1c 24             	mov    %ebx,(%esp)
  801b71:	e8 bd fb ff ff       	call   801733 <close>
	return r;
  801b76:	89 f0                	mov    %esi,%eax
}
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	56                   	push   %esi
  801b83:	53                   	push   %ebx
  801b84:	83 ec 10             	sub    $0x10,%esp
  801b87:	89 c6                	mov    %eax,%esi
  801b89:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b8b:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  801b92:	75 11                	jne    801ba5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b9b:	e8 24 08 00 00       	call   8023c4 <ipc_find_env>
  801ba0:	a3 ac 40 80 00       	mov    %eax,0x8040ac
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ba5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bac:	00 
  801bad:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801bb4:	00 
  801bb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb9:	a1 ac 40 80 00       	mov    0x8040ac,%eax
  801bbe:	89 04 24             	mov    %eax,(%esp)
  801bc1:	e8 98 07 00 00       	call   80235e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bcd:	00 
  801bce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd9:	e8 18 07 00 00       	call   8022f6 <ipc_recv>
}
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	5b                   	pop    %ebx
  801be2:	5e                   	pop    %esi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 14             	sub    $0x14,%esp
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 05 00 00 00       	mov    $0x5,%eax
  801c04:	e8 76 ff ff ff       	call   801b7f <fsipc>
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	78 2b                	js     801c3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c0f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801c16:	00 
  801c17:	89 1c 24             	mov    %ebx,(%esp)
  801c1a:	e8 5c f1 ff ff       	call   800d7b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c1f:	a1 80 50 80 00       	mov    0x805080,%eax
  801c24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c2a:	a1 84 50 80 00       	mov    0x805084,%eax
  801c2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	83 c4 14             	add    $0x14,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8b 40 0c             	mov    0xc(%eax),%eax
  801c4c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801c51:	ba 00 00 00 00       	mov    $0x0,%edx
  801c56:	b8 06 00 00 00       	mov    $0x6,%eax
  801c5b:	e8 1f ff ff ff       	call   801b7f <fsipc>
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
  801c65:	56                   	push   %esi
  801c66:	53                   	push   %ebx
  801c67:	83 ec 10             	sub    $0x10,%esp
  801c6a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	8b 40 0c             	mov    0xc(%eax),%eax
  801c73:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801c78:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	b8 03 00 00 00       	mov    $0x3,%eax
  801c88:	e8 f2 fe ff ff       	call   801b7f <fsipc>
  801c8d:	89 c3                	mov    %eax,%ebx
  801c8f:	85 c0                	test   %eax,%eax
  801c91:	78 6a                	js     801cfd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801c93:	39 c6                	cmp    %eax,%esi
  801c95:	73 24                	jae    801cbb <devfile_read+0x59>
  801c97:	c7 44 24 0c fd 2b 80 	movl   $0x802bfd,0xc(%esp)
  801c9e:	00 
  801c9f:	c7 44 24 08 04 2c 80 	movl   $0x802c04,0x8(%esp)
  801ca6:	00 
  801ca7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  801cae:	00 
  801caf:	c7 04 24 19 2c 80 00 	movl   $0x802c19,(%esp)
  801cb6:	e8 6b e9 ff ff       	call   800626 <_panic>
	assert(r <= PGSIZE);
  801cbb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc0:	7e 24                	jle    801ce6 <devfile_read+0x84>
  801cc2:	c7 44 24 0c 24 2c 80 	movl   $0x802c24,0xc(%esp)
  801cc9:	00 
  801cca:	c7 44 24 08 04 2c 80 	movl   $0x802c04,0x8(%esp)
  801cd1:	00 
  801cd2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801cd9:	00 
  801cda:	c7 04 24 19 2c 80 00 	movl   $0x802c19,(%esp)
  801ce1:	e8 40 e9 ff ff       	call   800626 <_panic>
	memmove(buf, &fsipcbuf, r);
  801ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cea:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801cf1:	00 
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	89 04 24             	mov    %eax,(%esp)
  801cf8:	e8 79 f2 ff ff       	call   800f76 <memmove>
	return r;
}
  801cfd:	89 d8                	mov    %ebx,%eax
  801cff:	83 c4 10             	add    $0x10,%esp
  801d02:	5b                   	pop    %ebx
  801d03:	5e                   	pop    %esi
  801d04:	5d                   	pop    %ebp
  801d05:	c3                   	ret    

00801d06 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	53                   	push   %ebx
  801d0a:	83 ec 24             	sub    $0x24,%esp
  801d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d10:	89 1c 24             	mov    %ebx,(%esp)
  801d13:	e8 08 f0 ff ff       	call   800d20 <strlen>
  801d18:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d1d:	7f 60                	jg     801d7f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d1f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 4d f8 ff ff       	call   801577 <fd_alloc>
  801d2a:	89 c2                	mov    %eax,%edx
  801d2c:	85 d2                	test   %edx,%edx
  801d2e:	78 54                	js     801d84 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d34:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801d3b:	e8 3b f0 ff ff       	call   800d7b <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d43:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d50:	e8 2a fe ff ff       	call   801b7f <fsipc>
  801d55:	89 c3                	mov    %eax,%ebx
  801d57:	85 c0                	test   %eax,%eax
  801d59:	79 17                	jns    801d72 <open+0x6c>
		fd_close(fd, 0);
  801d5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d62:	00 
  801d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d66:	89 04 24             	mov    %eax,(%esp)
  801d69:	e8 44 f9 ff ff       	call   8016b2 <fd_close>
		return r;
  801d6e:	89 d8                	mov    %ebx,%eax
  801d70:	eb 12                	jmp    801d84 <open+0x7e>
	}
	return fd2num(fd);
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	89 04 24             	mov    %eax,(%esp)
  801d78:	e8 d3 f7 ff ff       	call   801550 <fd2num>
  801d7d:	eb 05                	jmp    801d84 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801d7f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  801d84:	83 c4 24             	add    $0x24,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    
  801d8a:	66 90                	xchg   %ax,%ax
  801d8c:	66 90                	xchg   %ax,%ax
  801d8e:	66 90                	xchg   %ax,%ax

00801d90 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	56                   	push   %esi
  801d94:	53                   	push   %ebx
  801d95:	83 ec 10             	sub    $0x10,%esp
  801d98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9e:	89 04 24             	mov    %eax,(%esp)
  801da1:	e8 ba f7 ff ff       	call   801560 <fd2data>
  801da6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801da8:	c7 44 24 04 30 2c 80 	movl   $0x802c30,0x4(%esp)
  801daf:	00 
  801db0:	89 1c 24             	mov    %ebx,(%esp)
  801db3:	e8 c3 ef ff ff       	call   800d7b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801db8:	8b 46 04             	mov    0x4(%esi),%eax
  801dbb:	2b 06                	sub    (%esi),%eax
  801dbd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dc3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801dca:	00 00 00 
	stat->st_dev = &devpipe;
  801dcd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801dd4:	30 80 00 
	return 0;
}
  801dd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ddc:	83 c4 10             	add    $0x10,%esp
  801ddf:	5b                   	pop    %ebx
  801de0:	5e                   	pop    %esi
  801de1:	5d                   	pop    %ebp
  801de2:	c3                   	ret    

00801de3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	53                   	push   %ebx
  801de7:	83 ec 14             	sub    $0x14,%esp
  801dea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ded:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801df1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df8:	e8 d3 f4 ff ff       	call   8012d0 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dfd:	89 1c 24             	mov    %ebx,(%esp)
  801e00:	e8 5b f7 ff ff       	call   801560 <fd2data>
  801e05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e10:	e8 bb f4 ff ff       	call   8012d0 <sys_page_unmap>
}
  801e15:	83 c4 14             	add    $0x14,%esp
  801e18:	5b                   	pop    %ebx
  801e19:	5d                   	pop    %ebp
  801e1a:	c3                   	ret    

00801e1b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	57                   	push   %edi
  801e1f:	56                   	push   %esi
  801e20:	53                   	push   %ebx
  801e21:	83 ec 2c             	sub    $0x2c,%esp
  801e24:	89 c6                	mov    %eax,%esi
  801e26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e29:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801e2e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e31:	89 34 24             	mov    %esi,(%esp)
  801e34:	e8 d3 05 00 00       	call   80240c <pageref>
  801e39:	89 c7                	mov    %eax,%edi
  801e3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e3e:	89 04 24             	mov    %eax,(%esp)
  801e41:	e8 c6 05 00 00       	call   80240c <pageref>
  801e46:	39 c7                	cmp    %eax,%edi
  801e48:	0f 94 c2             	sete   %dl
  801e4b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e4e:	8b 0d b0 40 80 00    	mov    0x8040b0,%ecx
  801e54:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e57:	39 fb                	cmp    %edi,%ebx
  801e59:	74 21                	je     801e7c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e5b:	84 d2                	test   %dl,%dl
  801e5d:	74 ca                	je     801e29 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e5f:	8b 51 58             	mov    0x58(%ecx),%edx
  801e62:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e66:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e6e:	c7 04 24 37 2c 80 00 	movl   $0x802c37,(%esp)
  801e75:	e8 a5 e8 ff ff       	call   80071f <cprintf>
  801e7a:	eb ad                	jmp    801e29 <_pipeisclosed+0xe>
	}
}
  801e7c:	83 c4 2c             	add    $0x2c,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	57                   	push   %edi
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 1c             	sub    $0x1c,%esp
  801e8d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e90:	89 34 24             	mov    %esi,(%esp)
  801e93:	e8 c8 f6 ff ff       	call   801560 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e9c:	74 61                	je     801eff <devpipe_write+0x7b>
  801e9e:	89 c3                	mov    %eax,%ebx
  801ea0:	bf 00 00 00 00       	mov    $0x0,%edi
  801ea5:	eb 4a                	jmp    801ef1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801ea7:	89 da                	mov    %ebx,%edx
  801ea9:	89 f0                	mov    %esi,%eax
  801eab:	e8 6b ff ff ff       	call   801e1b <_pipeisclosed>
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	75 54                	jne    801f08 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801eb4:	e8 51 f3 ff ff       	call   80120a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb9:	8b 43 04             	mov    0x4(%ebx),%eax
  801ebc:	8b 0b                	mov    (%ebx),%ecx
  801ebe:	8d 51 20             	lea    0x20(%ecx),%edx
  801ec1:	39 d0                	cmp    %edx,%eax
  801ec3:	73 e2                	jae    801ea7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ec8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801ecc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801ecf:	99                   	cltd   
  801ed0:	c1 ea 1b             	shr    $0x1b,%edx
  801ed3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801ed6:	83 e1 1f             	and    $0x1f,%ecx
  801ed9:	29 d1                	sub    %edx,%ecx
  801edb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801edf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ee3:	83 c0 01             	add    $0x1,%eax
  801ee6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ee9:	83 c7 01             	add    $0x1,%edi
  801eec:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eef:	74 13                	je     801f04 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ef1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ef4:	8b 0b                	mov    (%ebx),%ecx
  801ef6:	8d 51 20             	lea    0x20(%ecx),%edx
  801ef9:	39 d0                	cmp    %edx,%eax
  801efb:	73 aa                	jae    801ea7 <devpipe_write+0x23>
  801efd:	eb c6                	jmp    801ec5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eff:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801f04:	89 f8                	mov    %edi,%eax
  801f06:	eb 05                	jmp    801f0d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f08:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801f0d:	83 c4 1c             	add    $0x1c,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    

00801f15 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	57                   	push   %edi
  801f19:	56                   	push   %esi
  801f1a:	53                   	push   %ebx
  801f1b:	83 ec 1c             	sub    $0x1c,%esp
  801f1e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801f21:	89 3c 24             	mov    %edi,(%esp)
  801f24:	e8 37 f6 ff ff       	call   801560 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f2d:	74 54                	je     801f83 <devpipe_read+0x6e>
  801f2f:	89 c3                	mov    %eax,%ebx
  801f31:	be 00 00 00 00       	mov    $0x0,%esi
  801f36:	eb 3e                	jmp    801f76 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801f38:	89 f0                	mov    %esi,%eax
  801f3a:	eb 55                	jmp    801f91 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f3c:	89 da                	mov    %ebx,%edx
  801f3e:	89 f8                	mov    %edi,%eax
  801f40:	e8 d6 fe ff ff       	call   801e1b <_pipeisclosed>
  801f45:	85 c0                	test   %eax,%eax
  801f47:	75 43                	jne    801f8c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f49:	e8 bc f2 ff ff       	call   80120a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f4e:	8b 03                	mov    (%ebx),%eax
  801f50:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f53:	74 e7                	je     801f3c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f55:	99                   	cltd   
  801f56:	c1 ea 1b             	shr    $0x1b,%edx
  801f59:	01 d0                	add    %edx,%eax
  801f5b:	83 e0 1f             	and    $0x1f,%eax
  801f5e:	29 d0                	sub    %edx,%eax
  801f60:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f68:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f6b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f6e:	83 c6 01             	add    $0x1,%esi
  801f71:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f74:	74 12                	je     801f88 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  801f76:	8b 03                	mov    (%ebx),%eax
  801f78:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f7b:	75 d8                	jne    801f55 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f7d:	85 f6                	test   %esi,%esi
  801f7f:	75 b7                	jne    801f38 <devpipe_read+0x23>
  801f81:	eb b9                	jmp    801f3c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f83:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f88:	89 f0                	mov    %esi,%eax
  801f8a:	eb 05                	jmp    801f91 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f91:	83 c4 1c             	add    $0x1c,%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5e                   	pop    %esi
  801f96:	5f                   	pop    %edi
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    

00801f99 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	56                   	push   %esi
  801f9d:	53                   	push   %ebx
  801f9e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fa1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa4:	89 04 24             	mov    %eax,(%esp)
  801fa7:	e8 cb f5 ff ff       	call   801577 <fd_alloc>
  801fac:	89 c2                	mov    %eax,%edx
  801fae:	85 d2                	test   %edx,%edx
  801fb0:	0f 88 4d 01 00 00    	js     802103 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fbd:	00 
  801fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fcc:	e8 58 f2 ff ff       	call   801229 <sys_page_alloc>
  801fd1:	89 c2                	mov    %eax,%edx
  801fd3:	85 d2                	test   %edx,%edx
  801fd5:	0f 88 28 01 00 00    	js     802103 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fde:	89 04 24             	mov    %eax,(%esp)
  801fe1:	e8 91 f5 ff ff       	call   801577 <fd_alloc>
  801fe6:	89 c3                	mov    %eax,%ebx
  801fe8:	85 c0                	test   %eax,%eax
  801fea:	0f 88 fe 00 00 00    	js     8020ee <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ff7:	00 
  801ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802006:	e8 1e f2 ff ff       	call   801229 <sys_page_alloc>
  80200b:	89 c3                	mov    %eax,%ebx
  80200d:	85 c0                	test   %eax,%eax
  80200f:	0f 88 d9 00 00 00    	js     8020ee <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	89 04 24             	mov    %eax,(%esp)
  80201b:	e8 40 f5 ff ff       	call   801560 <fd2data>
  802020:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802022:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802029:	00 
  80202a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802035:	e8 ef f1 ff ff       	call   801229 <sys_page_alloc>
  80203a:	89 c3                	mov    %eax,%ebx
  80203c:	85 c0                	test   %eax,%eax
  80203e:	0f 88 97 00 00 00    	js     8020db <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802047:	89 04 24             	mov    %eax,(%esp)
  80204a:	e8 11 f5 ff ff       	call   801560 <fd2data>
  80204f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802056:	00 
  802057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80205b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802062:	00 
  802063:	89 74 24 04          	mov    %esi,0x4(%esp)
  802067:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80206e:	e8 0a f2 ff ff       	call   80127d <sys_page_map>
  802073:	89 c3                	mov    %eax,%ebx
  802075:	85 c0                	test   %eax,%eax
  802077:	78 52                	js     8020cb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802079:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802084:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802087:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  80208e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  802094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802097:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802099:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 a2 f4 ff ff       	call   801550 <fd2num>
  8020ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020b1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8020b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b6:	89 04 24             	mov    %eax,(%esp)
  8020b9:	e8 92 f4 ff ff       	call   801550 <fd2num>
  8020be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020c1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8020c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c9:	eb 38                	jmp    802103 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8020cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d6:	e8 f5 f1 ff ff       	call   8012d0 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020e9:	e8 e2 f1 ff ff       	call   8012d0 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020fc:	e8 cf f1 ff ff       	call   8012d0 <sys_page_unmap>
  802101:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  802103:	83 c4 30             	add    $0x30,%esp
  802106:	5b                   	pop    %ebx
  802107:	5e                   	pop    %esi
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    

0080210a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802113:	89 44 24 04          	mov    %eax,0x4(%esp)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	89 04 24             	mov    %eax,(%esp)
  80211d:	e8 c9 f4 ff ff       	call   8015eb <fd_lookup>
  802122:	89 c2                	mov    %eax,%edx
  802124:	85 d2                	test   %edx,%edx
  802126:	78 15                	js     80213d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 2d f4 ff ff       	call   801560 <fd2data>
	return _pipeisclosed(fd, p);
  802133:	89 c2                	mov    %eax,%edx
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	e8 de fc ff ff       	call   801e1b <_pipeisclosed>
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    
  80213f:	90                   	nop

00802140 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802143:	b8 00 00 00 00       	mov    $0x0,%eax
  802148:	5d                   	pop    %ebp
  802149:	c3                   	ret    

0080214a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
  80214d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802150:	c7 44 24 04 4f 2c 80 	movl   $0x802c4f,0x4(%esp)
  802157:	00 
  802158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 18 ec ff ff       	call   800d7b <strcpy>
	return 0;
}
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	57                   	push   %edi
  80216e:	56                   	push   %esi
  80216f:	53                   	push   %ebx
  802170:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802176:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80217a:	74 4a                	je     8021c6 <devcons_write+0x5c>
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
  802181:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802186:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80218c:	8b 75 10             	mov    0x10(%ebp),%esi
  80218f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  802191:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802194:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802199:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80219c:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021a0:	03 45 0c             	add    0xc(%ebp),%eax
  8021a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a7:	89 3c 24             	mov    %edi,(%esp)
  8021aa:	e8 c7 ed ff ff       	call   800f76 <memmove>
		sys_cputs(buf, m);
  8021af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021b3:	89 3c 24             	mov    %edi,(%esp)
  8021b6:	e8 a1 ef ff ff       	call   80115c <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8021bb:	01 f3                	add    %esi,%ebx
  8021bd:	89 d8                	mov    %ebx,%eax
  8021bf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8021c2:	72 c8                	jb     80218c <devcons_write+0x22>
  8021c4:	eb 05                	jmp    8021cb <devcons_write+0x61>
  8021c6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8021cb:	89 d8                	mov    %ebx,%eax
  8021cd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5f                   	pop    %edi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8021de:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8021e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e7:	75 07                	jne    8021f0 <devcons_read+0x18>
  8021e9:	eb 28                	jmp    802213 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021eb:	e8 1a f0 ff ff       	call   80120a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021f0:	e8 85 ef ff ff       	call   80117a <sys_cgetc>
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 f2                	je     8021eb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	78 16                	js     802213 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021fd:	83 f8 04             	cmp    $0x4,%eax
  802200:	74 0c                	je     80220e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802202:	8b 55 0c             	mov    0xc(%ebp),%edx
  802205:	88 02                	mov    %al,(%edx)
	return 1;
  802207:	b8 01 00 00 00       	mov    $0x1,%eax
  80220c:	eb 05                	jmp    802213 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80220e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802213:	c9                   	leave  
  802214:	c3                   	ret    

00802215 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802221:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802228:	00 
  802229:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80222c:	89 04 24             	mov    %eax,(%esp)
  80222f:	e8 28 ef ff ff       	call   80115c <sys_cputs>
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <getchar>:

int
getchar(void)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80223c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802243:	00 
  802244:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80224b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802252:	e8 3f f6 ff ff       	call   801896 <read>
	if (r < 0)
  802257:	85 c0                	test   %eax,%eax
  802259:	78 0f                	js     80226a <getchar+0x34>
		return r;
	if (r < 1)
  80225b:	85 c0                	test   %eax,%eax
  80225d:	7e 06                	jle    802265 <getchar+0x2f>
		return -E_EOF;
	return c;
  80225f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802263:	eb 05                	jmp    80226a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802265:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802272:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802275:	89 44 24 04          	mov    %eax,0x4(%esp)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	89 04 24             	mov    %eax,(%esp)
  80227f:	e8 67 f3 ff ff       	call   8015eb <fd_lookup>
  802284:	85 c0                	test   %eax,%eax
  802286:	78 11                	js     802299 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  802291:	39 10                	cmp    %edx,(%eax)
  802293:	0f 94 c0             	sete   %al
  802296:	0f b6 c0             	movzbl %al,%eax
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <opencons>:

int
opencons(void)
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022a4:	89 04 24             	mov    %eax,(%esp)
  8022a7:	e8 cb f2 ff ff       	call   801577 <fd_alloc>
		return r;
  8022ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	78 40                	js     8022f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022b9:	00 
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c8:	e8 5c ef ff ff       	call   801229 <sys_page_alloc>
		return r;
  8022cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 1f                	js     8022f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8022d3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8022d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8022e8:	89 04 24             	mov    %eax,(%esp)
  8022eb:	e8 60 f2 ff ff       	call   801550 <fd2num>
  8022f0:	89 c2                	mov    %eax,%edx
}
  8022f2:	89 d0                	mov    %edx,%eax
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	56                   	push   %esi
  8022fa:	53                   	push   %ebx
  8022fb:	83 ec 10             	sub    $0x10,%esp
  8022fe:	8b 75 08             	mov    0x8(%ebp),%esi
  802301:	8b 45 0c             	mov    0xc(%ebp),%eax
  802304:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  802307:	85 c0                	test   %eax,%eax
  802309:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80230e:	0f 44 c2             	cmove  %edx,%eax
  802311:	89 04 24             	mov    %eax,(%esp)
  802314:	e8 26 f1 ff ff       	call   80143f <sys_ipc_recv>
	if (err_code < 0) {
  802319:	85 c0                	test   %eax,%eax
  80231b:	79 16                	jns    802333 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  80231d:	85 f6                	test   %esi,%esi
  80231f:	74 06                	je     802327 <ipc_recv+0x31>
  802321:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  802327:	85 db                	test   %ebx,%ebx
  802329:	74 2c                	je     802357 <ipc_recv+0x61>
  80232b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802331:	eb 24                	jmp    802357 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  802333:	85 f6                	test   %esi,%esi
  802335:	74 0a                	je     802341 <ipc_recv+0x4b>
  802337:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80233c:	8b 40 74             	mov    0x74(%eax),%eax
  80233f:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  802341:	85 db                	test   %ebx,%ebx
  802343:	74 0a                	je     80234f <ipc_recv+0x59>
  802345:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80234a:	8b 40 78             	mov    0x78(%eax),%eax
  80234d:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  80234f:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  802354:	8b 40 70             	mov    0x70(%eax),%eax
}
  802357:	83 c4 10             	add    $0x10,%esp
  80235a:	5b                   	pop    %ebx
  80235b:	5e                   	pop    %esi
  80235c:	5d                   	pop    %ebp
  80235d:	c3                   	ret    

0080235e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80235e:	55                   	push   %ebp
  80235f:	89 e5                	mov    %esp,%ebp
  802361:	57                   	push   %edi
  802362:	56                   	push   %esi
  802363:	53                   	push   %ebx
  802364:	83 ec 1c             	sub    $0x1c,%esp
  802367:	8b 7d 08             	mov    0x8(%ebp),%edi
  80236a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80236d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802370:	eb 25                	jmp    802397 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  802372:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802375:	74 20                	je     802397 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  802377:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80237b:	c7 44 24 08 5b 2c 80 	movl   $0x802c5b,0x8(%esp)
  802382:	00 
  802383:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80238a:	00 
  80238b:	c7 04 24 67 2c 80 00 	movl   $0x802c67,(%esp)
  802392:	e8 8f e2 ff ff       	call   800626 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  802397:	85 db                	test   %ebx,%ebx
  802399:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80239e:	0f 45 c3             	cmovne %ebx,%eax
  8023a1:	8b 55 14             	mov    0x14(%ebp),%edx
  8023a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8023a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b0:	89 3c 24             	mov    %edi,(%esp)
  8023b3:	e8 64 f0 ff ff       	call   80141c <sys_ipc_try_send>
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	75 b6                	jne    802372 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  8023bc:	83 c4 1c             	add    $0x1c,%esp
  8023bf:	5b                   	pop    %ebx
  8023c0:	5e                   	pop    %esi
  8023c1:	5f                   	pop    %edi
  8023c2:	5d                   	pop    %ebp
  8023c3:	c3                   	ret    

008023c4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
  8023c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  8023ca:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  8023cf:	39 c8                	cmp    %ecx,%eax
  8023d1:	74 17                	je     8023ea <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023d3:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  8023d8:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8023db:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8023e1:	8b 52 50             	mov    0x50(%edx),%edx
  8023e4:	39 ca                	cmp    %ecx,%edx
  8023e6:	75 14                	jne    8023fc <ipc_find_env+0x38>
  8023e8:	eb 05                	jmp    8023ef <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ea:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  8023ef:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023f2:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023f7:	8b 40 40             	mov    0x40(%eax),%eax
  8023fa:	eb 0e                	jmp    80240a <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023fc:	83 c0 01             	add    $0x1,%eax
  8023ff:	3d 00 04 00 00       	cmp    $0x400,%eax
  802404:	75 d2                	jne    8023d8 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802406:	66 b8 00 00          	mov    $0x0,%ax
}
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    

0080240c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802412:	89 d0                	mov    %edx,%eax
  802414:	c1 e8 16             	shr    $0x16,%eax
  802417:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80241e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802423:	f6 c1 01             	test   $0x1,%cl
  802426:	74 1d                	je     802445 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802428:	c1 ea 0c             	shr    $0xc,%edx
  80242b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802432:	f6 c2 01             	test   $0x1,%dl
  802435:	74 0e                	je     802445 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802437:	c1 ea 0c             	shr    $0xc,%edx
  80243a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802441:	ef 
  802442:	0f b7 c0             	movzwl %ax,%eax
}
  802445:	5d                   	pop    %ebp
  802446:	c3                   	ret    
  802447:	66 90                	xchg   %ax,%ax
  802449:	66 90                	xchg   %ax,%ax
  80244b:	66 90                	xchg   %ax,%ax
  80244d:	66 90                	xchg   %ax,%ax
  80244f:	90                   	nop

00802450 <__udivdi3>:
  802450:	55                   	push   %ebp
  802451:	57                   	push   %edi
  802452:	56                   	push   %esi
  802453:	83 ec 0c             	sub    $0xc,%esp
  802456:	8b 44 24 28          	mov    0x28(%esp),%eax
  80245a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80245e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802462:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802466:	85 c0                	test   %eax,%eax
  802468:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80246c:	89 ea                	mov    %ebp,%edx
  80246e:	89 0c 24             	mov    %ecx,(%esp)
  802471:	75 2d                	jne    8024a0 <__udivdi3+0x50>
  802473:	39 e9                	cmp    %ebp,%ecx
  802475:	77 61                	ja     8024d8 <__udivdi3+0x88>
  802477:	85 c9                	test   %ecx,%ecx
  802479:	89 ce                	mov    %ecx,%esi
  80247b:	75 0b                	jne    802488 <__udivdi3+0x38>
  80247d:	b8 01 00 00 00       	mov    $0x1,%eax
  802482:	31 d2                	xor    %edx,%edx
  802484:	f7 f1                	div    %ecx
  802486:	89 c6                	mov    %eax,%esi
  802488:	31 d2                	xor    %edx,%edx
  80248a:	89 e8                	mov    %ebp,%eax
  80248c:	f7 f6                	div    %esi
  80248e:	89 c5                	mov    %eax,%ebp
  802490:	89 f8                	mov    %edi,%eax
  802492:	f7 f6                	div    %esi
  802494:	89 ea                	mov    %ebp,%edx
  802496:	83 c4 0c             	add    $0xc,%esp
  802499:	5e                   	pop    %esi
  80249a:	5f                   	pop    %edi
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    
  80249d:	8d 76 00             	lea    0x0(%esi),%esi
  8024a0:	39 e8                	cmp    %ebp,%eax
  8024a2:	77 24                	ja     8024c8 <__udivdi3+0x78>
  8024a4:	0f bd e8             	bsr    %eax,%ebp
  8024a7:	83 f5 1f             	xor    $0x1f,%ebp
  8024aa:	75 3c                	jne    8024e8 <__udivdi3+0x98>
  8024ac:	8b 74 24 04          	mov    0x4(%esp),%esi
  8024b0:	39 34 24             	cmp    %esi,(%esp)
  8024b3:	0f 86 9f 00 00 00    	jbe    802558 <__udivdi3+0x108>
  8024b9:	39 d0                	cmp    %edx,%eax
  8024bb:	0f 82 97 00 00 00    	jb     802558 <__udivdi3+0x108>
  8024c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	31 d2                	xor    %edx,%edx
  8024ca:	31 c0                	xor    %eax,%eax
  8024cc:	83 c4 0c             	add    $0xc,%esp
  8024cf:	5e                   	pop    %esi
  8024d0:	5f                   	pop    %edi
  8024d1:	5d                   	pop    %ebp
  8024d2:	c3                   	ret    
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	89 f8                	mov    %edi,%eax
  8024da:	f7 f1                	div    %ecx
  8024dc:	31 d2                	xor    %edx,%edx
  8024de:	83 c4 0c             	add    $0xc,%esp
  8024e1:	5e                   	pop    %esi
  8024e2:	5f                   	pop    %edi
  8024e3:	5d                   	pop    %ebp
  8024e4:	c3                   	ret    
  8024e5:	8d 76 00             	lea    0x0(%esi),%esi
  8024e8:	89 e9                	mov    %ebp,%ecx
  8024ea:	8b 3c 24             	mov    (%esp),%edi
  8024ed:	d3 e0                	shl    %cl,%eax
  8024ef:	89 c6                	mov    %eax,%esi
  8024f1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024f6:	29 e8                	sub    %ebp,%eax
  8024f8:	89 c1                	mov    %eax,%ecx
  8024fa:	d3 ef                	shr    %cl,%edi
  8024fc:	89 e9                	mov    %ebp,%ecx
  8024fe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802502:	8b 3c 24             	mov    (%esp),%edi
  802505:	09 74 24 08          	or     %esi,0x8(%esp)
  802509:	89 d6                	mov    %edx,%esi
  80250b:	d3 e7                	shl    %cl,%edi
  80250d:	89 c1                	mov    %eax,%ecx
  80250f:	89 3c 24             	mov    %edi,(%esp)
  802512:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802516:	d3 ee                	shr    %cl,%esi
  802518:	89 e9                	mov    %ebp,%ecx
  80251a:	d3 e2                	shl    %cl,%edx
  80251c:	89 c1                	mov    %eax,%ecx
  80251e:	d3 ef                	shr    %cl,%edi
  802520:	09 d7                	or     %edx,%edi
  802522:	89 f2                	mov    %esi,%edx
  802524:	89 f8                	mov    %edi,%eax
  802526:	f7 74 24 08          	divl   0x8(%esp)
  80252a:	89 d6                	mov    %edx,%esi
  80252c:	89 c7                	mov    %eax,%edi
  80252e:	f7 24 24             	mull   (%esp)
  802531:	39 d6                	cmp    %edx,%esi
  802533:	89 14 24             	mov    %edx,(%esp)
  802536:	72 30                	jb     802568 <__udivdi3+0x118>
  802538:	8b 54 24 04          	mov    0x4(%esp),%edx
  80253c:	89 e9                	mov    %ebp,%ecx
  80253e:	d3 e2                	shl    %cl,%edx
  802540:	39 c2                	cmp    %eax,%edx
  802542:	73 05                	jae    802549 <__udivdi3+0xf9>
  802544:	3b 34 24             	cmp    (%esp),%esi
  802547:	74 1f                	je     802568 <__udivdi3+0x118>
  802549:	89 f8                	mov    %edi,%eax
  80254b:	31 d2                	xor    %edx,%edx
  80254d:	e9 7a ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802558:	31 d2                	xor    %edx,%edx
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	e9 68 ff ff ff       	jmp    8024cc <__udivdi3+0x7c>
  802564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802568:	8d 47 ff             	lea    -0x1(%edi),%eax
  80256b:	31 d2                	xor    %edx,%edx
  80256d:	83 c4 0c             	add    $0xc,%esp
  802570:	5e                   	pop    %esi
  802571:	5f                   	pop    %edi
  802572:	5d                   	pop    %ebp
  802573:	c3                   	ret    
  802574:	66 90                	xchg   %ax,%ax
  802576:	66 90                	xchg   %ax,%ax
  802578:	66 90                	xchg   %ax,%ax
  80257a:	66 90                	xchg   %ax,%ax
  80257c:	66 90                	xchg   %ax,%ax
  80257e:	66 90                	xchg   %ax,%ax

00802580 <__umoddi3>:
  802580:	55                   	push   %ebp
  802581:	57                   	push   %edi
  802582:	56                   	push   %esi
  802583:	83 ec 14             	sub    $0x14,%esp
  802586:	8b 44 24 28          	mov    0x28(%esp),%eax
  80258a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80258e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802592:	89 c7                	mov    %eax,%edi
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	8b 44 24 30          	mov    0x30(%esp),%eax
  80259c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8025a0:	89 34 24             	mov    %esi,(%esp)
  8025a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025a7:	85 c0                	test   %eax,%eax
  8025a9:	89 c2                	mov    %eax,%edx
  8025ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025af:	75 17                	jne    8025c8 <__umoddi3+0x48>
  8025b1:	39 fe                	cmp    %edi,%esi
  8025b3:	76 4b                	jbe    802600 <__umoddi3+0x80>
  8025b5:	89 c8                	mov    %ecx,%eax
  8025b7:	89 fa                	mov    %edi,%edx
  8025b9:	f7 f6                	div    %esi
  8025bb:	89 d0                	mov    %edx,%eax
  8025bd:	31 d2                	xor    %edx,%edx
  8025bf:	83 c4 14             	add    $0x14,%esp
  8025c2:	5e                   	pop    %esi
  8025c3:	5f                   	pop    %edi
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    
  8025c6:	66 90                	xchg   %ax,%ax
  8025c8:	39 f8                	cmp    %edi,%eax
  8025ca:	77 54                	ja     802620 <__umoddi3+0xa0>
  8025cc:	0f bd e8             	bsr    %eax,%ebp
  8025cf:	83 f5 1f             	xor    $0x1f,%ebp
  8025d2:	75 5c                	jne    802630 <__umoddi3+0xb0>
  8025d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8025d8:	39 3c 24             	cmp    %edi,(%esp)
  8025db:	0f 87 e7 00 00 00    	ja     8026c8 <__umoddi3+0x148>
  8025e1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8025e5:	29 f1                	sub    %esi,%ecx
  8025e7:	19 c7                	sbb    %eax,%edi
  8025e9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025f1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025f9:	83 c4 14             	add    $0x14,%esp
  8025fc:	5e                   	pop    %esi
  8025fd:	5f                   	pop    %edi
  8025fe:	5d                   	pop    %ebp
  8025ff:	c3                   	ret    
  802600:	85 f6                	test   %esi,%esi
  802602:	89 f5                	mov    %esi,%ebp
  802604:	75 0b                	jne    802611 <__umoddi3+0x91>
  802606:	b8 01 00 00 00       	mov    $0x1,%eax
  80260b:	31 d2                	xor    %edx,%edx
  80260d:	f7 f6                	div    %esi
  80260f:	89 c5                	mov    %eax,%ebp
  802611:	8b 44 24 04          	mov    0x4(%esp),%eax
  802615:	31 d2                	xor    %edx,%edx
  802617:	f7 f5                	div    %ebp
  802619:	89 c8                	mov    %ecx,%eax
  80261b:	f7 f5                	div    %ebp
  80261d:	eb 9c                	jmp    8025bb <__umoddi3+0x3b>
  80261f:	90                   	nop
  802620:	89 c8                	mov    %ecx,%eax
  802622:	89 fa                	mov    %edi,%edx
  802624:	83 c4 14             	add    $0x14,%esp
  802627:	5e                   	pop    %esi
  802628:	5f                   	pop    %edi
  802629:	5d                   	pop    %ebp
  80262a:	c3                   	ret    
  80262b:	90                   	nop
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	8b 04 24             	mov    (%esp),%eax
  802633:	be 20 00 00 00       	mov    $0x20,%esi
  802638:	89 e9                	mov    %ebp,%ecx
  80263a:	29 ee                	sub    %ebp,%esi
  80263c:	d3 e2                	shl    %cl,%edx
  80263e:	89 f1                	mov    %esi,%ecx
  802640:	d3 e8                	shr    %cl,%eax
  802642:	89 e9                	mov    %ebp,%ecx
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	8b 04 24             	mov    (%esp),%eax
  80264b:	09 54 24 04          	or     %edx,0x4(%esp)
  80264f:	89 fa                	mov    %edi,%edx
  802651:	d3 e0                	shl    %cl,%eax
  802653:	89 f1                	mov    %esi,%ecx
  802655:	89 44 24 08          	mov    %eax,0x8(%esp)
  802659:	8b 44 24 10          	mov    0x10(%esp),%eax
  80265d:	d3 ea                	shr    %cl,%edx
  80265f:	89 e9                	mov    %ebp,%ecx
  802661:	d3 e7                	shl    %cl,%edi
  802663:	89 f1                	mov    %esi,%ecx
  802665:	d3 e8                	shr    %cl,%eax
  802667:	89 e9                	mov    %ebp,%ecx
  802669:	09 f8                	or     %edi,%eax
  80266b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80266f:	f7 74 24 04          	divl   0x4(%esp)
  802673:	d3 e7                	shl    %cl,%edi
  802675:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802679:	89 d7                	mov    %edx,%edi
  80267b:	f7 64 24 08          	mull   0x8(%esp)
  80267f:	39 d7                	cmp    %edx,%edi
  802681:	89 c1                	mov    %eax,%ecx
  802683:	89 14 24             	mov    %edx,(%esp)
  802686:	72 2c                	jb     8026b4 <__umoddi3+0x134>
  802688:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80268c:	72 22                	jb     8026b0 <__umoddi3+0x130>
  80268e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802692:	29 c8                	sub    %ecx,%eax
  802694:	19 d7                	sbb    %edx,%edi
  802696:	89 e9                	mov    %ebp,%ecx
  802698:	89 fa                	mov    %edi,%edx
  80269a:	d3 e8                	shr    %cl,%eax
  80269c:	89 f1                	mov    %esi,%ecx
  80269e:	d3 e2                	shl    %cl,%edx
  8026a0:	89 e9                	mov    %ebp,%ecx
  8026a2:	d3 ef                	shr    %cl,%edi
  8026a4:	09 d0                	or     %edx,%eax
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 14             	add    $0x14,%esp
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	39 d7                	cmp    %edx,%edi
  8026b2:	75 da                	jne    80268e <__umoddi3+0x10e>
  8026b4:	8b 14 24             	mov    (%esp),%edx
  8026b7:	89 c1                	mov    %eax,%ecx
  8026b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8026bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8026c1:	eb cb                	jmp    80268e <__umoddi3+0x10e>
  8026c3:	90                   	nop
  8026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8026cc:	0f 82 0f ff ff ff    	jb     8025e1 <__umoddi3+0x61>
  8026d2:	e9 1a ff ff ff       	jmp    8025f1 <__umoddi3+0x71>
