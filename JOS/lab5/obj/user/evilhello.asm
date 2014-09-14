
obj/user/evilhello.debug:     file format elf32-i386


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
  80002c:	e8 1e 00 00 00       	call   80004f <libmain>
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
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 0c 00 10 f0 	movl   $0xf010000c,(%esp)
  800048:	e8 93 00 00 00       	call   8000e0 <sys_cputs>
}
  80004d:	c9                   	leave  
  80004e:	c3                   	ret    

0080004f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004f:	55                   	push   %ebp
  800050:	89 e5                	mov    %esp,%ebp
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 10             	sub    $0x10,%esp
  800057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  80005d:	e8 0d 01 00 00       	call   80016f <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800062:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800068:	39 c2                	cmp    %eax,%edx
  80006a:	74 17                	je     800083 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80006c:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800071:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800074:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  80007a:	8b 49 40             	mov    0x40(%ecx),%ecx
  80007d:	39 c1                	cmp    %eax,%ecx
  80007f:	75 18                	jne    800099 <libmain+0x4a>
  800081:	eb 05                	jmp    800088 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800083:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800088:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80008b:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800091:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800097:	eb 0b                	jmp    8000a4 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800099:	83 c2 01             	add    $0x1,%edx
  80009c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000a2:	75 cd                	jne    800071 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a4:	85 db                	test   %ebx,%ebx
  8000a6:	7e 07                	jle    8000af <libmain+0x60>
		binaryname = argv[0];
  8000a8:	8b 06                	mov    (%esi),%eax
  8000aa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 78 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000bb:	e8 07 00 00 00       	call   8000c7 <exit>
}
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	5b                   	pop    %ebx
  8000c4:	5e                   	pop    %esi
  8000c5:	5d                   	pop    %ebp
  8000c6:	c3                   	ret    

008000c7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c7:	55                   	push   %ebp
  8000c8:	89 e5                	mov    %esp,%ebp
  8000ca:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000cd:	e8 64 05 00 00       	call   800636 <close_all>
	sys_env_destroy(0);
  8000d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d9:	e8 3f 00 00 00       	call   80011d <sys_env_destroy>
}
  8000de:	c9                   	leave  
  8000df:	c3                   	ret    

008000e0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000e0:	55                   	push   %ebp
  8000e1:	89 e5                	mov    %esp,%ebp
  8000e3:	57                   	push   %edi
  8000e4:	56                   	push   %esi
  8000e5:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f1:	89 c3                	mov    %eax,%ebx
  8000f3:	89 c7                	mov    %eax,%edi
  8000f5:	89 c6                	mov    %eax,%esi
  8000f7:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f9:	5b                   	pop    %ebx
  8000fa:	5e                   	pop    %esi
  8000fb:	5f                   	pop    %edi
  8000fc:	5d                   	pop    %ebp
  8000fd:	c3                   	ret    

008000fe <sys_cgetc>:

int
sys_cgetc(void)
{
  8000fe:	55                   	push   %ebp
  8000ff:	89 e5                	mov    %esp,%ebp
  800101:	57                   	push   %edi
  800102:	56                   	push   %esi
  800103:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800104:	ba 00 00 00 00       	mov    $0x0,%edx
  800109:	b8 01 00 00 00       	mov    $0x1,%eax
  80010e:	89 d1                	mov    %edx,%ecx
  800110:	89 d3                	mov    %edx,%ebx
  800112:	89 d7                	mov    %edx,%edi
  800114:	89 d6                	mov    %edx,%esi
  800116:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800118:	5b                   	pop    %ebx
  800119:	5e                   	pop    %esi
  80011a:	5f                   	pop    %edi
  80011b:	5d                   	pop    %ebp
  80011c:	c3                   	ret    

0080011d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	57                   	push   %edi
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
  800123:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800126:	b9 00 00 00 00       	mov    $0x0,%ecx
  80012b:	b8 03 00 00 00       	mov    $0x3,%eax
  800130:	8b 55 08             	mov    0x8(%ebp),%edx
  800133:	89 cb                	mov    %ecx,%ebx
  800135:	89 cf                	mov    %ecx,%edi
  800137:	89 ce                	mov    %ecx,%esi
  800139:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80013b:	85 c0                	test   %eax,%eax
  80013d:	7e 28                	jle    800167 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80013f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800143:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80014a:	00 
  80014b:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  800152:	00 
  800153:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80015a:	00 
  80015b:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  800162:	e8 8f 10 00 00       	call   8011f6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800167:	83 c4 2c             	add    $0x2c,%esp
  80016a:	5b                   	pop    %ebx
  80016b:	5e                   	pop    %esi
  80016c:	5f                   	pop    %edi
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    

0080016f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	57                   	push   %edi
  800173:	56                   	push   %esi
  800174:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800175:	ba 00 00 00 00       	mov    $0x0,%edx
  80017a:	b8 02 00 00 00       	mov    $0x2,%eax
  80017f:	89 d1                	mov    %edx,%ecx
  800181:	89 d3                	mov    %edx,%ebx
  800183:	89 d7                	mov    %edx,%edi
  800185:	89 d6                	mov    %edx,%esi
  800187:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800189:	5b                   	pop    %ebx
  80018a:	5e                   	pop    %esi
  80018b:	5f                   	pop    %edi
  80018c:	5d                   	pop    %ebp
  80018d:	c3                   	ret    

0080018e <sys_yield>:

void
sys_yield(void)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800194:	ba 00 00 00 00       	mov    $0x0,%edx
  800199:	b8 0b 00 00 00       	mov    $0xb,%eax
  80019e:	89 d1                	mov    %edx,%ecx
  8001a0:	89 d3                	mov    %edx,%ebx
  8001a2:	89 d7                	mov    %edx,%edi
  8001a4:	89 d6                	mov    %edx,%esi
  8001a6:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8001a8:	5b                   	pop    %ebx
  8001a9:	5e                   	pop    %esi
  8001aa:	5f                   	pop    %edi
  8001ab:	5d                   	pop    %ebp
  8001ac:	c3                   	ret    

008001ad <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	57                   	push   %edi
  8001b1:	56                   	push   %esi
  8001b2:	53                   	push   %ebx
  8001b3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b6:	be 00 00 00 00       	mov    $0x0,%esi
  8001bb:	b8 04 00 00 00       	mov    $0x4,%eax
  8001c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c9:	89 f7                	mov    %esi,%edi
  8001cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001cd:	85 c0                	test   %eax,%eax
  8001cf:	7e 28                	jle    8001f9 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001d5:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001dc:	00 
  8001dd:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  8001e4:	00 
  8001e5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ec:	00 
  8001ed:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  8001f4:	e8 fd 0f 00 00       	call   8011f6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001f9:	83 c4 2c             	add    $0x2c,%esp
  8001fc:	5b                   	pop    %ebx
  8001fd:	5e                   	pop    %esi
  8001fe:	5f                   	pop    %edi
  8001ff:	5d                   	pop    %ebp
  800200:	c3                   	ret    

00800201 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	57                   	push   %edi
  800205:	56                   	push   %esi
  800206:	53                   	push   %ebx
  800207:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80020a:	b8 05 00 00 00       	mov    $0x5,%eax
  80020f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800212:	8b 55 08             	mov    0x8(%ebp),%edx
  800215:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800218:	8b 7d 14             	mov    0x14(%ebp),%edi
  80021b:	8b 75 18             	mov    0x18(%ebp),%esi
  80021e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800220:	85 c0                	test   %eax,%eax
  800222:	7e 28                	jle    80024c <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800224:	89 44 24 10          	mov    %eax,0x10(%esp)
  800228:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80022f:	00 
  800230:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  800237:	00 
  800238:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80023f:	00 
  800240:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  800247:	e8 aa 0f 00 00       	call   8011f6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80024c:	83 c4 2c             	add    $0x2c,%esp
  80024f:	5b                   	pop    %ebx
  800250:	5e                   	pop    %esi
  800251:	5f                   	pop    %edi
  800252:	5d                   	pop    %ebp
  800253:	c3                   	ret    

00800254 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	57                   	push   %edi
  800258:	56                   	push   %esi
  800259:	53                   	push   %ebx
  80025a:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80025d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800262:	b8 06 00 00 00       	mov    $0x6,%eax
  800267:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80026a:	8b 55 08             	mov    0x8(%ebp),%edx
  80026d:	89 df                	mov    %ebx,%edi
  80026f:	89 de                	mov    %ebx,%esi
  800271:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800273:	85 c0                	test   %eax,%eax
  800275:	7e 28                	jle    80029f <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800277:	89 44 24 10          	mov    %eax,0x10(%esp)
  80027b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800282:	00 
  800283:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  80028a:	00 
  80028b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800292:	00 
  800293:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  80029a:	e8 57 0f 00 00       	call   8011f6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80029f:	83 c4 2c             	add    $0x2c,%esp
  8002a2:	5b                   	pop    %ebx
  8002a3:	5e                   	pop    %esi
  8002a4:	5f                   	pop    %edi
  8002a5:	5d                   	pop    %ebp
  8002a6:	c3                   	ret    

008002a7 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	57                   	push   %edi
  8002ab:	56                   	push   %esi
  8002ac:	53                   	push   %ebx
  8002ad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8002ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c0:	89 df                	mov    %ebx,%edi
  8002c2:	89 de                	mov    %ebx,%esi
  8002c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002c6:	85 c0                	test   %eax,%eax
  8002c8:	7e 28                	jle    8002f2 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002d5:	00 
  8002d6:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  8002dd:	00 
  8002de:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002e5:	00 
  8002e6:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  8002ed:	e8 04 0f 00 00       	call   8011f6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002f2:	83 c4 2c             	add    $0x2c,%esp
  8002f5:	5b                   	pop    %ebx
  8002f6:	5e                   	pop    %esi
  8002f7:	5f                   	pop    %edi
  8002f8:	5d                   	pop    %ebp
  8002f9:	c3                   	ret    

008002fa <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002fa:	55                   	push   %ebp
  8002fb:	89 e5                	mov    %esp,%ebp
  8002fd:	57                   	push   %edi
  8002fe:	56                   	push   %esi
  8002ff:	53                   	push   %ebx
  800300:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800303:	bb 00 00 00 00       	mov    $0x0,%ebx
  800308:	b8 09 00 00 00       	mov    $0x9,%eax
  80030d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800310:	8b 55 08             	mov    0x8(%ebp),%edx
  800313:	89 df                	mov    %ebx,%edi
  800315:	89 de                	mov    %ebx,%esi
  800317:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800319:	85 c0                	test   %eax,%eax
  80031b:	7e 28                	jle    800345 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80031d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800321:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800328:	00 
  800329:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  800330:	00 
  800331:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800338:	00 
  800339:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  800340:	e8 b1 0e 00 00       	call   8011f6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800345:	83 c4 2c             	add    $0x2c,%esp
  800348:	5b                   	pop    %ebx
  800349:	5e                   	pop    %esi
  80034a:	5f                   	pop    %edi
  80034b:	5d                   	pop    %ebp
  80034c:	c3                   	ret    

0080034d <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80034d:	55                   	push   %ebp
  80034e:	89 e5                	mov    %esp,%ebp
  800350:	57                   	push   %edi
  800351:	56                   	push   %esi
  800352:	53                   	push   %ebx
  800353:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800356:	bb 00 00 00 00       	mov    $0x0,%ebx
  80035b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800360:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800363:	8b 55 08             	mov    0x8(%ebp),%edx
  800366:	89 df                	mov    %ebx,%edi
  800368:	89 de                	mov    %ebx,%esi
  80036a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80036c:	85 c0                	test   %eax,%eax
  80036e:	7e 28                	jle    800398 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800370:	89 44 24 10          	mov    %eax,0x10(%esp)
  800374:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80037b:	00 
  80037c:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  800383:	00 
  800384:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80038b:	00 
  80038c:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  800393:	e8 5e 0e 00 00       	call   8011f6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800398:	83 c4 2c             	add    $0x2c,%esp
  80039b:	5b                   	pop    %ebx
  80039c:	5e                   	pop    %esi
  80039d:	5f                   	pop    %edi
  80039e:	5d                   	pop    %ebp
  80039f:	c3                   	ret    

008003a0 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a6:	be 00 00 00 00       	mov    $0x0,%esi
  8003ab:	b8 0c 00 00 00       	mov    $0xc,%eax
  8003b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b9:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003bc:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003be:	5b                   	pop    %ebx
  8003bf:	5e                   	pop    %esi
  8003c0:	5f                   	pop    %edi
  8003c1:	5d                   	pop    %ebp
  8003c2:	c3                   	ret    

008003c3 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003c3:	55                   	push   %ebp
  8003c4:	89 e5                	mov    %esp,%ebp
  8003c6:	57                   	push   %edi
  8003c7:	56                   	push   %esi
  8003c8:	53                   	push   %ebx
  8003c9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d1:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d9:	89 cb                	mov    %ecx,%ebx
  8003db:	89 cf                	mov    %ecx,%edi
  8003dd:	89 ce                	mov    %ecx,%esi
  8003df:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003e1:	85 c0                	test   %eax,%eax
  8003e3:	7e 28                	jle    80040d <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003e9:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003f0:	00 
  8003f1:	c7 44 24 08 2a 21 80 	movl   $0x80212a,0x8(%esp)
  8003f8:	00 
  8003f9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800400:	00 
  800401:	c7 04 24 47 21 80 00 	movl   $0x802147,(%esp)
  800408:	e8 e9 0d 00 00       	call   8011f6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80040d:	83 c4 2c             	add    $0x2c,%esp
  800410:	5b                   	pop    %ebx
  800411:	5e                   	pop    %esi
  800412:	5f                   	pop    %edi
  800413:	5d                   	pop    %ebp
  800414:	c3                   	ret    
  800415:	66 90                	xchg   %ax,%ax
  800417:	66 90                	xchg   %ax,%ax
  800419:	66 90                	xchg   %ax,%ax
  80041b:	66 90                	xchg   %ax,%ax
  80041d:	66 90                	xchg   %ax,%ax
  80041f:	90                   	nop

00800420 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	05 00 00 00 30       	add    $0x30000000,%eax
  80042b:	c1 e8 0c             	shr    $0xc,%eax
}
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80043b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800440:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    

