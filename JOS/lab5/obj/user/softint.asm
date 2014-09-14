
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
  800136:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80013d:	00 
  80013e:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800145:	00 
  800146:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80014d:	e8 84 10 00 00       	call   8011d6 <_panic>

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
  8001c8:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  8001cf:	00 
  8001d0:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001d7:	00 
  8001d8:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  8001df:	e8 f2 0f 00 00       	call   8011d6 <_panic>

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
  80021b:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  800222:	00 
  800223:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80022a:	00 
  80022b:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  800232:	e8 9f 0f 00 00       	call   8011d6 <_panic>

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
  80026e:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  800275:	00 
  800276:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80027d:	00 
  80027e:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  800285:	e8 4c 0f 00 00       	call   8011d6 <_panic>

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
  8002c1:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  8002c8:	00 
  8002c9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002d0:	00 
  8002d1:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  8002d8:	e8 f9 0e 00 00       	call   8011d6 <_panic>

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
  800314:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80031b:	00 
  80031c:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800323:	00 
  800324:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80032b:	e8 a6 0e 00 00       	call   8011d6 <_panic>

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
  800367:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  80036e:	00 
  80036f:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800376:	00 
  800377:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  80037e:	e8 53 0e 00 00       	call   8011d6 <_panic>

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
  8003dc:	c7 44 24 08 0a 21 80 	movl   $0x80210a,0x8(%esp)
  8003e3:	00 
  8003e4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8003eb:	00 
  8003ec:	c7 04 24 27 21 80 00 	movl   $0x802127,(%esp)
  8003f3:	e8 de 0d 00 00       	call   8011d6 <_panic>

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
  800545:	c7 04 24 38 21 80 00 	movl   $0x802138,(%esp)
  80054c:	e8 7e 0d 00 00       	call   8012cf <cprintf>
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
  80079b:	c7 04 24 79 21 80 00 	movl   $0x802179,(%esp)
  8007a2:	e8 28 0b 00 00       	call   8012cf <cprintf>
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
  800883:	c7 04 24 95 21 80 00 	movl   $0x802195,(%esp)
  80088a:	e8 40 0a 00 00       	call   8012cf <cprintf>
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
  80093c:	c7 04 24 58 21 80 00 	movl   $0x802158,(%esp)
  800943:	e8 87 09 00 00       	call   8012cf <cprintf>
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
  800a02:	e8 e1 01 00 00       	call   800be8 <open>
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
  800a37:	89 c3                	mov    %eax,%ebx
  800a39:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800a3b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a42:	75 11                	jne    800a55 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a4b:	e8 8a 13 00 00       	call   801dda <ipc_find_env>
  800a50:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  800a55:	a1 04 40 80 00       	mov    0x804004,%eax
  800a5a:	8b 40 48             	mov    0x48(%eax),%eax
  800a5d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a67:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6f:	c7 04 24 b2 21 80 00 	movl   $0x8021b2,(%esp)
  800a76:	e8 54 08 00 00       	call   8012cf <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a7b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800a82:	00 
  800a83:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800a8a:	00 
  800a8b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a8f:	a1 00 40 80 00       	mov    0x804000,%eax
  800a94:	89 04 24             	mov    %eax,(%esp)
  800a97:	e8 d8 12 00 00       	call   801d74 <ipc_send>
	cprintf("ipc_send\n");
  800a9c:	c7 04 24 c8 21 80 00 	movl   $0x8021c8,(%esp)
  800aa3:	e8 27 08 00 00       	call   8012cf <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  800aa8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800aaf:	00 
  800ab0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800abb:	e8 4c 12 00 00       	call   801d0c <ipc_recv>
}
  800ac0:	83 c4 10             	add    $0x10,%esp
  800ac3:	5b                   	pop    %ebx
  800ac4:	5e                   	pop    %esi
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	83 ec 14             	sub    $0x14,%esp
  800ace:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  800ad7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800adc:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae1:	b8 05 00 00 00       	mov    $0x5,%eax
  800ae6:	e8 44 ff ff ff       	call   800a2f <fsipc>
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	85 d2                	test   %edx,%edx
  800aef:	78 2b                	js     800b1c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800af1:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800af8:	00 
  800af9:	89 1c 24             	mov    %ebx,(%esp)
  800afc:	e8 2a 0e 00 00       	call   80192b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b01:	a1 80 50 80 00       	mov    0x805080,%eax
  800b06:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b0c:	a1 84 50 80 00       	mov    0x805084,%eax
  800b11:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b1c:	83 c4 14             	add    $0x14,%esp
  800b1f:	5b                   	pop    %ebx
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8b 40 0c             	mov    0xc(%eax),%eax
  800b2e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b33:	ba 00 00 00 00       	mov    $0x0,%edx
  800b38:	b8 06 00 00 00       	mov    $0x6,%eax
  800b3d:	e8 ed fe ff ff       	call   800a2f <fsipc>
}
  800b42:	c9                   	leave  
  800b43:	c3                   	ret    

00800b44 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	56                   	push   %esi
  800b48:	53                   	push   %ebx
  800b49:	83 ec 10             	sub    $0x10,%esp
  800b4c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 40 0c             	mov    0xc(%eax),%eax
  800b55:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b5a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b60:	ba 00 00 00 00       	mov    $0x0,%edx
  800b65:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6a:	e8 c0 fe ff ff       	call   800a2f <fsipc>
  800b6f:	89 c3                	mov    %eax,%ebx
  800b71:	85 c0                	test   %eax,%eax
  800b73:	78 6a                	js     800bdf <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b75:	39 c6                	cmp    %eax,%esi
  800b77:	73 24                	jae    800b9d <devfile_read+0x59>
  800b79:	c7 44 24 0c d2 21 80 	movl   $0x8021d2,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 d9 21 80 	movl   $0x8021d9,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 ee 21 80 00 	movl   $0x8021ee,(%esp)
  800b98:	e8 39 06 00 00       	call   8011d6 <_panic>
	assert(r <= PGSIZE);
  800b9d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ba2:	7e 24                	jle    800bc8 <devfile_read+0x84>
  800ba4:	c7 44 24 0c f9 21 80 	movl   $0x8021f9,0xc(%esp)
  800bab:	00 
  800bac:	c7 44 24 08 d9 21 80 	movl   $0x8021d9,0x8(%esp)
  800bb3:	00 
  800bb4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800bbb:	00 
  800bbc:	c7 04 24 ee 21 80 00 	movl   $0x8021ee,(%esp)
  800bc3:	e8 0e 06 00 00       	call   8011d6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800bc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bcc:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bd3:	00 
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	89 04 24             	mov    %eax,(%esp)
  800bda:	e8 47 0f 00 00       	call   801b26 <memmove>
	return r;
}
  800bdf:	89 d8                	mov    %ebx,%eax
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	5b                   	pop    %ebx
  800be5:	5e                   	pop    %esi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 24             	sub    $0x24,%esp
  800bef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800bf2:	89 1c 24             	mov    %ebx,(%esp)
  800bf5:	e8 d6 0c 00 00       	call   8018d0 <strlen>
  800bfa:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bff:	7f 60                	jg     800c61 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c04:	89 04 24             	mov    %eax,(%esp)
  800c07:	e8 1b f8 ff ff       	call   800427 <fd_alloc>
  800c0c:	89 c2                	mov    %eax,%edx
  800c0e:	85 d2                	test   %edx,%edx
  800c10:	78 54                	js     800c66 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c16:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c1d:	e8 09 0d 00 00       	call   80192b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c32:	e8 f8 fd ff ff       	call   800a2f <fsipc>
  800c37:	89 c3                	mov    %eax,%ebx
  800c39:	85 c0                	test   %eax,%eax
  800c3b:	79 17                	jns    800c54 <open+0x6c>
		fd_close(fd, 0);
  800c3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c44:	00 
  800c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c48:	89 04 24             	mov    %eax,(%esp)
  800c4b:	e8 12 f9 ff ff       	call   800562 <fd_close>
		return r;
  800c50:	89 d8                	mov    %ebx,%eax
  800c52:	eb 12                	jmp    800c66 <open+0x7e>
	}
	return fd2num(fd);
  800c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c57:	89 04 24             	mov    %eax,(%esp)
  800c5a:	e8 a1 f7 ff ff       	call   800400 <fd2num>
  800c5f:	eb 05                	jmp    800c66 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c61:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800c66:	83 c4 24             	add    $0x24,%esp
  800c69:	5b                   	pop    %ebx
  800c6a:	5d                   	pop    %ebp
  800c6b:	c3                   	ret    
  800c6c:	66 90                	xchg   %ax,%ax
  800c6e:	66 90                	xchg   %ax,%ax

00800c70 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	56                   	push   %esi
  800c74:	53                   	push   %ebx
  800c75:	83 ec 10             	sub    $0x10,%esp
  800c78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	89 04 24             	mov    %eax,(%esp)
  800c81:	e8 8a f7 ff ff       	call   800410 <fd2data>
  800c86:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c88:	c7 44 24 04 05 22 80 	movl   $0x802205,0x4(%esp)
  800c8f:	00 
  800c90:	89 1c 24             	mov    %ebx,(%esp)
  800c93:	e8 93 0c 00 00       	call   80192b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c98:	8b 46 04             	mov    0x4(%esi),%eax
  800c9b:	2b 06                	sub    (%esi),%eax
  800c9d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ca3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800caa:	00 00 00 
	stat->st_dev = &devpipe;
  800cad:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800cb4:	30 80 00 
	return 0;
}
  800cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
  800cbf:	5b                   	pop    %ebx
  800cc0:	5e                   	pop    %esi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	53                   	push   %ebx
  800cc7:	83 ec 14             	sub    $0x14,%esp
  800cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800ccd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cd8:	e8 62 f5 ff ff       	call   80023f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800cdd:	89 1c 24             	mov    %ebx,(%esp)
  800ce0:	e8 2b f7 ff ff       	call   800410 <fd2data>
  800ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cf0:	e8 4a f5 ff ff       	call   80023f <sys_page_unmap>
}
  800cf5:	83 c4 14             	add    $0x14,%esp
  800cf8:	5b                   	pop    %ebx
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	83 ec 2c             	sub    $0x2c,%esp
  800d04:	89 c6                	mov    %eax,%esi
  800d06:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d09:	a1 04 40 80 00       	mov    0x804004,%eax
  800d0e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d11:	89 34 24             	mov    %esi,(%esp)
  800d14:	e8 09 11 00 00       	call   801e22 <pageref>
  800d19:	89 c7                	mov    %eax,%edi
  800d1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d1e:	89 04 24             	mov    %eax,(%esp)
  800d21:	e8 fc 10 00 00       	call   801e22 <pageref>
  800d26:	39 c7                	cmp    %eax,%edi
  800d28:	0f 94 c2             	sete   %dl
  800d2b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d2e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d34:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d37:	39 fb                	cmp    %edi,%ebx
  800d39:	74 21                	je     800d5c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d3b:	84 d2                	test   %dl,%dl
  800d3d:	74 ca                	je     800d09 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d3f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d46:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d4a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d4e:	c7 04 24 0c 22 80 00 	movl   $0x80220c,(%esp)
  800d55:	e8 75 05 00 00       	call   8012cf <cprintf>
  800d5a:	eb ad                	jmp    800d09 <_pipeisclosed+0xe>
	}
}
  800d5c:	83 c4 2c             	add    $0x2c,%esp
  800d5f:	5b                   	pop    %ebx
  800d60:	5e                   	pop    %esi
  800d61:	5f                   	pop    %edi
  800d62:	5d                   	pop    %ebp
  800d63:	c3                   	ret    

