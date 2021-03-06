
obj/user/buggyhello.debug:     file format elf32-i386


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
	sys_cputs((char*)1, 1);
  800039:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800040:	00 
  800041:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
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
  80014b:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800152:	00 
  800153:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80015a:	00 
  80015b:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800162:	e8 5f 10 00 00       	call   8011c6 <_panic>

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
  8001dd:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8001e4:	00 
  8001e5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001ec:	00 
  8001ed:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  8001f4:	e8 cd 0f 00 00       	call   8011c6 <_panic>

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
  800230:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800237:	00 
  800238:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80023f:	00 
  800240:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800247:	e8 7a 0f 00 00       	call   8011c6 <_panic>

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
  800283:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  80028a:	00 
  80028b:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800292:	00 
  800293:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  80029a:	e8 27 0f 00 00       	call   8011c6 <_panic>

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
  8002d6:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8002dd:	00 
  8002de:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002e5:	00 
  8002e6:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  8002ed:	e8 d4 0e 00 00       	call   8011c6 <_panic>

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
  800329:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800330:	00 
  800331:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800338:	00 
  800339:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800340:	e8 81 0e 00 00       	call   8011c6 <_panic>

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
  80037c:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800383:	00 
  800384:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80038b:	00 
  80038c:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800393:	e8 2e 0e 00 00       	call   8011c6 <_panic>

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
  8003f1:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8003f8:	00 
  8003f9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800400:	00 
  800401:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800408:	e8 b9 0d 00 00       	call   8011c6 <_panic>

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
  800565:	c7 04 24 18 21 80 00 	movl   $0x802118,(%esp)
  80056c:	e8 4e 0d 00 00       	call   8012bf <cprintf>
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
  8007bb:	c7 04 24 59 21 80 00 	movl   $0x802159,(%esp)
  8007c2:	e8 f8 0a 00 00       	call   8012bf <cprintf>
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
  8008a3:	c7 04 24 75 21 80 00 	movl   $0x802175,(%esp)
  8008aa:	e8 10 0a 00 00       	call   8012bf <cprintf>
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
  80095c:	c7 04 24 38 21 80 00 	movl   $0x802138,(%esp)
  800963:	e8 57 09 00 00       	call   8012bf <cprintf>
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
  800a22:	e8 af 01 00 00       	call   800bd6 <open>
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
  800a57:	89 c6                	mov    %eax,%esi
  800a59:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a5b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a62:	75 11                	jne    800a75 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a6b:	e8 5a 13 00 00       	call   801dca <ipc_find_env>
  800a70:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a75:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800a7c:	00 
  800a7d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800a84:	00 
  800a85:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a89:	a1 00 40 80 00       	mov    0x804000,%eax
  800a8e:	89 04 24             	mov    %eax,(%esp)
  800a91:	e8 ce 12 00 00       	call   801d64 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a96:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800a9d:	00 
  800a9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800aa9:	e8 4e 12 00 00       	call   801cfc <ipc_recv>
}
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	5b                   	pop    %ebx
  800ab2:	5e                   	pop    %esi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	53                   	push   %ebx
  800ab9:	83 ec 14             	sub    $0x14,%esp
  800abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ac5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800aca:	ba 00 00 00 00       	mov    $0x0,%edx
  800acf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ad4:	e8 76 ff ff ff       	call   800a4f <fsipc>
  800ad9:	89 c2                	mov    %eax,%edx
  800adb:	85 d2                	test   %edx,%edx
  800add:	78 2b                	js     800b0a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800adf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ae6:	00 
  800ae7:	89 1c 24             	mov    %ebx,(%esp)
  800aea:	e8 2c 0e 00 00       	call   80191b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800aef:	a1 80 50 80 00       	mov    0x805080,%eax
  800af4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800afa:	a1 84 50 80 00       	mov    0x805084,%eax
  800aff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0a:	83 c4 14             	add    $0x14,%esp
  800b0d:	5b                   	pop    %ebx
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
  800b13:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	8b 40 0c             	mov    0xc(%eax),%eax
  800b1c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b21:	ba 00 00 00 00       	mov    $0x0,%edx
  800b26:	b8 06 00 00 00       	mov    $0x6,%eax
  800b2b:	e8 1f ff ff ff       	call   800a4f <fsipc>
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	56                   	push   %esi
  800b36:	53                   	push   %ebx
  800b37:	83 ec 10             	sub    $0x10,%esp
  800b3a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	8b 40 0c             	mov    0xc(%eax),%eax
  800b43:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b48:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b53:	b8 03 00 00 00       	mov    $0x3,%eax
  800b58:	e8 f2 fe ff ff       	call   800a4f <fsipc>
  800b5d:	89 c3                	mov    %eax,%ebx
  800b5f:	85 c0                	test   %eax,%eax
  800b61:	78 6a                	js     800bcd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b63:	39 c6                	cmp    %eax,%esi
  800b65:	73 24                	jae    800b8b <devfile_read+0x59>
  800b67:	c7 44 24 0c 92 21 80 	movl   $0x802192,0xc(%esp)
  800b6e:	00 
  800b6f:	c7 44 24 08 99 21 80 	movl   $0x802199,0x8(%esp)
  800b76:	00 
  800b77:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  800b7e:	00 
  800b7f:	c7 04 24 ae 21 80 00 	movl   $0x8021ae,(%esp)
  800b86:	e8 3b 06 00 00       	call   8011c6 <_panic>
	assert(r <= PGSIZE);
  800b8b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b90:	7e 24                	jle    800bb6 <devfile_read+0x84>
  800b92:	c7 44 24 0c b9 21 80 	movl   $0x8021b9,0xc(%esp)
  800b99:	00 
  800b9a:	c7 44 24 08 99 21 80 	movl   $0x802199,0x8(%esp)
  800ba1:	00 
  800ba2:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800ba9:	00 
  800baa:	c7 04 24 ae 21 80 00 	movl   $0x8021ae,(%esp)
  800bb1:	e8 10 06 00 00       	call   8011c6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bba:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bc1:	00 
  800bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc5:	89 04 24             	mov    %eax,(%esp)
  800bc8:	e8 49 0f 00 00       	call   801b16 <memmove>
	return r;
}
  800bcd:	89 d8                	mov    %ebx,%eax
  800bcf:	83 c4 10             	add    $0x10,%esp
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	53                   	push   %ebx
  800bda:	83 ec 24             	sub    $0x24,%esp
  800bdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800be0:	89 1c 24             	mov    %ebx,(%esp)
  800be3:	e8 d8 0c 00 00       	call   8018c0 <strlen>
  800be8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bed:	7f 60                	jg     800c4f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800bef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bf2:	89 04 24             	mov    %eax,(%esp)
  800bf5:	e8 4d f8 ff ff       	call   800447 <fd_alloc>
  800bfa:	89 c2                	mov    %eax,%edx
  800bfc:	85 d2                	test   %edx,%edx
  800bfe:	78 54                	js     800c54 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800c00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c04:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800c0b:	e8 0b 0d 00 00       	call   80191b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c13:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c1b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c20:	e8 2a fe ff ff       	call   800a4f <fsipc>
  800c25:	89 c3                	mov    %eax,%ebx
  800c27:	85 c0                	test   %eax,%eax
  800c29:	79 17                	jns    800c42 <open+0x6c>
		fd_close(fd, 0);
  800c2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c32:	00 
  800c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c36:	89 04 24             	mov    %eax,(%esp)
  800c39:	e8 44 f9 ff ff       	call   800582 <fd_close>
		return r;
  800c3e:	89 d8                	mov    %ebx,%eax
  800c40:	eb 12                	jmp    800c54 <open+0x7e>
	}
	return fd2num(fd);
  800c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c45:	89 04 24             	mov    %eax,(%esp)
  800c48:	e8 d3 f7 ff ff       	call   800420 <fd2num>
  800c4d:	eb 05                	jmp    800c54 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c4f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800c54:	83 c4 24             	add    $0x24,%esp
  800c57:	5b                   	pop    %ebx
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    
  800c5a:	66 90                	xchg   %ax,%ax
  800c5c:	66 90                	xchg   %ax,%ax
  800c5e:	66 90                	xchg   %ax,%ax

00800c60 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	83 ec 10             	sub    $0x10,%esp
  800c68:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 04 24             	mov    %eax,(%esp)
  800c71:	e8 ba f7 ff ff       	call   800430 <fd2data>
  800c76:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c78:	c7 44 24 04 c5 21 80 	movl   $0x8021c5,0x4(%esp)
  800c7f:	00 
  800c80:	89 1c 24             	mov    %ebx,(%esp)
  800c83:	e8 93 0c 00 00       	call   80191b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c88:	8b 46 04             	mov    0x4(%esi),%eax
  800c8b:	2b 06                	sub    (%esi),%eax
  800c8d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c93:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c9a:	00 00 00 
	stat->st_dev = &devpipe;
  800c9d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800ca4:	30 80 00 
	return 0;
}
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  800cac:	83 c4 10             	add    $0x10,%esp
  800caf:	5b                   	pop    %ebx
  800cb0:	5e                   	pop    %esi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800cbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cc8:	e8 87 f5 ff ff       	call   800254 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ccd:	89 1c 24             	mov    %ebx,(%esp)
  800cd0:	e8 5b f7 ff ff       	call   800430 <fd2data>
  800cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ce0:	e8 6f f5 ff ff       	call   800254 <sys_page_unmap>
}
  800ce5:	83 c4 14             	add    $0x14,%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
  800cee:	57                   	push   %edi
  800cef:	56                   	push   %esi
  800cf0:	53                   	push   %ebx
  800cf1:	83 ec 2c             	sub    $0x2c,%esp
  800cf4:	89 c6                	mov    %eax,%esi
  800cf6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800cf9:	a1 04 40 80 00       	mov    0x804004,%eax
  800cfe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800d01:	89 34 24             	mov    %esi,(%esp)
  800d04:	e8 09 11 00 00       	call   801e12 <pageref>
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d0e:	89 04 24             	mov    %eax,(%esp)
  800d11:	e8 fc 10 00 00       	call   801e12 <pageref>
  800d16:	39 c7                	cmp    %eax,%edi
  800d18:	0f 94 c2             	sete   %dl
  800d1b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d1e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d24:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d27:	39 fb                	cmp    %edi,%ebx
  800d29:	74 21                	je     800d4c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d2b:	84 d2                	test   %dl,%dl
  800d2d:	74 ca                	je     800cf9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d2f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d32:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d36:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d3e:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800d45:	e8 75 05 00 00       	call   8012bf <cprintf>
  800d4a:	eb ad                	jmp    800cf9 <_pipeisclosed+0xe>
	}
}
  800d4c:	83 c4 2c             	add    $0x2c,%esp
  800d4f:	5b                   	pop    %ebx
  800d50:	5e                   	pop    %esi
  800d51:	5f                   	pop    %edi
  800d52:	5d                   	pop    %ebp
  800d53:	c3                   	ret    