00800447 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800447:	55                   	push   %ebp
  800448:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80044a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80044f:	a8 01                	test   $0x1,%al
  800451:	74 34                	je     800487 <fd_alloc+0x40>
  800453:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800458:	a8 01                	test   $0x1,%al
  80045a:	74 32                	je     80048e <fd_alloc+0x47>
  80045c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800461:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800463:	89 c2                	mov    %eax,%edx
  800465:	c1 ea 16             	shr    $0x16,%edx
  800468:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80046f:	f6 c2 01             	test   $0x1,%dl
  800472:	74 1f                	je     800493 <fd_alloc+0x4c>
  800474:	89 c2                	mov    %eax,%edx
  800476:	c1 ea 0c             	shr    $0xc,%edx
  800479:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800480:	f6 c2 01             	test   $0x1,%dl
  800483:	75 1a                	jne    80049f <fd_alloc+0x58>
  800485:	eb 0c                	jmp    800493 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800487:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80048c:	eb 05                	jmp    800493 <fd_alloc+0x4c>
  80048e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800493:	8b 45 08             	mov    0x8(%ebp),%eax
  800496:	89 08                	mov    %ecx,(%eax)
			return 0;
  800498:	b8 00 00 00 00       	mov    $0x0,%eax
  80049d:	eb 1a                	jmp    8004b9 <fd_alloc+0x72>
  80049f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8004a4:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8004a9:	75 b6                	jne    800461 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004b4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8004b9:	5d                   	pop    %ebp
  8004ba:	c3                   	ret    

008004bb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004bb:	55                   	push   %ebp
  8004bc:	89 e5                	mov    %esp,%ebp
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004c1:	83 f8 1f             	cmp    $0x1f,%eax
  8004c4:	77 36                	ja     8004fc <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004c6:	c1 e0 0c             	shl    $0xc,%eax
  8004c9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004ce:	89 c2                	mov    %eax,%edx
  8004d0:	c1 ea 16             	shr    $0x16,%edx
  8004d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004da:	f6 c2 01             	test   $0x1,%dl
  8004dd:	74 24                	je     800503 <fd_lookup+0x48>
  8004df:	89 c2                	mov    %eax,%edx
  8004e1:	c1 ea 0c             	shr    $0xc,%edx
  8004e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004eb:	f6 c2 01             	test   $0x1,%dl
  8004ee:	74 1a                	je     80050a <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004f3:	89 02                	mov    %eax,(%edx)
	return 0;
  8004f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fa:	eb 13                	jmp    80050f <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8004fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800501:	eb 0c                	jmp    80050f <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800503:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800508:	eb 05                	jmp    80050f <fd_lookup+0x54>
  80050a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80050f:	5d                   	pop    %ebp
  800510:	c3                   	ret    

00800511 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800511:	55                   	push   %ebp
  800512:	89 e5                	mov    %esp,%ebp
  800514:	53                   	push   %ebx
  800515:	83 ec 14             	sub    $0x14,%esp
  800518:	8b 45 08             	mov    0x8(%ebp),%eax
  80051b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80051e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800524:	75 1e                	jne    800544 <dev_lookup+0x33>
  800526:	eb 0e                	jmp    800536 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800528:	b8 20 30 80 00       	mov    $0x803020,%eax
  80052d:	eb 0c                	jmp    80053b <dev_lookup+0x2a>
  80052f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800534:	eb 05                	jmp    80053b <dev_lookup+0x2a>
  800536:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80053b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80053d:	b8 00 00 00 00       	mov    $0x0,%eax
  800542:	eb 38                	jmp    80057c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800544:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80054a:	74 dc                	je     800528 <dev_lookup+0x17>
  80054c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  800552:	74 db                	je     80052f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800554:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80055a:	8b 52 48             	mov    0x48(%edx),%edx
  80055d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800561:	89 54 24 04          	mov    %edx,0x4(%esp)
  800565:	c7 04 24 58 21 80 00 	movl   $0x802158,(%esp)
  80056c:	e8 7e 0d 00 00       	call   8012ef <cprintf>
	*dev = 0;
  800571:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80057c:	83 c4 14             	add    $0x14,%esp
  80057f:	5b                   	pop    %ebx
  800580:	5d                   	pop    %ebp
  800581:	c3                   	ret    

00800582 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	56                   	push   %esi
  800586:	53                   	push   %ebx
  800587:	83 ec 20             	sub    $0x20,%esp
  80058a:	8b 75 08             	mov    0x8(%ebp),%esi
  80058d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800590:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800593:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800597:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80059d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	e8 13 ff ff ff       	call   8004bb <fd_lookup>
  8005a8:	85 c0                	test   %eax,%eax
  8005aa:	78 05                	js     8005b1 <fd_close+0x2f>
	    || fd != fd2)
  8005ac:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8005af:	74 0c                	je     8005bd <fd_close+0x3b>
		return (must_exist ? r : 0);
  8005b1:	84 db                	test   %bl,%bl
  8005b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b8:	0f 44 c2             	cmove  %edx,%eax
  8005bb:	eb 3f                	jmp    8005fc <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c4:	8b 06                	mov    (%esi),%eax
  8005c6:	89 04 24             	mov    %eax,(%esp)
  8005c9:	e8 43 ff ff ff       	call   800511 <dev_lookup>
  8005ce:	89 c3                	mov    %eax,%ebx
  8005d0:	85 c0                	test   %eax,%eax
  8005d2:	78 16                	js     8005ea <fd_close+0x68>
		if (dev->dev_close)
  8005d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8005da:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8005df:	85 c0                	test   %eax,%eax
  8005e1:	74 07                	je     8005ea <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8005e3:	89 34 24             	mov    %esi,(%esp)
  8005e6:	ff d0                	call   *%eax
  8005e8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8005ea:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f5:	e8 5a fc ff ff       	call   800254 <sys_page_unmap>
	return r;
  8005fa:	89 d8                	mov    %ebx,%eax
}
  8005fc:	83 c4 20             	add    $0x20,%esp
  8005ff:	5b                   	pop    %ebx
  800600:	5e                   	pop    %esi
  800601:	5d                   	pop    %ebp
  800602:	c3                   	ret    

00800603 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800603:	55                   	push   %ebp
  800604:	89 e5                	mov    %esp,%ebp
  800606:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800609:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80060c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800610:	8b 45 08             	mov    0x8(%ebp),%eax
  800613:	89 04 24             	mov    %eax,(%esp)
  800616:	e8 a0 fe ff ff       	call   8004bb <fd_lookup>
  80061b:	89 c2                	mov    %eax,%edx
  80061d:	85 d2                	test   %edx,%edx
  80061f:	78 13                	js     800634 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800621:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800628:	00 
  800629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80062c:	89 04 24             	mov    %eax,(%esp)
  80062f:	e8 4e ff ff ff       	call   800582 <fd_close>
}
  800634:	c9                   	leave  
  800635:	c3                   	ret    

00800636 <close_all>:

void
close_all(void)
{
  800636:	55                   	push   %ebp
  800637:	89 e5                	mov    %esp,%ebp
  800639:	53                   	push   %ebx
  80063a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80063d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800642:	89 1c 24             	mov    %ebx,(%esp)
  800645:	e8 b9 ff ff ff       	call   800603 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80064a:	83 c3 01             	add    $0x1,%ebx
  80064d:	83 fb 20             	cmp    $0x20,%ebx
  800650:	75 f0                	jne    800642 <close_all+0xc>
		close(i);
}
  800652:	83 c4 14             	add    $0x14,%esp
  800655:	5b                   	pop    %ebx
  800656:	5d                   	pop    %ebp
  800657:	c3                   	ret    

00800658 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
  80065b:	57                   	push   %edi
  80065c:	56                   	push   %esi
  80065d:	53                   	push   %ebx
  80065e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800661:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800664:	89 44 24 04          	mov    %eax,0x4(%esp)
  800668:	8b 45 08             	mov    0x8(%ebp),%eax
  80066b:	89 04 24             	mov    %eax,(%esp)
  80066e:	e8 48 fe ff ff       	call   8004bb <fd_lookup>
  800673:	89 c2                	mov    %eax,%edx
  800675:	85 d2                	test   %edx,%edx
  800677:	0f 88 e1 00 00 00    	js     80075e <dup+0x106>
		return r;
	close(newfdnum);
  80067d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800680:	89 04 24             	mov    %eax,(%esp)
  800683:	e8 7b ff ff ff       	call   800603 <close>

	newfd = INDEX2FD(newfdnum);
  800688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80068b:	c1 e3 0c             	shl    $0xc,%ebx
  80068e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800697:	89 04 24             	mov    %eax,(%esp)
  80069a:	e8 91 fd ff ff       	call   800430 <fd2data>
  80069f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8006a1:	89 1c 24             	mov    %ebx,(%esp)
  8006a4:	e8 87 fd ff ff       	call   800430 <fd2data>
  8006a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	c1 e8 16             	shr    $0x16,%eax
  8006b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006b7:	a8 01                	test   $0x1,%al
  8006b9:	74 43                	je     8006fe <dup+0xa6>
  8006bb:	89 f0                	mov    %esi,%eax
  8006bd:	c1 e8 0c             	shr    $0xc,%eax
  8006c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006c7:	f6 c2 01             	test   $0x1,%dl
  8006ca:	74 32                	je     8006fe <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006cc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006d3:	25 07 0e 00 00       	and    $0xe07,%eax
  8006d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006dc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8006e0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8006e7:	00 
  8006e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006f3:	e8 09 fb ff ff       	call   800201 <sys_page_map>
  8006f8:	89 c6                	mov    %eax,%esi
  8006fa:	85 c0                	test   %eax,%eax
  8006fc:	78 3e                	js     80073c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800701:	89 c2                	mov    %eax,%edx
  800703:	c1 ea 0c             	shr    $0xc,%edx
  800706:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80070d:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800713:	89 54 24 10          	mov    %edx,0x10(%esp)
  800717:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80071b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800722:	00 
  800723:	89 44 24 04          	mov    %eax,0x4(%esp)
  800727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80072e:	e8 ce fa ff ff       	call   800201 <sys_page_map>
  800733:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800735:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800738:	85 f6                	test   %esi,%esi
  80073a:	79 22                	jns    80075e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80073c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800747:	e8 08 fb ff ff       	call   800254 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80074c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800750:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800757:	e8 f8 fa ff ff       	call   800254 <sys_page_unmap>
	return r;
  80075c:	89 f0                	mov    %esi,%eax
}
  80075e:	83 c4 3c             	add    $0x3c,%esp
  800761:	5b                   	pop    %ebx
  800762:	5e                   	pop    %esi
  800763:	5f                   	pop    %edi
  800764:	5d                   	pop    %ebp
  800765:	c3                   	ret    

00800766 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800766:	55                   	push   %ebp
  800767:	89 e5                	mov    %esp,%ebp
  800769:	53                   	push   %ebx
  80076a:	83 ec 24             	sub    $0x24,%esp
  80076d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800770:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800773:	89 44 24 04          	mov    %eax,0x4(%esp)
  800777:	89 1c 24             	mov    %ebx,(%esp)
  80077a:	e8 3c fd ff ff       	call   8004bb <fd_lookup>
  80077f:	89 c2                	mov    %eax,%edx
  800781:	85 d2                	test   %edx,%edx
  800783:	78 6d                	js     8007f2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800785:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800788:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	89 04 24             	mov    %eax,(%esp)
  800794:	e8 78 fd ff ff       	call   800511 <dev_lookup>
  800799:	85 c0                	test   %eax,%eax
  80079b:	78 55                	js     8007f2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80079d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a0:	8b 50 08             	mov    0x8(%eax),%edx
  8007a3:	83 e2 03             	and    $0x3,%edx
  8007a6:	83 fa 01             	cmp    $0x1,%edx
  8007a9:	75 23                	jne    8007ce <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8007ab:	a1 04 40 80 00       	mov    0x804004,%eax
  8007b0:	8b 40 48             	mov    0x48(%eax),%eax
  8007b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007bb:	c7 04 24 99 21 80 00 	movl   $0x802199,(%esp)
  8007c2:	e8 28 0b 00 00       	call   8012ef <cprintf>
		return -E_INVAL;
  8007c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007cc:	eb 24                	jmp    8007f2 <read+0x8c>
	}
	if (!dev->dev_read)
  8007ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d1:	8b 52 08             	mov    0x8(%edx),%edx
  8007d4:	85 d2                	test   %edx,%edx
  8007d6:	74 15                	je     8007ed <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007e6:	89 04 24             	mov    %eax,(%esp)
  8007e9:	ff d2                	call   *%edx
  8007eb:	eb 05                	jmp    8007f2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8007ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8007f2:	83 c4 24             	add    $0x24,%esp
  8007f5:	5b                   	pop    %ebx
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	57                   	push   %edi
  8007fc:	56                   	push   %esi
  8007fd:	53                   	push   %ebx
  8007fe:	83 ec 1c             	sub    $0x1c,%esp
  800801:	8b 7d 08             	mov    0x8(%ebp),%edi
  800804:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800807:	85 f6                	test   %esi,%esi
  800809:	74 33                	je     80083e <readn+0x46>
  80080b:	b8 00 00 00 00       	mov    $0x0,%eax
  800810:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800815:	89 f2                	mov    %esi,%edx
  800817:	29 c2                	sub    %eax,%edx
  800819:	89 54 24 08          	mov    %edx,0x8(%esp)
  80081d:	03 45 0c             	add    0xc(%ebp),%eax
  800820:	89 44 24 04          	mov    %eax,0x4(%esp)
  800824:	89 3c 24             	mov    %edi,(%esp)
  800827:	e8 3a ff ff ff       	call   800766 <read>
		if (m < 0)
  80082c:	85 c0                	test   %eax,%eax
  80082e:	78 1b                	js     80084b <readn+0x53>
			return m;
		if (m == 0)
  800830:	85 c0                	test   %eax,%eax
  800832:	74 11                	je     800845 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800834:	01 c3                	add    %eax,%ebx
  800836:	89 d8                	mov    %ebx,%eax
  800838:	39 f3                	cmp    %esi,%ebx
  80083a:	72 d9                	jb     800815 <readn+0x1d>
  80083c:	eb 0b                	jmp    800849 <readn+0x51>
  80083e:	b8 00 00 00 00       	mov    $0x0,%eax
  800843:	eb 06                	jmp    80084b <readn+0x53>
  800845:	89 d8                	mov    %ebx,%eax
  800847:	eb 02                	jmp    80084b <readn+0x53>
  800849:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80084b:	83 c4 1c             	add    $0x1c,%esp
  80084e:	5b                   	pop    %ebx
  80084f:	5e                   	pop    %esi
  800850:	5f                   	pop    %edi
  800851:	5d                   	pop    %ebp
  800852:	c3                   	ret    