00800d64 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	57                   	push   %edi
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 1c             	sub    $0x1c,%esp
  800d6d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d70:	89 34 24             	mov    %esi,(%esp)
  800d73:	e8 98 f6 ff ff       	call   800410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7c:	74 61                	je     800ddf <devpipe_write+0x7b>
  800d7e:	89 c3                	mov    %eax,%ebx
  800d80:	bf 00 00 00 00       	mov    $0x0,%edi
  800d85:	eb 4a                	jmp    800dd1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800d87:	89 da                	mov    %ebx,%edx
  800d89:	89 f0                	mov    %esi,%eax
  800d8b:	e8 6b ff ff ff       	call   800cfb <_pipeisclosed>
  800d90:	85 c0                	test   %eax,%eax
  800d92:	75 54                	jne    800de8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800d94:	e8 e0 f3 ff ff       	call   800179 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d99:	8b 43 04             	mov    0x4(%ebx),%eax
  800d9c:	8b 0b                	mov    (%ebx),%ecx
  800d9e:	8d 51 20             	lea    0x20(%ecx),%edx
  800da1:	39 d0                	cmp    %edx,%eax
  800da3:	73 e2                	jae    800d87 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800dac:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800daf:	99                   	cltd   
  800db0:	c1 ea 1b             	shr    $0x1b,%edx
  800db3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800db6:	83 e1 1f             	and    $0x1f,%ecx
  800db9:	29 d1                	sub    %edx,%ecx
  800dbb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800dbf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800dc3:	83 c0 01             	add    $0x1,%eax
  800dc6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dc9:	83 c7 01             	add    $0x1,%edi
  800dcc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800dcf:	74 13                	je     800de4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800dd1:	8b 43 04             	mov    0x4(%ebx),%eax
  800dd4:	8b 0b                	mov    (%ebx),%ecx
  800dd6:	8d 51 20             	lea    0x20(%ecx),%edx
  800dd9:	39 d0                	cmp    %edx,%eax
  800ddb:	73 aa                	jae    800d87 <devpipe_write+0x23>
  800ddd:	eb c6                	jmp    800da5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ddf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800de4:	89 f8                	mov    %edi,%eax
  800de6:	eb 05                	jmp    800ded <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800de8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800ded:	83 c4 1c             	add    $0x1c,%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 1c             	sub    $0x1c,%esp
  800dfe:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e01:	89 3c 24             	mov    %edi,(%esp)
  800e04:	e8 07 f6 ff ff       	call   800410 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0d:	74 54                	je     800e63 <devpipe_read+0x6e>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	be 00 00 00 00       	mov    $0x0,%esi
  800e16:	eb 3e                	jmp    800e56 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e18:	89 f0                	mov    %esi,%eax
  800e1a:	eb 55                	jmp    800e71 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e1c:	89 da                	mov    %ebx,%edx
  800e1e:	89 f8                	mov    %edi,%eax
  800e20:	e8 d6 fe ff ff       	call   800cfb <_pipeisclosed>
  800e25:	85 c0                	test   %eax,%eax
  800e27:	75 43                	jne    800e6c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e29:	e8 4b f3 ff ff       	call   800179 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e2e:	8b 03                	mov    (%ebx),%eax
  800e30:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e33:	74 e7                	je     800e1c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e35:	99                   	cltd   
  800e36:	c1 ea 1b             	shr    $0x1b,%edx
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 e0 1f             	and    $0x1f,%eax
  800e3e:	29 d0                	sub    %edx,%eax
  800e40:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e4b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e4e:	83 c6 01             	add    $0x1,%esi
  800e51:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e54:	74 12                	je     800e68 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e56:	8b 03                	mov    (%ebx),%eax
  800e58:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e5b:	75 d8                	jne    800e35 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e5d:	85 f6                	test   %esi,%esi
  800e5f:	75 b7                	jne    800e18 <devpipe_read+0x23>
  800e61:	eb b9                	jmp    800e1c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e63:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e68:	89 f0                	mov    %esi,%eax
  800e6a:	eb 05                	jmp    800e71 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e6c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e71:	83 c4 1c             	add    $0x1c,%esp
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5f                   	pop    %edi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800e81:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e84:	89 04 24             	mov    %eax,(%esp)
  800e87:	e8 9b f5 ff ff       	call   800427 <fd_alloc>
  800e8c:	89 c2                	mov    %eax,%edx
  800e8e:	85 d2                	test   %edx,%edx
  800e90:	0f 88 4d 01 00 00    	js     800fe3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e96:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e9d:	00 
  800e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ea5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800eac:	e8 e7 f2 ff ff       	call   800198 <sys_page_alloc>
  800eb1:	89 c2                	mov    %eax,%edx
  800eb3:	85 d2                	test   %edx,%edx
  800eb5:	0f 88 28 01 00 00    	js     800fe3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800ebb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ebe:	89 04 24             	mov    %eax,(%esp)
  800ec1:	e8 61 f5 ff ff       	call   800427 <fd_alloc>
  800ec6:	89 c3                	mov    %eax,%ebx
  800ec8:	85 c0                	test   %eax,%eax
  800eca:	0f 88 fe 00 00 00    	js     800fce <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ed0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ed7:	00 
  800ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ee6:	e8 ad f2 ff ff       	call   800198 <sys_page_alloc>
  800eeb:	89 c3                	mov    %eax,%ebx
  800eed:	85 c0                	test   %eax,%eax
  800eef:	0f 88 d9 00 00 00    	js     800fce <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ef8:	89 04 24             	mov    %eax,(%esp)
  800efb:	e8 10 f5 ff ff       	call   800410 <fd2data>
  800f00:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f02:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f09:	00 
  800f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f15:	e8 7e f2 ff ff       	call   800198 <sys_page_alloc>
  800f1a:	89 c3                	mov    %eax,%ebx
  800f1c:	85 c0                	test   %eax,%eax
  800f1e:	0f 88 97 00 00 00    	js     800fbb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f27:	89 04 24             	mov    %eax,(%esp)
  800f2a:	e8 e1 f4 ff ff       	call   800410 <fd2data>
  800f2f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f36:	00 
  800f37:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f3b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f42:	00 
  800f43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f4e:	e8 99 f2 ff ff       	call   8001ec <sys_page_map>
  800f53:	89 c3                	mov    %eax,%ebx
  800f55:	85 c0                	test   %eax,%eax
  800f57:	78 52                	js     800fab <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f59:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f62:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f67:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f6e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f77:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f7c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f86:	89 04 24             	mov    %eax,(%esp)
  800f89:	e8 72 f4 ff ff       	call   800400 <fd2num>
  800f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f91:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f96:	89 04 24             	mov    %eax,(%esp)
  800f99:	e8 62 f4 ff ff       	call   800400 <fd2num>
  800f9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fa1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa9:	eb 38                	jmp    800fe3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800fab:	89 74 24 04          	mov    %esi,0x4(%esp)
  800faf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fb6:	e8 84 f2 ff ff       	call   80023f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fc9:	e8 71 f2 ff ff       	call   80023f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fdc:	e8 5e f2 ff ff       	call   80023f <sys_page_unmap>
  800fe1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  800fe3:	83 c4 30             	add    $0x30,%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5d                   	pop    %ebp
  800fe9:	c3                   	ret    

00800fea <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	89 04 24             	mov    %eax,(%esp)
  800ffd:	e8 99 f4 ff ff       	call   80049b <fd_lookup>
  801002:	89 c2                	mov    %eax,%edx
  801004:	85 d2                	test   %edx,%edx
  801006:	78 15                	js     80101d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100b:	89 04 24             	mov    %eax,(%esp)
  80100e:	e8 fd f3 ff ff       	call   800410 <fd2data>
	return _pipeisclosed(fd, p);
  801013:	89 c2                	mov    %eax,%edx
  801015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801018:	e8 de fc ff ff       	call   800cfb <_pipeisclosed>
}
  80101d:	c9                   	leave  
  80101e:	c3                   	ret    
  80101f:	90                   	nop

00801020 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801030:	c7 44 24 04 24 22 80 	movl   $0x802224,0x4(%esp)
  801037:	00 
  801038:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103b:	89 04 24             	mov    %eax,(%esp)
  80103e:	e8 e8 08 00 00       	call   80192b <strcpy>
	return 0;
}
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	c9                   	leave  
  801049:	c3                   	ret    