00800d54 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	57                   	push   %edi
  800d58:	56                   	push   %esi
  800d59:	53                   	push   %ebx
  800d5a:	83 ec 1c             	sub    $0x1c,%esp
  800d5d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d60:	89 34 24             	mov    %esi,(%esp)
  800d63:	e8 c8 f6 ff ff       	call   800430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6c:	74 61                	je     800dcf <devpipe_write+0x7b>
  800d6e:	89 c3                	mov    %eax,%ebx
  800d70:	bf 00 00 00 00       	mov    $0x0,%edi
  800d75:	eb 4a                	jmp    800dc1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800d77:	89 da                	mov    %ebx,%edx
  800d79:	89 f0                	mov    %esi,%eax
  800d7b:	e8 6b ff ff ff       	call   800ceb <_pipeisclosed>
  800d80:	85 c0                	test   %eax,%eax
  800d82:	75 54                	jne    800dd8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800d84:	e8 05 f4 ff ff       	call   80018e <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d89:	8b 43 04             	mov    0x4(%ebx),%eax
  800d8c:	8b 0b                	mov    (%ebx),%ecx
  800d8e:	8d 51 20             	lea    0x20(%ecx),%edx
  800d91:	39 d0                	cmp    %edx,%eax
  800d93:	73 e2                	jae    800d77 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d9c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d9f:	99                   	cltd   
  800da0:	c1 ea 1b             	shr    $0x1b,%edx
  800da3:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800da6:	83 e1 1f             	and    $0x1f,%ecx
  800da9:	29 d1                	sub    %edx,%ecx
  800dab:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800daf:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800db3:	83 c0 01             	add    $0x1,%eax
  800db6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800db9:	83 c7 01             	add    $0x1,%edi
  800dbc:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800dbf:	74 13                	je     800dd4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800dc1:	8b 43 04             	mov    0x4(%ebx),%eax
  800dc4:	8b 0b                	mov    (%ebx),%ecx
  800dc6:	8d 51 20             	lea    0x20(%ecx),%edx
  800dc9:	39 d0                	cmp    %edx,%eax
  800dcb:	73 aa                	jae    800d77 <devpipe_write+0x23>
  800dcd:	eb c6                	jmp    800d95 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dcf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800dd4:	89 f8                	mov    %edi,%eax
  800dd6:	eb 05                	jmp    800ddd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800dd8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800ddd:	83 c4 1c             	add    $0x1c,%esp
  800de0:	5b                   	pop    %ebx
  800de1:	5e                   	pop    %esi
  800de2:	5f                   	pop    %edi
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	57                   	push   %edi
  800de9:	56                   	push   %esi
  800dea:	53                   	push   %ebx
  800deb:	83 ec 1c             	sub    $0x1c,%esp
  800dee:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800df1:	89 3c 24             	mov    %edi,(%esp)
  800df4:	e8 37 f6 ff ff       	call   800430 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800df9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfd:	74 54                	je     800e53 <devpipe_read+0x6e>
  800dff:	89 c3                	mov    %eax,%ebx
  800e01:	be 00 00 00 00       	mov    $0x0,%esi
  800e06:	eb 3e                	jmp    800e46 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800e08:	89 f0                	mov    %esi,%eax
  800e0a:	eb 55                	jmp    800e61 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800e0c:	89 da                	mov    %ebx,%edx
  800e0e:	89 f8                	mov    %edi,%eax
  800e10:	e8 d6 fe ff ff       	call   800ceb <_pipeisclosed>
  800e15:	85 c0                	test   %eax,%eax
  800e17:	75 43                	jne    800e5c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e19:	e8 70 f3 ff ff       	call   80018e <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e1e:	8b 03                	mov    (%ebx),%eax
  800e20:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e23:	74 e7                	je     800e0c <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e25:	99                   	cltd   
  800e26:	c1 ea 1b             	shr    $0x1b,%edx
  800e29:	01 d0                	add    %edx,%eax
  800e2b:	83 e0 1f             	and    $0x1f,%eax
  800e2e:	29 d0                	sub    %edx,%eax
  800e30:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e38:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e3b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e3e:	83 c6 01             	add    $0x1,%esi
  800e41:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e44:	74 12                	je     800e58 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e46:	8b 03                	mov    (%ebx),%eax
  800e48:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e4b:	75 d8                	jne    800e25 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e4d:	85 f6                	test   %esi,%esi
  800e4f:	75 b7                	jne    800e08 <devpipe_read+0x23>
  800e51:	eb b9                	jmp    800e0c <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e53:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e58:	89 f0                	mov    %esi,%eax
  800e5a:	eb 05                	jmp    800e61 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e5c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e61:	83 c4 1c             	add    $0x1c,%esp
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	56                   	push   %esi
  800e6d:	53                   	push   %ebx
  800e6e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800e71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e74:	89 04 24             	mov    %eax,(%esp)
  800e77:	e8 cb f5 ff ff       	call   800447 <fd_alloc>
  800e7c:	89 c2                	mov    %eax,%edx
  800e7e:	85 d2                	test   %edx,%edx
  800e80:	0f 88 4d 01 00 00    	js     800fd3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e86:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e8d:	00 
  800e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e9c:	e8 0c f3 ff ff       	call   8001ad <sys_page_alloc>
  800ea1:	89 c2                	mov    %eax,%edx
  800ea3:	85 d2                	test   %edx,%edx
  800ea5:	0f 88 28 01 00 00    	js     800fd3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800eab:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800eae:	89 04 24             	mov    %eax,(%esp)
  800eb1:	e8 91 f5 ff ff       	call   800447 <fd_alloc>
  800eb6:	89 c3                	mov    %eax,%ebx
  800eb8:	85 c0                	test   %eax,%eax
  800eba:	0f 88 fe 00 00 00    	js     800fbe <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ec0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ec7:	00 
  800ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ecf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ed6:	e8 d2 f2 ff ff       	call   8001ad <sys_page_alloc>
  800edb:	89 c3                	mov    %eax,%ebx
  800edd:	85 c0                	test   %eax,%eax
  800edf:	0f 88 d9 00 00 00    	js     800fbe <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee8:	89 04 24             	mov    %eax,(%esp)
  800eeb:	e8 40 f5 ff ff       	call   800430 <fd2data>
  800ef0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ef2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ef9:	00 
  800efa:	89 44 24 04          	mov    %eax,0x4(%esp)
  800efe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f05:	e8 a3 f2 ff ff       	call   8001ad <sys_page_alloc>
  800f0a:	89 c3                	mov    %eax,%ebx
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	0f 88 97 00 00 00    	js     800fab <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f17:	89 04 24             	mov    %eax,(%esp)
  800f1a:	e8 11 f5 ff ff       	call   800430 <fd2data>
  800f1f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f26:	00 
  800f27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f32:	00 
  800f33:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f3e:	e8 be f2 ff ff       	call   800201 <sys_page_map>
  800f43:	89 c3                	mov    %eax,%ebx
  800f45:	85 c0                	test   %eax,%eax
  800f47:	78 52                	js     800f9b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f49:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f52:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f5e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f67:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f76:	89 04 24             	mov    %eax,(%esp)
  800f79:	e8 a2 f4 ff ff       	call   800420 <fd2num>
  800f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f81:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f86:	89 04 24             	mov    %eax,(%esp)
  800f89:	e8 92 f4 ff ff       	call   800420 <fd2num>
  800f8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f91:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f94:	b8 00 00 00 00       	mov    $0x0,%eax
  800f99:	eb 38                	jmp    800fd3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800f9b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fa6:	e8 a9 f2 ff ff       	call   800254 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fae:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fb9:	e8 96 f2 ff ff       	call   800254 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fcc:	e8 83 f2 ff ff       	call   800254 <sys_page_unmap>
  800fd1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  800fd3:	83 c4 30             	add    $0x30,%esp
  800fd6:	5b                   	pop    %ebx
  800fd7:	5e                   	pop    %esi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fe0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	89 04 24             	mov    %eax,(%esp)
  800fed:	e8 c9 f4 ff ff       	call   8004bb <fd_lookup>
  800ff2:	89 c2                	mov    %eax,%edx
  800ff4:	85 d2                	test   %edx,%edx
  800ff6:	78 15                	js     80100d <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ffb:	89 04 24             	mov    %eax,(%esp)
  800ffe:	e8 2d f4 ff ff       	call   800430 <fd2data>
	return _pipeisclosed(fd, p);
  801003:	89 c2                	mov    %eax,%edx
  801005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801008:	e8 de fc ff ff       	call   800ceb <_pipeisclosed>
}
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    
  80100f:	90                   	nop