00800853 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	53                   	push   %ebx
  800857:	83 ec 24             	sub    $0x24,%esp
  80085a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80085d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800860:	89 44 24 04          	mov    %eax,0x4(%esp)
  800864:	89 1c 24             	mov    %ebx,(%esp)
  800867:	e8 4f fc ff ff       	call   8004bb <fd_lookup>
  80086c:	89 c2                	mov    %eax,%edx
  80086e:	85 d2                	test   %edx,%edx
  800870:	78 68                	js     8008da <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800875:	89 44 24 04          	mov    %eax,0x4(%esp)
  800879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	89 04 24             	mov    %eax,(%esp)
  800881:	e8 8b fc ff ff       	call   800511 <dev_lookup>
  800886:	85 c0                	test   %eax,%eax
  800888:	78 50                	js     8008da <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80088a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800891:	75 23                	jne    8008b6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800893:	a1 04 40 80 00       	mov    0x804004,%eax
  800898:	8b 40 48             	mov    0x48(%eax),%eax
  80089b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80089f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a3:	c7 04 24 b5 21 80 00 	movl   $0x8021b5,(%esp)
  8008aa:	e8 40 0a 00 00       	call   8012ef <cprintf>
		return -E_INVAL;
  8008af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008b4:	eb 24                	jmp    8008da <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b9:	8b 52 0c             	mov    0xc(%edx),%edx
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	74 15                	je     8008d5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008ce:	89 04 24             	mov    %eax,(%esp)
  8008d1:	ff d2                	call   *%edx
  8008d3:	eb 05                	jmp    8008da <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8008d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8008da:	83 c4 24             	add    $0x24,%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5d                   	pop    %ebp
  8008df:	c3                   	ret    

008008e0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
  8008e3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008e6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8008e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 04 24             	mov    %eax,(%esp)
  8008f3:	e8 c3 fb ff ff       	call   8004bb <fd_lookup>
  8008f8:	85 c0                	test   %eax,%eax
  8008fa:	78 0e                	js     80090a <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8008fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8008ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800902:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	53                   	push   %ebx
  800910:	83 ec 24             	sub    $0x24,%esp
  800913:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800916:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800919:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091d:	89 1c 24             	mov    %ebx,(%esp)
  800920:	e8 96 fb ff ff       	call   8004bb <fd_lookup>
  800925:	89 c2                	mov    %eax,%edx
  800927:	85 d2                	test   %edx,%edx
  800929:	78 61                	js     80098c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80092b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80092e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 04 24             	mov    %eax,(%esp)
  80093a:	e8 d2 fb ff ff       	call   800511 <dev_lookup>
  80093f:	85 c0                	test   %eax,%eax
  800941:	78 49                	js     80098c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800946:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80094a:	75 23                	jne    80096f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80094c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800951:	8b 40 48             	mov    0x48(%eax),%eax
  800954:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095c:	c7 04 24 78 21 80 00 	movl   $0x802178,(%esp)
  800963:	e8 87 09 00 00       	call   8012ef <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800968:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80096d:	eb 1d                	jmp    80098c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80096f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800972:	8b 52 18             	mov    0x18(%edx),%edx
  800975:	85 d2                	test   %edx,%edx
  800977:	74 0e                	je     800987 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800979:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800980:	89 04 24             	mov    %eax,(%esp)
  800983:	ff d2                	call   *%edx
  800985:	eb 05                	jmp    80098c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800987:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80098c:	83 c4 24             	add    $0x24,%esp
  80098f:	5b                   	pop    %ebx
  800990:	5d                   	pop    %ebp
  800991:	c3                   	ret    

00800992 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	53                   	push   %ebx
  800996:	83 ec 24             	sub    $0x24,%esp
  800999:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80099c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80099f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a6:	89 04 24             	mov    %eax,(%esp)
  8009a9:	e8 0d fb ff ff       	call   8004bb <fd_lookup>
  8009ae:	89 c2                	mov    %eax,%edx
  8009b0:	85 d2                	test   %edx,%edx
  8009b2:	78 52                	js     800a06 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	89 04 24             	mov    %eax,(%esp)
  8009c3:	e8 49 fb ff ff       	call   800511 <dev_lookup>
  8009c8:	85 c0                	test   %eax,%eax
  8009ca:	78 3a                	js     800a06 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009cf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009d3:	74 2c                	je     800a01 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009d5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009d8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009df:	00 00 00 
	stat->st_isdir = 0;
  8009e2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009e9:	00 00 00 
	stat->st_dev = dev;
  8009ec:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009f9:	89 14 24             	mov    %edx,(%esp)
  8009fc:	ff 50 14             	call   *0x14(%eax)
  8009ff:	eb 05                	jmp    800a06 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  800a01:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  800a06:	83 c4 24             	add    $0x24,%esp
  800a09:	5b                   	pop    %ebx
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	56                   	push   %esi
  800a10:	53                   	push   %ebx
  800a11:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a14:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a1b:	00 
  800a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1f:	89 04 24             	mov    %eax,(%esp)
  800a22:	e8 e1 01 00 00       	call   800c08 <open>
  800a27:	89 c3                	mov    %eax,%ebx
  800a29:	85 db                	test   %ebx,%ebx
  800a2b:	78 1b                	js     800a48 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a34:	89 1c 24             	mov    %ebx,(%esp)
  800a37:	e8 56 ff ff ff       	call   800992 <fstat>
  800a3c:	89 c6                	mov    %eax,%esi
	close(fd);
  800a3e:	89 1c 24             	mov    %ebx,(%esp)
  800a41:	e8 bd fb ff ff       	call   800603 <close>
	return r;
  800a46:	89 f0                	mov    %esi,%eax
}
  800a48:	83 c4 10             	add    $0x10,%esp
  800a4b:	5b                   	pop    %ebx
  800a4c:	5e                   	pop    %esi
  800a4d:	5d                   	pop    %ebp
  800a4e:	c3                   	ret    

00800a4f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	56                   	push   %esi
  800a53:	53                   	push   %ebx
  800a54:	83 ec 10             	sub    $0x10,%esp
  800a57:	89 c3                	mov    %eax,%ebx
  800a59:	89 d6                	mov    %edx,%esi
	static envid_t fsenv;
	if (fsenv == 0)
  800a5b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a62:	75 11                	jne    800a75 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a6b:	e8 8a 13 00 00       	call   801dfa <ipc_find_env>
  800a70:	a3 00 40 80 00       	mov    %eax,0x804000

	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);
  800a75:	a1 04 40 80 00       	mov    0x804004,%eax
  800a7a:	8b 40 48             	mov    0x48(%eax),%eax
  800a7d:	8b 15 00 50 80 00    	mov    0x805000,%edx
  800a83:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a87:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a8f:	c7 04 24 d2 21 80 00 	movl   $0x8021d2,(%esp)
  800a96:	e8 54 08 00 00       	call   8012ef <cprintf>

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a9b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800aa2:	00 
  800aa3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800aaa:	00 
  800aab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aaf:	a1 00 40 80 00       	mov    0x804000,%eax
  800ab4:	89 04 24             	mov    %eax,(%esp)
  800ab7:	e8 d8 12 00 00       	call   801d94 <ipc_send>
	cprintf("ipc_send\n");
  800abc:	c7 04 24 e8 21 80 00 	movl   $0x8021e8,(%esp)
  800ac3:	e8 27 08 00 00       	call   8012ef <cprintf>
	return ipc_recv(NULL, dstva, NULL);
  800ac8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800acf:	00 
  800ad0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800adb:	e8 4c 12 00 00       	call   801d2c <ipc_recv>
}
  800ae0:	83 c4 10             	add    $0x10,%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	53                   	push   %ebx
  800aeb:	83 ec 14             	sub    $0x14,%esp
  800aee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 40 0c             	mov    0xc(%eax),%eax
  800af7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800afc:	ba 00 00 00 00       	mov    $0x0,%edx
  800b01:	b8 05 00 00 00       	mov    $0x5,%eax
  800b06:	e8 44 ff ff ff       	call   800a4f <fsipc>
  800b0b:	89 c2                	mov    %eax,%edx
  800b0d:	85 d2                	test   %edx,%edx
  800b0f:	78 2b                	js     800b3c <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800b11:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800b18:	00 
  800b19:	89 1c 24             	mov    %ebx,(%esp)
  800b1c:	e8 2a 0e 00 00       	call   80194b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800b21:	a1 80 50 80 00       	mov    0x805080,%eax
  800b26:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800b2c:	a1 84 50 80 00       	mov    0x805084,%eax
  800b31:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b3c:	83 c4 14             	add    $0x14,%esp
  800b3f:	5b                   	pop    %ebx
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  800b4e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	b8 06 00 00 00       	mov    $0x6,%eax
  800b5d:	e8 ed fe ff ff       	call   800a4f <fsipc>
}
  800b62:	c9                   	leave  
  800b63:	c3                   	ret    

00800b64 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b64:	55                   	push   %ebp
  800b65:	89 e5                	mov    %esp,%ebp
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	83 ec 10             	sub    $0x10,%esp
  800b6c:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 40 0c             	mov    0xc(%eax),%eax
  800b75:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b7a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b80:	ba 00 00 00 00       	mov    $0x0,%edx
  800b85:	b8 03 00 00 00       	mov    $0x3,%eax
  800b8a:	e8 c0 fe ff ff       	call   800a4f <fsipc>
  800b8f:	89 c3                	mov    %eax,%ebx
  800b91:	85 c0                	test   %eax,%eax
  800b93:	78 6a                	js     800bff <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b95:	39 c6                	cmp    %eax,%esi
  800b97:	73 24                	jae    800bbd <devfile_read+0x59>
  800b99:	c7 44 24 0c f2 21 80 	movl   $0x8021f2,0xc(%esp)
  800ba0:	00 
  800ba1:	c7 44 24 08 f9 21 80 	movl   $0x8021f9,0x8(%esp)
  800ba8:	00 
  800ba9:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800bb0:	00 
  800bb1:	c7 04 24 0e 22 80 00 	movl   $0x80220e,(%esp)
  800bb8:	e8 39 06 00 00       	call   8011f6 <_panic>
	assert(r <= PGSIZE);
  800bbd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800bc2:	7e 24                	jle    800be8 <devfile_read+0x84>
  800bc4:	c7 44 24 0c 19 22 80 	movl   $0x802219,0xc(%esp)
  800bcb:	00 
  800bcc:	c7 44 24 08 f9 21 80 	movl   $0x8021f9,0x8(%esp)
  800bd3:	00 
  800bd4:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
  800bdb:	00 
  800bdc:	c7 04 24 0e 22 80 00 	movl   $0x80220e,(%esp)
  800be3:	e8 0e 06 00 00       	call   8011f6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800be8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bec:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bf3:	00 
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 04 24             	mov    %eax,(%esp)
  800bfa:	e8 47 0f 00 00       	call   801b46 <memmove>
	return r;
}
  800bff:	89 d8                	mov    %ebx,%eax
  800c01:	83 c4 10             	add    $0x10,%esp
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	53                   	push   %ebx
  800c0c:	83 ec 24             	sub    $0x24,%esp
  800c0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800c12:	89 1c 24             	mov    %ebx,(%esp)
  800c15:	e8 d6 0c 00 00       	call   8018f0 <strlen>
  800c1a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800c1f:	7f 60                	jg     800c81 <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800c21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c24:	89 04 24             	mov    %eax,(%esp)
  800c27:	e8 1b f8 ff ff       	call   800447 <fd_alloc>
  800c2c:	89 c2                	mov    %eax,%edx
  800c2e:	85 d2                	test   %edx,%edx
  800c30:	78 54                	js     800c86 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c36:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c3d:	e8 09 0d 00 00       	call   80194b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4d:	b8 01 00 00 00       	mov    $0x1,%eax
  800c52:	e8 f8 fd ff ff       	call   800a4f <fsipc>
  800c57:	89 c3                	mov    %eax,%ebx
  800c59:	85 c0                	test   %eax,%eax
  800c5b:	79 17                	jns    800c74 <open+0x6c>
		fd_close(fd, 0);
  800c5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c64:	00 
  800c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c68:	89 04 24             	mov    %eax,(%esp)
  800c6b:	e8 12 f9 ff ff       	call   800582 <fd_close>
		return r;
  800c70:	89 d8                	mov    %ebx,%eax
  800c72:	eb 12                	jmp    800c86 <open+0x7e>
	}
	return fd2num(fd);
  800c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c77:	89 04 24             	mov    %eax,(%esp)
  800c7a:	e8 a1 f7 ff ff       	call   800420 <fd2num>
  800c7f:	eb 05                	jmp    800c86 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c81:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800c86:	83 c4 24             	add    $0x24,%esp
  800c89:	5b                   	pop    %ebx
  800c8a:	5d                   	pop    %ebp
  800c8b:	c3                   	ret    
  800c8c:	66 90                	xchg   %ax,%ax
  800c8e:	66 90                	xchg   %ax,%ax

00800c90 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
  800c95:	83 ec 10             	sub    $0x10,%esp
  800c98:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9e:	89 04 24             	mov    %eax,(%esp)
  800ca1:	e8 8a f7 ff ff       	call   800430 <fd2data>
  800ca6:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800ca8:	c7 44 24 04 25 22 80 	movl   $0x802225,0x4(%esp)
  800caf:	00 
  800cb0:	89 1c 24             	mov    %ebx,(%esp)
  800cb3:	e8 93 0c 00 00       	call   80194b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800cb8:	8b 46 04             	mov    0x4(%esi),%eax
  800cbb:	2b 06                	sub    (%esi),%eax
  800cbd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800cc3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cca:	00 00 00 
	stat->st_dev = &devpipe;
  800ccd:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800cd4:	30 80 00 
	return 0;
}
  800cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cdc:	83 c4 10             	add    $0x10,%esp
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5d                   	pop    %ebp
  800ce2:	c3                   	ret    

