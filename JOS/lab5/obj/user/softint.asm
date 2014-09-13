
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 09 00 00 00       	call   80003a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $14");	// page fault
  800036:	cd 0e                	int    $0xe
}
  800038:	5d                   	pop    %ebp
  800039:	c3                   	ret    

0080003a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003a:	55                   	push   %ebp
  80003b:	89 e5                	mov    %esp,%ebp
  80003d:	56                   	push   %esi
  80003e:	53                   	push   %ebx
  80003f:	83 ec 10             	sub    $0x10,%esp
  800042:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800045:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800048:	e8 0d 01 00 00       	call   80015a <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80004d:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800053:	39 c2                	cmp    %eax,%edx
  800055:	74 17                	je     80006e <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800057:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80005c:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80005f:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800065:	8b 49 40             	mov    0x40(%ecx),%ecx
  800068:	39 c1                	cmp    %eax,%ecx
  80006a:	75 18                	jne    800084 <libmain+0x4a>
  80006c:	eb 05                	jmp    800073 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80006e:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800073:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800076:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80007c:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800082:	eb 0b                	jmp    80008f <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800084:	83 c2 01             	add    $0x1,%edx
  800087:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80008d:	75 cd                	jne    80005c <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008f:	85 db                	test   %ebx,%ebx
  800091:	7e 07                	jle    80009a <libmain+0x60>
		binaryname = argv[0];
  800093:	8b 06                	mov    (%esi),%eax
  800095:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80009e:	89 1c 24             	mov    %ebx,(%esp)
  8000a1:	e8 8d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a6:	e8 07 00 00 00       	call   8000b2 <exit>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	5b                   	pop    %ebx
  8000af:	5e                   	pop    %esi
  8000b0:	5d                   	pop    %ebp
  8000b1:	c3                   	ret    

008000b2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b2:	55                   	push   %ebp
  8000b3:	89 e5                	mov    %esp,%ebp
  8000b5:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000b8:	e8 59 05 00 00       	call   800616 <close_all>
	sys_env_destroy(0);
  8000bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c4:	e8 3f 00 00 00       	call   800108 <sys_env_destroy>
}
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000dc:	89 c3                	mov    %eax,%ebx
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	89 c6                	mov    %eax,%esi
  8000e2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	89 d3                	mov    %edx,%ebx
  8000fd:	89 d7                	mov    %edx,%edi
  8000ff:	89 d6                	mov    %edx,%esi
  800101:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5f                   	pop    %edi
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800111:	b9 00 00 00 00       	mov    $0x0,%ecx
  800116:	b8 03 00 00 00       	mov    $0x3,%eax
  80011b:	8b 55 08             	mov    0x8(%ebp),%edx
  80011e:	89 cb                	mov    %ecx,%ebx
  800120:	89 cf                	mov    %ecx,%edi
  800122:	89 ce                	mov    %ecx,%esi
  800124:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800126:	85 c0                	test   %eax,%eax
  800128:	7e 28                	jle    800152 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80012a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80012e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800135:	00 
  800136:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  80013d:	00 
  80013e:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  80014d:	e8 54 10 00 00       	call   8011a6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800152:	83 c4 2c             	add    $0x2c,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5f                   	pop    %edi
  800158:	5d                   	pop    %ebp
  800159:	c3                   	ret    

0080015a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	57                   	push   %edi
  80015e:	56                   	push   %esi
  80015f:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800160:	ba 00 00 00 00       	mov    $0x0,%edx
  800165:	b8 02 00 00 00       	mov    $0x2,%eax
  80016a:	89 d1                	mov    %edx,%ecx
  80016c:	89 d3                	mov    %edx,%ebx
  80016e:	89 d7                	mov    %edx,%edi
  800170:	89 d6                	mov    %edx,%esi
  800172:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_yield>:

void
sys_yield(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	57                   	push   %edi
  80017d:	56                   	push   %esi
  80017e:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80017f:	ba 00 00 00 00       	mov    $0x0,%edx
  800184:	b8 0b 00 00 00       	mov    $0xb,%eax
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	89 d3                	mov    %edx,%ebx
  80018d:	89 d7                	mov    %edx,%edi
  80018f:	89 d6                	mov    %edx,%esi
  800191:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
  80019e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a1:	be 00 00 00 00       	mov    $0x0,%esi
  8001a6:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b4:	89 f7                	mov    %esi,%edi
  8001b6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001b8:	85 c0                	test   %eax,%eax
  8001ba:	7e 28                	jle    8001e4 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c0:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001c7:	00 
  8001c8:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  8001cf:	00 
  8001d0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001d7:	00 
  8001d8:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  8001df:	e8 c2 0f 00 00       	call   8011a6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001e4:	83 c4 2c             	add    $0x2c,%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    

008001ec <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	57                   	push   %edi
  8001f0:	56                   	push   %esi
  8001f1:	53                   	push   %ebx
  8001f2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001f5:	b8 05 00 00 00       	mov    $0x5,%eax
  8001fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800200:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800203:	8b 7d 14             	mov    0x14(%ebp),%edi
  800206:	8b 75 18             	mov    0x18(%ebp),%esi
  800209:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80020b:	85 c0                	test   %eax,%eax
  80020d:	7e 28                	jle    800237 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80020f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800213:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80021a:	00 
  80021b:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  800222:	00 
  800223:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80022a:	00 
  80022b:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  800232:	e8 6f 0f 00 00       	call   8011a6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800237:	83 c4 2c             	add    $0x2c,%esp
  80023a:	5b                   	pop    %ebx
  80023b:	5e                   	pop    %esi
  80023c:	5f                   	pop    %edi
  80023d:	5d                   	pop    %ebp
  80023e:	c3                   	ret    

0080023f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800248:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024d:	b8 06 00 00 00       	mov    $0x6,%eax
  800252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800255:	8b 55 08             	mov    0x8(%ebp),%edx
  800258:	89 df                	mov    %ebx,%edi
  80025a:	89 de                	mov    %ebx,%esi
  80025c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80025e:	85 c0                	test   %eax,%eax
  800260:	7e 28                	jle    80028a <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800262:	89 44 24 10          	mov    %eax,0x10(%esp)
  800266:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80026d:	00 
  80026e:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  800275:	00 
  800276:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80027d:	00 
  80027e:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  800285:	e8 1c 0f 00 00       	call   8011a6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80028a:	83 c4 2c             	add    $0x2c,%esp
  80028d:	5b                   	pop    %ebx
  80028e:	5e                   	pop    %esi
  80028f:	5f                   	pop    %edi
  800290:	5d                   	pop    %ebp
  800291:	c3                   	ret    

00800292 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	57                   	push   %edi
  800296:	56                   	push   %esi
  800297:	53                   	push   %ebx
  800298:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80029b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a0:	b8 08 00 00 00       	mov    $0x8,%eax
  8002a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ab:	89 df                	mov    %ebx,%edi
  8002ad:	89 de                	mov    %ebx,%esi
  8002af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b1:	85 c0                	test   %eax,%eax
  8002b3:	7e 28                	jle    8002dd <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002b9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002c0:	00 
  8002c1:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  8002d8:	e8 c9 0e 00 00       	call   8011a6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002dd:	83 c4 2c             	add    $0x2c,%esp
  8002e0:	5b                   	pop    %ebx
  8002e1:	5e                   	pop    %esi
  8002e2:	5f                   	pop    %edi
  8002e3:	5d                   	pop    %ebp
  8002e4:	c3                   	ret    

008002e5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002e5:	55                   	push   %ebp
  8002e6:	89 e5                	mov    %esp,%ebp
  8002e8:	57                   	push   %edi
  8002e9:	56                   	push   %esi
  8002ea:	53                   	push   %ebx
  8002eb:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fe:	89 df                	mov    %ebx,%edi
  800300:	89 de                	mov    %ebx,%esi
  800302:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800304:	85 c0                	test   %eax,%eax
  800306:	7e 28                	jle    800330 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800308:	89 44 24 10          	mov    %eax,0x10(%esp)
  80030c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800313:	00 
  800314:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  80031b:	00 
  80031c:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800323:	00 
  800324:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  80032b:	e8 76 0e 00 00       	call   8011a6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800330:	83 c4 2c             	add    $0x2c,%esp
  800333:	5b                   	pop    %ebx
  800334:	5e                   	pop    %esi
  800335:	5f                   	pop    %edi
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    

00800338 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	57                   	push   %edi
  80033c:	56                   	push   %esi
  80033d:	53                   	push   %ebx
  80033e:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800341:	bb 00 00 00 00       	mov    $0x0,%ebx
  800346:	b8 0a 00 00 00       	mov    $0xa,%eax
  80034b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034e:	8b 55 08             	mov    0x8(%ebp),%edx
  800351:	89 df                	mov    %ebx,%edi
  800353:	89 de                	mov    %ebx,%esi
  800355:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800357:	85 c0                	test   %eax,%eax
  800359:	7e 28                	jle    800383 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80035b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80035f:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800366:	00 
  800367:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  80036e:	00 
  80036f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800376:	00 
  800377:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  80037e:	e8 23 0e 00 00       	call   8011a6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800383:	83 c4 2c             	add    $0x2c,%esp
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    

0080038b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800391:	be 00 00 00 00       	mov    $0x0,%esi
  800396:	b8 0c 00 00 00       	mov    $0xc,%eax
  80039b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80039e:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003a7:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003a9:	5b                   	pop    %ebx
  8003aa:	5e                   	pop    %esi
  8003ab:	5f                   	pop    %edi
  8003ac:	5d                   	pop    %ebp
  8003ad:	c3                   	ret    

008003ae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003ae:	55                   	push   %ebp
  8003af:	89 e5                	mov    %esp,%ebp
  8003b1:	57                   	push   %edi
  8003b2:	56                   	push   %esi
  8003b3:	53                   	push   %ebx
  8003b4:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003bc:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c4:	89 cb                	mov    %ecx,%ebx
  8003c6:	89 cf                	mov    %ecx,%edi
  8003c8:	89 ce                	mov    %ecx,%esi
  8003ca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003cc:	85 c0                	test   %eax,%eax
  8003ce:	7e 28                	jle    8003f8 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003d4:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003db:	00 
  8003dc:	c7 44 24 08 ca 20 80 	movl   $0x8020ca,0x8(%esp)
  8003e3:	00 
  8003e4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8003eb:	00 
  8003ec:	c7 04 24 e7 20 80 00 	movl   $0x8020e7,(%esp)
  8003f3:	e8 ae 0d 00 00       	call   8011a6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003f8:	83 c4 2c             	add    $0x2c,%esp
  8003fb:	5b                   	pop    %ebx
  8003fc:	5e                   	pop    %esi
  8003fd:	5f                   	pop    %edi
  8003fe:	5d                   	pop    %ebp
  8003ff:	c3                   	ret    

00800400 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800403:	8b 45 08             	mov    0x8(%ebp),%eax
  800406:	05 00 00 00 30       	add    $0x30000000,%eax
  80040b:	c1 e8 0c             	shr    $0xc,%eax
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80041b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800420:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800425:	5d                   	pop    %ebp
  800426:	c3                   	ret    

00800427 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800427:	55                   	push   %ebp
  800428:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80042a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80042f:	a8 01                	test   $0x1,%al
  800431:	74 34                	je     800467 <fd_alloc+0x40>
  800433:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800438:	a8 01                	test   $0x1,%al
  80043a:	74 32                	je     80046e <fd_alloc+0x47>
  80043c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800441:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800443:	89 c2                	mov    %eax,%edx
  800445:	c1 ea 16             	shr    $0x16,%edx
  800448:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80044f:	f6 c2 01             	test   $0x1,%dl
  800452:	74 1f                	je     800473 <fd_alloc+0x4c>
  800454:	89 c2                	mov    %eax,%edx
  800456:	c1 ea 0c             	shr    $0xc,%edx
  800459:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800460:	f6 c2 01             	test   $0x1,%dl
  800463:	75 1a                	jne    80047f <fd_alloc+0x58>
  800465:	eb 0c                	jmp    800473 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800467:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80046c:	eb 05                	jmp    800473 <fd_alloc+0x4c>
  80046e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	89 08                	mov    %ecx,(%eax)
			return 0;
  800478:	b8 00 00 00 00       	mov    $0x0,%eax
  80047d:	eb 1a                	jmp    800499 <fd_alloc+0x72>
  80047f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800484:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800489:	75 b6                	jne    800441 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800494:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800499:	5d                   	pop    %ebp
  80049a:	c3                   	ret    

0080049b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004a1:	83 f8 1f             	cmp    $0x1f,%eax
  8004a4:	77 36                	ja     8004dc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004a6:	c1 e0 0c             	shl    $0xc,%eax
  8004a9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004ae:	89 c2                	mov    %eax,%edx
  8004b0:	c1 ea 16             	shr    $0x16,%edx
  8004b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004ba:	f6 c2 01             	test   $0x1,%dl
  8004bd:	74 24                	je     8004e3 <fd_lookup+0x48>
  8004bf:	89 c2                	mov    %eax,%edx
  8004c1:	c1 ea 0c             	shr    $0xc,%edx
  8004c4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004cb:	f6 c2 01             	test   $0x1,%dl
  8004ce:	74 1a                	je     8004ea <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	89 02                	mov    %eax,(%edx)
	return 0;
  8004d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004da:	eb 13                	jmp    8004ef <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8004dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004e1:	eb 0c                	jmp    8004ef <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8004e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004e8:	eb 05                	jmp    8004ef <fd_lookup+0x54>
  8004ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	53                   	push   %ebx
  8004f5:	83 ec 14             	sub    $0x14,%esp
  8004f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  8004fe:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800504:	75 1e                	jne    800524 <dev_lookup+0x33>
  800506:	eb 0e                	jmp    800516 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800508:	b8 20 30 80 00       	mov    $0x803020,%eax
  80050d:	eb 0c                	jmp    80051b <dev_lookup+0x2a>
  80050f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800514:	eb 05                	jmp    80051b <dev_lookup+0x2a>
  800516:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80051b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80051d:	b8 00 00 00 00       	mov    $0x0,%eax
  800522:	eb 38                	jmp    80055c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800524:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80052a:	74 dc                	je     800508 <dev_lookup+0x17>
  80052c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  800532:	74 db                	je     80050f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800534:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80053a:	8b 52 48             	mov    0x48(%edx),%edx
  80053d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800541:	89 54 24 04          	mov    %edx,0x4(%esp)
  800545:	c7 04 24 f8 20 80 00 	movl   $0x8020f8,(%esp)
  80054c:	e8 4e 0d 00 00       	call   80129f <cprintf>
	*dev = 0;
  800551:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800557:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80055c:	83 c4 14             	add    $0x14,%esp
  80055f:	5b                   	pop    %ebx
  800560:	5d                   	pop    %ebp
  800561:	c3                   	ret    

00800562 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800562:	55                   	push   %ebp
  800563:	89 e5                	mov    %esp,%ebp
  800565:	56                   	push   %esi
  800566:	53                   	push   %ebx
  800567:	83 ec 20             	sub    $0x20,%esp
  80056a:	8b 75 08             	mov    0x8(%ebp),%esi
  80056d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800570:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800573:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800577:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80057d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800580:	89 04 24             	mov    %eax,(%esp)
  800583:	e8 13 ff ff ff       	call   80049b <fd_lookup>
  800588:	85 c0                	test   %eax,%eax
  80058a:	78 05                	js     800591 <fd_close+0x2f>
	    || fd != fd2)
  80058c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80058f:	74 0c                	je     80059d <fd_close+0x3b>
		return (must_exist ? r : 0);
  800591:	84 db                	test   %bl,%bl
  800593:	ba 00 00 00 00       	mov    $0x0,%edx
  800598:	0f 44 c2             	cmove  %edx,%eax
  80059b:	eb 3f                	jmp    8005dc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80059d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a4:	8b 06                	mov    (%esi),%eax
  8005a6:	89 04 24             	mov    %eax,(%esp)
  8005a9:	e8 43 ff ff ff       	call   8004f1 <dev_lookup>
  8005ae:	89 c3                	mov    %eax,%ebx
  8005b0:	85 c0                	test   %eax,%eax
  8005b2:	78 16                	js     8005ca <fd_close+0x68>
		if (dev->dev_close)
  8005b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8005ba:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8005bf:	85 c0                	test   %eax,%eax
  8005c1:	74 07                	je     8005ca <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8005c3:	89 34 24             	mov    %esi,(%esp)
  8005c6:	ff d0                	call   *%eax
  8005c8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8005ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005d5:	e8 65 fc ff ff       	call   80023f <sys_page_unmap>
	return r;
  8005da:	89 d8                	mov    %ebx,%eax
}
  8005dc:	83 c4 20             	add    $0x20,%esp
  8005df:	5b                   	pop    %ebx
  8005e0:	5e                   	pop    %esi
  8005e1:	5d                   	pop    %ebp
  8005e2:	c3                   	ret    