00801010 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801010:	55                   	push   %ebp
  801011:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801013:	b8 00 00 00 00       	mov    $0x0,%eax
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801020:	c7 44 24 04 e4 21 80 	movl   $0x8021e4,0x4(%esp)
  801027:	00 
  801028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102b:	89 04 24             	mov    %eax,(%esp)
  80102e:	e8 e8 08 00 00       	call   80191b <strcpy>
	return 0;
}
  801033:	b8 00 00 00 00       	mov    $0x0,%eax
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	57                   	push   %edi
  80103e:	56                   	push   %esi
  80103f:	53                   	push   %ebx
  801040:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801046:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80104a:	74 4a                	je     801096 <devcons_write+0x5c>
  80104c:	b8 00 00 00 00       	mov    $0x0,%eax
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801056:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80105c:	8b 75 10             	mov    0x10(%ebp),%esi
  80105f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801061:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801064:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801069:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80106c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801070:	03 45 0c             	add    0xc(%ebp),%eax
  801073:	89 44 24 04          	mov    %eax,0x4(%esp)
  801077:	89 3c 24             	mov    %edi,(%esp)
  80107a:	e8 97 0a 00 00       	call   801b16 <memmove>
		sys_cputs(buf, m);
  80107f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801083:	89 3c 24             	mov    %edi,(%esp)
  801086:	e8 55 f0 ff ff       	call   8000e0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80108b:	01 f3                	add    %esi,%ebx
  80108d:	89 d8                	mov    %ebx,%eax
  80108f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801092:	72 c8                	jb     80105c <devcons_write+0x22>
  801094:	eb 05                	jmp    80109b <devcons_write+0x61>
  801096:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80109b:	89 d8                	mov    %ebx,%eax
  80109d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8010a3:	5b                   	pop    %ebx
  8010a4:	5e                   	pop    %esi
  8010a5:	5f                   	pop    %edi
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8010ae:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	75 07                	jne    8010c0 <devcons_read+0x18>
  8010b9:	eb 28                	jmp    8010e3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8010bb:	e8 ce f0 ff ff       	call   80018e <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010c0:	e8 39 f0 ff ff       	call   8000fe <sys_cgetc>
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	74 f2                	je     8010bb <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010c9:	85 c0                	test   %eax,%eax
  8010cb:	78 16                	js     8010e3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010cd:	83 f8 04             	cmp    $0x4,%eax
  8010d0:	74 0c                	je     8010de <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8010d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d5:	88 02                	mov    %al,(%edx)
	return 1;
  8010d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010dc:	eb 05                	jmp    8010e3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8010de:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8010e3:	c9                   	leave  
  8010e4:	c3                   	ret    

008010e5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8010e5:	55                   	push   %ebp
  8010e6:	89 e5                	mov    %esp,%ebp
  8010e8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8010f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010f8:	00 
  8010f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8010fc:	89 04 24             	mov    %eax,(%esp)
  8010ff:	e8 dc ef ff ff       	call   8000e0 <sys_cputs>
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <getchar>:

int
getchar(void)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80110c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801113:	00 
  801114:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80111b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801122:	e8 3f f6 ff ff       	call   800766 <read>
	if (r < 0)
  801127:	85 c0                	test   %eax,%eax
  801129:	78 0f                	js     80113a <getchar+0x34>
		return r;
	if (r < 1)
  80112b:	85 c0                	test   %eax,%eax
  80112d:	7e 06                	jle    801135 <getchar+0x2f>
		return -E_EOF;
	return c;
  80112f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801133:	eb 05                	jmp    80113a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801135:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80113a:	c9                   	leave  
  80113b:	c3                   	ret    

0080113c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80113c:	55                   	push   %ebp
  80113d:	89 e5                	mov    %esp,%ebp
  80113f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801142:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801145:	89 44 24 04          	mov    %eax,0x4(%esp)
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	89 04 24             	mov    %eax,(%esp)
  80114f:	e8 67 f3 ff ff       	call   8004bb <fd_lookup>
  801154:	85 c0                	test   %eax,%eax
  801156:	78 11                	js     801169 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80115b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801161:	39 10                	cmp    %edx,(%eax)
  801163:	0f 94 c0             	sete   %al
  801166:	0f b6 c0             	movzbl %al,%eax
}
  801169:	c9                   	leave  
  80116a:	c3                   	ret    

0080116b <opencons>:

int
opencons(void)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801171:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801174:	89 04 24             	mov    %eax,(%esp)
  801177:	e8 cb f2 ff ff       	call   800447 <fd_alloc>
		return r;
  80117c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80117e:	85 c0                	test   %eax,%eax
  801180:	78 40                	js     8011c2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801182:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801189:	00 
  80118a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801198:	e8 10 f0 ff ff       	call   8001ad <sys_page_alloc>
		return r;
  80119d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	78 1f                	js     8011c2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8011a3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ac:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8011ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011b1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8011b8:	89 04 24             	mov    %eax,(%esp)
  8011bb:	e8 60 f2 ff ff       	call   800420 <fd2num>
  8011c0:	89 c2                	mov    %eax,%edx
}
  8011c2:	89 d0                	mov    %edx,%eax
  8011c4:	c9                   	leave  
  8011c5:	c3                   	ret    

008011c6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	56                   	push   %esi
  8011ca:	53                   	push   %ebx
  8011cb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ce:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011d1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8011d7:	e8 93 ef ff ff       	call   80016f <sys_getenvid>
  8011dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011df:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011ea:	89 74 24 08          	mov    %esi,0x8(%esp)
  8011ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f2:	c7 04 24 f0 21 80 00 	movl   $0x8021f0,(%esp)
  8011f9:	e8 c1 00 00 00       	call   8012bf <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801202:	8b 45 10             	mov    0x10(%ebp),%eax
  801205:	89 04 24             	mov    %eax,(%esp)
  801208:	e8 51 00 00 00       	call   80125e <vcprintf>
	cprintf("\n");
  80120d:	c7 04 24 dd 21 80 00 	movl   $0x8021dd,(%esp)
  801214:	e8 a6 00 00 00       	call   8012bf <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801219:	cc                   	int3   
  80121a:	eb fd                	jmp    801219 <_panic+0x53>

0080121c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
  80121f:	53                   	push   %ebx
  801220:	83 ec 14             	sub    $0x14,%esp
  801223:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801226:	8b 13                	mov    (%ebx),%edx
  801228:	8d 42 01             	lea    0x1(%edx),%eax
  80122b:	89 03                	mov    %eax,(%ebx)
  80122d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801230:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801234:	3d ff 00 00 00       	cmp    $0xff,%eax
  801239:	75 19                	jne    801254 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80123b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801242:	00 
  801243:	8d 43 08             	lea    0x8(%ebx),%eax
  801246:	89 04 24             	mov    %eax,(%esp)
  801249:	e8 92 ee ff ff       	call   8000e0 <sys_cputs>
		b->idx = 0;
  80124e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801254:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801258:	83 c4 14             	add    $0x14,%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801267:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80126e:	00 00 00 
	b.cnt = 0;
  801271:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801278:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80127b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801282:	8b 45 08             	mov    0x8(%ebp),%eax
  801285:	89 44 24 08          	mov    %eax,0x8(%esp)
  801289:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80128f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801293:	c7 04 24 1c 12 80 00 	movl   $0x80121c,(%esp)
  80129a:	e8 b5 01 00 00       	call   801454 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80129f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8012a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8012af:	89 04 24             	mov    %eax,(%esp)
  8012b2:	e8 29 ee ff ff       	call   8000e0 <sys_cputs>

	return b.cnt;
}
  8012b7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012c5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cf:	89 04 24             	mov    %eax,(%esp)
  8012d2:	e8 87 ff ff ff       	call   80125e <vcprintf>
	va_end(ap);

	return cnt;
}
  8012d7:	c9                   	leave  
  8012d8:	c3                   	ret    
  8012d9:	66 90                	xchg   %ax,%ax
  8012db:	66 90                	xchg   %ax,%ax
  8012dd:	66 90                	xchg   %ax,%ax
  8012df:	90                   	nop

008012e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	57                   	push   %edi
  8012e4:	56                   	push   %esi
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 3c             	sub    $0x3c,%esp
  8012e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012ec:	89 d7                	mov    %edx,%edi
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801302:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801305:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801308:	39 f1                	cmp    %esi,%ecx
  80130a:	72 14                	jb     801320 <printnum+0x40>
  80130c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80130f:	76 0f                	jbe    801320 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801311:	8b 45 14             	mov    0x14(%ebp),%eax
  801314:	8d 70 ff             	lea    -0x1(%eax),%esi
  801317:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80131a:	85 f6                	test   %esi,%esi
  80131c:	7f 60                	jg     80137e <printnum+0x9e>
  80131e:	eb 72                	jmp    801392 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801320:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801323:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801327:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80132a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80132d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801331:	89 44 24 08          	mov    %eax,0x8(%esp)
  801335:	8b 44 24 08          	mov    0x8(%esp),%eax
  801339:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	89 d6                	mov    %edx,%esi
  801341:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801344:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801347:	89 54 24 08          	mov    %edx,0x8(%esp)
  80134b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80134f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801352:	89 04 24             	mov    %eax,(%esp)
  801355:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801358:	89 44 24 04          	mov    %eax,0x4(%esp)
  80135c:	e8 ef 0a 00 00       	call   801e50 <__udivdi3>
  801361:	89 d9                	mov    %ebx,%ecx
  801363:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801367:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80136b:	89 04 24             	mov    %eax,(%esp)
  80136e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801372:	89 fa                	mov    %edi,%edx
  801374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801377:	e8 64 ff ff ff       	call   8012e0 <printnum>
  80137c:	eb 14                	jmp    801392 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80137e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801382:	8b 45 18             	mov    0x18(%ebp),%eax
  801385:	89 04 24             	mov    %eax,(%esp)
  801388:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80138a:	83 ee 01             	sub    $0x1,%esi
  80138d:	75 ef                	jne    80137e <printnum+0x9e>
  80138f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801392:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801396:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80139a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80139d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8013a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ab:	89 04 24             	mov    %eax,(%esp)
  8013ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b5:	e8 c6 0b 00 00       	call   801f80 <__umoddi3>
  8013ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013be:	0f be 80 13 22 80 00 	movsbl 0x802213(%eax),%eax
  8013c5:	89 04 24             	mov    %eax,(%esp)
  8013c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cb:	ff d0                	call   *%eax
}
  8013cd:	83 c4 3c             	add    $0x3c,%esp
  8013d0:	5b                   	pop    %ebx
  8013d1:	5e                   	pop    %esi
  8013d2:	5f                   	pop    %edi
  8013d3:	5d                   	pop    %ebp
  8013d4:	c3                   	ret    

008013d5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8013d5:	55                   	push   %ebp
  8013d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013d8:	83 fa 01             	cmp    $0x1,%edx
  8013db:	7e 0e                	jle    8013eb <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8013dd:	8b 10                	mov    (%eax),%edx
  8013df:	8d 4a 08             	lea    0x8(%edx),%ecx
  8013e2:	89 08                	mov    %ecx,(%eax)
  8013e4:	8b 02                	mov    (%edx),%eax
  8013e6:	8b 52 04             	mov    0x4(%edx),%edx
  8013e9:	eb 22                	jmp    80140d <getuint+0x38>
	else if (lflag)
  8013eb:	85 d2                	test   %edx,%edx
  8013ed:	74 10                	je     8013ff <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8013ef:	8b 10                	mov    (%eax),%edx
  8013f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013f4:	89 08                	mov    %ecx,(%eax)
  8013f6:	8b 02                	mov    (%edx),%eax
  8013f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fd:	eb 0e                	jmp    80140d <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8013ff:	8b 10                	mov    (%eax),%edx
  801401:	8d 4a 04             	lea    0x4(%edx),%ecx
  801404:	89 08                	mov    %ecx,(%eax)
  801406:	8b 02                	mov    (%edx),%eax
  801408:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80140d:	5d                   	pop    %ebp
  80140e:	c3                   	ret    