00800ce3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	53                   	push   %ebx
  800ce7:	83 ec 14             	sub    $0x14,%esp
  800cea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800ced:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cf1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cf8:	e8 57 f5 ff ff       	call   800254 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800cfd:	89 1c 24             	mov    %ebx,(%esp)
  800d00:	e8 2b f7 ff ff       	call   800430 <fd2data>
  800d05:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800d10:	e8 3f f5 ff ff       	call   800254 <sys_page_unmap>
}
  800d15:	83 c4 14             	add    $0x14,%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 2c             	sub    $0x2c,%esp
  800d24:	89 c6                	mov    %eax,%esi
  800d26:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800d29:	a1 04 40 80 00       	mov    0x804004,%eax
  800d2e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d31:	89 34 24             	mov    %esi,(%esp)
  800d34:	e8 09 11 00 00       	call   801e42 <pageref>
  800d39:	89 c7                	mov    %eax,%edi
  800d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d3e:	89 04 24             	mov    %eax,(%esp)
  800d41:	e8 fc 10 00 00       	call   801e42 <pageref>
  800d46:	39 c7                	cmp    %eax,%edi
  800d48:	0f 94 c2             	sete   %dl
  800d4b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d4e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d54:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d57:	39 fb                	cmp    %edi,%ebx
  800d59:	74 21                	je     800d7c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d5b:	84 d2                	test   %dl,%dl
  800d5d:	74 ca                	je     800d29 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d5f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d62:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d66:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d6a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d6e:	c7 04 24 2c 22 80 00 	movl   $0x80222c,(%esp)
  800d75:	e8 75 05 00 00       	call   8012ef <cprintf>
  800d7a:	eb ad                	jmp    800d29 <_pipeisclosed+0xe>
	}
}
  800d7c:	83 c4 2c             	add    $0x2c,%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 1c             	sub    $0x1c,%esp
  800d8d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d90:	89 34 24             	mov    %esi,(%esp)
  800d93:	e8 98 f6 ff ff       	call   800430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d9c:	74 61                	je     800dff <devpipe_write+0x7b>
  800d9e:	89 c3                	mov    %eax,%ebx
  800da0:	bf 00 00 00 00       	mov    $0x0,%edi
  800da5:	eb 4a                	jmp    800df1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800da7:	89 da                	mov    %ebx,%edx
  800da9:	89 f0                	mov    %esi,%eax
  800dab:	e8 6b ff ff ff       	call   800d1b <_pipeisclosed>
  800db0:	85 c0                	test   %eax,%eax
  800db2:	75 54                	jne    800e08 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800db4:	e8 d5 f3 ff ff       	call   80018e <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800db9:	8b 43 04             	mov    0x4(%ebx),%eax
  800dbc:	8b 0b                	mov    (%ebx),%ecx
  800dbe:	8d 51 20             	lea    0x20(%ecx),%edx
  800dc1:	39 d0                	cmp    %edx,%eax
  800dc3:	73 e2                	jae    800da7 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800dc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc8:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800dcc:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800dcf:	99                   	cltd   
  800dd0:	c1 ea 1b             	shr    $0x1b,%edx
  800dd3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800dd6:	83 e1 1f             	and    $0x1f,%ecx
  800dd9:	29 d1                	sub    %edx,%ecx
  800ddb:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800ddf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800de3:	83 c0 01             	add    $0x1,%eax
  800de6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800de9:	83 c7 01             	add    $0x1,%edi
  800dec:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800def:	74 13                	je     800e04 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800df1:	8b 43 04             	mov    0x4(%ebx),%eax
  800df4:	8b 0b                	mov    (%ebx),%ecx
  800df6:	8d 51 20             	lea    0x20(%ecx),%edx
  800df9:	39 d0                	cmp    %edx,%eax
  800dfb:	73 aa                	jae    800da7 <devpipe_write+0x23>
  800dfd:	eb c6                	jmp    800dc5 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dff:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800e04:	89 f8                	mov    %edi,%eax
  800e06:	eb 05                	jmp    800e0d <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e08:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800e0d:	83 c4 1c             	add    $0x1c,%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5e                   	pop    %esi
  800e12:	5f                   	pop    %edi
  800e13:	5d                   	pop    %ebp
  800e14:	c3                   	ret    

00800e15 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800e15:	55                   	push   %ebp
  800e16:	89 e5                	mov    %esp,%ebp
  800e18:	57                   	push   %edi
  800e19:	56                   	push   %esi
  800e1a:	53                   	push   %ebx
  800e1b:	83 ec 1c             	sub    $0x1c,%esp
  800e1e:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800e21:	89 3c 24             	mov    %edi,(%esp)
  800e24:	e8 07 f6 ff ff       	call   800430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e2d:	74 54                	je     800e83 <devpipe_read+0x6e>
  800e2f:	89 c3                	mov    %eax,%ebx
  800e31:	be 00 00 00 00       	mov    $0x0,%esi
  800e36:	eb 3e                	jmp    800e76 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	eb 55                	jmp    800e91 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e3c:	89 da                	mov    %ebx,%edx
  800e3e:	89 f8                	mov    %edi,%eax
  800e40:	e8 d6 fe ff ff       	call   800d1b <_pipeisclosed>
  800e45:	85 c0                	test   %eax,%eax
  800e47:	75 43                	jne    800e8c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e49:	e8 40 f3 ff ff       	call   80018e <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e4e:	8b 03                	mov    (%ebx),%eax
  800e50:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e53:	74 e7                	je     800e3c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e55:	99                   	cltd   
  800e56:	c1 ea 1b             	shr    $0x1b,%edx
  800e59:	01 d0                	add    %edx,%eax
  800e5b:	83 e0 1f             	and    $0x1f,%eax
  800e5e:	29 d0                	sub    %edx,%eax
  800e60:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e68:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e6b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e6e:	83 c6 01             	add    $0x1,%esi
  800e71:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e74:	74 12                	je     800e88 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e76:	8b 03                	mov    (%ebx),%eax
  800e78:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e7b:	75 d8                	jne    800e55 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e7d:	85 f6                	test   %esi,%esi
  800e7f:	75 b7                	jne    800e38 <devpipe_read+0x23>
  800e81:	eb b9                	jmp    800e3c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e83:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e88:	89 f0                	mov    %esi,%eax
  800e8a:	eb 05                	jmp    800e91 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e8c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e91:	83 c4 1c             	add    $0x1c,%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	56                   	push   %esi
  800e9d:	53                   	push   %ebx
  800e9e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800ea1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ea4:	89 04 24             	mov    %eax,(%esp)
  800ea7:	e8 9b f5 ff ff       	call   800447 <fd_alloc>
  800eac:	89 c2                	mov    %eax,%edx
  800eae:	85 d2                	test   %edx,%edx
  800eb0:	0f 88 4d 01 00 00    	js     801003 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800eb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ebd:	00 
  800ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ecc:	e8 dc f2 ff ff       	call   8001ad <sys_page_alloc>
  800ed1:	89 c2                	mov    %eax,%edx
  800ed3:	85 d2                	test   %edx,%edx
  800ed5:	0f 88 28 01 00 00    	js     801003 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800edb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ede:	89 04 24             	mov    %eax,(%esp)
  800ee1:	e8 61 f5 ff ff       	call   800447 <fd_alloc>
  800ee6:	89 c3                	mov    %eax,%ebx
  800ee8:	85 c0                	test   %eax,%eax
  800eea:	0f 88 fe 00 00 00    	js     800fee <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ef0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ef7:	00 
  800ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f06:	e8 a2 f2 ff ff       	call   8001ad <sys_page_alloc>
  800f0b:	89 c3                	mov    %eax,%ebx
  800f0d:	85 c0                	test   %eax,%eax
  800f0f:	0f 88 d9 00 00 00    	js     800fee <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f18:	89 04 24             	mov    %eax,(%esp)
  800f1b:	e8 10 f5 ff ff       	call   800430 <fd2data>
  800f20:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f22:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800f29:	00 
  800f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f2e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f35:	e8 73 f2 ff ff       	call   8001ad <sys_page_alloc>
  800f3a:	89 c3                	mov    %eax,%ebx
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	0f 88 97 00 00 00    	js     800fdb <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f47:	89 04 24             	mov    %eax,(%esp)
  800f4a:	e8 e1 f4 ff ff       	call   800430 <fd2data>
  800f4f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f56:	00 
  800f57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f62:	00 
  800f63:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f6e:	e8 8e f2 ff ff       	call   800201 <sys_page_map>
  800f73:	89 c3                	mov    %eax,%ebx
  800f75:	85 c0                	test   %eax,%eax
  800f77:	78 52                	js     800fcb <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f79:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f82:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f87:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f8e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f97:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa6:	89 04 24             	mov    %eax,(%esp)
  800fa9:	e8 72 f4 ff ff       	call   800420 <fd2num>
  800fae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fb1:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	89 04 24             	mov    %eax,(%esp)
  800fb9:	e8 62 f4 ff ff       	call   800420 <fd2num>
  800fbe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fc1:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800fc4:	b8 00 00 00 00       	mov    $0x0,%eax
  800fc9:	eb 38                	jmp    801003 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800fcb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fd6:	e8 79 f2 ff ff       	call   800254 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fe9:	e8 66 f2 ff ff       	call   800254 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ffc:	e8 53 f2 ff ff       	call   800254 <sys_page_unmap>
  801001:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801003:	83 c4 30             	add    $0x30,%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801010:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801013:	89 44 24 04          	mov    %eax,0x4(%esp)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	89 04 24             	mov    %eax,(%esp)
  80101d:	e8 99 f4 ff ff       	call   8004bb <fd_lookup>
  801022:	89 c2                	mov    %eax,%edx
  801024:	85 d2                	test   %edx,%edx
  801026:	78 15                	js     80103d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102b:	89 04 24             	mov    %eax,(%esp)
  80102e:	e8 fd f3 ff ff       	call   800430 <fd2data>
	return _pipeisclosed(fd, p);
  801033:	89 c2                	mov    %eax,%edx
  801035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801038:	e8 de fc ff ff       	call   800d1b <_pipeisclosed>
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    
  80103f:	90                   	nop

00801040 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801043:	b8 00 00 00 00       	mov    $0x0,%eax
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801050:	c7 44 24 04 44 22 80 	movl   $0x802244,0x4(%esp)
  801057:	00 
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	89 04 24             	mov    %eax,(%esp)
  80105e:	e8 e8 08 00 00       	call   80194b <strcpy>
	return 0;
}
  801063:	b8 00 00 00 00       	mov    $0x0,%eax
  801068:	c9                   	leave  
  801069:	c3                   	ret    

0080106a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801076:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107a:	74 4a                	je     8010c6 <devcons_write+0x5c>
  80107c:	b8 00 00 00 00       	mov    $0x0,%eax
  801081:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801086:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80108c:	8b 75 10             	mov    0x10(%ebp),%esi
  80108f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801091:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801094:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801099:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80109c:	89 74 24 08          	mov    %esi,0x8(%esp)
  8010a0:	03 45 0c             	add    0xc(%ebp),%eax
  8010a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010a7:	89 3c 24             	mov    %edi,(%esp)
  8010aa:	e8 97 0a 00 00       	call   801b46 <memmove>
		sys_cputs(buf, m);
  8010af:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b3:	89 3c 24             	mov    %edi,(%esp)
  8010b6:	e8 25 f0 ff ff       	call   8000e0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8010bb:	01 f3                	add    %esi,%ebx
  8010bd:	89 d8                	mov    %ebx,%eax
  8010bf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8010c2:	72 c8                	jb     80108c <devcons_write+0x22>
  8010c4:	eb 05                	jmp    8010cb <devcons_write+0x61>
  8010c6:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8010cb:	89 d8                	mov    %ebx,%eax
  8010cd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8010d3:	5b                   	pop    %ebx
  8010d4:	5e                   	pop    %esi
  8010d5:	5f                   	pop    %edi
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    

008010d8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8010e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e7:	75 07                	jne    8010f0 <devcons_read+0x18>
  8010e9:	eb 28                	jmp    801113 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8010eb:	e8 9e f0 ff ff       	call   80018e <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010f0:	e8 09 f0 ff ff       	call   8000fe <sys_cgetc>
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	74 f2                	je     8010eb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010f9:	85 c0                	test   %eax,%eax
  8010fb:	78 16                	js     801113 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010fd:	83 f8 04             	cmp    $0x4,%eax
  801100:	74 0c                	je     80110e <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801102:	8b 55 0c             	mov    0xc(%ebp),%edx
  801105:	88 02                	mov    %al,(%edx)
	return 1;
  801107:	b8 01 00 00 00       	mov    $0x1,%eax
  80110c:	eb 05                	jmp    801113 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80110e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  801113:	c9                   	leave  
  801114:	c3                   	ret    

00801115 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80111b:	8b 45 08             	mov    0x8(%ebp),%eax
  80111e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801121:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801128:	00 
  801129:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80112c:	89 04 24             	mov    %eax,(%esp)
  80112f:	e8 ac ef ff ff       	call   8000e0 <sys_cputs>
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <getchar>:

int
getchar(void)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80113c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801143:	00 
  801144:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801147:	89 44 24 04          	mov    %eax,0x4(%esp)
  80114b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801152:	e8 0f f6 ff ff       	call   800766 <read>
	if (r < 0)
  801157:	85 c0                	test   %eax,%eax
  801159:	78 0f                	js     80116a <getchar+0x34>
		return r;
	if (r < 1)
  80115b:	85 c0                	test   %eax,%eax
  80115d:	7e 06                	jle    801165 <getchar+0x2f>
		return -E_EOF;
	return c;
  80115f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801163:	eb 05                	jmp    80116a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801165:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801172:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801175:	89 44 24 04          	mov    %eax,0x4(%esp)
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	89 04 24             	mov    %eax,(%esp)
  80117f:	e8 37 f3 ff ff       	call   8004bb <fd_lookup>
  801184:	85 c0                	test   %eax,%eax
  801186:	78 11                	js     801199 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801191:	39 10                	cmp    %edx,(%eax)
  801193:	0f 94 c0             	sete   %al
  801196:	0f b6 c0             	movzbl %al,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <opencons>:

int
opencons(void)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a4:	89 04 24             	mov    %eax,(%esp)
  8011a7:	e8 9b f2 ff ff       	call   800447 <fd_alloc>
		return r;
  8011ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8011ae:	85 c0                	test   %eax,%eax
  8011b0:	78 40                	js     8011f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8011b9:	00 
  8011ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c8:	e8 e0 ef ff ff       	call   8001ad <sys_page_alloc>
		return r;
  8011cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 1f                	js     8011f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8011d3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8011de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8011e8:	89 04 24             	mov    %eax,(%esp)
  8011eb:	e8 30 f2 ff ff       	call   800420 <fd2num>
  8011f0:	89 c2                	mov    %eax,%edx
}
  8011f2:	89 d0                	mov    %edx,%eax
  8011f4:	c9                   	leave  
  8011f5:	c3                   	ret    

