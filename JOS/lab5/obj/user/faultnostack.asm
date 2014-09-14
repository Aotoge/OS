
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 28 00 00 00       	call   800059 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	c7 44 24 04 1f 04 80 	movl   $0x80041f,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800048:	e8 0a 03 00 00       	call   800357 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  80004d:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  800054:	00 00 00 
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  800067:	e8 0d 01 00 00       	call   800179 <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  80006c:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800072:	39 c2                	cmp    %eax,%edx
  800074:	74 17                	je     80008d <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800076:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  80007b:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  80007e:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800084:	8b 49 40             	mov    0x40(%ecx),%ecx
  800087:	39 c1                	cmp    %eax,%ecx
  800089:	75 18                	jne    8000a3 <libmain+0x4a>
  80008b:	eb 05                	jmp    800092 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80008d:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800092:	6b d2 7c             	imul   $0x7c,%edx,%edx
  800095:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80009b:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  8000a1:	eb 0b                	jmp    8000ae <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  8000a3:	83 c2 01             	add    $0x1,%edx
  8000a6:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000ac:	75 cd                	jne    80007b <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	85 db                	test   %ebx,%ebx
  8000b0:	7e 07                	jle    8000b9 <libmain+0x60>
		binaryname = argv[0];
  8000b2:	8b 06                	mov    (%esi),%eax
  8000b4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000bd:	89 1c 24             	mov    %ebx,(%esp)
  8000c0:	e8 6e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c5:	e8 07 00 00 00       	call   8000d1 <exit>
}
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	5b                   	pop    %ebx
  8000ce:	5e                   	pop    %esi
  8000cf:	5d                   	pop    %ebp
  8000d0:	c3                   	ret    

008000d1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d1:	55                   	push   %ebp
  8000d2:	89 e5                	mov    %esp,%ebp
  8000d4:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000d7:	e8 aa 05 00 00       	call   800686 <close_all>
	sys_env_destroy(0);
  8000dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e3:	e8 3f 00 00 00       	call   800127 <sys_env_destroy>
}
  8000e8:	c9                   	leave  
  8000e9:	c3                   	ret    

008000ea <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ea:	55                   	push   %ebp
  8000eb:	89 e5                	mov    %esp,%ebp
  8000ed:	57                   	push   %edi
  8000ee:	56                   	push   %esi
  8000ef:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fb:	89 c3                	mov    %eax,%ebx
  8000fd:	89 c7                	mov    %eax,%edi
  8000ff:	89 c6                	mov    %eax,%esi
  800101:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5f                   	pop    %edi
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <sys_cgetc>:

int
sys_cgetc(void)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80010e:	ba 00 00 00 00       	mov    $0x0,%edx
  800113:	b8 01 00 00 00       	mov    $0x1,%eax
  800118:	89 d1                	mov    %edx,%ecx
  80011a:	89 d3                	mov    %edx,%ebx
  80011c:	89 d7                	mov    %edx,%edi
  80011e:	89 d6                	mov    %edx,%esi
  800120:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5f                   	pop    %edi
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    

00800127 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	57                   	push   %edi
  80012b:	56                   	push   %esi
  80012c:	53                   	push   %ebx
  80012d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800130:	b9 00 00 00 00       	mov    $0x0,%ecx
  800135:	b8 03 00 00 00       	mov    $0x3,%eax
  80013a:	8b 55 08             	mov    0x8(%ebp),%edx
  80013d:	89 cb                	mov    %ecx,%ebx
  80013f:	89 cf                	mov    %ecx,%edi
  800141:	89 ce                	mov    %ecx,%esi
  800143:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800145:	85 c0                	test   %eax,%eax
  800147:	7e 28                	jle    800171 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800149:	89 44 24 10          	mov    %eax,0x10(%esp)
  80014d:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800154:	00 
  800155:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80015c:	00 
  80015d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800164:	00 
  800165:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80016c:	e8 a5 10 00 00       	call   801216 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800171:	83 c4 2c             	add    $0x2c,%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <sys_getenvid>:

envid_t
sys_getenvid(void)
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
  800184:	b8 02 00 00 00       	mov    $0x2,%eax
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	89 d3                	mov    %edx,%ebx
  80018d:	89 d7                	mov    %edx,%edi
  80018f:	89 d6                	mov    %edx,%esi
  800191:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800193:	5b                   	pop    %ebx
  800194:	5e                   	pop    %esi
  800195:	5f                   	pop    %edi
  800196:	5d                   	pop    %ebp
  800197:	c3                   	ret    

00800198 <sys_yield>:

void
sys_yield(void)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	57                   	push   %edi
  80019c:	56                   	push   %esi
  80019d:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80019e:	ba 00 00 00 00       	mov    $0x0,%edx
  8001a3:	b8 0b 00 00 00       	mov    $0xb,%eax
  8001a8:	89 d1                	mov    %edx,%ecx
  8001aa:	89 d3                	mov    %edx,%ebx
  8001ac:	89 d7                	mov    %edx,%edi
  8001ae:	89 d6                	mov    %edx,%esi
  8001b0:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001b2:	5b                   	pop    %ebx
  8001b3:	5e                   	pop    %esi
  8001b4:	5f                   	pop    %edi
  8001b5:	5d                   	pop    %ebp
  8001b6:	c3                   	ret    

008001b7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001b7:	55                   	push   %ebp
  8001b8:	89 e5                	mov    %esp,%ebp
  8001ba:	57                   	push   %edi
  8001bb:	56                   	push   %esi
  8001bc:	53                   	push   %ebx
  8001bd:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c0:	be 00 00 00 00       	mov    $0x0,%esi
  8001c5:	b8 04 00 00 00       	mov    $0x4,%eax
  8001ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d3:	89 f7                	mov    %esi,%edi
  8001d5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	7e 28                	jle    800203 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001db:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001df:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001e6:	00 
  8001e7:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  8001ee:	00 
  8001ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001f6:	00 
  8001f7:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  8001fe:	e8 13 10 00 00       	call   801216 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800203:	83 c4 2c             	add    $0x2c,%esp
  800206:	5b                   	pop    %ebx
  800207:	5e                   	pop    %esi
  800208:	5f                   	pop    %edi
  800209:	5d                   	pop    %ebp
  80020a:	c3                   	ret    

0080020b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800214:	b8 05 00 00 00       	mov    $0x5,%eax
  800219:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80021c:	8b 55 08             	mov    0x8(%ebp),%edx
  80021f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800222:	8b 7d 14             	mov    0x14(%ebp),%edi
  800225:	8b 75 18             	mov    0x18(%ebp),%esi
  800228:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80022a:	85 c0                	test   %eax,%eax
  80022c:	7e 28                	jle    800256 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80022e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800232:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800239:	00 
  80023a:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800241:	00 
  800242:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800249:	00 
  80024a:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  800251:	e8 c0 0f 00 00       	call   801216 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800256:	83 c4 2c             	add    $0x2c,%esp
  800259:	5b                   	pop    %ebx
  80025a:	5e                   	pop    %esi
  80025b:	5f                   	pop    %edi
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	57                   	push   %edi
  800262:	56                   	push   %esi
  800263:	53                   	push   %ebx
  800264:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800267:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026c:	b8 06 00 00 00       	mov    $0x6,%eax
  800271:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800274:	8b 55 08             	mov    0x8(%ebp),%edx
  800277:	89 df                	mov    %ebx,%edi
  800279:	89 de                	mov    %ebx,%esi
  80027b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80027d:	85 c0                	test   %eax,%eax
  80027f:	7e 28                	jle    8002a9 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800281:	89 44 24 10          	mov    %eax,0x10(%esp)
  800285:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80028c:	00 
  80028d:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800294:	00 
  800295:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80029c:	00 
  80029d:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  8002a4:	e8 6d 0f 00 00       	call   801216 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8002a9:	83 c4 2c             	add    $0x2c,%esp
  8002ac:	5b                   	pop    %ebx
  8002ad:	5e                   	pop    %esi
  8002ae:	5f                   	pop    %edi
  8002af:	5d                   	pop    %ebp
  8002b0:	c3                   	ret    

008002b1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	57                   	push   %edi
  8002b5:	56                   	push   %esi
  8002b6:	53                   	push   %ebx
  8002b7:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002ba:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bf:	b8 08 00 00 00       	mov    $0x8,%eax
  8002c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ca:	89 df                	mov    %ebx,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002d0:	85 c0                	test   %eax,%eax
  8002d2:	7e 28                	jle    8002fc <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002d8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002df:	00 
  8002e0:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  8002e7:	00 
  8002e8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002ef:	00 
  8002f0:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  8002f7:	e8 1a 0f 00 00       	call   801216 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002fc:	83 c4 2c             	add    $0x2c,%esp
  8002ff:	5b                   	pop    %ebx
  800300:	5e                   	pop    %esi
  800301:	5f                   	pop    %edi
  800302:	5d                   	pop    %ebp
  800303:	c3                   	ret    

00800304 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800304:	55                   	push   %ebp
  800305:	89 e5                	mov    %esp,%ebp
  800307:	57                   	push   %edi
  800308:	56                   	push   %esi
  800309:	53                   	push   %ebx
  80030a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80030d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800312:	b8 09 00 00 00       	mov    $0x9,%eax
  800317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031a:	8b 55 08             	mov    0x8(%ebp),%edx
  80031d:	89 df                	mov    %ebx,%edi
  80031f:	89 de                	mov    %ebx,%esi
  800321:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800323:	85 c0                	test   %eax,%eax
  800325:	7e 28                	jle    80034f <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800327:	89 44 24 10          	mov    %eax,0x10(%esp)
  80032b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800332:	00 
  800333:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80033a:	00 
  80033b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800342:	00 
  800343:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80034a:	e8 c7 0e 00 00       	call   801216 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80034f:	83 c4 2c             	add    $0x2c,%esp
  800352:	5b                   	pop    %ebx
  800353:	5e                   	pop    %esi
  800354:	5f                   	pop    %edi
  800355:	5d                   	pop    %ebp
  800356:	c3                   	ret    

00800357 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800357:	55                   	push   %ebp
  800358:	89 e5                	mov    %esp,%ebp
  80035a:	57                   	push   %edi
  80035b:	56                   	push   %esi
  80035c:	53                   	push   %ebx
  80035d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800360:	bb 00 00 00 00       	mov    $0x0,%ebx
  800365:	b8 0a 00 00 00       	mov    $0xa,%eax
  80036a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80036d:	8b 55 08             	mov    0x8(%ebp),%edx
  800370:	89 df                	mov    %ebx,%edi
  800372:	89 de                	mov    %ebx,%esi
  800374:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800376:	85 c0                	test   %eax,%eax
  800378:	7e 28                	jle    8003a2 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80037a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80037e:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800385:	00 
  800386:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  80038d:	00 
  80038e:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800395:	00 
  800396:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  80039d:	e8 74 0e 00 00       	call   801216 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8003a2:	83 c4 2c             	add    $0x2c,%esp
  8003a5:	5b                   	pop    %ebx
  8003a6:	5e                   	pop    %esi
  8003a7:	5f                   	pop    %edi
  8003a8:	5d                   	pop    %ebp
  8003a9:	c3                   	ret    

008003aa <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003aa:	55                   	push   %ebp
  8003ab:	89 e5                	mov    %esp,%ebp
  8003ad:	57                   	push   %edi
  8003ae:	56                   	push   %esi
  8003af:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003b0:	be 00 00 00 00       	mov    $0x0,%esi
  8003b5:	b8 0c 00 00 00       	mov    $0xc,%eax
  8003ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003c6:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003c8:	5b                   	pop    %ebx
  8003c9:	5e                   	pop    %esi
  8003ca:	5f                   	pop    %edi
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	57                   	push   %edi
  8003d1:	56                   	push   %esi
  8003d2:	53                   	push   %ebx
  8003d3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003db:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e3:	89 cb                	mov    %ecx,%ebx
  8003e5:	89 cf                	mov    %ecx,%edi
  8003e7:	89 ce                	mov    %ecx,%esi
  8003e9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003eb:	85 c0                	test   %eax,%eax
  8003ed:	7e 28                	jle    800417 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003ef:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003f3:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003fa:	00 
  8003fb:	c7 44 24 08 aa 21 80 	movl   $0x8021aa,0x8(%esp)
  800402:	00 
  800403:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80040a:	00 
  80040b:	c7 04 24 c7 21 80 00 	movl   $0x8021c7,(%esp)
  800412:	e8 ff 0d 00 00       	call   801216 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800417:	83 c4 2c             	add    $0x2c,%esp
  80041a:	5b                   	pop    %ebx
  80041b:	5e                   	pop    %esi
  80041c:	5f                   	pop    %edi
  80041d:	5d                   	pop    %ebp
  80041e:	c3                   	ret    

0080041f <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80041f:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800420:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  800425:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800427:	83 c4 04             	add    $0x4,%esp
	//
	// LAB 4: Your code here.
	
	// Get utf base pointer	
	// ebx = utf
	movl %esp, %ebx	
  80042a:	89 e3                	mov    %esp,%ebx

	// ecx = utf->eip
	movl $0xa, %esi
  80042c:	be 0a 00 00 00       	mov    $0xa,%esi
	movl (%ebx, %esi, 4), %ecx
  800431:	8b 0c b3             	mov    (%ebx,%esi,4),%ecx

	// edx = &utf->esp
	movl $0xc, %esi
  800434:	be 0c 00 00 00       	mov    $0xc,%esi
	leal (%ebx, %esi, 4), %edx
  800439:	8d 14 b3             	lea    (%ebx,%esi,4),%edx

	// eax = utf->esp
	movl (%edx), %eax
  80043c:	8b 02                	mov    (%edx),%eax

	// utf->esp -= 4
	subl $0x4, %eax 					// eax -= 4
  80043e:	83 e8 04             	sub    $0x4,%eax
	movl %eax, (%edx)  					// *edx = eax
  800441:	89 02                	mov    %eax,(%edx)

	// push trap-time eip onto trap-time stack
	// *(utf->esp) = utf->eip
	movl %ecx, (%eax)
  800443:	89 08                	mov    %ecx,(%eax)
	// 1. utf->eip = utf->eflags
	// 2. utf->eflags = utf->esp
	
	// -------- 1 -----------
	// eax = utf->eflags
	movl $0xb, %esi
  800445:	be 0b 00 00 00       	mov    $0xb,%esi
	movl (%ebx, %esi, 4), %eax 
  80044a:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// ecx = &utf->eip
	movl $0xa, %esi
  80044d:	be 0a 00 00 00       	mov    $0xa,%esi
	leal (%ebx, %esi, 4), %ecx
  800452:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// utf->eip = utf->eflags
	movl %eax, (%ecx)
  800455:	89 01                	mov    %eax,(%ecx)

	// -------- 2 -----------
	// ecx = &utf->elfags
	movl $0xb, %esi
  800457:	be 0b 00 00 00       	mov    $0xb,%esi
	leal (%ebx, %esi, 4), %ecx
  80045c:	8d 0c b3             	lea    (%ebx,%esi,4),%ecx

	// eax = utf->esp
	movl $0xc, %esi
  80045f:	be 0c 00 00 00       	mov    $0xc,%esi
	movl (%ebx, %esi, 4), %eax
  800464:	8b 04 b3             	mov    (%ebx,%esi,4),%eax

	// utf->eflags = utf->esp
	movl %eax, (%ecx)
  800467:	89 01                	mov    %eax,(%ecx)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp    		// ignore fault_va and tf_err
  800469:	83 c4 08             	add    $0x8,%esp
	popal
  80046c:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80046d:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80046e:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  80046f:	c3                   	ret    

