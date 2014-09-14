
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
  800155:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80015c:	00 
  80015d:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800164:	00 
  800165:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  80016c:	e8 d5 10 00 00       	call   801246 <_panic>

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
  8001e7:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  8001ee:	00 
  8001ef:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001f6:	00 
  8001f7:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8001fe:	e8 43 10 00 00       	call   801246 <_panic>

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
  80023a:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  800241:	00 
  800242:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800249:	00 
  80024a:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  800251:	e8 f0 0f 00 00       	call   801246 <_panic>

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
  80028d:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  800294:	00 
  800295:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80029c:	00 
  80029d:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8002a4:	e8 9d 0f 00 00       	call   801246 <_panic>

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
  8002e0:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  8002e7:	00 
  8002e8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002ef:	00 
  8002f0:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  8002f7:	e8 4a 0f 00 00       	call   801246 <_panic>

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
  800333:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80033a:	00 
  80033b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800342:	00 
  800343:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  80034a:	e8 f7 0e 00 00       	call   801246 <_panic>

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
  800386:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  80038d:	00 
  80038e:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800395:	00 
  800396:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  80039d:	e8 a4 0e 00 00       	call   801246 <_panic>

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
  8003fb:	c7 44 24 08 ea 21 80 	movl   $0x8021ea,0x8(%esp)
  800402:	00 
  800403:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80040a:	00 
  80040b:	c7 04 24 07 22 80 00 	movl   $0x802207,(%esp)
  800412:	e8 2f 0e 00 00       	call   801246 <_panic>

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
  8005b5:	c7 04 24 18 22 80 00 	movl   $0x802218,(%esp)
  8005bc:	e8 7e 0d 00 00       	call   80133f <cprintf>
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
  80080b:	c7 04 24 59 22 80 00 	movl   $0x802259,(%esp)
  800812:	e8 28 0b 00 00       	call   80133f <cprintf>
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
  8008f3:	c7 04 24 75 22 80 00 	movl   $0x802275,(%esp)
  8008fa:	e8 40 0a 00 00       	call   80133f <cprintf>
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
  8009ac:	c7 04 24 38 22 80 00 	movl   $0x802238,(%esp)
  8009b3:	e8 87 09 00 00       	call   80133f <cprintf>
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
  800a72:	e8 e1 01 00 00       	call   800c58 <open>
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
  800aa7:	89 c3                	mov    %eax,%ebx
  800aa9:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800aab:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800ab2:	75 11                	jne    800ac5 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800abb:	e8 f3 13 00 00       	call   801eb3 <ipc_find_env>
  800ac0:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  800ac5:	a1 04 40 80 00       	mov    0x804004,%eax
  800aca:	8b 40 48             	mov    0x48(%eax),%eax
  800acd:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800ad3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ad7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800adf:	c7 04 24 92 22 80 00 	movl   $0x802292,(%esp)
  800ae6:	e8 54 08 00 00       	call   80133f <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800aeb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800af2:	00 
  800af3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800afa:	00 
  800afb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aff:	a1 00 40 80 00       	mov    0x804000,%eax
  800b04:	89 04 24             	mov    %eax,(%esp)
  800b07:	e8 41 13 00 00       	call   801e4d <ipc_send>
	cprintf("ipc_send\n");
  800b0c:	c7 04 24 a8 22 80 00 	movl   $0x8022a8,(%esp)
  800b13:	e8 27 08 00 00       	call   80133f <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  800b18:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b1f:	00 
  800b20:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b2b:	e8 b5 12 00 00       	call   801de5 <ipc_recv>
}
  800b30:	83 c4 10             	add    $0x10,%esp
  800b33:	5b                   	pop    %ebx
  800b34:	5e                   	pop    %esi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 14             	sub    $0x14,%esp
  800b3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	8b 40 0c             	mov    0xc(%eax),%eax
  800b47:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b51:	b8 05 00 00 00       	mov    $0x5,%eax
  800b56:	e8 44 ff ff ff       	call   800a9f <fsipc>
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	85 d2                	test   %edx,%edx
  800b5f:	78 2b                	js     800b8c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b61:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b68:	00 
  800b69:	89 1c 24             	mov    %ebx,(%esp)
  800b6c:	e8 2a 0e 00 00       	call   80199b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b71:	a1 80 50 80 00       	mov    0x805080,%eax
  800b76:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b7c:	a1 84 50 80 00       	mov    0x805084,%eax
  800b81:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8c:	83 c4 14             	add    $0x14,%esp
  800b8f:	5b                   	pop    %ebx
  800b90:	5d                   	pop    %ebp
  800b91:	c3                   	ret    

00800b92 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b92:	55                   	push   %ebp
  800b93:	89 e5                	mov    %esp,%ebp
  800b95:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9b:	8b 40 0c             	mov    0xc(%eax),%eax
  800b9e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800ba3:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba8:	b8 06 00 00 00       	mov    $0x6,%eax
  800bad:	e8 ed fe ff ff       	call   800a9f <fsipc>
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 10             	sub    $0x10,%esp
  800bbc:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	8b 40 0c             	mov    0xc(%eax),%eax
  800bc5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800bca:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800bd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800bda:	e8 c0 fe ff ff       	call   800a9f <fsipc>
  800bdf:	89 c3                	mov    %eax,%ebx
  800be1:	85 c0                	test   %eax,%eax
  800be3:	78 6a                	js     800c4f <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800be5:	39 c6                	cmp    %eax,%esi
  800be7:	73 24                	jae    800c0d <devfile_read+0x59>
  800be9:	c7 44 24 0c b2 22 80 	movl   $0x8022b2,0xc(%esp)
  800bf0:	00 
  800bf1:	c7 44 24 08 b9 22 80 	movl   $0x8022b9,0x8(%esp)
  800bf8:	00 
  800bf9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800c00:	00 
  800c01:	c7 04 24 ce 22 80 00 	movl   $0x8022ce,(%esp)
  800c08:	e8 39 06 00 00       	call   801246 <_panic>
	assert(r <= PGSIZE);
  800c0d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800c12:	7e 24                	jle    800c38 <devfile_read+0x84>
  800c14:	c7 44 24 0c d9 22 80 	movl   $0x8022d9,0xc(%esp)
  800c1b:	00 
  800c1c:	c7 44 24 08 b9 22 80 	movl   $0x8022b9,0x8(%esp)
  800c23:	00 
  800c24:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800c2b:	00 
  800c2c:	c7 04 24 ce 22 80 00 	movl   $0x8022ce,(%esp)
  800c33:	e8 0e 06 00 00       	call   801246 <_panic>
	memmove(buf, &fsipcbuf, r);
  800c38:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3c:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800c43:	00 
  800c44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c47:	89 04 24             	mov    %eax,(%esp)
  800c4a:	e8 47 0f 00 00       	call   801b96 <memmove>
	return r;
}
  800c4f:	89 d8                	mov    %ebx,%eax
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	53                   	push   %ebx
  800c5c:	83 ec 24             	sub    $0x24,%esp
  800c5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c62:	89 1c 24             	mov    %ebx,(%esp)
  800c65:	e8 d6 0c 00 00       	call   801940 <strlen>
  800c6a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c6f:	7f 60                	jg     800cd1 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c74:	89 04 24             	mov    %eax,(%esp)
  800c77:	e8 1b f8 ff ff       	call   800497 <fd_alloc>
  800c7c:	89 c2                	mov    %eax,%edx
  800c7e:	85 d2                	test   %edx,%edx
  800c80:	78 54                	js     800cd6 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c86:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c8d:	e8 09 0d 00 00       	call   80199b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c95:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9d:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca2:	e8 f8 fd ff ff       	call   800a9f <fsipc>
  800ca7:	89 c3                	mov    %eax,%ebx
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	79 17                	jns    800cc4 <open+0x6c>
		fd_close(fd, 0);
  800cad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cb4:	00 
  800cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cb8:	89 04 24             	mov    %eax,(%esp)
  800cbb:	e8 12 f9 ff ff       	call   8005d2 <fd_close>
		return r;
  800cc0:	89 d8                	mov    %ebx,%eax
  800cc2:	eb 12                	jmp    800cd6 <open+0x7e>
	}
	return fd2num(fd);
  800cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc7:	89 04 24             	mov    %eax,(%esp)
  800cca:	e8 a1 f7 ff ff       	call   800470 <fd2num>
  800ccf:	eb 05                	jmp    800cd6 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800cd1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800cd6:	83 c4 24             	add    $0x24,%esp
  800cd9:	5b                   	pop    %ebx
  800cda:	5d                   	pop    %ebp
  800cdb:	c3                   	ret    
  800cdc:	66 90                	xchg   %ax,%ax
  800cde:	66 90                	xchg   %ax,%ax

00800ce0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	56                   	push   %esi
  800ce4:	53                   	push   %ebx
  800ce5:	83 ec 10             	sub    $0x10,%esp
  800ce8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cee:	89 04 24             	mov    %eax,(%esp)
  800cf1:	e8 8a f7 ff ff       	call   800480 <fd2data>
  800cf6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800cf8:	c7 44 24 04 e5 22 80 	movl   $0x8022e5,0x4(%esp)
  800cff:	00 
  800d00:	89 1c 24             	mov    %ebx,(%esp)
  800d03:	e8 93 0c 00 00       	call   80199b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800d08:	8b 46 04             	mov    0x4(%esi),%eax
  800d0b:	2b 06                	sub    (%esi),%eax
  800d0d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800d13:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d1a:	00 00 00 
	stat->st_dev = &devpipe;
  800d1d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800d24:	30 80 00 
	return 0;
}
  800d27:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2c:	83 c4 10             	add    $0x10,%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	53                   	push   %ebx
  800d37:	83 ec 14             	sub    $0x14,%esp
  800d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800d3d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d48:	e8 11 f5 ff ff       	call   80025e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800d4d:	89 1c 24             	mov    %ebx,(%esp)
  800d50:	e8 2b f7 ff ff       	call   800480 <fd2data>
  800d55:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d60:	e8 f9 f4 ff ff       	call   80025e <sys_page_unmap>
}
  800d65:	83 c4 14             	add    $0x14,%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    