008011f6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	56                   	push   %esi
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011fe:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  801201:	8b 35 00 30 80 00    	mov    0x803000,%esi
  801207:	e8 63 ef ff ff       	call   80016f <sys_getenvid>
  80120c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120f:	89 54 24 10          	mov    %edx,0x10(%esp)
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80121a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80121e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801222:	c7 04 24 50 22 80 00 	movl   $0x802250,(%esp)
  801229:	e8 c1 00 00 00       	call   8012ef <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80122e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801232:	8b 45 10             	mov    0x10(%ebp),%eax
  801235:	89 04 24             	mov    %eax,(%esp)
  801238:	e8 51 00 00 00       	call   80128e <vcprintf>
	cprintf("\n");
  80123d:	c7 04 24 3d 22 80 00 	movl   $0x80223d,(%esp)
  801244:	e8 a6 00 00 00       	call   8012ef <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801249:	cc                   	int3   
  80124a:	eb fd                	jmp    801249 <_panic+0x53>

0080124c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	53                   	push   %ebx
  801250:	83 ec 14             	sub    $0x14,%esp
  801253:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801256:	8b 13                	mov    (%ebx),%edx
  801258:	8d 42 01             	lea    0x1(%edx),%eax
  80125b:	89 03                	mov    %eax,(%ebx)
  80125d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801260:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801264:	3d ff 00 00 00       	cmp    $0xff,%eax
  801269:	75 19                	jne    801284 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80126b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801272:	00 
  801273:	8d 43 08             	lea    0x8(%ebx),%eax
  801276:	89 04 24             	mov    %eax,(%esp)
  801279:	e8 62 ee ff ff       	call   8000e0 <sys_cputs>
		b->idx = 0;
  80127e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801284:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801288:	83 c4 14             	add    $0x14,%esp
  80128b:	5b                   	pop    %ebx
  80128c:	5d                   	pop    %ebp
  80128d:	c3                   	ret    

0080128e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80128e:	55                   	push   %ebp
  80128f:	89 e5                	mov    %esp,%ebp
  801291:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801297:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80129e:	00 00 00 
	b.cnt = 0;
  8012a1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8012a8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8012bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c3:	c7 04 24 4c 12 80 00 	movl   $0x80124c,(%esp)
  8012ca:	e8 b5 01 00 00       	call   801484 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8012cf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8012d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8012df:	89 04 24             	mov    %eax,(%esp)
  8012e2:	e8 f9 ed ff ff       	call   8000e0 <sys_cputs>

	return b.cnt;
}
  8012e7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012f5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	89 04 24             	mov    %eax,(%esp)
  801302:	e8 87 ff ff ff       	call   80128e <vcprintf>
	va_end(ap);

	return cnt;
}
  801307:	c9                   	leave  
  801308:	c3                   	ret    
  801309:	66 90                	xchg   %ax,%ax
  80130b:	66 90                	xchg   %ax,%ax
  80130d:	66 90                	xchg   %ax,%ax
  80130f:	90                   	nop

00801310 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	57                   	push   %edi
  801314:	56                   	push   %esi
  801315:	53                   	push   %ebx
  801316:	83 ec 3c             	sub    $0x3c,%esp
  801319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80131c:	89 d7                	mov    %edx,%edi
  80131e:	8b 45 08             	mov    0x8(%ebp),%eax
  801321:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801324:	8b 75 0c             	mov    0xc(%ebp),%esi
  801327:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  80132a:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80132d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801332:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801335:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801338:	39 f1                	cmp    %esi,%ecx
  80133a:	72 14                	jb     801350 <printnum+0x40>
  80133c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80133f:	76 0f                	jbe    801350 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801341:	8b 45 14             	mov    0x14(%ebp),%eax
  801344:	8d 70 ff             	lea    -0x1(%eax),%esi
  801347:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80134a:	85 f6                	test   %esi,%esi
  80134c:	7f 60                	jg     8013ae <printnum+0x9e>
  80134e:	eb 72                	jmp    8013c2 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801350:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801353:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801357:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80135a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80135d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801361:	89 44 24 08          	mov    %eax,0x8(%esp)
  801365:	8b 44 24 08          	mov    0x8(%esp),%eax
  801369:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80136d:	89 c3                	mov    %eax,%ebx
  80136f:	89 d6                	mov    %edx,%esi
  801371:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801374:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801377:	89 54 24 08          	mov    %edx,0x8(%esp)
  80137b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80137f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801382:	89 04 24             	mov    %eax,(%esp)
  801385:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138c:	e8 ef 0a 00 00       	call   801e80 <__udivdi3>
  801391:	89 d9                	mov    %ebx,%ecx
  801393:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801397:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80139b:	89 04 24             	mov    %eax,(%esp)
  80139e:	89 54 24 04          	mov    %edx,0x4(%esp)
  8013a2:	89 fa                	mov    %edi,%edx
  8013a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a7:	e8 64 ff ff ff       	call   801310 <printnum>
  8013ac:	eb 14                	jmp    8013c2 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8013ae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8013b5:	89 04 24             	mov    %eax,(%esp)
  8013b8:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8013ba:	83 ee 01             	sub    $0x1,%esi
  8013bd:	75 ef                	jne    8013ae <printnum+0x9e>
  8013bf:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013c6:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8013ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013db:	89 04 24             	mov    %eax,(%esp)
  8013de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e5:	e8 c6 0b 00 00       	call   801fb0 <__umoddi3>
  8013ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013ee:	0f be 80 73 22 80 00 	movsbl 0x802273(%eax),%eax
  8013f5:	89 04 24             	mov    %eax,(%esp)
  8013f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
}
  8013fd:	83 c4 3c             	add    $0x3c,%esp
  801400:	5b                   	pop    %ebx
  801401:	5e                   	pop    %esi
  801402:	5f                   	pop    %edi
  801403:	5d                   	pop    %ebp
  801404:	c3                   	ret    

00801405 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801408:	83 fa 01             	cmp    $0x1,%edx
  80140b:	7e 0e                	jle    80141b <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80140d:	8b 10                	mov    (%eax),%edx
  80140f:	8d 4a 08             	lea    0x8(%edx),%ecx
  801412:	89 08                	mov    %ecx,(%eax)
  801414:	8b 02                	mov    (%edx),%eax
  801416:	8b 52 04             	mov    0x4(%edx),%edx
  801419:	eb 22                	jmp    80143d <getuint+0x38>
	else if (lflag)
  80141b:	85 d2                	test   %edx,%edx
  80141d:	74 10                	je     80142f <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  80141f:	8b 10                	mov    (%eax),%edx
  801421:	8d 4a 04             	lea    0x4(%edx),%ecx
  801424:	89 08                	mov    %ecx,(%eax)
  801426:	8b 02                	mov    (%edx),%eax
  801428:	ba 00 00 00 00       	mov    $0x0,%edx
  80142d:	eb 0e                	jmp    80143d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  80142f:	8b 10                	mov    (%eax),%edx
  801431:	8d 4a 04             	lea    0x4(%edx),%ecx
  801434:	89 08                	mov    %ecx,(%eax)
  801436:	8b 02                	mov    (%edx),%eax
  801438:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80143d:	5d                   	pop    %ebp
  80143e:	c3                   	ret    

0080143f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80143f:	55                   	push   %ebp
  801440:	89 e5                	mov    %esp,%ebp
  801442:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801445:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801449:	8b 10                	mov    (%eax),%edx
  80144b:	3b 50 04             	cmp    0x4(%eax),%edx
  80144e:	73 0a                	jae    80145a <sprintputch+0x1b>
		*b->buf++ = ch;
  801450:	8d 4a 01             	lea    0x1(%edx),%ecx
  801453:	89 08                	mov    %ecx,(%eax)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	88 02                	mov    %al,(%edx)
}
  80145a:	5d                   	pop    %ebp
  80145b:	c3                   	ret    

0080145c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801462:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801469:	8b 45 10             	mov    0x10(%ebp),%eax
  80146c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	89 04 24             	mov    %eax,(%esp)
  80147d:	e8 02 00 00 00       	call   801484 <vprintfmt>
	va_end(ap);
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	57                   	push   %edi
  801488:	56                   	push   %esi
  801489:	53                   	push   %ebx
  80148a:	83 ec 3c             	sub    $0x3c,%esp
  80148d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801490:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801493:	eb 18                	jmp    8014ad <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801495:	85 c0                	test   %eax,%eax
  801497:	0f 84 c3 03 00 00    	je     801860 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80149d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8014a1:	89 04 24             	mov    %eax,(%esp)
  8014a4:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014a7:	89 f3                	mov    %esi,%ebx
  8014a9:	eb 02                	jmp    8014ad <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014ab:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8014ad:	8d 73 01             	lea    0x1(%ebx),%esi
  8014b0:	0f b6 03             	movzbl (%ebx),%eax
  8014b3:	83 f8 25             	cmp    $0x25,%eax
  8014b6:	75 dd                	jne    801495 <vprintfmt+0x11>
  8014b8:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  8014bc:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8014c3:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8014ca:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d6:	eb 1d                	jmp    8014f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014d8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8014da:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8014de:	eb 15                	jmp    8014f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014e0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014e2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8014e6:	eb 0d                	jmp    8014f5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8014e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014ee:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014f5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014f8:	0f b6 06             	movzbl (%esi),%eax
  8014fb:	0f b6 c8             	movzbl %al,%ecx
  8014fe:	83 e8 23             	sub    $0x23,%eax
  801501:	3c 55                	cmp    $0x55,%al
  801503:	0f 87 2f 03 00 00    	ja     801838 <vprintfmt+0x3b4>
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	ff 24 85 c0 23 80 00 	jmp    *0x8023c0(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801513:	8d 41 d0             	lea    -0x30(%ecx),%eax
  801516:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  801519:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  80151d:	8d 48 d0             	lea    -0x30(%eax),%ecx
  801520:	83 f9 09             	cmp    $0x9,%ecx
  801523:	77 50                	ja     801575 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801525:	89 de                	mov    %ebx,%esi
  801527:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80152a:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  80152d:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801530:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801534:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801537:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80153a:	83 fb 09             	cmp    $0x9,%ebx
  80153d:	76 eb                	jbe    80152a <vprintfmt+0xa6>
  80153f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801542:	eb 33                	jmp    801577 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801544:	8b 45 14             	mov    0x14(%ebp),%eax
  801547:	8d 48 04             	lea    0x4(%eax),%ecx
  80154a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801552:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801554:	eb 21                	jmp    801577 <vprintfmt+0xf3>
  801556:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801559:	85 c9                	test   %ecx,%ecx
  80155b:	b8 00 00 00 00       	mov    $0x0,%eax
  801560:	0f 49 c1             	cmovns %ecx,%eax
  801563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801566:	89 de                	mov    %ebx,%esi
  801568:	eb 8b                	jmp    8014f5 <vprintfmt+0x71>
  80156a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80156c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801573:	eb 80                	jmp    8014f5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801575:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801577:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80157b:	0f 89 74 ff ff ff    	jns    8014f5 <vprintfmt+0x71>
  801581:	e9 62 ff ff ff       	jmp    8014e8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801586:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801589:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80158b:	e9 65 ff ff ff       	jmp    8014f5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801590:	8b 45 14             	mov    0x14(%ebp),%eax
  801593:	8d 50 04             	lea    0x4(%eax),%edx
  801596:	89 55 14             	mov    %edx,0x14(%ebp)
  801599:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80159d:	8b 00                	mov    (%eax),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8015a5:	e9 03 ff ff ff       	jmp    8014ad <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8015aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ad:	8d 50 04             	lea    0x4(%eax),%edx
  8015b0:	89 55 14             	mov    %edx,0x14(%ebp)
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	99                   	cltd   
  8015b6:	31 d0                	xor    %edx,%eax
  8015b8:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8015ba:	83 f8 0f             	cmp    $0xf,%eax
  8015bd:	7f 0b                	jg     8015ca <vprintfmt+0x146>
  8015bf:	8b 14 85 20 25 80 00 	mov    0x802520(,%eax,4),%edx
  8015c6:	85 d2                	test   %edx,%edx
  8015c8:	75 20                	jne    8015ea <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  8015ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015ce:	c7 44 24 08 8b 22 80 	movl   $0x80228b,0x8(%esp)
  8015d5:	00 
  8015d6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015da:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dd:	89 04 24             	mov    %eax,(%esp)
  8015e0:	e8 77 fe ff ff       	call   80145c <printfmt>
  8015e5:	e9 c3 fe ff ff       	jmp    8014ad <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8015ea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ee:	c7 44 24 08 0b 22 80 	movl   $0x80220b,0x8(%esp)
  8015f5:	00 
  8015f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	89 04 24             	mov    %eax,(%esp)
  801600:	e8 57 fe ff ff       	call   80145c <printfmt>
  801605:	e9 a3 fe ff ff       	jmp    8014ad <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80160a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80160d:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801610:	8b 45 14             	mov    0x14(%ebp),%eax
  801613:	8d 50 04             	lea    0x4(%eax),%edx
  801616:	89 55 14             	mov    %edx,0x14(%ebp)
  801619:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  80161b:	85 c0                	test   %eax,%eax
  80161d:	ba 84 22 80 00       	mov    $0x802284,%edx
  801622:	0f 45 d0             	cmovne %eax,%edx
  801625:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  801628:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  80162c:	74 04                	je     801632 <vprintfmt+0x1ae>
  80162e:	85 f6                	test   %esi,%esi
  801630:	7f 19                	jg     80164b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801632:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801635:	8d 70 01             	lea    0x1(%eax),%esi
  801638:	0f b6 10             	movzbl (%eax),%edx
  80163b:	0f be c2             	movsbl %dl,%eax
  80163e:	85 c0                	test   %eax,%eax
  801640:	0f 85 95 00 00 00    	jne    8016db <vprintfmt+0x257>
  801646:	e9 85 00 00 00       	jmp    8016d0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80164b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80164f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801652:	89 04 24             	mov    %eax,(%esp)
  801655:	e8 b8 02 00 00       	call   801912 <strnlen>
  80165a:	29 c6                	sub    %eax,%esi
  80165c:	89 f0                	mov    %esi,%eax
  80165e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801661:	85 f6                	test   %esi,%esi
  801663:	7e cd                	jle    801632 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801665:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801669:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801672:	89 34 24             	mov    %esi,(%esp)
  801675:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801678:	83 eb 01             	sub    $0x1,%ebx
  80167b:	75 f1                	jne    80166e <vprintfmt+0x1ea>
  80167d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801680:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801683:	eb ad                	jmp    801632 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801685:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801689:	74 1e                	je     8016a9 <vprintfmt+0x225>
  80168b:	0f be d2             	movsbl %dl,%edx
  80168e:	83 ea 20             	sub    $0x20,%edx
  801691:	83 fa 5e             	cmp    $0x5e,%edx
  801694:	76 13                	jbe    8016a9 <vprintfmt+0x225>
					putch('?', putdat);
  801696:	8b 45 0c             	mov    0xc(%ebp),%eax
  801699:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8016a4:	ff 55 08             	call   *0x8(%ebp)
  8016a7:	eb 0d                	jmp    8016b6 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  8016a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ac:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016b0:	89 04 24             	mov    %eax,(%esp)
  8016b3:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016b6:	83 ef 01             	sub    $0x1,%edi
  8016b9:	83 c6 01             	add    $0x1,%esi
  8016bc:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8016c0:	0f be c2             	movsbl %dl,%eax
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	75 20                	jne    8016e7 <vprintfmt+0x263>
  8016c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016ca:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016d4:	7f 25                	jg     8016fb <vprintfmt+0x277>
  8016d6:	e9 d2 fd ff ff       	jmp    8014ad <vprintfmt+0x29>
  8016db:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8016de:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016e1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016e4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016e7:	85 db                	test   %ebx,%ebx
  8016e9:	78 9a                	js     801685 <vprintfmt+0x201>
  8016eb:	83 eb 01             	sub    $0x1,%ebx
  8016ee:	79 95                	jns    801685 <vprintfmt+0x201>
  8016f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016f3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016f9:	eb d5                	jmp    8016d0 <vprintfmt+0x24c>
  8016fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8016fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  801701:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801704:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801708:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80170f:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801711:	83 eb 01             	sub    $0x1,%ebx
  801714:	75 ee                	jne    801704 <vprintfmt+0x280>
  801716:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801719:	e9 8f fd ff ff       	jmp    8014ad <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  80171e:	83 fa 01             	cmp    $0x1,%edx
  801721:	7e 16                	jle    801739 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  801723:	8b 45 14             	mov    0x14(%ebp),%eax
  801726:	8d 50 08             	lea    0x8(%eax),%edx
  801729:	89 55 14             	mov    %edx,0x14(%ebp)
  80172c:	8b 50 04             	mov    0x4(%eax),%edx
  80172f:	8b 00                	mov    (%eax),%eax
  801731:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801734:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801737:	eb 32                	jmp    80176b <vprintfmt+0x2e7>
	else if (lflag)
  801739:	85 d2                	test   %edx,%edx
  80173b:	74 18                	je     801755 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80173d:	8b 45 14             	mov    0x14(%ebp),%eax
  801740:	8d 50 04             	lea    0x4(%eax),%edx
  801743:	89 55 14             	mov    %edx,0x14(%ebp)
  801746:	8b 30                	mov    (%eax),%esi
  801748:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80174b:	89 f0                	mov    %esi,%eax
  80174d:	c1 f8 1f             	sar    $0x1f,%eax
  801750:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801753:	eb 16                	jmp    80176b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801755:	8b 45 14             	mov    0x14(%ebp),%eax
  801758:	8d 50 04             	lea    0x4(%eax),%edx
  80175b:	89 55 14             	mov    %edx,0x14(%ebp)
  80175e:	8b 30                	mov    (%eax),%esi
  801760:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801763:	89 f0                	mov    %esi,%eax
  801765:	c1 f8 1f             	sar    $0x1f,%eax
  801768:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80176b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80176e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801771:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801776:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80177a:	0f 89 80 00 00 00    	jns    801800 <vprintfmt+0x37c>
				putch('-', putdat);
  801780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801784:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80178b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80178e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801791:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801794:	f7 d8                	neg    %eax
  801796:	83 d2 00             	adc    $0x0,%edx
  801799:	f7 da                	neg    %edx
			}
			base = 10;
  80179b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a0:	eb 5e                	jmp    801800 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8017a2:	8d 45 14             	lea    0x14(%ebp),%eax
  8017a5:	e8 5b fc ff ff       	call   801405 <getuint>
			base = 10;
  8017aa:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8017af:	eb 4f                	jmp    801800 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  8017b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8017b4:	e8 4c fc ff ff       	call   801405 <getuint>
			base = 8;
  8017b9:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8017be:	eb 40                	jmp    801800 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  8017c0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017c4:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8017cb:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8017ce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017d2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8017d9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8017dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017df:	8d 50 04             	lea    0x4(%eax),%edx
  8017e2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017e5:	8b 00                	mov    (%eax),%eax
  8017e7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8017ec:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017f1:	eb 0d                	jmp    801800 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017f3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017f6:	e8 0a fc ff ff       	call   801405 <getuint>
			base = 16;
  8017fb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  801800:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801804:	89 74 24 10          	mov    %esi,0x10(%esp)
  801808:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  80180b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80180f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801813:	89 04 24             	mov    %eax,(%esp)
  801816:	89 54 24 04          	mov    %edx,0x4(%esp)
  80181a:	89 fa                	mov    %edi,%edx
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	e8 ec fa ff ff       	call   801310 <printnum>
			break;
  801824:	e9 84 fc ff ff       	jmp    8014ad <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801829:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80182d:	89 0c 24             	mov    %ecx,(%esp)
  801830:	ff 55 08             	call   *0x8(%ebp)
			break;
  801833:	e9 75 fc ff ff       	jmp    8014ad <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801838:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80183c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801843:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801846:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80184a:	0f 84 5b fc ff ff    	je     8014ab <vprintfmt+0x27>
  801850:	89 f3                	mov    %esi,%ebx
  801852:	83 eb 01             	sub    $0x1,%ebx
  801855:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801859:	75 f7                	jne    801852 <vprintfmt+0x3ce>
  80185b:	e9 4d fc ff ff       	jmp    8014ad <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801860:	83 c4 3c             	add    $0x3c,%esp
  801863:	5b                   	pop    %ebx
  801864:	5e                   	pop    %esi
  801865:	5f                   	pop    %edi
  801866:	5d                   	pop    %ebp
  801867:	c3                   	ret    