00800470 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800473:	8b 45 08             	mov    0x8(%ebp),%eax
  800476:	05 00 00 00 30       	add    $0x30000000,%eax
  80047b:	c1 e8 0c             	shr    $0xc,%eax
}
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    

00800480 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800495:	5d                   	pop    %ebp
  800496:	c3                   	ret    

00800497 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800497:	55                   	push   %ebp
  800498:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80049a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80049f:	a8 01                	test   $0x1,%al
  8004a1:	74 34                	je     8004d7 <fd_alloc+0x40>
  8004a3:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8004a8:	a8 01                	test   $0x1,%al
  8004aa:	74 32                	je     8004de <fd_alloc+0x47>
  8004ac:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004b1:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8004b3:	89 c2                	mov    %eax,%edx
  8004b5:	c1 ea 16             	shr    $0x16,%edx
  8004b8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004bf:	f6 c2 01             	test   $0x1,%dl
  8004c2:	74 1f                	je     8004e3 <fd_alloc+0x4c>
  8004c4:	89 c2                	mov    %eax,%edx
  8004c6:	c1 ea 0c             	shr    $0xc,%edx
  8004c9:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004d0:	f6 c2 01             	test   $0x1,%dl
  8004d3:	75 1a                	jne    8004ef <fd_alloc+0x58>
  8004d5:	eb 0c                	jmp    8004e3 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  8004d7:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8004dc:	eb 05                	jmp    8004e3 <fd_alloc+0x4c>
  8004de:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  8004e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e6:	89 08                	mov    %ecx,(%eax)
			return 0;
  8004e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ed:	eb 1a                	jmp    800509 <fd_alloc+0x72>
  8004ef:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8004f4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004f9:	75 b6                	jne    8004b1 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  800504:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800509:	5d                   	pop    %ebp
  80050a:	c3                   	ret    

0080050b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800511:	83 f8 1f             	cmp    $0x1f,%eax
  800514:	77 36                	ja     80054c <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800516:	c1 e0 0c             	shl    $0xc,%eax
  800519:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80051e:	89 c2                	mov    %eax,%edx
  800520:	c1 ea 16             	shr    $0x16,%edx
  800523:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80052a:	f6 c2 01             	test   $0x1,%dl
  80052d:	74 24                	je     800553 <fd_lookup+0x48>
  80052f:	89 c2                	mov    %eax,%edx
  800531:	c1 ea 0c             	shr    $0xc,%edx
  800534:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80053b:	f6 c2 01             	test   $0x1,%dl
  80053e:	74 1a                	je     80055a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	89 02                	mov    %eax,(%edx)
	return 0;
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	eb 13                	jmp    80055f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80054c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800551:	eb 0c                	jmp    80055f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800553:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800558:	eb 05                	jmp    80055f <fd_lookup+0x54>
  80055a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80055f:	5d                   	pop    %ebp
  800560:	c3                   	ret    

00800561 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800561:	55                   	push   %ebp
  800562:	89 e5                	mov    %esp,%ebp
  800564:	53                   	push   %ebx
  800565:	83 ec 14             	sub    $0x14,%esp
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
  80056b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80056e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800574:	75 1e                	jne    800594 <dev_lookup+0x33>
  800576:	eb 0e                	jmp    800586 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800578:	b8 20 30 80 00       	mov    $0x803020,%eax
  80057d:	eb 0c                	jmp    80058b <dev_lookup+0x2a>
  80057f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800584:	eb 05                	jmp    80058b <dev_lookup+0x2a>
  800586:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80058b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80058d:	b8 00 00 00 00       	mov    $0x0,%eax
  800592:	eb 38                	jmp    8005cc <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800594:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80059a:	74 dc                	je     800578 <dev_lookup+0x17>
  80059c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  8005a2:	74 db                	je     80057f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8005a4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8005aa:	8b 52 48             	mov    0x48(%edx),%edx
  8005ad:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005b5:	c7 04 24 d8 21 80 00 	movl   $0x8021d8,(%esp)
  8005bc:	e8 4e 0d 00 00       	call   80130f <cprintf>
	*dev = 0;
  8005c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  8005c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8005cc:	83 c4 14             	add    $0x14,%esp
  8005cf:	5b                   	pop    %ebx
  8005d0:	5d                   	pop    %ebp
  8005d1:	c3                   	ret    

008005d2 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8005d2:	55                   	push   %ebp
  8005d3:	89 e5                	mov    %esp,%ebp
  8005d5:	56                   	push   %esi
  8005d6:	53                   	push   %ebx
  8005d7:	83 ec 20             	sub    $0x20,%esp
  8005da:	8b 75 08             	mov    0x8(%ebp),%esi
  8005dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005e3:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8005e7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8005ed:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	e8 13 ff ff ff       	call   80050b <fd_lookup>
  8005f8:	85 c0                	test   %eax,%eax
  8005fa:	78 05                	js     800601 <fd_close+0x2f>
	    || fd != fd2)
  8005fc:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8005ff:	74 0c                	je     80060d <fd_close+0x3b>
		return (must_exist ? r : 0);
  800601:	84 db                	test   %bl,%bl
  800603:	ba 00 00 00 00       	mov    $0x0,%edx
  800608:	0f 44 c2             	cmove  %edx,%eax
  80060b:	eb 3f                	jmp    80064c <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80060d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800610:	89 44 24 04          	mov    %eax,0x4(%esp)
  800614:	8b 06                	mov    (%esi),%eax
  800616:	89 04 24             	mov    %eax,(%esp)
  800619:	e8 43 ff ff ff       	call   800561 <dev_lookup>
  80061e:	89 c3                	mov    %eax,%ebx
  800620:	85 c0                	test   %eax,%eax
  800622:	78 16                	js     80063a <fd_close+0x68>
		if (dev->dev_close)
  800624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800627:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80062a:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  80062f:	85 c0                	test   %eax,%eax
  800631:	74 07                	je     80063a <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  800633:	89 34 24             	mov    %esi,(%esp)
  800636:	ff d0                	call   *%eax
  800638:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80063a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800645:	e8 14 fc ff ff       	call   80025e <sys_page_unmap>
	return r;
  80064a:	89 d8                	mov    %ebx,%eax
}
  80064c:	83 c4 20             	add    $0x20,%esp
  80064f:	5b                   	pop    %ebx
  800650:	5e                   	pop    %esi
  800651:	5d                   	pop    %ebp
  800652:	c3                   	ret    

00800653 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800659:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80065c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	89 04 24             	mov    %eax,(%esp)
  800666:	e8 a0 fe ff ff       	call   80050b <fd_lookup>
  80066b:	89 c2                	mov    %eax,%edx
  80066d:	85 d2                	test   %edx,%edx
  80066f:	78 13                	js     800684 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800671:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800678:	00 
  800679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80067c:	89 04 24             	mov    %eax,(%esp)
  80067f:	e8 4e ff ff ff       	call   8005d2 <fd_close>
}
  800684:	c9                   	leave  
  800685:	c3                   	ret    

00800686 <close_all>:

void
close_all(void)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
  800689:	53                   	push   %ebx
  80068a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80068d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800692:	89 1c 24             	mov    %ebx,(%esp)
  800695:	e8 b9 ff ff ff       	call   800653 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80069a:	83 c3 01             	add    $0x1,%ebx
  80069d:	83 fb 20             	cmp    $0x20,%ebx
  8006a0:	75 f0                	jne    800692 <close_all+0xc>
		close(i);
}
  8006a2:	83 c4 14             	add    $0x14,%esp
  8006a5:	5b                   	pop    %ebx
  8006a6:	5d                   	pop    %ebp
  8006a7:	c3                   	ret    

008006a8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	57                   	push   %edi
  8006ac:	56                   	push   %esi
  8006ad:	53                   	push   %ebx
  8006ae:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8006b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8006b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 04 24             	mov    %eax,(%esp)
  8006be:	e8 48 fe ff ff       	call   80050b <fd_lookup>
  8006c3:	89 c2                	mov    %eax,%edx
  8006c5:	85 d2                	test   %edx,%edx
  8006c7:	0f 88 e1 00 00 00    	js     8007ae <dup+0x106>
		return r;
	close(newfdnum);
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	89 04 24             	mov    %eax,(%esp)
  8006d3:	e8 7b ff ff ff       	call   800653 <close>

	newfd = INDEX2FD(newfdnum);
  8006d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8006db:	c1 e3 0c             	shl    $0xc,%ebx
  8006de:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8006e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006e7:	89 04 24             	mov    %eax,(%esp)
  8006ea:	e8 91 fd ff ff       	call   800480 <fd2data>
  8006ef:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8006f1:	89 1c 24             	mov    %ebx,(%esp)
  8006f4:	e8 87 fd ff ff       	call   800480 <fd2data>
  8006f9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006fb:	89 f0                	mov    %esi,%eax
  8006fd:	c1 e8 16             	shr    $0x16,%eax
  800700:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800707:	a8 01                	test   $0x1,%al
  800709:	74 43                	je     80074e <dup+0xa6>
  80070b:	89 f0                	mov    %esi,%eax
  80070d:	c1 e8 0c             	shr    $0xc,%eax
  800710:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800717:	f6 c2 01             	test   $0x1,%dl
  80071a:	74 32                	je     80074e <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80071c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800723:	25 07 0e 00 00       	and    $0xe07,%eax
  800728:	89 44 24 10          	mov    %eax,0x10(%esp)
  80072c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800730:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800737:	00 
  800738:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800743:	e8 c3 fa ff ff       	call   80020b <sys_page_map>
  800748:	89 c6                	mov    %eax,%esi
  80074a:	85 c0                	test   %eax,%eax
  80074c:	78 3e                	js     80078c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80074e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800751:	89 c2                	mov    %eax,%edx
  800753:	c1 ea 0c             	shr    $0xc,%edx
  800756:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80075d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800763:	89 54 24 10          	mov    %edx,0x10(%esp)
  800767:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80076b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800772:	00 
  800773:	89 44 24 04          	mov    %eax,0x4(%esp)
  800777:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80077e:	e8 88 fa ff ff       	call   80020b <sys_page_map>
  800783:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800785:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800788:	85 f6                	test   %esi,%esi
  80078a:	79 22                	jns    8007ae <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80078c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800790:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800797:	e8 c2 fa ff ff       	call   80025e <sys_page_unmap>
	sys_page_unmap(0, nva);
  80079c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007a7:	e8 b2 fa ff ff       	call   80025e <sys_page_unmap>
	return r;
  8007ac:	89 f0                	mov    %esi,%eax
}
  8007ae:	83 c4 3c             	add    $0x3c,%esp
  8007b1:	5b                   	pop    %ebx
  8007b2:	5e                   	pop    %esi
  8007b3:	5f                   	pop    %edi
  8007b4:	5d                   	pop    %ebp
  8007b5:	c3                   	ret    

008007b6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8007b6:	55                   	push   %ebp
  8007b7:	89 e5                	mov    %esp,%ebp
  8007b9:	53                   	push   %ebx
  8007ba:	83 ec 24             	sub    $0x24,%esp
  8007bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c7:	89 1c 24             	mov    %ebx,(%esp)
  8007ca:	e8 3c fd ff ff       	call   80050b <fd_lookup>
  8007cf:	89 c2                	mov    %eax,%edx
  8007d1:	85 d2                	test   %edx,%edx
  8007d3:	78 6d                	js     800842 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	89 04 24             	mov    %eax,(%esp)
  8007e4:	e8 78 fd ff ff       	call   800561 <dev_lookup>
  8007e9:	85 c0                	test   %eax,%eax
  8007eb:	78 55                	js     800842 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8007ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f0:	8b 50 08             	mov    0x8(%eax),%edx
  8007f3:	83 e2 03             	and    $0x3,%edx
  8007f6:	83 fa 01             	cmp    $0x1,%edx
  8007f9:	75 23                	jne    80081e <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007fb:	a1 04 40 80 00       	mov    0x804004,%eax
  800800:	8b 40 48             	mov    0x48(%eax),%eax
  800803:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080b:	c7 04 24 19 22 80 00 	movl   $0x802219,(%esp)
  800812:	e8 f8 0a 00 00       	call   80130f <cprintf>
		return -E_INVAL;
  800817:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081c:	eb 24                	jmp    800842 <read+0x8c>
	}
	if (!dev->dev_read)
  80081e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800821:	8b 52 08             	mov    0x8(%edx),%edx
  800824:	85 d2                	test   %edx,%edx
  800826:	74 15                	je     80083d <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80082b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80082f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800832:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800836:	89 04 24             	mov    %eax,(%esp)
  800839:	ff d2                	call   *%edx
  80083b:	eb 05                	jmp    800842 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  80083d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  800842:	83 c4 24             	add    $0x24,%esp
  800845:	5b                   	pop    %ebx
  800846:	5d                   	pop    %ebp
  800847:	c3                   	ret    

