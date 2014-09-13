
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 44 00 00 00       	call   800075 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800040:	00 
  800041:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800048:	ee 
  800049:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800050:	e8 7e 01 00 00       	call   8001d3 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800055:	c7 44 24 04 20 00 10 	movl   $0xf0100020,0x4(%esp)
  80005c:	f0 
  80005d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800064:	e8 0a 03 00 00       	call   800373 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800069:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800070:	00 00 00 
}
  800073:	c9                   	leave  
  800074:	c3                   	ret    

00800075 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800075:	55                   	push   %ebp
  800076:	89 e5                	mov    %esp,%ebp
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	83 ec 10             	sub    $0x10,%esp
  80007d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800083:	e8 0d 01 00 00       	call   800195 <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800088:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	74 17                	je     8000a9 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800092:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800097:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80009a:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  8000a0:	8b 49 40             	mov    0x40(%ecx),%ecx
  8000a3:	39 c1                	cmp    %eax,%ecx
  8000a5:	75 18                	jne    8000bf <libmain+0x4a>
  8000a7:	eb 05                	jmp    8000ae <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000a9:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  8000ae:	6b d2 7c             	imul   $0x7c,%edx,%edx
  8000b1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8000b7:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000bd:	eb 0b                	jmp    8000ca <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000bf:	83 c2 01             	add    $0x1,%edx
  8000c2:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000c8:	75 cd                	jne    800097 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ca:	85 db                	test   %ebx,%ebx
  8000cc:	7e 07                	jle    8000d5 <libmain+0x60>
		binaryname = argv[0];
  8000ce:	8b 06                	mov    (%esi),%eax
  8000d0:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d9:	89 1c 24             	mov    %ebx,(%esp)
  8000dc:	e8 52 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e1:	e8 07 00 00 00       	call   8000ed <exit>
}
  8000e6:	83 c4 10             	add    $0x10,%esp
  8000e9:	5b                   	pop    %ebx
  8000ea:	5e                   	pop    %esi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000f3:	e8 5e 05 00 00       	call   800656 <close_all>
	sys_env_destroy(0);
  8000f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ff:	e8 3f 00 00 00       	call   800143 <sys_env_destroy>
}
  800104:	c9                   	leave  
  800105:	c3                   	ret    

00800106 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800106:	55                   	push   %ebp
  800107:	89 e5                	mov    %esp,%ebp
  800109:	57                   	push   %edi
  80010a:	56                   	push   %esi
  80010b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80010c:	b8 00 00 00 00       	mov    $0x0,%eax
  800111:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800114:	8b 55 08             	mov    0x8(%ebp),%edx
  800117:	89 c3                	mov    %eax,%ebx
  800119:	89 c7                	mov    %eax,%edi
  80011b:	89 c6                	mov    %eax,%esi
  80011d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80011f:	5b                   	pop    %ebx
  800120:	5e                   	pop    %esi
  800121:	5f                   	pop    %edi
  800122:	5d                   	pop    %ebp
  800123:	c3                   	ret    

00800124 <sys_cgetc>:

int
sys_cgetc(void)
{
  800124:	55                   	push   %ebp
  800125:	89 e5                	mov    %esp,%ebp
  800127:	57                   	push   %edi
  800128:	56                   	push   %esi
  800129:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80012a:	ba 00 00 00 00       	mov    $0x0,%edx
  80012f:	b8 01 00 00 00       	mov    $0x1,%eax
  800134:	89 d1                	mov    %edx,%ecx
  800136:	89 d3                	mov    %edx,%ebx
  800138:	89 d7                	mov    %edx,%edi
  80013a:	89 d6                	mov    %edx,%esi
  80013c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80013e:	5b                   	pop    %ebx
  80013f:	5e                   	pop    %esi
  800140:	5f                   	pop    %edi
  800141:	5d                   	pop    %ebp
  800142:	c3                   	ret    

00800143 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	57                   	push   %edi
  800147:	56                   	push   %esi
  800148:	53                   	push   %ebx
  800149:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80014c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800151:	b8 03 00 00 00       	mov    $0x3,%eax
  800156:	8b 55 08             	mov    0x8(%ebp),%edx
  800159:	89 cb                	mov    %ecx,%ebx
  80015b:	89 cf                	mov    %ecx,%edi
  80015d:	89 ce                	mov    %ecx,%esi
  80015f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800161:	85 c0                	test   %eax,%eax
  800163:	7e 28                	jle    80018d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800165:	89 44 24 10          	mov    %eax,0x10(%esp)
  800169:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800170:	00 
  800171:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  800178:	00 
  800179:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800180:	00 
  800181:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  800188:	e8 59 10 00 00       	call   8011e6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80018d:	83 c4 2c             	add    $0x2c,%esp
  800190:	5b                   	pop    %ebx
  800191:	5e                   	pop    %esi
  800192:	5f                   	pop    %edi
  800193:	5d                   	pop    %ebp
  800194:	c3                   	ret    

00800195 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	57                   	push   %edi
  800199:	56                   	push   %esi
  80019a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80019b:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a0:	b8 02 00 00 00       	mov    $0x2,%eax
  8001a5:	89 d1                	mov    %edx,%ecx
  8001a7:	89 d3                	mov    %edx,%ebx
  8001a9:	89 d7                	mov    %edx,%edi
  8001ab:	89 d6                	mov    %edx,%esi
  8001ad:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8001af:	5b                   	pop    %ebx
  8001b0:	5e                   	pop    %esi
  8001b1:	5f                   	pop    %edi
  8001b2:	5d                   	pop    %ebp
  8001b3:	c3                   	ret    

008001b4 <sys_yield>:

void
sys_yield(void)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	57                   	push   %edi
  8001b8:	56                   	push   %esi
  8001b9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8001bf:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001c4:	89 d1                	mov    %edx,%ecx
  8001c6:	89 d3                	mov    %edx,%ebx
  8001c8:	89 d7                	mov    %edx,%edi
  8001ca:	89 d6                	mov    %edx,%esi
  8001cc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001ce:	5b                   	pop    %ebx
  8001cf:	5e                   	pop    %esi
  8001d0:	5f                   	pop    %edi
  8001d1:	5d                   	pop    %ebp
  8001d2:	c3                   	ret    

008001d3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	57                   	push   %edi
  8001d7:	56                   	push   %esi
  8001d8:	53                   	push   %ebx
  8001d9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001dc:	be 00 00 00 00       	mov    $0x0,%esi
  8001e1:	b8 04 00 00 00       	mov    $0x4,%eax
  8001e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001ef:	89 f7                	mov    %esi,%edi
  8001f1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001f3:	85 c0                	test   %eax,%eax
  8001f5:	7e 28                	jle    80021f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001fb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800202:	00 
  800203:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80020a:	00 
  80020b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800212:	00 
  800213:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80021a:	e8 c7 0f 00 00       	call   8011e6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80021f:	83 c4 2c             	add    $0x2c,%esp
  800222:	5b                   	pop    %ebx
  800223:	5e                   	pop    %esi
  800224:	5f                   	pop    %edi
  800225:	5d                   	pop    %ebp
  800226:	c3                   	ret    

00800227 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800227:	55                   	push   %ebp
  800228:	89 e5                	mov    %esp,%ebp
  80022a:	57                   	push   %edi
  80022b:	56                   	push   %esi
  80022c:	53                   	push   %ebx
  80022d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800230:	b8 05 00 00 00       	mov    $0x5,%eax
  800235:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800238:	8b 55 08             	mov    0x8(%ebp),%edx
  80023b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80023e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800241:	8b 75 18             	mov    0x18(%ebp),%esi
  800244:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800246:	85 c0                	test   %eax,%eax
  800248:	7e 28                	jle    800272 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80024a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80024e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800255:	00 
  800256:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80025d:	00 
  80025e:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800265:	00 
  800266:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80026d:	e8 74 0f 00 00       	call   8011e6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800272:	83 c4 2c             	add    $0x2c,%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	57                   	push   %edi
  80027e:	56                   	push   %esi
  80027f:	53                   	push   %ebx
  800280:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800283:	bb 00 00 00 00       	mov    $0x0,%ebx
  800288:	b8 06 00 00 00       	mov    $0x6,%eax
  80028d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800290:	8b 55 08             	mov    0x8(%ebp),%edx
  800293:	89 df                	mov    %ebx,%edi
  800295:	89 de                	mov    %ebx,%esi
  800297:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800299:	85 c0                	test   %eax,%eax
  80029b:	7e 28                	jle    8002c5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80029d:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002a1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8002a8:	00 
  8002a9:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  8002b0:	00 
  8002b1:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002b8:	00 
  8002b9:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  8002c0:	e8 21 0f 00 00       	call   8011e6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002c5:	83 c4 2c             	add    $0x2c,%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    

008002cd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	57                   	push   %edi
  8002d1:	56                   	push   %esi
  8002d2:	53                   	push   %ebx
  8002d3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002d6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002db:	b8 08 00 00 00       	mov    $0x8,%eax
  8002e0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002e6:	89 df                	mov    %ebx,%edi
  8002e8:	89 de                	mov    %ebx,%esi
  8002ea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002ec:	85 c0                	test   %eax,%eax
  8002ee:	7e 28                	jle    800318 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002f4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002fb:	00 
  8002fc:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  800303:	00 
  800304:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80030b:	00 
  80030c:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  800313:	e8 ce 0e 00 00       	call   8011e6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800318:	83 c4 2c             	add    $0x2c,%esp
  80031b:	5b                   	pop    %ebx
  80031c:	5e                   	pop    %esi
  80031d:	5f                   	pop    %edi
  80031e:	5d                   	pop    %ebp
  80031f:	c3                   	ret    

00800320 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	57                   	push   %edi
  800324:	56                   	push   %esi
  800325:	53                   	push   %ebx
  800326:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800329:	bb 00 00 00 00       	mov    $0x0,%ebx
  80032e:	b8 09 00 00 00       	mov    $0x9,%eax
  800333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800336:	8b 55 08             	mov    0x8(%ebp),%edx
  800339:	89 df                	mov    %ebx,%edi
  80033b:	89 de                	mov    %ebx,%esi
  80033d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80033f:	85 c0                	test   %eax,%eax
  800341:	7e 28                	jle    80036b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800343:	89 44 24 10          	mov    %eax,0x10(%esp)
  800347:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80034e:	00 
  80034f:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  800356:	00 
  800357:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80035e:	00 
  80035f:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  800366:	e8 7b 0e 00 00       	call   8011e6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80036b:	83 c4 2c             	add    $0x2c,%esp
  80036e:	5b                   	pop    %ebx
  80036f:	5e                   	pop    %esi
  800370:	5f                   	pop    %edi
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	57                   	push   %edi
  800377:	56                   	push   %esi
  800378:	53                   	push   %ebx
  800379:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80037c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800381:	b8 0a 00 00 00       	mov    $0xa,%eax
  800386:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800389:	8b 55 08             	mov    0x8(%ebp),%edx
  80038c:	89 df                	mov    %ebx,%edi
  80038e:	89 de                	mov    %ebx,%esi
  800390:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800392:	85 c0                	test   %eax,%eax
  800394:	7e 28                	jle    8003be <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800396:	89 44 24 10          	mov    %eax,0x10(%esp)
  80039a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8003a1:	00 
  8003a2:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  8003a9:	00 
  8003aa:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8003b1:	00 
  8003b2:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  8003b9:	e8 28 0e 00 00       	call   8011e6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003be:	83 c4 2c             	add    $0x2c,%esp
  8003c1:	5b                   	pop    %ebx
  8003c2:	5e                   	pop    %esi
  8003c3:	5f                   	pop    %edi
  8003c4:	5d                   	pop    %ebp
  8003c5:	c3                   	ret    

008003c6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003c6:	55                   	push   %ebp
  8003c7:	89 e5                	mov    %esp,%ebp
  8003c9:	57                   	push   %edi
  8003ca:	56                   	push   %esi
  8003cb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003cc:	be 00 00 00 00       	mov    $0x0,%esi
  8003d1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8003d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003e2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003e4:	5b                   	pop    %ebx
  8003e5:	5e                   	pop    %esi
  8003e6:	5f                   	pop    %edi
  8003e7:	5d                   	pop    %ebp
  8003e8:	c3                   	ret    

008003e9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	57                   	push   %edi
  8003ed:	56                   	push   %esi
  8003ee:	53                   	push   %ebx
  8003ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f7:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ff:	89 cb                	mov    %ecx,%ebx
  800401:	89 cf                	mov    %ecx,%edi
  800403:	89 ce                	mov    %ecx,%esi
  800405:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800407:	85 c0                	test   %eax,%eax
  800409:	7e 28                	jle    800433 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80040b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80040f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800416:	00 
  800417:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80041e:	00 
  80041f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800426:	00 
  800427:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80042e:	e8 b3 0d 00 00       	call   8011e6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800433:	83 c4 2c             	add    $0x2c,%esp
  800436:	5b                   	pop    %ebx
  800437:	5e                   	pop    %esi
  800438:	5f                   	pop    %edi
  800439:	5d                   	pop    %ebp
  80043a:	c3                   	ret    
  80043b:	66 90                	xchg   %ax,%ax
  80043d:	66 90                	xchg   %ax,%ax
  80043f:	90                   	nop

00800440 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	05 00 00 00 30       	add    $0x30000000,%eax
  80044b:	c1 e8 0c             	shr    $0xc,%eax
}
  80044e:	5d                   	pop    %ebp
  80044f:	c3                   	ret    