00801868 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 28             	sub    $0x28,%esp
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801874:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801877:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80187b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80187e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801885:	85 c0                	test   %eax,%eax
  801887:	74 30                	je     8018b9 <vsnprintf+0x51>
  801889:	85 d2                	test   %edx,%edx
  80188b:	7e 2c                	jle    8018b9 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80188d:	8b 45 14             	mov    0x14(%ebp),%eax
  801890:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801894:	8b 45 10             	mov    0x10(%ebp),%eax
  801897:	89 44 24 08          	mov    %eax,0x8(%esp)
  80189b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80189e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a2:	c7 04 24 3f 14 80 00 	movl   $0x80143f,(%esp)
  8018a9:	e8 d6 fb ff ff       	call   801484 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8018ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8018b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b7:	eb 05                	jmp    8018be <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8018b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8018c6:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8018c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	89 04 24             	mov    %eax,(%esp)
  8018e1:	e8 82 ff ff ff       	call   801868 <vsnprintf>
	va_end(ap);

	return rc;
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    
  8018e8:	66 90                	xchg   %ax,%ax
  8018ea:	66 90                	xchg   %ax,%ax
  8018ec:	66 90                	xchg   %ax,%ax
  8018ee:	66 90                	xchg   %ax,%ax

008018f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018f6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018f9:	74 10                	je     80190b <strlen+0x1b>
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801900:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801903:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801907:	75 f7                	jne    801900 <strlen+0x10>
  801909:	eb 05                	jmp    801910 <strlen+0x20>
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    

00801912 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	53                   	push   %ebx
  801916:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801919:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80191c:	85 c9                	test   %ecx,%ecx
  80191e:	74 1c                	je     80193c <strnlen+0x2a>
  801920:	80 3b 00             	cmpb   $0x0,(%ebx)
  801923:	74 1e                	je     801943 <strnlen+0x31>
  801925:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  80192a:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80192c:	39 ca                	cmp    %ecx,%edx
  80192e:	74 18                	je     801948 <strnlen+0x36>
  801930:	83 c2 01             	add    $0x1,%edx
  801933:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801938:	75 f0                	jne    80192a <strnlen+0x18>
  80193a:	eb 0c                	jmp    801948 <strnlen+0x36>
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
  801941:	eb 05                	jmp    801948 <strnlen+0x36>
  801943:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801948:	5b                   	pop    %ebx
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801955:	89 c2                	mov    %eax,%edx
  801957:	83 c2 01             	add    $0x1,%edx
  80195a:	83 c1 01             	add    $0x1,%ecx
  80195d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801961:	88 5a ff             	mov    %bl,-0x1(%edx)
  801964:	84 db                	test   %bl,%bl
  801966:	75 ef                	jne    801957 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801968:	5b                   	pop    %ebx
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	53                   	push   %ebx
  80196f:	83 ec 08             	sub    $0x8,%esp
  801972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801975:	89 1c 24             	mov    %ebx,(%esp)
  801978:	e8 73 ff ff ff       	call   8018f0 <strlen>
	strcpy(dst + len, src);
  80197d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801980:	89 54 24 04          	mov    %edx,0x4(%esp)
  801984:	01 d8                	add    %ebx,%eax
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 bd ff ff ff       	call   80194b <strcpy>
	return dst;
}
  80198e:	89 d8                	mov    %ebx,%eax
  801990:	83 c4 08             	add    $0x8,%esp
  801993:	5b                   	pop    %ebx
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    

00801996 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	8b 75 08             	mov    0x8(%ebp),%esi
  80199e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019a4:	85 db                	test   %ebx,%ebx
  8019a6:	74 17                	je     8019bf <strncpy+0x29>
  8019a8:	01 f3                	add    %esi,%ebx
  8019aa:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  8019ac:	83 c1 01             	add    $0x1,%ecx
  8019af:	0f b6 02             	movzbl (%edx),%eax
  8019b2:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8019b5:	80 3a 01             	cmpb   $0x1,(%edx)
  8019b8:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019bb:	39 d9                	cmp    %ebx,%ecx
  8019bd:	75 ed                	jne    8019ac <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8019bf:	89 f0                	mov    %esi,%eax
  8019c1:	5b                   	pop    %ebx
  8019c2:	5e                   	pop    %esi
  8019c3:	5d                   	pop    %ebp
  8019c4:	c3                   	ret    

008019c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
  8019c8:	57                   	push   %edi
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
  8019cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019d1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019d4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019d6:	85 f6                	test   %esi,%esi
  8019d8:	74 34                	je     801a0e <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8019da:	83 fe 01             	cmp    $0x1,%esi
  8019dd:	74 26                	je     801a05 <strlcpy+0x40>
  8019df:	0f b6 0b             	movzbl (%ebx),%ecx
  8019e2:	84 c9                	test   %cl,%cl
  8019e4:	74 23                	je     801a09 <strlcpy+0x44>
  8019e6:	83 ee 02             	sub    $0x2,%esi
  8019e9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8019ee:	83 c0 01             	add    $0x1,%eax
  8019f1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019f4:	39 f2                	cmp    %esi,%edx
  8019f6:	74 13                	je     801a0b <strlcpy+0x46>
  8019f8:	83 c2 01             	add    $0x1,%edx
  8019fb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019ff:	84 c9                	test   %cl,%cl
  801a01:	75 eb                	jne    8019ee <strlcpy+0x29>
  801a03:	eb 06                	jmp    801a0b <strlcpy+0x46>
  801a05:	89 f8                	mov    %edi,%eax
  801a07:	eb 02                	jmp    801a0b <strlcpy+0x46>
  801a09:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  801a0b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801a0e:	29 f8                	sub    %edi,%eax
}
  801a10:	5b                   	pop    %ebx
  801a11:	5e                   	pop    %esi
  801a12:	5f                   	pop    %edi
  801a13:	5d                   	pop    %ebp
  801a14:	c3                   	ret    

00801a15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
  801a18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a1e:	0f b6 01             	movzbl (%ecx),%eax
  801a21:	84 c0                	test   %al,%al
  801a23:	74 15                	je     801a3a <strcmp+0x25>
  801a25:	3a 02                	cmp    (%edx),%al
  801a27:	75 11                	jne    801a3a <strcmp+0x25>
		p++, q++;
  801a29:	83 c1 01             	add    $0x1,%ecx
  801a2c:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801a2f:	0f b6 01             	movzbl (%ecx),%eax
  801a32:	84 c0                	test   %al,%al
  801a34:	74 04                	je     801a3a <strcmp+0x25>
  801a36:	3a 02                	cmp    (%edx),%al
  801a38:	74 ef                	je     801a29 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a3a:	0f b6 c0             	movzbl %al,%eax
  801a3d:	0f b6 12             	movzbl (%edx),%edx
  801a40:	29 d0                	sub    %edx,%eax
}
  801a42:	5d                   	pop    %ebp
  801a43:	c3                   	ret    

00801a44 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a52:	85 f6                	test   %esi,%esi
  801a54:	74 29                	je     801a7f <strncmp+0x3b>
  801a56:	0f b6 03             	movzbl (%ebx),%eax
  801a59:	84 c0                	test   %al,%al
  801a5b:	74 30                	je     801a8d <strncmp+0x49>
  801a5d:	3a 02                	cmp    (%edx),%al
  801a5f:	75 2c                	jne    801a8d <strncmp+0x49>
  801a61:	8d 43 01             	lea    0x1(%ebx),%eax
  801a64:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a66:	89 c3                	mov    %eax,%ebx
  801a68:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a6b:	39 f0                	cmp    %esi,%eax
  801a6d:	74 17                	je     801a86 <strncmp+0x42>
  801a6f:	0f b6 08             	movzbl (%eax),%ecx
  801a72:	84 c9                	test   %cl,%cl
  801a74:	74 17                	je     801a8d <strncmp+0x49>
  801a76:	83 c0 01             	add    $0x1,%eax
  801a79:	3a 0a                	cmp    (%edx),%cl
  801a7b:	74 e9                	je     801a66 <strncmp+0x22>
  801a7d:	eb 0e                	jmp    801a8d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a84:	eb 0f                	jmp    801a95 <strncmp+0x51>
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
  801a8b:	eb 08                	jmp    801a95 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a8d:	0f b6 03             	movzbl (%ebx),%eax
  801a90:	0f b6 12             	movzbl (%edx),%edx
  801a93:	29 d0                	sub    %edx,%eax
}
  801a95:	5b                   	pop    %ebx
  801a96:	5e                   	pop    %esi
  801a97:	5d                   	pop    %ebp
  801a98:	c3                   	ret    