00800848 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800848:	55                   	push   %ebp
  800849:	89 e5                	mov    %esp,%ebp
  80084b:	57                   	push   %edi
  80084c:	56                   	push   %esi
  80084d:	53                   	push   %ebx
  80084e:	83 ec 1c             	sub    $0x1c,%esp
  800851:	8b 7d 08             	mov    0x8(%ebp),%edi
  800854:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800857:	85 f6                	test   %esi,%esi
  800859:	74 33                	je     80088e <readn+0x46>
  80085b:	b8 00 00 00 00       	mov    $0x0,%eax
  800860:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800865:	89 f2                	mov    %esi,%edx
  800867:	29 c2                	sub    %eax,%edx
  800869:	89 54 24 08          	mov    %edx,0x8(%esp)
  80086d:	03 45 0c             	add    0xc(%ebp),%eax
  800870:	89 44 24 04          	mov    %eax,0x4(%esp)
  800874:	89 3c 24             	mov    %edi,(%esp)
  800877:	e8 3a ff ff ff       	call   8007b6 <read>
		if (m < 0)
  80087c:	85 c0                	test   %eax,%eax
  80087e:	78 1b                	js     80089b <readn+0x53>
			return m;
		if (m == 0)
  800880:	85 c0                	test   %eax,%eax
  800882:	74 11                	je     800895 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800884:	01 c3                	add    %eax,%ebx
  800886:	89 d8                	mov    %ebx,%eax
  800888:	39 f3                	cmp    %esi,%ebx
  80088a:	72 d9                	jb     800865 <readn+0x1d>
  80088c:	eb 0b                	jmp    800899 <readn+0x51>
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
  800893:	eb 06                	jmp    80089b <readn+0x53>
  800895:	89 d8                	mov    %ebx,%eax
  800897:	eb 02                	jmp    80089b <readn+0x53>
  800899:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80089b:	83 c4 1c             	add    $0x1c,%esp
  80089e:	5b                   	pop    %ebx
  80089f:	5e                   	pop    %esi
  8008a0:	5f                   	pop    %edi
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	53                   	push   %ebx
  8008a7:	83 ec 24             	sub    $0x24,%esp
  8008aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b4:	89 1c 24             	mov    %ebx,(%esp)
  8008b7:	e8 4f fc ff ff       	call   80050b <fd_lookup>
  8008bc:	89 c2                	mov    %eax,%edx
  8008be:	85 d2                	test   %edx,%edx
  8008c0:	78 68                	js     80092a <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	89 04 24             	mov    %eax,(%esp)
  8008d1:	e8 8b fc ff ff       	call   800561 <dev_lookup>
  8008d6:	85 c0                	test   %eax,%eax
  8008d8:	78 50                	js     80092a <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008e1:	75 23                	jne    800906 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8008e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8008e8:	8b 40 48             	mov    0x48(%eax),%eax
  8008eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f3:	c7 04 24 35 22 80 00 	movl   $0x802235,(%esp)
  8008fa:	e8 10 0a 00 00       	call   80130f <cprintf>
		return -E_INVAL;
  8008ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800904:	eb 24                	jmp    80092a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800906:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800909:	8b 52 0c             	mov    0xc(%edx),%edx
  80090c:	85 d2                	test   %edx,%edx
  80090e:	74 15                	je     800925 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800910:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800913:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800917:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80091e:	89 04 24             	mov    %eax,(%esp)
  800921:	ff d2                	call   *%edx
  800923:	eb 05                	jmp    80092a <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  800925:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80092a:	83 c4 24             	add    $0x24,%esp
  80092d:	5b                   	pop    %ebx
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <seek>:

int
seek(int fdnum, off_t offset)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800936:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800939:	89 44 24 04          	mov    %eax,0x4(%esp)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	89 04 24             	mov    %eax,(%esp)
  800943:	e8 c3 fb ff ff       	call   80050b <fd_lookup>
  800948:	85 c0                	test   %eax,%eax
  80094a:	78 0e                	js     80095a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  80094c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80094f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800952:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800955:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    

0080095c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	53                   	push   %ebx
  800960:	83 ec 24             	sub    $0x24,%esp
  800963:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800966:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096d:	89 1c 24             	mov    %ebx,(%esp)
  800970:	e8 96 fb ff ff       	call   80050b <fd_lookup>
  800975:	89 c2                	mov    %eax,%edx
  800977:	85 d2                	test   %edx,%edx
  800979:	78 61                	js     8009dc <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80097b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80097e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	89 04 24             	mov    %eax,(%esp)
  80098a:	e8 d2 fb ff ff       	call   800561 <dev_lookup>
  80098f:	85 c0                	test   %eax,%eax
  800991:	78 49                	js     8009dc <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800993:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800996:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80099a:	75 23                	jne    8009bf <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80099c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8009a1:	8b 40 48             	mov    0x48(%eax),%eax
  8009a4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ac:	c7 04 24 f8 21 80 00 	movl   $0x8021f8,(%esp)
  8009b3:	e8 57 09 00 00       	call   80130f <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8009b8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009bd:	eb 1d                	jmp    8009dc <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8009bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009c2:	8b 52 18             	mov    0x18(%edx),%edx
  8009c5:	85 d2                	test   %edx,%edx
  8009c7:	74 0e                	je     8009d7 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8009c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8009d0:	89 04 24             	mov    %eax,(%esp)
  8009d3:	ff d2                	call   *%edx
  8009d5:	eb 05                	jmp    8009dc <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8009d7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8009dc:	83 c4 24             	add    $0x24,%esp
  8009df:	5b                   	pop    %ebx
  8009e0:	5d                   	pop    %ebp
  8009e1:	c3                   	ret    

008009e2 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8009e2:	55                   	push   %ebp
  8009e3:	89 e5                	mov    %esp,%ebp
  8009e5:	53                   	push   %ebx
  8009e6:	83 ec 24             	sub    $0x24,%esp
  8009e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8009ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	89 04 24             	mov    %eax,(%esp)
  8009f9:	e8 0d fb ff ff       	call   80050b <fd_lookup>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	85 d2                	test   %edx,%edx
  800a02:	78 52                	js     800a56 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a07:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	89 04 24             	mov    %eax,(%esp)
  800a13:	e8 49 fb ff ff       	call   800561 <dev_lookup>
  800a18:	85 c0                	test   %eax,%eax
  800a1a:	78 3a                	js     800a56 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  800a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800a23:	74 2c                	je     800a51 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800a25:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800a28:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800a2f:	00 00 00 
	stat->st_isdir = 0;
  800a32:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800a39:	00 00 00 
	stat->st_dev = dev;
  800a3c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800a42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a46:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800a49:	89 14 24             	mov    %edx,(%esp)
  800a4c:	ff 50 14             	call   *0x14(%eax)
  800a4f:	eb 05                	jmp    800a56 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a51:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a56:	83 c4 24             	add    $0x24,%esp
  800a59:	5b                   	pop    %ebx
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a64:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a6b:	00 
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	89 04 24             	mov    %eax,(%esp)
  800a72:	e8 af 01 00 00       	call   800c26 <open>
  800a77:	89 c3                	mov    %eax,%ebx
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	78 1b                	js     800a98 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a84:	89 1c 24             	mov    %ebx,(%esp)
  800a87:	e8 56 ff ff ff       	call   8009e2 <fstat>
  800a8c:	89 c6                	mov    %eax,%esi
	close(fd);
  800a8e:	89 1c 24             	mov    %ebx,(%esp)
  800a91:	e8 bd fb ff ff       	call   800653 <close>
	return r;
  800a96:	89 f0                	mov    %esi,%eax
}
  800a98:	83 c4 10             	add    $0x10,%esp
  800a9b:	5b                   	pop    %ebx
  800a9c:	5e                   	pop    %esi
  800a9d:	5d                   	pop    %ebp
  800a9e:	c3                   	ret    

00800a9f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	56                   	push   %esi
  800aa3:	53                   	push   %ebx
  800aa4:	83 ec 10             	sub    $0x10,%esp
  800aa7:	89 c6                	mov    %eax,%esi
  800aa9:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800aab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ab2:	75 11                	jne    800ac5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800abb:	e8 c3 13 00 00       	call   801e83 <ipc_find_env>
  800ac0:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ac5:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800acc:	00 
  800acd:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800ad4:	00 
  800ad5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad9:	a1 00 40 80 00       	mov    0x804000,%eax
  800ade:	89 04 24             	mov    %eax,(%esp)
  800ae1:	e8 37 13 00 00       	call   801e1d <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800ae6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800aed:	00 
  800aee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800af2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800af9:	e8 b7 12 00 00       	call   801db5 <ipc_recv>
}
  800afe:	83 c4 10             	add    $0x10,%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	53                   	push   %ebx
  800b09:	83 ec 14             	sub    $0x14,%esp
  800b0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	8b 40 0c             	mov    0xc(%eax),%eax
  800b15:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b1f:	b8 05 00 00 00       	mov    $0x5,%eax
  800b24:	e8 76 ff ff ff       	call   800a9f <fsipc>
  800b29:	89 c2                	mov    %eax,%edx
  800b2b:	85 d2                	test   %edx,%edx
  800b2d:	78 2b                	js     800b5a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b2f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b36:	00 
  800b37:	89 1c 24             	mov    %ebx,(%esp)
  800b3a:	e8 2c 0e 00 00       	call   80196b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b3f:	a1 80 50 80 00       	mov    0x805080,%eax
  800b44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b4a:	a1 84 50 80 00       	mov    0x805084,%eax
  800b4f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b5a:	83 c4 14             	add    $0x14,%esp
  800b5d:	5b                   	pop    %ebx
  800b5e:	5d                   	pop    %ebp
  800b5f:	c3                   	ret    

00800b60 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	8b 40 0c             	mov    0xc(%eax),%eax
  800b6c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b71:	ba 00 00 00 00       	mov    $0x0,%edx
  800b76:	b8 06 00 00 00       	mov    $0x6,%eax
  800b7b:	e8 1f ff ff ff       	call   800a9f <fsipc>
}
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	56                   	push   %esi
  800b86:	53                   	push   %ebx
  800b87:	83 ec 10             	sub    $0x10,%esp
  800b8a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 40 0c             	mov    0xc(%eax),%eax
  800b93:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b98:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba8:	e8 f2 fe ff ff       	call   800a9f <fsipc>
  800bad:	89 c3                	mov    %eax,%ebx
  800baf:	85 c0                	test   %eax,%eax
  800bb1:	78 6a                	js     800c1d <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800bb3:	39 c6                	cmp    %eax,%esi
  800bb5:	73 24                	jae    800bdb <devfile_read+0x59>
  800bb7:	c7 44 24 0c 52 22 80 	movl   $0x802252,0xc(%esp)
  800bbe:	00 
  800bbf:	c7 44 24 08 59 22 80 	movl   $0x802259,0x8(%esp)
  800bc6:	00 
  800bc7:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  800bce:	00 
  800bcf:	c7 04 24 6e 22 80 00 	movl   $0x80226e,(%esp)
  800bd6:	e8 3b 06 00 00       	call   801216 <_panic>
	assert(r <= PGSIZE);
  800bdb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800be0:	7e 24                	jle    800c06 <devfile_read+0x84>
  800be2:	c7 44 24 0c 79 22 80 	movl   $0x802279,0xc(%esp)
  800be9:	00 
  800bea:	c7 44 24 08 59 22 80 	movl   $0x802259,0x8(%esp)
  800bf1:	00 
  800bf2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800bf9:	00 
  800bfa:	c7 04 24 6e 22 80 00 	movl   $0x80226e,(%esp)
  800c01:	e8 10 06 00 00       	call   801216 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c06:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0a:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c11:	00 
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	89 04 24             	mov    %eax,(%esp)
  800c18:	e8 49 0f 00 00       	call   801b66 <memmove>
	return r;
}
  800c1d:	89 d8                	mov    %ebx,%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 24             	sub    $0x24,%esp
  800c2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c30:	89 1c 24             	mov    %ebx,(%esp)
  800c33:	e8 d8 0c 00 00       	call   801910 <strlen>
  800c38:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c3d:	7f 60                	jg     800c9f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c42:	89 04 24             	mov    %eax,(%esp)
  800c45:	e8 4d f8 ff ff       	call   800497 <fd_alloc>
  800c4a:	89 c2                	mov    %eax,%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	78 54                	js     800ca4 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c54:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c5b:	e8 0b 0d 00 00       	call   80196b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c6b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c70:	e8 2a fe ff ff       	call   800a9f <fsipc>
  800c75:	89 c3                	mov    %eax,%ebx
  800c77:	85 c0                	test   %eax,%eax
  800c79:	79 17                	jns    800c92 <open+0x6c>
		fd_close(fd, 0);
  800c7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c82:	00 
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c86:	89 04 24             	mov    %eax,(%esp)
  800c89:	e8 44 f9 ff ff       	call   8005d2 <fd_close>
		return r;
  800c8e:	89 d8                	mov    %ebx,%eax
  800c90:	eb 12                	jmp    800ca4 <open+0x7e>
	}
	return fd2num(fd);
  800c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c95:	89 04 24             	mov    %eax,(%esp)
  800c98:	e8 d3 f7 ff ff       	call   800470 <fd2num>
  800c9d:	eb 05                	jmp    800ca4 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c9f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800ca4:	83 c4 24             	add    $0x24,%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5d                   	pop    %ebp
  800ca9:	c3                   	ret    
  800caa:	66 90                	xchg   %ax,%ax
  800cac:	66 90                	xchg   %ax,%ax
  800cae:	66 90                	xchg   %ax,%ax