00800450 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80045b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800460:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80046a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80046f:	a8 01                	test   $0x1,%al
  800471:	74 34                	je     8004a7 <fd_alloc+0x40>
  800473:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800478:	a8 01                	test   $0x1,%al
  80047a:	74 32                	je     8004ae <fd_alloc+0x47>
  80047c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800481:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800483:	89 c2                	mov    %eax,%edx
  800485:	c1 ea 16             	shr    $0x16,%edx
  800488:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80048f:	f6 c2 01             	test   $0x1,%dl
  800492:	74 1f                	je     8004b3 <fd_alloc+0x4c>
  800494:	89 c2                	mov    %eax,%edx
  800496:	c1 ea 0c             	shr    $0xc,%edx
  800499:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004a0:	f6 c2 01             	test   $0x1,%dl
  8004a3:	75 1a                	jne    8004bf <fd_alloc+0x58>
  8004a5:	eb 0c                	jmp    8004b3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004a7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8004ac:	eb 05                	jmp    8004b3 <fd_alloc+0x4c>
  8004ae:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8004b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8004b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004bd:	eb 1a                	jmp    8004d9 <fd_alloc+0x72>
  8004bf:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8004c4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004c9:	75 b6                	jne    800481 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004d4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8004d9:	5d                   	pop    %ebp
  8004da:	c3                   	ret    

008004db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004e1:	83 f8 1f             	cmp    $0x1f,%eax
  8004e4:	77 36                	ja     80051c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004e6:	c1 e0 0c             	shl    $0xc,%eax
  8004e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004ee:	89 c2                	mov    %eax,%edx
  8004f0:	c1 ea 16             	shr    $0x16,%edx
  8004f3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004fa:	f6 c2 01             	test   $0x1,%dl
  8004fd:	74 24                	je     800523 <fd_lookup+0x48>
  8004ff:	89 c2                	mov    %eax,%edx
  800501:	c1 ea 0c             	shr    $0xc,%edx
  800504:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80050b:	f6 c2 01             	test   $0x1,%dl
  80050e:	74 1a                	je     80052a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800510:	8b 55 0c             	mov    0xc(%ebp),%edx
  800513:	89 02                	mov    %eax,(%edx)
	return 0;
  800515:	b8 00 00 00 00       	mov    $0x0,%eax
  80051a:	eb 13                	jmp    80052f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80051c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800521:	eb 0c                	jmp    80052f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800523:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800528:	eb 05                	jmp    80052f <fd_lookup+0x54>
  80052a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80052f:	5d                   	pop    %ebp
  800530:	c3                   	ret    

00800531 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	53                   	push   %ebx
  800535:	83 ec 14             	sub    $0x14,%esp
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80053e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800544:	75 1e                	jne    800564 <dev_lookup+0x33>
  800546:	eb 0e                	jmp    800556 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800548:	b8 20 30 80 00       	mov    $0x803020,%eax
  80054d:	eb 0c                	jmp    80055b <dev_lookup+0x2a>
  80054f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800554:	eb 05                	jmp    80055b <dev_lookup+0x2a>
  800556:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80055b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80055d:	b8 00 00 00 00       	mov    $0x0,%eax
  800562:	eb 38                	jmp    80059c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800564:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80056a:	74 dc                	je     800548 <dev_lookup+0x17>
  80056c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  800572:	74 db                	je     80054f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800574:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80057a:	8b 52 48             	mov    0x48(%edx),%edx
  80057d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800581:	89 54 24 04          	mov    %edx,0x4(%esp)
  800585:	c7 04 24 38 21 80 00 	movl   $0x802138,(%esp)
  80058c:	e8 4e 0d 00 00       	call   8012df <cprintf>
	*dev = 0;
  800591:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800597:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80059c:	83 c4 14             	add    $0x14,%esp
  80059f:	5b                   	pop    %ebx
  8005a0:	5d                   	pop    %ebp
  8005a1:	c3                   	ret    

008005a2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005a2:	55                   	push   %ebp
  8005a3:	89 e5                	mov    %esp,%ebp
  8005a5:	56                   	push   %esi
  8005a6:	53                   	push   %ebx
  8005a7:	83 ec 20             	sub    $0x20,%esp
  8005aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005b3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005b7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8005bd:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	e8 13 ff ff ff       	call   8004db <fd_lookup>
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	78 05                	js     8005d1 <fd_close+0x2f>
	    || fd != fd2)
  8005cc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8005cf:	74 0c                	je     8005dd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8005d1:	84 db                	test   %bl,%bl
  8005d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d8:	0f 44 c2             	cmove  %edx,%eax
  8005db:	eb 3f                	jmp    80061c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e4:	8b 06                	mov    (%esi),%eax
  8005e6:	89 04 24             	mov    %eax,(%esp)
  8005e9:	e8 43 ff ff ff       	call   800531 <dev_lookup>
  8005ee:	89 c3                	mov    %eax,%ebx
  8005f0:	85 c0                	test   %eax,%eax
  8005f2:	78 16                	js     80060a <fd_close+0x68>
		if (dev->dev_close)
  8005f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8005fa:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8005ff:	85 c0                	test   %eax,%eax
  800601:	74 07                	je     80060a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800603:	89 34 24             	mov    %esi,(%esp)
  800606:	ff d0                	call   *%eax
  800608:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80060a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800615:	e8 60 fc ff ff       	call   80027a <sys_page_unmap>
	return r;
  80061a:	89 d8                	mov    %ebx,%eax
}
  80061c:	83 c4 20             	add    $0x20,%esp
  80061f:	5b                   	pop    %ebx
  800620:	5e                   	pop    %esi
  800621:	5d                   	pop    %ebp
  800622:	c3                   	ret    

00800623 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800629:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	89 04 24             	mov    %eax,(%esp)
  800636:	e8 a0 fe ff ff       	call   8004db <fd_lookup>
  80063b:	89 c2                	mov    %eax,%edx
  80063d:	85 d2                	test   %edx,%edx
  80063f:	78 13                	js     800654 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800641:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800648:	00 
  800649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80064c:	89 04 24             	mov    %eax,(%esp)
  80064f:	e8 4e ff ff ff       	call   8005a2 <fd_close>
}
  800654:	c9                   	leave  
  800655:	c3                   	ret    

00800656 <close_all>:

void
close_all(void)
{
  800656:	55                   	push   %ebp
  800657:	89 e5                	mov    %esp,%ebp
  800659:	53                   	push   %ebx
  80065a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80065d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800662:	89 1c 24             	mov    %ebx,(%esp)
  800665:	e8 b9 ff ff ff       	call   800623 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80066a:	83 c3 01             	add    $0x1,%ebx
  80066d:	83 fb 20             	cmp    $0x20,%ebx
  800670:	75 f0                	jne    800662 <close_all+0xc>
		close(i);
}
  800672:	83 c4 14             	add    $0x14,%esp
  800675:	5b                   	pop    %ebx
  800676:	5d                   	pop    %ebp
  800677:	c3                   	ret    

00800678 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	57                   	push   %edi
  80067c:	56                   	push   %esi
  80067d:	53                   	push   %ebx
  80067e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800681:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800684:	89 44 24 04          	mov    %eax,0x4(%esp)
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	89 04 24             	mov    %eax,(%esp)
  80068e:	e8 48 fe ff ff       	call   8004db <fd_lookup>
  800693:	89 c2                	mov    %eax,%edx
  800695:	85 d2                	test   %edx,%edx
  800697:	0f 88 e1 00 00 00    	js     80077e <dup+0x106>
		return r;
	close(newfdnum);
  80069d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a0:	89 04 24             	mov    %eax,(%esp)
  8006a3:	e8 7b ff ff ff       	call   800623 <close>

	newfd = INDEX2FD(newfdnum);
  8006a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006ab:	c1 e3 0c             	shl    $0xc,%ebx
  8006ae:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8006b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b7:	89 04 24             	mov    %eax,(%esp)
  8006ba:	e8 91 fd ff ff       	call   800450 <fd2data>
  8006bf:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8006c1:	89 1c 24             	mov    %ebx,(%esp)
  8006c4:	e8 87 fd ff ff       	call   800450 <fd2data>
  8006c9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006cb:	89 f0                	mov    %esi,%eax
  8006cd:	c1 e8 16             	shr    $0x16,%eax
  8006d0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006d7:	a8 01                	test   $0x1,%al
  8006d9:	74 43                	je     80071e <dup+0xa6>
  8006db:	89 f0                	mov    %esi,%eax
  8006dd:	c1 e8 0c             	shr    $0xc,%eax
  8006e0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006e7:	f6 c2 01             	test   $0x1,%dl
  8006ea:	74 32                	je     80071e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006f3:	25 07 0e 00 00       	and    $0xe07,%eax
  8006f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006fc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800700:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800707:	00 
  800708:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800713:	e8 0f fb ff ff       	call   800227 <sys_page_map>
  800718:	89 c6                	mov    %eax,%esi
  80071a:	85 c0                	test   %eax,%eax
  80071c:	78 3e                	js     80075c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80071e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800721:	89 c2                	mov    %eax,%edx
  800723:	c1 ea 0c             	shr    $0xc,%edx
  800726:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80072d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800733:	89 54 24 10          	mov    %edx,0x10(%esp)
  800737:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80073b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800742:	00 
  800743:	89 44 24 04          	mov    %eax,0x4(%esp)
  800747:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80074e:	e8 d4 fa ff ff       	call   800227 <sys_page_map>
  800753:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800755:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800758:	85 f6                	test   %esi,%esi
  80075a:	79 22                	jns    80077e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80075c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800760:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800767:	e8 0e fb ff ff       	call   80027a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80076c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800770:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800777:	e8 fe fa ff ff       	call   80027a <sys_page_unmap>
	return r;
  80077c:	89 f0                	mov    %esi,%eax
}
  80077e:	83 c4 3c             	add    $0x3c,%esp
  800781:	5b                   	pop    %ebx
  800782:	5e                   	pop    %esi
  800783:	5f                   	pop    %edi
  800784:	5d                   	pop    %ebp
  800785:	c3                   	ret    

00800786 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800786:	55                   	push   %ebp
  800787:	89 e5                	mov    %esp,%ebp
  800789:	53                   	push   %ebx
  80078a:	83 ec 24             	sub    $0x24,%esp
  80078d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800790:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800793:	89 44 24 04          	mov    %eax,0x4(%esp)
  800797:	89 1c 24             	mov    %ebx,(%esp)
  80079a:	e8 3c fd ff ff       	call   8004db <fd_lookup>
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	85 d2                	test   %edx,%edx
  8007a3:	78 6d                	js     800812 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	89 04 24             	mov    %eax,(%esp)
  8007b4:	e8 78 fd ff ff       	call   800531 <dev_lookup>
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	78 55                	js     800812 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8007bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c0:	8b 50 08             	mov    0x8(%eax),%edx
  8007c3:	83 e2 03             	and    $0x3,%edx
  8007c6:	83 fa 01             	cmp    $0x1,%edx
  8007c9:	75 23                	jne    8007ee <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8007d0:	8b 40 48             	mov    0x48(%eax),%eax
  8007d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007db:	c7 04 24 79 21 80 00 	movl   $0x802179,(%esp)
  8007e2:	e8 f8 0a 00 00       	call   8012df <cprintf>
		return -E_INVAL;
  8007e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ec:	eb 24                	jmp    800812 <read+0x8c>
	}
	if (!dev->dev_read)
  8007ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f1:	8b 52 08             	mov    0x8(%edx),%edx
  8007f4:	85 d2                	test   %edx,%edx
  8007f6:	74 15                	je     80080d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007f8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800802:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800806:	89 04 24             	mov    %eax,(%esp)
  800809:	ff d2                	call   *%edx
  80080b:	eb 05                	jmp    800812 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80080d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800812:	83 c4 24             	add    $0x24,%esp
  800815:	5b                   	pop    %ebx
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	57                   	push   %edi
  80081c:	56                   	push   %esi
  80081d:	53                   	push   %ebx
  80081e:	83 ec 1c             	sub    $0x1c,%esp
  800821:	8b 7d 08             	mov    0x8(%ebp),%edi
  800824:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800827:	85 f6                	test   %esi,%esi
  800829:	74 33                	je     80085e <readn+0x46>
  80082b:	b8 00 00 00 00       	mov    $0x0,%eax
  800830:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800835:	89 f2                	mov    %esi,%edx
  800837:	29 c2                	sub    %eax,%edx
  800839:	89 54 24 08          	mov    %edx,0x8(%esp)
  80083d:	03 45 0c             	add    0xc(%ebp),%eax
  800840:	89 44 24 04          	mov    %eax,0x4(%esp)
  800844:	89 3c 24             	mov    %edi,(%esp)
  800847:	e8 3a ff ff ff       	call   800786 <read>
		if (m < 0)
  80084c:	85 c0                	test   %eax,%eax
  80084e:	78 1b                	js     80086b <readn+0x53>
			return m;
		if (m == 0)
  800850:	85 c0                	test   %eax,%eax
  800852:	74 11                	je     800865 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800854:	01 c3                	add    %eax,%ebx
  800856:	89 d8                	mov    %ebx,%eax
  800858:	39 f3                	cmp    %esi,%ebx
  80085a:	72 d9                	jb     800835 <readn+0x1d>
  80085c:	eb 0b                	jmp    800869 <readn+0x51>
  80085e:	b8 00 00 00 00       	mov    $0x0,%eax
  800863:	eb 06                	jmp    80086b <readn+0x53>
  800865:	89 d8                	mov    %ebx,%eax
  800867:	eb 02                	jmp    80086b <readn+0x53>
  800869:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80086b:	83 c4 1c             	add    $0x1c,%esp
  80086e:	5b                   	pop    %ebx
  80086f:	5e                   	pop    %esi
  800870:	5f                   	pop    %edi
  800871:	5d                   	pop    %ebp
  800872:	c3                   	ret    