0080104a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801056:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80105a:	74 4a                	je     8010a6 <devcons_write+0x5c>
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
  801061:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801066:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80106c:	8b 75 10             	mov    0x10(%ebp),%esi
  80106f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801071:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801074:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801079:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80107c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801080:	03 45 0c             	add    0xc(%ebp),%eax
  801083:	89 44 24 04          	mov    %eax,0x4(%esp)
  801087:	89 3c 24             	mov    %edi,(%esp)
  80108a:	e8 97 0a 00 00       	call   801b26 <memmove>
		sys_cputs(buf, m);
  80108f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801093:	89 3c 24             	mov    %edi,(%esp)
  801096:	e8 30 f0 ff ff       	call   8000cb <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80109b:	01 f3                	add    %esi,%ebx
  80109d:	89 d8                	mov    %ebx,%eax
  80109f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8010a2:	72 c8                	jb     80106c <devcons_write+0x22>
  8010a4:	eb 05                	jmp    8010ab <devcons_write+0x61>
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8010ab:	89 d8                	mov    %ebx,%eax
  8010ad:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8010b3:	5b                   	pop    %ebx
  8010b4:	5e                   	pop    %esi
  8010b5:	5f                   	pop    %edi
  8010b6:	5d                   	pop    %ebp
  8010b7:	c3                   	ret    

008010b8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8010be:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8010c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010c7:	75 07                	jne    8010d0 <devcons_read+0x18>
  8010c9:	eb 28                	jmp    8010f3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8010cb:	e8 a9 f0 ff ff       	call   800179 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010d0:	e8 14 f0 ff ff       	call   8000e9 <sys_cgetc>
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	74 f2                	je     8010cb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 16                	js     8010f3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010dd:	83 f8 04             	cmp    $0x4,%eax
  8010e0:	74 0c                	je     8010ee <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8010e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e5:	88 02                	mov    %al,(%edx)
	return 1;
  8010e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010ec:	eb 05                	jmp    8010f3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8010ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801101:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801108:	00 
  801109:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80110c:	89 04 24             	mov    %eax,(%esp)
  80110f:	e8 b7 ef ff ff       	call   8000cb <sys_cputs>
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <getchar>:

int
getchar(void)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80111c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801123:	00 
  801124:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801132:	e8 0f f6 ff ff       	call   800746 <read>
	if (r < 0)
  801137:	85 c0                	test   %eax,%eax
  801139:	78 0f                	js     80114a <getchar+0x34>
		return r;
	if (r < 1)
  80113b:	85 c0                	test   %eax,%eax
  80113d:	7e 06                	jle    801145 <getchar+0x2f>
		return -E_EOF;
	return c;
  80113f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801143:	eb 05                	jmp    80114a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801145:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80114a:	c9                   	leave  
  80114b:	c3                   	ret    

0080114c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801152:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801155:	89 44 24 04          	mov    %eax,0x4(%esp)
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	89 04 24             	mov    %eax,(%esp)
  80115f:	e8 37 f3 ff ff       	call   80049b <fd_lookup>
  801164:	85 c0                	test   %eax,%eax
  801166:	78 11                	js     801179 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801171:	39 10                	cmp    %edx,(%eax)
  801173:	0f 94 c0             	sete   %al
  801176:	0f b6 c0             	movzbl %al,%eax
}
  801179:	c9                   	leave  
  80117a:	c3                   	ret    

0080117b <opencons>:

int
opencons(void)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801181:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801184:	89 04 24             	mov    %eax,(%esp)
  801187:	e8 9b f2 ff ff       	call   800427 <fd_alloc>
		return r;
  80118c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80118e:	85 c0                	test   %eax,%eax
  801190:	78 40                	js     8011d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801192:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801199:	00 
  80119a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a8:	e8 eb ef ff ff       	call   800198 <sys_page_alloc>
		return r;
  8011ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011af:	85 c0                	test   %eax,%eax
  8011b1:	78 1f                	js     8011d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8011b3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8011be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8011c8:	89 04 24             	mov    %eax,(%esp)
  8011cb:	e8 30 f2 ff ff       	call   800400 <fd2num>
  8011d0:	89 c2                	mov    %eax,%edx
}
  8011d2:	89 d0                	mov    %edx,%eax
  8011d4:	c9                   	leave  
  8011d5:	c3                   	ret    

008011d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011d6:	55                   	push   %ebp
  8011d7:	89 e5                	mov    %esp,%ebp
  8011d9:	56                   	push   %esi
  8011da:	53                   	push   %ebx
  8011db:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011e1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8011e7:	e8 6e ef ff ff       	call   80015a <sys_getenvid>
  8011ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ef:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011fa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8011fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801202:	c7 04 24 30 22 80 00 	movl   $0x802230,(%esp)
  801209:	e8 c1 00 00 00       	call   8012cf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80120e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	89 04 24             	mov    %eax,(%esp)
  801218:	e8 51 00 00 00       	call   80126e <vcprintf>
	cprintf("\n");
  80121d:	c7 04 24 1d 22 80 00 	movl   $0x80221d,(%esp)
  801224:	e8 a6 00 00 00       	call   8012cf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801229:	cc                   	int3   
  80122a:	eb fd                	jmp    801229 <_panic+0x53>

0080122c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	53                   	push   %ebx
  801230:	83 ec 14             	sub    $0x14,%esp
  801233:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801236:	8b 13                	mov    (%ebx),%edx
  801238:	8d 42 01             	lea    0x1(%edx),%eax
  80123b:	89 03                	mov    %eax,(%ebx)
  80123d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801240:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801244:	3d ff 00 00 00       	cmp    $0xff,%eax
  801249:	75 19                	jne    801264 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80124b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801252:	00 
  801253:	8d 43 08             	lea    0x8(%ebx),%eax
  801256:	89 04 24             	mov    %eax,(%esp)
  801259:	e8 6d ee ff ff       	call   8000cb <sys_cputs>
		b->idx = 0;
  80125e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801264:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801268:	83 c4 14             	add    $0x14,%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5d                   	pop    %ebp
  80126d:	c3                   	ret    

0080126e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801277:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80127e:	00 00 00 
	b.cnt = 0;
  801281:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801288:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	89 44 24 08          	mov    %eax,0x8(%esp)
  801299:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80129f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a3:	c7 04 24 2c 12 80 00 	movl   $0x80122c,(%esp)
  8012aa:	e8 b5 01 00 00       	call   801464 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8012af:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8012b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012b9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 04 ee ff ff       	call   8000cb <sys_cputs>

	return b.cnt;
}
  8012c7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8012cd:	c9                   	leave  
  8012ce:	c3                   	ret    

008012cf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8012cf:	55                   	push   %ebp
  8012d0:	89 e5                	mov    %esp,%ebp
  8012d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012d5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012df:	89 04 24             	mov    %eax,(%esp)
  8012e2:	e8 87 ff ff ff       	call   80126e <vcprintf>
	va_end(ap);

	return cnt;
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    
  8012e9:	66 90                	xchg   %ax,%ax
  8012eb:	66 90                	xchg   %ax,%ax
  8012ed:	66 90                	xchg   %ax,%ax
  8012ef:	90                   	nop

008012f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	57                   	push   %edi
  8012f4:	56                   	push   %esi
  8012f5:	53                   	push   %ebx
  8012f6:	83 ec 3c             	sub    $0x3c,%esp
  8012f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012fc:	89 d7                	mov    %edx,%edi
  8012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801301:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801304:	8b 75 0c             	mov    0xc(%ebp),%esi
  801307:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80130a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80130d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801312:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801315:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801318:	39 f1                	cmp    %esi,%ecx
  80131a:	72 14                	jb     801330 <printnum+0x40>
  80131c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80131f:	76 0f                	jbe    801330 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801321:	8b 45 14             	mov    0x14(%ebp),%eax
  801324:	8d 70 ff             	lea    -0x1(%eax),%esi
  801327:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80132a:	85 f6                	test   %esi,%esi
  80132c:	7f 60                	jg     80138e <printnum+0x9e>
  80132e:	eb 72                	jmp    8013a2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801330:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801333:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801337:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80133a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80133d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801341:	89 44 24 08          	mov    %eax,0x8(%esp)
  801345:	8b 44 24 08          	mov    0x8(%esp),%eax
  801349:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	89 d6                	mov    %edx,%esi
  801351:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801354:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801357:	89 54 24 08          	mov    %edx,0x8(%esp)
  80135b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80135f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801362:	89 04 24             	mov    %eax,(%esp)
  801365:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136c:	e8 ef 0a 00 00       	call   801e60 <__udivdi3>
  801371:	89 d9                	mov    %ebx,%ecx
  801373:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801377:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80137b:	89 04 24             	mov    %eax,(%esp)
  80137e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801382:	89 fa                	mov    %edi,%edx
  801384:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801387:	e8 64 ff ff ff       	call   8012f0 <printnum>
  80138c:	eb 14                	jmp    8013a2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80138e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801392:	8b 45 18             	mov    0x18(%ebp),%eax
  801395:	89 04 24             	mov    %eax,(%esp)
  801398:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80139a:	83 ee 01             	sub    $0x1,%esi
  80139d:	75 ef                	jne    80138e <printnum+0x9e>
  80139f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013a2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013a6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8013aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c5:	e8 c6 0b 00 00       	call   801f90 <__umoddi3>
  8013ca:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013ce:	0f be 80 53 22 80 00 	movsbl 0x802253(%eax),%eax
  8013d5:	89 04 24             	mov    %eax,(%esp)
  8013d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013db:	ff d0                	call   *%eax
}
  8013dd:	83 c4 3c             	add    $0x3c,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5e                   	pop    %esi
  8013e2:	5f                   	pop    %edi
  8013e3:	5d                   	pop    %ebp
  8013e4:	c3                   	ret    

008013e5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013e8:	83 fa 01             	cmp    $0x1,%edx
  8013eb:	7e 0e                	jle    8013fb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8013ed:	8b 10                	mov    (%eax),%edx
  8013ef:	8d 4a 08             	lea    0x8(%edx),%ecx
  8013f2:	89 08                	mov    %ecx,(%eax)
  8013f4:	8b 02                	mov    (%edx),%eax
  8013f6:	8b 52 04             	mov    0x4(%edx),%edx
  8013f9:	eb 22                	jmp    80141d <getuint+0x38>
	else if (lflag)
  8013fb:	85 d2                	test   %edx,%edx
  8013fd:	74 10                	je     80140f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8013ff:	8b 10                	mov    (%eax),%edx
  801401:	8d 4a 04             	lea    0x4(%edx),%ecx
  801404:	89 08                	mov    %ecx,(%eax)
  801406:	8b 02                	mov    (%edx),%eax
  801408:	ba 00 00 00 00       	mov    $0x0,%edx
  80140d:	eb 0e                	jmp    80141d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80140f:	8b 10                	mov    (%eax),%edx
  801411:	8d 4a 04             	lea    0x4(%edx),%ecx
  801414:	89 08                	mov    %ecx,(%eax)
  801416:	8b 02                	mov    (%edx),%eax
  801418:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801425:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801429:	8b 10                	mov    (%eax),%edx
  80142b:	3b 50 04             	cmp    0x4(%eax),%edx
  80142e:	73 0a                	jae    80143a <sprintputch+0x1b>
		*b->buf++ = ch;
  801430:	8d 4a 01             	lea    0x1(%edx),%ecx
  801433:	89 08                	mov    %ecx,(%eax)
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	88 02                	mov    %al,(%edx)
}
  80143a:	5d                   	pop    %ebp
  80143b:	c3                   	ret    