00800cb0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 10             	sub    $0x10,%esp
  800cb8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	89 04 24             	mov    %eax,(%esp)
  800cc1:	e8 ba f7 ff ff       	call   800480 <fd2data>
  800cc6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800cc8:	c7 44 24 04 85 22 80 	movl   $0x802285,0x4(%esp)
  800ccf:	00 
  800cd0:	89 1c 24             	mov    %ebx,(%esp)
  800cd3:	e8 93 0c 00 00       	call   80196b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800cd8:	8b 46 04             	mov    0x4(%esi),%eax
  800cdb:	2b 06                	sub    (%esi),%eax
  800cdd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800ce3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cea:	00 00 00 
	stat->st_dev = &devpipe;
  800ced:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800cf4:	30 80 00 
	return 0;
}
  800cf7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cfc:	83 c4 10             	add    $0x10,%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	53                   	push   %ebx
  800d07:	83 ec 14             	sub    $0x14,%esp
  800d0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d0d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d18:	e8 41 f5 ff ff       	call   80025e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800d1d:	89 1c 24             	mov    %ebx,(%esp)
  800d20:	e8 5b f7 ff ff       	call   800480 <fd2data>
  800d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d30:	e8 29 f5 ff ff       	call   80025e <sys_page_unmap>
}
  800d35:	83 c4 14             	add    $0x14,%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
  800d41:	83 ec 2c             	sub    $0x2c,%esp
  800d44:	89 c6                	mov    %eax,%esi
  800d46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d49:	a1 04 40 80 00       	mov    0x804004,%eax
  800d4e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d51:	89 34 24             	mov    %esi,(%esp)
  800d54:	e8 72 11 00 00       	call   801ecb <pageref>
  800d59:	89 c7                	mov    %eax,%edi
  800d5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5e:	89 04 24             	mov    %eax,(%esp)
  800d61:	e8 65 11 00 00       	call   801ecb <pageref>
  800d66:	39 c7                	cmp    %eax,%edi
  800d68:	0f 94 c2             	sete   %dl
  800d6b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d6e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d74:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d77:	39 fb                	cmp    %edi,%ebx
  800d79:	74 21                	je     800d9c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d7b:	84 d2                	test   %dl,%dl
  800d7d:	74 ca                	je     800d49 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d7f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d82:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d86:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d8a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d8e:	c7 04 24 8c 22 80 00 	movl   $0x80228c,(%esp)
  800d95:	e8 75 05 00 00       	call   80130f <cprintf>
  800d9a:	eb ad                	jmp    800d49 <_pipeisclosed+0xe>
	}
}
  800d9c:	83 c4 2c             	add    $0x2c,%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
  800daa:	83 ec 1c             	sub    $0x1c,%esp
  800dad:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800db0:	89 34 24             	mov    %esi,(%esp)
  800db3:	e8 c8 f6 ff ff       	call   800480 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800db8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbc:	74 61                	je     800e1f <devpipe_write+0x7b>
  800dbe:	89 c3                	mov    %eax,%ebx
  800dc0:	bf 00 00 00 00       	mov    $0x0,%edi
  800dc5:	eb 4a                	jmp    800e11 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800dc7:	89 da                	mov    %ebx,%edx
  800dc9:	89 f0                	mov    %esi,%eax
  800dcb:	e8 6b ff ff ff       	call   800d3b <_pipeisclosed>
  800dd0:	85 c0                	test   %eax,%eax
  800dd2:	75 54                	jne    800e28 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800dd4:	e8 bf f3 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800dd9:	8b 43 04             	mov    0x4(%ebx),%eax
  800ddc:	8b 0b                	mov    (%ebx),%ecx
  800dde:	8d 51 20             	lea    0x20(%ecx),%edx
  800de1:	39 d0                	cmp    %edx,%eax
  800de3:	73 e2                	jae    800dc7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800dec:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800def:	99                   	cltd   
  800df0:	c1 ea 1b             	shr    $0x1b,%edx
  800df3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800df6:	83 e1 1f             	and    $0x1f,%ecx
  800df9:	29 d1                	sub    %edx,%ecx
  800dfb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800dff:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e03:	83 c0 01             	add    $0x1,%eax
  800e06:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e09:	83 c7 01             	add    $0x1,%edi
  800e0c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e0f:	74 13                	je     800e24 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e11:	8b 43 04             	mov    0x4(%ebx),%eax
  800e14:	8b 0b                	mov    (%ebx),%ecx
  800e16:	8d 51 20             	lea    0x20(%ecx),%edx
  800e19:	39 d0                	cmp    %edx,%eax
  800e1b:	73 aa                	jae    800dc7 <devpipe_write+0x23>
  800e1d:	eb c6                	jmp    800de5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e1f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e24:	89 f8                	mov    %edi,%eax
  800e26:	eb 05                	jmp    800e2d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e28:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e2d:	83 c4 1c             	add    $0x1c,%esp
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	57                   	push   %edi
  800e39:	56                   	push   %esi
  800e3a:	53                   	push   %ebx
  800e3b:	83 ec 1c             	sub    $0x1c,%esp
  800e3e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e41:	89 3c 24             	mov    %edi,(%esp)
  800e44:	e8 37 f6 ff ff       	call   800480 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e4d:	74 54                	je     800ea3 <devpipe_read+0x6e>
  800e4f:	89 c3                	mov    %eax,%ebx
  800e51:	be 00 00 00 00       	mov    $0x0,%esi
  800e56:	eb 3e                	jmp    800e96 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e58:	89 f0                	mov    %esi,%eax
  800e5a:	eb 55                	jmp    800eb1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e5c:	89 da                	mov    %ebx,%edx
  800e5e:	89 f8                	mov    %edi,%eax
  800e60:	e8 d6 fe ff ff       	call   800d3b <_pipeisclosed>
  800e65:	85 c0                	test   %eax,%eax
  800e67:	75 43                	jne    800eac <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e69:	e8 2a f3 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e6e:	8b 03                	mov    (%ebx),%eax
  800e70:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e73:	74 e7                	je     800e5c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e75:	99                   	cltd   
  800e76:	c1 ea 1b             	shr    $0x1b,%edx
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	83 e0 1f             	and    $0x1f,%eax
  800e7e:	29 d0                	sub    %edx,%eax
  800e80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e8b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e8e:	83 c6 01             	add    $0x1,%esi
  800e91:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e94:	74 12                	je     800ea8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e96:	8b 03                	mov    (%ebx),%eax
  800e98:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e9b:	75 d8                	jne    800e75 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e9d:	85 f6                	test   %esi,%esi
  800e9f:	75 b7                	jne    800e58 <devpipe_read+0x23>
  800ea1:	eb b9                	jmp    800e5c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ea3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800ea8:	89 f0                	mov    %esi,%eax
  800eaa:	eb 05                	jmp    800eb1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800eac:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800eb1:	83 c4 1c             	add    $0x1c,%esp
  800eb4:	5b                   	pop    %ebx
  800eb5:	5e                   	pop    %esi
  800eb6:	5f                   	pop    %edi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
  800ebe:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800ec1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ec4:	89 04 24             	mov    %eax,(%esp)
  800ec7:	e8 cb f5 ff ff       	call   800497 <fd_alloc>
  800ecc:	89 c2                	mov    %eax,%edx
  800ece:	85 d2                	test   %edx,%edx
  800ed0:	0f 88 4d 01 00 00    	js     801023 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ed6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800edd:	00 
  800ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800eec:	e8 c6 f2 ff ff       	call   8001b7 <sys_page_alloc>
  800ef1:	89 c2                	mov    %eax,%edx
  800ef3:	85 d2                	test   %edx,%edx
  800ef5:	0f 88 28 01 00 00    	js     801023 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800efb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800efe:	89 04 24             	mov    %eax,(%esp)
  800f01:	e8 91 f5 ff ff       	call   800497 <fd_alloc>
  800f06:	89 c3                	mov    %eax,%ebx
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	0f 88 fe 00 00 00    	js     80100e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f10:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f17:	00 
  800f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f26:	e8 8c f2 ff ff       	call   8001b7 <sys_page_alloc>
  800f2b:	89 c3                	mov    %eax,%ebx
  800f2d:	85 c0                	test   %eax,%eax
  800f2f:	0f 88 d9 00 00 00    	js     80100e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f38:	89 04 24             	mov    %eax,(%esp)
  800f3b:	e8 40 f5 ff ff       	call   800480 <fd2data>
  800f40:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f42:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f49:	00 
  800f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f55:	e8 5d f2 ff ff       	call   8001b7 <sys_page_alloc>
  800f5a:	89 c3                	mov    %eax,%ebx
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	0f 88 97 00 00 00    	js     800ffb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f67:	89 04 24             	mov    %eax,(%esp)
  800f6a:	e8 11 f5 ff ff       	call   800480 <fd2data>
  800f6f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f76:	00 
  800f77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f82:	00 
  800f83:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f8e:	e8 78 f2 ff ff       	call   80020b <sys_page_map>
  800f93:	89 c3                	mov    %eax,%ebx
  800f95:	85 c0                	test   %eax,%eax
  800f97:	78 52                	js     800feb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f99:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800fae:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fbc:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc6:	89 04 24             	mov    %eax,(%esp)
  800fc9:	e8 a2 f4 ff ff       	call   800470 <fd2num>
  800fce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	89 04 24             	mov    %eax,(%esp)
  800fd9:	e8 92 f4 ff ff       	call   800470 <fd2num>
  800fde:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fe1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800fe4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe9:	eb 38                	jmp    801023 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800feb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ff6:	e8 63 f2 ff ff       	call   80025e <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801002:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801009:	e8 50 f2 ff ff       	call   80025e <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80100e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801011:	89 44 24 04          	mov    %eax,0x4(%esp)
  801015:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80101c:	e8 3d f2 ff ff       	call   80025e <sys_page_unmap>
  801021:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801023:	83 c4 30             	add    $0x30,%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801030:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801033:	89 44 24 04          	mov    %eax,0x4(%esp)
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	89 04 24             	mov    %eax,(%esp)
  80103d:	e8 c9 f4 ff ff       	call   80050b <fd_lookup>
  801042:	89 c2                	mov    %eax,%edx
  801044:	85 d2                	test   %edx,%edx
  801046:	78 15                	js     80105d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104b:	89 04 24             	mov    %eax,(%esp)
  80104e:	e8 2d f4 ff ff       	call   800480 <fd2data>
	return _pipeisclosed(fd, p);
  801053:	89 c2                	mov    %eax,%edx
  801055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801058:	e8 de fc ff ff       	call   800d3b <_pipeisclosed>
}
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    
  80105f:	90                   	nop

00801060 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801070:	c7 44 24 04 a4 22 80 	movl   $0x8022a4,0x4(%esp)
  801077:	00 
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	89 04 24             	mov    %eax,(%esp)
  80107e:	e8 e8 08 00 00       	call   80196b <strcpy>
	return 0;
}
  801083:	b8 00 00 00 00       	mov    $0x0,%eax
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	57                   	push   %edi
  80108e:	56                   	push   %esi
  80108f:	53                   	push   %ebx
  801090:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801096:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109a:	74 4a                	je     8010e6 <devcons_write+0x5c>
  80109c:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8010a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8010ac:	8b 75 10             	mov    0x10(%ebp),%esi
  8010af:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8010b1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8010b4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8010b9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8010bc:	89 74 24 08          	mov    %esi,0x8(%esp)
  8010c0:	03 45 0c             	add    0xc(%ebp),%eax
  8010c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010c7:	89 3c 24             	mov    %edi,(%esp)
  8010ca:	e8 97 0a 00 00       	call   801b66 <memmove>
		sys_cputs(buf, m);
  8010cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010d3:	89 3c 24             	mov    %edi,(%esp)
  8010d6:	e8 0f f0 ff ff       	call   8000ea <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010db:	01 f3                	add    %esi,%ebx
  8010dd:	89 d8                	mov    %ebx,%eax
  8010df:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8010e2:	72 c8                	jb     8010ac <devcons_write+0x22>
  8010e4:	eb 05                	jmp    8010eb <devcons_write+0x61>
  8010e6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8010f3:	5b                   	pop    %ebx
  8010f4:	5e                   	pop    %esi
  8010f5:	5f                   	pop    %edi
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801107:	75 07                	jne    801110 <devcons_read+0x18>
  801109:	eb 28                	jmp    801133 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80110b:	e8 88 f0 ff ff       	call   800198 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801110:	e8 f3 ef ff ff       	call   800108 <sys_cgetc>
  801115:	85 c0                	test   %eax,%eax
  801117:	74 f2                	je     80110b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801119:	85 c0                	test   %eax,%eax
  80111b:	78 16                	js     801133 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80111d:	83 f8 04             	cmp    $0x4,%eax
  801120:	74 0c                	je     80112e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801122:	8b 55 0c             	mov    0xc(%ebp),%edx
  801125:	88 02                	mov    %al,(%edx)
	return 1;
  801127:	b8 01 00 00 00       	mov    $0x1,%eax
  80112c:	eb 05                	jmp    801133 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801133:	c9                   	leave  
  801134:	c3                   	ret    

00801135 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801135:	55                   	push   %ebp
  801136:	89 e5                	mov    %esp,%ebp
  801138:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801141:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801148:	00 
  801149:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80114c:	89 04 24             	mov    %eax,(%esp)
  80114f:	e8 96 ef ff ff       	call   8000ea <sys_cputs>
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <getchar>:

int
getchar(void)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80115c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801163:	00 
  801164:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801167:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801172:	e8 3f f6 ff ff       	call   8007b6 <read>
	if (r < 0)
  801177:	85 c0                	test   %eax,%eax
  801179:	78 0f                	js     80118a <getchar+0x34>
		return r;
	if (r < 1)
  80117b:	85 c0                	test   %eax,%eax
  80117d:	7e 06                	jle    801185 <getchar+0x2f>
		return -E_EOF;
	return c;
  80117f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801183:	eb 05                	jmp    80118a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801185:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801195:	89 44 24 04          	mov    %eax,0x4(%esp)
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	89 04 24             	mov    %eax,(%esp)
  80119f:	e8 67 f3 ff ff       	call   80050b <fd_lookup>
  8011a4:	85 c0                	test   %eax,%eax
  8011a6:	78 11                	js     8011b9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8011a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ab:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011b1:	39 10                	cmp    %edx,(%eax)
  8011b3:	0f 94 c0             	sete   %al
  8011b6:	0f b6 c0             	movzbl %al,%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <opencons>:

int
opencons(void)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c4:	89 04 24             	mov    %eax,(%esp)
  8011c7:	e8 cb f2 ff ff       	call   800497 <fd_alloc>
		return r;
  8011cc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	78 40                	js     801212 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011d2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8011d9:	00 
  8011da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011e8:	e8 ca ef ff ff       	call   8001b7 <sys_page_alloc>
		return r;
  8011ed:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 1f                	js     801212 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8011f3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011fc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8011fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801201:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801208:	89 04 24             	mov    %eax,(%esp)
  80120b:	e8 60 f2 ff ff       	call   800470 <fd2num>
  801210:	89 c2                	mov    %eax,%edx
}
  801212:	89 d0                	mov    %edx,%eax
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80121e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801221:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801227:	e8 4d ef ff ff       	call   800179 <sys_getenvid>
  80122c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80122f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801233:	8b 55 08             	mov    0x8(%ebp),%edx
  801236:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80123a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80123e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801242:	c7 04 24 b0 22 80 00 	movl   $0x8022b0,(%esp)
  801249:	e8 c1 00 00 00       	call   80130f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80124e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801252:	8b 45 10             	mov    0x10(%ebp),%eax
  801255:	89 04 24             	mov    %eax,(%esp)
  801258:	e8 51 00 00 00       	call   8012ae <vcprintf>
	cprintf("\n");
  80125d:	c7 04 24 9d 22 80 00 	movl   $0x80229d,(%esp)
  801264:	e8 a6 00 00 00       	call   80130f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801269:	cc                   	int3   
  80126a:	eb fd                	jmp    801269 <_panic+0x53>

0080126c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80126c:	55                   	push   %ebp
  80126d:	89 e5                	mov    %esp,%ebp
  80126f:	53                   	push   %ebx
  801270:	83 ec 14             	sub    $0x14,%esp
  801273:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801276:	8b 13                	mov    (%ebx),%edx
  801278:	8d 42 01             	lea    0x1(%edx),%eax
  80127b:	89 03                	mov    %eax,(%ebx)
  80127d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801280:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801284:	3d ff 00 00 00       	cmp    $0xff,%eax
  801289:	75 19                	jne    8012a4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80128b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801292:	00 
  801293:	8d 43 08             	lea    0x8(%ebx),%eax
  801296:	89 04 24             	mov    %eax,(%esp)
  801299:	e8 4c ee ff ff       	call   8000ea <sys_cputs>
		b->idx = 0;
  80129e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8012a4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8012a8:	83 c4 14             	add    $0x14,%esp
  8012ab:	5b                   	pop    %ebx
  8012ac:	5d                   	pop    %ebp
  8012ad:	c3                   	ret    