00800873 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	53                   	push   %ebx
  800877:	83 ec 24             	sub    $0x24,%esp
  80087a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80087d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800880:	89 44 24 04          	mov    %eax,0x4(%esp)
  800884:	89 1c 24             	mov    %ebx,(%esp)
  800887:	e8 4f fc ff ff       	call   8004db <fd_lookup>
  80088c:	89 c2                	mov    %eax,%edx
  80088e:	85 d2                	test   %edx,%edx
  800890:	78 68                	js     8008fa <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800895:	89 44 24 04          	mov    %eax,0x4(%esp)
  800899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 8b fc ff ff       	call   800531 <dev_lookup>
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	78 50                	js     8008fa <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ad:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008b1:	75 23                	jne    8008d6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008b3:	a1 04 40 80 00       	mov    0x804004,%eax
  8008b8:	8b 40 48             	mov    0x48(%eax),%eax
  8008bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c3:	c7 04 24 95 21 80 00 	movl   $0x802195,(%esp)
  8008ca:	e8 10 0a 00 00       	call   8012df <cprintf>
		return -E_INVAL;
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d4:	eb 24                	jmp    8008fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	74 15                	je     8008f5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008ee:	89 04 24             	mov    %eax,(%esp)
  8008f1:	ff d2                	call   *%edx
  8008f3:	eb 05                	jmp    8008fa <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8008f5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8008fa:	83 c4 24             	add    $0x24,%esp
  8008fd:	5b                   	pop    %ebx
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <seek>:

int
seek(int fdnum, off_t offset)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800906:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	89 04 24             	mov    %eax,(%esp)
  800913:	e8 c3 fb ff ff       	call   8004db <fd_lookup>
  800918:	85 c0                	test   %eax,%eax
  80091a:	78 0e                	js     80092a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80091c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80091f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800922:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80092a:	c9                   	leave  
  80092b:	c3                   	ret    

0080092c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	53                   	push   %ebx
  800930:	83 ec 24             	sub    $0x24,%esp
  800933:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800936:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800939:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093d:	89 1c 24             	mov    %ebx,(%esp)
  800940:	e8 96 fb ff ff       	call   8004db <fd_lookup>
  800945:	89 c2                	mov    %eax,%edx
  800947:	85 d2                	test   %edx,%edx
  800949:	78 61                	js     8009ac <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80094b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80094e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800955:	8b 00                	mov    (%eax),%eax
  800957:	89 04 24             	mov    %eax,(%esp)
  80095a:	e8 d2 fb ff ff       	call   800531 <dev_lookup>
  80095f:	85 c0                	test   %eax,%eax
  800961:	78 49                	js     8009ac <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800966:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80096a:	75 23                	jne    80098f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80096c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800971:	8b 40 48             	mov    0x48(%eax),%eax
  800974:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80097c:	c7 04 24 58 21 80 00 	movl   $0x802158,(%esp)
  800983:	e8 57 09 00 00       	call   8012df <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800988:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80098d:	eb 1d                	jmp    8009ac <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	8b 52 18             	mov    0x18(%edx),%edx
  800995:	85 d2                	test   %edx,%edx
  800997:	74 0e                	je     8009a7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800999:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009a0:	89 04 24             	mov    %eax,(%esp)
  8009a3:	ff d2                	call   *%edx
  8009a5:	eb 05                	jmp    8009ac <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009ac:	83 c4 24             	add    $0x24,%esp
  8009af:	5b                   	pop    %ebx
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	83 ec 24             	sub    $0x24,%esp
  8009b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	89 04 24             	mov    %eax,(%esp)
  8009c9:	e8 0d fb ff ff       	call   8004db <fd_lookup>
  8009ce:	89 c2                	mov    %eax,%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	78 52                	js     800a26 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009de:	8b 00                	mov    (%eax),%eax
  8009e0:	89 04 24             	mov    %eax,(%esp)
  8009e3:	e8 49 fb ff ff       	call   800531 <dev_lookup>
  8009e8:	85 c0                	test   %eax,%eax
  8009ea:	78 3a                	js     800a26 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8009ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ef:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009f3:	74 2c                	je     800a21 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009f5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009f8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009ff:	00 00 00 
	stat->st_isdir = 0;
  800a02:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a09:	00 00 00 
	stat->st_dev = dev;
  800a0c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a19:	89 14 24             	mov    %edx,(%esp)
  800a1c:	ff 50 14             	call   *0x14(%eax)
  800a1f:	eb 05                	jmp    800a26 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a21:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a26:	83 c4 24             	add    $0x24,%esp
  800a29:	5b                   	pop    %ebx
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a3b:	00 
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	89 04 24             	mov    %eax,(%esp)
  800a42:	e8 af 01 00 00       	call   800bf6 <open>
  800a47:	89 c3                	mov    %eax,%ebx
  800a49:	85 db                	test   %ebx,%ebx
  800a4b:	78 1b                	js     800a68 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a54:	89 1c 24             	mov    %ebx,(%esp)
  800a57:	e8 56 ff ff ff       	call   8009b2 <fstat>
  800a5c:	89 c6                	mov    %eax,%esi
	close(fd);
  800a5e:	89 1c 24             	mov    %ebx,(%esp)
  800a61:	e8 bd fb ff ff       	call   800623 <close>
	return r;
  800a66:	89 f0                	mov    %esi,%eax
}
  800a68:	83 c4 10             	add    $0x10,%esp
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	83 ec 10             	sub    $0x10,%esp
  800a77:	89 c6                	mov    %eax,%esi
  800a79:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a7b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a82:	75 11                	jne    800a95 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a8b:	e8 5c 13 00 00       	call   801dec <ipc_find_env>
  800a90:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a95:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800a9c:	00 
  800a9d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800aa4:	00 
  800aa5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aa9:	a1 00 40 80 00       	mov    0x804000,%eax
  800aae:	89 04 24             	mov    %eax,(%esp)
  800ab1:	e8 d0 12 00 00       	call   801d86 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800ab6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800abd:	00 
  800abe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ac2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ac9:	e8 4e 12 00 00       	call   801d1c <ipc_recv>
}
  800ace:	83 c4 10             	add    $0x10,%esp
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5d                   	pop    %ebp
  800ad4:	c3                   	ret    

00800ad5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	53                   	push   %ebx
  800ad9:	83 ec 14             	sub    $0x14,%esp
  800adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ae5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800aea:	ba 00 00 00 00       	mov    $0x0,%edx
  800aef:	b8 05 00 00 00       	mov    $0x5,%eax
  800af4:	e8 76 ff ff ff       	call   800a6f <fsipc>
  800af9:	89 c2                	mov    %eax,%edx
  800afb:	85 d2                	test   %edx,%edx
  800afd:	78 2b                	js     800b2a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800aff:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b06:	00 
  800b07:	89 1c 24             	mov    %ebx,(%esp)
  800b0a:	e8 2c 0e 00 00       	call   80193b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b0f:	a1 80 50 80 00       	mov    0x805080,%eax
  800b14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b1a:	a1 84 50 80 00       	mov    0x805084,%eax
  800b1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b2a:	83 c4 14             	add    $0x14,%esp
  800b2d:	5b                   	pop    %ebx
  800b2e:	5d                   	pop    %ebp
  800b2f:	c3                   	ret    

00800b30 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 40 0c             	mov    0xc(%eax),%eax
  800b3c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b41:	ba 00 00 00 00       	mov    $0x0,%edx
  800b46:	b8 06 00 00 00       	mov    $0x6,%eax
  800b4b:	e8 1f ff ff ff       	call   800a6f <fsipc>
}
  800b50:	c9                   	leave  
  800b51:	c3                   	ret    

00800b52 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b52:	55                   	push   %ebp
  800b53:	89 e5                	mov    %esp,%ebp
  800b55:	56                   	push   %esi
  800b56:	53                   	push   %ebx
  800b57:	83 ec 10             	sub    $0x10,%esp
  800b5a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 40 0c             	mov    0xc(%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b68:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b73:	b8 03 00 00 00       	mov    $0x3,%eax
  800b78:	e8 f2 fe ff ff       	call   800a6f <fsipc>
  800b7d:	89 c3                	mov    %eax,%ebx
  800b7f:	85 c0                	test   %eax,%eax
  800b81:	78 6a                	js     800bed <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b83:	39 c6                	cmp    %eax,%esi
  800b85:	73 24                	jae    800bab <devfile_read+0x59>
  800b87:	c7 44 24 0c b2 21 80 	movl   $0x8021b2,0xc(%esp)
  800b8e:	00 
  800b8f:	c7 44 24 08 b9 21 80 	movl   $0x8021b9,0x8(%esp)
  800b96:	00 
  800b97:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800b9e:	00 
  800b9f:	c7 04 24 ce 21 80 00 	movl   $0x8021ce,(%esp)
  800ba6:	e8 3b 06 00 00       	call   8011e6 <_panic>
	assert(r <= PGSIZE);
  800bab:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800bb0:	7e 24                	jle    800bd6 <devfile_read+0x84>
  800bb2:	c7 44 24 0c d9 21 80 	movl   $0x8021d9,0xc(%esp)
  800bb9:	00 
  800bba:	c7 44 24 08 b9 21 80 	movl   $0x8021b9,0x8(%esp)
  800bc1:	00 
  800bc2:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800bc9:	00 
  800bca:	c7 04 24 ce 21 80 00 	movl   $0x8021ce,(%esp)
  800bd1:	e8 10 06 00 00       	call   8011e6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800bd6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bda:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800be1:	00 
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 04 24             	mov    %eax,(%esp)
  800be8:	e8 49 0f 00 00       	call   801b36 <memmove>
	return r;
}
  800bed:	89 d8                	mov    %ebx,%eax
  800bef:	83 c4 10             	add    $0x10,%esp
  800bf2:	5b                   	pop    %ebx
  800bf3:	5e                   	pop    %esi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	53                   	push   %ebx
  800bfa:	83 ec 24             	sub    $0x24,%esp
  800bfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c00:	89 1c 24             	mov    %ebx,(%esp)
  800c03:	e8 d8 0c 00 00       	call   8018e0 <strlen>
  800c08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c0d:	7f 60                	jg     800c6f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c12:	89 04 24             	mov    %eax,(%esp)
  800c15:	e8 4d f8 ff ff       	call   800467 <fd_alloc>
  800c1a:	89 c2                	mov    %eax,%edx
  800c1c:	85 d2                	test   %edx,%edx
  800c1e:	78 54                	js     800c74 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c24:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c2b:	e8 0b 0d 00 00       	call   80193b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c33:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c40:	e8 2a fe ff ff       	call   800a6f <fsipc>
  800c45:	89 c3                	mov    %eax,%ebx
  800c47:	85 c0                	test   %eax,%eax
  800c49:	79 17                	jns    800c62 <open+0x6c>
		fd_close(fd, 0);
  800c4b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c52:	00 
  800c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c56:	89 04 24             	mov    %eax,(%esp)
  800c59:	e8 44 f9 ff ff       	call   8005a2 <fd_close>
		return r;
  800c5e:	89 d8                	mov    %ebx,%eax
  800c60:	eb 12                	jmp    800c74 <open+0x7e>
	}

	return fd2num(fd);
  800c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c65:	89 04 24             	mov    %eax,(%esp)
  800c68:	e8 d3 f7 ff ff       	call   800440 <fd2num>
  800c6d:	eb 05                	jmp    800c74 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c6f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800c74:	83 c4 24             	add    $0x24,%esp
  800c77:	5b                   	pop    %ebx
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    
  800c7a:	66 90                	xchg   %ax,%ax
  800c7c:	66 90                	xchg   %ax,%ax
  800c7e:	66 90                	xchg   %ax,%ax

00800c80 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	56                   	push   %esi
  800c84:	53                   	push   %ebx
  800c85:	83 ec 10             	sub    $0x10,%esp
  800c88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	89 04 24             	mov    %eax,(%esp)
  800c91:	e8 ba f7 ff ff       	call   800450 <fd2data>
  800c96:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c98:	c7 44 24 04 e5 21 80 	movl   $0x8021e5,0x4(%esp)
  800c9f:	00 
  800ca0:	89 1c 24             	mov    %ebx,(%esp)
  800ca3:	e8 93 0c 00 00       	call   80193b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800ca8:	8b 46 04             	mov    0x4(%esi),%eax
  800cab:	2b 06                	sub    (%esi),%eax
  800cad:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800cb3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cba:	00 00 00 
	stat->st_dev = &devpipe;
  800cbd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800cc4:	30 80 00 
	return 0;
}
  800cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  800ccc:	83 c4 10             	add    $0x10,%esp
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 14             	sub    $0x14,%esp
  800cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800cdd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ce1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ce8:	e8 8d f5 ff ff       	call   80027a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ced:	89 1c 24             	mov    %ebx,(%esp)
  800cf0:	e8 5b f7 ff ff       	call   800450 <fd2data>
  800cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d00:	e8 75 f5 ff ff       	call   80027a <sys_page_unmap>
}
  800d05:	83 c4 14             	add    $0x14,%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 2c             	sub    $0x2c,%esp
  800d14:	89 c6                	mov    %eax,%esi
  800d16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d19:	a1 04 40 80 00       	mov    0x804004,%eax
  800d1e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d21:	89 34 24             	mov    %esi,(%esp)
  800d24:	e8 0b 11 00 00       	call   801e34 <pageref>
  800d29:	89 c7                	mov    %eax,%edi
  800d2b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d2e:	89 04 24             	mov    %eax,(%esp)
  800d31:	e8 fe 10 00 00       	call   801e34 <pageref>
  800d36:	39 c7                	cmp    %eax,%edi
  800d38:	0f 94 c2             	sete   %dl
  800d3b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d3e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d44:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d47:	39 fb                	cmp    %edi,%ebx
  800d49:	74 21                	je     800d6c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d4b:	84 d2                	test   %dl,%dl
  800d4d:	74 ca                	je     800d19 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d4f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d56:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d5a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d5e:	c7 04 24 ec 21 80 00 	movl   $0x8021ec,(%esp)
  800d65:	e8 75 05 00 00       	call   8012df <cprintf>
  800d6a:	eb ad                	jmp    800d19 <_pipeisclosed+0xe>
	}
}
  800d6c:	83 c4 2c             	add    $0x2c,%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
  800d7a:	83 ec 1c             	sub    $0x1c,%esp
  800d7d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d80:	89 34 24             	mov    %esi,(%esp)
  800d83:	e8 c8 f6 ff ff       	call   800450 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8c:	74 61                	je     800def <devpipe_write+0x7b>
  800d8e:	89 c3                	mov    %eax,%ebx
  800d90:	bf 00 00 00 00       	mov    $0x0,%edi
  800d95:	eb 4a                	jmp    800de1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800d97:	89 da                	mov    %ebx,%edx
  800d99:	89 f0                	mov    %esi,%eax
  800d9b:	e8 6b ff ff ff       	call   800d0b <_pipeisclosed>
  800da0:	85 c0                	test   %eax,%eax
  800da2:	75 54                	jne    800df8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800da4:	e8 0b f4 ff ff       	call   8001b4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800da9:	8b 43 04             	mov    0x4(%ebx),%eax
  800dac:	8b 0b                	mov    (%ebx),%ecx
  800dae:	8d 51 20             	lea    0x20(%ecx),%edx
  800db1:	39 d0                	cmp    %edx,%eax
  800db3:	73 e2                	jae    800d97 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800db5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800dbc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800dbf:	99                   	cltd   
  800dc0:	c1 ea 1b             	shr    $0x1b,%edx
  800dc3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800dc6:	83 e1 1f             	and    $0x1f,%ecx
  800dc9:	29 d1                	sub    %edx,%ecx
  800dcb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800dcf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800dd3:	83 c0 01             	add    $0x1,%eax
  800dd6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dd9:	83 c7 01             	add    $0x1,%edi
  800ddc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800ddf:	74 13                	je     800df4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800de1:	8b 43 04             	mov    0x4(%ebx),%eax
  800de4:	8b 0b                	mov    (%ebx),%ecx
  800de6:	8d 51 20             	lea    0x20(%ecx),%edx
  800de9:	39 d0                	cmp    %edx,%eax
  800deb:	73 aa                	jae    800d97 <devpipe_write+0x23>
  800ded:	eb c6                	jmp    800db5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800def:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800df4:	89 f8                	mov    %edi,%eax
  800df6:	eb 05                	jmp    800dfd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800df8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800dfd:	83 c4 1c             	add    $0x1c,%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    