00800d6b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d6b:	55                   	push   %ebp
  800d6c:	89 e5                	mov    %esp,%ebp
  800d6e:	57                   	push   %edi
  800d6f:	56                   	push   %esi
  800d70:	53                   	push   %ebx
  800d71:	83 ec 2c             	sub    $0x2c,%esp
  800d74:	89 c6                	mov    %eax,%esi
  800d76:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d79:	a1 04 40 80 00       	mov    0x804004,%eax
  800d7e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d81:	89 34 24             	mov    %esi,(%esp)
  800d84:	e8 72 11 00 00       	call   801efb <pageref>
  800d89:	89 c7                	mov    %eax,%edi
  800d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d8e:	89 04 24             	mov    %eax,(%esp)
  800d91:	e8 65 11 00 00       	call   801efb <pageref>
  800d96:	39 c7                	cmp    %eax,%edi
  800d98:	0f 94 c2             	sete   %dl
  800d9b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d9e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800da4:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800da7:	39 fb                	cmp    %edi,%ebx
  800da9:	74 21                	je     800dcc <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800dab:	84 d2                	test   %dl,%dl
  800dad:	74 ca                	je     800d79 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800daf:	8b 51 58             	mov    0x58(%ecx),%edx
  800db2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800db6:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800dbe:	c7 04 24 ec 22 80 00 	movl   $0x8022ec,(%esp)
  800dc5:	e8 75 05 00 00       	call   80133f <cprintf>
  800dca:	eb ad                	jmp    800d79 <_pipeisclosed+0xe>
	}
}
  800dcc:	83 c4 2c             	add    $0x2c,%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    

00800dd4 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800dd4:	55                   	push   %ebp
  800dd5:	89 e5                	mov    %esp,%ebp
  800dd7:	57                   	push   %edi
  800dd8:	56                   	push   %esi
  800dd9:	53                   	push   %ebx
  800dda:	83 ec 1c             	sub    $0x1c,%esp
  800ddd:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800de0:	89 34 24             	mov    %esi,(%esp)
  800de3:	e8 98 f6 ff ff       	call   800480 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800de8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dec:	74 61                	je     800e4f <devpipe_write+0x7b>
  800dee:	89 c3                	mov    %eax,%ebx
  800df0:	bf 00 00 00 00       	mov    $0x0,%edi
  800df5:	eb 4a                	jmp    800e41 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800df7:	89 da                	mov    %ebx,%edx
  800df9:	89 f0                	mov    %esi,%eax
  800dfb:	e8 6b ff ff ff       	call   800d6b <_pipeisclosed>
  800e00:	85 c0                	test   %eax,%eax
  800e02:	75 54                	jne    800e58 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800e04:	e8 8f f3 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e09:	8b 43 04             	mov    0x4(%ebx),%eax
  800e0c:	8b 0b                	mov    (%ebx),%ecx
  800e0e:	8d 51 20             	lea    0x20(%ecx),%edx
  800e11:	39 d0                	cmp    %edx,%eax
  800e13:	73 e2                	jae    800df7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800e1c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800e1f:	99                   	cltd   
  800e20:	c1 ea 1b             	shr    $0x1b,%edx
  800e23:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800e26:	83 e1 1f             	and    $0x1f,%ecx
  800e29:	29 d1                	sub    %edx,%ecx
  800e2b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800e2f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800e33:	83 c0 01             	add    $0x1,%eax
  800e36:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e39:	83 c7 01             	add    $0x1,%edi
  800e3c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e3f:	74 13                	je     800e54 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e41:	8b 43 04             	mov    0x4(%ebx),%eax
  800e44:	8b 0b                	mov    (%ebx),%ecx
  800e46:	8d 51 20             	lea    0x20(%ecx),%edx
  800e49:	39 d0                	cmp    %edx,%eax
  800e4b:	73 aa                	jae    800df7 <devpipe_write+0x23>
  800e4d:	eb c6                	jmp    800e15 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e4f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e54:	89 f8                	mov    %edi,%eax
  800e56:	eb 05                	jmp    800e5d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e5d:	83 c4 1c             	add    $0x1c,%esp
  800e60:	5b                   	pop    %ebx
  800e61:	5e                   	pop    %esi
  800e62:	5f                   	pop    %edi
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
  800e6b:	83 ec 1c             	sub    $0x1c,%esp
  800e6e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e71:	89 3c 24             	mov    %edi,(%esp)
  800e74:	e8 07 f6 ff ff       	call   800480 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e7d:	74 54                	je     800ed3 <devpipe_read+0x6e>
  800e7f:	89 c3                	mov    %eax,%ebx
  800e81:	be 00 00 00 00       	mov    $0x0,%esi
  800e86:	eb 3e                	jmp    800ec6 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e88:	89 f0                	mov    %esi,%eax
  800e8a:	eb 55                	jmp    800ee1 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e8c:	89 da                	mov    %ebx,%edx
  800e8e:	89 f8                	mov    %edi,%eax
  800e90:	e8 d6 fe ff ff       	call   800d6b <_pipeisclosed>
  800e95:	85 c0                	test   %eax,%eax
  800e97:	75 43                	jne    800edc <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e99:	e8 fa f2 ff ff       	call   800198 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e9e:	8b 03                	mov    (%ebx),%eax
  800ea0:	3b 43 04             	cmp    0x4(%ebx),%eax
  800ea3:	74 e7                	je     800e8c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ea5:	99                   	cltd   
  800ea6:	c1 ea 1b             	shr    $0x1b,%edx
  800ea9:	01 d0                	add    %edx,%eax
  800eab:	83 e0 1f             	and    $0x1f,%eax
  800eae:	29 d0                	sub    %edx,%eax
  800eb0:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800eb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb8:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800ebb:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ebe:	83 c6 01             	add    $0x1,%esi
  800ec1:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ec4:	74 12                	je     800ed8 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800ec6:	8b 03                	mov    (%ebx),%eax
  800ec8:	3b 43 04             	cmp    0x4(%ebx),%eax
  800ecb:	75 d8                	jne    800ea5 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800ecd:	85 f6                	test   %esi,%esi
  800ecf:	75 b7                	jne    800e88 <devpipe_read+0x23>
  800ed1:	eb b9                	jmp    800e8c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800ed3:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800ed8:	89 f0                	mov    %esi,%eax
  800eda:	eb 05                	jmp    800ee1 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800ee1:	83 c4 1c             	add    $0x1c,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    

00800ee9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
  800eec:	56                   	push   %esi
  800eed:	53                   	push   %ebx
  800eee:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800ef1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ef4:	89 04 24             	mov    %eax,(%esp)
  800ef7:	e8 9b f5 ff ff       	call   800497 <fd_alloc>
  800efc:	89 c2                	mov    %eax,%edx
  800efe:	85 d2                	test   %edx,%edx
  800f00:	0f 88 4d 01 00 00    	js     801053 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f0d:	00 
  800f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f1c:	e8 96 f2 ff ff       	call   8001b7 <sys_page_alloc>
  800f21:	89 c2                	mov    %eax,%edx
  800f23:	85 d2                	test   %edx,%edx
  800f25:	0f 88 28 01 00 00    	js     801053 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800f2b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f2e:	89 04 24             	mov    %eax,(%esp)
  800f31:	e8 61 f5 ff ff       	call   800497 <fd_alloc>
  800f36:	89 c3                	mov    %eax,%ebx
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	0f 88 fe 00 00 00    	js     80103e <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f40:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f47:	00 
  800f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f56:	e8 5c f2 ff ff       	call   8001b7 <sys_page_alloc>
  800f5b:	89 c3                	mov    %eax,%ebx
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	0f 88 d9 00 00 00    	js     80103e <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f68:	89 04 24             	mov    %eax,(%esp)
  800f6b:	e8 10 f5 ff ff       	call   800480 <fd2data>
  800f70:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f72:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f79:	00 
  800f7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f7e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f85:	e8 2d f2 ff ff       	call   8001b7 <sys_page_alloc>
  800f8a:	89 c3                	mov    %eax,%ebx
  800f8c:	85 c0                	test   %eax,%eax
  800f8e:	0f 88 97 00 00 00    	js     80102b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f97:	89 04 24             	mov    %eax,(%esp)
  800f9a:	e8 e1 f4 ff ff       	call   800480 <fd2data>
  800f9f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800fa6:	00 
  800fa7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800fb2:	00 
  800fb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fb7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fbe:	e8 48 f2 ff ff       	call   80020b <sys_page_map>
  800fc3:	89 c3                	mov    %eax,%ebx
  800fc5:	85 c0                	test   %eax,%eax
  800fc7:	78 52                	js     80101b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800fc9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd2:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800fde:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe7:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fec:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff6:	89 04 24             	mov    %eax,(%esp)
  800ff9:	e8 72 f4 ff ff       	call   800470 <fd2num>
  800ffe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801001:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801006:	89 04 24             	mov    %eax,(%esp)
  801009:	e8 62 f4 ff ff       	call   800470 <fd2num>
  80100e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801011:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801014:	b8 00 00 00 00       	mov    $0x0,%eax
  801019:	eb 38                	jmp    801053 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  80101b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80101f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801026:	e8 33 f2 ff ff       	call   80025e <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80102b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801032:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801039:	e8 20 f2 ff ff       	call   80025e <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	89 44 24 04          	mov    %eax,0x4(%esp)
  801045:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80104c:	e8 0d f2 ff ff       	call   80025e <sys_page_unmap>
  801051:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801053:	83 c4 30             	add    $0x30,%esp
  801056:	5b                   	pop    %ebx
  801057:	5e                   	pop    %esi
  801058:	5d                   	pop    %ebp
  801059:	c3                   	ret    

0080105a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801060:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801063:	89 44 24 04          	mov    %eax,0x4(%esp)
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	89 04 24             	mov    %eax,(%esp)
  80106d:	e8 99 f4 ff ff       	call   80050b <fd_lookup>
  801072:	89 c2                	mov    %eax,%edx
  801074:	85 d2                	test   %edx,%edx
  801076:	78 15                	js     80108d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107b:	89 04 24             	mov    %eax,(%esp)
  80107e:	e8 fd f3 ff ff       	call   800480 <fd2data>
	return _pipeisclosed(fd, p);
  801083:	89 c2                	mov    %eax,%edx
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801088:	e8 de fc ff ff       	call   800d6b <_pipeisclosed>
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    
  80108f:	90                   	nop

00801090 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801093:	b8 00 00 00 00       	mov    $0x0,%eax
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8010a0:	c7 44 24 04 04 23 80 	movl   $0x802304,0x4(%esp)
  8010a7:	00 
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	89 04 24             	mov    %eax,(%esp)
  8010ae:	e8 e8 08 00 00       	call   80199b <strcpy>
	return 0;
}
  8010b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8010b8:	c9                   	leave  
  8010b9:	c3                   	ret    