00801a99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	53                   	push   %ebx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801aa3:	0f b6 18             	movzbl (%eax),%ebx
  801aa6:	84 db                	test   %bl,%bl
  801aa8:	74 1d                	je     801ac7 <strchr+0x2e>
  801aaa:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801aac:	38 d3                	cmp    %dl,%bl
  801aae:	75 06                	jne    801ab6 <strchr+0x1d>
  801ab0:	eb 1a                	jmp    801acc <strchr+0x33>
  801ab2:	38 ca                	cmp    %cl,%dl
  801ab4:	74 16                	je     801acc <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801ab6:	83 c0 01             	add    $0x1,%eax
  801ab9:	0f b6 10             	movzbl (%eax),%edx
  801abc:	84 d2                	test   %dl,%dl
  801abe:	75 f2                	jne    801ab2 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801ac0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac5:	eb 05                	jmp    801acc <strchr+0x33>
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801acc:	5b                   	pop    %ebx
  801acd:	5d                   	pop    %ebp
  801ace:	c3                   	ret    

00801acf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	53                   	push   %ebx
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801ad9:	0f b6 18             	movzbl (%eax),%ebx
  801adc:	84 db                	test   %bl,%bl
  801ade:	74 16                	je     801af6 <strfind+0x27>
  801ae0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801ae2:	38 d3                	cmp    %dl,%bl
  801ae4:	75 06                	jne    801aec <strfind+0x1d>
  801ae6:	eb 0e                	jmp    801af6 <strfind+0x27>
  801ae8:	38 ca                	cmp    %cl,%dl
  801aea:	74 0a                	je     801af6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801aec:	83 c0 01             	add    $0x1,%eax
  801aef:	0f b6 10             	movzbl (%eax),%edx
  801af2:	84 d2                	test   %dl,%dl
  801af4:	75 f2                	jne    801ae8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801af6:	5b                   	pop    %ebx
  801af7:	5d                   	pop    %ebp
  801af8:	c3                   	ret    

00801af9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
  801afc:	57                   	push   %edi
  801afd:	56                   	push   %esi
  801afe:	53                   	push   %ebx
  801aff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b02:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801b05:	85 c9                	test   %ecx,%ecx
  801b07:	74 36                	je     801b3f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801b09:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801b0f:	75 28                	jne    801b39 <memset+0x40>
  801b11:	f6 c1 03             	test   $0x3,%cl
  801b14:	75 23                	jne    801b39 <memset+0x40>
		c &= 0xFF;
  801b16:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801b1a:	89 d3                	mov    %edx,%ebx
  801b1c:	c1 e3 08             	shl    $0x8,%ebx
  801b1f:	89 d6                	mov    %edx,%esi
  801b21:	c1 e6 18             	shl    $0x18,%esi
  801b24:	89 d0                	mov    %edx,%eax
  801b26:	c1 e0 10             	shl    $0x10,%eax
  801b29:	09 f0                	or     %esi,%eax
  801b2b:	09 c2                	or     %eax,%edx
  801b2d:	89 d0                	mov    %edx,%eax
  801b2f:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b31:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b34:	fc                   	cld    
  801b35:	f3 ab                	rep stos %eax,%es:(%edi)
  801b37:	eb 06                	jmp    801b3f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b39:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3c:	fc                   	cld    
  801b3d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b3f:	89 f8                	mov    %edi,%eax
  801b41:	5b                   	pop    %ebx
  801b42:	5e                   	pop    %esi
  801b43:	5f                   	pop    %edi
  801b44:	5d                   	pop    %ebp
  801b45:	c3                   	ret    

00801b46 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	57                   	push   %edi
  801b4a:	56                   	push   %esi
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b54:	39 c6                	cmp    %eax,%esi
  801b56:	73 35                	jae    801b8d <memmove+0x47>
  801b58:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b5b:	39 d0                	cmp    %edx,%eax
  801b5d:	73 2e                	jae    801b8d <memmove+0x47>
		s += n;
		d += n;
  801b5f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b62:	89 d6                	mov    %edx,%esi
  801b64:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b6c:	75 13                	jne    801b81 <memmove+0x3b>
  801b6e:	f6 c1 03             	test   $0x3,%cl
  801b71:	75 0e                	jne    801b81 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b73:	83 ef 04             	sub    $0x4,%edi
  801b76:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b79:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b7c:	fd                   	std    
  801b7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b7f:	eb 09                	jmp    801b8a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b81:	83 ef 01             	sub    $0x1,%edi
  801b84:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b87:	fd                   	std    
  801b88:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b8a:	fc                   	cld    
  801b8b:	eb 1d                	jmp    801baa <memmove+0x64>
  801b8d:	89 f2                	mov    %esi,%edx
  801b8f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b91:	f6 c2 03             	test   $0x3,%dl
  801b94:	75 0f                	jne    801ba5 <memmove+0x5f>
  801b96:	f6 c1 03             	test   $0x3,%cl
  801b99:	75 0a                	jne    801ba5 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b9b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b9e:	89 c7                	mov    %eax,%edi
  801ba0:	fc                   	cld    
  801ba1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801ba3:	eb 05                	jmp    801baa <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801ba5:	89 c7                	mov    %eax,%edi
  801ba7:	fc                   	cld    
  801ba8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801baa:	5e                   	pop    %esi
  801bab:	5f                   	pop    %edi
  801bac:	5d                   	pop    %ebp
  801bad:	c3                   	ret    

00801bae <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
  801bb1:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801bb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 79 ff ff ff       	call   801b46 <memmove>
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	57                   	push   %edi
  801bd3:	56                   	push   %esi
  801bd4:	53                   	push   %ebx
  801bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bdb:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bde:	8d 78 ff             	lea    -0x1(%eax),%edi
  801be1:	85 c0                	test   %eax,%eax
  801be3:	74 36                	je     801c1b <memcmp+0x4c>
		if (*s1 != *s2)
  801be5:	0f b6 03             	movzbl (%ebx),%eax
  801be8:	0f b6 0e             	movzbl (%esi),%ecx
  801beb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bf0:	38 c8                	cmp    %cl,%al
  801bf2:	74 1c                	je     801c10 <memcmp+0x41>
  801bf4:	eb 10                	jmp    801c06 <memcmp+0x37>
  801bf6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801bfb:	83 c2 01             	add    $0x1,%edx
  801bfe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801c02:	38 c8                	cmp    %cl,%al
  801c04:	74 0a                	je     801c10 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801c06:	0f b6 c0             	movzbl %al,%eax
  801c09:	0f b6 c9             	movzbl %cl,%ecx
  801c0c:	29 c8                	sub    %ecx,%eax
  801c0e:	eb 10                	jmp    801c20 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801c10:	39 fa                	cmp    %edi,%edx
  801c12:	75 e2                	jne    801bf6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 05                	jmp    801c20 <memcmp+0x51>
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	53                   	push   %ebx
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801c2f:	89 c2                	mov    %eax,%edx
  801c31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c34:	39 d0                	cmp    %edx,%eax
  801c36:	73 13                	jae    801c4b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c38:	89 d9                	mov    %ebx,%ecx
  801c3a:	38 18                	cmp    %bl,(%eax)
  801c3c:	75 06                	jne    801c44 <memfind+0x1f>
  801c3e:	eb 0b                	jmp    801c4b <memfind+0x26>
  801c40:	38 08                	cmp    %cl,(%eax)
  801c42:	74 07                	je     801c4b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c44:	83 c0 01             	add    $0x1,%eax
  801c47:	39 d0                	cmp    %edx,%eax
  801c49:	75 f5                	jne    801c40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c4b:	5b                   	pop    %ebx
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    

00801c4e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	57                   	push   %edi
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	8b 55 08             	mov    0x8(%ebp),%edx
  801c57:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c5a:	0f b6 0a             	movzbl (%edx),%ecx
  801c5d:	80 f9 09             	cmp    $0x9,%cl
  801c60:	74 05                	je     801c67 <strtol+0x19>
  801c62:	80 f9 20             	cmp    $0x20,%cl
  801c65:	75 10                	jne    801c77 <strtol+0x29>
		s++;
  801c67:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c6a:	0f b6 0a             	movzbl (%edx),%ecx
  801c6d:	80 f9 09             	cmp    $0x9,%cl
  801c70:	74 f5                	je     801c67 <strtol+0x19>
  801c72:	80 f9 20             	cmp    $0x20,%cl
  801c75:	74 f0                	je     801c67 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c77:	80 f9 2b             	cmp    $0x2b,%cl
  801c7a:	75 0a                	jne    801c86 <strtol+0x38>
		s++;
  801c7c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c7f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c84:	eb 11                	jmp    801c97 <strtol+0x49>
  801c86:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c8b:	80 f9 2d             	cmp    $0x2d,%cl
  801c8e:	75 07                	jne    801c97 <strtol+0x49>
		s++, neg = 1;
  801c90:	83 c2 01             	add    $0x1,%edx
  801c93:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c97:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c9c:	75 15                	jne    801cb3 <strtol+0x65>
  801c9e:	80 3a 30             	cmpb   $0x30,(%edx)
  801ca1:	75 10                	jne    801cb3 <strtol+0x65>
  801ca3:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801ca7:	75 0a                	jne    801cb3 <strtol+0x65>
		s += 2, base = 16;
  801ca9:	83 c2 02             	add    $0x2,%edx
  801cac:	b8 10 00 00 00       	mov    $0x10,%eax
  801cb1:	eb 10                	jmp    801cc3 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801cb3:	85 c0                	test   %eax,%eax
  801cb5:	75 0c                	jne    801cc3 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801cb7:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801cb9:	80 3a 30             	cmpb   $0x30,(%edx)
  801cbc:	75 05                	jne    801cc3 <strtol+0x75>
		s++, base = 8;
  801cbe:	83 c2 01             	add    $0x1,%edx
  801cc1:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801cc3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cc8:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801ccb:	0f b6 0a             	movzbl (%edx),%ecx
  801cce:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801cd1:	89 f0                	mov    %esi,%eax
  801cd3:	3c 09                	cmp    $0x9,%al
  801cd5:	77 08                	ja     801cdf <strtol+0x91>
			dig = *s - '0';
  801cd7:	0f be c9             	movsbl %cl,%ecx
  801cda:	83 e9 30             	sub    $0x30,%ecx
  801cdd:	eb 20                	jmp    801cff <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801cdf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801ce2:	89 f0                	mov    %esi,%eax
  801ce4:	3c 19                	cmp    $0x19,%al
  801ce6:	77 08                	ja     801cf0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801ce8:	0f be c9             	movsbl %cl,%ecx
  801ceb:	83 e9 57             	sub    $0x57,%ecx
  801cee:	eb 0f                	jmp    801cff <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801cf0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801cf3:	89 f0                	mov    %esi,%eax
  801cf5:	3c 19                	cmp    $0x19,%al
  801cf7:	77 16                	ja     801d0f <strtol+0xc1>
			dig = *s - 'A' + 10;
  801cf9:	0f be c9             	movsbl %cl,%ecx
  801cfc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801cff:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801d02:	7d 0f                	jge    801d13 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801d04:	83 c2 01             	add    $0x1,%edx
  801d07:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801d0b:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801d0d:	eb bc                	jmp    801ccb <strtol+0x7d>
  801d0f:	89 d8                	mov    %ebx,%eax
  801d11:	eb 02                	jmp    801d15 <strtol+0xc7>
  801d13:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801d15:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d19:	74 05                	je     801d20 <strtol+0xd2>
		*endptr = (char *) s;
  801d1b:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d1e:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801d20:	f7 d8                	neg    %eax
  801d22:	85 ff                	test   %edi,%edi
  801d24:	0f 44 c3             	cmove  %ebx,%eax
}
  801d27:	5b                   	pop    %ebx
  801d28:	5e                   	pop    %esi
  801d29:	5f                   	pop    %edi
  801d2a:	5d                   	pop    %ebp
  801d2b:	c3                   	ret    

00801d2c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	56                   	push   %esi
  801d30:	53                   	push   %ebx
  801d31:	83 ec 10             	sub    $0x10,%esp
  801d34:	8b 75 08             	mov    0x8(%ebp),%esi
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg != NULL ? pg : (void*)UTOP);
  801d3d:	85 c0                	test   %eax,%eax
  801d3f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d44:	0f 44 c2             	cmove  %edx,%eax
  801d47:	89 04 24             	mov    %eax,(%esp)
  801d4a:	e8 74 e6 ff ff       	call   8003c3 <sys_ipc_recv>
	if (err_code < 0) {
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	79 16                	jns    801d69 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d53:	85 f6                	test   %esi,%esi
  801d55:	74 06                	je     801d5d <ipc_recv+0x31>
  801d57:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d5d:	85 db                	test   %ebx,%ebx
  801d5f:	74 2c                	je     801d8d <ipc_recv+0x61>
  801d61:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d67:	eb 24                	jmp    801d8d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d69:	85 f6                	test   %esi,%esi
  801d6b:	74 0a                	je     801d77 <ipc_recv+0x4b>
  801d6d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d72:	8b 40 74             	mov    0x74(%eax),%eax
  801d75:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d77:	85 db                	test   %ebx,%ebx
  801d79:	74 0a                	je     801d85 <ipc_recv+0x59>
  801d7b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d80:	8b 40 78             	mov    0x78(%eax),%eax
  801d83:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d85:	a1 04 40 80 00       	mov    0x804004,%eax
  801d8a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	5b                   	pop    %ebx
  801d91:	5e                   	pop    %esi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    

00801d94 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 1c             	sub    $0x1c,%esp
  801d9d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801da0:	8b 75 0c             	mov    0xc(%ebp),%esi
  801da3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801da6:	eb 25                	jmp    801dcd <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801da8:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801dab:	74 20                	je     801dcd <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801dad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db1:	c7 44 24 08 80 25 80 	movl   $0x802580,0x8(%esp)
  801db8:	00 
  801db9:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801dc0:	00 
  801dc1:	c7 04 24 8c 25 80 00 	movl   $0x80258c,(%esp)
  801dc8:	e8 29 f4 ff ff       	call   8011f6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801dcd:	85 db                	test   %ebx,%ebx
  801dcf:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801dd4:	0f 45 c3             	cmovne %ebx,%eax
  801dd7:	8b 55 14             	mov    0x14(%ebp),%edx
  801dda:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dde:	89 44 24 08          	mov    %eax,0x8(%esp)
  801de2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801de6:	89 3c 24             	mov    %edi,(%esp)
  801de9:	e8 b2 e5 ff ff       	call   8003a0 <sys_ipc_try_send>
  801dee:	85 c0                	test   %eax,%eax
  801df0:	75 b6                	jne    801da8 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801df2:	83 c4 1c             	add    $0x1c,%esp
  801df5:	5b                   	pop    %ebx
  801df6:	5e                   	pop    %esi
  801df7:	5f                   	pop    %edi
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    

00801dfa <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801e00:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801e05:	39 c8                	cmp    %ecx,%eax
  801e07:	74 17                	je     801e20 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801e0e:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801e11:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801e17:	8b 52 50             	mov    0x50(%edx),%edx
  801e1a:	39 ca                	cmp    %ecx,%edx
  801e1c:	75 14                	jne    801e32 <ipc_find_env+0x38>
  801e1e:	eb 05                	jmp    801e25 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e20:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801e25:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e28:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801e2d:	8b 40 40             	mov    0x40(%eax),%eax
  801e30:	eb 0e                	jmp    801e40 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e32:	83 c0 01             	add    $0x1,%eax
  801e35:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e3a:	75 d2                	jne    801e0e <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e3c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e40:	5d                   	pop    %ebp
  801e41:	c3                   	ret    

00801e42 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e42:	55                   	push   %ebp
  801e43:	89 e5                	mov    %esp,%ebp
  801e45:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e48:	89 d0                	mov    %edx,%eax
  801e4a:	c1 e8 16             	shr    $0x16,%eax
  801e4d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e59:	f6 c1 01             	test   $0x1,%cl
  801e5c:	74 1d                	je     801e7b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e5e:	c1 ea 0c             	shr    $0xc,%edx
  801e61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e68:	f6 c2 01             	test   $0x1,%dl
  801e6b:	74 0e                	je     801e7b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e6d:	c1 ea 0c             	shr    $0xc,%edx
  801e70:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e77:	ef 
  801e78:	0f b7 c0             	movzwl %ax,%eax
}
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
  801e7d:	66 90                	xchg   %ax,%ax
  801e7f:	90                   	nop