0080140f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80140f:	55                   	push   %ebp
  801410:	89 e5                	mov    %esp,%ebp
  801412:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801415:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801419:	8b 10                	mov    (%eax),%edx
  80141b:	3b 50 04             	cmp    0x4(%eax),%edx
  80141e:	73 0a                	jae    80142a <sprintputch+0x1b>
		*b->buf++ = ch;
  801420:	8d 4a 01             	lea    0x1(%edx),%ecx
  801423:	89 08                	mov    %ecx,(%eax)
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	88 02                	mov    %al,(%edx)
}
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801432:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801435:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801439:	8b 45 10             	mov    0x10(%ebp),%eax
  80143c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	89 44 24 04          	mov    %eax,0x4(%esp)
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	e8 02 00 00 00       	call   801454 <vprintfmt>
	va_end(ap);
}
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	57                   	push   %edi
  801458:	56                   	push   %esi
  801459:	53                   	push   %ebx
  80145a:	83 ec 3c             	sub    $0x3c,%esp
  80145d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801460:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801463:	eb 18                	jmp    80147d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801465:	85 c0                	test   %eax,%eax
  801467:	0f 84 c3 03 00 00    	je     801830 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80146d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801471:	89 04 24             	mov    %eax,(%esp)
  801474:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801477:	89 f3                	mov    %esi,%ebx
  801479:	eb 02                	jmp    80147d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80147d:	8d 73 01             	lea    0x1(%ebx),%esi
  801480:	0f b6 03             	movzbl (%ebx),%eax
  801483:	83 f8 25             	cmp    $0x25,%eax
  801486:	75 dd                	jne    801465 <vprintfmt+0x11>
  801488:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80148c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801493:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80149a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a6:	eb 1d                	jmp    8014c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014a8:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8014aa:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  8014ae:	eb 15                	jmp    8014c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014b0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014b2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8014b6:	eb 0d                	jmp    8014c5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8014b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014be:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014c5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014c8:	0f b6 06             	movzbl (%esi),%eax
  8014cb:	0f b6 c8             	movzbl %al,%ecx
  8014ce:	83 e8 23             	sub    $0x23,%eax
  8014d1:	3c 55                	cmp    $0x55,%al
  8014d3:	0f 87 2f 03 00 00    	ja     801808 <vprintfmt+0x3b4>
  8014d9:	0f b6 c0             	movzbl %al,%eax
  8014dc:	ff 24 85 60 23 80 00 	jmp    *0x802360(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8014e3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8014e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8014e9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8014ed:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8014f0:	83 f9 09             	cmp    $0x9,%ecx
  8014f3:	77 50                	ja     801545 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014f5:	89 de                	mov    %ebx,%esi
  8014f7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014fa:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8014fd:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801500:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  801504:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  801507:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80150a:	83 fb 09             	cmp    $0x9,%ebx
  80150d:	76 eb                	jbe    8014fa <vprintfmt+0xa6>
  80150f:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801512:	eb 33                	jmp    801547 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801514:	8b 45 14             	mov    0x14(%ebp),%eax
  801517:	8d 48 04             	lea    0x4(%eax),%ecx
  80151a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80151d:	8b 00                	mov    (%eax),%eax
  80151f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801522:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801524:	eb 21                	jmp    801547 <vprintfmt+0xf3>
  801526:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801529:	85 c9                	test   %ecx,%ecx
  80152b:	b8 00 00 00 00       	mov    $0x0,%eax
  801530:	0f 49 c1             	cmovns %ecx,%eax
  801533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801536:	89 de                	mov    %ebx,%esi
  801538:	eb 8b                	jmp    8014c5 <vprintfmt+0x71>
  80153a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80153c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801543:	eb 80                	jmp    8014c5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801545:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801547:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80154b:	0f 89 74 ff ff ff    	jns    8014c5 <vprintfmt+0x71>
  801551:	e9 62 ff ff ff       	jmp    8014b8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801556:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801559:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80155b:	e9 65 ff ff ff       	jmp    8014c5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801560:	8b 45 14             	mov    0x14(%ebp),%eax
  801563:	8d 50 04             	lea    0x4(%eax),%edx
  801566:	89 55 14             	mov    %edx,0x14(%ebp)
  801569:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	89 04 24             	mov    %eax,(%esp)
  801572:	ff 55 08             	call   *0x8(%ebp)
			break;
  801575:	e9 03 ff ff ff       	jmp    80147d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80157a:	8b 45 14             	mov    0x14(%ebp),%eax
  80157d:	8d 50 04             	lea    0x4(%eax),%edx
  801580:	89 55 14             	mov    %edx,0x14(%ebp)
  801583:	8b 00                	mov    (%eax),%eax
  801585:	99                   	cltd   
  801586:	31 d0                	xor    %edx,%eax
  801588:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80158a:	83 f8 0f             	cmp    $0xf,%eax
  80158d:	7f 0b                	jg     80159a <vprintfmt+0x146>
  80158f:	8b 14 85 c0 24 80 00 	mov    0x8024c0(,%eax,4),%edx
  801596:	85 d2                	test   %edx,%edx
  801598:	75 20                	jne    8015ba <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80159a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80159e:	c7 44 24 08 2b 22 80 	movl   $0x80222b,0x8(%esp)
  8015a5:	00 
  8015a6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	89 04 24             	mov    %eax,(%esp)
  8015b0:	e8 77 fe ff ff       	call   80142c <printfmt>
  8015b5:	e9 c3 fe ff ff       	jmp    80147d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8015ba:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015be:	c7 44 24 08 ab 21 80 	movl   $0x8021ab,0x8(%esp)
  8015c5:	00 
  8015c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	89 04 24             	mov    %eax,(%esp)
  8015d0:	e8 57 fe ff ff       	call   80142c <printfmt>
  8015d5:	e9 a3 fe ff ff       	jmp    80147d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015da:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8015dd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015e3:	8d 50 04             	lea    0x4(%eax),%edx
  8015e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015e9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8015eb:	85 c0                	test   %eax,%eax
  8015ed:	ba 24 22 80 00       	mov    $0x802224,%edx
  8015f2:	0f 45 d0             	cmovne %eax,%edx
  8015f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8015f8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8015fc:	74 04                	je     801602 <vprintfmt+0x1ae>
  8015fe:	85 f6                	test   %esi,%esi
  801600:	7f 19                	jg     80161b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801602:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801605:	8d 70 01             	lea    0x1(%eax),%esi
  801608:	0f b6 10             	movzbl (%eax),%edx
  80160b:	0f be c2             	movsbl %dl,%eax
  80160e:	85 c0                	test   %eax,%eax
  801610:	0f 85 95 00 00 00    	jne    8016ab <vprintfmt+0x257>
  801616:	e9 85 00 00 00       	jmp    8016a0 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80161b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80161f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801622:	89 04 24             	mov    %eax,(%esp)
  801625:	e8 b8 02 00 00       	call   8018e2 <strnlen>
  80162a:	29 c6                	sub    %eax,%esi
  80162c:	89 f0                	mov    %esi,%eax
  80162e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801631:	85 f6                	test   %esi,%esi
  801633:	7e cd                	jle    801602 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801635:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801639:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80163c:	89 c3                	mov    %eax,%ebx
  80163e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801642:	89 34 24             	mov    %esi,(%esp)
  801645:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801648:	83 eb 01             	sub    $0x1,%ebx
  80164b:	75 f1                	jne    80163e <vprintfmt+0x1ea>
  80164d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801653:	eb ad                	jmp    801602 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801655:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801659:	74 1e                	je     801679 <vprintfmt+0x225>
  80165b:	0f be d2             	movsbl %dl,%edx
  80165e:	83 ea 20             	sub    $0x20,%edx
  801661:	83 fa 5e             	cmp    $0x5e,%edx
  801664:	76 13                	jbe    801679 <vprintfmt+0x225>
					putch('?', putdat);
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801674:	ff 55 08             	call   *0x8(%ebp)
  801677:	eb 0d                	jmp    801686 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801679:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80167c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801680:	89 04 24             	mov    %eax,(%esp)
  801683:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801686:	83 ef 01             	sub    $0x1,%edi
  801689:	83 c6 01             	add    $0x1,%esi
  80168c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801690:	0f be c2             	movsbl %dl,%eax
  801693:	85 c0                	test   %eax,%eax
  801695:	75 20                	jne    8016b7 <vprintfmt+0x263>
  801697:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80169a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80169d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016a4:	7f 25                	jg     8016cb <vprintfmt+0x277>
  8016a6:	e9 d2 fd ff ff       	jmp    80147d <vprintfmt+0x29>
  8016ab:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8016ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016b1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016b4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016b7:	85 db                	test   %ebx,%ebx
  8016b9:	78 9a                	js     801655 <vprintfmt+0x201>
  8016bb:	83 eb 01             	sub    $0x1,%ebx
  8016be:	79 95                	jns    801655 <vprintfmt+0x201>
  8016c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016c3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016c9:	eb d5                	jmp    8016a0 <vprintfmt+0x24c>
  8016cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016d1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8016d4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8016df:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016e1:	83 eb 01             	sub    $0x1,%ebx
  8016e4:	75 ee                	jne    8016d4 <vprintfmt+0x280>
  8016e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016e9:	e9 8f fd ff ff       	jmp    80147d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8016ee:	83 fa 01             	cmp    $0x1,%edx
  8016f1:	7e 16                	jle    801709 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8016f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f6:	8d 50 08             	lea    0x8(%eax),%edx
  8016f9:	89 55 14             	mov    %edx,0x14(%ebp)
  8016fc:	8b 50 04             	mov    0x4(%eax),%edx
  8016ff:	8b 00                	mov    (%eax),%eax
  801701:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801704:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801707:	eb 32                	jmp    80173b <vprintfmt+0x2e7>
	else if (lflag)
  801709:	85 d2                	test   %edx,%edx
  80170b:	74 18                	je     801725 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  80170d:	8b 45 14             	mov    0x14(%ebp),%eax
  801710:	8d 50 04             	lea    0x4(%eax),%edx
  801713:	89 55 14             	mov    %edx,0x14(%ebp)
  801716:	8b 30                	mov    (%eax),%esi
  801718:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80171b:	89 f0                	mov    %esi,%eax
  80171d:	c1 f8 1f             	sar    $0x1f,%eax
  801720:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801723:	eb 16                	jmp    80173b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801725:	8b 45 14             	mov    0x14(%ebp),%eax
  801728:	8d 50 04             	lea    0x4(%eax),%edx
  80172b:	89 55 14             	mov    %edx,0x14(%ebp)
  80172e:	8b 30                	mov    (%eax),%esi
  801730:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801733:	89 f0                	mov    %esi,%eax
  801735:	c1 f8 1f             	sar    $0x1f,%eax
  801738:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80173b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80173e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801741:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801746:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80174a:	0f 89 80 00 00 00    	jns    8017d0 <vprintfmt+0x37c>
				putch('-', putdat);
  801750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801754:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80175b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80175e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801761:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801764:	f7 d8                	neg    %eax
  801766:	83 d2 00             	adc    $0x0,%edx
  801769:	f7 da                	neg    %edx
			}
			base = 10;
  80176b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801770:	eb 5e                	jmp    8017d0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801772:	8d 45 14             	lea    0x14(%ebp),%eax
  801775:	e8 5b fc ff ff       	call   8013d5 <getuint>
			base = 10;
  80177a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80177f:	eb 4f                	jmp    8017d0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801781:	8d 45 14             	lea    0x14(%ebp),%eax
  801784:	e8 4c fc ff ff       	call   8013d5 <getuint>
			base = 8;
  801789:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80178e:	eb 40                	jmp    8017d0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801790:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801794:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80179b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80179e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017a2:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8017a9:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8017ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8017af:	8d 50 04             	lea    0x4(%eax),%edx
  8017b2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017b5:	8b 00                	mov    (%eax),%eax
  8017b7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8017bc:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017c1:	eb 0d                	jmp    8017d0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017c6:	e8 0a fc ff ff       	call   8013d5 <getuint>
			base = 16;
  8017cb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017d0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8017d4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8017d8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017db:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017e3:	89 04 24             	mov    %eax,(%esp)
  8017e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017ea:	89 fa                	mov    %edi,%edx
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	e8 ec fa ff ff       	call   8012e0 <printnum>
			break;
  8017f4:	e9 84 fc ff ff       	jmp    80147d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017f9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017fd:	89 0c 24             	mov    %ecx,(%esp)
  801800:	ff 55 08             	call   *0x8(%ebp)
			break;
  801803:	e9 75 fc ff ff       	jmp    80147d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801808:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80180c:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801813:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801816:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80181a:	0f 84 5b fc ff ff    	je     80147b <vprintfmt+0x27>
  801820:	89 f3                	mov    %esi,%ebx
  801822:	83 eb 01             	sub    $0x1,%ebx
  801825:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801829:	75 f7                	jne    801822 <vprintfmt+0x3ce>
  80182b:	e9 4d fc ff ff       	jmp    80147d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801830:	83 c4 3c             	add    $0x3c,%esp
  801833:	5b                   	pop    %ebx
  801834:	5e                   	pop    %esi
  801835:	5f                   	pop    %edi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    