00800e05 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e05:	55                   	push   %ebp
  800e06:	89 e5                	mov    %esp,%ebp
  800e08:	57                   	push   %edi
  800e09:	56                   	push   %esi
  800e0a:	53                   	push   %ebx
  800e0b:	83 ec 1c             	sub    $0x1c,%esp
  800e0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e11:	89 3c 24             	mov    %edi,(%esp)
  800e14:	e8 37 f6 ff ff       	call   800450 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1d:	74 54                	je     800e73 <devpipe_read+0x6e>
  800e1f:	89 c3                	mov    %eax,%ebx
  800e21:	be 00 00 00 00       	mov    $0x0,%esi
  800e26:	eb 3e                	jmp    800e66 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e28:	89 f0                	mov    %esi,%eax
  800e2a:	eb 55                	jmp    800e81 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e2c:	89 da                	mov    %ebx,%edx
  800e2e:	89 f8                	mov    %edi,%eax
  800e30:	e8 d6 fe ff ff       	call   800d0b <_pipeisclosed>
  800e35:	85 c0                	test   %eax,%eax
  800e37:	75 43                	jne    800e7c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e39:	e8 76 f3 ff ff       	call   8001b4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e3e:	8b 03                	mov    (%ebx),%eax
  800e40:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e43:	74 e7                	je     800e2c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e45:	99                   	cltd   
  800e46:	c1 ea 1b             	shr    $0x1b,%edx
  800e49:	01 d0                	add    %edx,%eax
  800e4b:	83 e0 1f             	and    $0x1f,%eax
  800e4e:	29 d0                	sub    %edx,%eax
  800e50:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e58:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e5b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e5e:	83 c6 01             	add    $0x1,%esi
  800e61:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e64:	74 12                	je     800e78 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e66:	8b 03                	mov    (%ebx),%eax
  800e68:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e6b:	75 d8                	jne    800e45 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e6d:	85 f6                	test   %esi,%esi
  800e6f:	75 b7                	jne    800e28 <devpipe_read+0x23>
  800e71:	eb b9                	jmp    800e2c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e73:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e78:	89 f0                	mov    %esi,%eax
  800e7a:	eb 05                	jmp    800e81 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e81:	83 c4 1c             	add    $0x1c,%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800e91:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e94:	89 04 24             	mov    %eax,(%esp)
  800e97:	e8 cb f5 ff ff       	call   800467 <fd_alloc>
  800e9c:	89 c2                	mov    %eax,%edx
  800e9e:	85 d2                	test   %edx,%edx
  800ea0:	0f 88 4d 01 00 00    	js     800ff3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ea6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ead:	00 
  800eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ebc:	e8 12 f3 ff ff       	call   8001d3 <sys_page_alloc>
  800ec1:	89 c2                	mov    %eax,%edx
  800ec3:	85 d2                	test   %edx,%edx
  800ec5:	0f 88 28 01 00 00    	js     800ff3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800ecb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ece:	89 04 24             	mov    %eax,(%esp)
  800ed1:	e8 91 f5 ff ff       	call   800467 <fd_alloc>
  800ed6:	89 c3                	mov    %eax,%ebx
  800ed8:	85 c0                	test   %eax,%eax
  800eda:	0f 88 fe 00 00 00    	js     800fde <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ee0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ee7:	00 
  800ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ef6:	e8 d8 f2 ff ff       	call   8001d3 <sys_page_alloc>
  800efb:	89 c3                	mov    %eax,%ebx
  800efd:	85 c0                	test   %eax,%eax
  800eff:	0f 88 d9 00 00 00    	js     800fde <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f08:	89 04 24             	mov    %eax,(%esp)
  800f0b:	e8 40 f5 ff ff       	call   800450 <fd2data>
  800f10:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f12:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f19:	00 
  800f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f25:	e8 a9 f2 ff ff       	call   8001d3 <sys_page_alloc>
  800f2a:	89 c3                	mov    %eax,%ebx
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	0f 88 97 00 00 00    	js     800fcb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f37:	89 04 24             	mov    %eax,(%esp)
  800f3a:	e8 11 f5 ff ff       	call   800450 <fd2data>
  800f3f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f46:	00 
  800f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f52:	00 
  800f53:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f5e:	e8 c4 f2 ff ff       	call   800227 <sys_page_map>
  800f63:	89 c3                	mov    %eax,%ebx
  800f65:	85 c0                	test   %eax,%eax
  800f67:	78 52                	js     800fbb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f69:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f72:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f77:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f7e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f87:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f96:	89 04 24             	mov    %eax,(%esp)
  800f99:	e8 a2 f4 ff ff       	call   800440 <fd2num>
  800f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fa6:	89 04 24             	mov    %eax,(%esp)
  800fa9:	e8 92 f4 ff ff       	call   800440 <fd2num>
  800fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800fb4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb9:	eb 38                	jmp    800ff3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800fbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fc6:	e8 af f2 ff ff       	call   80027a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fce:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fd9:	e8 9c f2 ff ff       	call   80027a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fec:	e8 89 f2 ff ff       	call   80027a <sys_page_unmap>
  800ff1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  800ff3:	83 c4 30             	add    $0x30,%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801000:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801003:	89 44 24 04          	mov    %eax,0x4(%esp)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 04 24             	mov    %eax,(%esp)
  80100d:	e8 c9 f4 ff ff       	call   8004db <fd_lookup>
  801012:	89 c2                	mov    %eax,%edx
  801014:	85 d2                	test   %edx,%edx
  801016:	78 15                	js     80102d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101b:	89 04 24             	mov    %eax,(%esp)
  80101e:	e8 2d f4 ff ff       	call   800450 <fd2data>
	return _pipeisclosed(fd, p);
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	e8 de fc ff ff       	call   800d0b <_pipeisclosed>
}
  80102d:	c9                   	leave  
  80102e:	c3                   	ret    
  80102f:	90                   	nop

00801030 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	5d                   	pop    %ebp
  801039:	c3                   	ret    

0080103a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801040:	c7 44 24 04 04 22 80 	movl   $0x802204,0x4(%esp)
  801047:	00 
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	89 04 24             	mov    %eax,(%esp)
  80104e:	e8 e8 08 00 00       	call   80193b <strcpy>
	return 0;
}
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	57                   	push   %edi
  80105e:	56                   	push   %esi
  80105f:	53                   	push   %ebx
  801060:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801066:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80106a:	74 4a                	je     8010b6 <devcons_write+0x5c>
  80106c:	b8 00 00 00 00       	mov    $0x0,%eax
  801071:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801076:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80107c:	8b 75 10             	mov    0x10(%ebp),%esi
  80107f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801081:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801084:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801089:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80108c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801090:	03 45 0c             	add    0xc(%ebp),%eax
  801093:	89 44 24 04          	mov    %eax,0x4(%esp)
  801097:	89 3c 24             	mov    %edi,(%esp)
  80109a:	e8 97 0a 00 00       	call   801b36 <memmove>
		sys_cputs(buf, m);
  80109f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a3:	89 3c 24             	mov    %edi,(%esp)
  8010a6:	e8 5b f0 ff ff       	call   800106 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010ab:	01 f3                	add    %esi,%ebx
  8010ad:	89 d8                	mov    %ebx,%eax
  8010af:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8010b2:	72 c8                	jb     80107c <devcons_write+0x22>
  8010b4:	eb 05                	jmp    8010bb <devcons_write+0x61>
  8010b6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8010bb:	89 d8                	mov    %ebx,%eax
  8010bd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5f                   	pop    %edi
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8010ce:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8010d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d7:	75 07                	jne    8010e0 <devcons_read+0x18>
  8010d9:	eb 28                	jmp    801103 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8010db:	e8 d4 f0 ff ff       	call   8001b4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010e0:	e8 3f f0 ff ff       	call   800124 <sys_cgetc>
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	74 f2                	je     8010db <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010e9:	85 c0                	test   %eax,%eax
  8010eb:	78 16                	js     801103 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010ed:	83 f8 04             	cmp    $0x4,%eax
  8010f0:	74 0c                	je     8010fe <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	88 02                	mov    %al,(%edx)
	return 1;
  8010f7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010fc:	eb 05                	jmp    801103 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801111:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801118:	00 
  801119:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80111c:	89 04 24             	mov    %eax,(%esp)
  80111f:	e8 e2 ef ff ff       	call   800106 <sys_cputs>
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <getchar>:

int
getchar(void)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80112c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801133:	00 
  801134:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801137:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801142:	e8 3f f6 ff ff       	call   800786 <read>
	if (r < 0)
  801147:	85 c0                	test   %eax,%eax
  801149:	78 0f                	js     80115a <getchar+0x34>
		return r;
	if (r < 1)
  80114b:	85 c0                	test   %eax,%eax
  80114d:	7e 06                	jle    801155 <getchar+0x2f>
		return -E_EOF;
	return c;
  80114f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801153:	eb 05                	jmp    80115a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801155:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801162:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801165:	89 44 24 04          	mov    %eax,0x4(%esp)
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	89 04 24             	mov    %eax,(%esp)
  80116f:	e8 67 f3 ff ff       	call   8004db <fd_lookup>
  801174:	85 c0                	test   %eax,%eax
  801176:	78 11                	js     801189 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801181:	39 10                	cmp    %edx,(%eax)
  801183:	0f 94 c0             	sete   %al
  801186:	0f b6 c0             	movzbl %al,%eax
}
  801189:	c9                   	leave  
  80118a:	c3                   	ret    

0080118b <opencons>:

int
opencons(void)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801191:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801194:	89 04 24             	mov    %eax,(%esp)
  801197:	e8 cb f2 ff ff       	call   800467 <fd_alloc>
		return r;
  80119c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	78 40                	js     8011e2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011a2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8011a9:	00 
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b8:	e8 16 f0 ff ff       	call   8001d3 <sys_page_alloc>
		return r;
  8011bd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 1f                	js     8011e2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8011c3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011cc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8011ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8011d8:	89 04 24             	mov    %eax,(%esp)
  8011db:	e8 60 f2 ff ff       	call   800440 <fd2num>
  8011e0:	89 c2                	mov    %eax,%edx
}
  8011e2:	89 d0                	mov    %edx,%eax
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ee:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011f1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8011f7:	e8 99 ef ff ff       	call   800195 <sys_getenvid>
  8011fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ff:	89 54 24 10          	mov    %edx,0x10(%esp)
  801203:	8b 55 08             	mov    0x8(%ebp),%edx
  801206:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80120a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80120e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801212:	c7 04 24 10 22 80 00 	movl   $0x802210,(%esp)
  801219:	e8 c1 00 00 00       	call   8012df <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80121e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801222:	8b 45 10             	mov    0x10(%ebp),%eax
  801225:	89 04 24             	mov    %eax,(%esp)
  801228:	e8 51 00 00 00       	call   80127e <vcprintf>
	cprintf("\n");
  80122d:	c7 04 24 fd 21 80 00 	movl   $0x8021fd,(%esp)
  801234:	e8 a6 00 00 00       	call   8012df <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801239:	cc                   	int3   
  80123a:	eb fd                	jmp    801239 <_panic+0x53>

0080123c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
  80123f:	53                   	push   %ebx
  801240:	83 ec 14             	sub    $0x14,%esp
  801243:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801246:	8b 13                	mov    (%ebx),%edx
  801248:	8d 42 01             	lea    0x1(%edx),%eax
  80124b:	89 03                	mov    %eax,(%ebx)
  80124d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801250:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801254:	3d ff 00 00 00       	cmp    $0xff,%eax
  801259:	75 19                	jne    801274 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80125b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801262:	00 
  801263:	8d 43 08             	lea    0x8(%ebx),%eax
  801266:	89 04 24             	mov    %eax,(%esp)
  801269:	e8 98 ee ff ff       	call   800106 <sys_cputs>
		b->idx = 0;
  80126e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801274:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801278:	83 c4 14             	add    $0x14,%esp
  80127b:	5b                   	pop    %ebx
  80127c:	5d                   	pop    %ebp
  80127d:	c3                   	ret    