008010ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	57                   	push   %edi
  8010be:	56                   	push   %esi
  8010bf:	53                   	push   %ebx
  8010c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	74 4a                	je     801116 <devcons_write+0x5c>
  8010cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8010d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8010d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8010dc:	8b 75 10             	mov    0x10(%ebp),%esi
  8010df:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  8010e1:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8010e4:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8010e9:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8010ec:	89 74 24 08          	mov    %esi,0x8(%esp)
  8010f0:	03 45 0c             	add    0xc(%ebp),%eax
  8010f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f7:	89 3c 24             	mov    %edi,(%esp)
  8010fa:	e8 97 0a 00 00       	call   801b96 <memmove>
		sys_cputs(buf, m);
  8010ff:	89 74 24 04          	mov    %esi,0x4(%esp)
  801103:	89 3c 24             	mov    %edi,(%esp)
  801106:	e8 df ef ff ff       	call   8000ea <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80110b:	01 f3                	add    %esi,%ebx
  80110d:	89 d8                	mov    %ebx,%eax
  80110f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801112:	72 c8                	jb     8010dc <devcons_write+0x22>
  801114:	eb 05                	jmp    80111b <devcons_write+0x61>
  801116:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80112e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  801133:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801137:	75 07                	jne    801140 <devcons_read+0x18>
  801139:	eb 28                	jmp    801163 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  80113b:	e8 58 f0 ff ff       	call   800198 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801140:	e8 c3 ef ff ff       	call   800108 <sys_cgetc>
  801145:	85 c0                	test   %eax,%eax
  801147:	74 f2                	je     80113b <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  801149:	85 c0                	test   %eax,%eax
  80114b:	78 16                	js     801163 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80114d:	83 f8 04             	cmp    $0x4,%eax
  801150:	74 0c                	je     80115e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801152:	8b 55 0c             	mov    0xc(%ebp),%edx
  801155:	88 02                	mov    %al,(%edx)
	return 1;
  801157:	b8 01 00 00 00       	mov    $0x1,%eax
  80115c:	eb 05                	jmp    801163 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801163:	c9                   	leave  
  801164:	c3                   	ret    

00801165 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801171:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801178:	00 
  801179:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80117c:	89 04 24             	mov    %eax,(%esp)
  80117f:	e8 66 ef ff ff       	call   8000ea <sys_cputs>
}
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <getchar>:

int
getchar(void)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80118c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801193:	00 
  801194:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801197:	89 44 24 04          	mov    %eax,0x4(%esp)
  80119b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a2:	e8 0f f6 ff ff       	call   8007b6 <read>
	if (r < 0)
  8011a7:	85 c0                	test   %eax,%eax
  8011a9:	78 0f                	js     8011ba <getchar+0x34>
		return r;
	if (r < 1)
  8011ab:	85 c0                	test   %eax,%eax
  8011ad:	7e 06                	jle    8011b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8011af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8011b3:	eb 05                	jmp    8011ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8011b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8011ba:	c9                   	leave  
  8011bb:	c3                   	ret    

008011bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	89 04 24             	mov    %eax,(%esp)
  8011cf:	e8 37 f3 ff ff       	call   80050b <fd_lookup>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	78 11                	js     8011e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8011d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011db:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011e1:	39 10                	cmp    %edx,(%eax)
  8011e3:	0f 94 c0             	sete   %al
  8011e6:	0f b6 c0             	movzbl %al,%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    

008011eb <opencons>:

int
opencons(void)
{
  8011eb:	55                   	push   %ebp
  8011ec:	89 e5                	mov    %esp,%ebp
  8011ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f4:	89 04 24             	mov    %eax,(%esp)
  8011f7:	e8 9b f2 ff ff       	call   800497 <fd_alloc>
		return r;
  8011fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011fe:	85 c0                	test   %eax,%eax
  801200:	78 40                	js     801242 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801202:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801209:	00 
  80120a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80120d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801218:	e8 9a ef ff ff       	call   8001b7 <sys_page_alloc>
		return r;
  80121d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80121f:	85 c0                	test   %eax,%eax
  801221:	78 1f                	js     801242 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801223:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80122e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801231:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801238:	89 04 24             	mov    %eax,(%esp)
  80123b:	e8 30 f2 ff ff       	call   800470 <fd2num>
  801240:	89 c2                	mov    %eax,%edx
}
  801242:	89 d0                	mov    %edx,%eax
  801244:	c9                   	leave  
  801245:	c3                   	ret    

00801246 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801246:	55                   	push   %ebp
  801247:	89 e5                	mov    %esp,%ebp
  801249:	56                   	push   %esi
  80124a:	53                   	push   %ebx
  80124b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80124e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801251:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801257:	e8 1d ef ff ff       	call   800179 <sys_getenvid>
  80125c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80125f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801263:	8b 55 08             	mov    0x8(%ebp),%edx
  801266:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80126a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80126e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801272:	c7 04 24 10 23 80 00 	movl   $0x802310,(%esp)
  801279:	e8 c1 00 00 00       	call   80133f <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80127e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801282:	8b 45 10             	mov    0x10(%ebp),%eax
  801285:	89 04 24             	mov    %eax,(%esp)
  801288:	e8 51 00 00 00       	call   8012de <vcprintf>
	cprintf("\n");
  80128d:	c7 04 24 fd 22 80 00 	movl   $0x8022fd,(%esp)
  801294:	e8 a6 00 00 00       	call   80133f <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801299:	cc                   	int3   
  80129a:	eb fd                	jmp    801299 <_panic+0x53>

0080129c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80129c:	55                   	push   %ebp
  80129d:	89 e5                	mov    %esp,%ebp
  80129f:	53                   	push   %ebx
  8012a0:	83 ec 14             	sub    $0x14,%esp
  8012a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8012a6:	8b 13                	mov    (%ebx),%edx
  8012a8:	8d 42 01             	lea    0x1(%edx),%eax
  8012ab:	89 03                	mov    %eax,(%ebx)
  8012ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012b0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8012b4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012b9:	75 19                	jne    8012d4 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8012bb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8012c2:	00 
  8012c3:	8d 43 08             	lea    0x8(%ebx),%eax
  8012c6:	89 04 24             	mov    %eax,(%esp)
  8012c9:	e8 1c ee ff ff       	call   8000ea <sys_cputs>
		b->idx = 0;
  8012ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8012d4:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8012d8:	83 c4 14             	add    $0x14,%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5d                   	pop    %ebp
  8012dd:	c3                   	ret    

008012de <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8012de:	55                   	push   %ebp
  8012df:	89 e5                	mov    %esp,%ebp
  8012e1:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8012e7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8012ee:	00 00 00 
	b.cnt = 0;
  8012f1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8012f8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8012fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 44 24 08          	mov    %eax,0x8(%esp)
  801309:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80130f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801313:	c7 04 24 9c 12 80 00 	movl   $0x80129c,(%esp)
  80131a:	e8 b5 01 00 00       	call   8014d4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80131f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801325:	89 44 24 04          	mov    %eax,0x4(%esp)
  801329:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80132f:	89 04 24             	mov    %eax,(%esp)
  801332:	e8 b3 ed ff ff       	call   8000ea <sys_cputs>

	return b.cnt;
}
  801337:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801345:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	89 04 24             	mov    %eax,(%esp)
  801352:	e8 87 ff ff ff       	call   8012de <vcprintf>
	va_end(ap);

	return cnt;
}
  801357:	c9                   	leave  
  801358:	c3                   	ret    
  801359:	66 90                	xchg   %ax,%ax
  80135b:	66 90                	xchg   %ax,%ax
  80135d:	66 90                	xchg   %ax,%ax
  80135f:	90                   	nop

00801360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	57                   	push   %edi
  801364:	56                   	push   %esi
  801365:	53                   	push   %ebx
  801366:	83 ec 3c             	sub    $0x3c,%esp
  801369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80136c:	89 d7                	mov    %edx,%edi
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801374:	8b 75 0c             	mov    0xc(%ebp),%esi
  801377:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80137d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801382:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801385:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801388:	39 f1                	cmp    %esi,%ecx
  80138a:	72 14                	jb     8013a0 <printnum+0x40>
  80138c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80138f:	76 0f                	jbe    8013a0 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801391:	8b 45 14             	mov    0x14(%ebp),%eax
  801394:	8d 70 ff             	lea    -0x1(%eax),%esi
  801397:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80139a:	85 f6                	test   %esi,%esi
  80139c:	7f 60                	jg     8013fe <printnum+0x9e>
  80139e:	eb 72                	jmp    801412 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013a0:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8013a3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8013a7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8013aa:	8d 51 ff             	lea    -0x1(%ecx),%edx
  8013ad:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013b5:	8b 44 24 08          	mov    0x8(%esp),%eax
  8013b9:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8013bd:	89 c3                	mov    %eax,%ebx
  8013bf:	89 d6                	mov    %edx,%esi
  8013c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013c4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8013c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8013cb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8013cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013dc:	e8 5f 0b 00 00       	call   801f40 <__udivdi3>
  8013e1:	89 d9                	mov    %ebx,%ecx
  8013e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013e7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013eb:	89 04 24             	mov    %eax,(%esp)
  8013ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013f2:	89 fa                	mov    %edi,%edx
  8013f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f7:	e8 64 ff ff ff       	call   801360 <printnum>
  8013fc:	eb 14                	jmp    801412 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8013fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801402:	8b 45 18             	mov    0x18(%ebp),%eax
  801405:	89 04 24             	mov    %eax,(%esp)
  801408:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80140a:	83 ee 01             	sub    $0x1,%esi
  80140d:	75 ef                	jne    8013fe <printnum+0x9e>
  80140f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801412:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801416:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80141a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80141d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801420:	89 44 24 08          	mov    %eax,0x8(%esp)
  801424:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	89 04 24             	mov    %eax,(%esp)
  80142e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801431:	89 44 24 04          	mov    %eax,0x4(%esp)
  801435:	e8 36 0c 00 00       	call   802070 <__umoddi3>
  80143a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80143e:	0f be 80 33 23 80 00 	movsbl 0x802333(%eax),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	ff d0                	call   *%eax
}
  80144d:	83 c4 3c             	add    $0x3c,%esp
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    

00801455 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801458:	83 fa 01             	cmp    $0x1,%edx
  80145b:	7e 0e                	jle    80146b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80145d:	8b 10                	mov    (%eax),%edx
  80145f:	8d 4a 08             	lea    0x8(%edx),%ecx
  801462:	89 08                	mov    %ecx,(%eax)
  801464:	8b 02                	mov    (%edx),%eax
  801466:	8b 52 04             	mov    0x4(%edx),%edx
  801469:	eb 22                	jmp    80148d <getuint+0x38>
	else if (lflag)
  80146b:	85 d2                	test   %edx,%edx
  80146d:	74 10                	je     80147f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80146f:	8b 10                	mov    (%eax),%edx
  801471:	8d 4a 04             	lea    0x4(%edx),%ecx
  801474:	89 08                	mov    %ecx,(%eax)
  801476:	8b 02                	mov    (%edx),%eax
  801478:	ba 00 00 00 00       	mov    $0x0,%edx
  80147d:	eb 0e                	jmp    80148d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80147f:	8b 10                	mov    (%eax),%edx
  801481:	8d 4a 04             	lea    0x4(%edx),%ecx
  801484:	89 08                	mov    %ecx,(%eax)
  801486:	8b 02                	mov    (%edx),%eax
  801488:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80148d:	5d                   	pop    %ebp
  80148e:	c3                   	ret    