008012ae <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8012b7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8012be:	00 00 00 
	b.cnt = 0;
  8012c1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8012c8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012d9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8012df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e3:	c7 04 24 6c 12 80 00 	movl   $0x80126c,(%esp)
  8012ea:	e8 b5 01 00 00       	call   8014a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8012ef:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8012f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012f9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8012ff:	89 04 24             	mov    %eax,(%esp)
  801302:	e8 e3 ed ff ff       	call   8000ea <sys_cputs>

	return b.cnt;
}
  801307:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801315:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801318:	89 44 24 04          	mov    %eax,0x4(%esp)
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	89 04 24             	mov    %eax,(%esp)
  801322:	e8 87 ff ff ff       	call   8012ae <vcprintf>
	va_end(ap);

	return cnt;
}
  801327:	c9                   	leave  
  801328:	c3                   	ret    
  801329:	66 90                	xchg   %ax,%ax
  80132b:	66 90                	xchg   %ax,%ax
  80132d:	66 90                	xchg   %ax,%ax
  80132f:	90                   	nop

00801330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	57                   	push   %edi
  801334:	56                   	push   %esi
  801335:	53                   	push   %ebx
  801336:	83 ec 3c             	sub    $0x3c,%esp
  801339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80133c:	89 d7                	mov    %edx,%edi
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801344:	8b 75 0c             	mov    0xc(%ebp),%esi
  801347:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80134a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80134d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801352:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801355:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801358:	39 f1                	cmp    %esi,%ecx
  80135a:	72 14                	jb     801370 <printnum+0x40>
  80135c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80135f:	76 0f                	jbe    801370 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	8d 70 ff             	lea    -0x1(%eax),%esi
  801367:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80136a:	85 f6                	test   %esi,%esi
  80136c:	7f 60                	jg     8013ce <printnum+0x9e>
  80136e:	eb 72                	jmp    8013e2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801370:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801373:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801377:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80137a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80137d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801381:	89 44 24 08          	mov    %eax,0x8(%esp)
  801385:	8b 44 24 08          	mov    0x8(%esp),%eax
  801389:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80138d:	89 c3                	mov    %eax,%ebx
  80138f:	89 d6                	mov    %edx,%esi
  801391:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801394:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801397:	89 54 24 08          	mov    %edx,0x8(%esp)
  80139b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80139f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ac:	e8 5f 0b 00 00       	call   801f10 <__udivdi3>
  8013b1:	89 d9                	mov    %ebx,%ecx
  8013b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013bb:	89 04 24             	mov    %eax,(%esp)
  8013be:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013c2:	89 fa                	mov    %edi,%edx
  8013c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c7:	e8 64 ff ff ff       	call   801330 <printnum>
  8013cc:	eb 14                	jmp    8013e2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8013ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013d2:	8b 45 18             	mov    0x18(%ebp),%eax
  8013d5:	89 04 24             	mov    %eax,(%esp)
  8013d8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013da:	83 ee 01             	sub    $0x1,%esi
  8013dd:	75 ef                	jne    8013ce <printnum+0x9e>
  8013df:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013e6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8013ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013f4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fb:	89 04 24             	mov    %eax,(%esp)
  8013fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801401:	89 44 24 04          	mov    %eax,0x4(%esp)
  801405:	e8 36 0c 00 00       	call   802040 <__umoddi3>
  80140a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80140e:	0f be 80 d3 22 80 00 	movsbl 0x8022d3(%eax),%eax
  801415:	89 04 24             	mov    %eax,(%esp)
  801418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141b:	ff d0                	call   *%eax
}
  80141d:	83 c4 3c             	add    $0x3c,%esp
  801420:	5b                   	pop    %ebx
  801421:	5e                   	pop    %esi
  801422:	5f                   	pop    %edi
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801428:	83 fa 01             	cmp    $0x1,%edx
  80142b:	7e 0e                	jle    80143b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80142d:	8b 10                	mov    (%eax),%edx
  80142f:	8d 4a 08             	lea    0x8(%edx),%ecx
  801432:	89 08                	mov    %ecx,(%eax)
  801434:	8b 02                	mov    (%edx),%eax
  801436:	8b 52 04             	mov    0x4(%edx),%edx
  801439:	eb 22                	jmp    80145d <getuint+0x38>
	else if (lflag)
  80143b:	85 d2                	test   %edx,%edx
  80143d:	74 10                	je     80144f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80143f:	8b 10                	mov    (%eax),%edx
  801441:	8d 4a 04             	lea    0x4(%edx),%ecx
  801444:	89 08                	mov    %ecx,(%eax)
  801446:	8b 02                	mov    (%edx),%eax
  801448:	ba 00 00 00 00       	mov    $0x0,%edx
  80144d:	eb 0e                	jmp    80145d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80144f:	8b 10                	mov    (%eax),%edx
  801451:	8d 4a 04             	lea    0x4(%edx),%ecx
  801454:	89 08                	mov    %ecx,(%eax)
  801456:	8b 02                	mov    (%edx),%eax
  801458:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801465:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801469:	8b 10                	mov    (%eax),%edx
  80146b:	3b 50 04             	cmp    0x4(%eax),%edx
  80146e:	73 0a                	jae    80147a <sprintputch+0x1b>
		*b->buf++ = ch;
  801470:	8d 4a 01             	lea    0x1(%edx),%ecx
  801473:	89 08                	mov    %ecx,(%eax)
  801475:	8b 45 08             	mov    0x8(%ebp),%eax
  801478:	88 02                	mov    %al,(%edx)
}
  80147a:	5d                   	pop    %ebp
  80147b:	c3                   	ret    

0080147c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801482:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801485:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801489:	8b 45 10             	mov    0x10(%ebp),%eax
  80148c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801490:	8b 45 0c             	mov    0xc(%ebp),%eax
  801493:	89 44 24 04          	mov    %eax,0x4(%esp)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	89 04 24             	mov    %eax,(%esp)
  80149d:	e8 02 00 00 00       	call   8014a4 <vprintfmt>
	va_end(ap);
}
  8014a2:	c9                   	leave  
  8014a3:	c3                   	ret    

008014a4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8014a4:	55                   	push   %ebp
  8014a5:	89 e5                	mov    %esp,%ebp
  8014a7:	57                   	push   %edi
  8014a8:	56                   	push   %esi
  8014a9:	53                   	push   %ebx
  8014aa:	83 ec 3c             	sub    $0x3c,%esp
  8014ad:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8014b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014b3:	eb 18                	jmp    8014cd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	0f 84 c3 03 00 00    	je     801880 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8014bd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014c1:	89 04 24             	mov    %eax,(%esp)
  8014c4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014c7:	89 f3                	mov    %esi,%ebx
  8014c9:	eb 02                	jmp    8014cd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014cb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014cd:	8d 73 01             	lea    0x1(%ebx),%esi
  8014d0:	0f b6 03             	movzbl (%ebx),%eax
  8014d3:	83 f8 25             	cmp    $0x25,%eax
  8014d6:	75 dd                	jne    8014b5 <vprintfmt+0x11>
  8014d8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8014dc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8014e3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8014ea:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f6:	eb 1d                	jmp    801515 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014f8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8014fa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8014fe:	eb 15                	jmp    801515 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801500:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801502:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  801506:	eb 0d                	jmp    801515 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801508:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80150b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80150e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801515:	8d 5e 01             	lea    0x1(%esi),%ebx
  801518:	0f b6 06             	movzbl (%esi),%eax
  80151b:	0f b6 c8             	movzbl %al,%ecx
  80151e:	83 e8 23             	sub    $0x23,%eax
  801521:	3c 55                	cmp    $0x55,%al
  801523:	0f 87 2f 03 00 00    	ja     801858 <vprintfmt+0x3b4>
  801529:	0f b6 c0             	movzbl %al,%eax
  80152c:	ff 24 85 20 24 80 00 	jmp    *0x802420(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801533:	8d 41 d0             	lea    -0x30(%ecx),%eax
  801536:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  801539:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80153d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801540:	83 f9 09             	cmp    $0x9,%ecx
  801543:	77 50                	ja     801595 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801545:	89 de                	mov    %ebx,%esi
  801547:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80154a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80154d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801550:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801554:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801557:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80155a:	83 fb 09             	cmp    $0x9,%ebx
  80155d:	76 eb                	jbe    80154a <vprintfmt+0xa6>
  80155f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801562:	eb 33                	jmp    801597 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801564:	8b 45 14             	mov    0x14(%ebp),%eax
  801567:	8d 48 04             	lea    0x4(%eax),%ecx
  80156a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801572:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801574:	eb 21                	jmp    801597 <vprintfmt+0xf3>
  801576:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801579:	85 c9                	test   %ecx,%ecx
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	0f 49 c1             	cmovns %ecx,%eax
  801583:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801586:	89 de                	mov    %ebx,%esi
  801588:	eb 8b                	jmp    801515 <vprintfmt+0x71>
  80158a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80158c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801593:	eb 80                	jmp    801515 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801595:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801597:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159b:	0f 89 74 ff ff ff    	jns    801515 <vprintfmt+0x71>
  8015a1:	e9 62 ff ff ff       	jmp    801508 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8015a6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015a9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8015ab:	e9 65 ff ff ff       	jmp    801515 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8015b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b3:	8d 50 04             	lea    0x4(%eax),%edx
  8015b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015b9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015bd:	8b 00                	mov    (%eax),%eax
  8015bf:	89 04 24             	mov    %eax,(%esp)
  8015c2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8015c5:	e9 03 ff ff ff       	jmp    8014cd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8015ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8015cd:	8d 50 04             	lea    0x4(%eax),%edx
  8015d0:	89 55 14             	mov    %edx,0x14(%ebp)
  8015d3:	8b 00                	mov    (%eax),%eax
  8015d5:	99                   	cltd   
  8015d6:	31 d0                	xor    %edx,%eax
  8015d8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8015da:	83 f8 0f             	cmp    $0xf,%eax
  8015dd:	7f 0b                	jg     8015ea <vprintfmt+0x146>
  8015df:	8b 14 85 80 25 80 00 	mov    0x802580(,%eax,4),%edx
  8015e6:	85 d2                	test   %edx,%edx
  8015e8:	75 20                	jne    80160a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8015ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ee:	c7 44 24 08 eb 22 80 	movl   $0x8022eb,0x8(%esp)
  8015f5:	00 
  8015f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	89 04 24             	mov    %eax,(%esp)
  801600:	e8 77 fe ff ff       	call   80147c <printfmt>
  801605:	e9 c3 fe ff ff       	jmp    8014cd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80160a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80160e:	c7 44 24 08 6b 22 80 	movl   $0x80226b,0x8(%esp)
  801615:	00 
  801616:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 04 24             	mov    %eax,(%esp)
  801620:	e8 57 fe ff ff       	call   80147c <printfmt>
  801625:	e9 a3 fe ff ff       	jmp    8014cd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80162a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80162d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801630:	8b 45 14             	mov    0x14(%ebp),%eax
  801633:	8d 50 04             	lea    0x4(%eax),%edx
  801636:	89 55 14             	mov    %edx,0x14(%ebp)
  801639:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80163b:	85 c0                	test   %eax,%eax
  80163d:	ba e4 22 80 00       	mov    $0x8022e4,%edx
  801642:	0f 45 d0             	cmovne %eax,%edx
  801645:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801648:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80164c:	74 04                	je     801652 <vprintfmt+0x1ae>
  80164e:	85 f6                	test   %esi,%esi
  801650:	7f 19                	jg     80166b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801652:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801655:	8d 70 01             	lea    0x1(%eax),%esi
  801658:	0f b6 10             	movzbl (%eax),%edx
  80165b:	0f be c2             	movsbl %dl,%eax
  80165e:	85 c0                	test   %eax,%eax
  801660:	0f 85 95 00 00 00    	jne    8016fb <vprintfmt+0x257>
  801666:	e9 85 00 00 00       	jmp    8016f0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80166b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80166f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	e8 b8 02 00 00       	call   801932 <strnlen>
  80167a:	29 c6                	sub    %eax,%esi
  80167c:	89 f0                	mov    %esi,%eax
  80167e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801681:	85 f6                	test   %esi,%esi
  801683:	7e cd                	jle    801652 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801685:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801689:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80168c:	89 c3                	mov    %eax,%ebx
  80168e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801692:	89 34 24             	mov    %esi,(%esp)
  801695:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801698:	83 eb 01             	sub    $0x1,%ebx
  80169b:	75 f1                	jne    80168e <vprintfmt+0x1ea>
  80169d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8016a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016a3:	eb ad                	jmp    801652 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8016a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016a9:	74 1e                	je     8016c9 <vprintfmt+0x225>
  8016ab:	0f be d2             	movsbl %dl,%edx
  8016ae:	83 ea 20             	sub    $0x20,%edx
  8016b1:	83 fa 5e             	cmp    $0x5e,%edx
  8016b4:	76 13                	jbe    8016c9 <vprintfmt+0x225>
					putch('?', putdat);
  8016b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bd:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8016c4:	ff 55 08             	call   *0x8(%ebp)
  8016c7:	eb 0d                	jmp    8016d6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8016c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016cc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016d0:	89 04 24             	mov    %eax,(%esp)
  8016d3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016d6:	83 ef 01             	sub    $0x1,%edi
  8016d9:	83 c6 01             	add    $0x1,%esi
  8016dc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8016e0:	0f be c2             	movsbl %dl,%eax
  8016e3:	85 c0                	test   %eax,%eax
  8016e5:	75 20                	jne    801707 <vprintfmt+0x263>
  8016e7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016ea:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016f0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016f4:	7f 25                	jg     80171b <vprintfmt+0x277>
  8016f6:	e9 d2 fd ff ff       	jmp    8014cd <vprintfmt+0x29>
  8016fb:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8016fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801701:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801704:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801707:	85 db                	test   %ebx,%ebx
  801709:	78 9a                	js     8016a5 <vprintfmt+0x201>
  80170b:	83 eb 01             	sub    $0x1,%ebx
  80170e:	79 95                	jns    8016a5 <vprintfmt+0x201>
  801710:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801713:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801716:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801719:	eb d5                	jmp    8016f0 <vprintfmt+0x24c>
  80171b:	8b 75 08             	mov    0x8(%ebp),%esi
  80171e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801721:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801724:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801728:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80172f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801731:	83 eb 01             	sub    $0x1,%ebx
  801734:	75 ee                	jne    801724 <vprintfmt+0x280>
  801736:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801739:	e9 8f fd ff ff       	jmp    8014cd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80173e:	83 fa 01             	cmp    $0x1,%edx
  801741:	7e 16                	jle    801759 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801743:	8b 45 14             	mov    0x14(%ebp),%eax
  801746:	8d 50 08             	lea    0x8(%eax),%edx
  801749:	89 55 14             	mov    %edx,0x14(%ebp)
  80174c:	8b 50 04             	mov    0x4(%eax),%edx
  80174f:	8b 00                	mov    (%eax),%eax
  801751:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801754:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801757:	eb 32                	jmp    80178b <vprintfmt+0x2e7>
	else if (lflag)
  801759:	85 d2                	test   %edx,%edx
  80175b:	74 18                	je     801775 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80175d:	8b 45 14             	mov    0x14(%ebp),%eax
  801760:	8d 50 04             	lea    0x4(%eax),%edx
  801763:	89 55 14             	mov    %edx,0x14(%ebp)
  801766:	8b 30                	mov    (%eax),%esi
  801768:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80176b:	89 f0                	mov    %esi,%eax
  80176d:	c1 f8 1f             	sar    $0x1f,%eax
  801770:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801773:	eb 16                	jmp    80178b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801775:	8b 45 14             	mov    0x14(%ebp),%eax
  801778:	8d 50 04             	lea    0x4(%eax),%edx
  80177b:	89 55 14             	mov    %edx,0x14(%ebp)
  80177e:	8b 30                	mov    (%eax),%esi
  801780:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801783:	89 f0                	mov    %esi,%eax
  801785:	c1 f8 1f             	sar    $0x1f,%eax
  801788:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80178b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80178e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801791:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801796:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80179a:	0f 89 80 00 00 00    	jns    801820 <vprintfmt+0x37c>
				putch('-', putdat);
  8017a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017a4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8017ab:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8017ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017b4:	f7 d8                	neg    %eax
  8017b6:	83 d2 00             	adc    $0x0,%edx
  8017b9:	f7 da                	neg    %edx
			}
			base = 10;
  8017bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017c0:	eb 5e                	jmp    801820 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8017c5:	e8 5b fc ff ff       	call   801425 <getuint>
			base = 10;
  8017ca:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8017cf:	eb 4f                	jmp    801820 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8017d1:	8d 45 14             	lea    0x14(%ebp),%eax
  8017d4:	e8 4c fc ff ff       	call   801425 <getuint>
			base = 8;
  8017d9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8017de:	eb 40                	jmp    801820 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8017e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017e4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8017eb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8017ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017f2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8017f9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8017fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ff:	8d 50 04             	lea    0x4(%eax),%edx
  801802:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801805:	8b 00                	mov    (%eax),%eax
  801807:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80180c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801811:	eb 0d                	jmp    801820 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801813:	8d 45 14             	lea    0x14(%ebp),%eax
  801816:	e8 0a fc ff ff       	call   801425 <getuint>
			base = 16;
  80181b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801820:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801824:	89 74 24 10          	mov    %esi,0x10(%esp)
  801828:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80182b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80182f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	89 54 24 04          	mov    %edx,0x4(%esp)
  80183a:	89 fa                	mov    %edi,%edx
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	e8 ec fa ff ff       	call   801330 <printnum>
			break;
  801844:	e9 84 fc ff ff       	jmp    8014cd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801849:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80184d:	89 0c 24             	mov    %ecx,(%esp)
  801850:	ff 55 08             	call   *0x8(%ebp)
			break;
  801853:	e9 75 fc ff ff       	jmp    8014cd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801858:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80185c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801863:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801866:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80186a:	0f 84 5b fc ff ff    	je     8014cb <vprintfmt+0x27>
  801870:	89 f3                	mov    %esi,%ebx
  801872:	83 eb 01             	sub    $0x1,%ebx
  801875:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801879:	75 f7                	jne    801872 <vprintfmt+0x3ce>
  80187b:	e9 4d fc ff ff       	jmp    8014cd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801880:	83 c4 3c             	add    $0x3c,%esp
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5f                   	pop    %edi
  801886:	5d                   	pop    %ebp
  801887:	c3                   	ret    