0080127e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80127e:	55                   	push   %ebp
  80127f:	89 e5                	mov    %esp,%ebp
  801281:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801287:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80128e:	00 00 00 
	b.cnt = 0;
  801291:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801298:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80129b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012a9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8012af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b3:	c7 04 24 3c 12 80 00 	movl   $0x80123c,(%esp)
  8012ba:	e8 b5 01 00 00       	call   801474 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8012bf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8012c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 2f ee ff ff       	call   800106 <sys_cputs>

	return b.cnt;
}
  8012d7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012e5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ef:	89 04 24             	mov    %eax,(%esp)
  8012f2:	e8 87 ff ff ff       	call   80127e <vcprintf>
	va_end(ap);

	return cnt;
}
  8012f7:	c9                   	leave  
  8012f8:	c3                   	ret    
  8012f9:	66 90                	xchg   %ax,%ax
  8012fb:	66 90                	xchg   %ax,%ax
  8012fd:	66 90                	xchg   %ax,%ax
  8012ff:	90                   	nop

00801300 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	57                   	push   %edi
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 3c             	sub    $0x3c,%esp
  801309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80130c:	89 d7                	mov    %edx,%edi
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801314:	8b 75 0c             	mov    0xc(%ebp),%esi
  801317:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80131d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801322:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801325:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801328:	39 f1                	cmp    %esi,%ecx
  80132a:	72 14                	jb     801340 <printnum+0x40>
  80132c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80132f:	76 0f                	jbe    801340 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801331:	8b 45 14             	mov    0x14(%ebp),%eax
  801334:	8d 70 ff             	lea    -0x1(%eax),%esi
  801337:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80133a:	85 f6                	test   %esi,%esi
  80133c:	7f 60                	jg     80139e <printnum+0x9e>
  80133e:	eb 72                	jmp    8013b2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801340:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801343:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801347:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80134a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80134d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801351:	89 44 24 08          	mov    %eax,0x8(%esp)
  801355:	8b 44 24 08          	mov    0x8(%esp),%eax
  801359:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80135d:	89 c3                	mov    %eax,%ebx
  80135f:	89 d6                	mov    %edx,%esi
  801361:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801364:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801367:	89 54 24 08          	mov    %edx,0x8(%esp)
  80136b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80136f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801372:	89 04 24             	mov    %eax,(%esp)
  801375:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801378:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137c:	e8 ef 0a 00 00       	call   801e70 <__udivdi3>
  801381:	89 d9                	mov    %ebx,%ecx
  801383:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801387:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801392:	89 fa                	mov    %edi,%edx
  801394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801397:	e8 64 ff ff ff       	call   801300 <printnum>
  80139c:	eb 14                	jmp    8013b2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80139e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013aa:	83 ee 01             	sub    $0x1,%esi
  8013ad:	75 ef                	jne    80139e <printnum+0x9e>
  8013af:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013b6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8013ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d5:	e8 c6 0b 00 00       	call   801fa0 <__umoddi3>
  8013da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013de:	0f be 80 33 22 80 00 	movsbl 0x802233(%eax),%eax
  8013e5:	89 04 24             	mov    %eax,(%esp)
  8013e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
}
  8013ed:	83 c4 3c             	add    $0x3c,%esp
  8013f0:	5b                   	pop    %ebx
  8013f1:	5e                   	pop    %esi
  8013f2:	5f                   	pop    %edi
  8013f3:	5d                   	pop    %ebp
  8013f4:	c3                   	ret    

008013f5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013f8:	83 fa 01             	cmp    $0x1,%edx
  8013fb:	7e 0e                	jle    80140b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8013fd:	8b 10                	mov    (%eax),%edx
  8013ff:	8d 4a 08             	lea    0x8(%edx),%ecx
  801402:	89 08                	mov    %ecx,(%eax)
  801404:	8b 02                	mov    (%edx),%eax
  801406:	8b 52 04             	mov    0x4(%edx),%edx
  801409:	eb 22                	jmp    80142d <getuint+0x38>
	else if (lflag)
  80140b:	85 d2                	test   %edx,%edx
  80140d:	74 10                	je     80141f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80140f:	8b 10                	mov    (%eax),%edx
  801411:	8d 4a 04             	lea    0x4(%edx),%ecx
  801414:	89 08                	mov    %ecx,(%eax)
  801416:	8b 02                	mov    (%edx),%eax
  801418:	ba 00 00 00 00       	mov    $0x0,%edx
  80141d:	eb 0e                	jmp    80142d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80141f:	8b 10                	mov    (%eax),%edx
  801421:	8d 4a 04             	lea    0x4(%edx),%ecx
  801424:	89 08                	mov    %ecx,(%eax)
  801426:	8b 02                	mov    (%edx),%eax
  801428:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80142d:	5d                   	pop    %ebp
  80142e:	c3                   	ret    

0080142f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80142f:	55                   	push   %ebp
  801430:	89 e5                	mov    %esp,%ebp
  801432:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801435:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801439:	8b 10                	mov    (%eax),%edx
  80143b:	3b 50 04             	cmp    0x4(%eax),%edx
  80143e:	73 0a                	jae    80144a <sprintputch+0x1b>
		*b->buf++ = ch;
  801440:	8d 4a 01             	lea    0x1(%edx),%ecx
  801443:	89 08                	mov    %ecx,(%eax)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	88 02                	mov    %al,(%edx)
}
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801452:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801455:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801459:	8b 45 10             	mov    0x10(%ebp),%eax
  80145c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801460:	8b 45 0c             	mov    0xc(%ebp),%eax
  801463:	89 44 24 04          	mov    %eax,0x4(%esp)
  801467:	8b 45 08             	mov    0x8(%ebp),%eax
  80146a:	89 04 24             	mov    %eax,(%esp)
  80146d:	e8 02 00 00 00       	call   801474 <vprintfmt>
	va_end(ap);
}
  801472:	c9                   	leave  
  801473:	c3                   	ret    

00801474 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801474:	55                   	push   %ebp
  801475:	89 e5                	mov    %esp,%ebp
  801477:	57                   	push   %edi
  801478:	56                   	push   %esi
  801479:	53                   	push   %ebx
  80147a:	83 ec 3c             	sub    $0x3c,%esp
  80147d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801480:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801483:	eb 18                	jmp    80149d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801485:	85 c0                	test   %eax,%eax
  801487:	0f 84 c3 03 00 00    	je     801850 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80148d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801491:	89 04 24             	mov    %eax,(%esp)
  801494:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801497:	89 f3                	mov    %esi,%ebx
  801499:	eb 02                	jmp    80149d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80149b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80149d:	8d 73 01             	lea    0x1(%ebx),%esi
  8014a0:	0f b6 03             	movzbl (%ebx),%eax
  8014a3:	83 f8 25             	cmp    $0x25,%eax
  8014a6:	75 dd                	jne    801485 <vprintfmt+0x11>
  8014a8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8014ac:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8014b3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8014ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c6:	eb 1d                	jmp    8014e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014c8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8014ca:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8014ce:	eb 15                	jmp    8014e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014d0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014d2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8014d6:	eb 0d                	jmp    8014e5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8014d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014de:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014e5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014e8:	0f b6 06             	movzbl (%esi),%eax
  8014eb:	0f b6 c8             	movzbl %al,%ecx
  8014ee:	83 e8 23             	sub    $0x23,%eax
  8014f1:	3c 55                	cmp    $0x55,%al
  8014f3:	0f 87 2f 03 00 00    	ja     801828 <vprintfmt+0x3b4>
  8014f9:	0f b6 c0             	movzbl %al,%eax
  8014fc:	ff 24 85 80 23 80 00 	jmp    *0x802380(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801503:	8d 41 d0             	lea    -0x30(%ecx),%eax
  801506:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  801509:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80150d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801510:	83 f9 09             	cmp    $0x9,%ecx
  801513:	77 50                	ja     801565 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801515:	89 de                	mov    %ebx,%esi
  801517:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80151a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80151d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801520:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801524:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801527:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80152a:	83 fb 09             	cmp    $0x9,%ebx
  80152d:	76 eb                	jbe    80151a <vprintfmt+0xa6>
  80152f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801532:	eb 33                	jmp    801567 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801534:	8b 45 14             	mov    0x14(%ebp),%eax
  801537:	8d 48 04             	lea    0x4(%eax),%ecx
  80153a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801542:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801544:	eb 21                	jmp    801567 <vprintfmt+0xf3>
  801546:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801549:	85 c9                	test   %ecx,%ecx
  80154b:	b8 00 00 00 00       	mov    $0x0,%eax
  801550:	0f 49 c1             	cmovns %ecx,%eax
  801553:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801556:	89 de                	mov    %ebx,%esi
  801558:	eb 8b                	jmp    8014e5 <vprintfmt+0x71>
  80155a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80155c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801563:	eb 80                	jmp    8014e5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801565:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80156b:	0f 89 74 ff ff ff    	jns    8014e5 <vprintfmt+0x71>
  801571:	e9 62 ff ff ff       	jmp    8014d8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801576:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801579:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80157b:	e9 65 ff ff ff       	jmp    8014e5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801580:	8b 45 14             	mov    0x14(%ebp),%eax
  801583:	8d 50 04             	lea    0x4(%eax),%edx
  801586:	89 55 14             	mov    %edx,0x14(%ebp)
  801589:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	89 04 24             	mov    %eax,(%esp)
  801592:	ff 55 08             	call   *0x8(%ebp)
			break;
  801595:	e9 03 ff ff ff       	jmp    80149d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80159a:	8b 45 14             	mov    0x14(%ebp),%eax
  80159d:	8d 50 04             	lea    0x4(%eax),%edx
  8015a0:	89 55 14             	mov    %edx,0x14(%ebp)
  8015a3:	8b 00                	mov    (%eax),%eax
  8015a5:	99                   	cltd   
  8015a6:	31 d0                	xor    %edx,%eax
  8015a8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8015aa:	83 f8 0f             	cmp    $0xf,%eax
  8015ad:	7f 0b                	jg     8015ba <vprintfmt+0x146>
  8015af:	8b 14 85 e0 24 80 00 	mov    0x8024e0(,%eax,4),%edx
  8015b6:	85 d2                	test   %edx,%edx
  8015b8:	75 20                	jne    8015da <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8015ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015be:	c7 44 24 08 4b 22 80 	movl   $0x80224b,0x8(%esp)
  8015c5:	00 
  8015c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	89 04 24             	mov    %eax,(%esp)
  8015d0:	e8 77 fe ff ff       	call   80144c <printfmt>
  8015d5:	e9 c3 fe ff ff       	jmp    80149d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8015da:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015de:	c7 44 24 08 cb 21 80 	movl   $0x8021cb,0x8(%esp)
  8015e5:	00 
  8015e6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	89 04 24             	mov    %eax,(%esp)
  8015f0:	e8 57 fe ff ff       	call   80144c <printfmt>
  8015f5:	e9 a3 fe ff ff       	jmp    80149d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015fa:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8015fd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801600:	8b 45 14             	mov    0x14(%ebp),%eax
  801603:	8d 50 04             	lea    0x4(%eax),%edx
  801606:	89 55 14             	mov    %edx,0x14(%ebp)
  801609:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80160b:	85 c0                	test   %eax,%eax
  80160d:	ba 44 22 80 00       	mov    $0x802244,%edx
  801612:	0f 45 d0             	cmovne %eax,%edx
  801615:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801618:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80161c:	74 04                	je     801622 <vprintfmt+0x1ae>
  80161e:	85 f6                	test   %esi,%esi
  801620:	7f 19                	jg     80163b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801622:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801625:	8d 70 01             	lea    0x1(%eax),%esi
  801628:	0f b6 10             	movzbl (%eax),%edx
  80162b:	0f be c2             	movsbl %dl,%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	0f 85 95 00 00 00    	jne    8016cb <vprintfmt+0x257>
  801636:	e9 85 00 00 00       	jmp    8016c0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80163b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80163f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801642:	89 04 24             	mov    %eax,(%esp)
  801645:	e8 b8 02 00 00       	call   801902 <strnlen>
  80164a:	29 c6                	sub    %eax,%esi
  80164c:	89 f0                	mov    %esi,%eax
  80164e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801651:	85 f6                	test   %esi,%esi
  801653:	7e cd                	jle    801622 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801655:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801659:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80165c:	89 c3                	mov    %eax,%ebx
  80165e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801662:	89 34 24             	mov    %esi,(%esp)
  801665:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801668:	83 eb 01             	sub    $0x1,%ebx
  80166b:	75 f1                	jne    80165e <vprintfmt+0x1ea>
  80166d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801670:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801673:	eb ad                	jmp    801622 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801675:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801679:	74 1e                	je     801699 <vprintfmt+0x225>
  80167b:	0f be d2             	movsbl %dl,%edx
  80167e:	83 ea 20             	sub    $0x20,%edx
  801681:	83 fa 5e             	cmp    $0x5e,%edx
  801684:	76 13                	jbe    801699 <vprintfmt+0x225>
					putch('?', putdat);
  801686:	8b 45 0c             	mov    0xc(%ebp),%eax
  801689:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801694:	ff 55 08             	call   *0x8(%ebp)
  801697:	eb 0d                	jmp    8016a6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801699:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80169c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016a0:	89 04 24             	mov    %eax,(%esp)
  8016a3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016a6:	83 ef 01             	sub    $0x1,%edi
  8016a9:	83 c6 01             	add    $0x1,%esi
  8016ac:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8016b0:	0f be c2             	movsbl %dl,%eax
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	75 20                	jne    8016d7 <vprintfmt+0x263>
  8016b7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016ba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016c4:	7f 25                	jg     8016eb <vprintfmt+0x277>
  8016c6:	e9 d2 fd ff ff       	jmp    80149d <vprintfmt+0x29>
  8016cb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8016ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016d1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016d4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016d7:	85 db                	test   %ebx,%ebx
  8016d9:	78 9a                	js     801675 <vprintfmt+0x201>
  8016db:	83 eb 01             	sub    $0x1,%ebx
  8016de:	79 95                	jns    801675 <vprintfmt+0x201>
  8016e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016e9:	eb d5                	jmp    8016c0 <vprintfmt+0x24c>
  8016eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016f1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8016f4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016f8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8016ff:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801701:	83 eb 01             	sub    $0x1,%ebx
  801704:	75 ee                	jne    8016f4 <vprintfmt+0x280>
  801706:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801709:	e9 8f fd ff ff       	jmp    80149d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80170e:	83 fa 01             	cmp    $0x1,%edx
  801711:	7e 16                	jle    801729 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801713:	8b 45 14             	mov    0x14(%ebp),%eax
  801716:	8d 50 08             	lea    0x8(%eax),%edx
  801719:	89 55 14             	mov    %edx,0x14(%ebp)
  80171c:	8b 50 04             	mov    0x4(%eax),%edx
  80171f:	8b 00                	mov    (%eax),%eax
  801721:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801724:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801727:	eb 32                	jmp    80175b <vprintfmt+0x2e7>
	else if (lflag)
  801729:	85 d2                	test   %edx,%edx
  80172b:	74 18                	je     801745 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80172d:	8b 45 14             	mov    0x14(%ebp),%eax
  801730:	8d 50 04             	lea    0x4(%eax),%edx
  801733:	89 55 14             	mov    %edx,0x14(%ebp)
  801736:	8b 30                	mov    (%eax),%esi
  801738:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80173b:	89 f0                	mov    %esi,%eax
  80173d:	c1 f8 1f             	sar    $0x1f,%eax
  801740:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801743:	eb 16                	jmp    80175b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801745:	8b 45 14             	mov    0x14(%ebp),%eax
  801748:	8d 50 04             	lea    0x4(%eax),%edx
  80174b:	89 55 14             	mov    %edx,0x14(%ebp)
  80174e:	8b 30                	mov    (%eax),%esi
  801750:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801753:	89 f0                	mov    %esi,%eax
  801755:	c1 f8 1f             	sar    $0x1f,%eax
  801758:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80175b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80175e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801761:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801766:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80176a:	0f 89 80 00 00 00    	jns    8017f0 <vprintfmt+0x37c>
				putch('-', putdat);
  801770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801774:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80177b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80177e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801781:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801784:	f7 d8                	neg    %eax
  801786:	83 d2 00             	adc    $0x0,%edx
  801789:	f7 da                	neg    %edx
			}
			base = 10;
  80178b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801790:	eb 5e                	jmp    8017f0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801792:	8d 45 14             	lea    0x14(%ebp),%eax
  801795:	e8 5b fc ff ff       	call   8013f5 <getuint>
			base = 10;
  80179a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80179f:	eb 4f                	jmp    8017f0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8017a1:	8d 45 14             	lea    0x14(%ebp),%eax
  8017a4:	e8 4c fc ff ff       	call   8013f5 <getuint>
			base = 8;
  8017a9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8017ae:	eb 40                	jmp    8017f0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8017b0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017b4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8017bb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8017be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017c2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8017c9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8017cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017cf:	8d 50 04             	lea    0x4(%eax),%edx
  8017d2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017d5:	8b 00                	mov    (%eax),%eax
  8017d7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8017dc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017e1:	eb 0d                	jmp    8017f0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017e3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017e6:	e8 0a fc ff ff       	call   8013f5 <getuint>
			base = 16;
  8017eb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017f0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8017f4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8017f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017fb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801803:	89 04 24             	mov    %eax,(%esp)
  801806:	89 54 24 04          	mov    %edx,0x4(%esp)
  80180a:	89 fa                	mov    %edi,%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	e8 ec fa ff ff       	call   801300 <printnum>
			break;
  801814:	e9 84 fc ff ff       	jmp    80149d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801819:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80181d:	89 0c 24             	mov    %ecx,(%esp)
  801820:	ff 55 08             	call   *0x8(%ebp)
			break;
  801823:	e9 75 fc ff ff       	jmp    80149d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801828:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80182c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801833:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801836:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80183a:	0f 84 5b fc ff ff    	je     80149b <vprintfmt+0x27>
  801840:	89 f3                	mov    %esi,%ebx
  801842:	83 eb 01             	sub    $0x1,%ebx
  801845:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801849:	75 f7                	jne    801842 <vprintfmt+0x3ce>
  80184b:	e9 4d fc ff ff       	jmp    80149d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801850:	83 c4 3c             	add    $0x3c,%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5f                   	pop    %edi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 28             	sub    $0x28,%esp
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801864:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801867:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80186b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80186e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801875:	85 c0                	test   %eax,%eax
  801877:	74 30                	je     8018a9 <vsnprintf+0x51>
  801879:	85 d2                	test   %edx,%edx
  80187b:	7e 2c                	jle    8018a9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80187d:	8b 45 14             	mov    0x14(%ebp),%eax
  801880:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801884:	8b 45 10             	mov    0x10(%ebp),%eax
  801887:	89 44 24 08          	mov    %eax,0x8(%esp)
  80188b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	c7 04 24 2f 14 80 00 	movl   $0x80142f,(%esp)
  801899:	e8 d6 fb ff ff       	call   801474 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80189e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a7:	eb 05                	jmp    8018ae <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8018a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018b6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8018b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 82 ff ff ff       	call   801858 <vsnprintf>
	va_end(ap);

	return rc;
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    
  8018d8:	66 90                	xchg   %ax,%ax
  8018da:	66 90                	xchg   %ax,%ax
  8018dc:	66 90                	xchg   %ax,%ax
  8018de:	66 90                	xchg   %ax,%ax