0080148f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801495:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801499:	8b 10                	mov    (%eax),%edx
  80149b:	3b 50 04             	cmp    0x4(%eax),%edx
  80149e:	73 0a                	jae    8014aa <sprintputch+0x1b>
		*b->buf++ = ch;
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 08                	mov    %ecx,(%eax)
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	88 02                	mov    %al,(%edx)
}
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014b2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8014b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ca:	89 04 24             	mov    %eax,(%esp)
  8014cd:	e8 02 00 00 00       	call   8014d4 <vprintfmt>
	va_end(ap);
}
  8014d2:	c9                   	leave  
  8014d3:	c3                   	ret    

008014d4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8014d4:	55                   	push   %ebp
  8014d5:	89 e5                	mov    %esp,%ebp
  8014d7:	57                   	push   %edi
  8014d8:	56                   	push   %esi
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 3c             	sub    $0x3c,%esp
  8014dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8014e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014e3:	eb 18                	jmp    8014fd <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8014e5:	85 c0                	test   %eax,%eax
  8014e7:	0f 84 c3 03 00 00    	je     8018b0 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  8014ed:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014f1:	89 04 24             	mov    %eax,(%esp)
  8014f4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014f7:	89 f3                	mov    %esi,%ebx
  8014f9:	eb 02                	jmp    8014fd <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014fb:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014fd:	8d 73 01             	lea    0x1(%ebx),%esi
  801500:	0f b6 03             	movzbl (%ebx),%eax
  801503:	83 f8 25             	cmp    $0x25,%eax
  801506:	75 dd                	jne    8014e5 <vprintfmt+0x11>
  801508:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80150c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801513:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80151a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801521:	ba 00 00 00 00       	mov    $0x0,%edx
  801526:	eb 1d                	jmp    801545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801528:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80152a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80152e:	eb 15                	jmp    801545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801530:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801532:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  801536:	eb 0d                	jmp    801545 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  801538:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80153b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80153e:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801545:	8d 5e 01             	lea    0x1(%esi),%ebx
  801548:	0f b6 06             	movzbl (%esi),%eax
  80154b:	0f b6 c8             	movzbl %al,%ecx
  80154e:	83 e8 23             	sub    $0x23,%eax
  801551:	3c 55                	cmp    $0x55,%al
  801553:	0f 87 2f 03 00 00    	ja     801888 <vprintfmt+0x3b4>
  801559:	0f b6 c0             	movzbl %al,%eax
  80155c:	ff 24 85 80 24 80 00 	jmp    *0x802480(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801563:	8d 41 d0             	lea    -0x30(%ecx),%eax
  801566:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  801569:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80156d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801570:	83 f9 09             	cmp    $0x9,%ecx
  801573:	77 50                	ja     8015c5 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801575:	89 de                	mov    %ebx,%esi
  801577:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80157a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80157d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801580:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801584:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801587:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80158a:	83 fb 09             	cmp    $0x9,%ebx
  80158d:	76 eb                	jbe    80157a <vprintfmt+0xa6>
  80158f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801592:	eb 33                	jmp    8015c7 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801594:	8b 45 14             	mov    0x14(%ebp),%eax
  801597:	8d 48 04             	lea    0x4(%eax),%ecx
  80159a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015a2:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8015a4:	eb 21                	jmp    8015c7 <vprintfmt+0xf3>
  8015a6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8015a9:	85 c9                	test   %ecx,%ecx
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b0:	0f 49 c1             	cmovns %ecx,%eax
  8015b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015b6:	89 de                	mov    %ebx,%esi
  8015b8:	eb 8b                	jmp    801545 <vprintfmt+0x71>
  8015ba:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8015bc:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8015c3:	eb 80                	jmp    801545 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015c5:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8015c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8015cb:	0f 89 74 ff ff ff    	jns    801545 <vprintfmt+0x71>
  8015d1:	e9 62 ff ff ff       	jmp    801538 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8015d6:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015d9:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8015db:	e9 65 ff ff ff       	jmp    801545 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8015e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e3:	8d 50 04             	lea    0x4(%eax),%edx
  8015e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ed:	8b 00                	mov    (%eax),%eax
  8015ef:	89 04 24             	mov    %eax,(%esp)
  8015f2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8015f5:	e9 03 ff ff ff       	jmp    8014fd <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8015fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015fd:	8d 50 04             	lea    0x4(%eax),%edx
  801600:	89 55 14             	mov    %edx,0x14(%ebp)
  801603:	8b 00                	mov    (%eax),%eax
  801605:	99                   	cltd   
  801606:	31 d0                	xor    %edx,%eax
  801608:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80160a:	83 f8 0f             	cmp    $0xf,%eax
  80160d:	7f 0b                	jg     80161a <vprintfmt+0x146>
  80160f:	8b 14 85 e0 25 80 00 	mov    0x8025e0(,%eax,4),%edx
  801616:	85 d2                	test   %edx,%edx
  801618:	75 20                	jne    80163a <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80161a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80161e:	c7 44 24 08 4b 23 80 	movl   $0x80234b,0x8(%esp)
  801625:	00 
  801626:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80162a:	8b 45 08             	mov    0x8(%ebp),%eax
  80162d:	89 04 24             	mov    %eax,(%esp)
  801630:	e8 77 fe ff ff       	call   8014ac <printfmt>
  801635:	e9 c3 fe ff ff       	jmp    8014fd <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  80163a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80163e:	c7 44 24 08 cb 22 80 	movl   $0x8022cb,0x8(%esp)
  801645:	00 
  801646:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80164a:	8b 45 08             	mov    0x8(%ebp),%eax
  80164d:	89 04 24             	mov    %eax,(%esp)
  801650:	e8 57 fe ff ff       	call   8014ac <printfmt>
  801655:	e9 a3 fe ff ff       	jmp    8014fd <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80165a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80165d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801660:	8b 45 14             	mov    0x14(%ebp),%eax
  801663:	8d 50 04             	lea    0x4(%eax),%edx
  801666:	89 55 14             	mov    %edx,0x14(%ebp)
  801669:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80166b:	85 c0                	test   %eax,%eax
  80166d:	ba 44 23 80 00       	mov    $0x802344,%edx
  801672:	0f 45 d0             	cmovne %eax,%edx
  801675:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801678:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80167c:	74 04                	je     801682 <vprintfmt+0x1ae>
  80167e:	85 f6                	test   %esi,%esi
  801680:	7f 19                	jg     80169b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801682:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801685:	8d 70 01             	lea    0x1(%eax),%esi
  801688:	0f b6 10             	movzbl (%eax),%edx
  80168b:	0f be c2             	movsbl %dl,%eax
  80168e:	85 c0                	test   %eax,%eax
  801690:	0f 85 95 00 00 00    	jne    80172b <vprintfmt+0x257>
  801696:	e9 85 00 00 00       	jmp    801720 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80169b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80169f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8016a2:	89 04 24             	mov    %eax,(%esp)
  8016a5:	e8 b8 02 00 00       	call   801962 <strnlen>
  8016aa:	29 c6                	sub    %eax,%esi
  8016ac:	89 f0                	mov    %esi,%eax
  8016ae:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8016b1:	85 f6                	test   %esi,%esi
  8016b3:	7e cd                	jle    801682 <vprintfmt+0x1ae>
					putch(padc, putdat);
  8016b5:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8016b9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016c2:	89 34 24             	mov    %esi,(%esp)
  8016c5:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8016c8:	83 eb 01             	sub    $0x1,%ebx
  8016cb:	75 f1                	jne    8016be <vprintfmt+0x1ea>
  8016cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8016d0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016d3:	eb ad                	jmp    801682 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8016d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016d9:	74 1e                	je     8016f9 <vprintfmt+0x225>
  8016db:	0f be d2             	movsbl %dl,%edx
  8016de:	83 ea 20             	sub    $0x20,%edx
  8016e1:	83 fa 5e             	cmp    $0x5e,%edx
  8016e4:	76 13                	jbe    8016f9 <vprintfmt+0x225>
					putch('?', putdat);
  8016e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ed:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8016f4:	ff 55 08             	call   *0x8(%ebp)
  8016f7:	eb 0d                	jmp    801706 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8016f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016fc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801700:	89 04 24             	mov    %eax,(%esp)
  801703:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801706:	83 ef 01             	sub    $0x1,%edi
  801709:	83 c6 01             	add    $0x1,%esi
  80170c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801710:	0f be c2             	movsbl %dl,%eax
  801713:	85 c0                	test   %eax,%eax
  801715:	75 20                	jne    801737 <vprintfmt+0x263>
  801717:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80171a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80171d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801720:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801724:	7f 25                	jg     80174b <vprintfmt+0x277>
  801726:	e9 d2 fd ff ff       	jmp    8014fd <vprintfmt+0x29>
  80172b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80172e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801731:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801734:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801737:	85 db                	test   %ebx,%ebx
  801739:	78 9a                	js     8016d5 <vprintfmt+0x201>
  80173b:	83 eb 01             	sub    $0x1,%ebx
  80173e:	79 95                	jns    8016d5 <vprintfmt+0x201>
  801740:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  801743:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801746:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801749:	eb d5                	jmp    801720 <vprintfmt+0x24c>
  80174b:	8b 75 08             	mov    0x8(%ebp),%esi
  80174e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801751:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801754:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801758:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80175f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801761:	83 eb 01             	sub    $0x1,%ebx
  801764:	75 ee                	jne    801754 <vprintfmt+0x280>
  801766:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801769:	e9 8f fd ff ff       	jmp    8014fd <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80176e:	83 fa 01             	cmp    $0x1,%edx
  801771:	7e 16                	jle    801789 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801773:	8b 45 14             	mov    0x14(%ebp),%eax
  801776:	8d 50 08             	lea    0x8(%eax),%edx
  801779:	89 55 14             	mov    %edx,0x14(%ebp)
  80177c:	8b 50 04             	mov    0x4(%eax),%edx
  80177f:	8b 00                	mov    (%eax),%eax
  801781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801784:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801787:	eb 32                	jmp    8017bb <vprintfmt+0x2e7>
	else if (lflag)
  801789:	85 d2                	test   %edx,%edx
  80178b:	74 18                	je     8017a5 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80178d:	8b 45 14             	mov    0x14(%ebp),%eax
  801790:	8d 50 04             	lea    0x4(%eax),%edx
  801793:	89 55 14             	mov    %edx,0x14(%ebp)
  801796:	8b 30                	mov    (%eax),%esi
  801798:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80179b:	89 f0                	mov    %esi,%eax
  80179d:	c1 f8 1f             	sar    $0x1f,%eax
  8017a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8017a3:	eb 16                	jmp    8017bb <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  8017a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8017a8:	8d 50 04             	lea    0x4(%eax),%edx
  8017ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8017ae:	8b 30                	mov    (%eax),%esi
  8017b0:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8017b3:	89 f0                	mov    %esi,%eax
  8017b5:	c1 f8 1f             	sar    $0x1f,%eax
  8017b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8017bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017be:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8017c1:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8017c6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8017ca:	0f 89 80 00 00 00    	jns    801850 <vprintfmt+0x37c>
				putch('-', putdat);
  8017d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017d4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8017db:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8017de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8017e4:	f7 d8                	neg    %eax
  8017e6:	83 d2 00             	adc    $0x0,%edx
  8017e9:	f7 da                	neg    %edx
			}
			base = 10;
  8017eb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017f0:	eb 5e                	jmp    801850 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8017f5:	e8 5b fc ff ff       	call   801455 <getuint>
			base = 10;
  8017fa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8017ff:	eb 4f                	jmp    801850 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801801:	8d 45 14             	lea    0x14(%ebp),%eax
  801804:	e8 4c fc ff ff       	call   801455 <getuint>
			base = 8;
  801809:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80180e:	eb 40                	jmp    801850 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801810:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801814:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80181b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80181e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801822:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801829:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80182c:	8b 45 14             	mov    0x14(%ebp),%eax
  80182f:	8d 50 04             	lea    0x4(%eax),%edx
  801832:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801835:	8b 00                	mov    (%eax),%eax
  801837:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80183c:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  801841:	eb 0d                	jmp    801850 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801843:	8d 45 14             	lea    0x14(%ebp),%eax
  801846:	e8 0a fc ff ff       	call   801455 <getuint>
			base = 16;
  80184b:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801850:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801854:	89 74 24 10          	mov    %esi,0x10(%esp)
  801858:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80185b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80185f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801863:	89 04 24             	mov    %eax,(%esp)
  801866:	89 54 24 04          	mov    %edx,0x4(%esp)
  80186a:	89 fa                	mov    %edi,%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	e8 ec fa ff ff       	call   801360 <printnum>
			break;
  801874:	e9 84 fc ff ff       	jmp    8014fd <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801879:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80187d:	89 0c 24             	mov    %ecx,(%esp)
  801880:	ff 55 08             	call   *0x8(%ebp)
			break;
  801883:	e9 75 fc ff ff       	jmp    8014fd <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801888:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80188c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801893:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801896:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80189a:	0f 84 5b fc ff ff    	je     8014fb <vprintfmt+0x27>
  8018a0:	89 f3                	mov    %esi,%ebx
  8018a2:	83 eb 01             	sub    $0x1,%ebx
  8018a5:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8018a9:	75 f7                	jne    8018a2 <vprintfmt+0x3ce>
  8018ab:	e9 4d fc ff ff       	jmp    8014fd <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  8018b0:	83 c4 3c             	add    $0x3c,%esp
  8018b3:	5b                   	pop    %ebx
  8018b4:	5e                   	pop    %esi
  8018b5:	5f                   	pop    %edi
  8018b6:	5d                   	pop    %ebp
  8018b7:	c3                   	ret    