00801888 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 28             	sub    $0x28,%esp
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801894:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801897:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80189b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80189e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	74 30                	je     8018d9 <vsnprintf+0x51>
  8018a9:	85 d2                	test   %edx,%edx
  8018ab:	7e 2c                	jle    8018d9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018bb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c2:	c7 04 24 5f 14 80 00 	movl   $0x80145f,(%esp)
  8018c9:	e8 d6 fb ff ff       	call   8014a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8018ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	eb 05                	jmp    8018de <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8018d9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018e6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8018e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 04 24             	mov    %eax,(%esp)
  801901:	e8 82 ff ff ff       	call   801888 <vsnprintf>
	va_end(ap);

	return rc;
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    
  801908:	66 90                	xchg   %ax,%ax
  80190a:	66 90                	xchg   %ax,%ax
  80190c:	66 90                	xchg   %ax,%ax
  80190e:	66 90                	xchg   %ax,%ax

00801910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801916:	80 3a 00             	cmpb   $0x0,(%edx)
  801919:	74 10                	je     80192b <strlen+0x1b>
  80191b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801920:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801927:	75 f7                	jne    801920 <strlen+0x10>
  801929:	eb 05                	jmp    801930 <strlen+0x20>
  80192b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801930:	5d                   	pop    %ebp
  801931:	c3                   	ret    

00801932 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	53                   	push   %ebx
  801936:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801939:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80193c:	85 c9                	test   %ecx,%ecx
  80193e:	74 1c                	je     80195c <strnlen+0x2a>
  801940:	80 3b 00             	cmpb   $0x0,(%ebx)
  801943:	74 1e                	je     801963 <strnlen+0x31>
  801945:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80194a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80194c:	39 ca                	cmp    %ecx,%edx
  80194e:	74 18                	je     801968 <strnlen+0x36>
  801950:	83 c2 01             	add    $0x1,%edx
  801953:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801958:	75 f0                	jne    80194a <strnlen+0x18>
  80195a:	eb 0c                	jmp    801968 <strnlen+0x36>
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
  801961:	eb 05                	jmp    801968 <strnlen+0x36>
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801968:	5b                   	pop    %ebx
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801975:	89 c2                	mov    %eax,%edx
  801977:	83 c2 01             	add    $0x1,%edx
  80197a:	83 c1 01             	add    $0x1,%ecx
  80197d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801981:	88 5a ff             	mov    %bl,-0x1(%edx)
  801984:	84 db                	test   %bl,%bl
  801986:	75 ef                	jne    801977 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801988:	5b                   	pop    %ebx
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	53                   	push   %ebx
  80198f:	83 ec 08             	sub    $0x8,%esp
  801992:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801995:	89 1c 24             	mov    %ebx,(%esp)
  801998:	e8 73 ff ff ff       	call   801910 <strlen>
	strcpy(dst + len, src);
  80199d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019a4:	01 d8                	add    %ebx,%eax
  8019a6:	89 04 24             	mov    %eax,(%esp)
  8019a9:	e8 bd ff ff ff       	call   80196b <strcpy>
	return dst;
}
  8019ae:	89 d8                	mov    %ebx,%eax
  8019b0:	83 c4 08             	add    $0x8,%esp
  8019b3:	5b                   	pop    %ebx
  8019b4:	5d                   	pop    %ebp
  8019b5:	c3                   	ret    

008019b6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	56                   	push   %esi
  8019ba:	53                   	push   %ebx
  8019bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8019be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019c4:	85 db                	test   %ebx,%ebx
  8019c6:	74 17                	je     8019df <strncpy+0x29>
  8019c8:	01 f3                	add    %esi,%ebx
  8019ca:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8019cc:	83 c1 01             	add    $0x1,%ecx
  8019cf:	0f b6 02             	movzbl (%edx),%eax
  8019d2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8019d5:	80 3a 01             	cmpb   $0x1,(%edx)
  8019d8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019db:	39 d9                	cmp    %ebx,%ecx
  8019dd:	75 ed                	jne    8019cc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8019df:	89 f0                	mov    %esi,%eax
  8019e1:	5b                   	pop    %ebx
  8019e2:	5e                   	pop    %esi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	57                   	push   %edi
  8019e9:	56                   	push   %esi
  8019ea:	53                   	push   %ebx
  8019eb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019f1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019f4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019f6:	85 f6                	test   %esi,%esi
  8019f8:	74 34                	je     801a2e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8019fa:	83 fe 01             	cmp    $0x1,%esi
  8019fd:	74 26                	je     801a25 <strlcpy+0x40>
  8019ff:	0f b6 0b             	movzbl (%ebx),%ecx
  801a02:	84 c9                	test   %cl,%cl
  801a04:	74 23                	je     801a29 <strlcpy+0x44>
  801a06:	83 ee 02             	sub    $0x2,%esi
  801a09:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  801a0e:	83 c0 01             	add    $0x1,%eax
  801a11:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a14:	39 f2                	cmp    %esi,%edx
  801a16:	74 13                	je     801a2b <strlcpy+0x46>
  801a18:	83 c2 01             	add    $0x1,%edx
  801a1b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a1f:	84 c9                	test   %cl,%cl
  801a21:	75 eb                	jne    801a0e <strlcpy+0x29>
  801a23:	eb 06                	jmp    801a2b <strlcpy+0x46>
  801a25:	89 f8                	mov    %edi,%eax
  801a27:	eb 02                	jmp    801a2b <strlcpy+0x46>
  801a29:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  801a2b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a2e:	29 f8                	sub    %edi,%eax
}
  801a30:	5b                   	pop    %ebx
  801a31:	5e                   	pop    %esi
  801a32:	5f                   	pop    %edi
  801a33:	5d                   	pop    %ebp
  801a34:	c3                   	ret    

00801a35 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
  801a38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a3e:	0f b6 01             	movzbl (%ecx),%eax
  801a41:	84 c0                	test   %al,%al
  801a43:	74 15                	je     801a5a <strcmp+0x25>
  801a45:	3a 02                	cmp    (%edx),%al
  801a47:	75 11                	jne    801a5a <strcmp+0x25>
		p++, q++;
  801a49:	83 c1 01             	add    $0x1,%ecx
  801a4c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a4f:	0f b6 01             	movzbl (%ecx),%eax
  801a52:	84 c0                	test   %al,%al
  801a54:	74 04                	je     801a5a <strcmp+0x25>
  801a56:	3a 02                	cmp    (%edx),%al
  801a58:	74 ef                	je     801a49 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a5a:	0f b6 c0             	movzbl %al,%eax
  801a5d:	0f b6 12             	movzbl (%edx),%edx
  801a60:	29 d0                	sub    %edx,%eax
}
  801a62:	5d                   	pop    %ebp
  801a63:	c3                   	ret    

00801a64 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	56                   	push   %esi
  801a68:	53                   	push   %ebx
  801a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a72:	85 f6                	test   %esi,%esi
  801a74:	74 29                	je     801a9f <strncmp+0x3b>
  801a76:	0f b6 03             	movzbl (%ebx),%eax
  801a79:	84 c0                	test   %al,%al
  801a7b:	74 30                	je     801aad <strncmp+0x49>
  801a7d:	3a 02                	cmp    (%edx),%al
  801a7f:	75 2c                	jne    801aad <strncmp+0x49>
  801a81:	8d 43 01             	lea    0x1(%ebx),%eax
  801a84:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a86:	89 c3                	mov    %eax,%ebx
  801a88:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a8b:	39 f0                	cmp    %esi,%eax
  801a8d:	74 17                	je     801aa6 <strncmp+0x42>
  801a8f:	0f b6 08             	movzbl (%eax),%ecx
  801a92:	84 c9                	test   %cl,%cl
  801a94:	74 17                	je     801aad <strncmp+0x49>
  801a96:	83 c0 01             	add    $0x1,%eax
  801a99:	3a 0a                	cmp    (%edx),%cl
  801a9b:	74 e9                	je     801a86 <strncmp+0x22>
  801a9d:	eb 0e                	jmp    801aad <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa4:	eb 0f                	jmp    801ab5 <strncmp+0x51>
  801aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801aab:	eb 08                	jmp    801ab5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801aad:	0f b6 03             	movzbl (%ebx),%eax
  801ab0:	0f b6 12             	movzbl (%edx),%edx
  801ab3:	29 d0                	sub    %edx,%eax
}
  801ab5:	5b                   	pop    %ebx
  801ab6:	5e                   	pop    %esi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	53                   	push   %ebx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801ac3:	0f b6 18             	movzbl (%eax),%ebx
  801ac6:	84 db                	test   %bl,%bl
  801ac8:	74 1d                	je     801ae7 <strchr+0x2e>
  801aca:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801acc:	38 d3                	cmp    %dl,%bl
  801ace:	75 06                	jne    801ad6 <strchr+0x1d>
  801ad0:	eb 1a                	jmp    801aec <strchr+0x33>
  801ad2:	38 ca                	cmp    %cl,%dl
  801ad4:	74 16                	je     801aec <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ad6:	83 c0 01             	add    $0x1,%eax
  801ad9:	0f b6 10             	movzbl (%eax),%edx
  801adc:	84 d2                	test   %dl,%dl
  801ade:	75 f2                	jne    801ad2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801ae0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae5:	eb 05                	jmp    801aec <strchr+0x33>
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aec:	5b                   	pop    %ebx
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    

00801aef <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	53                   	push   %ebx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801af9:	0f b6 18             	movzbl (%eax),%ebx
  801afc:	84 db                	test   %bl,%bl
  801afe:	74 16                	je     801b16 <strfind+0x27>
  801b00:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801b02:	38 d3                	cmp    %dl,%bl
  801b04:	75 06                	jne    801b0c <strfind+0x1d>
  801b06:	eb 0e                	jmp    801b16 <strfind+0x27>
  801b08:	38 ca                	cmp    %cl,%dl
  801b0a:	74 0a                	je     801b16 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b0c:	83 c0 01             	add    $0x1,%eax
  801b0f:	0f b6 10             	movzbl (%eax),%edx
  801b12:	84 d2                	test   %dl,%dl
  801b14:	75 f2                	jne    801b08 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801b16:	5b                   	pop    %ebx
  801b17:	5d                   	pop    %ebp
  801b18:	c3                   	ret    