008005e3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8005e3:	55                   	push   %ebp
  8005e4:	89 e5                	mov    %esp,%ebp
  8005e6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	89 04 24             	mov    %eax,(%esp)
  8005f6:	e8 a0 fe ff ff       	call   80049b <fd_lookup>
  8005fb:	89 c2                	mov    %eax,%edx
  8005fd:	85 d2                	test   %edx,%edx
  8005ff:	78 13                	js     800614 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800601:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800608:	00 
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	e8 4e ff ff ff       	call   800562 <fd_close>
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <close_all>:

void
close_all(void)
{
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	53                   	push   %ebx
  80061a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80061d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800622:	89 1c 24             	mov    %ebx,(%esp)
  800625:	e8 b9 ff ff ff       	call   8005e3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80062a:	83 c3 01             	add    $0x1,%ebx
  80062d:	83 fb 20             	cmp    $0x20,%ebx
  800630:	75 f0                	jne    800622 <close_all+0xc>
		close(i);
}
  800632:	83 c4 14             	add    $0x14,%esp
  800635:	5b                   	pop    %ebx
  800636:	5d                   	pop    %ebp
  800637:	c3                   	ret    

00800638 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	57                   	push   %edi
  80063c:	56                   	push   %esi
  80063d:	53                   	push   %ebx
  80063e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800641:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800644:	89 44 24 04          	mov    %eax,0x4(%esp)
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	89 04 24             	mov    %eax,(%esp)
  80064e:	e8 48 fe ff ff       	call   80049b <fd_lookup>
  800653:	89 c2                	mov    %eax,%edx
  800655:	85 d2                	test   %edx,%edx
  800657:	0f 88 e1 00 00 00    	js     80073e <dup+0x106>
		return r;
	close(newfdnum);
  80065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800660:	89 04 24             	mov    %eax,(%esp)
  800663:	e8 7b ff ff ff       	call   8005e3 <close>

	newfd = INDEX2FD(newfdnum);
  800668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80066b:	c1 e3 0c             	shl    $0xc,%ebx
  80066e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800677:	89 04 24             	mov    %eax,(%esp)
  80067a:	e8 91 fd ff ff       	call   800410 <fd2data>
  80067f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800681:	89 1c 24             	mov    %ebx,(%esp)
  800684:	e8 87 fd ff ff       	call   800410 <fd2data>
  800689:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80068b:	89 f0                	mov    %esi,%eax
  80068d:	c1 e8 16             	shr    $0x16,%eax
  800690:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800697:	a8 01                	test   $0x1,%al
  800699:	74 43                	je     8006de <dup+0xa6>
  80069b:	89 f0                	mov    %esi,%eax
  80069d:	c1 e8 0c             	shr    $0xc,%eax
  8006a0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006a7:	f6 c2 01             	test   $0x1,%dl
  8006aa:	74 32                	je     8006de <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8006c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8006c7:	00 
  8006c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006d3:	e8 14 fb ff ff       	call   8001ec <sys_page_map>
  8006d8:	89 c6                	mov    %eax,%esi
  8006da:	85 c0                	test   %eax,%eax
  8006dc:	78 3e                	js     80071c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006e1:	89 c2                	mov    %eax,%edx
  8006e3:	c1 ea 0c             	shr    $0xc,%edx
  8006e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8006ed:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8006f3:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8006fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800702:	00 
  800703:	89 44 24 04          	mov    %eax,0x4(%esp)
  800707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80070e:	e8 d9 fa ff ff       	call   8001ec <sys_page_map>
  800713:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800718:	85 f6                	test   %esi,%esi
  80071a:	79 22                	jns    80073e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80071c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800727:	e8 13 fb ff ff       	call   80023f <sys_page_unmap>
	sys_page_unmap(0, nva);
  80072c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800737:	e8 03 fb ff ff       	call   80023f <sys_page_unmap>
	return r;
  80073c:	89 f0                	mov    %esi,%eax
}
  80073e:	83 c4 3c             	add    $0x3c,%esp
  800741:	5b                   	pop    %ebx
  800742:	5e                   	pop    %esi
  800743:	5f                   	pop    %edi
  800744:	5d                   	pop    %ebp
  800745:	c3                   	ret    

00800746 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
  800749:	53                   	push   %ebx
  80074a:	83 ec 24             	sub    $0x24,%esp
  80074d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800750:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800753:	89 44 24 04          	mov    %eax,0x4(%esp)
  800757:	89 1c 24             	mov    %ebx,(%esp)
  80075a:	e8 3c fd ff ff       	call   80049b <fd_lookup>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	85 d2                	test   %edx,%edx
  800763:	78 6d                	js     8007d2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800765:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80076f:	8b 00                	mov    (%eax),%eax
  800771:	89 04 24             	mov    %eax,(%esp)
  800774:	e8 78 fd ff ff       	call   8004f1 <dev_lookup>
  800779:	85 c0                	test   %eax,%eax
  80077b:	78 55                	js     8007d2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8b 50 08             	mov    0x8(%eax),%edx
  800783:	83 e2 03             	and    $0x3,%edx
  800786:	83 fa 01             	cmp    $0x1,%edx
  800789:	75 23                	jne    8007ae <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80078b:	a1 04 40 80 00       	mov    0x804004,%eax
  800790:	8b 40 48             	mov    0x48(%eax),%eax
  800793:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079b:	c7 04 24 39 21 80 00 	movl   $0x802139,(%esp)
  8007a2:	e8 f8 0a 00 00       	call   80129f <cprintf>
		return -E_INVAL;
  8007a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ac:	eb 24                	jmp    8007d2 <read+0x8c>
	}
	if (!dev->dev_read)
  8007ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007b1:	8b 52 08             	mov    0x8(%edx),%edx
  8007b4:	85 d2                	test   %edx,%edx
  8007b6:	74 15                	je     8007cd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007c6:	89 04 24             	mov    %eax,(%esp)
  8007c9:	ff d2                	call   *%edx
  8007cb:	eb 05                	jmp    8007d2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8007cd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8007d2:	83 c4 24             	add    $0x24,%esp
  8007d5:	5b                   	pop    %ebx
  8007d6:	5d                   	pop    %ebp
  8007d7:	c3                   	ret    

008007d8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007d8:	55                   	push   %ebp
  8007d9:	89 e5                	mov    %esp,%ebp
  8007db:	57                   	push   %edi
  8007dc:	56                   	push   %esi
  8007dd:	53                   	push   %ebx
  8007de:	83 ec 1c             	sub    $0x1c,%esp
  8007e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007e4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007e7:	85 f6                	test   %esi,%esi
  8007e9:	74 33                	je     80081e <readn+0x46>
  8007eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f0:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007f5:	89 f2                	mov    %esi,%edx
  8007f7:	29 c2                	sub    %eax,%edx
  8007f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8007fd:	03 45 0c             	add    0xc(%ebp),%eax
  800800:	89 44 24 04          	mov    %eax,0x4(%esp)
  800804:	89 3c 24             	mov    %edi,(%esp)
  800807:	e8 3a ff ff ff       	call   800746 <read>
		if (m < 0)
  80080c:	85 c0                	test   %eax,%eax
  80080e:	78 1b                	js     80082b <readn+0x53>
			return m;
		if (m == 0)
  800810:	85 c0                	test   %eax,%eax
  800812:	74 11                	je     800825 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800814:	01 c3                	add    %eax,%ebx
  800816:	89 d8                	mov    %ebx,%eax
  800818:	39 f3                	cmp    %esi,%ebx
  80081a:	72 d9                	jb     8007f5 <readn+0x1d>
  80081c:	eb 0b                	jmp    800829 <readn+0x51>
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
  800823:	eb 06                	jmp    80082b <readn+0x53>
  800825:	89 d8                	mov    %ebx,%eax
  800827:	eb 02                	jmp    80082b <readn+0x53>
  800829:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80082b:	83 c4 1c             	add    $0x1c,%esp
  80082e:	5b                   	pop    %ebx
  80082f:	5e                   	pop    %esi
  800830:	5f                   	pop    %edi
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	83 ec 24             	sub    $0x24,%esp
  80083a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80083d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800840:	89 44 24 04          	mov    %eax,0x4(%esp)
  800844:	89 1c 24             	mov    %ebx,(%esp)
  800847:	e8 4f fc ff ff       	call   80049b <fd_lookup>
  80084c:	89 c2                	mov    %eax,%edx
  80084e:	85 d2                	test   %edx,%edx
  800850:	78 68                	js     8008ba <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800852:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800855:	89 44 24 04          	mov    %eax,0x4(%esp)
  800859:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80085c:	8b 00                	mov    (%eax),%eax
  80085e:	89 04 24             	mov    %eax,(%esp)
  800861:	e8 8b fc ff ff       	call   8004f1 <dev_lookup>
  800866:	85 c0                	test   %eax,%eax
  800868:	78 50                	js     8008ba <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80086a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800871:	75 23                	jne    800896 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800873:	a1 04 40 80 00       	mov    0x804004,%eax
  800878:	8b 40 48             	mov    0x48(%eax),%eax
  80087b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80087f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800883:	c7 04 24 55 21 80 00 	movl   $0x802155,(%esp)
  80088a:	e8 10 0a 00 00       	call   80129f <cprintf>
		return -E_INVAL;
  80088f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800894:	eb 24                	jmp    8008ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800896:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800899:	8b 52 0c             	mov    0xc(%edx),%edx
  80089c:	85 d2                	test   %edx,%edx
  80089e:	74 15                	je     8008b5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008a0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008ae:	89 04 24             	mov    %eax,(%esp)
  8008b1:	ff d2                	call   *%edx
  8008b3:	eb 05                	jmp    8008ba <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8008b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8008ba:	83 c4 24             	add    $0x24,%esp
  8008bd:	5b                   	pop    %ebx
  8008be:	5d                   	pop    %ebp
  8008bf:	c3                   	ret    