008018e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018e9:	74 10                	je     8018fb <strlen+0x1b>
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8018f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8018f7:	75 f7                	jne    8018f0 <strlen+0x10>
  8018f9:	eb 05                	jmp    801900 <strlen+0x20>
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801900:	5d                   	pop    %ebp
  801901:	c3                   	ret    

00801902 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
  801905:	53                   	push   %ebx
  801906:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801909:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80190c:	85 c9                	test   %ecx,%ecx
  80190e:	74 1c                	je     80192c <strnlen+0x2a>
  801910:	80 3b 00             	cmpb   $0x0,(%ebx)
  801913:	74 1e                	je     801933 <strnlen+0x31>
  801915:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80191a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80191c:	39 ca                	cmp    %ecx,%edx
  80191e:	74 18                	je     801938 <strnlen+0x36>
  801920:	83 c2 01             	add    $0x1,%edx
  801923:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801928:	75 f0                	jne    80191a <strnlen+0x18>
  80192a:	eb 0c                	jmp    801938 <strnlen+0x36>
  80192c:	b8 00 00 00 00       	mov    $0x0,%eax
  801931:	eb 05                	jmp    801938 <strnlen+0x36>
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801938:	5b                   	pop    %ebx
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	53                   	push   %ebx
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801945:	89 c2                	mov    %eax,%edx
  801947:	83 c2 01             	add    $0x1,%edx
  80194a:	83 c1 01             	add    $0x1,%ecx
  80194d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801951:	88 5a ff             	mov    %bl,-0x1(%edx)
  801954:	84 db                	test   %bl,%bl
  801956:	75 ef                	jne    801947 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801958:	5b                   	pop    %ebx
  801959:	5d                   	pop    %ebp
  80195a:	c3                   	ret    

0080195b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	53                   	push   %ebx
  80195f:	83 ec 08             	sub    $0x8,%esp
  801962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801965:	89 1c 24             	mov    %ebx,(%esp)
  801968:	e8 73 ff ff ff       	call   8018e0 <strlen>
	strcpy(dst + len, src);
  80196d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801970:	89 54 24 04          	mov    %edx,0x4(%esp)
  801974:	01 d8                	add    %ebx,%eax
  801976:	89 04 24             	mov    %eax,(%esp)
  801979:	e8 bd ff ff ff       	call   80193b <strcpy>
	return dst;
}
  80197e:	89 d8                	mov    %ebx,%eax
  801980:	83 c4 08             	add    $0x8,%esp
  801983:	5b                   	pop    %ebx
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	8b 75 08             	mov    0x8(%ebp),%esi
  80198e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801991:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801994:	85 db                	test   %ebx,%ebx
  801996:	74 17                	je     8019af <strncpy+0x29>
  801998:	01 f3                	add    %esi,%ebx
  80199a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80199c:	83 c1 01             	add    $0x1,%ecx
  80199f:	0f b6 02             	movzbl (%edx),%eax
  8019a2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8019a5:	80 3a 01             	cmpb   $0x1,(%edx)
  8019a8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019ab:	39 d9                	cmp    %ebx,%ecx
  8019ad:	75 ed                	jne    80199c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8019af:	89 f0                	mov    %esi,%eax
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	57                   	push   %edi
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
  8019bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019be:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019c1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019c4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019c6:	85 f6                	test   %esi,%esi
  8019c8:	74 34                	je     8019fe <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8019ca:	83 fe 01             	cmp    $0x1,%esi
  8019cd:	74 26                	je     8019f5 <strlcpy+0x40>
  8019cf:	0f b6 0b             	movzbl (%ebx),%ecx
  8019d2:	84 c9                	test   %cl,%cl
  8019d4:	74 23                	je     8019f9 <strlcpy+0x44>
  8019d6:	83 ee 02             	sub    $0x2,%esi
  8019d9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8019de:	83 c0 01             	add    $0x1,%eax
  8019e1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019e4:	39 f2                	cmp    %esi,%edx
  8019e6:	74 13                	je     8019fb <strlcpy+0x46>
  8019e8:	83 c2 01             	add    $0x1,%edx
  8019eb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019ef:	84 c9                	test   %cl,%cl
  8019f1:	75 eb                	jne    8019de <strlcpy+0x29>
  8019f3:	eb 06                	jmp    8019fb <strlcpy+0x46>
  8019f5:	89 f8                	mov    %edi,%eax
  8019f7:	eb 02                	jmp    8019fb <strlcpy+0x46>
  8019f9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8019fb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019fe:	29 f8                	sub    %edi,%eax
}
  801a00:	5b                   	pop    %ebx
  801a01:	5e                   	pop    %esi
  801a02:	5f                   	pop    %edi
  801a03:	5d                   	pop    %ebp
  801a04:	c3                   	ret    

00801a05 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
  801a08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a0e:	0f b6 01             	movzbl (%ecx),%eax
  801a11:	84 c0                	test   %al,%al
  801a13:	74 15                	je     801a2a <strcmp+0x25>
  801a15:	3a 02                	cmp    (%edx),%al
  801a17:	75 11                	jne    801a2a <strcmp+0x25>
		p++, q++;
  801a19:	83 c1 01             	add    $0x1,%ecx
  801a1c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a1f:	0f b6 01             	movzbl (%ecx),%eax
  801a22:	84 c0                	test   %al,%al
  801a24:	74 04                	je     801a2a <strcmp+0x25>
  801a26:	3a 02                	cmp    (%edx),%al
  801a28:	74 ef                	je     801a19 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a2a:	0f b6 c0             	movzbl %al,%eax
  801a2d:	0f b6 12             	movzbl (%edx),%edx
  801a30:	29 d0                	sub    %edx,%eax
}
  801a32:	5d                   	pop    %ebp
  801a33:	c3                   	ret    

00801a34 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a34:	55                   	push   %ebp
  801a35:	89 e5                	mov    %esp,%ebp
  801a37:	56                   	push   %esi
  801a38:	53                   	push   %ebx
  801a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a42:	85 f6                	test   %esi,%esi
  801a44:	74 29                	je     801a6f <strncmp+0x3b>
  801a46:	0f b6 03             	movzbl (%ebx),%eax
  801a49:	84 c0                	test   %al,%al
  801a4b:	74 30                	je     801a7d <strncmp+0x49>
  801a4d:	3a 02                	cmp    (%edx),%al
  801a4f:	75 2c                	jne    801a7d <strncmp+0x49>
  801a51:	8d 43 01             	lea    0x1(%ebx),%eax
  801a54:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a56:	89 c3                	mov    %eax,%ebx
  801a58:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a5b:	39 f0                	cmp    %esi,%eax
  801a5d:	74 17                	je     801a76 <strncmp+0x42>
  801a5f:	0f b6 08             	movzbl (%eax),%ecx
  801a62:	84 c9                	test   %cl,%cl
  801a64:	74 17                	je     801a7d <strncmp+0x49>
  801a66:	83 c0 01             	add    $0x1,%eax
  801a69:	3a 0a                	cmp    (%edx),%cl
  801a6b:	74 e9                	je     801a56 <strncmp+0x22>
  801a6d:	eb 0e                	jmp    801a7d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	eb 0f                	jmp    801a85 <strncmp+0x51>
  801a76:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7b:	eb 08                	jmp    801a85 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a7d:	0f b6 03             	movzbl (%ebx),%eax
  801a80:	0f b6 12             	movzbl (%edx),%edx
  801a83:	29 d0                	sub    %edx,%eax
}
  801a85:	5b                   	pop    %ebx
  801a86:	5e                   	pop    %esi
  801a87:	5d                   	pop    %ebp
  801a88:	c3                   	ret    