008018b8 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 28             	sub    $0x28,%esp
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018c7:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8018cb:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	74 30                	je     801909 <vsnprintf+0x51>
  8018d9:	85 d2                	test   %edx,%edx
  8018db:	7e 2c                	jle    801909 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f2:	c7 04 24 8f 14 80 00 	movl   $0x80148f,(%esp)
  8018f9:	e8 d6 fb ff ff       	call   8014d4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8018fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801901:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801907:	eb 05                	jmp    80190e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801909:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801916:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801919:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80191d:	8b 45 10             	mov    0x10(%ebp),%eax
  801920:	89 44 24 08          	mov    %eax,0x8(%esp)
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 82 ff ff ff       	call   8018b8 <vsnprintf>
	va_end(ap);

	return rc;
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    
  801938:	66 90                	xchg   %ax,%ax
  80193a:	66 90                	xchg   %ax,%ax
  80193c:	66 90                	xchg   %ax,%ax
  80193e:	66 90                	xchg   %ax,%ax

00801940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
  801943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801946:	80 3a 00             	cmpb   $0x0,(%edx)
  801949:	74 10                	je     80195b <strlen+0x1b>
  80194b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801950:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801957:	75 f7                	jne    801950 <strlen+0x10>
  801959:	eb 05                	jmp    801960 <strlen+0x20>
  80195b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801960:	5d                   	pop    %ebp
  801961:	c3                   	ret    

00801962 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	53                   	push   %ebx
  801966:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80196c:	85 c9                	test   %ecx,%ecx
  80196e:	74 1c                	je     80198c <strnlen+0x2a>
  801970:	80 3b 00             	cmpb   $0x0,(%ebx)
  801973:	74 1e                	je     801993 <strnlen+0x31>
  801975:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80197a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80197c:	39 ca                	cmp    %ecx,%edx
  80197e:	74 18                	je     801998 <strnlen+0x36>
  801980:	83 c2 01             	add    $0x1,%edx
  801983:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801988:	75 f0                	jne    80197a <strnlen+0x18>
  80198a:	eb 0c                	jmp    801998 <strnlen+0x36>
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
  801991:	eb 05                	jmp    801998 <strnlen+0x36>
  801993:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801998:	5b                   	pop    %ebx
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8019a5:	89 c2                	mov    %eax,%edx
  8019a7:	83 c2 01             	add    $0x1,%edx
  8019aa:	83 c1 01             	add    $0x1,%ecx
  8019ad:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8019b1:	88 5a ff             	mov    %bl,-0x1(%edx)
  8019b4:	84 db                	test   %bl,%bl
  8019b6:	75 ef                	jne    8019a7 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8019b8:	5b                   	pop    %ebx
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <strcat>:

char *
strcat(char *dst, const char *src)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8019c5:	89 1c 24             	mov    %ebx,(%esp)
  8019c8:	e8 73 ff ff ff       	call   801940 <strlen>
	strcpy(dst + len, src);
  8019cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d4:	01 d8                	add    %ebx,%eax
  8019d6:	89 04 24             	mov    %eax,(%esp)
  8019d9:	e8 bd ff ff ff       	call   80199b <strcpy>
	return dst;
}
  8019de:	89 d8                	mov    %ebx,%eax
  8019e0:	83 c4 08             	add    $0x8,%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    

008019e6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	56                   	push   %esi
  8019ea:	53                   	push   %ebx
  8019eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8019ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019f4:	85 db                	test   %ebx,%ebx
  8019f6:	74 17                	je     801a0f <strncpy+0x29>
  8019f8:	01 f3                	add    %esi,%ebx
  8019fa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8019fc:	83 c1 01             	add    $0x1,%ecx
  8019ff:	0f b6 02             	movzbl (%edx),%eax
  801a02:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801a05:	80 3a 01             	cmpb   $0x1,(%edx)
  801a08:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801a0b:	39 d9                	cmp    %ebx,%ecx
  801a0d:	75 ed                	jne    8019fc <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  801a0f:	89 f0                	mov    %esi,%eax
  801a11:	5b                   	pop    %ebx
  801a12:	5e                   	pop    %esi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	57                   	push   %edi
  801a19:	56                   	push   %esi
  801a1a:	53                   	push   %ebx
  801a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a1e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a21:	8b 75 10             	mov    0x10(%ebp),%esi
  801a24:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801a26:	85 f6                	test   %esi,%esi
  801a28:	74 34                	je     801a5e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  801a2a:	83 fe 01             	cmp    $0x1,%esi
  801a2d:	74 26                	je     801a55 <strlcpy+0x40>
  801a2f:	0f b6 0b             	movzbl (%ebx),%ecx
  801a32:	84 c9                	test   %cl,%cl
  801a34:	74 23                	je     801a59 <strlcpy+0x44>
  801a36:	83 ee 02             	sub    $0x2,%esi
  801a39:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  801a3e:	83 c0 01             	add    $0x1,%eax
  801a41:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801a44:	39 f2                	cmp    %esi,%edx
  801a46:	74 13                	je     801a5b <strlcpy+0x46>
  801a48:	83 c2 01             	add    $0x1,%edx
  801a4b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  801a4f:	84 c9                	test   %cl,%cl
  801a51:	75 eb                	jne    801a3e <strlcpy+0x29>
  801a53:	eb 06                	jmp    801a5b <strlcpy+0x46>
  801a55:	89 f8                	mov    %edi,%eax
  801a57:	eb 02                	jmp    801a5b <strlcpy+0x46>
  801a59:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  801a5b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a5e:	29 f8                	sub    %edi,%eax
}
  801a60:	5b                   	pop    %ebx
  801a61:	5e                   	pop    %esi
  801a62:	5f                   	pop    %edi
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a6e:	0f b6 01             	movzbl (%ecx),%eax
  801a71:	84 c0                	test   %al,%al
  801a73:	74 15                	je     801a8a <strcmp+0x25>
  801a75:	3a 02                	cmp    (%edx),%al
  801a77:	75 11                	jne    801a8a <strcmp+0x25>
		p++, q++;
  801a79:	83 c1 01             	add    $0x1,%ecx
  801a7c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a7f:	0f b6 01             	movzbl (%ecx),%eax
  801a82:	84 c0                	test   %al,%al
  801a84:	74 04                	je     801a8a <strcmp+0x25>
  801a86:	3a 02                	cmp    (%edx),%al
  801a88:	74 ef                	je     801a79 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a8a:	0f b6 c0             	movzbl %al,%eax
  801a8d:	0f b6 12             	movzbl (%edx),%edx
  801a90:	29 d0                	sub    %edx,%eax
}
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    