008008c0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8008c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d0:	89 04 24             	mov    %eax,(%esp)
  8008d3:	e8 c3 fb ff ff       	call   80049b <fd_lookup>
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	78 0e                	js     8008ea <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8008dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8008df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	53                   	push   %ebx
  8008f0:	83 ec 24             	sub    $0x24,%esp
  8008f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fd:	89 1c 24             	mov    %ebx,(%esp)
  800900:	e8 96 fb ff ff       	call   80049b <fd_lookup>
  800905:	89 c2                	mov    %eax,%edx
  800907:	85 d2                	test   %edx,%edx
  800909:	78 61                	js     80096c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80090b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	89 04 24             	mov    %eax,(%esp)
  80091a:	e8 d2 fb ff ff       	call   8004f1 <dev_lookup>
  80091f:	85 c0                	test   %eax,%eax
  800921:	78 49                	js     80096c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800926:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80092a:	75 23                	jne    80094f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80092c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800931:	8b 40 48             	mov    0x48(%eax),%eax
  800934:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093c:	c7 04 24 18 21 80 00 	movl   $0x802118,(%esp)
  800943:	e8 57 09 00 00       	call   80129f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800948:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094d:	eb 1d                	jmp    80096c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80094f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800952:	8b 52 18             	mov    0x18(%edx),%edx
  800955:	85 d2                	test   %edx,%edx
  800957:	74 0e                	je     800967 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800959:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80095c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800960:	89 04 24             	mov    %eax,(%esp)
  800963:	ff d2                	call   *%edx
  800965:	eb 05                	jmp    80096c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800967:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80096c:	83 c4 24             	add    $0x24,%esp
  80096f:	5b                   	pop    %ebx
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	83 ec 24             	sub    $0x24,%esp
  800979:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80097c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80097f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	89 04 24             	mov    %eax,(%esp)
  800989:	e8 0d fb ff ff       	call   80049b <fd_lookup>
  80098e:	89 c2                	mov    %eax,%edx
  800990:	85 d2                	test   %edx,%edx
  800992:	78 52                	js     8009e6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800994:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099e:	8b 00                	mov    (%eax),%eax
  8009a0:	89 04 24             	mov    %eax,(%esp)
  8009a3:	e8 49 fb ff ff       	call   8004f1 <dev_lookup>
  8009a8:	85 c0                	test   %eax,%eax
  8009aa:	78 3a                	js     8009e6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8009ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009af:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009b3:	74 2c                	je     8009e1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009b5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009b8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009bf:	00 00 00 
	stat->st_isdir = 0;
  8009c2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009c9:	00 00 00 
	stat->st_dev = dev;
  8009cc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009d9:	89 14 24             	mov    %edx,(%esp)
  8009dc:	ff 50 14             	call   *0x14(%eax)
  8009df:	eb 05                	jmp    8009e6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8009e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8009e6:	83 c4 24             	add    $0x24,%esp
  8009e9:	5b                   	pop    %ebx
  8009ea:	5d                   	pop    %ebp
  8009eb:	c3                   	ret    

008009ec <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009ec:	55                   	push   %ebp
  8009ed:	89 e5                	mov    %esp,%ebp
  8009ef:	56                   	push   %esi
  8009f0:	53                   	push   %ebx
  8009f1:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8009f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8009fb:	00 
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	89 04 24             	mov    %eax,(%esp)
  800a02:	e8 af 01 00 00       	call   800bb6 <open>
  800a07:	89 c3                	mov    %eax,%ebx
  800a09:	85 db                	test   %ebx,%ebx
  800a0b:	78 1b                	js     800a28 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a10:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a14:	89 1c 24             	mov    %ebx,(%esp)
  800a17:	e8 56 ff ff ff       	call   800972 <fstat>
  800a1c:	89 c6                	mov    %eax,%esi
	close(fd);
  800a1e:	89 1c 24             	mov    %ebx,(%esp)
  800a21:	e8 bd fb ff ff       	call   8005e3 <close>
	return r;
  800a26:	89 f0                	mov    %esi,%eax
}
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	5b                   	pop    %ebx
  800a2c:	5e                   	pop    %esi
  800a2d:	5d                   	pop    %ebp
  800a2e:	c3                   	ret    

00800a2f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	56                   	push   %esi
  800a33:	53                   	push   %ebx
  800a34:	83 ec 10             	sub    $0x10,%esp
  800a37:	89 c6                	mov    %eax,%esi
  800a39:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a3b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a42:	75 11                	jne    800a55 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a4b:	e8 5c 13 00 00       	call   801dac <ipc_find_env>
  800a50:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a55:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800a5c:	00 
  800a5d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800a64:	00 
  800a65:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a69:	a1 00 40 80 00       	mov    0x804000,%eax
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	e8 d0 12 00 00       	call   801d46 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800a7d:	00 
  800a7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a89:	e8 4e 12 00 00       	call   801cdc <ipc_recv>
}
  800a8e:	83 c4 10             	add    $0x10,%esp
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	53                   	push   %ebx
  800a99:	83 ec 14             	sub    $0x14,%esp
  800a9c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  800aa5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800aaa:	ba 00 00 00 00       	mov    $0x0,%edx
  800aaf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ab4:	e8 76 ff ff ff       	call   800a2f <fsipc>
  800ab9:	89 c2                	mov    %eax,%edx
  800abb:	85 d2                	test   %edx,%edx
  800abd:	78 2b                	js     800aea <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800abf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ac6:	00 
  800ac7:	89 1c 24             	mov    %ebx,(%esp)
  800aca:	e8 2c 0e 00 00       	call   8018fb <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800acf:	a1 80 50 80 00       	mov    0x805080,%eax
  800ad4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800ada:	a1 84 50 80 00       	mov    0x805084,%eax
  800adf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800ae5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aea:	83 c4 14             	add    $0x14,%esp
  800aed:	5b                   	pop    %ebx
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 40 0c             	mov    0xc(%eax),%eax
  800afc:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b01:	ba 00 00 00 00       	mov    $0x0,%edx
  800b06:	b8 06 00 00 00       	mov    $0x6,%eax
  800b0b:	e8 1f ff ff ff       	call   800a2f <fsipc>
}
  800b10:	c9                   	leave  
  800b11:	c3                   	ret    

00800b12 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	83 ec 10             	sub    $0x10,%esp
  800b1a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 40 0c             	mov    0xc(%eax),%eax
  800b23:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b28:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	b8 03 00 00 00       	mov    $0x3,%eax
  800b38:	e8 f2 fe ff ff       	call   800a2f <fsipc>
  800b3d:	89 c3                	mov    %eax,%ebx
  800b3f:	85 c0                	test   %eax,%eax
  800b41:	78 6a                	js     800bad <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b43:	39 c6                	cmp    %eax,%esi
  800b45:	73 24                	jae    800b6b <devfile_read+0x59>
  800b47:	c7 44 24 0c 72 21 80 	movl   $0x802172,0xc(%esp)
  800b4e:	00 
  800b4f:	c7 44 24 08 79 21 80 	movl   $0x802179,0x8(%esp)
  800b56:	00 
  800b57:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800b5e:	00 
  800b5f:	c7 04 24 8e 21 80 00 	movl   $0x80218e,(%esp)
  800b66:	e8 3b 06 00 00       	call   8011a6 <_panic>
	assert(r <= PGSIZE);
  800b6b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b70:	7e 24                	jle    800b96 <devfile_read+0x84>
  800b72:	c7 44 24 0c 99 21 80 	movl   $0x802199,0xc(%esp)
  800b79:	00 
  800b7a:	c7 44 24 08 79 21 80 	movl   $0x802179,0x8(%esp)
  800b81:	00 
  800b82:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800b89:	00 
  800b8a:	c7 04 24 8e 21 80 00 	movl   $0x80218e,(%esp)
  800b91:	e8 10 06 00 00       	call   8011a6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800b96:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b9a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ba1:	00 
  800ba2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba5:	89 04 24             	mov    %eax,(%esp)
  800ba8:	e8 49 0f 00 00       	call   801af6 <memmove>
	return r;
}
  800bad:	89 d8                	mov    %ebx,%eax
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	5b                   	pop    %ebx
  800bb3:	5e                   	pop    %esi
  800bb4:	5d                   	pop    %ebp
  800bb5:	c3                   	ret    

00800bb6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800bb6:	55                   	push   %ebp
  800bb7:	89 e5                	mov    %esp,%ebp
  800bb9:	53                   	push   %ebx
  800bba:	83 ec 24             	sub    $0x24,%esp
  800bbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800bc0:	89 1c 24             	mov    %ebx,(%esp)
  800bc3:	e8 d8 0c 00 00       	call   8018a0 <strlen>
  800bc8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bcd:	7f 60                	jg     800c2f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800bcf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bd2:	89 04 24             	mov    %eax,(%esp)
  800bd5:	e8 4d f8 ff ff       	call   800427 <fd_alloc>
  800bda:	89 c2                	mov    %eax,%edx
  800bdc:	85 d2                	test   %edx,%edx
  800bde:	78 54                	js     800c34 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800be0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800be4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800beb:	e8 0b 0d 00 00       	call   8018fb <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800c00:	e8 2a fe ff ff       	call   800a2f <fsipc>
  800c05:	89 c3                	mov    %eax,%ebx
  800c07:	85 c0                	test   %eax,%eax
  800c09:	79 17                	jns    800c22 <open+0x6c>
		fd_close(fd, 0);
  800c0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c12:	00 
  800c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c16:	89 04 24             	mov    %eax,(%esp)
  800c19:	e8 44 f9 ff ff       	call   800562 <fd_close>
		return r;
  800c1e:	89 d8                	mov    %ebx,%eax
  800c20:	eb 12                	jmp    800c34 <open+0x7e>
	}

	return fd2num(fd);
  800c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c25:	89 04 24             	mov    %eax,(%esp)
  800c28:	e8 d3 f7 ff ff       	call   800400 <fd2num>
  800c2d:	eb 05                	jmp    800c34 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c2f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  800c34:	83 c4 24             	add    $0x24,%esp
  800c37:	5b                   	pop    %ebx
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
  800c3a:	66 90                	xchg   %ax,%ax
  800c3c:	66 90                	xchg   %ax,%ax
  800c3e:	66 90                	xchg   %ax,%ax

00800c40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 10             	sub    $0x10,%esp
  800c48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	89 04 24             	mov    %eax,(%esp)
  800c51:	e8 ba f7 ff ff       	call   800410 <fd2data>
  800c56:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c58:	c7 44 24 04 a5 21 80 	movl   $0x8021a5,0x4(%esp)
  800c5f:	00 
  800c60:	89 1c 24             	mov    %ebx,(%esp)
  800c63:	e8 93 0c 00 00       	call   8018fb <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c68:	8b 46 04             	mov    0x4(%esi),%eax
  800c6b:	2b 06                	sub    (%esi),%eax
  800c6d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c73:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c7a:	00 00 00 
	stat->st_dev = &devpipe;
  800c7d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c84:	30 80 00 
	return 0;
}
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	83 c4 10             	add    $0x10,%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5d                   	pop    %ebp
  800c92:	c3                   	ret    