0080143c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801442:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801445:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801449:	8b 45 10             	mov    0x10(%ebp),%eax
  80144c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801450:	8b 45 0c             	mov    0xc(%ebp),%eax
  801453:	89 44 24 04          	mov    %eax,0x4(%esp)
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	89 04 24             	mov    %eax,(%esp)
  80145d:	e8 02 00 00 00       	call   801464 <vprintfmt>
	va_end(ap);
}
  801462:	c9                   	leave  
  801463:	c3                   	ret    

00801464 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	57                   	push   %edi
  801468:	56                   	push   %esi
  801469:	53                   	push   %ebx
  80146a:	83 ec 3c             	sub    $0x3c,%esp
  80146d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801470:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801473:	eb 18                	jmp    80148d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801475:	85 c0                	test   %eax,%eax
  801477:	0f 84 c3 03 00 00    	je     801840 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80147d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801481:	89 04 24             	mov    %eax,(%esp)
  801484:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801487:	89 f3                	mov    %esi,%ebx
  801489:	eb 02                	jmp    80148d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80148b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80148d:	8d 73 01             	lea    0x1(%ebx),%esi
  801490:	0f b6 03             	movzbl (%ebx),%eax
  801493:	83 f8 25             	cmp    $0x25,%eax
  801496:	75 dd                	jne    801475 <vprintfmt+0x11>
  801498:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80149c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8014a3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8014aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b6:	eb 1d                	jmp    8014d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014b8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8014ba:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8014be:	eb 15                	jmp    8014d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014c0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014c2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8014c6:	eb 0d                	jmp    8014d5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8014c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014ce:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014d5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014d8:	0f b6 06             	movzbl (%esi),%eax
  8014db:	0f b6 c8             	movzbl %al,%ecx
  8014de:	83 e8 23             	sub    $0x23,%eax
  8014e1:	3c 55                	cmp    $0x55,%al
  8014e3:	0f 87 2f 03 00 00    	ja     801818 <vprintfmt+0x3b4>
  8014e9:	0f b6 c0             	movzbl %al,%eax
  8014ec:	ff 24 85 a0 23 80 00 	jmp    *0x8023a0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8014f3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8014f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8014f9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8014fd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801500:	83 f9 09             	cmp    $0x9,%ecx
  801503:	77 50                	ja     801555 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801505:	89 de                	mov    %ebx,%esi
  801507:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80150a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80150d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801510:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801514:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801517:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80151a:	83 fb 09             	cmp    $0x9,%ebx
  80151d:	76 eb                	jbe    80150a <vprintfmt+0xa6>
  80151f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801522:	eb 33                	jmp    801557 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801524:	8b 45 14             	mov    0x14(%ebp),%eax
  801527:	8d 48 04             	lea    0x4(%eax),%ecx
  80152a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801532:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801534:	eb 21                	jmp    801557 <vprintfmt+0xf3>
  801536:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801539:	85 c9                	test   %ecx,%ecx
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	0f 49 c1             	cmovns %ecx,%eax
  801543:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801546:	89 de                	mov    %ebx,%esi
  801548:	eb 8b                	jmp    8014d5 <vprintfmt+0x71>
  80154a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80154c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801553:	eb 80                	jmp    8014d5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801555:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801557:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80155b:	0f 89 74 ff ff ff    	jns    8014d5 <vprintfmt+0x71>
  801561:	e9 62 ff ff ff       	jmp    8014c8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801566:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801569:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80156b:	e9 65 ff ff ff       	jmp    8014d5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801570:	8b 45 14             	mov    0x14(%ebp),%eax
  801573:	8d 50 04             	lea    0x4(%eax),%edx
  801576:	89 55 14             	mov    %edx,0x14(%ebp)
  801579:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80157d:	8b 00                	mov    (%eax),%eax
  80157f:	89 04 24             	mov    %eax,(%esp)
  801582:	ff 55 08             	call   *0x8(%ebp)
			break;
  801585:	e9 03 ff ff ff       	jmp    80148d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80158a:	8b 45 14             	mov    0x14(%ebp),%eax
  80158d:	8d 50 04             	lea    0x4(%eax),%edx
  801590:	89 55 14             	mov    %edx,0x14(%ebp)
  801593:	8b 00                	mov    (%eax),%eax
  801595:	99                   	cltd   
  801596:	31 d0                	xor    %edx,%eax
  801598:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80159a:	83 f8 0f             	cmp    $0xf,%eax
  80159d:	7f 0b                	jg     8015aa <vprintfmt+0x146>
  80159f:	8b 14 85 00 25 80 00 	mov    0x802500(,%eax,4),%edx
  8015a6:	85 d2                	test   %edx,%edx
  8015a8:	75 20                	jne    8015ca <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8015aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ae:	c7 44 24 08 6b 22 80 	movl   $0x80226b,0x8(%esp)
  8015b5:	00 
  8015b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	89 04 24             	mov    %eax,(%esp)
  8015c0:	e8 77 fe ff ff       	call   80143c <printfmt>
  8015c5:	e9 c3 fe ff ff       	jmp    80148d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8015ca:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ce:	c7 44 24 08 eb 21 80 	movl   $0x8021eb,0x8(%esp)
  8015d5:	00 
  8015d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 04 24             	mov    %eax,(%esp)
  8015e0:	e8 57 fe ff ff       	call   80143c <printfmt>
  8015e5:	e9 a3 fe ff ff       	jmp    80148d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ea:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8015ed:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f3:	8d 50 04             	lea    0x4(%eax),%edx
  8015f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015f9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	ba 64 22 80 00       	mov    $0x802264,%edx
  801602:	0f 45 d0             	cmovne %eax,%edx
  801605:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801608:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80160c:	74 04                	je     801612 <vprintfmt+0x1ae>
  80160e:	85 f6                	test   %esi,%esi
  801610:	7f 19                	jg     80162b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801612:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801615:	8d 70 01             	lea    0x1(%eax),%esi
  801618:	0f b6 10             	movzbl (%eax),%edx
  80161b:	0f be c2             	movsbl %dl,%eax
  80161e:	85 c0                	test   %eax,%eax
  801620:	0f 85 95 00 00 00    	jne    8016bb <vprintfmt+0x257>
  801626:	e9 85 00 00 00       	jmp    8016b0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80162b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80162f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801632:	89 04 24             	mov    %eax,(%esp)
  801635:	e8 b8 02 00 00       	call   8018f2 <strnlen>
  80163a:	29 c6                	sub    %eax,%esi
  80163c:	89 f0                	mov    %esi,%eax
  80163e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801641:	85 f6                	test   %esi,%esi
  801643:	7e cd                	jle    801612 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801645:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801649:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801652:	89 34 24             	mov    %esi,(%esp)
  801655:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801658:	83 eb 01             	sub    $0x1,%ebx
  80165b:	75 f1                	jne    80164e <vprintfmt+0x1ea>
  80165d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801660:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801663:	eb ad                	jmp    801612 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801665:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801669:	74 1e                	je     801689 <vprintfmt+0x225>
  80166b:	0f be d2             	movsbl %dl,%edx
  80166e:	83 ea 20             	sub    $0x20,%edx
  801671:	83 fa 5e             	cmp    $0x5e,%edx
  801674:	76 13                	jbe    801689 <vprintfmt+0x225>
					putch('?', putdat);
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801684:	ff 55 08             	call   *0x8(%ebp)
  801687:	eb 0d                	jmp    801696 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80168c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801690:	89 04 24             	mov    %eax,(%esp)
  801693:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801696:	83 ef 01             	sub    $0x1,%edi
  801699:	83 c6 01             	add    $0x1,%esi
  80169c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8016a0:	0f be c2             	movsbl %dl,%eax
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	75 20                	jne    8016c7 <vprintfmt+0x263>
  8016a7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016aa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016b4:	7f 25                	jg     8016db <vprintfmt+0x277>
  8016b6:	e9 d2 fd ff ff       	jmp    80148d <vprintfmt+0x29>
  8016bb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8016be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016c1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016c4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016c7:	85 db                	test   %ebx,%ebx
  8016c9:	78 9a                	js     801665 <vprintfmt+0x201>
  8016cb:	83 eb 01             	sub    $0x1,%ebx
  8016ce:	79 95                	jns    801665 <vprintfmt+0x201>
  8016d0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016d9:	eb d5                	jmp    8016b0 <vprintfmt+0x24c>
  8016db:	8b 75 08             	mov    0x8(%ebp),%esi
  8016de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016e1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8016e4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8016ef:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016f1:	83 eb 01             	sub    $0x1,%ebx
  8016f4:	75 ee                	jne    8016e4 <vprintfmt+0x280>
  8016f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016f9:	e9 8f fd ff ff       	jmp    80148d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8016fe:	83 fa 01             	cmp    $0x1,%edx
  801701:	7e 16                	jle    801719 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801703:	8b 45 14             	mov    0x14(%ebp),%eax
  801706:	8d 50 08             	lea    0x8(%eax),%edx
  801709:	89 55 14             	mov    %edx,0x14(%ebp)
  80170c:	8b 50 04             	mov    0x4(%eax),%edx
  80170f:	8b 00                	mov    (%eax),%eax
  801711:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801714:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801717:	eb 32                	jmp    80174b <vprintfmt+0x2e7>
	else if (lflag)
  801719:	85 d2                	test   %edx,%edx
  80171b:	74 18                	je     801735 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80171d:	8b 45 14             	mov    0x14(%ebp),%eax
  801720:	8d 50 04             	lea    0x4(%eax),%edx
  801723:	89 55 14             	mov    %edx,0x14(%ebp)
  801726:	8b 30                	mov    (%eax),%esi
  801728:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80172b:	89 f0                	mov    %esi,%eax
  80172d:	c1 f8 1f             	sar    $0x1f,%eax
  801730:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801733:	eb 16                	jmp    80174b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801735:	8b 45 14             	mov    0x14(%ebp),%eax
  801738:	8d 50 04             	lea    0x4(%eax),%edx
  80173b:	89 55 14             	mov    %edx,0x14(%ebp)
  80173e:	8b 30                	mov    (%eax),%esi
  801740:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801743:	89 f0                	mov    %esi,%eax
  801745:	c1 f8 1f             	sar    $0x1f,%eax
  801748:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80174b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80174e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801751:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801756:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80175a:	0f 89 80 00 00 00    	jns    8017e0 <vprintfmt+0x37c>
				putch('-', putdat);
  801760:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801764:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80176b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80176e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801771:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801774:	f7 d8                	neg    %eax
  801776:	83 d2 00             	adc    $0x0,%edx
  801779:	f7 da                	neg    %edx
			}
			base = 10;
  80177b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801780:	eb 5e                	jmp    8017e0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801782:	8d 45 14             	lea    0x14(%ebp),%eax
  801785:	e8 5b fc ff ff       	call   8013e5 <getuint>
			base = 10;
  80178a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80178f:	eb 4f                	jmp    8017e0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801791:	8d 45 14             	lea    0x14(%ebp),%eax
  801794:	e8 4c fc ff ff       	call   8013e5 <getuint>
			base = 8;
  801799:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80179e:	eb 40                	jmp    8017e0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8017a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017a4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8017ab:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8017ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017b2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8017b9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8017bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017bf:	8d 50 04             	lea    0x4(%eax),%edx
  8017c2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8017cc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017d1:	eb 0d                	jmp    8017e0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017d6:	e8 0a fc ff ff       	call   8013e5 <getuint>
			base = 16;
  8017db:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017e0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8017e4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8017e8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017f3:	89 04 24             	mov    %eax,(%esp)
  8017f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017fa:	89 fa                	mov    %edi,%edx
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	e8 ec fa ff ff       	call   8012f0 <printnum>
			break;
  801804:	e9 84 fc ff ff       	jmp    80148d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801809:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80180d:	89 0c 24             	mov    %ecx,(%esp)
  801810:	ff 55 08             	call   *0x8(%ebp)
			break;
  801813:	e9 75 fc ff ff       	jmp    80148d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801818:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80181c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801823:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801826:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80182a:	0f 84 5b fc ff ff    	je     80148b <vprintfmt+0x27>
  801830:	89 f3                	mov    %esi,%ebx
  801832:	83 eb 01             	sub    $0x1,%ebx
  801835:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801839:	75 f7                	jne    801832 <vprintfmt+0x3ce>
  80183b:	e9 4d fc ff ff       	jmp    80148d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801840:	83 c4 3c             	add    $0x3c,%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5f                   	pop    %edi
  801846:	5d                   	pop    %ebp
  801847:	c3                   	ret    