00801a94 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801aa2:	85 f6                	test   %esi,%esi
  801aa4:	74 29                	je     801acf <strncmp+0x3b>
  801aa6:	0f b6 03             	movzbl (%ebx),%eax
  801aa9:	84 c0                	test   %al,%al
  801aab:	74 30                	je     801add <strncmp+0x49>
  801aad:	3a 02                	cmp    (%edx),%al
  801aaf:	75 2c                	jne    801add <strncmp+0x49>
  801ab1:	8d 43 01             	lea    0x1(%ebx),%eax
  801ab4:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801ab6:	89 c3                	mov    %eax,%ebx
  801ab8:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801abb:	39 f0                	cmp    %esi,%eax
  801abd:	74 17                	je     801ad6 <strncmp+0x42>
  801abf:	0f b6 08             	movzbl (%eax),%ecx
  801ac2:	84 c9                	test   %cl,%cl
  801ac4:	74 17                	je     801add <strncmp+0x49>
  801ac6:	83 c0 01             	add    $0x1,%eax
  801ac9:	3a 0a                	cmp    (%edx),%cl
  801acb:	74 e9                	je     801ab6 <strncmp+0x22>
  801acd:	eb 0e                	jmp    801add <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801acf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad4:	eb 0f                	jmp    801ae5 <strncmp+0x51>
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 08                	jmp    801ae5 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801add:	0f b6 03             	movzbl (%ebx),%eax
  801ae0:	0f b6 12             	movzbl (%edx),%edx
  801ae3:	29 d0                	sub    %edx,%eax
}
  801ae5:	5b                   	pop    %ebx
  801ae6:	5e                   	pop    %esi
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	53                   	push   %ebx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801af3:	0f b6 18             	movzbl (%eax),%ebx
  801af6:	84 db                	test   %bl,%bl
  801af8:	74 1d                	je     801b17 <strchr+0x2e>
  801afa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801afc:	38 d3                	cmp    %dl,%bl
  801afe:	75 06                	jne    801b06 <strchr+0x1d>
  801b00:	eb 1a                	jmp    801b1c <strchr+0x33>
  801b02:	38 ca                	cmp    %cl,%dl
  801b04:	74 16                	je     801b1c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801b06:	83 c0 01             	add    $0x1,%eax
  801b09:	0f b6 10             	movzbl (%eax),%edx
  801b0c:	84 d2                	test   %dl,%dl
  801b0e:	75 f2                	jne    801b02 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
  801b15:	eb 05                	jmp    801b1c <strchr+0x33>
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1c:	5b                   	pop    %ebx
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	53                   	push   %ebx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801b29:	0f b6 18             	movzbl (%eax),%ebx
  801b2c:	84 db                	test   %bl,%bl
  801b2e:	74 16                	je     801b46 <strfind+0x27>
  801b30:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801b32:	38 d3                	cmp    %dl,%bl
  801b34:	75 06                	jne    801b3c <strfind+0x1d>
  801b36:	eb 0e                	jmp    801b46 <strfind+0x27>
  801b38:	38 ca                	cmp    %cl,%dl
  801b3a:	74 0a                	je     801b46 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801b3c:	83 c0 01             	add    $0x1,%eax
  801b3f:	0f b6 10             	movzbl (%eax),%edx
  801b42:	84 d2                	test   %dl,%dl
  801b44:	75 f2                	jne    801b38 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801b46:	5b                   	pop    %ebx
  801b47:	5d                   	pop    %ebp
  801b48:	c3                   	ret    

00801b49 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	57                   	push   %edi
  801b4d:	56                   	push   %esi
  801b4e:	53                   	push   %ebx
  801b4f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b52:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b55:	85 c9                	test   %ecx,%ecx
  801b57:	74 36                	je     801b8f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b59:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b5f:	75 28                	jne    801b89 <memset+0x40>
  801b61:	f6 c1 03             	test   $0x3,%cl
  801b64:	75 23                	jne    801b89 <memset+0x40>
		c &= 0xFF;
  801b66:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b6a:	89 d3                	mov    %edx,%ebx
  801b6c:	c1 e3 08             	shl    $0x8,%ebx
  801b6f:	89 d6                	mov    %edx,%esi
  801b71:	c1 e6 18             	shl    $0x18,%esi
  801b74:	89 d0                	mov    %edx,%eax
  801b76:	c1 e0 10             	shl    $0x10,%eax
  801b79:	09 f0                	or     %esi,%eax
  801b7b:	09 c2                	or     %eax,%edx
  801b7d:	89 d0                	mov    %edx,%eax
  801b7f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b81:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b84:	fc                   	cld    
  801b85:	f3 ab                	rep stos %eax,%es:(%edi)
  801b87:	eb 06                	jmp    801b8f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8c:	fc                   	cld    
  801b8d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b8f:	89 f8                	mov    %edi,%eax
  801b91:	5b                   	pop    %ebx
  801b92:	5e                   	pop    %esi
  801b93:	5f                   	pop    %edi
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    

00801b96 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	57                   	push   %edi
  801b9a:	56                   	push   %esi
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801ba4:	39 c6                	cmp    %eax,%esi
  801ba6:	73 35                	jae    801bdd <memmove+0x47>
  801ba8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801bab:	39 d0                	cmp    %edx,%eax
  801bad:	73 2e                	jae    801bdd <memmove+0x47>
		s += n;
		d += n;
  801baf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801bb2:	89 d6                	mov    %edx,%esi
  801bb4:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801bb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801bbc:	75 13                	jne    801bd1 <memmove+0x3b>
  801bbe:	f6 c1 03             	test   $0x3,%cl
  801bc1:	75 0e                	jne    801bd1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801bc3:	83 ef 04             	sub    $0x4,%edi
  801bc6:	8d 72 fc             	lea    -0x4(%edx),%esi
  801bc9:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801bcc:	fd                   	std    
  801bcd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bcf:	eb 09                	jmp    801bda <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801bd1:	83 ef 01             	sub    $0x1,%edi
  801bd4:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801bd7:	fd                   	std    
  801bd8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801bda:	fc                   	cld    
  801bdb:	eb 1d                	jmp    801bfa <memmove+0x64>
  801bdd:	89 f2                	mov    %esi,%edx
  801bdf:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801be1:	f6 c2 03             	test   $0x3,%dl
  801be4:	75 0f                	jne    801bf5 <memmove+0x5f>
  801be6:	f6 c1 03             	test   $0x3,%cl
  801be9:	75 0a                	jne    801bf5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801beb:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801bee:	89 c7                	mov    %eax,%edi
  801bf0:	fc                   	cld    
  801bf1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801bf3:	eb 05                	jmp    801bfa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801bf5:	89 c7                	mov    %eax,%edi
  801bf7:	fc                   	cld    
  801bf8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801bfa:	5e                   	pop    %esi
  801bfb:	5f                   	pop    %edi
  801bfc:	5d                   	pop    %ebp
  801bfd:	c3                   	ret    

00801bfe <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801c04:	8b 45 10             	mov    0x10(%ebp),%eax
  801c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	8b 45 08             	mov    0x8(%ebp),%eax
  801c15:	89 04 24             	mov    %eax,(%esp)
  801c18:	e8 79 ff ff ff       	call   801b96 <memmove>
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	57                   	push   %edi
  801c23:	56                   	push   %esi
  801c24:	53                   	push   %ebx
  801c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c28:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c2b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c2e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801c31:	85 c0                	test   %eax,%eax
  801c33:	74 36                	je     801c6b <memcmp+0x4c>
		if (*s1 != *s2)
  801c35:	0f b6 03             	movzbl (%ebx),%eax
  801c38:	0f b6 0e             	movzbl (%esi),%ecx
  801c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c40:	38 c8                	cmp    %cl,%al
  801c42:	74 1c                	je     801c60 <memcmp+0x41>
  801c44:	eb 10                	jmp    801c56 <memcmp+0x37>
  801c46:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801c4b:	83 c2 01             	add    $0x1,%edx
  801c4e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c52:	38 c8                	cmp    %cl,%al
  801c54:	74 0a                	je     801c60 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801c56:	0f b6 c0             	movzbl %al,%eax
  801c59:	0f b6 c9             	movzbl %cl,%ecx
  801c5c:	29 c8                	sub    %ecx,%eax
  801c5e:	eb 10                	jmp    801c70 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c60:	39 fa                	cmp    %edi,%edx
  801c62:	75 e2                	jne    801c46 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
  801c69:	eb 05                	jmp    801c70 <memcmp+0x51>
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5f                   	pop    %edi
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    

00801c75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	53                   	push   %ebx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801c7f:	89 c2                	mov    %eax,%edx
  801c81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c84:	39 d0                	cmp    %edx,%eax
  801c86:	73 13                	jae    801c9b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c88:	89 d9                	mov    %ebx,%ecx
  801c8a:	38 18                	cmp    %bl,(%eax)
  801c8c:	75 06                	jne    801c94 <memfind+0x1f>
  801c8e:	eb 0b                	jmp    801c9b <memfind+0x26>
  801c90:	38 08                	cmp    %cl,(%eax)
  801c92:	74 07                	je     801c9b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c94:	83 c0 01             	add    $0x1,%eax
  801c97:	39 d0                	cmp    %edx,%eax
  801c99:	75 f5                	jne    801c90 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c9b:	5b                   	pop    %ebx
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca7:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801caa:	0f b6 0a             	movzbl (%edx),%ecx
  801cad:	80 f9 09             	cmp    $0x9,%cl
  801cb0:	74 05                	je     801cb7 <strtol+0x19>
  801cb2:	80 f9 20             	cmp    $0x20,%cl
  801cb5:	75 10                	jne    801cc7 <strtol+0x29>
		s++;
  801cb7:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801cba:	0f b6 0a             	movzbl (%edx),%ecx
  801cbd:	80 f9 09             	cmp    $0x9,%cl
  801cc0:	74 f5                	je     801cb7 <strtol+0x19>
  801cc2:	80 f9 20             	cmp    $0x20,%cl
  801cc5:	74 f0                	je     801cb7 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801cc7:	80 f9 2b             	cmp    $0x2b,%cl
  801cca:	75 0a                	jne    801cd6 <strtol+0x38>
		s++;
  801ccc:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801ccf:	bf 00 00 00 00       	mov    $0x0,%edi
  801cd4:	eb 11                	jmp    801ce7 <strtol+0x49>
  801cd6:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801cdb:	80 f9 2d             	cmp    $0x2d,%cl
  801cde:	75 07                	jne    801ce7 <strtol+0x49>
		s++, neg = 1;
  801ce0:	83 c2 01             	add    $0x1,%edx
  801ce3:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ce7:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801cec:	75 15                	jne    801d03 <strtol+0x65>
  801cee:	80 3a 30             	cmpb   $0x30,(%edx)
  801cf1:	75 10                	jne    801d03 <strtol+0x65>
  801cf3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801cf7:	75 0a                	jne    801d03 <strtol+0x65>
		s += 2, base = 16;
  801cf9:	83 c2 02             	add    $0x2,%edx
  801cfc:	b8 10 00 00 00       	mov    $0x10,%eax
  801d01:	eb 10                	jmp    801d13 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801d03:	85 c0                	test   %eax,%eax
  801d05:	75 0c                	jne    801d13 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801d07:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801d09:	80 3a 30             	cmpb   $0x30,(%edx)
  801d0c:	75 05                	jne    801d13 <strtol+0x75>
		s++, base = 8;
  801d0e:	83 c2 01             	add    $0x1,%edx
  801d11:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801d13:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d18:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801d1b:	0f b6 0a             	movzbl (%edx),%ecx
  801d1e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801d21:	89 f0                	mov    %esi,%eax
  801d23:	3c 09                	cmp    $0x9,%al
  801d25:	77 08                	ja     801d2f <strtol+0x91>
			dig = *s - '0';
  801d27:	0f be c9             	movsbl %cl,%ecx
  801d2a:	83 e9 30             	sub    $0x30,%ecx
  801d2d:	eb 20                	jmp    801d4f <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801d2f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801d32:	89 f0                	mov    %esi,%eax
  801d34:	3c 19                	cmp    $0x19,%al
  801d36:	77 08                	ja     801d40 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801d38:	0f be c9             	movsbl %cl,%ecx
  801d3b:	83 e9 57             	sub    $0x57,%ecx
  801d3e:	eb 0f                	jmp    801d4f <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801d40:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801d43:	89 f0                	mov    %esi,%eax
  801d45:	3c 19                	cmp    $0x19,%al
  801d47:	77 16                	ja     801d5f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801d49:	0f be c9             	movsbl %cl,%ecx
  801d4c:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801d4f:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801d52:	7d 0f                	jge    801d63 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801d54:	83 c2 01             	add    $0x1,%edx
  801d57:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801d5b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801d5d:	eb bc                	jmp    801d1b <strtol+0x7d>
  801d5f:	89 d8                	mov    %ebx,%eax
  801d61:	eb 02                	jmp    801d65 <strtol+0xc7>
  801d63:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d69:	74 05                	je     801d70 <strtol+0xd2>
		*endptr = (char *) s;
  801d6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d6e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801d70:	f7 d8                	neg    %eax
  801d72:	85 ff                	test   %edi,%edi
  801d74:	0f 44 c3             	cmove  %ebx,%eax
}
  801d77:	5b                   	pop    %ebx
  801d78:	5e                   	pop    %esi
  801d79:	5f                   	pop    %edi
  801d7a:	5d                   	pop    %ebp
  801d7b:	c3                   	ret    