00801e80 <__udivdi3>:
  801e80:	55                   	push   %ebp
  801e81:	57                   	push   %edi
  801e82:	56                   	push   %esi
  801e83:	83 ec 0c             	sub    $0xc,%esp
  801e86:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e8a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e8e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e92:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e96:	85 c0                	test   %eax,%eax
  801e98:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e9c:	89 ea                	mov    %ebp,%edx
  801e9e:	89 0c 24             	mov    %ecx,(%esp)
  801ea1:	75 2d                	jne    801ed0 <__udivdi3+0x50>
  801ea3:	39 e9                	cmp    %ebp,%ecx
  801ea5:	77 61                	ja     801f08 <__udivdi3+0x88>
  801ea7:	85 c9                	test   %ecx,%ecx
  801ea9:	89 ce                	mov    %ecx,%esi
  801eab:	75 0b                	jne    801eb8 <__udivdi3+0x38>
  801ead:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb2:	31 d2                	xor    %edx,%edx
  801eb4:	f7 f1                	div    %ecx
  801eb6:	89 c6                	mov    %eax,%esi
  801eb8:	31 d2                	xor    %edx,%edx
  801eba:	89 e8                	mov    %ebp,%eax
  801ebc:	f7 f6                	div    %esi
  801ebe:	89 c5                	mov    %eax,%ebp
  801ec0:	89 f8                	mov    %edi,%eax
  801ec2:	f7 f6                	div    %esi
  801ec4:	89 ea                	mov    %ebp,%edx
  801ec6:	83 c4 0c             	add    $0xc,%esp
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	39 e8                	cmp    %ebp,%eax
  801ed2:	77 24                	ja     801ef8 <__udivdi3+0x78>
  801ed4:	0f bd e8             	bsr    %eax,%ebp
  801ed7:	83 f5 1f             	xor    $0x1f,%ebp
  801eda:	75 3c                	jne    801f18 <__udivdi3+0x98>
  801edc:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ee0:	39 34 24             	cmp    %esi,(%esp)
  801ee3:	0f 86 9f 00 00 00    	jbe    801f88 <__udivdi3+0x108>
  801ee9:	39 d0                	cmp    %edx,%eax
  801eeb:	0f 82 97 00 00 00    	jb     801f88 <__udivdi3+0x108>
  801ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ef8:	31 d2                	xor    %edx,%edx
  801efa:	31 c0                	xor    %eax,%eax
  801efc:	83 c4 0c             	add    $0xc,%esp
  801eff:	5e                   	pop    %esi
  801f00:	5f                   	pop    %edi
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    
  801f03:	90                   	nop
  801f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f08:	89 f8                	mov    %edi,%eax
  801f0a:	f7 f1                	div    %ecx
  801f0c:	31 d2                	xor    %edx,%edx
  801f0e:	83 c4 0c             	add    $0xc,%esp
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    
  801f15:	8d 76 00             	lea    0x0(%esi),%esi
  801f18:	89 e9                	mov    %ebp,%ecx
  801f1a:	8b 3c 24             	mov    (%esp),%edi
  801f1d:	d3 e0                	shl    %cl,%eax
  801f1f:	89 c6                	mov    %eax,%esi
  801f21:	b8 20 00 00 00       	mov    $0x20,%eax
  801f26:	29 e8                	sub    %ebp,%eax
  801f28:	89 c1                	mov    %eax,%ecx
  801f2a:	d3 ef                	shr    %cl,%edi
  801f2c:	89 e9                	mov    %ebp,%ecx
  801f2e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f32:	8b 3c 24             	mov    (%esp),%edi
  801f35:	09 74 24 08          	or     %esi,0x8(%esp)
  801f39:	89 d6                	mov    %edx,%esi
  801f3b:	d3 e7                	shl    %cl,%edi
  801f3d:	89 c1                	mov    %eax,%ecx
  801f3f:	89 3c 24             	mov    %edi,(%esp)
  801f42:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f46:	d3 ee                	shr    %cl,%esi
  801f48:	89 e9                	mov    %ebp,%ecx
  801f4a:	d3 e2                	shl    %cl,%edx
  801f4c:	89 c1                	mov    %eax,%ecx
  801f4e:	d3 ef                	shr    %cl,%edi
  801f50:	09 d7                	or     %edx,%edi
  801f52:	89 f2                	mov    %esi,%edx
  801f54:	89 f8                	mov    %edi,%eax
  801f56:	f7 74 24 08          	divl   0x8(%esp)
  801f5a:	89 d6                	mov    %edx,%esi
  801f5c:	89 c7                	mov    %eax,%edi
  801f5e:	f7 24 24             	mull   (%esp)
  801f61:	39 d6                	cmp    %edx,%esi
  801f63:	89 14 24             	mov    %edx,(%esp)
  801f66:	72 30                	jb     801f98 <__udivdi3+0x118>
  801f68:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f6c:	89 e9                	mov    %ebp,%ecx
  801f6e:	d3 e2                	shl    %cl,%edx
  801f70:	39 c2                	cmp    %eax,%edx
  801f72:	73 05                	jae    801f79 <__udivdi3+0xf9>
  801f74:	3b 34 24             	cmp    (%esp),%esi
  801f77:	74 1f                	je     801f98 <__udivdi3+0x118>
  801f79:	89 f8                	mov    %edi,%eax
  801f7b:	31 d2                	xor    %edx,%edx
  801f7d:	e9 7a ff ff ff       	jmp    801efc <__udivdi3+0x7c>
  801f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f88:	31 d2                	xor    %edx,%edx
  801f8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8f:	e9 68 ff ff ff       	jmp    801efc <__udivdi3+0x7c>
  801f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f98:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	83 c4 0c             	add    $0xc,%esp
  801fa0:	5e                   	pop    %esi
  801fa1:	5f                   	pop    %edi
  801fa2:	5d                   	pop    %ebp
  801fa3:	c3                   	ret    
  801fa4:	66 90                	xchg   %ax,%ax
  801fa6:	66 90                	xchg   %ax,%ax
  801fa8:	66 90                	xchg   %ax,%ax
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	66 90                	xchg   %ax,%ax
  801fae:	66 90                	xchg   %ax,%ax

00801fb0 <__umoddi3>:
  801fb0:	55                   	push   %ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	83 ec 14             	sub    $0x14,%esp
  801fb6:	8b 44 24 28          	mov    0x28(%esp),%eax
  801fba:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801fbe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801fc2:	89 c7                	mov    %eax,%edi
  801fc4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc8:	8b 44 24 30          	mov    0x30(%esp),%eax
  801fcc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fd0:	89 34 24             	mov    %esi,(%esp)
  801fd3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fd7:	85 c0                	test   %eax,%eax
  801fd9:	89 c2                	mov    %eax,%edx
  801fdb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fdf:	75 17                	jne    801ff8 <__umoddi3+0x48>
  801fe1:	39 fe                	cmp    %edi,%esi
  801fe3:	76 4b                	jbe    802030 <__umoddi3+0x80>
  801fe5:	89 c8                	mov    %ecx,%eax
  801fe7:	89 fa                	mov    %edi,%edx
  801fe9:	f7 f6                	div    %esi
  801feb:	89 d0                	mov    %edx,%eax
  801fed:	31 d2                	xor    %edx,%edx
  801fef:	83 c4 14             	add    $0x14,%esp
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
  801ff6:	66 90                	xchg   %ax,%ax
  801ff8:	39 f8                	cmp    %edi,%eax
  801ffa:	77 54                	ja     802050 <__umoddi3+0xa0>
  801ffc:	0f bd e8             	bsr    %eax,%ebp
  801fff:	83 f5 1f             	xor    $0x1f,%ebp
  802002:	75 5c                	jne    802060 <__umoddi3+0xb0>
  802004:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802008:	39 3c 24             	cmp    %edi,(%esp)
  80200b:	0f 87 e7 00 00 00    	ja     8020f8 <__umoddi3+0x148>
  802011:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802015:	29 f1                	sub    %esi,%ecx
  802017:	19 c7                	sbb    %eax,%edi
  802019:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80201d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802021:	8b 44 24 08          	mov    0x8(%esp),%eax
  802025:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802029:	83 c4 14             	add    $0x14,%esp
  80202c:	5e                   	pop    %esi
  80202d:	5f                   	pop    %edi
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    
  802030:	85 f6                	test   %esi,%esi
  802032:	89 f5                	mov    %esi,%ebp
  802034:	75 0b                	jne    802041 <__umoddi3+0x91>
  802036:	b8 01 00 00 00       	mov    $0x1,%eax
  80203b:	31 d2                	xor    %edx,%edx
  80203d:	f7 f6                	div    %esi
  80203f:	89 c5                	mov    %eax,%ebp
  802041:	8b 44 24 04          	mov    0x4(%esp),%eax
  802045:	31 d2                	xor    %edx,%edx
  802047:	f7 f5                	div    %ebp
  802049:	89 c8                	mov    %ecx,%eax
  80204b:	f7 f5                	div    %ebp
  80204d:	eb 9c                	jmp    801feb <__umoddi3+0x3b>
  80204f:	90                   	nop
  802050:	89 c8                	mov    %ecx,%eax
  802052:	89 fa                	mov    %edi,%edx
  802054:	83 c4 14             	add    $0x14,%esp
  802057:	5e                   	pop    %esi
  802058:	5f                   	pop    %edi
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    
  80205b:	90                   	nop
  80205c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802060:	8b 04 24             	mov    (%esp),%eax
  802063:	be 20 00 00 00       	mov    $0x20,%esi
  802068:	89 e9                	mov    %ebp,%ecx
  80206a:	29 ee                	sub    %ebp,%esi
  80206c:	d3 e2                	shl    %cl,%edx
  80206e:	89 f1                	mov    %esi,%ecx
  802070:	d3 e8                	shr    %cl,%eax
  802072:	89 e9                	mov    %ebp,%ecx
  802074:	89 44 24 04          	mov    %eax,0x4(%esp)
  802078:	8b 04 24             	mov    (%esp),%eax
  80207b:	09 54 24 04          	or     %edx,0x4(%esp)
  80207f:	89 fa                	mov    %edi,%edx
  802081:	d3 e0                	shl    %cl,%eax
  802083:	89 f1                	mov    %esi,%ecx
  802085:	89 44 24 08          	mov    %eax,0x8(%esp)
  802089:	8b 44 24 10          	mov    0x10(%esp),%eax
  80208d:	d3 ea                	shr    %cl,%edx
  80208f:	89 e9                	mov    %ebp,%ecx
  802091:	d3 e7                	shl    %cl,%edi
  802093:	89 f1                	mov    %esi,%ecx
  802095:	d3 e8                	shr    %cl,%eax
  802097:	89 e9                	mov    %ebp,%ecx
  802099:	09 f8                	or     %edi,%eax
  80209b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80209f:	f7 74 24 04          	divl   0x4(%esp)
  8020a3:	d3 e7                	shl    %cl,%edi
  8020a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8020a9:	89 d7                	mov    %edx,%edi
  8020ab:	f7 64 24 08          	mull   0x8(%esp)
  8020af:	39 d7                	cmp    %edx,%edi
  8020b1:	89 c1                	mov    %eax,%ecx
  8020b3:	89 14 24             	mov    %edx,(%esp)
  8020b6:	72 2c                	jb     8020e4 <__umoddi3+0x134>
  8020b8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8020bc:	72 22                	jb     8020e0 <__umoddi3+0x130>
  8020be:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8020c2:	29 c8                	sub    %ecx,%eax
  8020c4:	19 d7                	sbb    %edx,%edi
  8020c6:	89 e9                	mov    %ebp,%ecx
  8020c8:	89 fa                	mov    %edi,%edx
  8020ca:	d3 e8                	shr    %cl,%eax
  8020cc:	89 f1                	mov    %esi,%ecx
  8020ce:	d3 e2                	shl    %cl,%edx
  8020d0:	89 e9                	mov    %ebp,%ecx
  8020d2:	d3 ef                	shr    %cl,%edi
  8020d4:	09 d0                	or     %edx,%eax
  8020d6:	89 fa                	mov    %edi,%edx
  8020d8:	83 c4 14             	add    $0x14,%esp
  8020db:	5e                   	pop    %esi
  8020dc:	5f                   	pop    %edi
  8020dd:	5d                   	pop    %ebp
  8020de:	c3                   	ret    
  8020df:	90                   	nop
  8020e0:	39 d7                	cmp    %edx,%edi
  8020e2:	75 da                	jne    8020be <__umoddi3+0x10e>
  8020e4:	8b 14 24             	mov    (%esp),%edx
  8020e7:	89 c1                	mov    %eax,%ecx
  8020e9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020ed:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020f1:	eb cb                	jmp    8020be <__umoddi3+0x10e>
  8020f3:	90                   	nop
  8020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020f8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020fc:	0f 82 0f ff ff ff    	jb     802011 <__umoddi3+0x61>
  802102:	e9 1a ff ff ff       	jmp    802021 <__umoddi3+0x71>