00801848 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	83 ec 28             	sub    $0x28,%esp
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801854:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801857:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80185b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80185e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801865:	85 c0                	test   %eax,%eax
  801867:	74 30                	je     801899 <vsnprintf+0x51>
  801869:	85 d2                	test   %edx,%edx
  80186b:	7e 2c                	jle    801899 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80186d:	8b 45 14             	mov    0x14(%ebp),%eax
  801870:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801874:	8b 45 10             	mov    0x10(%ebp),%eax
  801877:	89 44 24 08          	mov    %eax,0x8(%esp)
  80187b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	c7 04 24 1f 14 80 00 	movl   $0x80141f,(%esp)
  801889:	e8 d6 fb ff ff       	call   801464 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80188e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801891:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	eb 05                	jmp    80189e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801899:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018a6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8018a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 82 ff ff ff       	call   801848 <vsnprintf>
	va_end(ap);

	return rc;
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    
  8018c8:	66 90                	xchg   %ax,%ax
  8018ca:	66 90                	xchg   %ax,%ax
  8018cc:	66 90                	xchg   %ax,%ax
  8018ce:	66 90                	xchg   %ax,%ax

008018d0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
  8018d3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018d6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018d9:	74 10                	je     8018eb <strlen+0x1b>
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8018e0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8018e7:	75 f7                	jne    8018e0 <strlen+0x10>
  8018e9:	eb 05                	jmp    8018f0 <strlen+0x20>
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	53                   	push   %ebx
  8018f6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018fc:	85 c9                	test   %ecx,%ecx
  8018fe:	74 1c                	je     80191c <strnlen+0x2a>
  801900:	80 3b 00             	cmpb   $0x0,(%ebx)
  801903:	74 1e                	je     801923 <strnlen+0x31>
  801905:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80190a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80190c:	39 ca                	cmp    %ecx,%edx
  80190e:	74 18                	je     801928 <strnlen+0x36>
  801910:	83 c2 01             	add    $0x1,%edx
  801913:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801918:	75 f0                	jne    80190a <strnlen+0x18>
  80191a:	eb 0c                	jmp    801928 <strnlen+0x36>
  80191c:	b8 00 00 00 00       	mov    $0x0,%eax
  801921:	eb 05                	jmp    801928 <strnlen+0x36>
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801928:	5b                   	pop    %ebx
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801935:	89 c2                	mov    %eax,%edx
  801937:	83 c2 01             	add    $0x1,%edx
  80193a:	83 c1 01             	add    $0x1,%ecx
  80193d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801941:	88 5a ff             	mov    %bl,-0x1(%edx)
  801944:	84 db                	test   %bl,%bl
  801946:	75 ef                	jne    801937 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801948:	5b                   	pop    %ebx
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	83 ec 08             	sub    $0x8,%esp
  801952:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801955:	89 1c 24             	mov    %ebx,(%esp)
  801958:	e8 73 ff ff ff       	call   8018d0 <strlen>
	strcpy(dst + len, src);
  80195d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801960:	89 54 24 04          	mov    %edx,0x4(%esp)
  801964:	01 d8                	add    %ebx,%eax
  801966:	89 04 24             	mov    %eax,(%esp)
  801969:	e8 bd ff ff ff       	call   80192b <strcpy>
	return dst;
}
  80196e:	89 d8                	mov    %ebx,%eax
  801970:	83 c4 08             	add    $0x8,%esp
  801973:	5b                   	pop    %ebx
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	56                   	push   %esi
  80197a:	53                   	push   %ebx
  80197b:	8b 75 08             	mov    0x8(%ebp),%esi
  80197e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801981:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801984:	85 db                	test   %ebx,%ebx
  801986:	74 17                	je     80199f <strncpy+0x29>
  801988:	01 f3                	add    %esi,%ebx
  80198a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80198c:	83 c1 01             	add    $0x1,%ecx
  80198f:	0f b6 02             	movzbl (%edx),%eax
  801992:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801995:	80 3a 01             	cmpb   $0x1,(%edx)
  801998:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80199b:	39 d9                	cmp    %ebx,%ecx
  80199d:	75 ed                	jne    80198c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80199f:	89 f0                	mov    %esi,%eax
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	57                   	push   %edi
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
  8019ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019b1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019b4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019b6:	85 f6                	test   %esi,%esi
  8019b8:	74 34                	je     8019ee <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8019ba:	83 fe 01             	cmp    $0x1,%esi
  8019bd:	74 26                	je     8019e5 <strlcpy+0x40>
  8019bf:	0f b6 0b             	movzbl (%ebx),%ecx
  8019c2:	84 c9                	test   %cl,%cl
  8019c4:	74 23                	je     8019e9 <strlcpy+0x44>
  8019c6:	83 ee 02             	sub    $0x2,%esi
  8019c9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8019ce:	83 c0 01             	add    $0x1,%eax
  8019d1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019d4:	39 f2                	cmp    %esi,%edx
  8019d6:	74 13                	je     8019eb <strlcpy+0x46>
  8019d8:	83 c2 01             	add    $0x1,%edx
  8019db:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019df:	84 c9                	test   %cl,%cl
  8019e1:	75 eb                	jne    8019ce <strlcpy+0x29>
  8019e3:	eb 06                	jmp    8019eb <strlcpy+0x46>
  8019e5:	89 f8                	mov    %edi,%eax
  8019e7:	eb 02                	jmp    8019eb <strlcpy+0x46>
  8019e9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8019eb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019ee:	29 f8                	sub    %edi,%eax
}
  8019f0:	5b                   	pop    %ebx
  8019f1:	5e                   	pop    %esi
  8019f2:	5f                   	pop    %edi
  8019f3:	5d                   	pop    %ebp
  8019f4:	c3                   	ret    

008019f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8019fe:	0f b6 01             	movzbl (%ecx),%eax
  801a01:	84 c0                	test   %al,%al
  801a03:	74 15                	je     801a1a <strcmp+0x25>
  801a05:	3a 02                	cmp    (%edx),%al
  801a07:	75 11                	jne    801a1a <strcmp+0x25>
		p++, q++;
  801a09:	83 c1 01             	add    $0x1,%ecx
  801a0c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a0f:	0f b6 01             	movzbl (%ecx),%eax
  801a12:	84 c0                	test   %al,%al
  801a14:	74 04                	je     801a1a <strcmp+0x25>
  801a16:	3a 02                	cmp    (%edx),%al
  801a18:	74 ef                	je     801a09 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1a:	0f b6 c0             	movzbl %al,%eax
  801a1d:	0f b6 12             	movzbl (%edx),%edx
  801a20:	29 d0                	sub    %edx,%eax
}
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	56                   	push   %esi
  801a28:	53                   	push   %ebx
  801a29:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a32:	85 f6                	test   %esi,%esi
  801a34:	74 29                	je     801a5f <strncmp+0x3b>
  801a36:	0f b6 03             	movzbl (%ebx),%eax
  801a39:	84 c0                	test   %al,%al
  801a3b:	74 30                	je     801a6d <strncmp+0x49>
  801a3d:	3a 02                	cmp    (%edx),%al
  801a3f:	75 2c                	jne    801a6d <strncmp+0x49>
  801a41:	8d 43 01             	lea    0x1(%ebx),%eax
  801a44:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a46:	89 c3                	mov    %eax,%ebx
  801a48:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a4b:	39 f0                	cmp    %esi,%eax
  801a4d:	74 17                	je     801a66 <strncmp+0x42>
  801a4f:	0f b6 08             	movzbl (%eax),%ecx
  801a52:	84 c9                	test   %cl,%cl
  801a54:	74 17                	je     801a6d <strncmp+0x49>
  801a56:	83 c0 01             	add    $0x1,%eax
  801a59:	3a 0a                	cmp    (%edx),%cl
  801a5b:	74 e9                	je     801a46 <strncmp+0x22>
  801a5d:	eb 0e                	jmp    801a6d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a64:	eb 0f                	jmp    801a75 <strncmp+0x51>
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6b:	eb 08                	jmp    801a75 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a6d:	0f b6 03             	movzbl (%ebx),%eax
  801a70:	0f b6 12             	movzbl (%edx),%edx
  801a73:	29 d0                	sub    %edx,%eax
}
  801a75:	5b                   	pop    %ebx
  801a76:	5e                   	pop    %esi
  801a77:	5d                   	pop    %ebp
  801a78:	c3                   	ret    