00801d7c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
  801d7f:	83 ec 18             	sub    $0x18,%esp
	int r;
	if (_pgfault_handler == 0) {
  801d82:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801d89:	75 50                	jne    801ddb <set_pgfault_handler+0x5f>
		// First time through!
		if ((r = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0) {
  801d8b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d92:	00 
  801d93:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801d9a:	ee 
  801d9b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da2:	e8 10 e4 ff ff       	call   8001b7 <sys_page_alloc>
  801da7:	85 c0                	test   %eax,%eax
  801da9:	79 1c                	jns    801dc7 <set_pgfault_handler+0x4b>
			panic("set_pgfault_handler: sys_page_alloc");
  801dab:	c7 44 24 08 40 26 80 	movl   $0x802640,0x8(%esp)
  801db2:	00 
  801db3:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801dba:	00 
  801dbb:	c7 04 24 64 26 80 00 	movl   $0x802664,(%esp)
  801dc2:	e8 7f f4 ff ff       	call   801246 <_panic>
		}
		sys_env_set_pgfault_upcall(0, _pgfault_upcall);
  801dc7:	c7 44 24 04 1f 04 80 	movl   $0x80041f,0x4(%esp)
  801dce:	00 
  801dcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd6:	e8 7c e5 ff ff       	call   800357 <sys_env_set_pgfault_upcall>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	56                   	push   %esi
  801de9:	53                   	push   %ebx
  801dea:	83 ec 10             	sub    $0x10,%esp
  801ded:	8b 75 08             	mov    0x8(%ebp),%esi
  801df0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801df6:	85 c0                	test   %eax,%eax
  801df8:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801dfd:	0f 44 c2             	cmove  %edx,%eax
  801e00:	89 04 24             	mov    %eax,(%esp)
  801e03:	e8 c5 e5 ff ff       	call   8003cd <sys_ipc_recv>
	if (err_code < 0) {
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	79 16                	jns    801e22 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801e0c:	85 f6                	test   %esi,%esi
  801e0e:	74 06                	je     801e16 <ipc_recv+0x31>
  801e10:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801e16:	85 db                	test   %ebx,%ebx
  801e18:	74 2c                	je     801e46 <ipc_recv+0x61>
  801e1a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801e20:	eb 24                	jmp    801e46 <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801e22:	85 f6                	test   %esi,%esi
  801e24:	74 0a                	je     801e30 <ipc_recv+0x4b>
  801e26:	a1 04 40 80 00       	mov    0x804004,%eax
  801e2b:	8b 40 74             	mov    0x74(%eax),%eax
  801e2e:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801e30:	85 db                	test   %ebx,%ebx
  801e32:	74 0a                	je     801e3e <ipc_recv+0x59>
  801e34:	a1 04 40 80 00       	mov    0x804004,%eax
  801e39:	8b 40 78             	mov    0x78(%eax),%eax
  801e3c:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801e3e:	a1 04 40 80 00       	mov    0x804004,%eax
  801e43:	8b 40 70             	mov    0x70(%eax),%eax
}
  801e46:	83 c4 10             	add    $0x10,%esp
  801e49:	5b                   	pop    %ebx
  801e4a:	5e                   	pop    %esi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    

00801e4d <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	57                   	push   %edi
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	83 ec 1c             	sub    $0x1c,%esp
  801e56:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e59:	8b 75 0c             	mov    0xc(%ebp),%esi
  801e5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e5f:	eb 25                	jmp    801e86 <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801e61:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e64:	74 20                	je     801e86 <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801e66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6a:	c7 44 24 08 72 26 80 	movl   $0x802672,0x8(%esp)
  801e71:	00 
  801e72:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801e79:	00 
  801e7a:	c7 04 24 7e 26 80 00 	movl   $0x80267e,(%esp)
  801e81:	e8 c0 f3 ff ff       	call   801246 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801e86:	85 db                	test   %ebx,%ebx
  801e88:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801e8d:	0f 45 c3             	cmovne %ebx,%eax
  801e90:	8b 55 14             	mov    0x14(%ebp),%edx
  801e93:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801e97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e9f:	89 3c 24             	mov    %edi,(%esp)
  801ea2:	e8 03 e5 ff ff       	call   8003aa <sys_ipc_try_send>
  801ea7:	85 c0                	test   %eax,%eax
  801ea9:	75 b6                	jne    801e61 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801eab:	83 c4 1c             	add    $0x1c,%esp
  801eae:	5b                   	pop    %ebx
  801eaf:	5e                   	pop    %esi
  801eb0:	5f                   	pop    %edi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    

00801eb3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801eb9:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801ebe:	39 c8                	cmp    %ecx,%eax
  801ec0:	74 17                	je     801ed9 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ec2:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801ec7:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801eca:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801ed0:	8b 52 50             	mov    0x50(%edx),%edx
  801ed3:	39 ca                	cmp    %ecx,%edx
  801ed5:	75 14                	jne    801eeb <ipc_find_env+0x38>
  801ed7:	eb 05                	jmp    801ede <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801ede:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801ee1:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ee6:	8b 40 40             	mov    0x40(%eax),%eax
  801ee9:	eb 0e                	jmp    801ef9 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801eeb:	83 c0 01             	add    $0x1,%eax
  801eee:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ef3:	75 d2                	jne    801ec7 <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801ef5:	66 b8 00 00          	mov    $0x0,%ax
}
  801ef9:	5d                   	pop    %ebp
  801efa:	c3                   	ret    

00801efb <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f01:	89 d0                	mov    %edx,%eax
  801f03:	c1 e8 16             	shr    $0x16,%eax
  801f06:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801f12:	f6 c1 01             	test   $0x1,%cl
  801f15:	74 1d                	je     801f34 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801f17:	c1 ea 0c             	shr    $0xc,%edx
  801f1a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801f21:	f6 c2 01             	test   $0x1,%dl
  801f24:	74 0e                	je     801f34 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801f26:	c1 ea 0c             	shr    $0xc,%edx
  801f29:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801f30:	ef 
  801f31:	0f b7 c0             	movzwl %ax,%eax
}
  801f34:	5d                   	pop    %ebp
  801f35:	c3                   	ret    
  801f36:	66 90                	xchg   %ax,%ax
  801f38:	66 90                	xchg   %ax,%ax
  801f3a:	66 90                	xchg   %ax,%ax
  801f3c:	66 90                	xchg   %ax,%ax
  801f3e:	66 90                	xchg   %ax,%ax