00801b19 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	57                   	push   %edi
  801b1d:	56                   	push   %esi
  801b1e:	53                   	push   %ebx
  801b1f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b25:	85 c9                	test   %ecx,%ecx
  801b27:	74 36                	je     801b5f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b29:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b2f:	75 28                	jne    801b59 <memset+0x40>
  801b31:	f6 c1 03             	test   $0x3,%cl
  801b34:	75 23                	jne    801b59 <memset+0x40>
		c &= 0xFF;
  801b36:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b3a:	89 d3                	mov    %edx,%ebx
  801b3c:	c1 e3 08             	shl    $0x8,%ebx
  801b3f:	89 d6                	mov    %edx,%esi
  801b41:	c1 e6 18             	shl    $0x18,%esi
  801b44:	89 d0                	mov    %edx,%eax
  801b46:	c1 e0 10             	shl    $0x10,%eax
  801b49:	09 f0                	or     %esi,%eax
  801b4b:	09 c2                	or     %eax,%edx
  801b4d:	89 d0                	mov    %edx,%eax
  801b4f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b51:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b54:	fc                   	cld    
  801b55:	f3 ab                	rep stos %eax,%es:(%edi)
  801b57:	eb 06                	jmp    801b5f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5c:	fc                   	cld    
  801b5d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b5f:	89 f8                	mov    %edi,%eax
  801b61:	5b                   	pop    %ebx
  801b62:	5e                   	pop    %esi
  801b63:	5f                   	pop    %edi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    

00801b66 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	57                   	push   %edi
  801b6a:	56                   	push   %esi
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b71:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b74:	39 c6                	cmp    %eax,%esi
  801b76:	73 35                	jae    801bad <memmove+0x47>
  801b78:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b7b:	39 d0                	cmp    %edx,%eax
  801b7d:	73 2e                	jae    801bad <memmove+0x47>
		s += n;
		d += n;
  801b7f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b82:	89 d6                	mov    %edx,%esi
  801b84:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b86:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b8c:	75 13                	jne    801ba1 <memmove+0x3b>
  801b8e:	f6 c1 03             	test   $0x3,%cl
  801b91:	75 0e                	jne    801ba1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b93:	83 ef 04             	sub    $0x4,%edi
  801b96:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b99:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b9c:	fd                   	std    
  801b9d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b9f:	eb 09                	jmp    801baa <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801ba1:	83 ef 01             	sub    $0x1,%edi
  801ba4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801ba7:	fd                   	std    
  801ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801baa:	fc                   	cld    
  801bab:	eb 1d                	jmp    801bca <memmove+0x64>
  801bad:	89 f2                	mov    %esi,%edx
  801baf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bb1:	f6 c2 03             	test   $0x3,%dl
  801bb4:	75 0f                	jne    801bc5 <memmove+0x5f>
  801bb6:	f6 c1 03             	test   $0x3,%cl
  801bb9:	75 0a                	jne    801bc5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801bbb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801bbe:	89 c7                	mov    %eax,%edi
  801bc0:	fc                   	cld    
  801bc1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bc3:	eb 05                	jmp    801bca <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801bc5:	89 c7                	mov    %eax,%edi
  801bc7:	fc                   	cld    
  801bc8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801bca:	5e                   	pop    %esi
  801bcb:	5f                   	pop    %edi
  801bcc:	5d                   	pop    %ebp
  801bcd:	c3                   	ret    

00801bce <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	89 04 24             	mov    %eax,(%esp)
  801be8:	e8 79 ff ff ff       	call   801b66 <memmove>
}
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
  801bf2:	57                   	push   %edi
  801bf3:	56                   	push   %esi
  801bf4:	53                   	push   %ebx
  801bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bfb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bfe:	8d 78 ff             	lea    -0x1(%eax),%edi
  801c01:	85 c0                	test   %eax,%eax
  801c03:	74 36                	je     801c3b <memcmp+0x4c>
		if (*s1 != *s2)
  801c05:	0f b6 03             	movzbl (%ebx),%eax
  801c08:	0f b6 0e             	movzbl (%esi),%ecx
  801c0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c10:	38 c8                	cmp    %cl,%al
  801c12:	74 1c                	je     801c30 <memcmp+0x41>
  801c14:	eb 10                	jmp    801c26 <memcmp+0x37>
  801c16:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c1b:	83 c2 01             	add    $0x1,%edx
  801c1e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c22:	38 c8                	cmp    %cl,%al
  801c24:	74 0a                	je     801c30 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801c26:	0f b6 c0             	movzbl %al,%eax
  801c29:	0f b6 c9             	movzbl %cl,%ecx
  801c2c:	29 c8                	sub    %ecx,%eax
  801c2e:	eb 10                	jmp    801c40 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c30:	39 fa                	cmp    %edi,%edx
  801c32:	75 e2                	jne    801c16 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
  801c39:	eb 05                	jmp    801c40 <memcmp+0x51>
  801c3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c40:	5b                   	pop    %ebx
  801c41:	5e                   	pop    %esi
  801c42:	5f                   	pop    %edi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	53                   	push   %ebx
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801c4f:	89 c2                	mov    %eax,%edx
  801c51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c54:	39 d0                	cmp    %edx,%eax
  801c56:	73 13                	jae    801c6b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c58:	89 d9                	mov    %ebx,%ecx
  801c5a:	38 18                	cmp    %bl,(%eax)
  801c5c:	75 06                	jne    801c64 <memfind+0x1f>
  801c5e:	eb 0b                	jmp    801c6b <memfind+0x26>
  801c60:	38 08                	cmp    %cl,(%eax)
  801c62:	74 07                	je     801c6b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c64:	83 c0 01             	add    $0x1,%eax
  801c67:	39 d0                	cmp    %edx,%eax
  801c69:	75 f5                	jne    801c60 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c6b:	5b                   	pop    %ebx
  801c6c:	5d                   	pop    %ebp
  801c6d:	c3                   	ret    

00801c6e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	57                   	push   %edi
  801c72:	56                   	push   %esi
  801c73:	53                   	push   %ebx
  801c74:	8b 55 08             	mov    0x8(%ebp),%edx
  801c77:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c7a:	0f b6 0a             	movzbl (%edx),%ecx
  801c7d:	80 f9 09             	cmp    $0x9,%cl
  801c80:	74 05                	je     801c87 <strtol+0x19>
  801c82:	80 f9 20             	cmp    $0x20,%cl
  801c85:	75 10                	jne    801c97 <strtol+0x29>
		s++;
  801c87:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c8a:	0f b6 0a             	movzbl (%edx),%ecx
  801c8d:	80 f9 09             	cmp    $0x9,%cl
  801c90:	74 f5                	je     801c87 <strtol+0x19>
  801c92:	80 f9 20             	cmp    $0x20,%cl
  801c95:	74 f0                	je     801c87 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c97:	80 f9 2b             	cmp    $0x2b,%cl
  801c9a:	75 0a                	jne    801ca6 <strtol+0x38>
		s++;
  801c9c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c9f:	bf 00 00 00 00       	mov    $0x0,%edi
  801ca4:	eb 11                	jmp    801cb7 <strtol+0x49>
  801ca6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801cab:	80 f9 2d             	cmp    $0x2d,%cl
  801cae:	75 07                	jne    801cb7 <strtol+0x49>
		s++, neg = 1;
  801cb0:	83 c2 01             	add    $0x1,%edx
  801cb3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801cb7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801cbc:	75 15                	jne    801cd3 <strtol+0x65>
  801cbe:	80 3a 30             	cmpb   $0x30,(%edx)
  801cc1:	75 10                	jne    801cd3 <strtol+0x65>
  801cc3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801cc7:	75 0a                	jne    801cd3 <strtol+0x65>
		s += 2, base = 16;
  801cc9:	83 c2 02             	add    $0x2,%edx
  801ccc:	b8 10 00 00 00       	mov    $0x10,%eax
  801cd1:	eb 10                	jmp    801ce3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	75 0c                	jne    801ce3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801cd7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801cd9:	80 3a 30             	cmpb   $0x30,(%edx)
  801cdc:	75 05                	jne    801ce3 <strtol+0x75>
		s++, base = 8;
  801cde:	83 c2 01             	add    $0x1,%edx
  801ce1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801ce3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ce8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ceb:	0f b6 0a             	movzbl (%edx),%ecx
  801cee:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801cf1:	89 f0                	mov    %esi,%eax
  801cf3:	3c 09                	cmp    $0x9,%al
  801cf5:	77 08                	ja     801cff <strtol+0x91>
			dig = *s - '0';
  801cf7:	0f be c9             	movsbl %cl,%ecx
  801cfa:	83 e9 30             	sub    $0x30,%ecx
  801cfd:	eb 20                	jmp    801d1f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801cff:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801d02:	89 f0                	mov    %esi,%eax
  801d04:	3c 19                	cmp    $0x19,%al
  801d06:	77 08                	ja     801d10 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801d08:	0f be c9             	movsbl %cl,%ecx
  801d0b:	83 e9 57             	sub    $0x57,%ecx
  801d0e:	eb 0f                	jmp    801d1f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801d10:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801d13:	89 f0                	mov    %esi,%eax
  801d15:	3c 19                	cmp    $0x19,%al
  801d17:	77 16                	ja     801d2f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801d19:	0f be c9             	movsbl %cl,%ecx
  801d1c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d1f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801d22:	7d 0f                	jge    801d33 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801d24:	83 c2 01             	add    $0x1,%edx
  801d27:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801d2b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801d2d:	eb bc                	jmp    801ceb <strtol+0x7d>
  801d2f:	89 d8                	mov    %ebx,%eax
  801d31:	eb 02                	jmp    801d35 <strtol+0xc7>
  801d33:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801d35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d39:	74 05                	je     801d40 <strtol+0xd2>
		*endptr = (char *) s;
  801d3b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d3e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801d40:	f7 d8                	neg    %eax
  801d42:	85 ff                	test   %edi,%edi
  801d44:	0f 44 c3             	cmove  %ebx,%eax
}
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801d52:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801d59:	75 50                	jne    801dab <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801d5b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d62:	00 
  801d63:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801d6a:	ee 
  801d6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d72:	e8 40 e4 ff ff       	call   8001b7 <sys_page_alloc>
  801d77:	85 c0                	test   %eax,%eax
  801d79:	79 1c                	jns    801d97 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801d7b:	c7 44 24 08 e0 25 80 	movl   $0x8025e0,0x8(%esp)
  801d82:	00 
  801d83:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801d8a:	00 
  801d8b:	c7 04 24 04 26 80 00 	movl   $0x802604,(%esp)
  801d92:	e8 7f f4 ff ff       	call   801216 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801d97:	c7 44 24 04 1f 04 80 	movl   $0x80041f,0x4(%esp)
  801d9e:	00 
  801d9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da6:	e8 ac e5 ff ff       	call   800357 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	56                   	push   %esi
  801db9:	53                   	push   %ebx
  801dba:	83 ec 10             	sub    $0x10,%esp
  801dbd:	8b 75 08             	mov    0x8(%ebp),%esi
  801dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dcd:	0f 44 c2             	cmove  %edx,%eax
  801dd0:	89 04 24             	mov    %eax,(%esp)
  801dd3:	e8 f5 e5 ff ff       	call   8003cd <sys_ipc_recv>
	if (err_code < 0) {
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	79 16                	jns    801df2 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801ddc:	85 f6                	test   %esi,%esi
  801dde:	74 06                	je     801de6 <ipc_recv+0x31>
  801de0:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801de6:	85 db                	test   %ebx,%ebx
  801de8:	74 2c                	je     801e16 <ipc_recv+0x61>
  801dea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801df0:	eb 24                	jmp    801e16 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801df2:	85 f6                	test   %esi,%esi
  801df4:	74 0a                	je     801e00 <ipc_recv+0x4b>
  801df6:	a1 04 40 80 00       	mov    0x804004,%eax
  801dfb:	8b 40 74             	mov    0x74(%eax),%eax
  801dfe:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e00:	85 db                	test   %ebx,%ebx
  801e02:	74 0a                	je     801e0e <ipc_recv+0x59>
  801e04:	a1 04 40 80 00       	mov    0x804004,%eax
  801e09:	8b 40 78             	mov    0x78(%eax),%eax
  801e0c:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801e0e:	a1 04 40 80 00       	mov    0x804004,%eax
  801e13:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e16:	83 c4 10             	add    $0x10,%esp
  801e19:	5b                   	pop    %ebx
  801e1a:	5e                   	pop    %esi
  801e1b:	5d                   	pop    %ebp
  801e1c:	c3                   	ret    

00801e1d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	57                   	push   %edi
  801e21:	56                   	push   %esi
  801e22:	53                   	push   %ebx
  801e23:	83 ec 1c             	sub    $0x1c,%esp
  801e26:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e29:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e2c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e2f:	eb 25                	jmp    801e56 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801e31:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e34:	74 20                	je     801e56 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801e36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e3a:	c7 44 24 08 12 26 80 	movl   $0x802612,0x8(%esp)
  801e41:	00 
  801e42:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e49:	00 
  801e4a:	c7 04 24 1e 26 80 00 	movl   $0x80261e,(%esp)
  801e51:	e8 c0 f3 ff ff       	call   801216 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e56:	85 db                	test   %ebx,%ebx
  801e58:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e5d:	0f 45 c3             	cmovne %ebx,%eax
  801e60:	8b 55 14             	mov    0x14(%ebp),%edx
  801e63:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e6f:	89 3c 24             	mov    %edi,(%esp)
  801e72:	e8 33 e5 ff ff       	call   8003aa <sys_ipc_try_send>
  801e77:	85 c0                	test   %eax,%eax
  801e79:	75 b6                	jne    801e31 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801e7b:	83 c4 1c             	add    $0x1c,%esp
  801e7e:	5b                   	pop    %ebx
  801e7f:	5e                   	pop    %esi
  801e80:	5f                   	pop    %edi
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e89:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e8e:	39 c8                	cmp    %ecx,%eax
  801e90:	74 17                	je     801ea9 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e97:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e9a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ea0:	8b 52 50             	mov    0x50(%edx),%edx
  801ea3:	39 ca                	cmp    %ecx,%edx
  801ea5:	75 14                	jne    801ebb <ipc_find_env+0x38>
  801ea7:	eb 05                	jmp    801eae <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801eae:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801eb1:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801eb6:	8b 40 40             	mov    0x40(%eax),%eax
  801eb9:	eb 0e                	jmp    801ec9 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ebb:	83 c0 01             	add    $0x1,%eax
  801ebe:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ec3:	75 d2                	jne    801e97 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ec5:	66 b8 00 00          	mov    $0x0,%ax
}
  801ec9:	5d                   	pop    %ebp
  801eca:	c3                   	ret    