00801a79 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	53                   	push   %ebx
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a83:	0f b6 18             	movzbl (%eax),%ebx
  801a86:	84 db                	test   %bl,%bl
  801a88:	74 1d                	je     801aa7 <strchr+0x2e>
  801a8a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a8c:	38 d3                	cmp    %dl,%bl
  801a8e:	75 06                	jne    801a96 <strchr+0x1d>
  801a90:	eb 1a                	jmp    801aac <strchr+0x33>
  801a92:	38 ca                	cmp    %cl,%dl
  801a94:	74 16                	je     801aac <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a96:	83 c0 01             	add    $0x1,%eax
  801a99:	0f b6 10             	movzbl (%eax),%edx
  801a9c:	84 d2                	test   %dl,%dl
  801a9e:	75 f2                	jne    801a92 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa5:	eb 05                	jmp    801aac <strchr+0x33>
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aac:	5b                   	pop    %ebx
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    

00801aaf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801ab9:	0f b6 18             	movzbl (%eax),%ebx
  801abc:	84 db                	test   %bl,%bl
  801abe:	74 16                	je     801ad6 <strfind+0x27>
  801ac0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801ac2:	38 d3                	cmp    %dl,%bl
  801ac4:	75 06                	jne    801acc <strfind+0x1d>
  801ac6:	eb 0e                	jmp    801ad6 <strfind+0x27>
  801ac8:	38 ca                	cmp    %cl,%dl
  801aca:	74 0a                	je     801ad6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801acc:	83 c0 01             	add    $0x1,%eax
  801acf:	0f b6 10             	movzbl (%eax),%edx
  801ad2:	84 d2                	test   %dl,%dl
  801ad4:	75 f2                	jne    801ac8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801ad6:	5b                   	pop    %ebx
  801ad7:	5d                   	pop    %ebp
  801ad8:	c3                   	ret    

00801ad9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	57                   	push   %edi
  801add:	56                   	push   %esi
  801ade:	53                   	push   %ebx
  801adf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ae2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ae5:	85 c9                	test   %ecx,%ecx
  801ae7:	74 36                	je     801b1f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ae9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801aef:	75 28                	jne    801b19 <memset+0x40>
  801af1:	f6 c1 03             	test   $0x3,%cl
  801af4:	75 23                	jne    801b19 <memset+0x40>
		c &= 0xFF;
  801af6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801afa:	89 d3                	mov    %edx,%ebx
  801afc:	c1 e3 08             	shl    $0x8,%ebx
  801aff:	89 d6                	mov    %edx,%esi
  801b01:	c1 e6 18             	shl    $0x18,%esi
  801b04:	89 d0                	mov    %edx,%eax
  801b06:	c1 e0 10             	shl    $0x10,%eax
  801b09:	09 f0                	or     %esi,%eax
  801b0b:	09 c2                	or     %eax,%edx
  801b0d:	89 d0                	mov    %edx,%eax
  801b0f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b11:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b14:	fc                   	cld    
  801b15:	f3 ab                	rep stos %eax,%es:(%edi)
  801b17:	eb 06                	jmp    801b1f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1c:	fc                   	cld    
  801b1d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b1f:	89 f8                	mov    %edi,%eax
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
  801b29:	57                   	push   %edi
  801b2a:	56                   	push   %esi
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b31:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b34:	39 c6                	cmp    %eax,%esi
  801b36:	73 35                	jae    801b6d <memmove+0x47>
  801b38:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b3b:	39 d0                	cmp    %edx,%eax
  801b3d:	73 2e                	jae    801b6d <memmove+0x47>
		s += n;
		d += n;
  801b3f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b42:	89 d6                	mov    %edx,%esi
  801b44:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b4c:	75 13                	jne    801b61 <memmove+0x3b>
  801b4e:	f6 c1 03             	test   $0x3,%cl
  801b51:	75 0e                	jne    801b61 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b53:	83 ef 04             	sub    $0x4,%edi
  801b56:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b59:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b5c:	fd                   	std    
  801b5d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b5f:	eb 09                	jmp    801b6a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b61:	83 ef 01             	sub    $0x1,%edi
  801b64:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b67:	fd                   	std    
  801b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b6a:	fc                   	cld    
  801b6b:	eb 1d                	jmp    801b8a <memmove+0x64>
  801b6d:	89 f2                	mov    %esi,%edx
  801b6f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b71:	f6 c2 03             	test   $0x3,%dl
  801b74:	75 0f                	jne    801b85 <memmove+0x5f>
  801b76:	f6 c1 03             	test   $0x3,%cl
  801b79:	75 0a                	jne    801b85 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b7b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b7e:	89 c7                	mov    %eax,%edi
  801b80:	fc                   	cld    
  801b81:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b83:	eb 05                	jmp    801b8a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b85:	89 c7                	mov    %eax,%edi
  801b87:	fc                   	cld    
  801b88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b8a:	5e                   	pop    %esi
  801b8b:	5f                   	pop    %edi
  801b8c:	5d                   	pop    %ebp
  801b8d:	c3                   	ret    

00801b8e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801b94:	8b 45 10             	mov    0x10(%ebp),%eax
  801b97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	89 04 24             	mov    %eax,(%esp)
  801ba8:	e8 79 ff ff ff       	call   801b26 <memmove>
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	57                   	push   %edi
  801bb3:	56                   	push   %esi
  801bb4:	53                   	push   %ebx
  801bb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bb8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bbb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bbe:	8d 78 ff             	lea    -0x1(%eax),%edi
  801bc1:	85 c0                	test   %eax,%eax
  801bc3:	74 36                	je     801bfb <memcmp+0x4c>
		if (*s1 != *s2)
  801bc5:	0f b6 03             	movzbl (%ebx),%eax
  801bc8:	0f b6 0e             	movzbl (%esi),%ecx
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	38 c8                	cmp    %cl,%al
  801bd2:	74 1c                	je     801bf0 <memcmp+0x41>
  801bd4:	eb 10                	jmp    801be6 <memcmp+0x37>
  801bd6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801bdb:	83 c2 01             	add    $0x1,%edx
  801bde:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801be2:	38 c8                	cmp    %cl,%al
  801be4:	74 0a                	je     801bf0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801be6:	0f b6 c0             	movzbl %al,%eax
  801be9:	0f b6 c9             	movzbl %cl,%ecx
  801bec:	29 c8                	sub    %ecx,%eax
  801bee:	eb 10                	jmp    801c00 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bf0:	39 fa                	cmp    %edi,%edx
  801bf2:	75 e2                	jne    801bd6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf9:	eb 05                	jmp    801c00 <memcmp+0x51>
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c00:	5b                   	pop    %ebx
  801c01:	5e                   	pop    %esi
  801c02:	5f                   	pop    %edi
  801c03:	5d                   	pop    %ebp
  801c04:	c3                   	ret    

00801c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	53                   	push   %ebx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801c0f:	89 c2                	mov    %eax,%edx
  801c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c14:	39 d0                	cmp    %edx,%eax
  801c16:	73 13                	jae    801c2b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c18:	89 d9                	mov    %ebx,%ecx
  801c1a:	38 18                	cmp    %bl,(%eax)
  801c1c:	75 06                	jne    801c24 <memfind+0x1f>
  801c1e:	eb 0b                	jmp    801c2b <memfind+0x26>
  801c20:	38 08                	cmp    %cl,(%eax)
  801c22:	74 07                	je     801c2b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c24:	83 c0 01             	add    $0x1,%eax
  801c27:	39 d0                	cmp    %edx,%eax
  801c29:	75 f5                	jne    801c20 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c2b:	5b                   	pop    %ebx
  801c2c:	5d                   	pop    %ebp
  801c2d:	c3                   	ret    