00801a89 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	53                   	push   %ebx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a93:	0f b6 18             	movzbl (%eax),%ebx
  801a96:	84 db                	test   %bl,%bl
  801a98:	74 1d                	je     801ab7 <strchr+0x2e>
  801a9a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a9c:	38 d3                	cmp    %dl,%bl
  801a9e:	75 06                	jne    801aa6 <strchr+0x1d>
  801aa0:	eb 1a                	jmp    801abc <strchr+0x33>
  801aa2:	38 ca                	cmp    %cl,%dl
  801aa4:	74 16                	je     801abc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801aa6:	83 c0 01             	add    $0x1,%eax
  801aa9:	0f b6 10             	movzbl (%eax),%edx
  801aac:	84 d2                	test   %dl,%dl
  801aae:	75 f2                	jne    801aa2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801ab0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab5:	eb 05                	jmp    801abc <strchr+0x33>
  801ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abc:	5b                   	pop    %ebx
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801ac9:	0f b6 18             	movzbl (%eax),%ebx
  801acc:	84 db                	test   %bl,%bl
  801ace:	74 16                	je     801ae6 <strfind+0x27>
  801ad0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801ad2:	38 d3                	cmp    %dl,%bl
  801ad4:	75 06                	jne    801adc <strfind+0x1d>
  801ad6:	eb 0e                	jmp    801ae6 <strfind+0x27>
  801ad8:	38 ca                	cmp    %cl,%dl
  801ada:	74 0a                	je     801ae6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801adc:	83 c0 01             	add    $0x1,%eax
  801adf:	0f b6 10             	movzbl (%eax),%edx
  801ae2:	84 d2                	test   %dl,%dl
  801ae4:	75 f2                	jne    801ad8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801ae6:	5b                   	pop    %ebx
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	57                   	push   %edi
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
  801aef:	8b 7d 08             	mov    0x8(%ebp),%edi
  801af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801af5:	85 c9                	test   %ecx,%ecx
  801af7:	74 36                	je     801b2f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801af9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801aff:	75 28                	jne    801b29 <memset+0x40>
  801b01:	f6 c1 03             	test   $0x3,%cl
  801b04:	75 23                	jne    801b29 <memset+0x40>
		c &= 0xFF;
  801b06:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b0a:	89 d3                	mov    %edx,%ebx
  801b0c:	c1 e3 08             	shl    $0x8,%ebx
  801b0f:	89 d6                	mov    %edx,%esi
  801b11:	c1 e6 18             	shl    $0x18,%esi
  801b14:	89 d0                	mov    %edx,%eax
  801b16:	c1 e0 10             	shl    $0x10,%eax
  801b19:	09 f0                	or     %esi,%eax
  801b1b:	09 c2                	or     %eax,%edx
  801b1d:	89 d0                	mov    %edx,%eax
  801b1f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b21:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b24:	fc                   	cld    
  801b25:	f3 ab                	rep stos %eax,%es:(%edi)
  801b27:	eb 06                	jmp    801b2f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	fc                   	cld    
  801b2d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b2f:	89 f8                	mov    %edi,%eax
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	57                   	push   %edi
  801b3a:	56                   	push   %esi
  801b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b44:	39 c6                	cmp    %eax,%esi
  801b46:	73 35                	jae    801b7d <memmove+0x47>
  801b48:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b4b:	39 d0                	cmp    %edx,%eax
  801b4d:	73 2e                	jae    801b7d <memmove+0x47>
		s += n;
		d += n;
  801b4f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b52:	89 d6                	mov    %edx,%esi
  801b54:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b5c:	75 13                	jne    801b71 <memmove+0x3b>
  801b5e:	f6 c1 03             	test   $0x3,%cl
  801b61:	75 0e                	jne    801b71 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b63:	83 ef 04             	sub    $0x4,%edi
  801b66:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b69:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b6c:	fd                   	std    
  801b6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b6f:	eb 09                	jmp    801b7a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b71:	83 ef 01             	sub    $0x1,%edi
  801b74:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b77:	fd                   	std    
  801b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b7a:	fc                   	cld    
  801b7b:	eb 1d                	jmp    801b9a <memmove+0x64>
  801b7d:	89 f2                	mov    %esi,%edx
  801b7f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b81:	f6 c2 03             	test   $0x3,%dl
  801b84:	75 0f                	jne    801b95 <memmove+0x5f>
  801b86:	f6 c1 03             	test   $0x3,%cl
  801b89:	75 0a                	jne    801b95 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b8b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b8e:	89 c7                	mov    %eax,%edi
  801b90:	fc                   	cld    
  801b91:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b93:	eb 05                	jmp    801b9a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b95:	89 c7                	mov    %eax,%edi
  801b97:	fc                   	cld    
  801b98:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b9a:	5e                   	pop    %esi
  801b9b:	5f                   	pop    %edi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801ba4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bab:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	89 04 24             	mov    %eax,(%esp)
  801bb8:	e8 79 ff ff ff       	call   801b36 <memmove>
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	57                   	push   %edi
  801bc3:	56                   	push   %esi
  801bc4:	53                   	push   %ebx
  801bc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bcb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bce:	8d 78 ff             	lea    -0x1(%eax),%edi
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	74 36                	je     801c0b <memcmp+0x4c>
		if (*s1 != *s2)
  801bd5:	0f b6 03             	movzbl (%ebx),%eax
  801bd8:	0f b6 0e             	movzbl (%esi),%ecx
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	38 c8                	cmp    %cl,%al
  801be2:	74 1c                	je     801c00 <memcmp+0x41>
  801be4:	eb 10                	jmp    801bf6 <memcmp+0x37>
  801be6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801beb:	83 c2 01             	add    $0x1,%edx
  801bee:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801bf2:	38 c8                	cmp    %cl,%al
  801bf4:	74 0a                	je     801c00 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801bf6:	0f b6 c0             	movzbl %al,%eax
  801bf9:	0f b6 c9             	movzbl %cl,%ecx
  801bfc:	29 c8                	sub    %ecx,%eax
  801bfe:	eb 10                	jmp    801c10 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c00:	39 fa                	cmp    %edi,%edx
  801c02:	75 e2                	jne    801be6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb 05                	jmp    801c10 <memcmp+0x51>
  801c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c10:	5b                   	pop    %ebx
  801c11:	5e                   	pop    %esi
  801c12:	5f                   	pop    %edi
  801c13:	5d                   	pop    %ebp
  801c14:	c3                   	ret    

00801c15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	53                   	push   %ebx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801c1f:	89 c2                	mov    %eax,%edx
  801c21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c24:	39 d0                	cmp    %edx,%eax
  801c26:	73 13                	jae    801c3b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c28:	89 d9                	mov    %ebx,%ecx
  801c2a:	38 18                	cmp    %bl,(%eax)
  801c2c:	75 06                	jne    801c34 <memfind+0x1f>
  801c2e:	eb 0b                	jmp    801c3b <memfind+0x26>
  801c30:	38 08                	cmp    %cl,(%eax)
  801c32:	74 07                	je     801c3b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c34:	83 c0 01             	add    $0x1,%eax
  801c37:	39 d0                	cmp    %edx,%eax
  801c39:	75 f5                	jne    801c30 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c3b:	5b                   	pop    %ebx
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	57                   	push   %edi
  801c42:	56                   	push   %esi
  801c43:	53                   	push   %ebx
  801c44:	8b 55 08             	mov    0x8(%ebp),%edx
  801c47:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4a:	0f b6 0a             	movzbl (%edx),%ecx
  801c4d:	80 f9 09             	cmp    $0x9,%cl
  801c50:	74 05                	je     801c57 <strtol+0x19>
  801c52:	80 f9 20             	cmp    $0x20,%cl
  801c55:	75 10                	jne    801c67 <strtol+0x29>
		s++;
  801c57:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c5a:	0f b6 0a             	movzbl (%edx),%ecx
  801c5d:	80 f9 09             	cmp    $0x9,%cl
  801c60:	74 f5                	je     801c57 <strtol+0x19>
  801c62:	80 f9 20             	cmp    $0x20,%cl
  801c65:	74 f0                	je     801c57 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c67:	80 f9 2b             	cmp    $0x2b,%cl
  801c6a:	75 0a                	jne    801c76 <strtol+0x38>
		s++;
  801c6c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c6f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c74:	eb 11                	jmp    801c87 <strtol+0x49>
  801c76:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c7b:	80 f9 2d             	cmp    $0x2d,%cl
  801c7e:	75 07                	jne    801c87 <strtol+0x49>
		s++, neg = 1;
  801c80:	83 c2 01             	add    $0x1,%edx
  801c83:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c87:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c8c:	75 15                	jne    801ca3 <strtol+0x65>
  801c8e:	80 3a 30             	cmpb   $0x30,(%edx)
  801c91:	75 10                	jne    801ca3 <strtol+0x65>
  801c93:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801c97:	75 0a                	jne    801ca3 <strtol+0x65>
		s += 2, base = 16;
  801c99:	83 c2 02             	add    $0x2,%edx
  801c9c:	b8 10 00 00 00       	mov    $0x10,%eax
  801ca1:	eb 10                	jmp    801cb3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	75 0c                	jne    801cb3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ca7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ca9:	80 3a 30             	cmpb   $0x30,(%edx)
  801cac:	75 05                	jne    801cb3 <strtol+0x75>
		s++, base = 8;
  801cae:	83 c2 01             	add    $0x1,%edx
  801cb1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801cb3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cbb:	0f b6 0a             	movzbl (%edx),%ecx
  801cbe:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801cc1:	89 f0                	mov    %esi,%eax
  801cc3:	3c 09                	cmp    $0x9,%al
  801cc5:	77 08                	ja     801ccf <strtol+0x91>
			dig = *s - '0';
  801cc7:	0f be c9             	movsbl %cl,%ecx
  801cca:	83 e9 30             	sub    $0x30,%ecx
  801ccd:	eb 20                	jmp    801cef <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801ccf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801cd2:	89 f0                	mov    %esi,%eax
  801cd4:	3c 19                	cmp    $0x19,%al
  801cd6:	77 08                	ja     801ce0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801cd8:	0f be c9             	movsbl %cl,%ecx
  801cdb:	83 e9 57             	sub    $0x57,%ecx
  801cde:	eb 0f                	jmp    801cef <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801ce0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801ce3:	89 f0                	mov    %esi,%eax
  801ce5:	3c 19                	cmp    $0x19,%al
  801ce7:	77 16                	ja     801cff <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ce9:	0f be c9             	movsbl %cl,%ecx
  801cec:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801cef:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801cf2:	7d 0f                	jge    801d03 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801cf4:	83 c2 01             	add    $0x1,%edx
  801cf7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801cfb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801cfd:	eb bc                	jmp    801cbb <strtol+0x7d>
  801cff:	89 d8                	mov    %ebx,%eax
  801d01:	eb 02                	jmp    801d05 <strtol+0xc7>
  801d03:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801d05:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d09:	74 05                	je     801d10 <strtol+0xd2>
		*endptr = (char *) s;
  801d0b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d0e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801d10:	f7 d8                	neg    %eax
  801d12:	85 ff                	test   %edi,%edi
  801d14:	0f 44 c3             	cmove  %ebx,%eax
}
  801d17:	5b                   	pop    %ebx
  801d18:	5e                   	pop    %esi
  801d19:	5f                   	pop    %edi
  801d1a:	5d                   	pop    %ebp
  801d1b:	c3                   	ret    

00801d1c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	56                   	push   %esi
  801d20:	53                   	push   %ebx
  801d21:	83 ec 10             	sub    $0x10,%esp
  801d24:	8b 75 08             	mov    0x8(%ebp),%esi
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801d2d:	83 f8 01             	cmp    $0x1,%eax
  801d30:	19 c0                	sbb    %eax,%eax
  801d32:	f7 d0                	not    %eax
  801d34:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801d39:	89 04 24             	mov    %eax,(%esp)
  801d3c:	e8 a8 e6 ff ff       	call   8003e9 <sys_ipc_recv>
	if (err_code < 0) {
  801d41:	85 c0                	test   %eax,%eax
  801d43:	79 16                	jns    801d5b <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801d45:	85 f6                	test   %esi,%esi
  801d47:	74 06                	je     801d4f <ipc_recv+0x33>
  801d49:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d4f:	85 db                	test   %ebx,%ebx
  801d51:	74 2c                	je     801d7f <ipc_recv+0x63>
  801d53:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d59:	eb 24                	jmp    801d7f <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d5b:	85 f6                	test   %esi,%esi
  801d5d:	74 0a                	je     801d69 <ipc_recv+0x4d>
  801d5f:	a1 04 40 80 00       	mov    0x804004,%eax
  801d64:	8b 40 74             	mov    0x74(%eax),%eax
  801d67:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d69:	85 db                	test   %ebx,%ebx
  801d6b:	74 0a                	je     801d77 <ipc_recv+0x5b>
  801d6d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d72:	8b 40 78             	mov    0x78(%eax),%eax
  801d75:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d77:	a1 04 40 80 00       	mov    0x804004,%eax
  801d7c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	57                   	push   %edi
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	83 ec 1c             	sub    $0x1c,%esp
  801d8f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d92:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d95:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d98:	eb 25                	jmp    801dbf <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d9a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d9d:	74 20                	je     801dbf <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801da3:	c7 44 24 08 40 25 80 	movl   $0x802540,0x8(%esp)
  801daa:	00 
  801dab:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801db2:	00 
  801db3:	c7 04 24 4c 25 80 00 	movl   $0x80254c,(%esp)
  801dba:	e8 27 f4 ff ff       	call   8011e6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801dbf:	85 db                	test   %ebx,%ebx
  801dc1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dc6:	0f 45 c3             	cmovne %ebx,%eax
  801dc9:	8b 55 14             	mov    0x14(%ebp),%edx
  801dcc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dd0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dd8:	89 3c 24             	mov    %edi,(%esp)
  801ddb:	e8 e6 e5 ff ff       	call   8003c6 <sys_ipc_try_send>
  801de0:	85 c0                	test   %eax,%eax
  801de2:	75 b6                	jne    801d9a <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801de4:	83 c4 1c             	add    $0x1c,%esp
  801de7:	5b                   	pop    %ebx
  801de8:	5e                   	pop    %esi
  801de9:	5f                   	pop    %edi
  801dea:	5d                   	pop    %ebp
  801deb:	c3                   	ret    

00801dec <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801df2:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801df7:	39 c8                	cmp    %ecx,%eax
  801df9:	74 17                	je     801e12 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dfb:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e00:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e03:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e09:	8b 52 50             	mov    0x50(%edx),%edx
  801e0c:	39 ca                	cmp    %ecx,%edx
  801e0e:	75 14                	jne    801e24 <ipc_find_env+0x38>
  801e10:	eb 05                	jmp    801e17 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e12:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e17:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e1a:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e1f:	8b 40 40             	mov    0x40(%eax),%eax
  801e22:	eb 0e                	jmp    801e32 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e24:	83 c0 01             	add    $0x1,%eax
  801e27:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e2c:	75 d2                	jne    801e00 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e2e:	66 b8 00 00          	mov    $0x0,%ax
}
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    