00801f40 <__udivdi3>:
  801f40:	55                   	push   %ebp
  801f41:	57                   	push   %edi
  801f42:	56                   	push   %esi
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801f4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801f52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f56:	85 c0                	test   %eax,%eax
  801f58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801f5c:	89 ea                	mov    %ebp,%edx
  801f5e:	89 0c 24             	mov    %ecx,(%esp)
  801f61:	75 2d                	jne    801f90 <__udivdi3+0x50>
  801f63:	39 e9                	cmp    %ebp,%ecx
  801f65:	77 61                	ja     801fc8 <__udivdi3+0x88>
  801f67:	85 c9                	test   %ecx,%ecx
  801f69:	89 ce                	mov    %ecx,%esi
  801f6b:	75 0b                	jne    801f78 <__udivdi3+0x38>
  801f6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f72:	31 d2                	xor    %edx,%edx
  801f74:	f7 f1                	div    %ecx
  801f76:	89 c6                	mov    %eax,%esi
  801f78:	31 d2                	xor    %edx,%edx
  801f7a:	89 e8                	mov    %ebp,%eax
  801f7c:	f7 f6                	div    %esi
  801f7e:	89 c5                	mov    %eax,%ebp
  801f80:	89 f8                	mov    %edi,%eax
  801f82:	f7 f6                	div    %esi
  801f84:	89 ea                	mov    %ebp,%edx
  801f86:	83 c4 0c             	add    $0xc,%esp
  801f89:	5e                   	pop    %esi
  801f8a:	5f                   	pop    %edi
  801f8b:	5d                   	pop    %ebp
  801f8c:	c3                   	ret    
  801f8d:	8d 76 00             	lea    0x0(%esi),%esi
  801f90:	39 e8                	cmp    %ebp,%eax
  801f92:	77 24                	ja     801fb8 <__udivdi3+0x78>
  801f94:	0f bd e8             	bsr    %eax,%ebp
  801f97:	83 f5 1f             	xor    $0x1f,%ebp
  801f9a:	75 3c                	jne    801fd8 <__udivdi3+0x98>
  801f9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801fa0:	39 34 24             	cmp    %esi,(%esp)
  801fa3:	0f 86 9f 00 00 00    	jbe    802048 <__udivdi3+0x108>
  801fa9:	39 d0                	cmp    %edx,%eax
  801fab:	0f 82 97 00 00 00    	jb     802048 <__udivdi3+0x108>
  801fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801fb8:	31 d2                	xor    %edx,%edx
  801fba:	31 c0                	xor    %eax,%eax
  801fbc:	83 c4 0c             	add    $0xc,%esp
  801fbf:	5e                   	pop    %esi
  801fc0:	5f                   	pop    %edi
  801fc1:	5d                   	pop    %ebp
  801fc2:	c3                   	ret    
  801fc3:	90                   	nop
  801fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801fc8:	89 f8                	mov    %edi,%eax
  801fca:	f7 f1                	div    %ecx
  801fcc:	31 d2                	xor    %edx,%edx
  801fce:	83 c4 0c             	add    $0xc,%esp
  801fd1:	5e                   	pop    %esi
  801fd2:	5f                   	pop    %edi
  801fd3:	5d                   	pop    %ebp
  801fd4:	c3                   	ret    
  801fd5:	8d 76 00             	lea    0x0(%esi),%esi
  801fd8:	89 e9                	mov    %ebp,%ecx
  801fda:	8b 3c 24             	mov    (%esp),%edi
  801fdd:	d3 e0                	shl    %cl,%eax
  801fdf:	89 c6                	mov    %eax,%esi
  801fe1:	b8 20 00 00 00       	mov    $0x20,%eax
  801fe6:	29 e8                	sub    %ebp,%eax
  801fe8:	89 c1                	mov    %eax,%ecx
  801fea:	d3 ef                	shr    %cl,%edi
  801fec:	89 e9                	mov    %ebp,%ecx
  801fee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ff2:	8b 3c 24             	mov    (%esp),%edi
  801ff5:	09 74 24 08          	or     %esi,0x8(%esp)
  801ff9:	89 d6                	mov    %edx,%esi
  801ffb:	d3 e7                	shl    %cl,%edi
  801ffd:	89 c1                	mov    %eax,%ecx
  801fff:	89 3c 24             	mov    %edi,(%esp)
  802002:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802006:	d3 ee                	shr    %cl,%esi
  802008:	89 e9                	mov    %ebp,%ecx
  80200a:	d3 e2                	shl    %cl,%edx
  80200c:	89 c1                	mov    %eax,%ecx
  80200e:	d3 ef                	shr    %cl,%edi
  802010:	09 d7                	or     %edx,%edi
  802012:	89 f2                	mov    %esi,%edx
  802014:	89 f8                	mov    %edi,%eax
  802016:	f7 74 24 08          	divl   0x8(%esp)
  80201a:	89 d6                	mov    %edx,%esi
  80201c:	89 c7                	mov    %eax,%edi
  80201e:	f7 24 24             	mull   (%esp)
  802021:	39 d6                	cmp    %edx,%esi
  802023:	89 14 24             	mov    %edx,(%esp)
  802026:	72 30                	jb     802058 <__udivdi3+0x118>
  802028:	8b 54 24 04          	mov    0x4(%esp),%edx
  80202c:	89 e9                	mov    %ebp,%ecx
  80202e:	d3 e2                	shl    %cl,%edx
  802030:	39 c2                	cmp    %eax,%edx
  802032:	73 05                	jae    802039 <__udivdi3+0xf9>
  802034:	3b 34 24             	cmp    (%esp),%esi
  802037:	74 1f                	je     802058 <__udivdi3+0x118>
  802039:	89 f8                	mov    %edi,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	e9 7a ff ff ff       	jmp    801fbc <__udivdi3+0x7c>
  802042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802048:	31 d2                	xor    %edx,%edx
  80204a:	b8 01 00 00 00       	mov    $0x1,%eax
  80204f:	e9 68 ff ff ff       	jmp    801fbc <__udivdi3+0x7c>
  802054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802058:	8d 47 ff             	lea    -0x1(%edi),%eax
  80205b:	31 d2                	xor    %edx,%edx
  80205d:	83 c4 0c             	add    $0xc,%esp
  802060:	5e                   	pop    %esi
  802061:	5f                   	pop    %edi
  802062:	5d                   	pop    %ebp
  802063:	c3                   	ret    
  802064:	66 90                	xchg   %ax,%ax
  802066:	66 90                	xchg   %ax,%ax
  802068:	66 90                	xchg   %ax,%ax
  80206a:	66 90                	xchg   %ax,%ax
  80206c:	66 90                	xchg   %ax,%ax
  80206e:	66 90                	xchg   %ax,%ax

00802070 <__umoddi3>:
  802070:	55                   	push   %ebp
  802071:	57                   	push   %edi
  802072:	56                   	push   %esi
  802073:	83 ec 14             	sub    $0x14,%esp
  802076:	8b 44 24 28          	mov    0x28(%esp),%eax
  80207a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80207e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802082:	89 c7                	mov    %eax,%edi
  802084:	89 44 24 04          	mov    %eax,0x4(%esp)
  802088:	8b 44 24 30          	mov    0x30(%esp),%eax
  80208c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802090:	89 34 24             	mov    %esi,(%esp)
  802093:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802097:	85 c0                	test   %eax,%eax
  802099:	89 c2                	mov    %eax,%edx
  80209b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80209f:	75 17                	jne    8020b8 <__umoddi3+0x48>
  8020a1:	39 fe                	cmp    %edi,%esi
  8020a3:	76 4b                	jbe    8020f0 <__umoddi3+0x80>
  8020a5:	89 c8                	mov    %ecx,%eax
  8020a7:	89 fa                	mov    %edi,%edx
  8020a9:	f7 f6                	div    %esi
  8020ab:	89 d0                	mov    %edx,%eax
  8020ad:	31 d2                	xor    %edx,%edx
  8020af:	83 c4 14             	add    $0x14,%esp
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    
  8020b6:	66 90                	xchg   %ax,%ax
  8020b8:	39 f8                	cmp    %edi,%eax
  8020ba:	77 54                	ja     802110 <__umoddi3+0xa0>
  8020bc:	0f bd e8             	bsr    %eax,%ebp
  8020bf:	83 f5 1f             	xor    $0x1f,%ebp
  8020c2:	75 5c                	jne    802120 <__umoddi3+0xb0>
  8020c4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8020c8:	39 3c 24             	cmp    %edi,(%esp)
  8020cb:	0f 87 e7 00 00 00    	ja     8021b8 <__umoddi3+0x148>
  8020d1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8020d5:	29 f1                	sub    %esi,%ecx
  8020d7:	19 c7                	sbb    %eax,%edi
  8020d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020e1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8020e5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8020e9:	83 c4 14             	add    $0x14,%esp
  8020ec:	5e                   	pop    %esi
  8020ed:	5f                   	pop    %edi
  8020ee:	5d                   	pop    %ebp
  8020ef:	c3                   	ret    
  8020f0:	85 f6                	test   %esi,%esi
  8020f2:	89 f5                	mov    %esi,%ebp
  8020f4:	75 0b                	jne    802101 <__umoddi3+0x91>
  8020f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8020fb:	31 d2                	xor    %edx,%edx
  8020fd:	f7 f6                	div    %esi
  8020ff:	89 c5                	mov    %eax,%ebp
  802101:	8b 44 24 04          	mov    0x4(%esp),%eax
  802105:	31 d2                	xor    %edx,%edx
  802107:	f7 f5                	div    %ebp
  802109:	89 c8                	mov    %ecx,%eax
  80210b:	f7 f5                	div    %ebp
  80210d:	eb 9c                	jmp    8020ab <__umoddi3+0x3b>
  80210f:	90                   	nop
  802110:	89 c8                	mov    %ecx,%eax
  802112:	89 fa                	mov    %edi,%edx
  802114:	83 c4 14             	add    $0x14,%esp
  802117:	5e                   	pop    %esi
  802118:	5f                   	pop    %edi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    
  80211b:	90                   	nop
  80211c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802120:	8b 04 24             	mov    (%esp),%eax
  802123:	be 20 00 00 00       	mov    $0x20,%esi
  802128:	89 e9                	mov    %ebp,%ecx
  80212a:	29 ee                	sub    %ebp,%esi
  80212c:	d3 e2                	shl    %cl,%edx
  80212e:	89 f1                	mov    %esi,%ecx
  802130:	d3 e8                	shr    %cl,%eax
  802132:	89 e9                	mov    %ebp,%ecx
  802134:	89 44 24 04          	mov    %eax,0x4(%esp)
  802138:	8b 04 24             	mov    (%esp),%eax
  80213b:	09 54 24 04          	or     %edx,0x4(%esp)
  80213f:	89 fa                	mov    %edi,%edx
  802141:	d3 e0                	shl    %cl,%eax
  802143:	89 f1                	mov    %esi,%ecx
  802145:	89 44 24 08          	mov    %eax,0x8(%esp)
  802149:	8b 44 24 10          	mov    0x10(%esp),%eax
  80214d:	d3 ea                	shr    %cl,%edx
  80214f:	89 e9                	mov    %ebp,%ecx
  802151:	d3 e7                	shl    %cl,%edi
  802153:	89 f1                	mov    %esi,%ecx
  802155:	d3 e8                	shr    %cl,%eax
  802157:	89 e9                	mov    %ebp,%ecx
  802159:	09 f8                	or     %edi,%eax
  80215b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80215f:	f7 74 24 04          	divl   0x4(%esp)
  802163:	d3 e7                	shl    %cl,%edi
  802165:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802169:	89 d7                	mov    %edx,%edi
  80216b:	f7 64 24 08          	mull   0x8(%esp)
  80216f:	39 d7                	cmp    %edx,%edi
  802171:	89 c1                	mov    %eax,%ecx
  802173:	89 14 24             	mov    %edx,(%esp)
  802176:	72 2c                	jb     8021a4 <__umoddi3+0x134>
  802178:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80217c:	72 22                	jb     8021a0 <__umoddi3+0x130>
  80217e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802182:	29 c8                	sub    %ecx,%eax
  802184:	19 d7                	sbb    %edx,%edi
  802186:	89 e9                	mov    %ebp,%ecx
  802188:	89 fa                	mov    %edi,%edx
  80218a:	d3 e8                	shr    %cl,%eax
  80218c:	89 f1                	mov    %esi,%ecx
  80218e:	d3 e2                	shl    %cl,%edx
  802190:	89 e9                	mov    %ebp,%ecx
  802192:	d3 ef                	shr    %cl,%edi
  802194:	09 d0                	or     %edx,%eax
  802196:	89 fa                	mov    %edi,%edx
  802198:	83 c4 14             	add    $0x14,%esp
  80219b:	5e                   	pop    %esi
  80219c:	5f                   	pop    %edi
  80219d:	5d                   	pop    %ebp
  80219e:	c3                   	ret    
  80219f:	90                   	nop
  8021a0:	39 d7                	cmp    %edx,%edi
  8021a2:	75 da                	jne    80217e <__umoddi3+0x10e>
  8021a4:	8b 14 24             	mov    (%esp),%edx
  8021a7:	89 c1                	mov    %eax,%ecx
  8021a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8021ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8021b1:	eb cb                	jmp    80217e <__umoddi3+0x10e>
  8021b3:	90                   	nop
  8021b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8021bc:	0f 82 0f ff ff ff    	jb     8020d1 <__umoddi3+0x61>
  8021c2:	e9 1a ff ff ff       	jmp    8020e1 <__umoddi3+0x71>