00801c2e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	57                   	push   %edi
  801c32:	56                   	push   %esi
  801c33:	53                   	push   %ebx
  801c34:	8b 55 08             	mov    0x8(%ebp),%edx
  801c37:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c3a:	0f b6 0a             	movzbl (%edx),%ecx
  801c3d:	80 f9 09             	cmp    $0x9,%cl
  801c40:	74 05                	je     801c47 <strtol+0x19>
  801c42:	80 f9 20             	cmp    $0x20,%cl
  801c45:	75 10                	jne    801c57 <strtol+0x29>
		s++;
  801c47:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c4a:	0f b6 0a             	movzbl (%edx),%ecx
  801c4d:	80 f9 09             	cmp    $0x9,%cl
  801c50:	74 f5                	je     801c47 <strtol+0x19>
  801c52:	80 f9 20             	cmp    $0x20,%cl
  801c55:	74 f0                	je     801c47 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c57:	80 f9 2b             	cmp    $0x2b,%cl
  801c5a:	75 0a                	jne    801c66 <strtol+0x38>
		s++;
  801c5c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c5f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c64:	eb 11                	jmp    801c77 <strtol+0x49>
  801c66:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c6b:	80 f9 2d             	cmp    $0x2d,%cl
  801c6e:	75 07                	jne    801c77 <strtol+0x49>
		s++, neg = 1;
  801c70:	83 c2 01             	add    $0x1,%edx
  801c73:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c77:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c7c:	75 15                	jne    801c93 <strtol+0x65>
  801c7e:	80 3a 30             	cmpb   $0x30,(%edx)
  801c81:	75 10                	jne    801c93 <strtol+0x65>
  801c83:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801c87:	75 0a                	jne    801c93 <strtol+0x65>
		s += 2, base = 16;
  801c89:	83 c2 02             	add    $0x2,%edx
  801c8c:	b8 10 00 00 00       	mov    $0x10,%eax
  801c91:	eb 10                	jmp    801ca3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801c93:	85 c0                	test   %eax,%eax
  801c95:	75 0c                	jne    801ca3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801c97:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801c99:	80 3a 30             	cmpb   $0x30,(%edx)
  801c9c:	75 05                	jne    801ca3 <strtol+0x75>
		s++, base = 8;
  801c9e:	83 c2 01             	add    $0x1,%edx
  801ca1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ca8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801cab:	0f b6 0a             	movzbl (%edx),%ecx
  801cae:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801cb1:	89 f0                	mov    %esi,%eax
  801cb3:	3c 09                	cmp    $0x9,%al
  801cb5:	77 08                	ja     801cbf <strtol+0x91>
			dig = *s - '0';
  801cb7:	0f be c9             	movsbl %cl,%ecx
  801cba:	83 e9 30             	sub    $0x30,%ecx
  801cbd:	eb 20                	jmp    801cdf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801cbf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801cc2:	89 f0                	mov    %esi,%eax
  801cc4:	3c 19                	cmp    $0x19,%al
  801cc6:	77 08                	ja     801cd0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801cc8:	0f be c9             	movsbl %cl,%ecx
  801ccb:	83 e9 57             	sub    $0x57,%ecx
  801cce:	eb 0f                	jmp    801cdf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801cd0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801cd3:	89 f0                	mov    %esi,%eax
  801cd5:	3c 19                	cmp    $0x19,%al
  801cd7:	77 16                	ja     801cef <strtol+0xc1>
			dig = *s - 'A' + 10;
  801cd9:	0f be c9             	movsbl %cl,%ecx
  801cdc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801cdf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801ce2:	7d 0f                	jge    801cf3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801ce4:	83 c2 01             	add    $0x1,%edx
  801ce7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801ceb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801ced:	eb bc                	jmp    801cab <strtol+0x7d>
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	eb 02                	jmp    801cf5 <strtol+0xc7>
  801cf3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801cf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cf9:	74 05                	je     801d00 <strtol+0xd2>
		*endptr = (char *) s;
  801cfb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cfe:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801d00:	f7 d8                	neg    %eax
  801d02:	85 ff                	test   %edi,%edi
  801d04:	0f 44 c3             	cmove  %ebx,%eax
}
  801d07:	5b                   	pop    %ebx
  801d08:	5e                   	pop    %esi
  801d09:	5f                   	pop    %edi
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    

00801d0c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
  801d11:	83 ec 10             	sub    $0x10,%esp
  801d14:	8b 75 08             	mov    0x8(%ebp),%esi
  801d17:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801d1d:	85 c0                	test   %eax,%eax
  801d1f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d24:	0f 44 c2             	cmove  %edx,%eax
  801d27:	89 04 24             	mov    %eax,(%esp)
  801d2a:	e8 7f e6 ff ff       	call   8003ae <sys_ipc_recv>
	if (err_code < 0) {
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	79 16                	jns    801d49 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d33:	85 f6                	test   %esi,%esi
  801d35:	74 06                	je     801d3d <ipc_recv+0x31>
  801d37:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d3d:	85 db                	test   %ebx,%ebx
  801d3f:	74 2c                	je     801d6d <ipc_recv+0x61>
  801d41:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d47:	eb 24                	jmp    801d6d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d49:	85 f6                	test   %esi,%esi
  801d4b:	74 0a                	je     801d57 <ipc_recv+0x4b>
  801d4d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d52:	8b 40 74             	mov    0x74(%eax),%eax
  801d55:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d57:	85 db                	test   %ebx,%ebx
  801d59:	74 0a                	je     801d65 <ipc_recv+0x59>
  801d5b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d60:	8b 40 78             	mov    0x78(%eax),%eax
  801d63:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d65:	a1 04 40 80 00       	mov    0x804004,%eax
  801d6a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d6d:	83 c4 10             	add    $0x10,%esp
  801d70:	5b                   	pop    %ebx
  801d71:	5e                   	pop    %esi
  801d72:	5d                   	pop    %ebp
  801d73:	c3                   	ret    

00801d74 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	57                   	push   %edi
  801d78:	56                   	push   %esi
  801d79:	53                   	push   %ebx
  801d7a:	83 ec 1c             	sub    $0x1c,%esp
  801d7d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d80:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d83:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d86:	eb 25                	jmp    801dad <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d88:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d8b:	74 20                	je     801dad <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d8d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d91:	c7 44 24 08 60 25 80 	movl   $0x802560,0x8(%esp)
  801d98:	00 
  801d99:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801da0:	00 
  801da1:	c7 04 24 6c 25 80 00 	movl   $0x80256c,(%esp)
  801da8:	e8 29 f4 ff ff       	call   8011d6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801dad:	85 db                	test   %ebx,%ebx
  801daf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801db4:	0f 45 c3             	cmovne %ebx,%eax
  801db7:	8b 55 14             	mov    0x14(%ebp),%edx
  801dba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dc6:	89 3c 24             	mov    %edi,(%esp)
  801dc9:	e8 bd e5 ff ff       	call   80038b <sys_ipc_try_send>
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	75 b6                	jne    801d88 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801dd2:	83 c4 1c             	add    $0x1c,%esp
  801dd5:	5b                   	pop    %ebx
  801dd6:	5e                   	pop    %esi
  801dd7:	5f                   	pop    %edi
  801dd8:	5d                   	pop    %ebp
  801dd9:	c3                   	ret    

00801dda <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801de0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801de5:	39 c8                	cmp    %ecx,%eax
  801de7:	74 17                	je     801e00 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801de9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dee:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801df1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801df7:	8b 52 50             	mov    0x50(%edx),%edx
  801dfa:	39 ca                	cmp    %ecx,%edx
  801dfc:	75 14                	jne    801e12 <ipc_find_env+0x38>
  801dfe:	eb 05                	jmp    801e05 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e05:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e08:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e0d:	8b 40 40             	mov    0x40(%eax),%eax
  801e10:	eb 0e                	jmp    801e20 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e12:	83 c0 01             	add    $0x1,%eax
  801e15:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e1a:	75 d2                	jne    801dee <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e1c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e20:	5d                   	pop    %ebp
  801e21:	c3                   	ret    

00801e22 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e28:	89 d0                	mov    %edx,%eax
  801e2a:	c1 e8 16             	shr    $0x16,%eax
  801e2d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e39:	f6 c1 01             	test   $0x1,%cl
  801e3c:	74 1d                	je     801e5b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e3e:	c1 ea 0c             	shr    $0xc,%edx
  801e41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e48:	f6 c2 01             	test   $0x1,%dl
  801e4b:	74 0e                	je     801e5b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e4d:	c1 ea 0c             	shr    $0xc,%edx
  801e50:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e57:	ef 
  801e58:	0f b7 c0             	movzwl %ax,%eax
}
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    
  801e5d:	66 90                	xchg   %ax,%ax
  801e5f:	90                   	nop