00801e34 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e3a:	89 d0                	mov    %edx,%eax
  801e3c:	c1 e8 16             	shr    $0x16,%eax
  801e3f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e46:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e4b:	f6 c1 01             	test   $0x1,%cl
  801e4e:	74 1d                	je     801e6d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e50:	c1 ea 0c             	shr    $0xc,%edx
  801e53:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e5a:	f6 c2 01             	test   $0x1,%dl
  801e5d:	74 0e                	je     801e6d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e5f:	c1 ea 0c             	shr    $0xc,%edx
  801e62:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e69:	ef 
  801e6a:	0f b7 c0             	movzwl %ax,%eax
}
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    
  801e6f:	90                   	nop

00801e70 <__udivdi3>:
  801e70:	55                   	push   %ebp
  801e71:	57                   	push   %edi
  801e72:	56                   	push   %esi
  801e73:	83 ec 0c             	sub    $0xc,%esp
  801e76:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e7a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e7e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e82:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e86:	85 c0                	test   %eax,%eax
  801e88:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e8c:	89 ea                	mov    %ebp,%edx
  801e8e:	89 0c 24             	mov    %ecx,(%esp)
  801e91:	75 2d                	jne    801ec0 <__udivdi3+0x50>
  801e93:	39 e9                	cmp    %ebp,%ecx
  801e95:	77 61                	ja     801ef8 <__udivdi3+0x88>
  801e97:	85 c9                	test   %ecx,%ecx
  801e99:	89 ce                	mov    %ecx,%esi
  801e9b:	75 0b                	jne    801ea8 <__udivdi3+0x38>
  801e9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801ea2:	31 d2                	xor    %edx,%edx
  801ea4:	f7 f1                	div    %ecx
  801ea6:	89 c6                	mov    %eax,%esi
  801ea8:	31 d2                	xor    %edx,%edx
  801eaa:	89 e8                	mov    %ebp,%eax
  801eac:	f7 f6                	div    %esi
  801eae:	89 c5                	mov    %eax,%ebp
  801eb0:	89 f8                	mov    %edi,%eax
  801eb2:	f7 f6                	div    %esi
  801eb4:	89 ea                	mov    %ebp,%edx
  801eb6:	83 c4 0c             	add    $0xc,%esp
  801eb9:	5e                   	pop    %esi
  801eba:	5f                   	pop    %edi
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    
  801ebd:	8d 76 00             	lea    0x0(%esi),%esi
  801ec0:	39 e8                	cmp    %ebp,%eax
  801ec2:	77 24                	ja     801ee8 <__udivdi3+0x78>
  801ec4:	0f bd e8             	bsr    %eax,%ebp
  801ec7:	83 f5 1f             	xor    $0x1f,%ebp
  801eca:	75 3c                	jne    801f08 <__udivdi3+0x98>
  801ecc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ed0:	39 34 24             	cmp    %esi,(%esp)
  801ed3:	0f 86 9f 00 00 00    	jbe    801f78 <__udivdi3+0x108>
  801ed9:	39 d0                	cmp    %edx,%eax
  801edb:	0f 82 97 00 00 00    	jb     801f78 <__udivdi3+0x108>
  801ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	31 d2                	xor    %edx,%edx
  801eea:	31 c0                	xor    %eax,%eax
  801eec:	83 c4 0c             	add    $0xc,%esp
  801eef:	5e                   	pop    %esi
  801ef0:	5f                   	pop    %edi
  801ef1:	5d                   	pop    %ebp
  801ef2:	c3                   	ret    
  801ef3:	90                   	nop
  801ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ef8:	89 f8                	mov    %edi,%eax
  801efa:	f7 f1                	div    %ecx
  801efc:	31 d2                	xor    %edx,%edx
  801efe:	83 c4 0c             	add    $0xc,%esp
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    
  801f05:	8d 76 00             	lea    0x0(%esi),%esi
  801f08:	89 e9                	mov    %ebp,%ecx
  801f0a:	8b 3c 24             	mov    (%esp),%edi
  801f0d:	d3 e0                	shl    %cl,%eax
  801f0f:	89 c6                	mov    %eax,%esi
  801f11:	b8 20 00 00 00       	mov    $0x20,%eax
  801f16:	29 e8                	sub    %ebp,%eax
  801f18:	89 c1                	mov    %eax,%ecx
  801f1a:	d3 ef                	shr    %cl,%edi
  801f1c:	89 e9                	mov    %ebp,%ecx
  801f1e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f22:	8b 3c 24             	mov    (%esp),%edi
  801f25:	09 74 24 08          	or     %esi,0x8(%esp)
  801f29:	89 d6                	mov    %edx,%esi
  801f2b:	d3 e7                	shl    %cl,%edi
  801f2d:	89 c1                	mov    %eax,%ecx
  801f2f:	89 3c 24             	mov    %edi,(%esp)
  801f32:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f36:	d3 ee                	shr    %cl,%esi
  801f38:	89 e9                	mov    %ebp,%ecx
  801f3a:	d3 e2                	shl    %cl,%edx
  801f3c:	89 c1                	mov    %eax,%ecx
  801f3e:	d3 ef                	shr    %cl,%edi
  801f40:	09 d7                	or     %edx,%edi
  801f42:	89 f2                	mov    %esi,%edx
  801f44:	89 f8                	mov    %edi,%eax
  801f46:	f7 74 24 08          	divl   0x8(%esp)
  801f4a:	89 d6                	mov    %edx,%esi
  801f4c:	89 c7                	mov    %eax,%edi
  801f4e:	f7 24 24             	mull   (%esp)
  801f51:	39 d6                	cmp    %edx,%esi
  801f53:	89 14 24             	mov    %edx,(%esp)
  801f56:	72 30                	jb     801f88 <__udivdi3+0x118>
  801f58:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f5c:	89 e9                	mov    %ebp,%ecx
  801f5e:	d3 e2                	shl    %cl,%edx
  801f60:	39 c2                	cmp    %eax,%edx
  801f62:	73 05                	jae    801f69 <__udivdi3+0xf9>
  801f64:	3b 34 24             	cmp    (%esp),%esi
  801f67:	74 1f                	je     801f88 <__udivdi3+0x118>
  801f69:	89 f8                	mov    %edi,%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	e9 7a ff ff ff       	jmp    801eec <__udivdi3+0x7c>
  801f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f78:	31 d2                	xor    %edx,%edx
  801f7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7f:	e9 68 ff ff ff       	jmp    801eec <__udivdi3+0x7c>
  801f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f88:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f8b:	31 d2                	xor    %edx,%edx
  801f8d:	83 c4 0c             	add    $0xc,%esp
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    
  801f94:	66 90                	xchg   %ax,%ax
  801f96:	66 90                	xchg   %ax,%ax
  801f98:	66 90                	xchg   %ax,%ax
  801f9a:	66 90                	xchg   %ax,%ax
  801f9c:	66 90                	xchg   %ax,%ax
  801f9e:	66 90                	xchg   %ax,%ax

00801fa0 <__umoddi3>:
  801fa0:	55                   	push   %ebp
  801fa1:	57                   	push   %edi
  801fa2:	56                   	push   %esi
  801fa3:	83 ec 14             	sub    $0x14,%esp
  801fa6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801faa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fb2:	89 c7                	mov    %eax,%edi
  801fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fbc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fc0:	89 34 24             	mov    %esi,(%esp)
  801fc3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	89 c2                	mov    %eax,%edx
  801fcb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fcf:	75 17                	jne    801fe8 <__umoddi3+0x48>
  801fd1:	39 fe                	cmp    %edi,%esi
  801fd3:	76 4b                	jbe    802020 <__umoddi3+0x80>
  801fd5:	89 c8                	mov    %ecx,%eax
  801fd7:	89 fa                	mov    %edi,%edx
  801fd9:	f7 f6                	div    %esi
  801fdb:	89 d0                	mov    %edx,%eax
  801fdd:	31 d2                	xor    %edx,%edx
  801fdf:	83 c4 14             	add    $0x14,%esp
  801fe2:	5e                   	pop    %esi
  801fe3:	5f                   	pop    %edi
  801fe4:	5d                   	pop    %ebp
  801fe5:	c3                   	ret    
  801fe6:	66 90                	xchg   %ax,%ax
  801fe8:	39 f8                	cmp    %edi,%eax
  801fea:	77 54                	ja     802040 <__umoddi3+0xa0>
  801fec:	0f bd e8             	bsr    %eax,%ebp
  801fef:	83 f5 1f             	xor    $0x1f,%ebp
  801ff2:	75 5c                	jne    802050 <__umoddi3+0xb0>
  801ff4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801ff8:	39 3c 24             	cmp    %edi,(%esp)
  801ffb:	0f 87 e7 00 00 00    	ja     8020e8 <__umoddi3+0x148>
  802001:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802005:	29 f1                	sub    %esi,%ecx
  802007:	19 c7                	sbb    %eax,%edi
  802009:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80200d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802011:	8b 44 24 08          	mov    0x8(%esp),%eax
  802015:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802019:	83 c4 14             	add    $0x14,%esp
  80201c:	5e                   	pop    %esi
  80201d:	5f                   	pop    %edi
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    
  802020:	85 f6                	test   %esi,%esi
  802022:	89 f5                	mov    %esi,%ebp
  802024:	75 0b                	jne    802031 <__umoddi3+0x91>
  802026:	b8 01 00 00 00       	mov    $0x1,%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	f7 f6                	div    %esi
  80202f:	89 c5                	mov    %eax,%ebp
  802031:	8b 44 24 04          	mov    0x4(%esp),%eax
  802035:	31 d2                	xor    %edx,%edx
  802037:	f7 f5                	div    %ebp
  802039:	89 c8                	mov    %ecx,%eax
  80203b:	f7 f5                	div    %ebp
  80203d:	eb 9c                	jmp    801fdb <__umoddi3+0x3b>
  80203f:	90                   	nop
  802040:	89 c8                	mov    %ecx,%eax
  802042:	89 fa                	mov    %edi,%edx
  802044:	83 c4 14             	add    $0x14,%esp
  802047:	5e                   	pop    %esi
  802048:	5f                   	pop    %edi
  802049:	5d                   	pop    %ebp
  80204a:	c3                   	ret    
  80204b:	90                   	nop
  80204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802050:	8b 04 24             	mov    (%esp),%eax
  802053:	be 20 00 00 00       	mov    $0x20,%esi
  802058:	89 e9                	mov    %ebp,%ecx
  80205a:	29 ee                	sub    %ebp,%esi
  80205c:	d3 e2                	shl    %cl,%edx
  80205e:	89 f1                	mov    %esi,%ecx
  802060:	d3 e8                	shr    %cl,%eax
  802062:	89 e9                	mov    %ebp,%ecx
  802064:	89 44 24 04          	mov    %eax,0x4(%esp)
  802068:	8b 04 24             	mov    (%esp),%eax
  80206b:	09 54 24 04          	or     %edx,0x4(%esp)
  80206f:	89 fa                	mov    %edi,%edx
  802071:	d3 e0                	shl    %cl,%eax
  802073:	89 f1                	mov    %esi,%ecx
  802075:	89 44 24 08          	mov    %eax,0x8(%esp)
  802079:	8b 44 24 10          	mov    0x10(%esp),%eax
  80207d:	d3 ea                	shr    %cl,%edx
  80207f:	89 e9                	mov    %ebp,%ecx
  802081:	d3 e7                	shl    %cl,%edi
  802083:	89 f1                	mov    %esi,%ecx
  802085:	d3 e8                	shr    %cl,%eax
  802087:	89 e9                	mov    %ebp,%ecx
  802089:	09 f8                	or     %edi,%eax
  80208b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80208f:	f7 74 24 04          	divl   0x4(%esp)
  802093:	d3 e7                	shl    %cl,%edi
  802095:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802099:	89 d7                	mov    %edx,%edi
  80209b:	f7 64 24 08          	mull   0x8(%esp)
  80209f:	39 d7                	cmp    %edx,%edi
  8020a1:	89 c1                	mov    %eax,%ecx
  8020a3:	89 14 24             	mov    %edx,(%esp)
  8020a6:	72 2c                	jb     8020d4 <__umoddi3+0x134>
  8020a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8020ac:	72 22                	jb     8020d0 <__umoddi3+0x130>
  8020ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020b2:	29 c8                	sub    %ecx,%eax
  8020b4:	19 d7                	sbb    %edx,%edi
  8020b6:	89 e9                	mov    %ebp,%ecx
  8020b8:	89 fa                	mov    %edi,%edx
  8020ba:	d3 e8                	shr    %cl,%eax
  8020bc:	89 f1                	mov    %esi,%ecx
  8020be:	d3 e2                	shl    %cl,%edx
  8020c0:	89 e9                	mov    %ebp,%ecx
  8020c2:	d3 ef                	shr    %cl,%edi
  8020c4:	09 d0                	or     %edx,%eax
  8020c6:	89 fa                	mov    %edi,%edx
  8020c8:	83 c4 14             	add    $0x14,%esp
  8020cb:	5e                   	pop    %esi
  8020cc:	5f                   	pop    %edi
  8020cd:	5d                   	pop    %ebp
  8020ce:	c3                   	ret    
  8020cf:	90                   	nop
  8020d0:	39 d7                	cmp    %edx,%edi
  8020d2:	75 da                	jne    8020ae <__umoddi3+0x10e>
  8020d4:	8b 14 24             	mov    (%esp),%edx
  8020d7:	89 c1                	mov    %eax,%ecx
  8020d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020e1:	eb cb                	jmp    8020ae <__umoddi3+0x10e>
  8020e3:	90                   	nop
  8020e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020ec:	0f 82 0f ff ff ff    	jb     802001 <__umoddi3+0x61>
  8020f2:	e9 1a ff ff ff       	jmp    802011 <__umoddi3+0x71>