00800c93 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c93:	55                   	push   %ebp
  800c94:	89 e5                	mov    %esp,%ebp
  800c96:	53                   	push   %ebx
  800c97:	83 ec 14             	sub    $0x14,%esp
  800c9a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c9d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ca1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ca8:	e8 92 f5 ff ff       	call   80023f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800cad:	89 1c 24             	mov    %ebx,(%esp)
  800cb0:	e8 5b f7 ff ff       	call   800410 <fd2data>
  800cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cb9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cc0:	e8 7a f5 ff ff       	call   80023f <sys_page_unmap>
}
  800cc5:	83 c4 14             	add    $0x14,%esp
  800cc8:	5b                   	pop    %ebx
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 2c             	sub    $0x2c,%esp
  800cd4:	89 c6                	mov    %eax,%esi
  800cd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800cd9:	a1 04 40 80 00       	mov    0x804004,%eax
  800cde:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800ce1:	89 34 24             	mov    %esi,(%esp)
  800ce4:	e8 0b 11 00 00       	call   801df4 <pageref>
  800ce9:	89 c7                	mov    %eax,%edi
  800ceb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800cee:	89 04 24             	mov    %eax,(%esp)
  800cf1:	e8 fe 10 00 00       	call   801df4 <pageref>
  800cf6:	39 c7                	cmp    %eax,%edi
  800cf8:	0f 94 c2             	sete   %dl
  800cfb:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800cfe:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d04:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d07:	39 fb                	cmp    %edi,%ebx
  800d09:	74 21                	je     800d2c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d0b:	84 d2                	test   %dl,%dl
  800d0d:	74 ca                	je     800cd9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d0f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d16:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d1e:	c7 04 24 ac 21 80 00 	movl   $0x8021ac,(%esp)
  800d25:	e8 75 05 00 00       	call   80129f <cprintf>
  800d2a:	eb ad                	jmp    800cd9 <_pipeisclosed+0xe>
	}
}
  800d2c:	83 c4 2c             	add    $0x2c,%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 1c             	sub    $0x1c,%esp
  800d3d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d40:	89 34 24             	mov    %esi,(%esp)
  800d43:	e8 c8 f6 ff ff       	call   800410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d48:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4c:	74 61                	je     800daf <devpipe_write+0x7b>
  800d4e:	89 c3                	mov    %eax,%ebx
  800d50:	bf 00 00 00 00       	mov    $0x0,%edi
  800d55:	eb 4a                	jmp    800da1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800d57:	89 da                	mov    %ebx,%edx
  800d59:	89 f0                	mov    %esi,%eax
  800d5b:	e8 6b ff ff ff       	call   800ccb <_pipeisclosed>
  800d60:	85 c0                	test   %eax,%eax
  800d62:	75 54                	jne    800db8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800d64:	e8 10 f4 ff ff       	call   800179 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d69:	8b 43 04             	mov    0x4(%ebx),%eax
  800d6c:	8b 0b                	mov    (%ebx),%ecx
  800d6e:	8d 51 20             	lea    0x20(%ecx),%edx
  800d71:	39 d0                	cmp    %edx,%eax
  800d73:	73 e2                	jae    800d57 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d78:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d7c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d7f:	99                   	cltd   
  800d80:	c1 ea 1b             	shr    $0x1b,%edx
  800d83:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800d86:	83 e1 1f             	and    $0x1f,%ecx
  800d89:	29 d1                	sub    %edx,%ecx
  800d8b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800d8f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800d93:	83 c0 01             	add    $0x1,%eax
  800d96:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d99:	83 c7 01             	add    $0x1,%edi
  800d9c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d9f:	74 13                	je     800db4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800da1:	8b 43 04             	mov    0x4(%ebx),%eax
  800da4:	8b 0b                	mov    (%ebx),%ecx
  800da6:	8d 51 20             	lea    0x20(%ecx),%edx
  800da9:	39 d0                	cmp    %edx,%eax
  800dab:	73 aa                	jae    800d57 <devpipe_write+0x23>
  800dad:	eb c6                	jmp    800d75 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800daf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800db4:	89 f8                	mov    %edi,%eax
  800db6:	eb 05                	jmp    800dbd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800db8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800dbd:	83 c4 1c             	add    $0x1c,%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5e                   	pop    %esi
  800dc2:	5f                   	pop    %edi
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	57                   	push   %edi
  800dc9:	56                   	push   %esi
  800dca:	53                   	push   %ebx
  800dcb:	83 ec 1c             	sub    $0x1c,%esp
  800dce:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800dd1:	89 3c 24             	mov    %edi,(%esp)
  800dd4:	e8 37 f6 ff ff       	call   800410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ddd:	74 54                	je     800e33 <devpipe_read+0x6e>
  800ddf:	89 c3                	mov    %eax,%ebx
  800de1:	be 00 00 00 00       	mov    $0x0,%esi
  800de6:	eb 3e                	jmp    800e26 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800de8:	89 f0                	mov    %esi,%eax
  800dea:	eb 55                	jmp    800e41 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800dec:	89 da                	mov    %ebx,%edx
  800dee:	89 f8                	mov    %edi,%eax
  800df0:	e8 d6 fe ff ff       	call   800ccb <_pipeisclosed>
  800df5:	85 c0                	test   %eax,%eax
  800df7:	75 43                	jne    800e3c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800df9:	e8 7b f3 ff ff       	call   800179 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800dfe:	8b 03                	mov    (%ebx),%eax
  800e00:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e03:	74 e7                	je     800dec <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e05:	99                   	cltd   
  800e06:	c1 ea 1b             	shr    $0x1b,%edx
  800e09:	01 d0                	add    %edx,%eax
  800e0b:	83 e0 1f             	and    $0x1f,%eax
  800e0e:	29 d0                	sub    %edx,%eax
  800e10:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e1b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e1e:	83 c6 01             	add    $0x1,%esi
  800e21:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e24:	74 12                	je     800e38 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e26:	8b 03                	mov    (%ebx),%eax
  800e28:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e2b:	75 d8                	jne    800e05 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e2d:	85 f6                	test   %esi,%esi
  800e2f:	75 b7                	jne    800de8 <devpipe_read+0x23>
  800e31:	eb b9                	jmp    800dec <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e33:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	eb 05                	jmp    800e41 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e3c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e41:	83 c4 1c             	add    $0x1c,%esp
  800e44:	5b                   	pop    %ebx
  800e45:	5e                   	pop    %esi
  800e46:	5f                   	pop    %edi
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	56                   	push   %esi
  800e4d:	53                   	push   %ebx
  800e4e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800e51:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e54:	89 04 24             	mov    %eax,(%esp)
  800e57:	e8 cb f5 ff ff       	call   800427 <fd_alloc>
  800e5c:	89 c2                	mov    %eax,%edx
  800e5e:	85 d2                	test   %edx,%edx
  800e60:	0f 88 4d 01 00 00    	js     800fb3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e66:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e6d:	00 
  800e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e7c:	e8 17 f3 ff ff       	call   800198 <sys_page_alloc>
  800e81:	89 c2                	mov    %eax,%edx
  800e83:	85 d2                	test   %edx,%edx
  800e85:	0f 88 28 01 00 00    	js     800fb3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800e8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e8e:	89 04 24             	mov    %eax,(%esp)
  800e91:	e8 91 f5 ff ff       	call   800427 <fd_alloc>
  800e96:	89 c3                	mov    %eax,%ebx
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	0f 88 fe 00 00 00    	js     800f9e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ea0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ea7:	00 
  800ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eab:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eaf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800eb6:	e8 dd f2 ff ff       	call   800198 <sys_page_alloc>
  800ebb:	89 c3                	mov    %eax,%ebx
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	0f 88 d9 00 00 00    	js     800f9e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec8:	89 04 24             	mov    %eax,(%esp)
  800ecb:	e8 40 f5 ff ff       	call   800410 <fd2data>
  800ed0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ed2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ed9:	00 
  800eda:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ede:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ee5:	e8 ae f2 ff ff       	call   800198 <sys_page_alloc>
  800eea:	89 c3                	mov    %eax,%ebx
  800eec:	85 c0                	test   %eax,%eax
  800eee:	0f 88 97 00 00 00    	js     800f8b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef7:	89 04 24             	mov    %eax,(%esp)
  800efa:	e8 11 f5 ff ff       	call   800410 <fd2data>
  800eff:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f06:	00 
  800f07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f12:	00 
  800f13:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f1e:	e8 c9 f2 ff ff       	call   8001ec <sys_page_map>
  800f23:	89 c3                	mov    %eax,%ebx
  800f25:	85 c0                	test   %eax,%eax
  800f27:	78 52                	js     800f7b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f29:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f32:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f3e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f47:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f56:	89 04 24             	mov    %eax,(%esp)
  800f59:	e8 a2 f4 ff ff       	call   800400 <fd2num>
  800f5e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f61:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f66:	89 04 24             	mov    %eax,(%esp)
  800f69:	e8 92 f4 ff ff       	call   800400 <fd2num>
  800f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f71:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
  800f79:	eb 38                	jmp    800fb3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800f7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f86:	e8 b4 f2 ff ff       	call   80023f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f99:	e8 a1 f2 ff ff       	call   80023f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fac:	e8 8e f2 ff ff       	call   80023f <sys_page_unmap>
  800fb1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  800fb3:	83 c4 30             	add    $0x30,%esp
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	89 04 24             	mov    %eax,(%esp)
  800fcd:	e8 c9 f4 ff ff       	call   80049b <fd_lookup>
  800fd2:	89 c2                	mov    %eax,%edx
  800fd4:	85 d2                	test   %edx,%edx
  800fd6:	78 15                	js     800fed <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fdb:	89 04 24             	mov    %eax,(%esp)
  800fde:	e8 2d f4 ff ff       	call   800410 <fd2data>
	return _pipeisclosed(fd, p);
  800fe3:	89 c2                	mov    %eax,%edx
  800fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fe8:	e8 de fc ff ff       	call   800ccb <_pipeisclosed>
}
  800fed:	c9                   	leave  
  800fee:	c3                   	ret    
  800fef:	90                   	nop

00800ff0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801000:	c7 44 24 04 c4 21 80 	movl   $0x8021c4,0x4(%esp)
  801007:	00 
  801008:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100b:	89 04 24             	mov    %eax,(%esp)
  80100e:	e8 e8 08 00 00       	call   8018fb <strcpy>
	return 0;
}
  801013:	b8 00 00 00 00       	mov    $0x0,%eax
  801018:	c9                   	leave  
  801019:	c3                   	ret    

0080101a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801026:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80102a:	74 4a                	je     801076 <devcons_write+0x5c>
  80102c:	b8 00 00 00 00       	mov    $0x0,%eax
  801031:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801036:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80103c:	8b 75 10             	mov    0x10(%ebp),%esi
  80103f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801041:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801044:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801049:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80104c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801050:	03 45 0c             	add    0xc(%ebp),%eax
  801053:	89 44 24 04          	mov    %eax,0x4(%esp)
  801057:	89 3c 24             	mov    %edi,(%esp)
  80105a:	e8 97 0a 00 00       	call   801af6 <memmove>
		sys_cputs(buf, m);
  80105f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801063:	89 3c 24             	mov    %edi,(%esp)
  801066:	e8 60 f0 ff ff       	call   8000cb <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80106b:	01 f3                	add    %esi,%ebx
  80106d:	89 d8                	mov    %ebx,%eax
  80106f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801072:	72 c8                	jb     80103c <devcons_write+0x22>
  801074:	eb 05                	jmp    80107b <devcons_write+0x61>
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80107b:	89 d8                	mov    %ebx,%eax
  80107d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801083:	5b                   	pop    %ebx
  801084:	5e                   	pop    %esi
  801085:	5f                   	pop    %edi
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80108e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <devcons_read+0x18>
  801099:	eb 28                	jmp    8010c3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80109b:	e8 d9 f0 ff ff       	call   800179 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010a0:	e8 44 f0 ff ff       	call   8000e9 <sys_cgetc>
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	74 f2                	je     80109b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 16                	js     8010c3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010ad:	83 f8 04             	cmp    $0x4,%eax
  8010b0:	74 0c                	je     8010be <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	88 02                	mov    %al,(%edx)
	return 1;
  8010b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010bc:	eb 05                	jmp    8010c3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8010d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010d8:	00 
  8010d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8010dc:	89 04 24             	mov    %eax,(%esp)
  8010df:	e8 e7 ef ff ff       	call   8000cb <sys_cputs>
}
  8010e4:	c9                   	leave  
  8010e5:	c3                   	ret    

008010e6 <getchar>:

int
getchar(void)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8010ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8010f3:	00 
  8010f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8010f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801102:	e8 3f f6 ff ff       	call   800746 <read>
	if (r < 0)
  801107:	85 c0                	test   %eax,%eax
  801109:	78 0f                	js     80111a <getchar+0x34>
		return r;
	if (r < 1)
  80110b:	85 c0                	test   %eax,%eax
  80110d:	7e 06                	jle    801115 <getchar+0x2f>
		return -E_EOF;
	return c;
  80110f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801113:	eb 05                	jmp    80111a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801115:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80111a:	c9                   	leave  
  80111b:	c3                   	ret    

0080111c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801122:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801125:	89 44 24 04          	mov    %eax,0x4(%esp)
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	89 04 24             	mov    %eax,(%esp)
  80112f:	e8 67 f3 ff ff       	call   80049b <fd_lookup>
  801134:	85 c0                	test   %eax,%eax
  801136:	78 11                	js     801149 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801141:	39 10                	cmp    %edx,(%eax)
  801143:	0f 94 c0             	sete   %al
  801146:	0f b6 c0             	movzbl %al,%eax
}
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <opencons>:

int
opencons(void)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801151:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801154:	89 04 24             	mov    %eax,(%esp)
  801157:	e8 cb f2 ff ff       	call   800427 <fd_alloc>
		return r;
  80115c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80115e:	85 c0                	test   %eax,%eax
  801160:	78 40                	js     8011a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801162:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801169:	00 
  80116a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801171:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801178:	e8 1b f0 ff ff       	call   800198 <sys_page_alloc>
		return r;
  80117d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 1f                	js     8011a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801183:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801189:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801198:	89 04 24             	mov    %eax,(%esp)
  80119b:	e8 60 f2 ff ff       	call   800400 <fd2num>
  8011a0:	89 c2                	mov    %eax,%edx
}
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c9                   	leave  
  8011a5:	c3                   	ret    

008011a6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011a6:	55                   	push   %ebp
  8011a7:	89 e5                	mov    %esp,%ebp
  8011a9:	56                   	push   %esi
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ae:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011b1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8011b7:	e8 9e ef ff ff       	call   80015a <sys_getenvid>
  8011bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011bf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011ca:	89 74 24 08          	mov    %esi,0x8(%esp)
  8011ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011d2:	c7 04 24 d0 21 80 00 	movl   $0x8021d0,(%esp)
  8011d9:	e8 c1 00 00 00       	call   80129f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e5:	89 04 24             	mov    %eax,(%esp)
  8011e8:	e8 51 00 00 00       	call   80123e <vcprintf>
	cprintf("\n");
  8011ed:	c7 04 24 bd 21 80 00 	movl   $0x8021bd,(%esp)
  8011f4:	e8 a6 00 00 00       	call   80129f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011f9:	cc                   	int3   
  8011fa:	eb fd                	jmp    8011f9 <_panic+0x53>

008011fc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	53                   	push   %ebx
  801200:	83 ec 14             	sub    $0x14,%esp
  801203:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801206:	8b 13                	mov    (%ebx),%edx
  801208:	8d 42 01             	lea    0x1(%edx),%eax
  80120b:	89 03                	mov    %eax,(%ebx)
  80120d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801210:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801214:	3d ff 00 00 00       	cmp    $0xff,%eax
  801219:	75 19                	jne    801234 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80121b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801222:	00 
  801223:	8d 43 08             	lea    0x8(%ebx),%eax
  801226:	89 04 24             	mov    %eax,(%esp)
  801229:	e8 9d ee ff ff       	call   8000cb <sys_cputs>
		b->idx = 0;
  80122e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801234:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801238:	83 c4 14             	add    $0x14,%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5d                   	pop    %ebp
  80123d:	c3                   	ret    

0080123e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801247:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80124e:	00 00 00 
	b.cnt = 0;
  801251:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801258:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	89 44 24 08          	mov    %eax,0x8(%esp)
  801269:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80126f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801273:	c7 04 24 fc 11 80 00 	movl   $0x8011fc,(%esp)
  80127a:	e8 b5 01 00 00       	call   801434 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80127f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801285:	89 44 24 04          	mov    %eax,0x4(%esp)
  801289:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80128f:	89 04 24             	mov    %eax,(%esp)
  801292:	e8 34 ee ff ff       	call   8000cb <sys_cputs>

	return b.cnt;
}
  801297:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
  8012a2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012a5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 87 ff ff ff       	call   80123e <vcprintf>
	va_end(ap);

	return cnt;
}
  8012b7:	c9                   	leave  
  8012b8:	c3                   	ret    
  8012b9:	66 90                	xchg   %ax,%ax
  8012bb:	66 90                	xchg   %ax,%ax
  8012bd:	66 90                	xchg   %ax,%ax
  8012bf:	90                   	nop