00801ecb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ed1:	89 d0                	mov    %edx,%eax
  801ed3:	c1 e8 16             	shr    $0x16,%eax
  801ed6:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801edd:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ee2:	f6 c1 01             	test   $0x1,%cl
  801ee5:	74 1d                	je     801f04 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801ee7:	c1 ea 0c             	shr    $0xc,%edx
  801eea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801ef1:	f6 c2 01             	test   $0x1,%dl
  801ef4:	74 0e                	je     801f04 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ef6:	c1 ea 0c             	shr    $0xc,%edx
  801ef9:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f00:	ef 
  801f01:	0f b7 c0             	movzwl %ax,%eax
}
  801f04:	5d                   	pop    %ebp
  801f05:	c3                   	ret    
  801f06:	66 90                	xchg   %ax,%ax
  801f08:	66 90                	xchg   %ax,%ax
  801f0a:	66 90                	xchg   %ax,%ax
  801f0c:	66 90                	xchg   %ax,%ax
  801f0e:	66 90                	xchg   %ax,%ax

00801f10 <__udivdi3>:
  801f10:	55                   	push   %ebp
  801f11:	57                   	push   %edi
  801f12:	56                   	push   %esi
  801f13:	83 ec 0c             	sub    $0xc,%esp
  801f16:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f1a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801f1e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801f22:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f26:	85 c0                	test   %eax,%eax
  801f28:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f2c:	89 ea                	mov    %ebp,%edx
  801f2e:	89 0c 24             	mov    %ecx,(%esp)
  801f31:	75 2d                	jne    801f60 <__udivdi3+0x50>
  801f33:	39 e9                	cmp    %ebp,%ecx
  801f35:	77 61                	ja     801f98 <__udivdi3+0x88>
  801f37:	85 c9                	test   %ecx,%ecx
  801f39:	89 ce                	mov    %ecx,%esi
  801f3b:	75 0b                	jne    801f48 <__udivdi3+0x38>
  801f3d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f42:	31 d2                	xor    %edx,%edx
  801f44:	f7 f1                	div    %ecx
  801f46:	89 c6                	mov    %eax,%esi
  801f48:	31 d2                	xor    %edx,%edx
  801f4a:	89 e8                	mov    %ebp,%eax
  801f4c:	f7 f6                	div    %esi
  801f4e:	89 c5                	mov    %eax,%ebp
  801f50:	89 f8                	mov    %edi,%eax
  801f52:	f7 f6                	div    %esi
  801f54:	89 ea                	mov    %ebp,%edx
  801f56:	83 c4 0c             	add    $0xc,%esp
  801f59:	5e                   	pop    %esi
  801f5a:	5f                   	pop    %edi
  801f5b:	5d                   	pop    %ebp
  801f5c:	c3                   	ret    
  801f5d:	8d 76 00             	lea    0x0(%esi),%esi
  801f60:	39 e8                	cmp    %ebp,%eax
  801f62:	77 24                	ja     801f88 <__udivdi3+0x78>
  801f64:	0f bd e8             	bsr    %eax,%ebp
  801f67:	83 f5 1f             	xor    $0x1f,%ebp
  801f6a:	75 3c                	jne    801fa8 <__udivdi3+0x98>
  801f6c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801f70:	39 34 24             	cmp    %esi,(%esp)
  801f73:	0f 86 9f 00 00 00    	jbe    802018 <__udivdi3+0x108>
  801f79:	39 d0                	cmp    %edx,%eax
  801f7b:	0f 82 97 00 00 00    	jb     802018 <__udivdi3+0x108>
  801f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801f88:	31 d2                	xor    %edx,%edx
  801f8a:	31 c0                	xor    %eax,%eax
  801f8c:	83 c4 0c             	add    $0xc,%esp
  801f8f:	5e                   	pop    %esi
  801f90:	5f                   	pop    %edi
  801f91:	5d                   	pop    %ebp
  801f92:	c3                   	ret    
  801f93:	90                   	nop
  801f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f98:	89 f8                	mov    %edi,%eax
  801f9a:	f7 f1                	div    %ecx
  801f9c:	31 d2                	xor    %edx,%edx
  801f9e:	83 c4 0c             	add    $0xc,%esp
  801fa1:	5e                   	pop    %esi
  801fa2:	5f                   	pop    %edi
  801fa3:	5d                   	pop    %ebp
  801fa4:	c3                   	ret    
  801fa5:	8d 76 00             	lea    0x0(%esi),%esi
  801fa8:	89 e9                	mov    %ebp,%ecx
  801faa:	8b 3c 24             	mov    (%esp),%edi
  801fad:	d3 e0                	shl    %cl,%eax
  801faf:	89 c6                	mov    %eax,%esi
  801fb1:	b8 20 00 00 00       	mov    $0x20,%eax
  801fb6:	29 e8                	sub    %ebp,%eax
  801fb8:	89 c1                	mov    %eax,%ecx
  801fba:	d3 ef                	shr    %cl,%edi
  801fbc:	89 e9                	mov    %ebp,%ecx
  801fbe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801fc2:	8b 3c 24             	mov    (%esp),%edi
  801fc5:	09 74 24 08          	or     %esi,0x8(%esp)
  801fc9:	89 d6                	mov    %edx,%esi
  801fcb:	d3 e7                	shl    %cl,%edi
  801fcd:	89 c1                	mov    %eax,%ecx
  801fcf:	89 3c 24             	mov    %edi,(%esp)
  801fd2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fd6:	d3 ee                	shr    %cl,%esi
  801fd8:	89 e9                	mov    %ebp,%ecx
  801fda:	d3 e2                	shl    %cl,%edx
  801fdc:	89 c1                	mov    %eax,%ecx
  801fde:	d3 ef                	shr    %cl,%edi
  801fe0:	09 d7                	or     %edx,%edi
  801fe2:	89 f2                	mov    %esi,%edx
  801fe4:	89 f8                	mov    %edi,%eax
  801fe6:	f7 74 24 08          	divl   0x8(%esp)
  801fea:	89 d6                	mov    %edx,%esi
  801fec:	89 c7                	mov    %eax,%edi
  801fee:	f7 24 24             	mull   (%esp)
  801ff1:	39 d6                	cmp    %edx,%esi
  801ff3:	89 14 24             	mov    %edx,(%esp)
  801ff6:	72 30                	jb     802028 <__udivdi3+0x118>
  801ff8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ffc:	89 e9                	mov    %ebp,%ecx
  801ffe:	d3 e2                	shl    %cl,%edx
  802000:	39 c2                	cmp    %eax,%edx
  802002:	73 05                	jae    802009 <__udivdi3+0xf9>
  802004:	3b 34 24             	cmp    (%esp),%esi
  802007:	74 1f                	je     802028 <__udivdi3+0x118>
  802009:	89 f8                	mov    %edi,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	e9 7a ff ff ff       	jmp    801f8c <__udivdi3+0x7c>
  802012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802018:	31 d2                	xor    %edx,%edx
  80201a:	b8 01 00 00 00       	mov    $0x1,%eax
  80201f:	e9 68 ff ff ff       	jmp    801f8c <__udivdi3+0x7c>
  802024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802028:	8d 47 ff             	lea    -0x1(%edi),%eax
  80202b:	31 d2                	xor    %edx,%edx
  80202d:	83 c4 0c             	add    $0xc,%esp
  802030:	5e                   	pop    %esi
  802031:	5f                   	pop    %edi
  802032:	5d                   	pop    %ebp
  802033:	c3                   	ret    
  802034:	66 90                	xchg   %ax,%ax
  802036:	66 90                	xchg   %ax,%ax
  802038:	66 90                	xchg   %ax,%ax
  80203a:	66 90                	xchg   %ax,%ax
  80203c:	66 90                	xchg   %ax,%ax
  80203e:	66 90                	xchg   %ax,%ax

00802040 <__umoddi3>:
  802040:	55                   	push   %ebp
  802041:	57                   	push   %edi
  802042:	56                   	push   %esi
  802043:	83 ec 14             	sub    $0x14,%esp
  802046:	8b 44 24 28          	mov    0x28(%esp),%eax
  80204a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80204e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802052:	89 c7                	mov    %eax,%edi
  802054:	89 44 24 04          	mov    %eax,0x4(%esp)
  802058:	8b 44 24 30          	mov    0x30(%esp),%eax
  80205c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802060:	89 34 24             	mov    %esi,(%esp)
  802063:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802067:	85 c0                	test   %eax,%eax
  802069:	89 c2                	mov    %eax,%edx
  80206b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80206f:	75 17                	jne    802088 <__umoddi3+0x48>
  802071:	39 fe                	cmp    %edi,%esi
  802073:	76 4b                	jbe    8020c0 <__umoddi3+0x80>
  802075:	89 c8                	mov    %ecx,%eax
  802077:	89 fa                	mov    %edi,%edx
  802079:	f7 f6                	div    %esi
  80207b:	89 d0                	mov    %edx,%eax
  80207d:	31 d2                	xor    %edx,%edx
  80207f:	83 c4 14             	add    $0x14,%esp
  802082:	5e                   	pop    %esi
  802083:	5f                   	pop    %edi
  802084:	5d                   	pop    %ebp
  802085:	c3                   	ret    
  802086:	66 90                	xchg   %ax,%ax
  802088:	39 f8                	cmp    %edi,%eax
  80208a:	77 54                	ja     8020e0 <__umoddi3+0xa0>
  80208c:	0f bd e8             	bsr    %eax,%ebp
  80208f:	83 f5 1f             	xor    $0x1f,%ebp
  802092:	75 5c                	jne    8020f0 <__umoddi3+0xb0>
  802094:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802098:	39 3c 24             	cmp    %edi,(%esp)
  80209b:	0f 87 e7 00 00 00    	ja     802188 <__umoddi3+0x148>
  8020a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8020a5:	29 f1                	sub    %esi,%ecx
  8020a7:	19 c7                	sbb    %eax,%edi
  8020a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8020b9:	83 c4 14             	add    $0x14,%esp
  8020bc:	5e                   	pop    %esi
  8020bd:	5f                   	pop    %edi
  8020be:	5d                   	pop    %ebp
  8020bf:	c3                   	ret    
  8020c0:	85 f6                	test   %esi,%esi
  8020c2:	89 f5                	mov    %esi,%ebp
  8020c4:	75 0b                	jne    8020d1 <__umoddi3+0x91>
  8020c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020cb:	31 d2                	xor    %edx,%edx
  8020cd:	f7 f6                	div    %esi
  8020cf:	89 c5                	mov    %eax,%ebp
  8020d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020d5:	31 d2                	xor    %edx,%edx
  8020d7:	f7 f5                	div    %ebp
  8020d9:	89 c8                	mov    %ecx,%eax
  8020db:	f7 f5                	div    %ebp
  8020dd:	eb 9c                	jmp    80207b <__umoddi3+0x3b>
  8020df:	90                   	nop
  8020e0:	89 c8                	mov    %ecx,%eax
  8020e2:	89 fa                	mov    %edi,%edx
  8020e4:	83 c4 14             	add    $0x14,%esp
  8020e7:	5e                   	pop    %esi
  8020e8:	5f                   	pop    %edi
  8020e9:	5d                   	pop    %ebp
  8020ea:	c3                   	ret    
  8020eb:	90                   	nop
  8020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f0:	8b 04 24             	mov    (%esp),%eax
  8020f3:	be 20 00 00 00       	mov    $0x20,%esi
  8020f8:	89 e9                	mov    %ebp,%ecx
  8020fa:	29 ee                	sub    %ebp,%esi
  8020fc:	d3 e2                	shl    %cl,%edx
  8020fe:	89 f1                	mov    %esi,%ecx
  802100:	d3 e8                	shr    %cl,%eax
  802102:	89 e9                	mov    %ebp,%ecx
  802104:	89 44 24 04          	mov    %eax,0x4(%esp)
  802108:	8b 04 24             	mov    (%esp),%eax
  80210b:	09 54 24 04          	or     %edx,0x4(%esp)
  80210f:	89 fa                	mov    %edi,%edx
  802111:	d3 e0                	shl    %cl,%eax
  802113:	89 f1                	mov    %esi,%ecx
  802115:	89 44 24 08          	mov    %eax,0x8(%esp)
  802119:	8b 44 24 10          	mov    0x10(%esp),%eax
  80211d:	d3 ea                	shr    %cl,%edx
  80211f:	89 e9                	mov    %ebp,%ecx
  802121:	d3 e7                	shl    %cl,%edi
  802123:	89 f1                	mov    %esi,%ecx
  802125:	d3 e8                	shr    %cl,%eax
  802127:	89 e9                	mov    %ebp,%ecx
  802129:	09 f8                	or     %edi,%eax
  80212b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80212f:	f7 74 24 04          	divl   0x4(%esp)
  802133:	d3 e7                	shl    %cl,%edi
  802135:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802139:	89 d7                	mov    %edx,%edi
  80213b:	f7 64 24 08          	mull   0x8(%esp)
  80213f:	39 d7                	cmp    %edx,%edi
  802141:	89 c1                	mov    %eax,%ecx
  802143:	89 14 24             	mov    %edx,(%esp)
  802146:	72 2c                	jb     802174 <__umoddi3+0x134>
  802148:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80214c:	72 22                	jb     802170 <__umoddi3+0x130>
  80214e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802152:	29 c8                	sub    %ecx,%eax
  802154:	19 d7                	sbb    %edx,%edi
  802156:	89 e9                	mov    %ebp,%ecx
  802158:	89 fa                	mov    %edi,%edx
  80215a:	d3 e8                	shr    %cl,%eax
  80215c:	89 f1                	mov    %esi,%ecx
  80215e:	d3 e2                	shl    %cl,%edx
  802160:	89 e9                	mov    %ebp,%ecx
  802162:	d3 ef                	shr    %cl,%edi
  802164:	09 d0                	or     %edx,%eax
  802166:	89 fa                	mov    %edi,%edx
  802168:	83 c4 14             	add    $0x14,%esp
  80216b:	5e                   	pop    %esi
  80216c:	5f                   	pop    %edi
  80216d:	5d                   	pop    %ebp
  80216e:	c3                   	ret    
  80216f:	90                   	nop
  802170:	39 d7                	cmp    %edx,%edi
  802172:	75 da                	jne    80214e <__umoddi3+0x10e>
  802174:	8b 14 24             	mov    (%esp),%edx
  802177:	89 c1                	mov    %eax,%ecx
  802179:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80217d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802181:	eb cb                	jmp    80214e <__umoddi3+0x10e>
  802183:	90                   	nop
  802184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802188:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80218c:	0f 82 0f ff ff ff    	jb     8020a1 <__umoddi3+0x61>
  802192:	e9 1a ff ff ff       	jmp    8020b1 <__umoddi3+0x71>