00801838 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801838:	55                   	push   %ebp
  801839:	89 e5                	mov    %esp,%ebp
  80183b:	83 ec 28             	sub    $0x28,%esp
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801847:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80184b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80184e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801855:	85 c0                	test   %eax,%eax
  801857:	74 30                	je     801889 <vsnprintf+0x51>
  801859:	85 d2                	test   %edx,%edx
  80185b:	7e 2c                	jle    801889 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80185d:	8b 45 14             	mov    0x14(%ebp),%eax
  801860:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801864:	8b 45 10             	mov    0x10(%ebp),%eax
  801867:	89 44 24 08          	mov    %eax,0x8(%esp)
  80186b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80186e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801872:	c7 04 24 0f 14 80 00 	movl   $0x80140f,(%esp)
  801879:	e8 d6 fb ff ff       	call   801454 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80187e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801881:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801887:	eb 05                	jmp    80188e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801889:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801896:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801899:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80189d:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 82 ff ff ff       	call   801838 <vsnprintf>
	va_end(ap);

	return rc;
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    
  8018b8:	66 90                	xchg   %ax,%ax
  8018ba:	66 90                	xchg   %ax,%ax
  8018bc:	66 90                	xchg   %ax,%ax
  8018be:	66 90                	xchg   %ax,%ax

008018c0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018c6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018c9:	74 10                	je     8018db <strlen+0x1b>
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8018d0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8018d7:	75 f7                	jne    8018d0 <strlen+0x10>
  8018d9:	eb 05                	jmp    8018e0 <strlen+0x20>
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	53                   	push   %ebx
  8018e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ec:	85 c9                	test   %ecx,%ecx
  8018ee:	74 1c                	je     80190c <strnlen+0x2a>
  8018f0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8018f3:	74 1e                	je     801913 <strnlen+0x31>
  8018f5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8018fa:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018fc:	39 ca                	cmp    %ecx,%edx
  8018fe:	74 18                	je     801918 <strnlen+0x36>
  801900:	83 c2 01             	add    $0x1,%edx
  801903:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  801908:	75 f0                	jne    8018fa <strnlen+0x18>
  80190a:	eb 0c                	jmp    801918 <strnlen+0x36>
  80190c:	b8 00 00 00 00       	mov    $0x0,%eax
  801911:	eb 05                	jmp    801918 <strnlen+0x36>
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801918:	5b                   	pop    %ebx
  801919:	5d                   	pop    %ebp
  80191a:	c3                   	ret    

0080191b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	53                   	push   %ebx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801925:	89 c2                	mov    %eax,%edx
  801927:	83 c2 01             	add    $0x1,%edx
  80192a:	83 c1 01             	add    $0x1,%ecx
  80192d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801931:	88 5a ff             	mov    %bl,-0x1(%edx)
  801934:	84 db                	test   %bl,%bl
  801936:	75 ef                	jne    801927 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801938:	5b                   	pop    %ebx
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
  80193e:	53                   	push   %ebx
  80193f:	83 ec 08             	sub    $0x8,%esp
  801942:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801945:	89 1c 24             	mov    %ebx,(%esp)
  801948:	e8 73 ff ff ff       	call   8018c0 <strlen>
	strcpy(dst + len, src);
  80194d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801950:	89 54 24 04          	mov    %edx,0x4(%esp)
  801954:	01 d8                	add    %ebx,%eax
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	e8 bd ff ff ff       	call   80191b <strcpy>
	return dst;
}
  80195e:	89 d8                	mov    %ebx,%eax
  801960:	83 c4 08             	add    $0x8,%esp
  801963:	5b                   	pop    %ebx
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	56                   	push   %esi
  80196a:	53                   	push   %ebx
  80196b:	8b 75 08             	mov    0x8(%ebp),%esi
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801974:	85 db                	test   %ebx,%ebx
  801976:	74 17                	je     80198f <strncpy+0x29>
  801978:	01 f3                	add    %esi,%ebx
  80197a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80197c:	83 c1 01             	add    $0x1,%ecx
  80197f:	0f b6 02             	movzbl (%edx),%eax
  801982:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801985:	80 3a 01             	cmpb   $0x1,(%edx)
  801988:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80198b:	39 d9                	cmp    %ebx,%ecx
  80198d:	75 ed                	jne    80197c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80198f:	89 f0                	mov    %esi,%eax
  801991:	5b                   	pop    %ebx
  801992:	5e                   	pop    %esi
  801993:	5d                   	pop    %ebp
  801994:	c3                   	ret    

00801995 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	57                   	push   %edi
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80199e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8019a1:	8b 75 10             	mov    0x10(%ebp),%esi
  8019a4:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019a6:	85 f6                	test   %esi,%esi
  8019a8:	74 34                	je     8019de <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  8019aa:	83 fe 01             	cmp    $0x1,%esi
  8019ad:	74 26                	je     8019d5 <strlcpy+0x40>
  8019af:	0f b6 0b             	movzbl (%ebx),%ecx
  8019b2:	84 c9                	test   %cl,%cl
  8019b4:	74 23                	je     8019d9 <strlcpy+0x44>
  8019b6:	83 ee 02             	sub    $0x2,%esi
  8019b9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8019be:	83 c0 01             	add    $0x1,%eax
  8019c1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019c4:	39 f2                	cmp    %esi,%edx
  8019c6:	74 13                	je     8019db <strlcpy+0x46>
  8019c8:	83 c2 01             	add    $0x1,%edx
  8019cb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019cf:	84 c9                	test   %cl,%cl
  8019d1:	75 eb                	jne    8019be <strlcpy+0x29>
  8019d3:	eb 06                	jmp    8019db <strlcpy+0x46>
  8019d5:	89 f8                	mov    %edi,%eax
  8019d7:	eb 02                	jmp    8019db <strlcpy+0x46>
  8019d9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8019db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019de:	29 f8                	sub    %edi,%eax
}
  8019e0:	5b                   	pop    %ebx
  8019e1:	5e                   	pop    %esi
  8019e2:	5f                   	pop    %edi
  8019e3:	5d                   	pop    %ebp
  8019e4:	c3                   	ret    

008019e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8019ee:	0f b6 01             	movzbl (%ecx),%eax
  8019f1:	84 c0                	test   %al,%al
  8019f3:	74 15                	je     801a0a <strcmp+0x25>
  8019f5:	3a 02                	cmp    (%edx),%al
  8019f7:	75 11                	jne    801a0a <strcmp+0x25>
		p++, q++;
  8019f9:	83 c1 01             	add    $0x1,%ecx
  8019fc:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019ff:	0f b6 01             	movzbl (%ecx),%eax
  801a02:	84 c0                	test   %al,%al
  801a04:	74 04                	je     801a0a <strcmp+0x25>
  801a06:	3a 02                	cmp    (%edx),%al
  801a08:	74 ef                	je     8019f9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a0a:	0f b6 c0             	movzbl %al,%eax
  801a0d:	0f b6 12             	movzbl (%edx),%edx
  801a10:	29 d0                	sub    %edx,%eax
}
  801a12:	5d                   	pop    %ebp
  801a13:	c3                   	ret    