008012c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	57                   	push   %edi
  8012c4:	56                   	push   %esi
  8012c5:	53                   	push   %ebx
  8012c6:	83 ec 3c             	sub    $0x3c,%esp
  8012c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012cc:	89 d7                	mov    %edx,%edi
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012d4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8012da:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012dd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8012e5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8012e8:	39 f1                	cmp    %esi,%ecx
  8012ea:	72 14                	jb     801300 <printnum+0x40>
  8012ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8012ef:	76 0f                	jbe    801300 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8d 70 ff             	lea    -0x1(%eax),%esi
  8012f7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8012fa:	85 f6                	test   %esi,%esi
  8012fc:	7f 60                	jg     80135e <printnum+0x9e>
  8012fe:	eb 72                	jmp    801372 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801300:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801303:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801307:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80130a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80130d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801311:	89 44 24 08          	mov    %eax,0x8(%esp)
  801315:	8b 44 24 08          	mov    0x8(%esp),%eax
  801319:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80131d:	89 c3                	mov    %eax,%ebx
  80131f:	89 d6                	mov    %edx,%esi
  801321:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801324:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801327:	89 54 24 08          	mov    %edx,0x8(%esp)
  80132b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80132f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801338:	89 44 24 04          	mov    %eax,0x4(%esp)
  80133c:	e8 ef 0a 00 00       	call   801e30 <__udivdi3>
  801341:	89 d9                	mov    %ebx,%ecx
  801343:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801347:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80134b:	89 04 24             	mov    %eax,(%esp)
  80134e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801352:	89 fa                	mov    %edi,%edx
  801354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801357:	e8 64 ff ff ff       	call   8012c0 <printnum>
  80135c:	eb 14                	jmp    801372 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80135e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801362:	8b 45 18             	mov    0x18(%ebp),%eax
  801365:	89 04 24             	mov    %eax,(%esp)
  801368:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80136a:	83 ee 01             	sub    $0x1,%esi
  80136d:	75 ef                	jne    80135e <printnum+0x9e>
  80136f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801372:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801376:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80137a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80137d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801380:	89 44 24 08          	mov    %eax,0x8(%esp)
  801384:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801388:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80138b:	89 04 24             	mov    %eax,(%esp)
  80138e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801391:	89 44 24 04          	mov    %eax,0x4(%esp)
  801395:	e8 c6 0b 00 00       	call   801f60 <__umoddi3>
  80139a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80139e:	0f be 80 f3 21 80 00 	movsbl 0x8021f3(%eax),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ab:	ff d0                	call   *%eax
}
  8013ad:	83 c4 3c             	add    $0x3c,%esp
  8013b0:	5b                   	pop    %ebx
  8013b1:	5e                   	pop    %esi
  8013b2:	5f                   	pop    %edi
  8013b3:	5d                   	pop    %ebp
  8013b4:	c3                   	ret    

008013b5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013b8:	83 fa 01             	cmp    $0x1,%edx
  8013bb:	7e 0e                	jle    8013cb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8013bd:	8b 10                	mov    (%eax),%edx
  8013bf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8013c2:	89 08                	mov    %ecx,(%eax)
  8013c4:	8b 02                	mov    (%edx),%eax
  8013c6:	8b 52 04             	mov    0x4(%edx),%edx
  8013c9:	eb 22                	jmp    8013ed <getuint+0x38>
	else if (lflag)
  8013cb:	85 d2                	test   %edx,%edx
  8013cd:	74 10                	je     8013df <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8013cf:	8b 10                	mov    (%eax),%edx
  8013d1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013d4:	89 08                	mov    %ecx,(%eax)
  8013d6:	8b 02                	mov    (%edx),%eax
  8013d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013dd:	eb 0e                	jmp    8013ed <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8013df:	8b 10                	mov    (%eax),%edx
  8013e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013e4:	89 08                	mov    %ecx,(%eax)
  8013e6:	8b 02                	mov    (%edx),%eax
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013ed:	5d                   	pop    %ebp
  8013ee:	c3                   	ret    

008013ef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8013f5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8013f9:	8b 10                	mov    (%eax),%edx
  8013fb:	3b 50 04             	cmp    0x4(%eax),%edx
  8013fe:	73 0a                	jae    80140a <sprintputch+0x1b>
		*b->buf++ = ch;
  801400:	8d 4a 01             	lea    0x1(%edx),%ecx
  801403:	89 08                	mov    %ecx,(%eax)
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	88 02                	mov    %al,(%edx)
}
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801412:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801415:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801419:	8b 45 10             	mov    0x10(%ebp),%eax
  80141c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801420:	8b 45 0c             	mov    0xc(%ebp),%eax
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	89 04 24             	mov    %eax,(%esp)
  80142d:	e8 02 00 00 00       	call   801434 <vprintfmt>
	va_end(ap);
}
  801432:	c9                   	leave  
  801433:	c3                   	ret    

00801434 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801434:	55                   	push   %ebp
  801435:	89 e5                	mov    %esp,%ebp
  801437:	57                   	push   %edi
  801438:	56                   	push   %esi
  801439:	53                   	push   %ebx
  80143a:	83 ec 3c             	sub    $0x3c,%esp
  80143d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801440:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801443:	eb 18                	jmp    80145d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801445:	85 c0                	test   %eax,%eax
  801447:	0f 84 c3 03 00 00    	je     801810 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80144d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801451:	89 04 24             	mov    %eax,(%esp)
  801454:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801457:	89 f3                	mov    %esi,%ebx
  801459:	eb 02                	jmp    80145d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80145b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80145d:	8d 73 01             	lea    0x1(%ebx),%esi
  801460:	0f b6 03             	movzbl (%ebx),%eax
  801463:	83 f8 25             	cmp    $0x25,%eax
  801466:	75 dd                	jne    801445 <vprintfmt+0x11>
  801468:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80146c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801473:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80147a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801481:	ba 00 00 00 00       	mov    $0x0,%edx
  801486:	eb 1d                	jmp    8014a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801488:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80148a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80148e:	eb 15                	jmp    8014a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801490:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801492:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  801496:	eb 0d                	jmp    8014a5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801498:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80149b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80149e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014a5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014a8:	0f b6 06             	movzbl (%esi),%eax
  8014ab:	0f b6 c8             	movzbl %al,%ecx
  8014ae:	83 e8 23             	sub    $0x23,%eax
  8014b1:	3c 55                	cmp    $0x55,%al
  8014b3:	0f 87 2f 03 00 00    	ja     8017e8 <vprintfmt+0x3b4>
  8014b9:	0f b6 c0             	movzbl %al,%eax
  8014bc:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8014c3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8014c6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8014c9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8014cd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8014d0:	83 f9 09             	cmp    $0x9,%ecx
  8014d3:	77 50                	ja     801525 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014d5:	89 de                	mov    %ebx,%esi
  8014d7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014da:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8014dd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8014e0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8014e4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8014e7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8014ea:	83 fb 09             	cmp    $0x9,%ebx
  8014ed:	76 eb                	jbe    8014da <vprintfmt+0xa6>
  8014ef:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8014f2:	eb 33                	jmp    801527 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	8d 48 04             	lea    0x4(%eax),%ecx
  8014fa:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8014fd:	8b 00                	mov    (%eax),%eax
  8014ff:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801502:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801504:	eb 21                	jmp    801527 <vprintfmt+0xf3>
  801506:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801509:	85 c9                	test   %ecx,%ecx
  80150b:	b8 00 00 00 00       	mov    $0x0,%eax
  801510:	0f 49 c1             	cmovns %ecx,%eax
  801513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801516:	89 de                	mov    %ebx,%esi
  801518:	eb 8b                	jmp    8014a5 <vprintfmt+0x71>
  80151a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80151c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801523:	eb 80                	jmp    8014a5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801525:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801527:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80152b:	0f 89 74 ff ff ff    	jns    8014a5 <vprintfmt+0x71>
  801531:	e9 62 ff ff ff       	jmp    801498 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801536:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801539:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80153b:	e9 65 ff ff ff       	jmp    8014a5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801540:	8b 45 14             	mov    0x14(%ebp),%eax
  801543:	8d 50 04             	lea    0x4(%eax),%edx
  801546:	89 55 14             	mov    %edx,0x14(%ebp)
  801549:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	89 04 24             	mov    %eax,(%esp)
  801552:	ff 55 08             	call   *0x8(%ebp)
			break;
  801555:	e9 03 ff ff ff       	jmp    80145d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80155a:	8b 45 14             	mov    0x14(%ebp),%eax
  80155d:	8d 50 04             	lea    0x4(%eax),%edx
  801560:	89 55 14             	mov    %edx,0x14(%ebp)
  801563:	8b 00                	mov    (%eax),%eax
  801565:	99                   	cltd   
  801566:	31 d0                	xor    %edx,%eax
  801568:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80156a:	83 f8 0f             	cmp    $0xf,%eax
  80156d:	7f 0b                	jg     80157a <vprintfmt+0x146>
  80156f:	8b 14 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%edx
  801576:	85 d2                	test   %edx,%edx
  801578:	75 20                	jne    80159a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80157a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80157e:	c7 44 24 08 0b 22 80 	movl   $0x80220b,0x8(%esp)
  801585:	00 
  801586:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80158a:	8b 45 08             	mov    0x8(%ebp),%eax
  80158d:	89 04 24             	mov    %eax,(%esp)
  801590:	e8 77 fe ff ff       	call   80140c <printfmt>
  801595:	e9 c3 fe ff ff       	jmp    80145d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80159a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80159e:	c7 44 24 08 8b 21 80 	movl   $0x80218b,0x8(%esp)
  8015a5:	00 
  8015a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	89 04 24             	mov    %eax,(%esp)
  8015b0:	e8 57 fe ff ff       	call   80140c <printfmt>
  8015b5:	e9 a3 fe ff ff       	jmp    80145d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ba:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8015bd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c3:	8d 50 04             	lea    0x4(%eax),%edx
  8015c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015c9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	ba 04 22 80 00       	mov    $0x802204,%edx
  8015d2:	0f 45 d0             	cmovne %eax,%edx
  8015d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8015d8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8015dc:	74 04                	je     8015e2 <vprintfmt+0x1ae>
  8015de:	85 f6                	test   %esi,%esi
  8015e0:	7f 19                	jg     8015fb <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015e5:	8d 70 01             	lea    0x1(%eax),%esi
  8015e8:	0f b6 10             	movzbl (%eax),%edx
  8015eb:	0f be c2             	movsbl %dl,%eax
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	0f 85 95 00 00 00    	jne    80168b <vprintfmt+0x257>
  8015f6:	e9 85 00 00 00       	jmp    801680 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8015fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8015ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801602:	89 04 24             	mov    %eax,(%esp)
  801605:	e8 b8 02 00 00       	call   8018c2 <strnlen>
  80160a:	29 c6                	sub    %eax,%esi
  80160c:	89 f0                	mov    %esi,%eax
  80160e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801611:	85 f6                	test   %esi,%esi
  801613:	7e cd                	jle    8015e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801615:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801619:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80161c:	89 c3                	mov    %eax,%ebx
  80161e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801622:	89 34 24             	mov    %esi,(%esp)
  801625:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801628:	83 eb 01             	sub    $0x1,%ebx
  80162b:	75 f1                	jne    80161e <vprintfmt+0x1ea>
  80162d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801630:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801633:	eb ad                	jmp    8015e2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801635:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801639:	74 1e                	je     801659 <vprintfmt+0x225>
  80163b:	0f be d2             	movsbl %dl,%edx
  80163e:	83 ea 20             	sub    $0x20,%edx
  801641:	83 fa 5e             	cmp    $0x5e,%edx
  801644:	76 13                	jbe    801659 <vprintfmt+0x225>
					putch('?', putdat);
  801646:	8b 45 0c             	mov    0xc(%ebp),%eax
  801649:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801654:	ff 55 08             	call   *0x8(%ebp)
  801657:	eb 0d                	jmp    801666 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801659:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80165c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801660:	89 04 24             	mov    %eax,(%esp)
  801663:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801666:	83 ef 01             	sub    $0x1,%edi
  801669:	83 c6 01             	add    $0x1,%esi
  80166c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801670:	0f be c2             	movsbl %dl,%eax
  801673:	85 c0                	test   %eax,%eax
  801675:	75 20                	jne    801697 <vprintfmt+0x263>
  801677:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80167a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80167d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801680:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801684:	7f 25                	jg     8016ab <vprintfmt+0x277>
  801686:	e9 d2 fd ff ff       	jmp    80145d <vprintfmt+0x29>
  80168b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80168e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801691:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801694:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801697:	85 db                	test   %ebx,%ebx
  801699:	78 9a                	js     801635 <vprintfmt+0x201>
  80169b:	83 eb 01             	sub    $0x1,%ebx
  80169e:	79 95                	jns    801635 <vprintfmt+0x201>
  8016a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016a3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016a9:	eb d5                	jmp    801680 <vprintfmt+0x24c>
  8016ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ae:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016b1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8016b4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8016bf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016c1:	83 eb 01             	sub    $0x1,%ebx
  8016c4:	75 ee                	jne    8016b4 <vprintfmt+0x280>
  8016c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016c9:	e9 8f fd ff ff       	jmp    80145d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8016ce:	83 fa 01             	cmp    $0x1,%edx
  8016d1:	7e 16                	jle    8016e9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8d 50 08             	lea    0x8(%eax),%edx
  8016d9:	89 55 14             	mov    %edx,0x14(%ebp)
  8016dc:	8b 50 04             	mov    0x4(%eax),%edx
  8016df:	8b 00                	mov    (%eax),%eax
  8016e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8016e7:	eb 32                	jmp    80171b <vprintfmt+0x2e7>
	else if (lflag)
  8016e9:	85 d2                	test   %edx,%edx
  8016eb:	74 18                	je     801705 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8016ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f0:	8d 50 04             	lea    0x4(%eax),%edx
  8016f3:	89 55 14             	mov    %edx,0x14(%ebp)
  8016f6:	8b 30                	mov    (%eax),%esi
  8016f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8016fb:	89 f0                	mov    %esi,%eax
  8016fd:	c1 f8 1f             	sar    $0x1f,%eax
  801700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801703:	eb 16                	jmp    80171b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801705:	8b 45 14             	mov    0x14(%ebp),%eax
  801708:	8d 50 04             	lea    0x4(%eax),%edx
  80170b:	89 55 14             	mov    %edx,0x14(%ebp)
  80170e:	8b 30                	mov    (%eax),%esi
  801710:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801713:	89 f0                	mov    %esi,%eax
  801715:	c1 f8 1f             	sar    $0x1f,%eax
  801718:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80171b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80171e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801721:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801726:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80172a:	0f 89 80 00 00 00    	jns    8017b0 <vprintfmt+0x37c>
				putch('-', putdat);
  801730:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801734:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80173b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80173e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801741:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801744:	f7 d8                	neg    %eax
  801746:	83 d2 00             	adc    $0x0,%edx
  801749:	f7 da                	neg    %edx
			}
			base = 10;
  80174b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801750:	eb 5e                	jmp    8017b0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801752:	8d 45 14             	lea    0x14(%ebp),%eax
  801755:	e8 5b fc ff ff       	call   8013b5 <getuint>
			base = 10;
  80175a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80175f:	eb 4f                	jmp    8017b0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801761:	8d 45 14             	lea    0x14(%ebp),%eax
  801764:	e8 4c fc ff ff       	call   8013b5 <getuint>
			base = 8;
  801769:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80176e:	eb 40                	jmp    8017b0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801774:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80177b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80177e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801782:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801789:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80178c:	8b 45 14             	mov    0x14(%ebp),%eax
  80178f:	8d 50 04             	lea    0x4(%eax),%edx
  801792:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801795:	8b 00                	mov    (%eax),%eax
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80179c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017a1:	eb 0d                	jmp    8017b0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017a3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017a6:	e8 0a fc ff ff       	call   8013b5 <getuint>
			base = 16;
  8017ab:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017b0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8017b4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8017b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017bb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017c3:	89 04 24             	mov    %eax,(%esp)
  8017c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017ca:	89 fa                	mov    %edi,%edx
  8017cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cf:	e8 ec fa ff ff       	call   8012c0 <printnum>
			break;
  8017d4:	e9 84 fc ff ff       	jmp    80145d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017d9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017dd:	89 0c 24             	mov    %ecx,(%esp)
  8017e0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8017e3:	e9 75 fc ff ff       	jmp    80145d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017ec:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8017f3:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8017f6:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  8017fa:	0f 84 5b fc ff ff    	je     80145b <vprintfmt+0x27>
  801800:	89 f3                	mov    %esi,%ebx
  801802:	83 eb 01             	sub    $0x1,%ebx
  801805:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801809:	75 f7                	jne    801802 <vprintfmt+0x3ce>
  80180b:	e9 4d fc ff ff       	jmp    80145d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801810:	83 c4 3c             	add    $0x3c,%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    