00801e60 <__udivdi3>:
  801e60:	55                   	push   %ebp
  801e61:	57                   	push   %edi
  801e62:	56                   	push   %esi
  801e63:	83 ec 0c             	sub    $0xc,%esp
  801e66:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e6a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e6e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e72:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e76:	85 c0                	test   %eax,%eax
  801e78:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e7c:	89 ea                	mov    %ebp,%edx
  801e7e:	89 0c 24             	mov    %ecx,(%esp)
  801e81:	75 2d                	jne    801eb0 <__udivdi3+0x50>
  801e83:	39 e9                	cmp    %ebp,%ecx
  801e85:	77 61                	ja     801ee8 <__udivdi3+0x88>
  801e87:	85 c9                	test   %ecx,%ecx
  801e89:	89 ce                	mov    %ecx,%esi
  801e8b:	75 0b                	jne    801e98 <__udivdi3+0x38>
  801e8d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e92:	31 d2                	xor    %edx,%edx
  801e94:	f7 f1                	div    %ecx
  801e96:	89 c6                	mov    %eax,%esi
  801e98:	31 d2                	xor    %edx,%edx
  801e9a:	89 e8                	mov    %ebp,%eax
  801e9c:	f7 f6                	div    %esi
  801e9e:	89 c5                	mov    %eax,%ebp
  801ea0:	89 f8                	mov    %edi,%eax
  801ea2:	f7 f6                	div    %esi
  801ea4:	89 ea                	mov    %ebp,%edx
  801ea6:	83 c4 0c             	add    $0xc,%esp
  801ea9:	5e                   	pop    %esi
  801eaa:	5f                   	pop    %edi
  801eab:	5d                   	pop    %ebp
  801eac:	c3                   	ret    
  801ead:	8d 76 00             	lea    0x0(%esi),%esi
  801eb0:	39 e8                	cmp    %ebp,%eax
  801eb2:	77 24                	ja     801ed8 <__udivdi3+0x78>
  801eb4:	0f bd e8             	bsr    %eax,%ebp
  801eb7:	83 f5 1f             	xor    $0x1f,%ebp
  801eba:	75 3c                	jne    801ef8 <__udivdi3+0x98>
  801ebc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ec0:	39 34 24             	cmp    %esi,(%esp)
  801ec3:	0f 86 9f 00 00 00    	jbe    801f68 <__udivdi3+0x108>
  801ec9:	39 d0                	cmp    %edx,%eax
  801ecb:	0f 82 97 00 00 00    	jb     801f68 <__udivdi3+0x108>
  801ed1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ed8:	31 d2                	xor    %edx,%edx
  801eda:	31 c0                	xor    %eax,%eax
  801edc:	83 c4 0c             	add    $0xc,%esp
  801edf:	5e                   	pop    %esi
  801ee0:	5f                   	pop    %edi
  801ee1:	5d                   	pop    %ebp
  801ee2:	c3                   	ret    
  801ee3:	90                   	nop
  801ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ee8:	89 f8                	mov    %edi,%eax
  801eea:	f7 f1                	div    %ecx
  801eec:	31 d2                	xor    %edx,%edx
  801eee:	83 c4 0c             	add    $0xc,%esp
  801ef1:	5e                   	pop    %esi
  801ef2:	5f                   	pop    %edi
  801ef3:	5d                   	pop    %ebp
  801ef4:	c3                   	ret    
  801ef5:	8d 76 00             	lea    0x0(%esi),%esi
  801ef8:	89 e9                	mov    %ebp,%ecx
  801efa:	8b 3c 24             	mov    (%esp),%edi
  801efd:	d3 e0                	shl    %cl,%eax
  801eff:	89 c6                	mov    %eax,%esi
  801f01:	b8 20 00 00 00       	mov    $0x20,%eax
  801f06:	29 e8                	sub    %ebp,%eax
  801f08:	89 c1                	mov    %eax,%ecx
  801f0a:	d3 ef                	shr    %cl,%edi
  801f0c:	89 e9                	mov    %ebp,%ecx
  801f0e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f12:	8b 3c 24             	mov    (%esp),%edi
  801f15:	09 74 24 08          	or     %esi,0x8(%esp)
  801f19:	89 d6                	mov    %edx,%esi
  801f1b:	d3 e7                	shl    %cl,%edi
  801f1d:	89 c1                	mov    %eax,%ecx
  801f1f:	89 3c 24             	mov    %edi,(%esp)
  801f22:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f26:	d3 ee                	shr    %cl,%esi
  801f28:	89 e9                	mov    %ebp,%ecx
  801f2a:	d3 e2                	shl    %cl,%edx
  801f2c:	89 c1                	mov    %eax,%ecx
  801f2e:	d3 ef                	shr    %cl,%edi
  801f30:	09 d7                	or     %edx,%edi
  801f32:	89 f2                	mov    %esi,%edx
  801f34:	89 f8                	mov    %edi,%eax
  801f36:	f7 74 24 08          	divl   0x8(%esp)
  801f3a:	89 d6                	mov    %edx,%esi
  801f3c:	89 c7                	mov    %eax,%edi
  801f3e:	f7 24 24             	mull   (%esp)
  801f41:	39 d6                	cmp    %edx,%esi
  801f43:	89 14 24             	mov    %edx,(%esp)
  801f46:	72 30                	jb     801f78 <__udivdi3+0x118>
  801f48:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f4c:	89 e9                	mov    %ebp,%ecx
  801f4e:	d3 e2                	shl    %cl,%edx
  801f50:	39 c2                	cmp    %eax,%edx
  801f52:	73 05                	jae    801f59 <__udivdi3+0xf9>
  801f54:	3b 34 24             	cmp    (%esp),%esi
  801f57:	74 1f                	je     801f78 <__udivdi3+0x118>
  801f59:	89 f8                	mov    %edi,%eax
  801f5b:	31 d2                	xor    %edx,%edx
  801f5d:	e9 7a ff ff ff       	jmp    801edc <__udivdi3+0x7c>
  801f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f68:	31 d2                	xor    %edx,%edx
  801f6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6f:	e9 68 ff ff ff       	jmp    801edc <__udivdi3+0x7c>
  801f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f78:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	83 c4 0c             	add    $0xc,%esp
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    
  801f84:	66 90                	xchg   %ax,%ax
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	66 90                	xchg   %ax,%ax
  801f8a:	66 90                	xchg   %ax,%ax
  801f8c:	66 90                	xchg   %ax,%ax
  801f8e:	66 90                	xchg   %ax,%ax

00801f90 <__umoddi3>:
  801f90:	55                   	push   %ebp
  801f91:	57                   	push   %edi
  801f92:	56                   	push   %esi
  801f93:	83 ec 14             	sub    $0x14,%esp
  801f96:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f9a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f9e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fa2:	89 c7                	mov    %eax,%edi
  801fa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fac:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fb0:	89 34 24             	mov    %esi,(%esp)
  801fb3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	89 c2                	mov    %eax,%edx
  801fbb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fbf:	75 17                	jne    801fd8 <__umoddi3+0x48>
  801fc1:	39 fe                	cmp    %edi,%esi
  801fc3:	76 4b                	jbe    802010 <__umoddi3+0x80>
  801fc5:	89 c8                	mov    %ecx,%eax
  801fc7:	89 fa                	mov    %edi,%edx
  801fc9:	f7 f6                	div    %esi
  801fcb:	89 d0                	mov    %edx,%eax
  801fcd:	31 d2                	xor    %edx,%edx
  801fcf:	83 c4 14             	add    $0x14,%esp
  801fd2:	5e                   	pop    %esi
  801fd3:	5f                   	pop    %edi
  801fd4:	5d                   	pop    %ebp
  801fd5:	c3                   	ret    
  801fd6:	66 90                	xchg   %ax,%ax
  801fd8:	39 f8                	cmp    %edi,%eax
  801fda:	77 54                	ja     802030 <__umoddi3+0xa0>
  801fdc:	0f bd e8             	bsr    %eax,%ebp
  801fdf:	83 f5 1f             	xor    $0x1f,%ebp
  801fe2:	75 5c                	jne    802040 <__umoddi3+0xb0>
  801fe4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fe8:	39 3c 24             	cmp    %edi,(%esp)
  801feb:	0f 87 e7 00 00 00    	ja     8020d8 <__umoddi3+0x148>
  801ff1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801ff5:	29 f1                	sub    %esi,%ecx
  801ff7:	19 c7                	sbb    %eax,%edi
  801ff9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ffd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802001:	8b 44 24 08          	mov    0x8(%esp),%eax
  802005:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802009:	83 c4 14             	add    $0x14,%esp
  80200c:	5e                   	pop    %esi
  80200d:	5f                   	pop    %edi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    
  802010:	85 f6                	test   %esi,%esi
  802012:	89 f5                	mov    %esi,%ebp
  802014:	75 0b                	jne    802021 <__umoddi3+0x91>
  802016:	b8 01 00 00 00       	mov    $0x1,%eax
  80201b:	31 d2                	xor    %edx,%edx
  80201d:	f7 f6                	div    %esi
  80201f:	89 c5                	mov    %eax,%ebp
  802021:	8b 44 24 04          	mov    0x4(%esp),%eax
  802025:	31 d2                	xor    %edx,%edx
  802027:	f7 f5                	div    %ebp
  802029:	89 c8                	mov    %ecx,%eax
  80202b:	f7 f5                	div    %ebp
  80202d:	eb 9c                	jmp    801fcb <__umoddi3+0x3b>
  80202f:	90                   	nop
  802030:	89 c8                	mov    %ecx,%eax
  802032:	89 fa                	mov    %edi,%edx
  802034:	83 c4 14             	add    $0x14,%esp
  802037:	5e                   	pop    %esi
  802038:	5f                   	pop    %edi
  802039:	5d                   	pop    %ebp
  80203a:	c3                   	ret    
  80203b:	90                   	nop
  80203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802040:	8b 04 24             	mov    (%esp),%eax
  802043:	be 20 00 00 00       	mov    $0x20,%esi
  802048:	89 e9                	mov    %ebp,%ecx
  80204a:	29 ee                	sub    %ebp,%esi
  80204c:	d3 e2                	shl    %cl,%edx
  80204e:	89 f1                	mov    %esi,%ecx
  802050:	d3 e8                	shr    %cl,%eax
  802052:	89 e9                	mov    %ebp,%ecx
  802054:	89 44 24 04          	mov    %eax,0x4(%esp)
  802058:	8b 04 24             	mov    (%esp),%eax
  80205b:	09 54 24 04          	or     %edx,0x4(%esp)
  80205f:	89 fa                	mov    %edi,%edx
  802061:	d3 e0                	shl    %cl,%eax
  802063:	89 f1                	mov    %esi,%ecx
  802065:	89 44 24 08          	mov    %eax,0x8(%esp)
  802069:	8b 44 24 10          	mov    0x10(%esp),%eax
  80206d:	d3 ea                	shr    %cl,%edx
  80206f:	89 e9                	mov    %ebp,%ecx
  802071:	d3 e7                	shl    %cl,%edi
  802073:	89 f1                	mov    %esi,%ecx
  802075:	d3 e8                	shr    %cl,%eax
  802077:	89 e9                	mov    %ebp,%ecx
  802079:	09 f8                	or     %edi,%eax
  80207b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80207f:	f7 74 24 04          	divl   0x4(%esp)
  802083:	d3 e7                	shl    %cl,%edi
  802085:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802089:	89 d7                	mov    %edx,%edi
  80208b:	f7 64 24 08          	mull   0x8(%esp)
  80208f:	39 d7                	cmp    %edx,%edi
  802091:	89 c1                	mov    %eax,%ecx
  802093:	89 14 24             	mov    %edx,(%esp)
  802096:	72 2c                	jb     8020c4 <__umoddi3+0x134>
  802098:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80209c:	72 22                	jb     8020c0 <__umoddi3+0x130>
  80209e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020a2:	29 c8                	sub    %ecx,%eax
  8020a4:	19 d7                	sbb    %edx,%edi
  8020a6:	89 e9                	mov    %ebp,%ecx
  8020a8:	89 fa                	mov    %edi,%edx
  8020aa:	d3 e8                	shr    %cl,%eax
  8020ac:	89 f1                	mov    %esi,%ecx
  8020ae:	d3 e2                	shl    %cl,%edx
  8020b0:	89 e9                	mov    %ebp,%ecx
  8020b2:	d3 ef                	shr    %cl,%edi
  8020b4:	09 d0                	or     %edx,%eax
  8020b6:	89 fa                	mov    %edi,%edx
  8020b8:	83 c4 14             	add    $0x14,%esp
  8020bb:	5e                   	pop    %esi
  8020bc:	5f                   	pop    %edi
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    
  8020bf:	90                   	nop
  8020c0:	39 d7                	cmp    %edx,%edi
  8020c2:	75 da                	jne    80209e <__umoddi3+0x10e>
  8020c4:	8b 14 24             	mov    (%esp),%edx
  8020c7:	89 c1                	mov    %eax,%ecx
  8020c9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020cd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020d1:	eb cb                	jmp    80209e <__umoddi3+0x10e>
  8020d3:	90                   	nop
  8020d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020d8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020dc:	0f 82 0f ff ff ff    	jb     801ff1 <__umoddi3+0x61>
  8020e2:	e9 1a ff ff ff       	jmp    802001 <__umoddi3+0x71>