00801a14 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a22:	85 f6                	test   %esi,%esi
  801a24:	74 29                	je     801a4f <strncmp+0x3b>
  801a26:	0f b6 03             	movzbl (%ebx),%eax
  801a29:	84 c0                	test   %al,%al
  801a2b:	74 30                	je     801a5d <strncmp+0x49>
  801a2d:	3a 02                	cmp    (%edx),%al
  801a2f:	75 2c                	jne    801a5d <strncmp+0x49>
  801a31:	8d 43 01             	lea    0x1(%ebx),%eax
  801a34:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a36:	89 c3                	mov    %eax,%ebx
  801a38:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a3b:	39 f0                	cmp    %esi,%eax
  801a3d:	74 17                	je     801a56 <strncmp+0x42>
  801a3f:	0f b6 08             	movzbl (%eax),%ecx
  801a42:	84 c9                	test   %cl,%cl
  801a44:	74 17                	je     801a5d <strncmp+0x49>
  801a46:	83 c0 01             	add    $0x1,%eax
  801a49:	3a 0a                	cmp    (%edx),%cl
  801a4b:	74 e9                	je     801a36 <strncmp+0x22>
  801a4d:	eb 0e                	jmp    801a5d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a54:	eb 0f                	jmp    801a65 <strncmp+0x51>
  801a56:	b8 00 00 00 00       	mov    $0x0,%eax
  801a5b:	eb 08                	jmp    801a65 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a5d:	0f b6 03             	movzbl (%ebx),%eax
  801a60:	0f b6 12             	movzbl (%edx),%edx
  801a63:	29 d0                	sub    %edx,%eax
}
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	53                   	push   %ebx
  801a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a70:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a73:	0f b6 18             	movzbl (%eax),%ebx
  801a76:	84 db                	test   %bl,%bl
  801a78:	74 1d                	je     801a97 <strchr+0x2e>
  801a7a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a7c:	38 d3                	cmp    %dl,%bl
  801a7e:	75 06                	jne    801a86 <strchr+0x1d>
  801a80:	eb 1a                	jmp    801a9c <strchr+0x33>
  801a82:	38 ca                	cmp    %cl,%dl
  801a84:	74 16                	je     801a9c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a86:	83 c0 01             	add    $0x1,%eax
  801a89:	0f b6 10             	movzbl (%eax),%edx
  801a8c:	84 d2                	test   %dl,%dl
  801a8e:	75 f2                	jne    801a82 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801a90:	b8 00 00 00 00       	mov    $0x0,%eax
  801a95:	eb 05                	jmp    801a9c <strchr+0x33>
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a9c:	5b                   	pop    %ebx
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    

00801a9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	53                   	push   %ebx
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801aa9:	0f b6 18             	movzbl (%eax),%ebx
  801aac:	84 db                	test   %bl,%bl
  801aae:	74 16                	je     801ac6 <strfind+0x27>
  801ab0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801ab2:	38 d3                	cmp    %dl,%bl
  801ab4:	75 06                	jne    801abc <strfind+0x1d>
  801ab6:	eb 0e                	jmp    801ac6 <strfind+0x27>
  801ab8:	38 ca                	cmp    %cl,%dl
  801aba:	74 0a                	je     801ac6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801abc:	83 c0 01             	add    $0x1,%eax
  801abf:	0f b6 10             	movzbl (%eax),%edx
  801ac2:	84 d2                	test   %dl,%dl
  801ac4:	75 f2                	jne    801ab8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801ac6:	5b                   	pop    %ebx
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	57                   	push   %edi
  801acd:	56                   	push   %esi
  801ace:	53                   	push   %ebx
  801acf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ad2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ad5:	85 c9                	test   %ecx,%ecx
  801ad7:	74 36                	je     801b0f <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ad9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801adf:	75 28                	jne    801b09 <memset+0x40>
  801ae1:	f6 c1 03             	test   $0x3,%cl
  801ae4:	75 23                	jne    801b09 <memset+0x40>
		c &= 0xFF;
  801ae6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801aea:	89 d3                	mov    %edx,%ebx
  801aec:	c1 e3 08             	shl    $0x8,%ebx
  801aef:	89 d6                	mov    %edx,%esi
  801af1:	c1 e6 18             	shl    $0x18,%esi
  801af4:	89 d0                	mov    %edx,%eax
  801af6:	c1 e0 10             	shl    $0x10,%eax
  801af9:	09 f0                	or     %esi,%eax
  801afb:	09 c2                	or     %eax,%edx
  801afd:	89 d0                	mov    %edx,%eax
  801aff:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801b01:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801b04:	fc                   	cld    
  801b05:	f3 ab                	rep stos %eax,%es:(%edi)
  801b07:	eb 06                	jmp    801b0f <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0c:	fc                   	cld    
  801b0d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801b0f:	89 f8                	mov    %edi,%eax
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	57                   	push   %edi
  801b1a:	56                   	push   %esi
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b21:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b24:	39 c6                	cmp    %eax,%esi
  801b26:	73 35                	jae    801b5d <memmove+0x47>
  801b28:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b2b:	39 d0                	cmp    %edx,%eax
  801b2d:	73 2e                	jae    801b5d <memmove+0x47>
		s += n;
		d += n;
  801b2f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b32:	89 d6                	mov    %edx,%esi
  801b34:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b3c:	75 13                	jne    801b51 <memmove+0x3b>
  801b3e:	f6 c1 03             	test   $0x3,%cl
  801b41:	75 0e                	jne    801b51 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b43:	83 ef 04             	sub    $0x4,%edi
  801b46:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b49:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b4c:	fd                   	std    
  801b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b4f:	eb 09                	jmp    801b5a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b51:	83 ef 01             	sub    $0x1,%edi
  801b54:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b57:	fd                   	std    
  801b58:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b5a:	fc                   	cld    
  801b5b:	eb 1d                	jmp    801b7a <memmove+0x64>
  801b5d:	89 f2                	mov    %esi,%edx
  801b5f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b61:	f6 c2 03             	test   $0x3,%dl
  801b64:	75 0f                	jne    801b75 <memmove+0x5f>
  801b66:	f6 c1 03             	test   $0x3,%cl
  801b69:	75 0a                	jne    801b75 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b6b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b6e:	89 c7                	mov    %eax,%edi
  801b70:	fc                   	cld    
  801b71:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b73:	eb 05                	jmp    801b7a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b75:	89 c7                	mov    %eax,%edi
  801b77:	fc                   	cld    
  801b78:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b7a:	5e                   	pop    %esi
  801b7b:	5f                   	pop    %edi
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    

00801b7e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	89 04 24             	mov    %eax,(%esp)
  801b98:	e8 79 ff ff ff       	call   801b16 <memmove>
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	57                   	push   %edi
  801ba3:	56                   	push   %esi
  801ba4:	53                   	push   %ebx
  801ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bab:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bae:	8d 78 ff             	lea    -0x1(%eax),%edi
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	74 36                	je     801beb <memcmp+0x4c>
		if (*s1 != *s2)
  801bb5:	0f b6 03             	movzbl (%ebx),%eax
  801bb8:	0f b6 0e             	movzbl (%esi),%ecx
  801bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc0:	38 c8                	cmp    %cl,%al
  801bc2:	74 1c                	je     801be0 <memcmp+0x41>
  801bc4:	eb 10                	jmp    801bd6 <memcmp+0x37>
  801bc6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801bcb:	83 c2 01             	add    $0x1,%edx
  801bce:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801bd2:	38 c8                	cmp    %cl,%al
  801bd4:	74 0a                	je     801be0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801bd6:	0f b6 c0             	movzbl %al,%eax
  801bd9:	0f b6 c9             	movzbl %cl,%ecx
  801bdc:	29 c8                	sub    %ecx,%eax
  801bde:	eb 10                	jmp    801bf0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801be0:	39 fa                	cmp    %edi,%edx
  801be2:	75 e2                	jne    801bc6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax
  801be9:	eb 05                	jmp    801bf0 <memcmp+0x51>
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf0:	5b                   	pop    %ebx
  801bf1:	5e                   	pop    %esi
  801bf2:	5f                   	pop    %edi
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    

00801bf5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	53                   	push   %ebx
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801bff:	89 c2                	mov    %eax,%edx
  801c01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801c04:	39 d0                	cmp    %edx,%eax
  801c06:	73 13                	jae    801c1b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801c08:	89 d9                	mov    %ebx,%ecx
  801c0a:	38 18                	cmp    %bl,(%eax)
  801c0c:	75 06                	jne    801c14 <memfind+0x1f>
  801c0e:	eb 0b                	jmp    801c1b <memfind+0x26>
  801c10:	38 08                	cmp    %cl,(%eax)
  801c12:	74 07                	je     801c1b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c14:	83 c0 01             	add    $0x1,%eax
  801c17:	39 d0                	cmp    %edx,%eax
  801c19:	75 f5                	jne    801c10 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c1b:	5b                   	pop    %ebx
  801c1c:	5d                   	pop    %ebp
  801c1d:	c3                   	ret    