00801818 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 28             	sub    $0x28,%esp
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801824:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801827:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80182b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80182e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801835:	85 c0                	test   %eax,%eax
  801837:	74 30                	je     801869 <vsnprintf+0x51>
  801839:	85 d2                	test   %edx,%edx
  80183b:	7e 2c                	jle    801869 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80183d:	8b 45 14             	mov    0x14(%ebp),%eax
  801840:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	89 44 24 08          	mov    %eax,0x8(%esp)
  80184b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80184e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801852:	c7 04 24 ef 13 80 00 	movl   $0x8013ef,(%esp)
  801859:	e8 d6 fb ff ff       	call   801434 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80185e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801861:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	eb 05                	jmp    80186e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801869:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801876:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801879:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80187d:	8b 45 10             	mov    0x10(%ebp),%eax
  801880:	89 44 24 08          	mov    %eax,0x8(%esp)
  801884:	8b 45 0c             	mov    0xc(%ebp),%eax
  801887:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 04 24             	mov    %eax,(%esp)
  801891:	e8 82 ff ff ff       	call   801818 <vsnprintf>
	va_end(ap);

	return rc;
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    
  801898:	66 90                	xchg   %ax,%ax
  80189a:	66 90                	xchg   %ax,%ax
  80189c:	66 90                	xchg   %ax,%ax
  80189e:	66 90                	xchg   %ax,%ax

008018a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018a6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018a9:	74 10                	je     8018bb <strlen+0x1b>
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8018b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8018b7:	75 f7                	jne    8018b0 <strlen+0x10>
  8018b9:	eb 05                	jmp    8018c0 <strlen+0x20>
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8018c0:	5d                   	pop    %ebp
  8018c1:	c3                   	ret    

008018c2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	53                   	push   %ebx
  8018c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018cc:	85 c9                	test   %ecx,%ecx
  8018ce:	74 1c                	je     8018ec <strnlen+0x2a>
  8018d0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8018d3:	74 1e                	je     8018f3 <strnlen+0x31>
  8018d5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8018da:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018dc:	39 ca                	cmp    %ecx,%edx
  8018de:	74 18                	je     8018f8 <strnlen+0x36>
  8018e0:	83 c2 01             	add    $0x1,%edx
  8018e3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8018e8:	75 f0                	jne    8018da <strnlen+0x18>
  8018ea:	eb 0c                	jmp    8018f8 <strnlen+0x36>
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	eb 05                	jmp    8018f8 <strnlen+0x36>
  8018f3:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8018f8:	5b                   	pop    %ebx
  8018f9:	5d                   	pop    %ebp
  8018fa:	c3                   	ret    

008018fb <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	53                   	push   %ebx
  8018ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801905:	89 c2                	mov    %eax,%edx
  801907:	83 c2 01             	add    $0x1,%edx
  80190a:	83 c1 01             	add    $0x1,%ecx
  80190d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801911:	88 5a ff             	mov    %bl,-0x1(%edx)
  801914:	84 db                	test   %bl,%bl
  801916:	75 ef                	jne    801907 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801918:	5b                   	pop    %ebx
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    

0080191b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	83 ec 08             	sub    $0x8,%esp
  801922:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801925:	89 1c 24             	mov    %ebx,(%esp)
  801928:	e8 73 ff ff ff       	call   8018a0 <strlen>
	strcpy(dst + len, src);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	89 54 24 04          	mov    %edx,0x4(%esp)
  801934:	01 d8                	add    %ebx,%eax
  801936:	89 04 24             	mov    %eax,(%esp)
  801939:	e8 bd ff ff ff       	call   8018fb <strcpy>
	return dst;
}
  80193e:	89 d8                	mov    %ebx,%eax
  801940:	83 c4 08             	add    $0x8,%esp
  801943:	5b                   	pop    %ebx
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	56                   	push   %esi
  80194a:	53                   	push   %ebx
  80194b:	8b 75 08             	mov    0x8(%ebp),%esi
  80194e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801951:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801954:	85 db                	test   %ebx,%ebx
  801956:	74 17                	je     80196f <strncpy+0x29>
  801958:	01 f3                	add    %esi,%ebx
  80195a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80195c:	83 c1 01             	add    $0x1,%ecx
  80195f:	0f b6 02             	movzbl (%edx),%eax
  801962:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801965:	80 3a 01             	cmpb   $0x1,(%edx)
  801968:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80196b:	39 d9                	cmp    %ebx,%ecx
  80196d:	75 ed                	jne    80195c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80196f:	89 f0                	mov    %esi,%eax
  801971:	5b                   	pop    %ebx
  801972:	5e                   	pop    %esi
  801973:	5d                   	pop    %ebp
  801974:	c3                   	ret    

00801975 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	57                   	push   %edi
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80197e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801981:	8b 75 10             	mov    0x10(%ebp),%esi
  801984:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801986:	85 f6                	test   %esi,%esi
  801988:	74 34                	je     8019be <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80198a:	83 fe 01             	cmp    $0x1,%esi
  80198d:	74 26                	je     8019b5 <strlcpy+0x40>
  80198f:	0f b6 0b             	movzbl (%ebx),%ecx
  801992:	84 c9                	test   %cl,%cl
  801994:	74 23                	je     8019b9 <strlcpy+0x44>
  801996:	83 ee 02             	sub    $0x2,%esi
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  80199e:	83 c0 01             	add    $0x1,%eax
  8019a1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019a4:	39 f2                	cmp    %esi,%edx
  8019a6:	74 13                	je     8019bb <strlcpy+0x46>
  8019a8:	83 c2 01             	add    $0x1,%edx
  8019ab:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019af:	84 c9                	test   %cl,%cl
  8019b1:	75 eb                	jne    80199e <strlcpy+0x29>
  8019b3:	eb 06                	jmp    8019bb <strlcpy+0x46>
  8019b5:	89 f8                	mov    %edi,%eax
  8019b7:	eb 02                	jmp    8019bb <strlcpy+0x46>
  8019b9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8019bb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019be:	29 f8                	sub    %edi,%eax
}
  8019c0:	5b                   	pop    %ebx
  8019c1:	5e                   	pop    %esi
  8019c2:	5f                   	pop    %edi
  8019c3:	5d                   	pop    %ebp
  8019c4:	c3                   	ret    

008019c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8019ce:	0f b6 01             	movzbl (%ecx),%eax
  8019d1:	84 c0                	test   %al,%al
  8019d3:	74 15                	je     8019ea <strcmp+0x25>
  8019d5:	3a 02                	cmp    (%edx),%al
  8019d7:	75 11                	jne    8019ea <strcmp+0x25>
		p++, q++;
  8019d9:	83 c1 01             	add    $0x1,%ecx
  8019dc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019df:	0f b6 01             	movzbl (%ecx),%eax
  8019e2:	84 c0                	test   %al,%al
  8019e4:	74 04                	je     8019ea <strcmp+0x25>
  8019e6:	3a 02                	cmp    (%edx),%al
  8019e8:	74 ef                	je     8019d9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019ea:	0f b6 c0             	movzbl %al,%eax
  8019ed:	0f b6 12             	movzbl (%edx),%edx
  8019f0:	29 d0                	sub    %edx,%eax
}
  8019f2:	5d                   	pop    %ebp
  8019f3:	c3                   	ret    

008019f4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	56                   	push   %esi
  8019f8:	53                   	push   %ebx
  8019f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8019fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ff:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a02:	85 f6                	test   %esi,%esi
  801a04:	74 29                	je     801a2f <strncmp+0x3b>
  801a06:	0f b6 03             	movzbl (%ebx),%eax
  801a09:	84 c0                	test   %al,%al
  801a0b:	74 30                	je     801a3d <strncmp+0x49>
  801a0d:	3a 02                	cmp    (%edx),%al
  801a0f:	75 2c                	jne    801a3d <strncmp+0x49>
  801a11:	8d 43 01             	lea    0x1(%ebx),%eax
  801a14:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a16:	89 c3                	mov    %eax,%ebx
  801a18:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a1b:	39 f0                	cmp    %esi,%eax
  801a1d:	74 17                	je     801a36 <strncmp+0x42>
  801a1f:	0f b6 08             	movzbl (%eax),%ecx
  801a22:	84 c9                	test   %cl,%cl
  801a24:	74 17                	je     801a3d <strncmp+0x49>
  801a26:	83 c0 01             	add    $0x1,%eax
  801a29:	3a 0a                	cmp    (%edx),%cl
  801a2b:	74 e9                	je     801a16 <strncmp+0x22>
  801a2d:	eb 0e                	jmp    801a3d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a34:	eb 0f                	jmp    801a45 <strncmp+0x51>
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3b:	eb 08                	jmp    801a45 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a3d:	0f b6 03             	movzbl (%ebx),%eax
  801a40:	0f b6 12             	movzbl (%edx),%edx
  801a43:	29 d0                	sub    %edx,%eax
}
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	53                   	push   %ebx
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a53:	0f b6 18             	movzbl (%eax),%ebx
  801a56:	84 db                	test   %bl,%bl
  801a58:	74 1d                	je     801a77 <strchr+0x2e>
  801a5a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a5c:	38 d3                	cmp    %dl,%bl
  801a5e:	75 06                	jne    801a66 <strchr+0x1d>
  801a60:	eb 1a                	jmp    801a7c <strchr+0x33>
  801a62:	38 ca                	cmp    %cl,%dl
  801a64:	74 16                	je     801a7c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a66:	83 c0 01             	add    $0x1,%eax
  801a69:	0f b6 10             	movzbl (%eax),%edx
  801a6c:	84 d2                	test   %dl,%dl
  801a6e:	75 f2                	jne    801a62 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
  801a75:	eb 05                	jmp    801a7c <strchr+0x33>
  801a77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a7c:	5b                   	pop    %ebx
  801a7d:	5d                   	pop    %ebp
  801a7e:	c3                   	ret    

00801a7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	53                   	push   %ebx
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a89:	0f b6 18             	movzbl (%eax),%ebx
  801a8c:	84 db                	test   %bl,%bl
  801a8e:	74 16                	je     801aa6 <strfind+0x27>
  801a90:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a92:	38 d3                	cmp    %dl,%bl
  801a94:	75 06                	jne    801a9c <strfind+0x1d>
  801a96:	eb 0e                	jmp    801aa6 <strfind+0x27>
  801a98:	38 ca                	cmp    %cl,%dl
  801a9a:	74 0a                	je     801aa6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801a9c:	83 c0 01             	add    $0x1,%eax
  801a9f:	0f b6 10             	movzbl (%eax),%edx
  801aa2:	84 d2                	test   %dl,%dl
  801aa4:	75 f2                	jne    801a98 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801aa6:	5b                   	pop    %ebx
  801aa7:	5d                   	pop    %ebp
  801aa8:	c3                   	ret    

00801aa9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	57                   	push   %edi
  801aad:	56                   	push   %esi
  801aae:	53                   	push   %ebx
  801aaf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ab2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ab5:	85 c9                	test   %ecx,%ecx
  801ab7:	74 36                	je     801aef <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ab9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801abf:	75 28                	jne    801ae9 <memset+0x40>
  801ac1:	f6 c1 03             	test   $0x3,%cl
  801ac4:	75 23                	jne    801ae9 <memset+0x40>
		c &= 0xFF;
  801ac6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801aca:	89 d3                	mov    %edx,%ebx
  801acc:	c1 e3 08             	shl    $0x8,%ebx
  801acf:	89 d6                	mov    %edx,%esi
  801ad1:	c1 e6 18             	shl    $0x18,%esi
  801ad4:	89 d0                	mov    %edx,%eax
  801ad6:	c1 e0 10             	shl    $0x10,%eax
  801ad9:	09 f0                	or     %esi,%eax
  801adb:	09 c2                	or     %eax,%edx
  801add:	89 d0                	mov    %edx,%eax
  801adf:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801ae1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801ae4:	fc                   	cld    
  801ae5:	f3 ab                	rep stos %eax,%es:(%edi)
  801ae7:	eb 06                	jmp    801aef <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aec:	fc                   	cld    
  801aed:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801aef:	89 f8                	mov    %edi,%eax
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5f                   	pop    %edi
  801af4:	5d                   	pop    %ebp
  801af5:	c3                   	ret    

00801af6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	57                   	push   %edi
  801afa:	56                   	push   %esi
  801afb:	8b 45 08             	mov    0x8(%ebp),%eax
  801afe:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b01:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b04:	39 c6                	cmp    %eax,%esi
  801b06:	73 35                	jae    801b3d <memmove+0x47>
  801b08:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b0b:	39 d0                	cmp    %edx,%eax
  801b0d:	73 2e                	jae    801b3d <memmove+0x47>
		s += n;
		d += n;
  801b0f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b12:	89 d6                	mov    %edx,%esi
  801b14:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b1c:	75 13                	jne    801b31 <memmove+0x3b>
  801b1e:	f6 c1 03             	test   $0x3,%cl
  801b21:	75 0e                	jne    801b31 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b23:	83 ef 04             	sub    $0x4,%edi
  801b26:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b29:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b2c:	fd                   	std    
  801b2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b2f:	eb 09                	jmp    801b3a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b31:	83 ef 01             	sub    $0x1,%edi
  801b34:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b37:	fd                   	std    
  801b38:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b3a:	fc                   	cld    
  801b3b:	eb 1d                	jmp    801b5a <memmove+0x64>
  801b3d:	89 f2                	mov    %esi,%edx
  801b3f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b41:	f6 c2 03             	test   $0x3,%dl
  801b44:	75 0f                	jne    801b55 <memmove+0x5f>
  801b46:	f6 c1 03             	test   $0x3,%cl
  801b49:	75 0a                	jne    801b55 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b4b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b4e:	89 c7                	mov    %eax,%edi
  801b50:	fc                   	cld    
  801b51:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b53:	eb 05                	jmp    801b5a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b55:	89 c7                	mov    %eax,%edi
  801b57:	fc                   	cld    
  801b58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b5a:	5e                   	pop    %esi
  801b5b:	5f                   	pop    %edi
  801b5c:	5d                   	pop    %ebp
  801b5d:	c3                   	ret    

00801b5e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801b64:	8b 45 10             	mov    0x10(%ebp),%eax
  801b67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	89 04 24             	mov    %eax,(%esp)
  801b78:	e8 79 ff ff ff       	call   801af6 <memmove>
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	57                   	push   %edi
  801b83:	56                   	push   %esi
  801b84:	53                   	push   %ebx
  801b85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b88:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b8b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b8e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801b91:	85 c0                	test   %eax,%eax
  801b93:	74 36                	je     801bcb <memcmp+0x4c>
		if (*s1 != *s2)
  801b95:	0f b6 03             	movzbl (%ebx),%eax
  801b98:	0f b6 0e             	movzbl (%esi),%ecx
  801b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba0:	38 c8                	cmp    %cl,%al
  801ba2:	74 1c                	je     801bc0 <memcmp+0x41>
  801ba4:	eb 10                	jmp    801bb6 <memcmp+0x37>
  801ba6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801bab:	83 c2 01             	add    $0x1,%edx
  801bae:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801bb2:	38 c8                	cmp    %cl,%al
  801bb4:	74 0a                	je     801bc0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801bb6:	0f b6 c0             	movzbl %al,%eax
  801bb9:	0f b6 c9             	movzbl %cl,%ecx
  801bbc:	29 c8                	sub    %ecx,%eax
  801bbe:	eb 10                	jmp    801bd0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bc0:	39 fa                	cmp    %edi,%edx
  801bc2:	75 e2                	jne    801ba6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc9:	eb 05                	jmp    801bd0 <memcmp+0x51>
  801bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bd0:	5b                   	pop    %ebx
  801bd1:	5e                   	pop    %esi
  801bd2:	5f                   	pop    %edi
  801bd3:	5d                   	pop    %ebp
  801bd4:	c3                   	ret    

00801bd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	53                   	push   %ebx
  801bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801bdf:	89 c2                	mov    %eax,%edx
  801be1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801be4:	39 d0                	cmp    %edx,%eax
  801be6:	73 13                	jae    801bfb <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801be8:	89 d9                	mov    %ebx,%ecx
  801bea:	38 18                	cmp    %bl,(%eax)
  801bec:	75 06                	jne    801bf4 <memfind+0x1f>
  801bee:	eb 0b                	jmp    801bfb <memfind+0x26>
  801bf0:	38 08                	cmp    %cl,(%eax)
  801bf2:	74 07                	je     801bfb <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801bf4:	83 c0 01             	add    $0x1,%eax
  801bf7:	39 d0                	cmp    %edx,%eax
  801bf9:	75 f5                	jne    801bf0 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801bfb:	5b                   	pop    %ebx
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    

00801bfe <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	57                   	push   %edi
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	8b 55 08             	mov    0x8(%ebp),%edx
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c0a:	0f b6 0a             	movzbl (%edx),%ecx
  801c0d:	80 f9 09             	cmp    $0x9,%cl
  801c10:	74 05                	je     801c17 <strtol+0x19>
  801c12:	80 f9 20             	cmp    $0x20,%cl
  801c15:	75 10                	jne    801c27 <strtol+0x29>
		s++;
  801c17:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c1a:	0f b6 0a             	movzbl (%edx),%ecx
  801c1d:	80 f9 09             	cmp    $0x9,%cl
  801c20:	74 f5                	je     801c17 <strtol+0x19>
  801c22:	80 f9 20             	cmp    $0x20,%cl
  801c25:	74 f0                	je     801c17 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c27:	80 f9 2b             	cmp    $0x2b,%cl
  801c2a:	75 0a                	jne    801c36 <strtol+0x38>
		s++;
  801c2c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c2f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c34:	eb 11                	jmp    801c47 <strtol+0x49>
  801c36:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c3b:	80 f9 2d             	cmp    $0x2d,%cl
  801c3e:	75 07                	jne    801c47 <strtol+0x49>
		s++, neg = 1;
  801c40:	83 c2 01             	add    $0x1,%edx
  801c43:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c47:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c4c:	75 15                	jne    801c63 <strtol+0x65>
  801c4e:	80 3a 30             	cmpb   $0x30,(%edx)
  801c51:	75 10                	jne    801c63 <strtol+0x65>
  801c53:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801c57:	75 0a                	jne    801c63 <strtol+0x65>
		s += 2, base = 16;
  801c59:	83 c2 02             	add    $0x2,%edx
  801c5c:	b8 10 00 00 00       	mov    $0x10,%eax
  801c61:	eb 10                	jmp    801c73 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801c63:	85 c0                	test   %eax,%eax
  801c65:	75 0c                	jne    801c73 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801c67:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801c69:	80 3a 30             	cmpb   $0x30,(%edx)
  801c6c:	75 05                	jne    801c73 <strtol+0x75>
		s++, base = 8;
  801c6e:	83 c2 01             	add    $0x1,%edx
  801c71:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801c73:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c78:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c7b:	0f b6 0a             	movzbl (%edx),%ecx
  801c7e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801c81:	89 f0                	mov    %esi,%eax
  801c83:	3c 09                	cmp    $0x9,%al
  801c85:	77 08                	ja     801c8f <strtol+0x91>
			dig = *s - '0';
  801c87:	0f be c9             	movsbl %cl,%ecx
  801c8a:	83 e9 30             	sub    $0x30,%ecx
  801c8d:	eb 20                	jmp    801caf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801c8f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801c92:	89 f0                	mov    %esi,%eax
  801c94:	3c 19                	cmp    $0x19,%al
  801c96:	77 08                	ja     801ca0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801c98:	0f be c9             	movsbl %cl,%ecx
  801c9b:	83 e9 57             	sub    $0x57,%ecx
  801c9e:	eb 0f                	jmp    801caf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801ca0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801ca3:	89 f0                	mov    %esi,%eax
  801ca5:	3c 19                	cmp    $0x19,%al
  801ca7:	77 16                	ja     801cbf <strtol+0xc1>
			dig = *s - 'A' + 10;
  801ca9:	0f be c9             	movsbl %cl,%ecx
  801cac:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801caf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801cb2:	7d 0f                	jge    801cc3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801cb4:	83 c2 01             	add    $0x1,%edx
  801cb7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801cbb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801cbd:	eb bc                	jmp    801c7b <strtol+0x7d>
  801cbf:	89 d8                	mov    %ebx,%eax
  801cc1:	eb 02                	jmp    801cc5 <strtol+0xc7>
  801cc3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801cc5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cc9:	74 05                	je     801cd0 <strtol+0xd2>
		*endptr = (char *) s;
  801ccb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cce:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801cd0:	f7 d8                	neg    %eax
  801cd2:	85 ff                	test   %edi,%edi
  801cd4:	0f 44 c3             	cmove  %ebx,%eax
}
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    

00801cdc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	56                   	push   %esi
  801ce0:	53                   	push   %ebx
  801ce1:	83 ec 10             	sub    $0x10,%esp
  801ce4:	8b 75 08             	mov    0x8(%ebp),%esi
  801ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cea:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? pg : (void*)UTOP);
  801ced:	83 f8 01             	cmp    $0x1,%eax
  801cf0:	19 c0                	sbb    %eax,%eax
  801cf2:	f7 d0                	not    %eax
  801cf4:	25 00 00 c0 ee       	and    $0xeec00000,%eax
  801cf9:	89 04 24             	mov    %eax,(%esp)
  801cfc:	e8 ad e6 ff ff       	call   8003ae <sys_ipc_recv>
	if (err_code < 0) {
  801d01:	85 c0                	test   %eax,%eax
  801d03:	79 16                	jns    801d1b <ipc_recv+0x3f>
		if (from_env_store) *from_env_store = 0;
  801d05:	85 f6                	test   %esi,%esi
  801d07:	74 06                	je     801d0f <ipc_recv+0x33>
  801d09:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d0f:	85 db                	test   %ebx,%ebx
  801d11:	74 2c                	je     801d3f <ipc_recv+0x63>
  801d13:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d19:	eb 24                	jmp    801d3f <ipc_recv+0x63>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d1b:	85 f6                	test   %esi,%esi
  801d1d:	74 0a                	je     801d29 <ipc_recv+0x4d>
  801d1f:	a1 04 40 80 00       	mov    0x804004,%eax
  801d24:	8b 40 74             	mov    0x74(%eax),%eax
  801d27:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d29:	85 db                	test   %ebx,%ebx
  801d2b:	74 0a                	je     801d37 <ipc_recv+0x5b>
  801d2d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d32:	8b 40 78             	mov    0x78(%eax),%eax
  801d35:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d37:	a1 04 40 80 00       	mov    0x804004,%eax
  801d3c:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5d                   	pop    %ebp
  801d45:	c3                   	ret    

00801d46 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	57                   	push   %edi
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 1c             	sub    $0x1c,%esp
  801d4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d52:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d58:	eb 25                	jmp    801d7f <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d5a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d5d:	74 20                	je     801d7f <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d63:	c7 44 24 08 00 25 80 	movl   $0x802500,0x8(%esp)
  801d6a:	00 
  801d6b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801d72:	00 
  801d73:	c7 04 24 0c 25 80 00 	movl   $0x80250c,(%esp)
  801d7a:	e8 27 f4 ff ff       	call   8011a6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d7f:	85 db                	test   %ebx,%ebx
  801d81:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d86:	0f 45 c3             	cmovne %ebx,%eax
  801d89:	8b 55 14             	mov    0x14(%ebp),%edx
  801d8c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d94:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d98:	89 3c 24             	mov    %edi,(%esp)
  801d9b:	e8 eb e5 ff ff       	call   80038b <sys_ipc_try_send>
  801da0:	85 c0                	test   %eax,%eax
  801da2:	75 b6                	jne    801d5a <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801da4:	83 c4 1c             	add    $0x1c,%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    

00801dac <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801db2:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801db7:	39 c8                	cmp    %ecx,%eax
  801db9:	74 17                	je     801dd2 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dbb:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dc0:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dc3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dc9:	8b 52 50             	mov    0x50(%edx),%edx
  801dcc:	39 ca                	cmp    %ecx,%edx
  801dce:	75 14                	jne    801de4 <ipc_find_env+0x38>
  801dd0:	eb 05                	jmp    801dd7 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801dd7:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801dda:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ddf:	8b 40 40             	mov    0x40(%eax),%eax
  801de2:	eb 0e                	jmp    801df2 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801de4:	83 c0 01             	add    $0x1,%eax
  801de7:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dec:	75 d2                	jne    801dc0 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801dee:	66 b8 00 00          	mov    $0x0,%ax
}
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dfa:	89 d0                	mov    %edx,%eax
  801dfc:	c1 e8 16             	shr    $0x16,%eax
  801dff:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e0b:	f6 c1 01             	test   $0x1,%cl
  801e0e:	74 1d                	je     801e2d <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e10:	c1 ea 0c             	shr    $0xc,%edx
  801e13:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e1a:	f6 c2 01             	test   $0x1,%dl
  801e1d:	74 0e                	je     801e2d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e1f:	c1 ea 0c             	shr    $0xc,%edx
  801e22:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e29:	ef 
  801e2a:	0f b7 c0             	movzwl %ax,%eax
}
  801e2d:	5d                   	pop    %ebp
  801e2e:	c3                   	ret    
  801e2f:	90                   	nop