00801c1e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c1e:	55                   	push   %ebp
  801c1f:	89 e5                	mov    %esp,%ebp
  801c21:	57                   	push   %edi
  801c22:	56                   	push   %esi
  801c23:	53                   	push   %ebx
  801c24:	8b 55 08             	mov    0x8(%ebp),%edx
  801c27:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c2a:	0f b6 0a             	movzbl (%edx),%ecx
  801c2d:	80 f9 09             	cmp    $0x9,%cl
  801c30:	74 05                	je     801c37 <strtol+0x19>
  801c32:	80 f9 20             	cmp    $0x20,%cl
  801c35:	75 10                	jne    801c47 <strtol+0x29>
		s++;
  801c37:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c3a:	0f b6 0a             	movzbl (%edx),%ecx
  801c3d:	80 f9 09             	cmp    $0x9,%cl
  801c40:	74 f5                	je     801c37 <strtol+0x19>
  801c42:	80 f9 20             	cmp    $0x20,%cl
  801c45:	74 f0                	je     801c37 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c47:	80 f9 2b             	cmp    $0x2b,%cl
  801c4a:	75 0a                	jne    801c56 <strtol+0x38>
		s++;
  801c4c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c4f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c54:	eb 11                	jmp    801c67 <strtol+0x49>
  801c56:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c5b:	80 f9 2d             	cmp    $0x2d,%cl
  801c5e:	75 07                	jne    801c67 <strtol+0x49>
		s++, neg = 1;
  801c60:	83 c2 01             	add    $0x1,%edx
  801c63:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c67:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c6c:	75 15                	jne    801c83 <strtol+0x65>
  801c6e:	80 3a 30             	cmpb   $0x30,(%edx)
  801c71:	75 10                	jne    801c83 <strtol+0x65>
  801c73:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801c77:	75 0a                	jne    801c83 <strtol+0x65>
		s += 2, base = 16;
  801c79:	83 c2 02             	add    $0x2,%edx
  801c7c:	b8 10 00 00 00       	mov    $0x10,%eax
  801c81:	eb 10                	jmp    801c93 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801c83:	85 c0                	test   %eax,%eax
  801c85:	75 0c                	jne    801c93 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801c87:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801c89:	80 3a 30             	cmpb   $0x30,(%edx)
  801c8c:	75 05                	jne    801c93 <strtol+0x75>
		s++, base = 8;
  801c8e:	83 c2 01             	add    $0x1,%edx
  801c91:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c98:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c9b:	0f b6 0a             	movzbl (%edx),%ecx
  801c9e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801ca1:	89 f0                	mov    %esi,%eax
  801ca3:	3c 09                	cmp    $0x9,%al
  801ca5:	77 08                	ja     801caf <strtol+0x91>
			dig = *s - '0';
  801ca7:	0f be c9             	movsbl %cl,%ecx
  801caa:	83 e9 30             	sub    $0x30,%ecx
  801cad:	eb 20                	jmp    801ccf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801caf:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801cb2:	89 f0                	mov    %esi,%eax
  801cb4:	3c 19                	cmp    $0x19,%al
  801cb6:	77 08                	ja     801cc0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801cb8:	0f be c9             	movsbl %cl,%ecx
  801cbb:	83 e9 57             	sub    $0x57,%ecx
  801cbe:	eb 0f                	jmp    801ccf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801cc0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801cc3:	89 f0                	mov    %esi,%eax
  801cc5:	3c 19                	cmp    $0x19,%al
  801cc7:	77 16                	ja     801cdf <strtol+0xc1>
			dig = *s - 'A' + 10;
  801cc9:	0f be c9             	movsbl %cl,%ecx
  801ccc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801ccf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801cd2:	7d 0f                	jge    801ce3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801cd4:	83 c2 01             	add    $0x1,%edx
  801cd7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801cdb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801cdd:	eb bc                	jmp    801c9b <strtol+0x7d>
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	eb 02                	jmp    801ce5 <strtol+0xc7>
  801ce3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801ce5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce9:	74 05                	je     801cf0 <strtol+0xd2>
		*endptr = (char *) s;
  801ceb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cee:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801cf0:	f7 d8                	neg    %eax
  801cf2:	85 ff                	test   %edi,%edi
  801cf4:	0f 44 c3             	cmove  %ebx,%eax
}
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    

00801cfc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	56                   	push   %esi
  801d00:	53                   	push   %ebx
  801d01:	83 ec 10             	sub    $0x10,%esp
  801d04:	8b 75 08             	mov    0x8(%ebp),%esi
  801d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d14:	0f 44 c2             	cmove  %edx,%eax
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 a4 e6 ff ff       	call   8003c3 <sys_ipc_recv>
	if (err_code < 0) {
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	79 16                	jns    801d39 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d23:	85 f6                	test   %esi,%esi
  801d25:	74 06                	je     801d2d <ipc_recv+0x31>
  801d27:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d2d:	85 db                	test   %ebx,%ebx
  801d2f:	74 2c                	je     801d5d <ipc_recv+0x61>
  801d31:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d37:	eb 24                	jmp    801d5d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d39:	85 f6                	test   %esi,%esi
  801d3b:	74 0a                	je     801d47 <ipc_recv+0x4b>
  801d3d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d42:	8b 40 74             	mov    0x74(%eax),%eax
  801d45:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d47:	85 db                	test   %ebx,%ebx
  801d49:	74 0a                	je     801d55 <ipc_recv+0x59>
  801d4b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d50:	8b 40 78             	mov    0x78(%eax),%eax
  801d53:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d55:	a1 04 40 80 00       	mov    0x804004,%eax
  801d5a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	5b                   	pop    %ebx
  801d61:	5e                   	pop    %esi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    

00801d64 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	57                   	push   %edi
  801d68:	56                   	push   %esi
  801d69:	53                   	push   %ebx
  801d6a:	83 ec 1c             	sub    $0x1c,%esp
  801d6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d70:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d73:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d76:	eb 25                	jmp    801d9d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d78:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d7b:	74 20                	je     801d9d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d7d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d81:	c7 44 24 08 20 25 80 	movl   $0x802520,0x8(%esp)
  801d88:	00 
  801d89:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801d90:	00 
  801d91:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  801d98:	e8 29 f4 ff ff       	call   8011c6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d9d:	85 db                	test   %ebx,%ebx
  801d9f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801da4:	0f 45 c3             	cmovne %ebx,%eax
  801da7:	8b 55 14             	mov    0x14(%ebp),%edx
  801daa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801db6:	89 3c 24             	mov    %edi,(%esp)
  801db9:	e8 e2 e5 ff ff       	call   8003a0 <sys_ipc_try_send>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	75 b6                	jne    801d78 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801dc2:	83 c4 1c             	add    $0x1c,%esp
  801dc5:	5b                   	pop    %ebx
  801dc6:	5e                   	pop    %esi
  801dc7:	5f                   	pop    %edi
  801dc8:	5d                   	pop    %ebp
  801dc9:	c3                   	ret    

00801dca <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dca:	55                   	push   %ebp
  801dcb:	89 e5                	mov    %esp,%ebp
  801dcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801dd0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801dd5:	39 c8                	cmp    %ecx,%eax
  801dd7:	74 17                	je     801df0 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dde:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801de1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801de7:	8b 52 50             	mov    0x50(%edx),%edx
  801dea:	39 ca                	cmp    %ecx,%edx
  801dec:	75 14                	jne    801e02 <ipc_find_env+0x38>
  801dee:	eb 05                	jmp    801df5 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801df0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801df5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801df8:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801dfd:	8b 40 40             	mov    0x40(%eax),%eax
  801e00:	eb 0e                	jmp    801e10 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801e02:	83 c0 01             	add    $0x1,%eax
  801e05:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e0a:	75 d2                	jne    801dde <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801e0c:	66 b8 00 00          	mov    $0x0,%ax
}
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e18:	89 d0                	mov    %edx,%eax
  801e1a:	c1 e8 16             	shr    $0x16,%eax
  801e1d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e24:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e29:	f6 c1 01             	test   $0x1,%cl
  801e2c:	74 1d                	je     801e4b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e2e:	c1 ea 0c             	shr    $0xc,%edx
  801e31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e38:	f6 c2 01             	test   $0x1,%dl
  801e3b:	74 0e                	je     801e4b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e3d:	c1 ea 0c             	shr    $0xc,%edx
  801e40:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e47:	ef 
  801e48:	0f b7 c0             	movzwl %ax,%eax
}
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    
  801e4d:	66 90                	xchg   %ax,%ax
  801e4f:	90                   	nop