00801e30 <__udivdi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	83 ec 0c             	sub    $0xc,%esp
  801e36:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e3a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e3e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e46:	85 c0                	test   %eax,%eax
  801e48:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e4c:	89 ea                	mov    %ebp,%edx
  801e4e:	89 0c 24             	mov    %ecx,(%esp)
  801e51:	75 2d                	jne    801e80 <__udivdi3+0x50>
  801e53:	39 e9                	cmp    %ebp,%ecx
  801e55:	77 61                	ja     801eb8 <__udivdi3+0x88>
  801e57:	85 c9                	test   %ecx,%ecx
  801e59:	89 ce                	mov    %ecx,%esi
  801e5b:	75 0b                	jne    801e68 <__udivdi3+0x38>
  801e5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e62:	31 d2                	xor    %edx,%edx
  801e64:	f7 f1                	div    %ecx
  801e66:	89 c6                	mov    %eax,%esi
  801e68:	31 d2                	xor    %edx,%edx
  801e6a:	89 e8                	mov    %ebp,%eax
  801e6c:	f7 f6                	div    %esi
  801e6e:	89 c5                	mov    %eax,%ebp
  801e70:	89 f8                	mov    %edi,%eax
  801e72:	f7 f6                	div    %esi
  801e74:	89 ea                	mov    %ebp,%edx
  801e76:	83 c4 0c             	add    $0xc,%esp
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
  801e7d:	8d 76 00             	lea    0x0(%esi),%esi
  801e80:	39 e8                	cmp    %ebp,%eax
  801e82:	77 24                	ja     801ea8 <__udivdi3+0x78>
  801e84:	0f bd e8             	bsr    %eax,%ebp
  801e87:	83 f5 1f             	xor    $0x1f,%ebp
  801e8a:	75 3c                	jne    801ec8 <__udivdi3+0x98>
  801e8c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801e90:	39 34 24             	cmp    %esi,(%esp)
  801e93:	0f 86 9f 00 00 00    	jbe    801f38 <__udivdi3+0x108>
  801e99:	39 d0                	cmp    %edx,%eax
  801e9b:	0f 82 97 00 00 00    	jb     801f38 <__udivdi3+0x108>
  801ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ea8:	31 d2                	xor    %edx,%edx
  801eaa:	31 c0                	xor    %eax,%eax
  801eac:	83 c4 0c             	add    $0xc,%esp
  801eaf:	5e                   	pop    %esi
  801eb0:	5f                   	pop    %edi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    
  801eb3:	90                   	nop
  801eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801eb8:	89 f8                	mov    %edi,%eax
  801eba:	f7 f1                	div    %ecx
  801ebc:	31 d2                	xor    %edx,%edx
  801ebe:	83 c4 0c             	add    $0xc,%esp
  801ec1:	5e                   	pop    %esi
  801ec2:	5f                   	pop    %edi
  801ec3:	5d                   	pop    %ebp
  801ec4:	c3                   	ret    
  801ec5:	8d 76 00             	lea    0x0(%esi),%esi
  801ec8:	89 e9                	mov    %ebp,%ecx
  801eca:	8b 3c 24             	mov    (%esp),%edi
  801ecd:	d3 e0                	shl    %cl,%eax
  801ecf:	89 c6                	mov    %eax,%esi
  801ed1:	b8 20 00 00 00       	mov    $0x20,%eax
  801ed6:	29 e8                	sub    %ebp,%eax
  801ed8:	89 c1                	mov    %eax,%ecx
  801eda:	d3 ef                	shr    %cl,%edi
  801edc:	89 e9                	mov    %ebp,%ecx
  801ede:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ee2:	8b 3c 24             	mov    (%esp),%edi
  801ee5:	09 74 24 08          	or     %esi,0x8(%esp)
  801ee9:	89 d6                	mov    %edx,%esi
  801eeb:	d3 e7                	shl    %cl,%edi
  801eed:	89 c1                	mov    %eax,%ecx
  801eef:	89 3c 24             	mov    %edi,(%esp)
  801ef2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801ef6:	d3 ee                	shr    %cl,%esi
  801ef8:	89 e9                	mov    %ebp,%ecx
  801efa:	d3 e2                	shl    %cl,%edx
  801efc:	89 c1                	mov    %eax,%ecx
  801efe:	d3 ef                	shr    %cl,%edi
  801f00:	09 d7                	or     %edx,%edi
  801f02:	89 f2                	mov    %esi,%edx
  801f04:	89 f8                	mov    %edi,%eax
  801f06:	f7 74 24 08          	divl   0x8(%esp)
  801f0a:	89 d6                	mov    %edx,%esi
  801f0c:	89 c7                	mov    %eax,%edi
  801f0e:	f7 24 24             	mull   (%esp)
  801f11:	39 d6                	cmp    %edx,%esi
  801f13:	89 14 24             	mov    %edx,(%esp)
  801f16:	72 30                	jb     801f48 <__udivdi3+0x118>
  801f18:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f1c:	89 e9                	mov    %ebp,%ecx
  801f1e:	d3 e2                	shl    %cl,%edx
  801f20:	39 c2                	cmp    %eax,%edx
  801f22:	73 05                	jae    801f29 <__udivdi3+0xf9>
  801f24:	3b 34 24             	cmp    (%esp),%esi
  801f27:	74 1f                	je     801f48 <__udivdi3+0x118>
  801f29:	89 f8                	mov    %edi,%eax
  801f2b:	31 d2                	xor    %edx,%edx
  801f2d:	e9 7a ff ff ff       	jmp    801eac <__udivdi3+0x7c>
  801f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f38:	31 d2                	xor    %edx,%edx
  801f3a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3f:	e9 68 ff ff ff       	jmp    801eac <__udivdi3+0x7c>
  801f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f48:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	83 c4 0c             	add    $0xc,%esp
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	66 90                	xchg   %ax,%ax
  801f56:	66 90                	xchg   %ax,%ax
  801f58:	66 90                	xchg   %ax,%ax
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	66 90                	xchg   %ax,%ax
  801f5e:	66 90                	xchg   %ax,%ax

00801f60 <__umoddi3>:
  801f60:	55                   	push   %ebp
  801f61:	57                   	push   %edi
  801f62:	56                   	push   %esi
  801f63:	83 ec 14             	sub    $0x14,%esp
  801f66:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f6a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f6e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801f72:	89 c7                	mov    %eax,%edi
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	8b 44 24 30          	mov    0x30(%esp),%eax
  801f7c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801f80:	89 34 24             	mov    %esi,(%esp)
  801f83:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f87:	85 c0                	test   %eax,%eax
  801f89:	89 c2                	mov    %eax,%edx
  801f8b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f8f:	75 17                	jne    801fa8 <__umoddi3+0x48>
  801f91:	39 fe                	cmp    %edi,%esi
  801f93:	76 4b                	jbe    801fe0 <__umoddi3+0x80>
  801f95:	89 c8                	mov    %ecx,%eax
  801f97:	89 fa                	mov    %edi,%edx
  801f99:	f7 f6                	div    %esi
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	31 d2                	xor    %edx,%edx
  801f9f:	83 c4 14             	add    $0x14,%esp
  801fa2:	5e                   	pop    %esi
  801fa3:	5f                   	pop    %edi
  801fa4:	5d                   	pop    %ebp
  801fa5:	c3                   	ret    
  801fa6:	66 90                	xchg   %ax,%ax
  801fa8:	39 f8                	cmp    %edi,%eax
  801faa:	77 54                	ja     802000 <__umoddi3+0xa0>
  801fac:	0f bd e8             	bsr    %eax,%ebp
  801faf:	83 f5 1f             	xor    $0x1f,%ebp
  801fb2:	75 5c                	jne    802010 <__umoddi3+0xb0>
  801fb4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fb8:	39 3c 24             	cmp    %edi,(%esp)
  801fbb:	0f 87 e7 00 00 00    	ja     8020a8 <__umoddi3+0x148>
  801fc1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fc5:	29 f1                	sub    %esi,%ecx
  801fc7:	19 c7                	sbb    %eax,%edi
  801fc9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fcd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fd1:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fd5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801fd9:	83 c4 14             	add    $0x14,%esp
  801fdc:	5e                   	pop    %esi
  801fdd:	5f                   	pop    %edi
  801fde:	5d                   	pop    %ebp
  801fdf:	c3                   	ret    
  801fe0:	85 f6                	test   %esi,%esi
  801fe2:	89 f5                	mov    %esi,%ebp
  801fe4:	75 0b                	jne    801ff1 <__umoddi3+0x91>
  801fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  801feb:	31 d2                	xor    %edx,%edx
  801fed:	f7 f6                	div    %esi
  801fef:	89 c5                	mov    %eax,%ebp
  801ff1:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ff5:	31 d2                	xor    %edx,%edx
  801ff7:	f7 f5                	div    %ebp
  801ff9:	89 c8                	mov    %ecx,%eax
  801ffb:	f7 f5                	div    %ebp
  801ffd:	eb 9c                	jmp    801f9b <__umoddi3+0x3b>
  801fff:	90                   	nop
  802000:	89 c8                	mov    %ecx,%eax
  802002:	89 fa                	mov    %edi,%edx
  802004:	83 c4 14             	add    $0x14,%esp
  802007:	5e                   	pop    %esi
  802008:	5f                   	pop    %edi
  802009:	5d                   	pop    %ebp
  80200a:	c3                   	ret    
  80200b:	90                   	nop
  80200c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802010:	8b 04 24             	mov    (%esp),%eax
  802013:	be 20 00 00 00       	mov    $0x20,%esi
  802018:	89 e9                	mov    %ebp,%ecx
  80201a:	29 ee                	sub    %ebp,%esi
  80201c:	d3 e2                	shl    %cl,%edx
  80201e:	89 f1                	mov    %esi,%ecx
  802020:	d3 e8                	shr    %cl,%eax
  802022:	89 e9                	mov    %ebp,%ecx
  802024:	89 44 24 04          	mov    %eax,0x4(%esp)
  802028:	8b 04 24             	mov    (%esp),%eax
  80202b:	09 54 24 04          	or     %edx,0x4(%esp)
  80202f:	89 fa                	mov    %edi,%edx
  802031:	d3 e0                	shl    %cl,%eax
  802033:	89 f1                	mov    %esi,%ecx
  802035:	89 44 24 08          	mov    %eax,0x8(%esp)
  802039:	8b 44 24 10          	mov    0x10(%esp),%eax
  80203d:	d3 ea                	shr    %cl,%edx
  80203f:	89 e9                	mov    %ebp,%ecx
  802041:	d3 e7                	shl    %cl,%edi
  802043:	89 f1                	mov    %esi,%ecx
  802045:	d3 e8                	shr    %cl,%eax
  802047:	89 e9                	mov    %ebp,%ecx
  802049:	09 f8                	or     %edi,%eax
  80204b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80204f:	f7 74 24 04          	divl   0x4(%esp)
  802053:	d3 e7                	shl    %cl,%edi
  802055:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802059:	89 d7                	mov    %edx,%edi
  80205b:	f7 64 24 08          	mull   0x8(%esp)
  80205f:	39 d7                	cmp    %edx,%edi
  802061:	89 c1                	mov    %eax,%ecx
  802063:	89 14 24             	mov    %edx,(%esp)
  802066:	72 2c                	jb     802094 <__umoddi3+0x134>
  802068:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80206c:	72 22                	jb     802090 <__umoddi3+0x130>
  80206e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802072:	29 c8                	sub    %ecx,%eax
  802074:	19 d7                	sbb    %edx,%edi
  802076:	89 e9                	mov    %ebp,%ecx
  802078:	89 fa                	mov    %edi,%edx
  80207a:	d3 e8                	shr    %cl,%eax
  80207c:	89 f1                	mov    %esi,%ecx
  80207e:	d3 e2                	shl    %cl,%edx
  802080:	89 e9                	mov    %ebp,%ecx
  802082:	d3 ef                	shr    %cl,%edi
  802084:	09 d0                	or     %edx,%eax
  802086:	89 fa                	mov    %edi,%edx
  802088:	83 c4 14             	add    $0x14,%esp
  80208b:	5e                   	pop    %esi
  80208c:	5f                   	pop    %edi
  80208d:	5d                   	pop    %ebp
  80208e:	c3                   	ret    
  80208f:	90                   	nop
  802090:	39 d7                	cmp    %edx,%edi
  802092:	75 da                	jne    80206e <__umoddi3+0x10e>
  802094:	8b 14 24             	mov    (%esp),%edx
  802097:	89 c1                	mov    %eax,%ecx
  802099:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80209d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020a1:	eb cb                	jmp    80206e <__umoddi3+0x10e>
  8020a3:	90                   	nop
  8020a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020a8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020ac:	0f 82 0f ff ff ff    	jb     801fc1 <__umoddi3+0x61>
  8020b2:	e9 1a ff ff ff       	jmp    801fd1 <__umoddi3+0x71>