00801e50 <__udivdi3>:
  801e50:	55                   	push   %ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e5a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e5e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e62:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e66:	85 c0                	test   %eax,%eax
  801e68:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e6c:	89 ea                	mov    %ebp,%edx
  801e6e:	89 0c 24             	mov    %ecx,(%esp)
  801e71:	75 2d                	jne    801ea0 <__udivdi3+0x50>
  801e73:	39 e9                	cmp    %ebp,%ecx
  801e75:	77 61                	ja     801ed8 <__udivdi3+0x88>
  801e77:	85 c9                	test   %ecx,%ecx
  801e79:	89 ce                	mov    %ecx,%esi
  801e7b:	75 0b                	jne    801e88 <__udivdi3+0x38>
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	f7 f1                	div    %ecx
  801e86:	89 c6                	mov    %eax,%esi
  801e88:	31 d2                	xor    %edx,%edx
  801e8a:	89 e8                	mov    %ebp,%eax
  801e8c:	f7 f6                	div    %esi
  801e8e:	89 c5                	mov    %eax,%ebp
  801e90:	89 f8                	mov    %edi,%eax
  801e92:	f7 f6                	div    %esi
  801e94:	89 ea                	mov    %ebp,%edx
  801e96:	83 c4 0c             	add    $0xc,%esp
  801e99:	5e                   	pop    %esi
  801e9a:	5f                   	pop    %edi
  801e9b:	5d                   	pop    %ebp
  801e9c:	c3                   	ret    
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	39 e8                	cmp    %ebp,%eax
  801ea2:	77 24                	ja     801ec8 <__udivdi3+0x78>
  801ea4:	0f bd e8             	bsr    %eax,%ebp
  801ea7:	83 f5 1f             	xor    $0x1f,%ebp
  801eaa:	75 3c                	jne    801ee8 <__udivdi3+0x98>
  801eac:	8b 74 24 04          	mov    0x4(%esp),%esi
  801eb0:	39 34 24             	cmp    %esi,(%esp)
  801eb3:	0f 86 9f 00 00 00    	jbe    801f58 <__udivdi3+0x108>
  801eb9:	39 d0                	cmp    %edx,%eax
  801ebb:	0f 82 97 00 00 00    	jb     801f58 <__udivdi3+0x108>
  801ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801ec8:	31 d2                	xor    %edx,%edx
  801eca:	31 c0                	xor    %eax,%eax
  801ecc:	83 c4 0c             	add    $0xc,%esp
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    
  801ed3:	90                   	nop
  801ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ed8:	89 f8                	mov    %edi,%eax
  801eda:	f7 f1                	div    %ecx
  801edc:	31 d2                	xor    %edx,%edx
  801ede:	83 c4 0c             	add    $0xc,%esp
  801ee1:	5e                   	pop    %esi
  801ee2:	5f                   	pop    %edi
  801ee3:	5d                   	pop    %ebp
  801ee4:	c3                   	ret    
  801ee5:	8d 76 00             	lea    0x0(%esi),%esi
  801ee8:	89 e9                	mov    %ebp,%ecx
  801eea:	8b 3c 24             	mov    (%esp),%edi
  801eed:	d3 e0                	shl    %cl,%eax
  801eef:	89 c6                	mov    %eax,%esi
  801ef1:	b8 20 00 00 00       	mov    $0x20,%eax
  801ef6:	29 e8                	sub    %ebp,%eax
  801ef8:	89 c1                	mov    %eax,%ecx
  801efa:	d3 ef                	shr    %cl,%edi
  801efc:	89 e9                	mov    %ebp,%ecx
  801efe:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801f02:	8b 3c 24             	mov    (%esp),%edi
  801f05:	09 74 24 08          	or     %esi,0x8(%esp)
  801f09:	89 d6                	mov    %edx,%esi
  801f0b:	d3 e7                	shl    %cl,%edi
  801f0d:	89 c1                	mov    %eax,%ecx
  801f0f:	89 3c 24             	mov    %edi,(%esp)
  801f12:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f16:	d3 ee                	shr    %cl,%esi
  801f18:	89 e9                	mov    %ebp,%ecx
  801f1a:	d3 e2                	shl    %cl,%edx
  801f1c:	89 c1                	mov    %eax,%ecx
  801f1e:	d3 ef                	shr    %cl,%edi
  801f20:	09 d7                	or     %edx,%edi
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	89 f8                	mov    %edi,%eax
  801f26:	f7 74 24 08          	divl   0x8(%esp)
  801f2a:	89 d6                	mov    %edx,%esi
  801f2c:	89 c7                	mov    %eax,%edi
  801f2e:	f7 24 24             	mull   (%esp)
  801f31:	39 d6                	cmp    %edx,%esi
  801f33:	89 14 24             	mov    %edx,(%esp)
  801f36:	72 30                	jb     801f68 <__udivdi3+0x118>
  801f38:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f3c:	89 e9                	mov    %ebp,%ecx
  801f3e:	d3 e2                	shl    %cl,%edx
  801f40:	39 c2                	cmp    %eax,%edx
  801f42:	73 05                	jae    801f49 <__udivdi3+0xf9>
  801f44:	3b 34 24             	cmp    (%esp),%esi
  801f47:	74 1f                	je     801f68 <__udivdi3+0x118>
  801f49:	89 f8                	mov    %edi,%eax
  801f4b:	31 d2                	xor    %edx,%edx
  801f4d:	e9 7a ff ff ff       	jmp    801ecc <__udivdi3+0x7c>
  801f52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f58:	31 d2                	xor    %edx,%edx
  801f5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5f:	e9 68 ff ff ff       	jmp    801ecc <__udivdi3+0x7c>
  801f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f68:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f6b:	31 d2                	xor    %edx,%edx
  801f6d:	83 c4 0c             	add    $0xc,%esp
  801f70:	5e                   	pop    %esi
  801f71:	5f                   	pop    %edi
  801f72:	5d                   	pop    %ebp
  801f73:	c3                   	ret    
  801f74:	66 90                	xchg   %ax,%ax
  801f76:	66 90                	xchg   %ax,%ax
  801f78:	66 90                	xchg   %ax,%ax
  801f7a:	66 90                	xchg   %ax,%ax
  801f7c:	66 90                	xchg   %ax,%ax
  801f7e:	66 90                	xchg   %ax,%ax

00801f80 <__umoddi3>:
  801f80:	55                   	push   %ebp
  801f81:	57                   	push   %edi
  801f82:	56                   	push   %esi
  801f83:	83 ec 14             	sub    $0x14,%esp
  801f86:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f8a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f8e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801f92:	89 c7                	mov    %eax,%edi
  801f94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f98:	8b 44 24 30          	mov    0x30(%esp),%eax
  801f9c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801fa0:	89 34 24             	mov    %esi,(%esp)
  801fa3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	89 c2                	mov    %eax,%edx
  801fab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801faf:	75 17                	jne    801fc8 <__umoddi3+0x48>
  801fb1:	39 fe                	cmp    %edi,%esi
  801fb3:	76 4b                	jbe    802000 <__umoddi3+0x80>
  801fb5:	89 c8                	mov    %ecx,%eax
  801fb7:	89 fa                	mov    %edi,%edx
  801fb9:	f7 f6                	div    %esi
  801fbb:	89 d0                	mov    %edx,%eax
  801fbd:	31 d2                	xor    %edx,%edx
  801fbf:	83 c4 14             	add    $0x14,%esp
  801fc2:	5e                   	pop    %esi
  801fc3:	5f                   	pop    %edi
  801fc4:	5d                   	pop    %ebp
  801fc5:	c3                   	ret    
  801fc6:	66 90                	xchg   %ax,%ax
  801fc8:	39 f8                	cmp    %edi,%eax
  801fca:	77 54                	ja     802020 <__umoddi3+0xa0>
  801fcc:	0f bd e8             	bsr    %eax,%ebp
  801fcf:	83 f5 1f             	xor    $0x1f,%ebp
  801fd2:	75 5c                	jne    802030 <__umoddi3+0xb0>
  801fd4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fd8:	39 3c 24             	cmp    %edi,(%esp)
  801fdb:	0f 87 e7 00 00 00    	ja     8020c8 <__umoddi3+0x148>
  801fe1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fe5:	29 f1                	sub    %esi,%ecx
  801fe7:	19 c7                	sbb    %eax,%edi
  801fe9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ff1:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ff5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801ff9:	83 c4 14             	add    $0x14,%esp
  801ffc:	5e                   	pop    %esi
  801ffd:	5f                   	pop    %edi
  801ffe:	5d                   	pop    %ebp
  801fff:	c3                   	ret    
  802000:	85 f6                	test   %esi,%esi
  802002:	89 f5                	mov    %esi,%ebp
  802004:	75 0b                	jne    802011 <__umoddi3+0x91>
  802006:	b8 01 00 00 00       	mov    $0x1,%eax
  80200b:	31 d2                	xor    %edx,%edx
  80200d:	f7 f6                	div    %esi
  80200f:	89 c5                	mov    %eax,%ebp
  802011:	8b 44 24 04          	mov    0x4(%esp),%eax
  802015:	31 d2                	xor    %edx,%edx
  802017:	f7 f5                	div    %ebp
  802019:	89 c8                	mov    %ecx,%eax
  80201b:	f7 f5                	div    %ebp
  80201d:	eb 9c                	jmp    801fbb <__umoddi3+0x3b>
  80201f:	90                   	nop
  802020:	89 c8                	mov    %ecx,%eax
  802022:	89 fa                	mov    %edi,%edx
  802024:	83 c4 14             	add    $0x14,%esp
  802027:	5e                   	pop    %esi
  802028:	5f                   	pop    %edi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    
  80202b:	90                   	nop
  80202c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802030:	8b 04 24             	mov    (%esp),%eax
  802033:	be 20 00 00 00       	mov    $0x20,%esi
  802038:	89 e9                	mov    %ebp,%ecx
  80203a:	29 ee                	sub    %ebp,%esi
  80203c:	d3 e2                	shl    %cl,%edx
  80203e:	89 f1                	mov    %esi,%ecx
  802040:	d3 e8                	shr    %cl,%eax
  802042:	89 e9                	mov    %ebp,%ecx
  802044:	89 44 24 04          	mov    %eax,0x4(%esp)
  802048:	8b 04 24             	mov    (%esp),%eax
  80204b:	09 54 24 04          	or     %edx,0x4(%esp)
  80204f:	89 fa                	mov    %edi,%edx
  802051:	d3 e0                	shl    %cl,%eax
  802053:	89 f1                	mov    %esi,%ecx
  802055:	89 44 24 08          	mov    %eax,0x8(%esp)
  802059:	8b 44 24 10          	mov    0x10(%esp),%eax
  80205d:	d3 ea                	shr    %cl,%edx
  80205f:	89 e9                	mov    %ebp,%ecx
  802061:	d3 e7                	shl    %cl,%edi
  802063:	89 f1                	mov    %esi,%ecx
  802065:	d3 e8                	shr    %cl,%eax
  802067:	89 e9                	mov    %ebp,%ecx
  802069:	09 f8                	or     %edi,%eax
  80206b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80206f:	f7 74 24 04          	divl   0x4(%esp)
  802073:	d3 e7                	shl    %cl,%edi
  802075:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802079:	89 d7                	mov    %edx,%edi
  80207b:	f7 64 24 08          	mull   0x8(%esp)
  80207f:	39 d7                	cmp    %edx,%edi
  802081:	89 c1                	mov    %eax,%ecx
  802083:	89 14 24             	mov    %edx,(%esp)
  802086:	72 2c                	jb     8020b4 <__umoddi3+0x134>
  802088:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80208c:	72 22                	jb     8020b0 <__umoddi3+0x130>
  80208e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802092:	29 c8                	sub    %ecx,%eax
  802094:	19 d7                	sbb    %edx,%edi
  802096:	89 e9                	mov    %ebp,%ecx
  802098:	89 fa                	mov    %edi,%edx
  80209a:	d3 e8                	shr    %cl,%eax
  80209c:	89 f1                	mov    %esi,%ecx
  80209e:	d3 e2                	shl    %cl,%edx
  8020a0:	89 e9                	mov    %ebp,%ecx
  8020a2:	d3 ef                	shr    %cl,%edi
  8020a4:	09 d0                	or     %edx,%eax
  8020a6:	89 fa                	mov    %edi,%edx
  8020a8:	83 c4 14             	add    $0x14,%esp
  8020ab:	5e                   	pop    %esi
  8020ac:	5f                   	pop    %edi
  8020ad:	5d                   	pop    %ebp
  8020ae:	c3                   	ret    
  8020af:	90                   	nop
  8020b0:	39 d7                	cmp    %edx,%edi
  8020b2:	75 da                	jne    80208e <__umoddi3+0x10e>
  8020b4:	8b 14 24             	mov    (%esp),%edx
  8020b7:	89 c1                	mov    %eax,%ecx
  8020b9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020bd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020c1:	eb cb                	jmp    80208e <__umoddi3+0x10e>
  8020c3:	90                   	nop
  8020c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020c8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020cc:	0f 82 0f ff ff ff    	jb     801fe1 <__umoddi3+0x61>
  8020d2:	e9 1a ff ff ff       	jmp    801ff1 <__umoddi3+0x71>
