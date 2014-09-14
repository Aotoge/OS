
obj/user/badsegment.debug:     file format elf32-i386


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
  80002c:	e8 0d 00 00 00       	call   80003e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	// Try to load the kernel's TSS selector into the DS register.
	asm volatile("movw $0x28,%ax; movw %ax,%ds");
  800036:	66 b8 28 00          	mov    $0x28,%ax
  80003a:	8e d8                	mov    %eax,%ds
}
  80003c:	5d                   	pop    %ebp
  80003d:	c3                   	ret    

0080003e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80003e:	55                   	push   %ebp
  80003f:	89 e5                	mov    %esp,%ebp
  800041:	56                   	push   %esi
  800042:	53                   	push   %ebx
  800043:	83 ec 10             	sub    $0x10,%esp
  800046:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800049:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
  80004c:	e8 0d 01 00 00       	call   80015e <sys_getenvid>
	for (i = 0; i < NENV; ++i) {
		if (envs[i].env_id == current_id) {
  800051:	8b 15 48 00 c0 ee    	mov    0xeec00048,%edx
  800057:	39 c2                	cmp    %eax,%edx
  800059:	74 17                	je     800072 <libmain+0x34>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  80005b:	ba 01 00 00 00       	mov    $0x1,%edx
		if (envs[i].env_id == current_id) {
  800060:	6b ca 7c             	imul   $0x7c,%edx,%ecx
  800063:	81 c1 08 00 c0 ee    	add    $0xeec00008,%ecx
  800069:	8b 49 40             	mov    0x40(%ecx),%ecx
  80006c:	39 c1                	cmp    %eax,%ecx
  80006e:	75 18                	jne    800088 <libmain+0x4a>
  800070:	eb 05                	jmp    800077 <libmain+0x39>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800072:	ba 00 00 00 00       	mov    $0x0,%edx
		if (envs[i].env_id == current_id) {
		// if (envs[i].env_status == ENV_RUNNING) {
			thisenv = envs + i;
  800077:	6b d2 7c             	imul   $0x7c,%edx,%edx
  80007a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  800080:	89 15 04 40 80 00    	mov    %edx,0x804004
			break;
  800086:	eb 0b                	jmp    800093 <libmain+0x55>
libmain(int argc, char **argv)
{
	// set thisenv to point at our Env structure in envs[].
	int i;
	envid_t current_id = sys_getenvid();
	for (i = 0; i < NENV; ++i) {
  800088:	83 c2 01             	add    $0x1,%edx
  80008b:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800091:	75 cd                	jne    800060 <libmain+0x22>

	// cprintf("ID Get from sys: %d\n", current_id);
	// cprintf("ID Get by loop: %d\n", thisenv->env_id);

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800093:	85 db                	test   %ebx,%ebx
  800095:	7e 07                	jle    80009e <libmain+0x60>
		binaryname = argv[0];
  800097:	8b 06                	mov    (%esi),%eax
  800099:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80009e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000a2:	89 1c 24             	mov    %ebx,(%esp)
  8000a5:	e8 89 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000aa:	e8 07 00 00 00       	call   8000b6 <exit>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	5b                   	pop    %ebx
  8000b3:	5e                   	pop    %esi
  8000b4:	5d                   	pop    %ebp
  8000b5:	c3                   	ret    

008000b6 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b6:	55                   	push   %ebp
  8000b7:	89 e5                	mov    %esp,%ebp
  8000b9:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000bc:	e8 65 05 00 00       	call   800626 <close_all>
	sys_env_destroy(0);
  8000c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000c8:	e8 3f 00 00 00       	call   80010c <sys_env_destroy>
}
  8000cd:	c9                   	leave  
  8000ce:	c3                   	ret    

008000cf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000cf:	55                   	push   %ebp
  8000d0:	89 e5                	mov    %esp,%ebp
  8000d2:	57                   	push   %edi
  8000d3:	56                   	push   %esi
  8000d4:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8000e0:	89 c3                	mov    %eax,%ebx
  8000e2:	89 c7                	mov    %eax,%edi
  8000e4:	89 c6                	mov    %eax,%esi
  8000e6:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e8:	5b                   	pop    %ebx
  8000e9:	5e                   	pop    %esi
  8000ea:	5f                   	pop    %edi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000fd:	89 d1                	mov    %edx,%ecx
  8000ff:	89 d3                	mov    %edx,%ebx
  800101:	89 d7                	mov    %edx,%edi
  800103:	89 d6                	mov    %edx,%esi
  800105:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800107:	5b                   	pop    %ebx
  800108:	5e                   	pop    %esi
  800109:	5f                   	pop    %edi
  80010a:	5d                   	pop    %ebp
  80010b:	c3                   	ret    

0080010c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80010c:	55                   	push   %ebp
  80010d:	89 e5                	mov    %esp,%ebp
  80010f:	57                   	push   %edi
  800110:	56                   	push   %esi
  800111:	53                   	push   %ebx
  800112:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800115:	b9 00 00 00 00       	mov    $0x0,%ecx
  80011a:	b8 03 00 00 00       	mov    $0x3,%eax
  80011f:	8b 55 08             	mov    0x8(%ebp),%edx
  800122:	89 cb                	mov    %ecx,%ebx
  800124:	89 cf                	mov    %ecx,%edi
  800126:	89 ce                	mov    %ecx,%esi
  800128:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80012a:	85 c0                	test   %eax,%eax
  80012c:	7e 28                	jle    800156 <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80012e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800132:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800139:	00 
  80013a:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800141:	00 
  800142:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800149:	00 
  80014a:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800151:	e8 60 10 00 00       	call   8011b6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800156:	83 c4 2c             	add    $0x2c,%esp
  800159:	5b                   	pop    %ebx
  80015a:	5e                   	pop    %esi
  80015b:	5f                   	pop    %edi
  80015c:	5d                   	pop    %ebp
  80015d:	c3                   	ret    

0080015e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	57                   	push   %edi
  800162:	56                   	push   %esi
  800163:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800164:	ba 00 00 00 00       	mov    $0x0,%edx
  800169:	b8 02 00 00 00       	mov    $0x2,%eax
  80016e:	89 d1                	mov    %edx,%ecx
  800170:	89 d3                	mov    %edx,%ebx
  800172:	89 d7                	mov    %edx,%edi
  800174:	89 d6                	mov    %edx,%esi
  800176:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800178:	5b                   	pop    %ebx
  800179:	5e                   	pop    %esi
  80017a:	5f                   	pop    %edi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <sys_yield>:

void
sys_yield(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	57                   	push   %edi
  800181:	56                   	push   %esi
  800182:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800183:	ba 00 00 00 00       	mov    $0x0,%edx
  800188:	b8 0b 00 00 00       	mov    $0xb,%eax
  80018d:	89 d1                	mov    %edx,%ecx
  80018f:	89 d3                	mov    %edx,%ebx
  800191:	89 d7                	mov    %edx,%edi
  800193:	89 d6                	mov    %edx,%esi
  800195:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800197:	5b                   	pop    %ebx
  800198:	5e                   	pop    %esi
  800199:	5f                   	pop    %edi
  80019a:	5d                   	pop    %ebp
  80019b:	c3                   	ret    

0080019c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	57                   	push   %edi
  8001a0:	56                   	push   %esi
  8001a1:	53                   	push   %ebx
  8001a2:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001a5:	be 00 00 00 00       	mov    $0x0,%esi
  8001aa:	b8 04 00 00 00       	mov    $0x4,%eax
  8001af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b8:	89 f7                	mov    %esi,%edi
  8001ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8001bc:	85 c0                	test   %eax,%eax
  8001be:	7e 28                	jle    8001e8 <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001c4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8001cb:	00 
  8001cc:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8001d3:	00 
  8001d4:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001db:	00 
  8001dc:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  8001e3:	e8 ce 0f 00 00       	call   8011b6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8001e8:	83 c4 2c             	add    $0x2c,%esp
  8001eb:	5b                   	pop    %ebx
  8001ec:	5e                   	pop    %esi
  8001ed:	5f                   	pop    %edi
  8001ee:	5d                   	pop    %ebp
  8001ef:	c3                   	ret    

008001f0 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001f9:	b8 05 00 00 00       	mov    $0x5,%eax
  8001fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800201:	8b 55 08             	mov    0x8(%ebp),%edx
  800204:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800207:	8b 7d 14             	mov    0x14(%ebp),%edi
  80020a:	8b 75 18             	mov    0x18(%ebp),%esi
  80020d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80020f:	85 c0                	test   %eax,%eax
  800211:	7e 28                	jle    80023b <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800213:	89 44 24 10          	mov    %eax,0x10(%esp)
  800217:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80021e:	00 
  80021f:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800226:	00 
  800227:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80022e:	00 
  80022f:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800236:	e8 7b 0f 00 00       	call   8011b6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80023b:	83 c4 2c             	add    $0x2c,%esp
  80023e:	5b                   	pop    %ebx
  80023f:	5e                   	pop    %esi
  800240:	5f                   	pop    %edi
  800241:	5d                   	pop    %ebp
  800242:	c3                   	ret    

00800243 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	57                   	push   %edi
  800247:	56                   	push   %esi
  800248:	53                   	push   %ebx
  800249:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80024c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800251:	b8 06 00 00 00       	mov    $0x6,%eax
  800256:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800259:	8b 55 08             	mov    0x8(%ebp),%edx
  80025c:	89 df                	mov    %ebx,%edi
  80025e:	89 de                	mov    %ebx,%esi
  800260:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800262:	85 c0                	test   %eax,%eax
  800264:	7e 28                	jle    80028e <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800266:	89 44 24 10          	mov    %eax,0x10(%esp)
  80026a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800271:	00 
  800272:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800279:	00 
  80027a:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800281:	00 
  800282:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800289:	e8 28 0f 00 00       	call   8011b6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80028e:	83 c4 2c             	add    $0x2c,%esp
  800291:	5b                   	pop    %ebx
  800292:	5e                   	pop    %esi
  800293:	5f                   	pop    %edi
  800294:	5d                   	pop    %ebp
  800295:	c3                   	ret    

00800296 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800296:	55                   	push   %ebp
  800297:	89 e5                	mov    %esp,%ebp
  800299:	57                   	push   %edi
  80029a:	56                   	push   %esi
  80029b:	53                   	push   %ebx
  80029c:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80029f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8002a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8002af:	89 df                	mov    %ebx,%edi
  8002b1:	89 de                	mov    %ebx,%esi
  8002b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8002b5:	85 c0                	test   %eax,%eax
  8002b7:	7e 28                	jle    8002e1 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002bd:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8002c4:	00 
  8002c5:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8002cc:	00 
  8002cd:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8002d4:	00 
  8002d5:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  8002dc:	e8 d5 0e 00 00       	call   8011b6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8002e1:	83 c4 2c             	add    $0x2c,%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	57                   	push   %edi
  8002ed:	56                   	push   %esi
  8002ee:	53                   	push   %ebx
  8002ef:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f7:	b8 09 00 00 00       	mov    $0x9,%eax
  8002fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ff:	8b 55 08             	mov    0x8(%ebp),%edx
  800302:	89 df                	mov    %ebx,%edi
  800304:	89 de                	mov    %ebx,%esi
  800306:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800308:	85 c0                	test   %eax,%eax
  80030a:	7e 28                	jle    800334 <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80030c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800310:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800317:	00 
  800318:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  80031f:	00 
  800320:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  800327:	00 
  800328:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  80032f:	e8 82 0e 00 00       	call   8011b6 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800334:	83 c4 2c             	add    $0x2c,%esp
  800337:	5b                   	pop    %ebx
  800338:	5e                   	pop    %esi
  800339:	5f                   	pop    %edi
  80033a:	5d                   	pop    %ebp
  80033b:	c3                   	ret    

0080033c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	57                   	push   %edi
  800340:	56                   	push   %esi
  800341:	53                   	push   %ebx
  800342:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800345:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80034f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800352:	8b 55 08             	mov    0x8(%ebp),%edx
  800355:	89 df                	mov    %ebx,%edi
  800357:	89 de                	mov    %ebx,%esi
  800359:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80035b:	85 c0                	test   %eax,%eax
  80035d:	7e 28                	jle    800387 <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80035f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800363:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  80036a:	00 
  80036b:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  800372:	00 
  800373:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80037a:	00 
  80037b:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  800382:	e8 2f 0e 00 00       	call   8011b6 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800387:	83 c4 2c             	add    $0x2c,%esp
  80038a:	5b                   	pop    %ebx
  80038b:	5e                   	pop    %esi
  80038c:	5f                   	pop    %edi
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800395:	be 00 00 00 00       	mov    $0x0,%esi
  80039a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80039f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8003ab:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8003ad:	5b                   	pop    %ebx
  8003ae:	5e                   	pop    %esi
  8003af:	5f                   	pop    %edi
  8003b0:	5d                   	pop    %ebp
  8003b1:	c3                   	ret    

008003b2 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8003b2:	55                   	push   %ebp
  8003b3:	89 e5                	mov    %esp,%ebp
  8003b5:	57                   	push   %edi
  8003b6:	56                   	push   %esi
  8003b7:	53                   	push   %ebx
  8003b8:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003bb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c0:	b8 0d 00 00 00       	mov    $0xd,%eax
  8003c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c8:	89 cb                	mov    %ecx,%ebx
  8003ca:	89 cf                	mov    %ecx,%edi
  8003cc:	89 ce                	mov    %ecx,%esi
  8003ce:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8003d0:	85 c0                	test   %eax,%eax
  8003d2:	7e 28                	jle    8003fc <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003d4:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003d8:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8003df:	00 
  8003e0:	c7 44 24 08 ea 20 80 	movl   $0x8020ea,0x8(%esp)
  8003e7:	00 
  8003e8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8003ef:	00 
  8003f0:	c7 04 24 07 21 80 00 	movl   $0x802107,(%esp)
  8003f7:	e8 ba 0d 00 00       	call   8011b6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003fc:	83 c4 2c             	add    $0x2c,%esp
  8003ff:	5b                   	pop    %ebx
  800400:	5e                   	pop    %esi
  800401:	5f                   	pop    %edi
  800402:	5d                   	pop    %ebp
  800403:	c3                   	ret    
  800404:	66 90                	xchg   %ax,%ax
  800406:	66 90                	xchg   %ax,%ax
  800408:	66 90                	xchg   %ax,%ax
  80040a:	66 90                	xchg   %ax,%ax
  80040c:	66 90                	xchg   %ax,%ax
  80040e:	66 90                	xchg   %ax,%ax

00800410 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800413:	8b 45 08             	mov    0x8(%ebp),%eax
  800416:	05 00 00 00 30       	add    $0x30000000,%eax
  80041b:	c1 e8 0c             	shr    $0xc,%eax
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800423:	8b 45 08             	mov    0x8(%ebp),%eax
  800426:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80042b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800430:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800435:	5d                   	pop    %ebp
  800436:	c3                   	ret    

00800437 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800437:	55                   	push   %ebp
  800438:	89 e5                	mov    %esp,%ebp
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80043a:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  80043f:	a8 01                	test   $0x1,%al
  800441:	74 34                	je     800477 <fd_alloc+0x40>
  800443:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800448:	a8 01                	test   $0x1,%al
  80044a:	74 32                	je     80047e <fd_alloc+0x47>
  80044c:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800451:	89 c1                	mov    %eax,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800453:	89 c2                	mov    %eax,%edx
  800455:	c1 ea 16             	shr    $0x16,%edx
  800458:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80045f:	f6 c2 01             	test   $0x1,%dl
  800462:	74 1f                	je     800483 <fd_alloc+0x4c>
  800464:	89 c2                	mov    %eax,%edx
  800466:	c1 ea 0c             	shr    $0xc,%edx
  800469:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800470:	f6 c2 01             	test   $0x1,%dl
  800473:	75 1a                	jne    80048f <fd_alloc+0x58>
  800475:	eb 0c                	jmp    800483 <fd_alloc+0x4c>
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
  800477:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80047c:	eb 05                	jmp    800483 <fd_alloc+0x4c>
  80047e:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
  800483:	8b 45 08             	mov    0x8(%ebp),%eax
  800486:	89 08                	mov    %ecx,(%eax)
			return 0;
  800488:	b8 00 00 00 00       	mov    $0x0,%eax
  80048d:	eb 1a                	jmp    8004a9 <fd_alloc+0x72>
  80048f:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800494:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800499:	75 b6                	jne    800451 <fd_alloc+0x1a>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8004a4:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8004a9:	5d                   	pop    %ebp
  8004aa:	c3                   	ret    

008004ab <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004ab:	55                   	push   %ebp
  8004ac:	89 e5                	mov    %esp,%ebp
  8004ae:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004b1:	83 f8 1f             	cmp    $0x1f,%eax
  8004b4:	77 36                	ja     8004ec <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004b6:	c1 e0 0c             	shl    $0xc,%eax
  8004b9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004be:	89 c2                	mov    %eax,%edx
  8004c0:	c1 ea 16             	shr    $0x16,%edx
  8004c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004ca:	f6 c2 01             	test   $0x1,%dl
  8004cd:	74 24                	je     8004f3 <fd_lookup+0x48>
  8004cf:	89 c2                	mov    %eax,%edx
  8004d1:	c1 ea 0c             	shr    $0xc,%edx
  8004d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004db:	f6 c2 01             	test   $0x1,%dl
  8004de:	74 1a                	je     8004fa <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e3:	89 02                	mov    %eax,(%edx)
	return 0;
  8004e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ea:	eb 13                	jmp    8004ff <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8004ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004f1:	eb 0c                	jmp    8004ff <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8004f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004f8:	eb 05                	jmp    8004ff <fd_lookup+0x54>
  8004fa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8004ff:	5d                   	pop    %ebp
  800500:	c3                   	ret    

00800501 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800501:	55                   	push   %ebp
  800502:	89 e5                	mov    %esp,%ebp
  800504:	53                   	push   %ebx
  800505:	83 ec 14             	sub    $0x14,%esp
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  80050e:	39 05 04 30 80 00    	cmp    %eax,0x803004
  800514:	75 1e                	jne    800534 <dev_lookup+0x33>
  800516:	eb 0e                	jmp    800526 <dev_lookup+0x25>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800518:	b8 20 30 80 00       	mov    $0x803020,%eax
  80051d:	eb 0c                	jmp    80052b <dev_lookup+0x2a>
  80051f:	b8 3c 30 80 00       	mov    $0x80303c,%eax
  800524:	eb 05                	jmp    80052b <dev_lookup+0x2a>
  800526:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
  80052b:	89 03                	mov    %eax,(%ebx)
			return 0;
  80052d:	b8 00 00 00 00       	mov    $0x0,%eax
  800532:	eb 38                	jmp    80056c <dev_lookup+0x6b>
int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
  800534:	39 05 20 30 80 00    	cmp    %eax,0x803020
  80053a:	74 dc                	je     800518 <dev_lookup+0x17>
  80053c:	39 05 3c 30 80 00    	cmp    %eax,0x80303c
  800542:	74 db                	je     80051f <dev_lookup+0x1e>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800544:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80054a:	8b 52 48             	mov    0x48(%edx),%edx
  80054d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800551:	89 54 24 04          	mov    %edx,0x4(%esp)
  800555:	c7 04 24 18 21 80 00 	movl   $0x802118,(%esp)
  80055c:	e8 4e 0d 00 00       	call   8012af <cprintf>
	*dev = 0;
  800561:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	return -E_INVAL;
  800567:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80056c:	83 c4 14             	add    $0x14,%esp
  80056f:	5b                   	pop    %ebx
  800570:	5d                   	pop    %ebp
  800571:	c3                   	ret    

00800572 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800572:	55                   	push   %ebp
  800573:	89 e5                	mov    %esp,%ebp
  800575:	56                   	push   %esi
  800576:	53                   	push   %ebx
  800577:	83 ec 20             	sub    $0x20,%esp
  80057a:	8b 75 08             	mov    0x8(%ebp),%esi
  80057d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800580:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800583:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800587:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80058d:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800590:	89 04 24             	mov    %eax,(%esp)
  800593:	e8 13 ff ff ff       	call   8004ab <fd_lookup>
  800598:	85 c0                	test   %eax,%eax
  80059a:	78 05                	js     8005a1 <fd_close+0x2f>
	    || fd != fd2)
  80059c:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80059f:	74 0c                	je     8005ad <fd_close+0x3b>
		return (must_exist ? r : 0);
  8005a1:	84 db                	test   %bl,%bl
  8005a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a8:	0f 44 c2             	cmove  %edx,%eax
  8005ab:	eb 3f                	jmp    8005ec <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8005ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8005b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005b4:	8b 06                	mov    (%esi),%eax
  8005b6:	89 04 24             	mov    %eax,(%esp)
  8005b9:	e8 43 ff ff ff       	call   800501 <dev_lookup>
  8005be:	89 c3                	mov    %eax,%ebx
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	78 16                	js     8005da <fd_close+0x68>
		if (dev->dev_close)
  8005c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005c7:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8005ca:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8005cf:	85 c0                	test   %eax,%eax
  8005d1:	74 07                	je     8005da <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8005d3:	89 34 24             	mov    %esi,(%esp)
  8005d6:	ff d0                	call   *%eax
  8005d8:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8005da:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005e5:	e8 59 fc ff ff       	call   800243 <sys_page_unmap>
	return r;
  8005ea:	89 d8                	mov    %ebx,%eax
}
  8005ec:	83 c4 20             	add    $0x20,%esp
  8005ef:	5b                   	pop    %ebx
  8005f0:	5e                   	pop    %esi
  8005f1:	5d                   	pop    %ebp
  8005f2:	c3                   	ret    

008005f3 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	e8 a0 fe ff ff       	call   8004ab <fd_lookup>
  80060b:	89 c2                	mov    %eax,%edx
  80060d:	85 d2                	test   %edx,%edx
  80060f:	78 13                	js     800624 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  800611:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800618:	00 
  800619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061c:	89 04 24             	mov    %eax,(%esp)
  80061f:	e8 4e ff ff ff       	call   800572 <fd_close>
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <close_all>:

void
close_all(void)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80062d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800632:	89 1c 24             	mov    %ebx,(%esp)
  800635:	e8 b9 ff ff ff       	call   8005f3 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80063a:	83 c3 01             	add    $0x1,%ebx
  80063d:	83 fb 20             	cmp    $0x20,%ebx
  800640:	75 f0                	jne    800632 <close_all+0xc>
		close(i);
}
  800642:	83 c4 14             	add    $0x14,%esp
  800645:	5b                   	pop    %ebx
  800646:	5d                   	pop    %ebp
  800647:	c3                   	ret    

00800648 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800648:	55                   	push   %ebp
  800649:	89 e5                	mov    %esp,%ebp
  80064b:	57                   	push   %edi
  80064c:	56                   	push   %esi
  80064d:	53                   	push   %ebx
  80064e:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800651:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800654:	89 44 24 04          	mov    %eax,0x4(%esp)
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 04 24             	mov    %eax,(%esp)
  80065e:	e8 48 fe ff ff       	call   8004ab <fd_lookup>
  800663:	89 c2                	mov    %eax,%edx
  800665:	85 d2                	test   %edx,%edx
  800667:	0f 88 e1 00 00 00    	js     80074e <dup+0x106>
		return r;
	close(newfdnum);
  80066d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800670:	89 04 24             	mov    %eax,(%esp)
  800673:	e8 7b ff ff ff       	call   8005f3 <close>

	newfd = INDEX2FD(newfdnum);
  800678:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80067b:	c1 e3 0c             	shl    $0xc,%ebx
  80067e:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  800684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800687:	89 04 24             	mov    %eax,(%esp)
  80068a:	e8 91 fd ff ff       	call   800420 <fd2data>
  80068f:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  800691:	89 1c 24             	mov    %ebx,(%esp)
  800694:	e8 87 fd ff ff       	call   800420 <fd2data>
  800699:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80069b:	89 f0                	mov    %esi,%eax
  80069d:	c1 e8 16             	shr    $0x16,%eax
  8006a0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8006a7:	a8 01                	test   $0x1,%al
  8006a9:	74 43                	je     8006ee <dup+0xa6>
  8006ab:	89 f0                	mov    %esi,%eax
  8006ad:	c1 e8 0c             	shr    $0xc,%eax
  8006b0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8006b7:	f6 c2 01             	test   $0x1,%dl
  8006ba:	74 32                	je     8006ee <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006c3:	25 07 0e 00 00       	and    $0xe07,%eax
  8006c8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006cc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8006d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8006d7:	00 
  8006d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8006e3:	e8 08 fb ff ff       	call   8001f0 <sys_page_map>
  8006e8:	89 c6                	mov    %eax,%esi
  8006ea:	85 c0                	test   %eax,%eax
  8006ec:	78 3e                	js     80072c <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8006ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f1:	89 c2                	mov    %eax,%edx
  8006f3:	c1 ea 0c             	shr    $0xc,%edx
  8006f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8006fd:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800703:	89 54 24 10          	mov    %edx,0x10(%esp)
  800707:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80070b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800712:	00 
  800713:	89 44 24 04          	mov    %eax,0x4(%esp)
  800717:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80071e:	e8 cd fa ff ff       	call   8001f0 <sys_page_map>
  800723:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800728:	85 f6                	test   %esi,%esi
  80072a:	79 22                	jns    80074e <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  80072c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800737:	e8 07 fb ff ff       	call   800243 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80073c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800740:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800747:	e8 f7 fa ff ff       	call   800243 <sys_page_unmap>
	return r;
  80074c:	89 f0                	mov    %esi,%eax
}
  80074e:	83 c4 3c             	add    $0x3c,%esp
  800751:	5b                   	pop    %ebx
  800752:	5e                   	pop    %esi
  800753:	5f                   	pop    %edi
  800754:	5d                   	pop    %ebp
  800755:	c3                   	ret    

00800756 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800756:	55                   	push   %ebp
  800757:	89 e5                	mov    %esp,%ebp
  800759:	53                   	push   %ebx
  80075a:	83 ec 24             	sub    $0x24,%esp
  80075d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800760:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800763:	89 44 24 04          	mov    %eax,0x4(%esp)
  800767:	89 1c 24             	mov    %ebx,(%esp)
  80076a:	e8 3c fd ff ff       	call   8004ab <fd_lookup>
  80076f:	89 c2                	mov    %eax,%edx
  800771:	85 d2                	test   %edx,%edx
  800773:	78 6d                	js     8007e2 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800775:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800778:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	89 04 24             	mov    %eax,(%esp)
  800784:	e8 78 fd ff ff       	call   800501 <dev_lookup>
  800789:	85 c0                	test   %eax,%eax
  80078b:	78 55                	js     8007e2 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80078d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800790:	8b 50 08             	mov    0x8(%eax),%edx
  800793:	83 e2 03             	and    $0x3,%edx
  800796:	83 fa 01             	cmp    $0x1,%edx
  800799:	75 23                	jne    8007be <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80079b:	a1 04 40 80 00       	mov    0x804004,%eax
  8007a0:	8b 40 48             	mov    0x48(%eax),%eax
  8007a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ab:	c7 04 24 59 21 80 00 	movl   $0x802159,(%esp)
  8007b2:	e8 f8 0a 00 00       	call   8012af <cprintf>
		return -E_INVAL;
  8007b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007bc:	eb 24                	jmp    8007e2 <read+0x8c>
	}
	if (!dev->dev_read)
  8007be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c1:	8b 52 08             	mov    0x8(%edx),%edx
  8007c4:	85 d2                	test   %edx,%edx
  8007c6:	74 15                	je     8007dd <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8007c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8007cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d6:	89 04 24             	mov    %eax,(%esp)
  8007d9:	ff d2                	call   *%edx
  8007db:	eb 05                	jmp    8007e2 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8007dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8007e2:	83 c4 24             	add    $0x24,%esp
  8007e5:	5b                   	pop    %ebx
  8007e6:	5d                   	pop    %ebp
  8007e7:	c3                   	ret    

008007e8 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8007e8:	55                   	push   %ebp
  8007e9:	89 e5                	mov    %esp,%ebp
  8007eb:	57                   	push   %edi
  8007ec:	56                   	push   %esi
  8007ed:	53                   	push   %ebx
  8007ee:	83 ec 1c             	sub    $0x1c,%esp
  8007f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007f4:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007f7:	85 f6                	test   %esi,%esi
  8007f9:	74 33                	je     80082e <readn+0x46>
  8007fb:	b8 00 00 00 00       	mov    $0x0,%eax
  800800:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = read(fdnum, (char*)buf + tot, n - tot);
  800805:	89 f2                	mov    %esi,%edx
  800807:	29 c2                	sub    %eax,%edx
  800809:	89 54 24 08          	mov    %edx,0x8(%esp)
  80080d:	03 45 0c             	add    0xc(%ebp),%eax
  800810:	89 44 24 04          	mov    %eax,0x4(%esp)
  800814:	89 3c 24             	mov    %edi,(%esp)
  800817:	e8 3a ff ff ff       	call   800756 <read>
		if (m < 0)
  80081c:	85 c0                	test   %eax,%eax
  80081e:	78 1b                	js     80083b <readn+0x53>
			return m;
		if (m == 0)
  800820:	85 c0                	test   %eax,%eax
  800822:	74 11                	je     800835 <readn+0x4d>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800824:	01 c3                	add    %eax,%ebx
  800826:	89 d8                	mov    %ebx,%eax
  800828:	39 f3                	cmp    %esi,%ebx
  80082a:	72 d9                	jb     800805 <readn+0x1d>
  80082c:	eb 0b                	jmp    800839 <readn+0x51>
  80082e:	b8 00 00 00 00       	mov    $0x0,%eax
  800833:	eb 06                	jmp    80083b <readn+0x53>
  800835:	89 d8                	mov    %ebx,%eax
  800837:	eb 02                	jmp    80083b <readn+0x53>
  800839:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80083b:	83 c4 1c             	add    $0x1c,%esp
  80083e:	5b                   	pop    %ebx
  80083f:	5e                   	pop    %esi
  800840:	5f                   	pop    %edi
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	53                   	push   %ebx
  800847:	83 ec 24             	sub    $0x24,%esp
  80084a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80084d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800850:	89 44 24 04          	mov    %eax,0x4(%esp)
  800854:	89 1c 24             	mov    %ebx,(%esp)
  800857:	e8 4f fc ff ff       	call   8004ab <fd_lookup>
  80085c:	89 c2                	mov    %eax,%edx
  80085e:	85 d2                	test   %edx,%edx
  800860:	78 68                	js     8008ca <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800862:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800865:	89 44 24 04          	mov    %eax,0x4(%esp)
  800869:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80086c:	8b 00                	mov    (%eax),%eax
  80086e:	89 04 24             	mov    %eax,(%esp)
  800871:	e8 8b fc ff ff       	call   800501 <dev_lookup>
  800876:	85 c0                	test   %eax,%eax
  800878:	78 50                	js     8008ca <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80087a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800881:	75 23                	jne    8008a6 <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800883:	a1 04 40 80 00       	mov    0x804004,%eax
  800888:	8b 40 48             	mov    0x48(%eax),%eax
  80088b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80088f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800893:	c7 04 24 75 21 80 00 	movl   $0x802175,(%esp)
  80089a:	e8 10 0a 00 00       	call   8012af <cprintf>
		return -E_INVAL;
  80089f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a4:	eb 24                	jmp    8008ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a9:	8b 52 0c             	mov    0xc(%edx),%edx
  8008ac:	85 d2                	test   %edx,%edx
  8008ae:	74 15                	je     8008c5 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008be:	89 04 24             	mov    %eax,(%esp)
  8008c1:	ff d2                	call   *%edx
  8008c3:	eb 05                	jmp    8008ca <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8008c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8008ca:	83 c4 24             	add    $0x24,%esp
  8008cd:	5b                   	pop    %ebx
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    

008008d0 <seek>:

int
seek(int fdnum, off_t offset)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8008d6:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8008d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	89 04 24             	mov    %eax,(%esp)
  8008e3:	e8 c3 fb ff ff       	call   8004ab <fd_lookup>
  8008e8:	85 c0                	test   %eax,%eax
  8008ea:	78 0e                	js     8008fa <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8008ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8008ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8008f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	53                   	push   %ebx
  800900:	83 ec 24             	sub    $0x24,%esp
  800903:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800906:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800909:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090d:	89 1c 24             	mov    %ebx,(%esp)
  800910:	e8 96 fb ff ff       	call   8004ab <fd_lookup>
  800915:	89 c2                	mov    %eax,%edx
  800917:	85 d2                	test   %edx,%edx
  800919:	78 61                	js     80097c <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80091b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	89 04 24             	mov    %eax,(%esp)
  80092a:	e8 d2 fb ff ff       	call   800501 <dev_lookup>
  80092f:	85 c0                	test   %eax,%eax
  800931:	78 49                	js     80097c <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800936:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80093a:	75 23                	jne    80095f <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  80093c:	a1 04 40 80 00       	mov    0x804004,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800941:	8b 40 48             	mov    0x48(%eax),%eax
  800944:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094c:	c7 04 24 38 21 80 00 	movl   $0x802138,(%esp)
  800953:	e8 57 09 00 00       	call   8012af <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  800958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80095d:	eb 1d                	jmp    80097c <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  80095f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800962:	8b 52 18             	mov    0x18(%edx),%edx
  800965:	85 d2                	test   %edx,%edx
  800967:	74 0e                	je     800977 <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800969:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80096c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800970:	89 04 24             	mov    %eax,(%esp)
  800973:	ff d2                	call   *%edx
  800975:	eb 05                	jmp    80097c <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  800977:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  80097c:	83 c4 24             	add    $0x24,%esp
  80097f:	5b                   	pop    %ebx
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	53                   	push   %ebx
  800986:	83 ec 24             	sub    $0x24,%esp
  800989:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80098c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80098f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800993:	8b 45 08             	mov    0x8(%ebp),%eax
  800996:	89 04 24             	mov    %eax,(%esp)
  800999:	e8 0d fb ff ff       	call   8004ab <fd_lookup>
  80099e:	89 c2                	mov    %eax,%edx
  8009a0:	85 d2                	test   %edx,%edx
  8009a2:	78 52                	js     8009f6 <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8009a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ae:	8b 00                	mov    (%eax),%eax
  8009b0:	89 04 24             	mov    %eax,(%esp)
  8009b3:	e8 49 fb ff ff       	call   800501 <dev_lookup>
  8009b8:	85 c0                	test   %eax,%eax
  8009ba:	78 3a                	js     8009f6 <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8009bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009bf:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8009c3:	74 2c                	je     8009f1 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8009c5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8009c8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8009cf:	00 00 00 
	stat->st_isdir = 0;
  8009d2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8009d9:	00 00 00 
	stat->st_dev = dev;
  8009dc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8009e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8009e9:	89 14 24             	mov    %edx,(%esp)
  8009ec:	ff 50 14             	call   *0x14(%eax)
  8009ef:	eb 05                	jmp    8009f6 <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8009f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8009f6:	83 c4 24             	add    $0x24,%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5d                   	pop    %ebp
  8009fb:	c3                   	ret    

008009fc <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8009fc:	55                   	push   %ebp
  8009fd:	89 e5                	mov    %esp,%ebp
  8009ff:	56                   	push   %esi
  800a00:	53                   	push   %ebx
  800a01:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a0b:	00 
  800a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0f:	89 04 24             	mov    %eax,(%esp)
  800a12:	e8 af 01 00 00       	call   800bc6 <open>
  800a17:	89 c3                	mov    %eax,%ebx
  800a19:	85 db                	test   %ebx,%ebx
  800a1b:	78 1b                	js     800a38 <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a24:	89 1c 24             	mov    %ebx,(%esp)
  800a27:	e8 56 ff ff ff       	call   800982 <fstat>
  800a2c:	89 c6                	mov    %eax,%esi
	close(fd);
  800a2e:	89 1c 24             	mov    %ebx,(%esp)
  800a31:	e8 bd fb ff ff       	call   8005f3 <close>
	return r;
  800a36:	89 f0                	mov    %esi,%eax
}
  800a38:	83 c4 10             	add    $0x10,%esp
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	56                   	push   %esi
  800a43:	53                   	push   %ebx
  800a44:	83 ec 10             	sub    $0x10,%esp
  800a47:	89 c6                	mov    %eax,%esi
  800a49:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800a4b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800a52:	75 11                	jne    800a65 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  800a54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a5b:	e8 5a 13 00 00       	call   801dba <ipc_find_env>
  800a60:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800a65:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800a6c:	00 
  800a6d:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  800a74:	00 
  800a75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a79:	a1 00 40 80 00       	mov    0x804000,%eax
  800a7e:	89 04 24             	mov    %eax,(%esp)
  800a81:	e8 ce 12 00 00       	call   801d54 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800a86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800a8d:	00 
  800a8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a99:	e8 4e 12 00 00       	call   801cec <ipc_recv>
}
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	5b                   	pop    %ebx
  800aa2:	5e                   	pop    %esi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	53                   	push   %ebx
  800aa9:	83 ec 14             	sub    $0x14,%esp
  800aac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  800ab5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	b8 05 00 00 00       	mov    $0x5,%eax
  800ac4:	e8 76 ff ff ff       	call   800a3f <fsipc>
  800ac9:	89 c2                	mov    %eax,%edx
  800acb:	85 d2                	test   %edx,%edx
  800acd:	78 2b                	js     800afa <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800acf:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800ad6:	00 
  800ad7:	89 1c 24             	mov    %ebx,(%esp)
  800ada:	e8 2c 0e 00 00       	call   80190b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800adf:	a1 80 50 80 00       	mov    0x805080,%eax
  800ae4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800aea:	a1 84 50 80 00       	mov    0x805084,%eax
  800aef:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800afa:	83 c4 14             	add    $0x14,%esp
  800afd:	5b                   	pop    %ebx
  800afe:	5d                   	pop    %ebp
  800aff:	c3                   	ret    

00800b00 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	8b 40 0c             	mov    0xc(%eax),%eax
  800b0c:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800b11:	ba 00 00 00 00       	mov    $0x0,%edx
  800b16:	b8 06 00 00 00       	mov    $0x6,%eax
  800b1b:	e8 1f ff ff ff       	call   800a3f <fsipc>
}
  800b20:	c9                   	leave  
  800b21:	c3                   	ret    

00800b22 <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	56                   	push   %esi
  800b26:	53                   	push   %ebx
  800b27:	83 ec 10             	sub    $0x10,%esp
  800b2a:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b30:	8b 40 0c             	mov    0xc(%eax),%eax
  800b33:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b38:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b43:	b8 03 00 00 00       	mov    $0x3,%eax
  800b48:	e8 f2 fe ff ff       	call   800a3f <fsipc>
  800b4d:	89 c3                	mov    %eax,%ebx
  800b4f:	85 c0                	test   %eax,%eax
  800b51:	78 6a                	js     800bbd <devfile_read+0x9b>
		return r;
	assert(r <= n);
  800b53:	39 c6                	cmp    %eax,%esi
  800b55:	73 24                	jae    800b7b <devfile_read+0x59>
  800b57:	c7 44 24 0c 92 21 80 	movl   $0x802192,0xc(%esp)
  800b5e:	00 
  800b5f:	c7 44 24 08 99 21 80 	movl   $0x802199,0x8(%esp)
  800b66:	00 
  800b67:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
  800b6e:	00 
  800b6f:	c7 04 24 ae 21 80 00 	movl   $0x8021ae,(%esp)
  800b76:	e8 3b 06 00 00       	call   8011b6 <_panic>
	assert(r <= PGSIZE);
  800b7b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b80:	7e 24                	jle    800ba6 <devfile_read+0x84>
  800b82:	c7 44 24 0c b9 21 80 	movl   $0x8021b9,0xc(%esp)
  800b89:	00 
  800b8a:	c7 44 24 08 99 21 80 	movl   $0x802199,0x8(%esp)
  800b91:	00 
  800b92:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  800b99:	00 
  800b9a:	c7 04 24 ae 21 80 00 	movl   $0x8021ae,(%esp)
  800ba1:	e8 10 06 00 00       	call   8011b6 <_panic>
	memmove(buf, &fsipcbuf, r);
  800ba6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800baa:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  800bb1:	00 
  800bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb5:	89 04 24             	mov    %eax,(%esp)
  800bb8:	e8 49 0f 00 00       	call   801b06 <memmove>
	return r;
}
  800bbd:	89 d8                	mov    %ebx,%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    

00800bc6 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	53                   	push   %ebx
  800bca:	83 ec 24             	sub    $0x24,%esp
  800bcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  800bd0:	89 1c 24             	mov    %ebx,(%esp)
  800bd3:	e8 d8 0c 00 00       	call   8018b0 <strlen>
  800bd8:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bdd:	7f 60                	jg     800c3f <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  800bdf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800be2:	89 04 24             	mov    %eax,(%esp)
  800be5:	e8 4d f8 ff ff       	call   800437 <fd_alloc>
  800bea:	89 c2                	mov    %eax,%edx
  800bec:	85 d2                	test   %edx,%edx
  800bee:	78 54                	js     800c44 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  800bf0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bf4:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  800bfb:	e8 0b 0d 00 00       	call   80190b <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c03:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0b:	b8 01 00 00 00       	mov    $0x1,%eax
  800c10:	e8 2a fe ff ff       	call   800a3f <fsipc>
  800c15:	89 c3                	mov    %eax,%ebx
  800c17:	85 c0                	test   %eax,%eax
  800c19:	79 17                	jns    800c32 <open+0x6c>
		fd_close(fd, 0);
  800c1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c22:	00 
  800c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c26:	89 04 24             	mov    %eax,(%esp)
  800c29:	e8 44 f9 ff ff       	call   800572 <fd_close>
		return r;
  800c2e:	89 d8                	mov    %ebx,%eax
  800c30:	eb 12                	jmp    800c44 <open+0x7e>
	}
	return fd2num(fd);
  800c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c35:	89 04 24             	mov    %eax,(%esp)
  800c38:	e8 d3 f7 ff ff       	call   800410 <fd2num>
  800c3d:	eb 05                	jmp    800c44 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  800c3f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
		fd_close(fd, 0);
		return r;
	}
	return fd2num(fd);
}
  800c44:	83 c4 24             	add    $0x24,%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
  800c4a:	66 90                	xchg   %ax,%ax
  800c4c:	66 90                	xchg   %ax,%ax
  800c4e:	66 90                	xchg   %ax,%ax

00800c50 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c50:	55                   	push   %ebp
  800c51:	89 e5                	mov    %esp,%ebp
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 10             	sub    $0x10,%esp
  800c58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5e:	89 04 24             	mov    %eax,(%esp)
  800c61:	e8 ba f7 ff ff       	call   800420 <fd2data>
  800c66:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c68:	c7 44 24 04 c5 21 80 	movl   $0x8021c5,0x4(%esp)
  800c6f:	00 
  800c70:	89 1c 24             	mov    %ebx,(%esp)
  800c73:	e8 93 0c 00 00       	call   80190b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c78:	8b 46 04             	mov    0x4(%esi),%eax
  800c7b:	2b 06                	sub    (%esi),%eax
  800c7d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  800c83:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c8a:	00 00 00 
	stat->st_dev = &devpipe;
  800c8d:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c94:	30 80 00 
	return 0;
}
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9c:	83 c4 10             	add    $0x10,%esp
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 14             	sub    $0x14,%esp
  800caa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800cad:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cb8:	e8 86 f5 ff ff       	call   800243 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800cbd:	89 1c 24             	mov    %ebx,(%esp)
  800cc0:	e8 5b f7 ff ff       	call   800420 <fd2data>
  800cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cd0:	e8 6e f5 ff ff       	call   800243 <sys_page_unmap>
}
  800cd5:	83 c4 14             	add    $0x14,%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	57                   	push   %edi
  800cdf:	56                   	push   %esi
  800ce0:	53                   	push   %ebx
  800ce1:	83 ec 2c             	sub    $0x2c,%esp
  800ce4:	89 c6                	mov    %eax,%esi
  800ce6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  800ce9:	a1 04 40 80 00       	mov    0x804004,%eax
  800cee:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cf1:	89 34 24             	mov    %esi,(%esp)
  800cf4:	e8 09 11 00 00       	call   801e02 <pageref>
  800cf9:	89 c7                	mov    %eax,%edi
  800cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800cfe:	89 04 24             	mov    %eax,(%esp)
  800d01:	e8 fc 10 00 00       	call   801e02 <pageref>
  800d06:	39 c7                	cmp    %eax,%edi
  800d08:	0f 94 c2             	sete   %dl
  800d0b:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  800d0e:	8b 0d 04 40 80 00    	mov    0x804004,%ecx
  800d14:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  800d17:	39 fb                	cmp    %edi,%ebx
  800d19:	74 21                	je     800d3c <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  800d1b:	84 d2                	test   %dl,%dl
  800d1d:	74 ca                	je     800ce9 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d1f:	8b 51 58             	mov    0x58(%ecx),%edx
  800d22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d26:	89 54 24 08          	mov    %edx,0x8(%esp)
  800d2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d2e:	c7 04 24 cc 21 80 00 	movl   $0x8021cc,(%esp)
  800d35:	e8 75 05 00 00       	call   8012af <cprintf>
  800d3a:	eb ad                	jmp    800ce9 <_pipeisclosed+0xe>
	}
}
  800d3c:	83 c4 2c             	add    $0x2c,%esp
  800d3f:	5b                   	pop    %ebx
  800d40:	5e                   	pop    %esi
  800d41:	5f                   	pop    %edi
  800d42:	5d                   	pop    %ebp
  800d43:	c3                   	ret    

00800d44 <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  800d44:	55                   	push   %ebp
  800d45:	89 e5                	mov    %esp,%ebp
  800d47:	57                   	push   %edi
  800d48:	56                   	push   %esi
  800d49:	53                   	push   %ebx
  800d4a:	83 ec 1c             	sub    $0x1c,%esp
  800d4d:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  800d50:	89 34 24             	mov    %esi,(%esp)
  800d53:	e8 c8 f6 ff ff       	call   800420 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800d58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5c:	74 61                	je     800dbf <devpipe_write+0x7b>
  800d5e:	89 c3                	mov    %eax,%ebx
  800d60:	bf 00 00 00 00       	mov    $0x0,%edi
  800d65:	eb 4a                	jmp    800db1 <devpipe_write+0x6d>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  800d67:	89 da                	mov    %ebx,%edx
  800d69:	89 f0                	mov    %esi,%eax
  800d6b:	e8 6b ff ff ff       	call   800cdb <_pipeisclosed>
  800d70:	85 c0                	test   %eax,%eax
  800d72:	75 54                	jne    800dc8 <devpipe_write+0x84>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  800d74:	e8 04 f4 ff ff       	call   80017d <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d79:	8b 43 04             	mov    0x4(%ebx),%eax
  800d7c:	8b 0b                	mov    (%ebx),%ecx
  800d7e:	8d 51 20             	lea    0x20(%ecx),%edx
  800d81:	39 d0                	cmp    %edx,%eax
  800d83:	73 e2                	jae    800d67 <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d88:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  800d8c:	88 4d e7             	mov    %cl,-0x19(%ebp)
  800d8f:	99                   	cltd   
  800d90:	c1 ea 1b             	shr    $0x1b,%edx
  800d93:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  800d96:	83 e1 1f             	and    $0x1f,%ecx
  800d99:	29 d1                	sub    %edx,%ecx
  800d9b:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  800d9f:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  800da3:	83 c0 01             	add    $0x1,%eax
  800da6:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800da9:	83 c7 01             	add    $0x1,%edi
  800dac:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800daf:	74 13                	je     800dc4 <devpipe_write+0x80>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800db1:	8b 43 04             	mov    0x4(%ebx),%eax
  800db4:	8b 0b                	mov    (%ebx),%ecx
  800db6:	8d 51 20             	lea    0x20(%ecx),%edx
  800db9:	39 d0                	cmp    %edx,%eax
  800dbb:	73 aa                	jae    800d67 <devpipe_write+0x23>
  800dbd:	eb c6                	jmp    800d85 <devpipe_write+0x41>
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800dbf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  800dc4:	89 f8                	mov    %edi,%eax
  800dc6:	eb 05                	jmp    800dcd <devpipe_write+0x89>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800dc8:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  800dcd:	83 c4 1c             	add    $0x1c,%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
  800ddb:	83 ec 1c             	sub    $0x1c,%esp
  800dde:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  800de1:	89 3c 24             	mov    %edi,(%esp)
  800de4:	e8 37 f6 ff ff       	call   800420 <fd2data>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ded:	74 54                	je     800e43 <devpipe_read+0x6e>
  800def:	89 c3                	mov    %eax,%ebx
  800df1:	be 00 00 00 00       	mov    $0x0,%esi
  800df6:	eb 3e                	jmp    800e36 <devpipe_read+0x61>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  800df8:	89 f0                	mov    %esi,%eax
  800dfa:	eb 55                	jmp    800e51 <devpipe_read+0x7c>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  800dfc:	89 da                	mov    %ebx,%edx
  800dfe:	89 f8                	mov    %edi,%eax
  800e00:	e8 d6 fe ff ff       	call   800cdb <_pipeisclosed>
  800e05:	85 c0                	test   %eax,%eax
  800e07:	75 43                	jne    800e4c <devpipe_read+0x77>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  800e09:	e8 6f f3 ff ff       	call   80017d <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  800e0e:	8b 03                	mov    (%ebx),%eax
  800e10:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e13:	74 e7                	je     800dfc <devpipe_read+0x27>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e15:	99                   	cltd   
  800e16:	c1 ea 1b             	shr    $0x1b,%edx
  800e19:	01 d0                	add    %edx,%eax
  800e1b:	83 e0 1f             	and    $0x1f,%eax
  800e1e:	29 d0                	sub    %edx,%eax
  800e20:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  800e2b:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e2e:	83 c6 01             	add    $0x1,%esi
  800e31:	3b 75 10             	cmp    0x10(%ebp),%esi
  800e34:	74 12                	je     800e48 <devpipe_read+0x73>
		while (p->p_rpos == p->p_wpos) {
  800e36:	8b 03                	mov    (%ebx),%eax
  800e38:	3b 43 04             	cmp    0x4(%ebx),%eax
  800e3b:	75 d8                	jne    800e15 <devpipe_read+0x40>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  800e3d:	85 f6                	test   %esi,%esi
  800e3f:	75 b7                	jne    800df8 <devpipe_read+0x23>
  800e41:	eb b9                	jmp    800dfc <devpipe_read+0x27>
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  800e43:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  800e48:	89 f0                	mov    %esi,%eax
  800e4a:	eb 05                	jmp    800e51 <devpipe_read+0x7c>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  800e4c:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  800e51:	83 c4 1c             	add    $0x1c,%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
  800e5e:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  800e61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e64:	89 04 24             	mov    %eax,(%esp)
  800e67:	e8 cb f5 ff ff       	call   800437 <fd_alloc>
  800e6c:	89 c2                	mov    %eax,%edx
  800e6e:	85 d2                	test   %edx,%edx
  800e70:	0f 88 4d 01 00 00    	js     800fc3 <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e76:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800e7d:	00 
  800e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e8c:	e8 0b f3 ff ff       	call   80019c <sys_page_alloc>
  800e91:	89 c2                	mov    %eax,%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	0f 88 28 01 00 00    	js     800fc3 <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  800e9b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e9e:	89 04 24             	mov    %eax,(%esp)
  800ea1:	e8 91 f5 ff ff       	call   800437 <fd_alloc>
  800ea6:	89 c3                	mov    %eax,%ebx
  800ea8:	85 c0                	test   %eax,%eax
  800eaa:	0f 88 fe 00 00 00    	js     800fae <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800eb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800eb7:	00 
  800eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ebb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ebf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ec6:	e8 d1 f2 ff ff       	call   80019c <sys_page_alloc>
  800ecb:	89 c3                	mov    %eax,%ebx
  800ecd:	85 c0                	test   %eax,%eax
  800ecf:	0f 88 d9 00 00 00    	js     800fae <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  800ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed8:	89 04 24             	mov    %eax,(%esp)
  800edb:	e8 40 f5 ff ff       	call   800420 <fd2data>
  800ee0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ee2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  800ee9:	00 
  800eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ef5:	e8 a2 f2 ff ff       	call   80019c <sys_page_alloc>
  800efa:	89 c3                	mov    %eax,%ebx
  800efc:	85 c0                	test   %eax,%eax
  800efe:	0f 88 97 00 00 00    	js     800f9b <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f07:	89 04 24             	mov    %eax,(%esp)
  800f0a:	e8 11 f5 ff ff       	call   800420 <fd2data>
  800f0f:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  800f16:	00 
  800f17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800f1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800f22:	00 
  800f23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f2e:	e8 bd f2 ff ff       	call   8001f0 <sys_page_map>
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	85 c0                	test   %eax,%eax
  800f37:	78 52                	js     800f8b <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  800f39:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f42:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  800f4e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f57:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f5c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  800f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f66:	89 04 24             	mov    %eax,(%esp)
  800f69:	e8 a2 f4 ff ff       	call   800410 <fd2num>
  800f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f71:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f76:	89 04 24             	mov    %eax,(%esp)
  800f79:	e8 92 f4 ff ff       	call   800410 <fd2num>
  800f7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f81:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f84:	b8 00 00 00 00       	mov    $0x0,%eax
  800f89:	eb 38                	jmp    800fc3 <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  800f8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f96:	e8 a8 f2 ff ff       	call   800243 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  800f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fa9:	e8 95 f2 ff ff       	call   800243 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  800fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fbc:	e8 82 f2 ff ff       	call   800243 <sys_page_unmap>
  800fc1:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  800fc3:	83 c4 30             	add    $0x30,%esp
  800fc6:	5b                   	pop    %ebx
  800fc7:	5e                   	pop    %esi
  800fc8:	5d                   	pop    %ebp
  800fc9:	c3                   	ret    

00800fca <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	89 04 24             	mov    %eax,(%esp)
  800fdd:	e8 c9 f4 ff ff       	call   8004ab <fd_lookup>
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	85 d2                	test   %edx,%edx
  800fe6:	78 15                	js     800ffd <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  800fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800feb:	89 04 24             	mov    %eax,(%esp)
  800fee:	e8 2d f4 ff ff       	call   800420 <fd2data>
	return _pipeisclosed(fd, p);
  800ff3:	89 c2                	mov    %eax,%edx
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	e8 de fc ff ff       	call   800cdb <_pipeisclosed>
}
  800ffd:	c9                   	leave  
  800ffe:	c3                   	ret    
  800fff:	90                   	nop

00801000 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801003:	b8 00 00 00 00       	mov    $0x0,%eax
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801010:	c7 44 24 04 e4 21 80 	movl   $0x8021e4,0x4(%esp)
  801017:	00 
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	89 04 24             	mov    %eax,(%esp)
  80101e:	e8 e8 08 00 00       	call   80190b <strcpy>
	return 0;
}
  801023:	b8 00 00 00 00       	mov    $0x0,%eax
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801036:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103a:	74 4a                	je     801086 <devcons_write+0x5c>
  80103c:	b8 00 00 00 00       	mov    $0x0,%eax
  801041:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801046:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80104c:	8b 75 10             	mov    0x10(%ebp),%esi
  80104f:	29 c6                	sub    %eax,%esi
		if (m > sizeof(buf) - 1)
  801051:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801054:	ba 7f 00 00 00       	mov    $0x7f,%edx
  801059:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80105c:	89 74 24 08          	mov    %esi,0x8(%esp)
  801060:	03 45 0c             	add    0xc(%ebp),%eax
  801063:	89 44 24 04          	mov    %eax,0x4(%esp)
  801067:	89 3c 24             	mov    %edi,(%esp)
  80106a:	e8 97 0a 00 00       	call   801b06 <memmove>
		sys_cputs(buf, m);
  80106f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801073:	89 3c 24             	mov    %edi,(%esp)
  801076:	e8 54 f0 ff ff       	call   8000cf <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80107b:	01 f3                	add    %esi,%ebx
  80107d:	89 d8                	mov    %ebx,%eax
  80107f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801082:	72 c8                	jb     80104c <devcons_write+0x22>
  801084:	eb 05                	jmp    80108b <devcons_write+0x61>
  801086:	bb 00 00 00 00       	mov    $0x0,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80108b:	89 d8                	mov    %ebx,%eax
  80108d:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801093:	5b                   	pop    %ebx
  801094:	5e                   	pop    %esi
  801095:	5f                   	pop    %edi
  801096:	5d                   	pop    %ebp
  801097:	c3                   	ret    

00801098 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801098:	55                   	push   %ebp
  801099:	89 e5                	mov    %esp,%ebp
  80109b:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80109e:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8010a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a7:	75 07                	jne    8010b0 <devcons_read+0x18>
  8010a9:	eb 28                	jmp    8010d3 <devcons_read+0x3b>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8010ab:	e8 cd f0 ff ff       	call   80017d <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8010b0:	e8 38 f0 ff ff       	call   8000ed <sys_cgetc>
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	74 f2                	je     8010ab <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 16                	js     8010d3 <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8010bd:	83 f8 04             	cmp    $0x4,%eax
  8010c0:	74 0c                	je     8010ce <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8010c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c5:	88 02                	mov    %al,(%edx)
	return 1;
  8010c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010cc:	eb 05                	jmp    8010d3 <devcons_read+0x3b>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8010ce:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8010e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010e8:	00 
  8010e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8010ec:	89 04 24             	mov    %eax,(%esp)
  8010ef:	e8 db ef ff ff       	call   8000cf <sys_cputs>
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <getchar>:

int
getchar(void)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8010fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801103:	00 
  801104:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801107:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801112:	e8 3f f6 ff ff       	call   800756 <read>
	if (r < 0)
  801117:	85 c0                	test   %eax,%eax
  801119:	78 0f                	js     80112a <getchar+0x34>
		return r;
	if (r < 1)
  80111b:	85 c0                	test   %eax,%eax
  80111d:	7e 06                	jle    801125 <getchar+0x2f>
		return -E_EOF;
	return c;
  80111f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  801123:	eb 05                	jmp    80112a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  801125:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80112a:	c9                   	leave  
  80112b:	c3                   	ret    

0080112c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801132:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801135:	89 44 24 04          	mov    %eax,0x4(%esp)
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	89 04 24             	mov    %eax,(%esp)
  80113f:	e8 67 f3 ff ff       	call   8004ab <fd_lookup>
  801144:	85 c0                	test   %eax,%eax
  801146:	78 11                	js     801159 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801148:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801151:	39 10                	cmp    %edx,(%eax)
  801153:	0f 94 c0             	sete   %al
  801156:	0f b6 c0             	movzbl %al,%eax
}
  801159:	c9                   	leave  
  80115a:	c3                   	ret    

0080115b <opencons>:

int
opencons(void)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
  80115e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801161:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801164:	89 04 24             	mov    %eax,(%esp)
  801167:	e8 cb f2 ff ff       	call   800437 <fd_alloc>
		return r;
  80116c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80116e:	85 c0                	test   %eax,%eax
  801170:	78 40                	js     8011b2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801172:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801179:	00 
  80117a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801181:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801188:	e8 0f f0 ff ff       	call   80019c <sys_page_alloc>
		return r;
  80118d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80118f:	85 c0                	test   %eax,%eax
  801191:	78 1f                	js     8011b2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801193:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80119e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8011a8:	89 04 24             	mov    %eax,(%esp)
  8011ab:	e8 60 f2 ff ff       	call   800410 <fd2num>
  8011b0:	89 c2                	mov    %eax,%edx
}
  8011b2:	89 d0                	mov    %edx,%eax
  8011b4:	c9                   	leave  
  8011b5:	c3                   	ret    

008011b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8011b6:	55                   	push   %ebp
  8011b7:	89 e5                	mov    %esp,%ebp
  8011b9:	56                   	push   %esi
  8011ba:	53                   	push   %ebx
  8011bb:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8011be:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8011c1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8011c7:	e8 92 ef ff ff       	call   80015e <sys_getenvid>
  8011cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011cf:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8011da:	89 74 24 08          	mov    %esi,0x8(%esp)
  8011de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e2:	c7 04 24 f0 21 80 00 	movl   $0x8021f0,(%esp)
  8011e9:	e8 c1 00 00 00       	call   8012af <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8011ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	89 04 24             	mov    %eax,(%esp)
  8011f8:	e8 51 00 00 00       	call   80124e <vcprintf>
	cprintf("\n");
  8011fd:	c7 04 24 dd 21 80 00 	movl   $0x8021dd,(%esp)
  801204:	e8 a6 00 00 00       	call   8012af <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801209:	cc                   	int3   
  80120a:	eb fd                	jmp    801209 <_panic+0x53>

0080120c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	53                   	push   %ebx
  801210:	83 ec 14             	sub    $0x14,%esp
  801213:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801216:	8b 13                	mov    (%ebx),%edx
  801218:	8d 42 01             	lea    0x1(%edx),%eax
  80121b:	89 03                	mov    %eax,(%ebx)
  80121d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801220:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801224:	3d ff 00 00 00       	cmp    $0xff,%eax
  801229:	75 19                	jne    801244 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80122b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801232:	00 
  801233:	8d 43 08             	lea    0x8(%ebx),%eax
  801236:	89 04 24             	mov    %eax,(%esp)
  801239:	e8 91 ee ff ff       	call   8000cf <sys_cputs>
		b->idx = 0;
  80123e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801244:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801248:	83 c4 14             	add    $0x14,%esp
  80124b:	5b                   	pop    %ebx
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    

0080124e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801257:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80125e:	00 00 00 
	b.cnt = 0;
  801261:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801268:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80126b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	89 44 24 08          	mov    %eax,0x8(%esp)
  801279:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80127f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801283:	c7 04 24 0c 12 80 00 	movl   $0x80120c,(%esp)
  80128a:	e8 b5 01 00 00       	call   801444 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80128f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801295:	89 44 24 04          	mov    %eax,0x4(%esp)
  801299:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80129f:	89 04 24             	mov    %eax,(%esp)
  8012a2:	e8 28 ee ff ff       	call   8000cf <sys_cputs>

	return b.cnt;
}
  8012a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8012b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8012b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	89 04 24             	mov    %eax,(%esp)
  8012c2:	e8 87 ff ff ff       	call   80124e <vcprintf>
	va_end(ap);

	return cnt;
}
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    
  8012c9:	66 90                	xchg   %ax,%ax
  8012cb:	66 90                	xchg   %ax,%ax
  8012cd:	66 90                	xchg   %ax,%ax
  8012cf:	90                   	nop

008012d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	57                   	push   %edi
  8012d4:	56                   	push   %esi
  8012d5:	53                   	push   %ebx
  8012d6:	83 ec 3c             	sub    $0x3c,%esp
  8012d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8012dc:	89 d7                	mov    %edx,%edi
  8012de:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012e4:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012e7:	89 75 d4             	mov    %esi,-0x2c(%ebp)
  8012ea:	8b 45 10             	mov    0x10(%ebp),%eax
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8012ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8012f5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8012f8:	39 f1                	cmp    %esi,%ecx
  8012fa:	72 14                	jb     801310 <printnum+0x40>
  8012fc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8012ff:	76 0f                	jbe    801310 <printnum+0x40>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801301:	8b 45 14             	mov    0x14(%ebp),%eax
  801304:	8d 70 ff             	lea    -0x1(%eax),%esi
  801307:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80130a:	85 f6                	test   %esi,%esi
  80130c:	7f 60                	jg     80136e <printnum+0x9e>
  80130e:	eb 72                	jmp    801382 <printnum+0xb2>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801310:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801313:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801317:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80131a:	8d 51 ff             	lea    -0x1(%ecx),%edx
  80131d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801321:	89 44 24 08          	mov    %eax,0x8(%esp)
  801325:	8b 44 24 08          	mov    0x8(%esp),%eax
  801329:	8b 54 24 0c          	mov    0xc(%esp),%edx
  80132d:	89 c3                	mov    %eax,%ebx
  80132f:	89 d6                	mov    %edx,%esi
  801331:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801334:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801337:	89 54 24 08          	mov    %edx,0x8(%esp)
  80133b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80133f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801342:	89 04 24             	mov    %eax,(%esp)
  801345:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	e8 ef 0a 00 00       	call   801e40 <__udivdi3>
  801351:	89 d9                	mov    %ebx,%ecx
  801353:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801357:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80135b:	89 04 24             	mov    %eax,(%esp)
  80135e:	89 54 24 04          	mov    %edx,0x4(%esp)
  801362:	89 fa                	mov    %edi,%edx
  801364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801367:	e8 64 ff ff ff       	call   8012d0 <printnum>
  80136c:	eb 14                	jmp    801382 <printnum+0xb2>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80136e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801372:	8b 45 18             	mov    0x18(%ebp),%eax
  801375:	89 04 24             	mov    %eax,(%esp)
  801378:	ff d3                	call   *%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80137a:	83 ee 01             	sub    $0x1,%esi
  80137d:	75 ef                	jne    80136e <printnum+0x9e>
  80137f:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801382:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801386:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80138a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80138d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801390:	89 44 24 08          	mov    %eax,0x8(%esp)
  801394:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801398:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80139b:	89 04 24             	mov    %eax,(%esp)
  80139e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8013a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a5:	e8 c6 0b 00 00       	call   801f70 <__umoddi3>
  8013aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8013ae:	0f be 80 13 22 80 00 	movsbl 0x802213(%eax),%eax
  8013b5:	89 04 24             	mov    %eax,(%esp)
  8013b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bb:	ff d0                	call   *%eax
}
  8013bd:	83 c4 3c             	add    $0x3c,%esp
  8013c0:	5b                   	pop    %ebx
  8013c1:	5e                   	pop    %esi
  8013c2:	5f                   	pop    %edi
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8013c8:	83 fa 01             	cmp    $0x1,%edx
  8013cb:	7e 0e                	jle    8013db <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8013cd:	8b 10                	mov    (%eax),%edx
  8013cf:	8d 4a 08             	lea    0x8(%edx),%ecx
  8013d2:	89 08                	mov    %ecx,(%eax)
  8013d4:	8b 02                	mov    (%edx),%eax
  8013d6:	8b 52 04             	mov    0x4(%edx),%edx
  8013d9:	eb 22                	jmp    8013fd <getuint+0x38>
	else if (lflag)
  8013db:	85 d2                	test   %edx,%edx
  8013dd:	74 10                	je     8013ef <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8013df:	8b 10                	mov    (%eax),%edx
  8013e1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013e4:	89 08                	mov    %ecx,(%eax)
  8013e6:	8b 02                	mov    (%edx),%eax
  8013e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ed:	eb 0e                	jmp    8013fd <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8013ef:	8b 10                	mov    (%eax),%edx
  8013f1:	8d 4a 04             	lea    0x4(%edx),%ecx
  8013f4:	89 08                	mov    %ecx,(%eax)
  8013f6:	8b 02                	mov    (%edx),%eax
  8013f8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8013fd:	5d                   	pop    %ebp
  8013fe:	c3                   	ret    

008013ff <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801405:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801409:	8b 10                	mov    (%eax),%edx
  80140b:	3b 50 04             	cmp    0x4(%eax),%edx
  80140e:	73 0a                	jae    80141a <sprintputch+0x1b>
		*b->buf++ = ch;
  801410:	8d 4a 01             	lea    0x1(%edx),%ecx
  801413:	89 08                	mov    %ecx,(%eax)
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	88 02                	mov    %al,(%edx)
}
  80141a:	5d                   	pop    %ebp
  80141b:	c3                   	ret    

0080141c <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801422:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801425:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	89 44 24 04          	mov    %eax,0x4(%esp)
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	89 04 24             	mov    %eax,(%esp)
  80143d:	e8 02 00 00 00       	call   801444 <vprintfmt>
	va_end(ap);
}
  801442:	c9                   	leave  
  801443:	c3                   	ret    

00801444 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801444:	55                   	push   %ebp
  801445:	89 e5                	mov    %esp,%ebp
  801447:	57                   	push   %edi
  801448:	56                   	push   %esi
  801449:	53                   	push   %ebx
  80144a:	83 ec 3c             	sub    $0x3c,%esp
  80144d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801450:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801453:	eb 18                	jmp    80146d <vprintfmt+0x29>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801455:	85 c0                	test   %eax,%eax
  801457:	0f 84 c3 03 00 00    	je     801820 <vprintfmt+0x3dc>
				return;
			putch(ch, putdat);
  80145d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801461:	89 04 24             	mov    %eax,(%esp)
  801464:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801467:	89 f3                	mov    %esi,%ebx
  801469:	eb 02                	jmp    80146d <vprintfmt+0x29>
			break;

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
			for (fmt--; fmt[-1] != '%'; fmt--)
  80146b:	89 f3                	mov    %esi,%ebx
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80146d:	8d 73 01             	lea    0x1(%ebx),%esi
  801470:	0f b6 03             	movzbl (%ebx),%eax
  801473:	83 f8 25             	cmp    $0x25,%eax
  801476:	75 dd                	jne    801455 <vprintfmt+0x11>
  801478:	c6 45 e3 20          	movb   $0x20,-0x1d(%ebp)
  80147c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801483:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  80148a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801491:	ba 00 00 00 00       	mov    $0x0,%edx
  801496:	eb 1d                	jmp    8014b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801498:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  80149a:	c6 45 e3 2d          	movb   $0x2d,-0x1d(%ebp)
  80149e:	eb 15                	jmp    8014b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014a0:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8014a2:	c6 45 e3 30          	movb   $0x30,-0x1d(%ebp)
  8014a6:	eb 0d                	jmp    8014b5 <vprintfmt+0x71>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8014a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8014ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8014ae:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014b5:	8d 5e 01             	lea    0x1(%esi),%ebx
  8014b8:	0f b6 06             	movzbl (%esi),%eax
  8014bb:	0f b6 c8             	movzbl %al,%ecx
  8014be:	83 e8 23             	sub    $0x23,%eax
  8014c1:	3c 55                	cmp    $0x55,%al
  8014c3:	0f 87 2f 03 00 00    	ja     8017f8 <vprintfmt+0x3b4>
  8014c9:	0f b6 c0             	movzbl %al,%eax
  8014cc:	ff 24 85 60 23 80 00 	jmp    *0x802360(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8014d3:	8d 41 d0             	lea    -0x30(%ecx),%eax
  8014d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
				ch = *fmt;
  8014d9:	0f be 46 01          	movsbl 0x1(%esi),%eax
				if (ch < '0' || ch > '9')
  8014dd:	8d 48 d0             	lea    -0x30(%eax),%ecx
  8014e0:	83 f9 09             	cmp    $0x9,%ecx
  8014e3:	77 50                	ja     801535 <vprintfmt+0xf1>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8014e5:	89 de                	mov    %ebx,%esi
  8014e7:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8014ea:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
  8014ed:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8014f0:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8014f4:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8014f7:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8014fa:	83 fb 09             	cmp    $0x9,%ebx
  8014fd:	76 eb                	jbe    8014ea <vprintfmt+0xa6>
  8014ff:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801502:	eb 33                	jmp    801537 <vprintfmt+0xf3>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801504:	8b 45 14             	mov    0x14(%ebp),%eax
  801507:	8d 48 04             	lea    0x4(%eax),%ecx
  80150a:	89 4d 14             	mov    %ecx,0x14(%ebp)
  80150d:	8b 00                	mov    (%eax),%eax
  80150f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801512:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  801514:	eb 21                	jmp    801537 <vprintfmt+0xf3>
  801516:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801519:	85 c9                	test   %ecx,%ecx
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	0f 49 c1             	cmovns %ecx,%eax
  801523:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801526:	89 de                	mov    %ebx,%esi
  801528:	eb 8b                	jmp    8014b5 <vprintfmt+0x71>
  80152a:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  80152c:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801533:	eb 80                	jmp    8014b5 <vprintfmt+0x71>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801535:	89 de                	mov    %ebx,%esi
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801537:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80153b:	0f 89 74 ff ff ff    	jns    8014b5 <vprintfmt+0x71>
  801541:	e9 62 ff ff ff       	jmp    8014a8 <vprintfmt+0x64>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801546:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801549:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80154b:	e9 65 ff ff ff       	jmp    8014b5 <vprintfmt+0x71>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801550:	8b 45 14             	mov    0x14(%ebp),%eax
  801553:	8d 50 04             	lea    0x4(%eax),%edx
  801556:	89 55 14             	mov    %edx,0x14(%ebp)
  801559:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80155d:	8b 00                	mov    (%eax),%eax
  80155f:	89 04 24             	mov    %eax,(%esp)
  801562:	ff 55 08             	call   *0x8(%ebp)
			break;
  801565:	e9 03 ff ff ff       	jmp    80146d <vprintfmt+0x29>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8d 50 04             	lea    0x4(%eax),%edx
  801570:	89 55 14             	mov    %edx,0x14(%ebp)
  801573:	8b 00                	mov    (%eax),%eax
  801575:	99                   	cltd   
  801576:	31 d0                	xor    %edx,%eax
  801578:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80157a:	83 f8 0f             	cmp    $0xf,%eax
  80157d:	7f 0b                	jg     80158a <vprintfmt+0x146>
  80157f:	8b 14 85 c0 24 80 00 	mov    0x8024c0(,%eax,4),%edx
  801586:	85 d2                	test   %edx,%edx
  801588:	75 20                	jne    8015aa <vprintfmt+0x166>
				printfmt(putch, putdat, "error %d", err);
  80158a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80158e:	c7 44 24 08 2b 22 80 	movl   $0x80222b,0x8(%esp)
  801595:	00 
  801596:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80159a:	8b 45 08             	mov    0x8(%ebp),%eax
  80159d:	89 04 24             	mov    %eax,(%esp)
  8015a0:	e8 77 fe ff ff       	call   80141c <printfmt>
  8015a5:	e9 c3 fe ff ff       	jmp    80146d <vprintfmt+0x29>
			else
				printfmt(putch, putdat, "%s", p);
  8015aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8015ae:	c7 44 24 08 ab 21 80 	movl   $0x8021ab,0x8(%esp)
  8015b5:	00 
  8015b6:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8015ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bd:	89 04 24             	mov    %eax,(%esp)
  8015c0:	e8 57 fe ff ff       	call   80141c <printfmt>
  8015c5:	e9 a3 fe ff ff       	jmp    80146d <vprintfmt+0x29>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8015ca:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8015cd:	8b 75 e4             	mov    -0x1c(%ebp),%esi
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	8d 50 04             	lea    0x4(%eax),%edx
  8015d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8015d9:	8b 00                	mov    (%eax),%eax
				p = "(null)";
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	ba 24 22 80 00       	mov    $0x802224,%edx
  8015e2:	0f 45 d0             	cmovne %eax,%edx
  8015e5:	89 55 d0             	mov    %edx,-0x30(%ebp)
			if (width > 0 && padc != '-')
  8015e8:	80 7d e3 2d          	cmpb   $0x2d,-0x1d(%ebp)
  8015ec:	74 04                	je     8015f2 <vprintfmt+0x1ae>
  8015ee:	85 f6                	test   %esi,%esi
  8015f0:	7f 19                	jg     80160b <vprintfmt+0x1c7>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8015f2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8015f5:	8d 70 01             	lea    0x1(%eax),%esi
  8015f8:	0f b6 10             	movzbl (%eax),%edx
  8015fb:	0f be c2             	movsbl %dl,%eax
  8015fe:	85 c0                	test   %eax,%eax
  801600:	0f 85 95 00 00 00    	jne    80169b <vprintfmt+0x257>
  801606:	e9 85 00 00 00       	jmp    801690 <vprintfmt+0x24c>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80160b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80160f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801612:	89 04 24             	mov    %eax,(%esp)
  801615:	e8 b8 02 00 00       	call   8018d2 <strnlen>
  80161a:	29 c6                	sub    %eax,%esi
  80161c:	89 f0                	mov    %esi,%eax
  80161e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801621:	85 f6                	test   %esi,%esi
  801623:	7e cd                	jle    8015f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
  801625:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  801629:	89 5d 10             	mov    %ebx,0x10(%ebp)
  80162c:	89 c3                	mov    %eax,%ebx
  80162e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801632:	89 34 24             	mov    %esi,(%esp)
  801635:	ff 55 08             	call   *0x8(%ebp)
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801638:	83 eb 01             	sub    $0x1,%ebx
  80163b:	75 f1                	jne    80162e <vprintfmt+0x1ea>
  80163d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801640:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801643:	eb ad                	jmp    8015f2 <vprintfmt+0x1ae>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801649:	74 1e                	je     801669 <vprintfmt+0x225>
  80164b:	0f be d2             	movsbl %dl,%edx
  80164e:	83 ea 20             	sub    $0x20,%edx
  801651:	83 fa 5e             	cmp    $0x5e,%edx
  801654:	76 13                	jbe    801669 <vprintfmt+0x225>
					putch('?', putdat);
  801656:	8b 45 0c             	mov    0xc(%ebp),%eax
  801659:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165d:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801664:	ff 55 08             	call   *0x8(%ebp)
  801667:	eb 0d                	jmp    801676 <vprintfmt+0x232>
				else
					putch(ch, putdat);
  801669:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80166c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801670:	89 04 24             	mov    %eax,(%esp)
  801673:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801676:	83 ef 01             	sub    $0x1,%edi
  801679:	83 c6 01             	add    $0x1,%esi
  80167c:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  801680:	0f be c2             	movsbl %dl,%eax
  801683:	85 c0                	test   %eax,%eax
  801685:	75 20                	jne    8016a7 <vprintfmt+0x263>
  801687:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  80168a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80168d:	8b 5d 10             	mov    0x10(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801690:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801694:	7f 25                	jg     8016bb <vprintfmt+0x277>
  801696:	e9 d2 fd ff ff       	jmp    80146d <vprintfmt+0x29>
  80169b:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80169e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8016a1:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016a4:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8016a7:	85 db                	test   %ebx,%ebx
  8016a9:	78 9a                	js     801645 <vprintfmt+0x201>
  8016ab:	83 eb 01             	sub    $0x1,%ebx
  8016ae:	79 95                	jns    801645 <vprintfmt+0x201>
  8016b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  8016b3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8016b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016b9:	eb d5                	jmp    801690 <vprintfmt+0x24c>
  8016bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8016be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8016c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8016c4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8016cf:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8016d1:	83 eb 01             	sub    $0x1,%ebx
  8016d4:	75 ee                	jne    8016c4 <vprintfmt+0x280>
  8016d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016d9:	e9 8f fd ff ff       	jmp    80146d <vprintfmt+0x29>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8016de:	83 fa 01             	cmp    $0x1,%edx
  8016e1:	7e 16                	jle    8016f9 <vprintfmt+0x2b5>
		return va_arg(*ap, long long);
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8d 50 08             	lea    0x8(%eax),%edx
  8016e9:	89 55 14             	mov    %edx,0x14(%ebp)
  8016ec:	8b 50 04             	mov    0x4(%eax),%edx
  8016ef:	8b 00                	mov    (%eax),%eax
  8016f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016f4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8016f7:	eb 32                	jmp    80172b <vprintfmt+0x2e7>
	else if (lflag)
  8016f9:	85 d2                	test   %edx,%edx
  8016fb:	74 18                	je     801715 <vprintfmt+0x2d1>
		return va_arg(*ap, long);
  8016fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801700:	8d 50 04             	lea    0x4(%eax),%edx
  801703:	89 55 14             	mov    %edx,0x14(%ebp)
  801706:	8b 30                	mov    (%eax),%esi
  801708:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80170b:	89 f0                	mov    %esi,%eax
  80170d:	c1 f8 1f             	sar    $0x1f,%eax
  801710:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801713:	eb 16                	jmp    80172b <vprintfmt+0x2e7>
	else
		return va_arg(*ap, int);
  801715:	8b 45 14             	mov    0x14(%ebp),%eax
  801718:	8d 50 04             	lea    0x4(%eax),%edx
  80171b:	89 55 14             	mov    %edx,0x14(%ebp)
  80171e:	8b 30                	mov    (%eax),%esi
  801720:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801723:	89 f0                	mov    %esi,%eax
  801725:	c1 f8 1f             	sar    $0x1f,%eax
  801728:	89 45 dc             	mov    %eax,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80172b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80172e:	8b 55 dc             	mov    -0x24(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  801731:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  801736:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80173a:	0f 89 80 00 00 00    	jns    8017c0 <vprintfmt+0x37c>
				putch('-', putdat);
  801740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801744:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80174b:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  80174e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801751:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801754:	f7 d8                	neg    %eax
  801756:	83 d2 00             	adc    $0x0,%edx
  801759:	f7 da                	neg    %edx
			}
			base = 10;
  80175b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801760:	eb 5e                	jmp    8017c0 <vprintfmt+0x37c>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801762:	8d 45 14             	lea    0x14(%ebp),%eax
  801765:	e8 5b fc ff ff       	call   8013c5 <getuint>
			base = 10;
  80176a:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  80176f:	eb 4f                	jmp    8017c0 <vprintfmt+0x37c>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			num = getuint(&ap, lflag);
  801771:	8d 45 14             	lea    0x14(%ebp),%eax
  801774:	e8 4c fc ff ff       	call   8013c5 <getuint>
			base = 8;
  801779:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  80177e:	eb 40                	jmp    8017c0 <vprintfmt+0x37c>

		// pointer
		case 'p':
			putch('0', putdat);
  801780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801784:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80178b:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  80178e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801792:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801799:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	8d 50 04             	lea    0x4(%eax),%edx
  8017a2:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8017a5:	8b 00                	mov    (%eax),%eax
  8017a7:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8017ac:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8017b1:	eb 0d                	jmp    8017c0 <vprintfmt+0x37c>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8017b3:	8d 45 14             	lea    0x14(%ebp),%eax
  8017b6:	e8 0a fc ff ff       	call   8013c5 <getuint>
			base = 16;
  8017bb:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8017c0:	0f be 75 e3          	movsbl -0x1d(%ebp),%esi
  8017c4:	89 74 24 10          	mov    %esi,0x10(%esp)
  8017c8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8017cb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d3:	89 04 24             	mov    %eax,(%esp)
  8017d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017da:	89 fa                	mov    %edi,%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	e8 ec fa ff ff       	call   8012d0 <printnum>
			break;
  8017e4:	e9 84 fc ff ff       	jmp    80146d <vprintfmt+0x29>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8017e9:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017ed:	89 0c 24             	mov    %ecx,(%esp)
  8017f0:	ff 55 08             	call   *0x8(%ebp)
			break;
  8017f3:	e9 75 fc ff ff       	jmp    80146d <vprintfmt+0x29>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8017f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8017fc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801803:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  801806:	80 7e ff 25          	cmpb   $0x25,-0x1(%esi)
  80180a:	0f 84 5b fc ff ff    	je     80146b <vprintfmt+0x27>
  801810:	89 f3                	mov    %esi,%ebx
  801812:	83 eb 01             	sub    $0x1,%ebx
  801815:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  801819:	75 f7                	jne    801812 <vprintfmt+0x3ce>
  80181b:	e9 4d fc ff ff       	jmp    80146d <vprintfmt+0x29>
				/* do nothing */;
			break;
		}
	}
}
  801820:	83 c4 3c             	add    $0x3c,%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	83 ec 28             	sub    $0x28,%esp
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801834:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801837:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80183b:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80183e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801845:	85 c0                	test   %eax,%eax
  801847:	74 30                	je     801879 <vsnprintf+0x51>
  801849:	85 d2                	test   %edx,%edx
  80184b:	7e 2c                	jle    801879 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80184d:	8b 45 14             	mov    0x14(%ebp),%eax
  801850:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801854:	8b 45 10             	mov    0x10(%ebp),%eax
  801857:	89 44 24 08          	mov    %eax,0x8(%esp)
  80185b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80185e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801862:	c7 04 24 ff 13 80 00 	movl   $0x8013ff,(%esp)
  801869:	e8 d6 fb ff ff       	call   801444 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80186e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801871:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801877:	eb 05                	jmp    80187e <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  801879:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801886:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801889:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80188d:	8b 45 10             	mov    0x10(%ebp),%eax
  801890:	89 44 24 08          	mov    %eax,0x8(%esp)
  801894:	8b 45 0c             	mov    0xc(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 82 ff ff ff       	call   801828 <vsnprintf>
	va_end(ap);

	return rc;
}
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    
  8018a8:	66 90                	xchg   %ax,%ax
  8018aa:	66 90                	xchg   %ax,%ax
  8018ac:	66 90                	xchg   %ax,%ax
  8018ae:	66 90                	xchg   %ax,%ax

008018b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8018b6:	80 3a 00             	cmpb   $0x0,(%edx)
  8018b9:	74 10                	je     8018cb <strlen+0x1b>
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8018c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8018c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8018c7:	75 f7                	jne    8018c0 <strlen+0x10>
  8018c9:	eb 05                	jmp    8018d0 <strlen+0x20>
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8018d0:	5d                   	pop    %ebp
  8018d1:	c3                   	ret    

008018d2 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	53                   	push   %ebx
  8018d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8018d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018dc:	85 c9                	test   %ecx,%ecx
  8018de:	74 1c                	je     8018fc <strnlen+0x2a>
  8018e0:	80 3b 00             	cmpb   $0x0,(%ebx)
  8018e3:	74 1e                	je     801903 <strnlen+0x31>
  8018e5:	ba 01 00 00 00       	mov    $0x1,%edx
		n++;
  8018ea:	89 d0                	mov    %edx,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8018ec:	39 ca                	cmp    %ecx,%edx
  8018ee:	74 18                	je     801908 <strnlen+0x36>
  8018f0:	83 c2 01             	add    $0x1,%edx
  8018f3:	80 7c 13 ff 00       	cmpb   $0x0,-0x1(%ebx,%edx,1)
  8018f8:	75 f0                	jne    8018ea <strnlen+0x18>
  8018fa:	eb 0c                	jmp    801908 <strnlen+0x36>
  8018fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801901:	eb 05                	jmp    801908 <strnlen+0x36>
  801903:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801908:	5b                   	pop    %ebx
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	53                   	push   %ebx
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801915:	89 c2                	mov    %eax,%edx
  801917:	83 c2 01             	add    $0x1,%edx
  80191a:	83 c1 01             	add    $0x1,%ecx
  80191d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  801921:	88 5a ff             	mov    %bl,-0x1(%edx)
  801924:	84 db                	test   %bl,%bl
  801926:	75 ef                	jne    801917 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801928:	5b                   	pop    %ebx
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	83 ec 08             	sub    $0x8,%esp
  801932:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801935:	89 1c 24             	mov    %ebx,(%esp)
  801938:	e8 73 ff ff ff       	call   8018b0 <strlen>
	strcpy(dst + len, src);
  80193d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801940:	89 54 24 04          	mov    %edx,0x4(%esp)
  801944:	01 d8                	add    %ebx,%eax
  801946:	89 04 24             	mov    %eax,(%esp)
  801949:	e8 bd ff ff ff       	call   80190b <strcpy>
	return dst;
}
  80194e:	89 d8                	mov    %ebx,%eax
  801950:	83 c4 08             	add    $0x8,%esp
  801953:	5b                   	pop    %ebx
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	8b 75 08             	mov    0x8(%ebp),%esi
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 5d 10             	mov    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801964:	85 db                	test   %ebx,%ebx
  801966:	74 17                	je     80197f <strncpy+0x29>
  801968:	01 f3                	add    %esi,%ebx
  80196a:	89 f1                	mov    %esi,%ecx
		*dst++ = *src;
  80196c:	83 c1 01             	add    $0x1,%ecx
  80196f:	0f b6 02             	movzbl (%edx),%eax
  801972:	88 41 ff             	mov    %al,-0x1(%ecx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801975:	80 3a 01             	cmpb   $0x1,(%edx)
  801978:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80197b:	39 d9                	cmp    %ebx,%ecx
  80197d:	75 ed                	jne    80196c <strncpy+0x16>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  80197f:	89 f0                	mov    %esi,%eax
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	57                   	push   %edi
  801989:	56                   	push   %esi
  80198a:	53                   	push   %ebx
  80198b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80198e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801991:	8b 75 10             	mov    0x10(%ebp),%esi
  801994:	89 f8                	mov    %edi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801996:	85 f6                	test   %esi,%esi
  801998:	74 34                	je     8019ce <strlcpy+0x49>
		while (--size > 0 && *src != '\0')
  80199a:	83 fe 01             	cmp    $0x1,%esi
  80199d:	74 26                	je     8019c5 <strlcpy+0x40>
  80199f:	0f b6 0b             	movzbl (%ebx),%ecx
  8019a2:	84 c9                	test   %cl,%cl
  8019a4:	74 23                	je     8019c9 <strlcpy+0x44>
  8019a6:	83 ee 02             	sub    $0x2,%esi
  8019a9:	ba 00 00 00 00       	mov    $0x0,%edx
			*dst++ = *src++;
  8019ae:	83 c0 01             	add    $0x1,%eax
  8019b1:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8019b4:	39 f2                	cmp    %esi,%edx
  8019b6:	74 13                	je     8019cb <strlcpy+0x46>
  8019b8:	83 c2 01             	add    $0x1,%edx
  8019bb:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8019bf:	84 c9                	test   %cl,%cl
  8019c1:	75 eb                	jne    8019ae <strlcpy+0x29>
  8019c3:	eb 06                	jmp    8019cb <strlcpy+0x46>
  8019c5:	89 f8                	mov    %edi,%eax
  8019c7:	eb 02                	jmp    8019cb <strlcpy+0x46>
  8019c9:	89 f8                	mov    %edi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8019cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019ce:	29 f8                	sub    %edi,%eax
}
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5f                   	pop    %edi
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8019de:	0f b6 01             	movzbl (%ecx),%eax
  8019e1:	84 c0                	test   %al,%al
  8019e3:	74 15                	je     8019fa <strcmp+0x25>
  8019e5:	3a 02                	cmp    (%edx),%al
  8019e7:	75 11                	jne    8019fa <strcmp+0x25>
		p++, q++;
  8019e9:	83 c1 01             	add    $0x1,%ecx
  8019ec:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8019ef:	0f b6 01             	movzbl (%ecx),%eax
  8019f2:	84 c0                	test   %al,%al
  8019f4:	74 04                	je     8019fa <strcmp+0x25>
  8019f6:	3a 02                	cmp    (%edx),%al
  8019f8:	74 ef                	je     8019e9 <strcmp+0x14>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8019fa:	0f b6 c0             	movzbl %al,%eax
  8019fd:	0f b6 12             	movzbl (%edx),%edx
  801a00:	29 d0                	sub    %edx,%eax
}
  801a02:	5d                   	pop    %ebp
  801a03:	c3                   	ret    

00801a04 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0f:	8b 75 10             	mov    0x10(%ebp),%esi
	while (n > 0 && *p && *p == *q)
  801a12:	85 f6                	test   %esi,%esi
  801a14:	74 29                	je     801a3f <strncmp+0x3b>
  801a16:	0f b6 03             	movzbl (%ebx),%eax
  801a19:	84 c0                	test   %al,%al
  801a1b:	74 30                	je     801a4d <strncmp+0x49>
  801a1d:	3a 02                	cmp    (%edx),%al
  801a1f:	75 2c                	jne    801a4d <strncmp+0x49>
  801a21:	8d 43 01             	lea    0x1(%ebx),%eax
  801a24:	01 de                	add    %ebx,%esi
		n--, p++, q++;
  801a26:	89 c3                	mov    %eax,%ebx
  801a28:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  801a2b:	39 f0                	cmp    %esi,%eax
  801a2d:	74 17                	je     801a46 <strncmp+0x42>
  801a2f:	0f b6 08             	movzbl (%eax),%ecx
  801a32:	84 c9                	test   %cl,%cl
  801a34:	74 17                	je     801a4d <strncmp+0x49>
  801a36:	83 c0 01             	add    $0x1,%eax
  801a39:	3a 0a                	cmp    (%edx),%cl
  801a3b:	74 e9                	je     801a26 <strncmp+0x22>
  801a3d:	eb 0e                	jmp    801a4d <strncmp+0x49>
		n--, p++, q++;
	if (n == 0)
		return 0;
  801a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a44:	eb 0f                	jmp    801a55 <strncmp+0x51>
  801a46:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4b:	eb 08                	jmp    801a55 <strncmp+0x51>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a4d:	0f b6 03             	movzbl (%ebx),%eax
  801a50:	0f b6 12             	movzbl (%edx),%edx
  801a53:	29 d0                	sub    %edx,%eax
}
  801a55:	5b                   	pop    %ebx
  801a56:	5e                   	pop    %esi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	53                   	push   %ebx
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a63:	0f b6 18             	movzbl (%eax),%ebx
  801a66:	84 db                	test   %bl,%bl
  801a68:	74 1d                	je     801a87 <strchr+0x2e>
  801a6a:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801a6c:	38 d3                	cmp    %dl,%bl
  801a6e:	75 06                	jne    801a76 <strchr+0x1d>
  801a70:	eb 1a                	jmp    801a8c <strchr+0x33>
  801a72:	38 ca                	cmp    %cl,%dl
  801a74:	74 16                	je     801a8c <strchr+0x33>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801a76:	83 c0 01             	add    $0x1,%eax
  801a79:	0f b6 10             	movzbl (%eax),%edx
  801a7c:	84 d2                	test   %dl,%dl
  801a7e:	75 f2                	jne    801a72 <strchr+0x19>
		if (*s == c)
			return (char *) s;
	return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
  801a85:	eb 05                	jmp    801a8c <strchr+0x33>
  801a87:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8c:	5b                   	pop    %ebx
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	53                   	push   %ebx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	8b 55 0c             	mov    0xc(%ebp),%edx
	for (; *s; s++)
  801a99:	0f b6 18             	movzbl (%eax),%ebx
  801a9c:	84 db                	test   %bl,%bl
  801a9e:	74 16                	je     801ab6 <strfind+0x27>
  801aa0:	89 d1                	mov    %edx,%ecx
		if (*s == c)
  801aa2:	38 d3                	cmp    %dl,%bl
  801aa4:	75 06                	jne    801aac <strfind+0x1d>
  801aa6:	eb 0e                	jmp    801ab6 <strfind+0x27>
  801aa8:	38 ca                	cmp    %cl,%dl
  801aaa:	74 0a                	je     801ab6 <strfind+0x27>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801aac:	83 c0 01             	add    $0x1,%eax
  801aaf:	0f b6 10             	movzbl (%eax),%edx
  801ab2:	84 d2                	test   %dl,%dl
  801ab4:	75 f2                	jne    801aa8 <strfind+0x19>
		if (*s == c)
			break;
	return (char *) s;
}
  801ab6:	5b                   	pop    %ebx
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	57                   	push   %edi
  801abd:	56                   	push   %esi
  801abe:	53                   	push   %ebx
  801abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801ac5:	85 c9                	test   %ecx,%ecx
  801ac7:	74 36                	je     801aff <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801ac9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801acf:	75 28                	jne    801af9 <memset+0x40>
  801ad1:	f6 c1 03             	test   $0x3,%cl
  801ad4:	75 23                	jne    801af9 <memset+0x40>
		c &= 0xFF;
  801ad6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801ada:	89 d3                	mov    %edx,%ebx
  801adc:	c1 e3 08             	shl    $0x8,%ebx
  801adf:	89 d6                	mov    %edx,%esi
  801ae1:	c1 e6 18             	shl    $0x18,%esi
  801ae4:	89 d0                	mov    %edx,%eax
  801ae6:	c1 e0 10             	shl    $0x10,%eax
  801ae9:	09 f0                	or     %esi,%eax
  801aeb:	09 c2                	or     %eax,%edx
  801aed:	89 d0                	mov    %edx,%eax
  801aef:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  801af1:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  801af4:	fc                   	cld    
  801af5:	f3 ab                	rep stos %eax,%es:(%edi)
  801af7:	eb 06                	jmp    801aff <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801af9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afc:	fc                   	cld    
  801afd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801aff:	89 f8                	mov    %edi,%eax
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5f                   	pop    %edi
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    

00801b06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	57                   	push   %edi
  801b0a:	56                   	push   %esi
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801b14:	39 c6                	cmp    %eax,%esi
  801b16:	73 35                	jae    801b4d <memmove+0x47>
  801b18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801b1b:	39 d0                	cmp    %edx,%eax
  801b1d:	73 2e                	jae    801b4d <memmove+0x47>
		s += n;
		d += n;
  801b1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  801b22:	89 d6                	mov    %edx,%esi
  801b24:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b2c:	75 13                	jne    801b41 <memmove+0x3b>
  801b2e:	f6 c1 03             	test   $0x3,%cl
  801b31:	75 0e                	jne    801b41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b33:	83 ef 04             	sub    $0x4,%edi
  801b36:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b39:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  801b3c:	fd                   	std    
  801b3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b3f:	eb 09                	jmp    801b4a <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b41:	83 ef 01             	sub    $0x1,%edi
  801b44:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  801b47:	fd                   	std    
  801b48:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b4a:	fc                   	cld    
  801b4b:	eb 1d                	jmp    801b6a <memmove+0x64>
  801b4d:	89 f2                	mov    %esi,%edx
  801b4f:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b51:	f6 c2 03             	test   $0x3,%dl
  801b54:	75 0f                	jne    801b65 <memmove+0x5f>
  801b56:	f6 c1 03             	test   $0x3,%cl
  801b59:	75 0a                	jne    801b65 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b5b:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  801b5e:	89 c7                	mov    %eax,%edi
  801b60:	fc                   	cld    
  801b61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b63:	eb 05                	jmp    801b6a <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b65:	89 c7                	mov    %eax,%edi
  801b67:	fc                   	cld    
  801b68:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b6a:	5e                   	pop    %esi
  801b6b:	5f                   	pop    %edi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801b74:	8b 45 10             	mov    0x10(%ebp),%eax
  801b77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	89 04 24             	mov    %eax,(%esp)
  801b88:	e8 79 ff ff ff       	call   801b06 <memmove>
}
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	57                   	push   %edi
  801b93:	56                   	push   %esi
  801b94:	53                   	push   %ebx
  801b95:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b98:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801b9e:	8d 78 ff             	lea    -0x1(%eax),%edi
  801ba1:	85 c0                	test   %eax,%eax
  801ba3:	74 36                	je     801bdb <memcmp+0x4c>
		if (*s1 != *s2)
  801ba5:	0f b6 03             	movzbl (%ebx),%eax
  801ba8:	0f b6 0e             	movzbl (%esi),%ecx
  801bab:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb0:	38 c8                	cmp    %cl,%al
  801bb2:	74 1c                	je     801bd0 <memcmp+0x41>
  801bb4:	eb 10                	jmp    801bc6 <memcmp+0x37>
  801bb6:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
  801bbb:	83 c2 01             	add    $0x1,%edx
  801bbe:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
  801bc2:	38 c8                	cmp    %cl,%al
  801bc4:	74 0a                	je     801bd0 <memcmp+0x41>
			return (int) *s1 - (int) *s2;
  801bc6:	0f b6 c0             	movzbl %al,%eax
  801bc9:	0f b6 c9             	movzbl %cl,%ecx
  801bcc:	29 c8                	sub    %ecx,%eax
  801bce:	eb 10                	jmp    801be0 <memcmp+0x51>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801bd0:	39 fa                	cmp    %edi,%edx
  801bd2:	75 e2                	jne    801bb6 <memcmp+0x27>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801bd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd9:	eb 05                	jmp    801be0 <memcmp+0x51>
  801bdb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801be0:	5b                   	pop    %ebx
  801be1:	5e                   	pop    %esi
  801be2:	5f                   	pop    %edi
  801be3:	5d                   	pop    %ebp
  801be4:	c3                   	ret    

00801be5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const void *ends = (const char *) s + n;
  801bef:	89 c2                	mov    %eax,%edx
  801bf1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801bf4:	39 d0                	cmp    %edx,%eax
  801bf6:	73 13                	jae    801c0b <memfind+0x26>
		if (*(const unsigned char *) s == (unsigned char) c)
  801bf8:	89 d9                	mov    %ebx,%ecx
  801bfa:	38 18                	cmp    %bl,(%eax)
  801bfc:	75 06                	jne    801c04 <memfind+0x1f>
  801bfe:	eb 0b                	jmp    801c0b <memfind+0x26>
  801c00:	38 08                	cmp    %cl,(%eax)
  801c02:	74 07                	je     801c0b <memfind+0x26>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801c04:	83 c0 01             	add    $0x1,%eax
  801c07:	39 d0                	cmp    %edx,%eax
  801c09:	75 f5                	jne    801c00 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801c0b:	5b                   	pop    %ebx
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    

00801c0e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	57                   	push   %edi
  801c12:	56                   	push   %esi
  801c13:	53                   	push   %ebx
  801c14:	8b 55 08             	mov    0x8(%ebp),%edx
  801c17:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c1a:	0f b6 0a             	movzbl (%edx),%ecx
  801c1d:	80 f9 09             	cmp    $0x9,%cl
  801c20:	74 05                	je     801c27 <strtol+0x19>
  801c22:	80 f9 20             	cmp    $0x20,%cl
  801c25:	75 10                	jne    801c37 <strtol+0x29>
		s++;
  801c27:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801c2a:	0f b6 0a             	movzbl (%edx),%ecx
  801c2d:	80 f9 09             	cmp    $0x9,%cl
  801c30:	74 f5                	je     801c27 <strtol+0x19>
  801c32:	80 f9 20             	cmp    $0x20,%cl
  801c35:	74 f0                	je     801c27 <strtol+0x19>
		s++;

	// plus/minus sign
	if (*s == '+')
  801c37:	80 f9 2b             	cmp    $0x2b,%cl
  801c3a:	75 0a                	jne    801c46 <strtol+0x38>
		s++;
  801c3c:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  801c3f:	bf 00 00 00 00       	mov    $0x0,%edi
  801c44:	eb 11                	jmp    801c57 <strtol+0x49>
  801c46:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  801c4b:	80 f9 2d             	cmp    $0x2d,%cl
  801c4e:	75 07                	jne    801c57 <strtol+0x49>
		s++, neg = 1;
  801c50:	83 c2 01             	add    $0x1,%edx
  801c53:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801c57:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  801c5c:	75 15                	jne    801c73 <strtol+0x65>
  801c5e:	80 3a 30             	cmpb   $0x30,(%edx)
  801c61:	75 10                	jne    801c73 <strtol+0x65>
  801c63:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  801c67:	75 0a                	jne    801c73 <strtol+0x65>
		s += 2, base = 16;
  801c69:	83 c2 02             	add    $0x2,%edx
  801c6c:	b8 10 00 00 00       	mov    $0x10,%eax
  801c71:	eb 10                	jmp    801c83 <strtol+0x75>
	else if (base == 0 && s[0] == '0')
  801c73:	85 c0                	test   %eax,%eax
  801c75:	75 0c                	jne    801c83 <strtol+0x75>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801c77:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801c79:	80 3a 30             	cmpb   $0x30,(%edx)
  801c7c:	75 05                	jne    801c83 <strtol+0x75>
		s++, base = 8;
  801c7e:	83 c2 01             	add    $0x1,%edx
  801c81:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  801c83:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c88:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801c8b:	0f b6 0a             	movzbl (%edx),%ecx
  801c8e:	8d 71 d0             	lea    -0x30(%ecx),%esi
  801c91:	89 f0                	mov    %esi,%eax
  801c93:	3c 09                	cmp    $0x9,%al
  801c95:	77 08                	ja     801c9f <strtol+0x91>
			dig = *s - '0';
  801c97:	0f be c9             	movsbl %cl,%ecx
  801c9a:	83 e9 30             	sub    $0x30,%ecx
  801c9d:	eb 20                	jmp    801cbf <strtol+0xb1>
		else if (*s >= 'a' && *s <= 'z')
  801c9f:	8d 71 9f             	lea    -0x61(%ecx),%esi
  801ca2:	89 f0                	mov    %esi,%eax
  801ca4:	3c 19                	cmp    $0x19,%al
  801ca6:	77 08                	ja     801cb0 <strtol+0xa2>
			dig = *s - 'a' + 10;
  801ca8:	0f be c9             	movsbl %cl,%ecx
  801cab:	83 e9 57             	sub    $0x57,%ecx
  801cae:	eb 0f                	jmp    801cbf <strtol+0xb1>
		else if (*s >= 'A' && *s <= 'Z')
  801cb0:	8d 71 bf             	lea    -0x41(%ecx),%esi
  801cb3:	89 f0                	mov    %esi,%eax
  801cb5:	3c 19                	cmp    $0x19,%al
  801cb7:	77 16                	ja     801ccf <strtol+0xc1>
			dig = *s - 'A' + 10;
  801cb9:	0f be c9             	movsbl %cl,%ecx
  801cbc:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  801cbf:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  801cc2:	7d 0f                	jge    801cd3 <strtol+0xc5>
			break;
		s++, val = (val * base) + dig;
  801cc4:	83 c2 01             	add    $0x1,%edx
  801cc7:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  801ccb:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  801ccd:	eb bc                	jmp    801c8b <strtol+0x7d>
  801ccf:	89 d8                	mov    %ebx,%eax
  801cd1:	eb 02                	jmp    801cd5 <strtol+0xc7>
  801cd3:	89 d8                	mov    %ebx,%eax

	if (endptr)
  801cd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd9:	74 05                	je     801ce0 <strtol+0xd2>
		*endptr = (char *) s;
  801cdb:	8b 75 0c             	mov    0xc(%ebp),%esi
  801cde:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  801ce0:	f7 d8                	neg    %eax
  801ce2:	85 ff                	test   %edi,%edi
  801ce4:	0f 44 c3             	cmove  %ebx,%eax
}
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    

00801cec <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	56                   	push   %esi
  801cf0:	53                   	push   %ebx
  801cf1:	83 ec 10             	sub    $0x10,%esp
  801cf4:	8b 75 08             	mov    0x8(%ebp),%esi
  801cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cfa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// use UTOP to indicate a no mapping
	int err_code = sys_ipc_recv(pg == NULL ? (void*)UTOP : pg);
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  801d04:	0f 44 c2             	cmove  %edx,%eax
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 a3 e6 ff ff       	call   8003b2 <sys_ipc_recv>
	if (err_code < 0) {
  801d0f:	85 c0                	test   %eax,%eax
  801d11:	79 16                	jns    801d29 <ipc_recv+0x3d>
		if (from_env_store) *from_env_store = 0;
  801d13:	85 f6                	test   %esi,%esi
  801d15:	74 06                	je     801d1d <ipc_recv+0x31>
  801d17:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if (perm_store) *perm_store = 0;
  801d1d:	85 db                	test   %ebx,%ebx
  801d1f:	74 2c                	je     801d4d <ipc_recv+0x61>
  801d21:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d27:	eb 24                	jmp    801d4d <ipc_recv+0x61>
	} else {
		if (from_env_store) *from_env_store = thisenv->env_ipc_from;
  801d29:	85 f6                	test   %esi,%esi
  801d2b:	74 0a                	je     801d37 <ipc_recv+0x4b>
  801d2d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d32:	8b 40 74             	mov    0x74(%eax),%eax
  801d35:	89 06                	mov    %eax,(%esi)
		if (perm_store) *perm_store = thisenv->env_ipc_perm;
  801d37:	85 db                	test   %ebx,%ebx
  801d39:	74 0a                	je     801d45 <ipc_recv+0x59>
  801d3b:	a1 04 40 80 00       	mov    0x804004,%eax
  801d40:	8b 40 78             	mov    0x78(%eax),%eax
  801d43:	89 03                	mov    %eax,(%ebx)
	}
	return err_code < 0 ? err_code : thisenv->env_ipc_value;
  801d45:	a1 04 40 80 00       	mov    0x804004,%eax
  801d4a:	8b 40 70             	mov    0x70(%eax),%eax
}
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	5b                   	pop    %ebx
  801d51:	5e                   	pop    %esi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    

00801d54 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	57                   	push   %edi
  801d58:	56                   	push   %esi
  801d59:	53                   	push   %ebx
  801d5a:	83 ec 1c             	sub    $0x1c,%esp
  801d5d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d60:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d63:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d66:	eb 25                	jmp    801d8d <ipc_send+0x39>
		if (err_code != -E_IPC_NOT_RECV) {
  801d68:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d6b:	74 20                	je     801d8d <ipc_send+0x39>
			panic("ipc_send:%e", err_code);
  801d6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d71:	c7 44 24 08 20 25 80 	movl   $0x802520,0x8(%esp)
  801d78:	00 
  801d79:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801d80:	00 
  801d81:	c7 04 24 2c 25 80 00 	movl   $0x80252c,(%esp)
  801d88:	e8 29 f4 ff ff       	call   8011b6 <_panic>
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
	int err_code;
	while ((err_code = sys_ipc_try_send(to_env, val, pg == NULL ? (void*)UTOP : pg, perm))) {
  801d8d:	85 db                	test   %ebx,%ebx
  801d8f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  801d94:	0f 45 c3             	cmovne %ebx,%eax
  801d97:	8b 55 14             	mov    0x14(%ebp),%edx
  801d9a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801d9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801da2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801da6:	89 3c 24             	mov    %edi,(%esp)
  801da9:	e8 e1 e5 ff ff       	call   80038f <sys_ipc_try_send>
  801dae:	85 c0                	test   %eax,%eax
  801db0:	75 b6                	jne    801d68 <ipc_send+0x14>
		if (err_code != -E_IPC_NOT_RECV) {
			panic("ipc_send:%e", err_code);
		}
	}
}
  801db2:	83 c4 1c             	add    $0x1c,%esp
  801db5:	5b                   	pop    %ebx
  801db6:	5e                   	pop    %esi
  801db7:	5f                   	pop    %edi
  801db8:	5d                   	pop    %ebp
  801db9:	c3                   	ret    

00801dba <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
		if (envs[i].env_type == type)
  801dc0:	a1 50 00 c0 ee       	mov    0xeec00050,%eax
  801dc5:	39 c8                	cmp    %ecx,%eax
  801dc7:	74 17                	je     801de0 <ipc_find_env+0x26>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801dc9:	b8 01 00 00 00       	mov    $0x1,%eax
		if (envs[i].env_type == type)
  801dce:	6b d0 7c             	imul   $0x7c,%eax,%edx
  801dd1:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801dd7:	8b 52 50             	mov    0x50(%edx),%edx
  801dda:	39 ca                	cmp    %ecx,%edx
  801ddc:	75 14                	jne    801df2 <ipc_find_env+0x38>
  801dde:	eb 05                	jmp    801de5 <ipc_find_env+0x2b>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
			return envs[i].env_id;
  801de5:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801de8:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801ded:	8b 40 40             	mov    0x40(%eax),%eax
  801df0:	eb 0e                	jmp    801e00 <ipc_find_env+0x46>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801df2:	83 c0 01             	add    $0x1,%eax
  801df5:	3d 00 04 00 00       	cmp    $0x400,%eax
  801dfa:	75 d2                	jne    801dce <ipc_find_env+0x14>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801dfc:	66 b8 00 00          	mov    $0x0,%ax
}
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	c1 e8 16             	shr    $0x16,%eax
  801e0d:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e19:	f6 c1 01             	test   $0x1,%cl
  801e1c:	74 1d                	je     801e3b <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e1e:	c1 ea 0c             	shr    $0xc,%edx
  801e21:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801e28:	f6 c2 01             	test   $0x1,%dl
  801e2b:	74 0e                	je     801e3b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e2d:	c1 ea 0c             	shr    $0xc,%edx
  801e30:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e37:	ef 
  801e38:	0f b7 c0             	movzwl %ax,%eax
}
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    
  801e3d:	66 90                	xchg   %ax,%ax
  801e3f:	90                   	nop

00801e40 <__udivdi3>:
  801e40:	55                   	push   %ebp
  801e41:	57                   	push   %edi
  801e42:	56                   	push   %esi
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	8b 44 24 28          	mov    0x28(%esp),%eax
  801e4a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  801e4e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  801e52:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801e56:	85 c0                	test   %eax,%eax
  801e58:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e5c:	89 ea                	mov    %ebp,%edx
  801e5e:	89 0c 24             	mov    %ecx,(%esp)
  801e61:	75 2d                	jne    801e90 <__udivdi3+0x50>
  801e63:	39 e9                	cmp    %ebp,%ecx
  801e65:	77 61                	ja     801ec8 <__udivdi3+0x88>
  801e67:	85 c9                	test   %ecx,%ecx
  801e69:	89 ce                	mov    %ecx,%esi
  801e6b:	75 0b                	jne    801e78 <__udivdi3+0x38>
  801e6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e72:	31 d2                	xor    %edx,%edx
  801e74:	f7 f1                	div    %ecx
  801e76:	89 c6                	mov    %eax,%esi
  801e78:	31 d2                	xor    %edx,%edx
  801e7a:	89 e8                	mov    %ebp,%eax
  801e7c:	f7 f6                	div    %esi
  801e7e:	89 c5                	mov    %eax,%ebp
  801e80:	89 f8                	mov    %edi,%eax
  801e82:	f7 f6                	div    %esi
  801e84:	89 ea                	mov    %ebp,%edx
  801e86:	83 c4 0c             	add    $0xc,%esp
  801e89:	5e                   	pop    %esi
  801e8a:	5f                   	pop    %edi
  801e8b:	5d                   	pop    %ebp
  801e8c:	c3                   	ret    
  801e8d:	8d 76 00             	lea    0x0(%esi),%esi
  801e90:	39 e8                	cmp    %ebp,%eax
  801e92:	77 24                	ja     801eb8 <__udivdi3+0x78>
  801e94:	0f bd e8             	bsr    %eax,%ebp
  801e97:	83 f5 1f             	xor    $0x1f,%ebp
  801e9a:	75 3c                	jne    801ed8 <__udivdi3+0x98>
  801e9c:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ea0:	39 34 24             	cmp    %esi,(%esp)
  801ea3:	0f 86 9f 00 00 00    	jbe    801f48 <__udivdi3+0x108>
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	0f 82 97 00 00 00    	jb     801f48 <__udivdi3+0x108>
  801eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801eb8:	31 d2                	xor    %edx,%edx
  801eba:	31 c0                	xor    %eax,%eax
  801ebc:	83 c4 0c             	add    $0xc,%esp
  801ebf:	5e                   	pop    %esi
  801ec0:	5f                   	pop    %edi
  801ec1:	5d                   	pop    %ebp
  801ec2:	c3                   	ret    
  801ec3:	90                   	nop
  801ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801ec8:	89 f8                	mov    %edi,%eax
  801eca:	f7 f1                	div    %ecx
  801ecc:	31 d2                	xor    %edx,%edx
  801ece:	83 c4 0c             	add    $0xc,%esp
  801ed1:	5e                   	pop    %esi
  801ed2:	5f                   	pop    %edi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    
  801ed5:	8d 76 00             	lea    0x0(%esi),%esi
  801ed8:	89 e9                	mov    %ebp,%ecx
  801eda:	8b 3c 24             	mov    (%esp),%edi
  801edd:	d3 e0                	shl    %cl,%eax
  801edf:	89 c6                	mov    %eax,%esi
  801ee1:	b8 20 00 00 00       	mov    $0x20,%eax
  801ee6:	29 e8                	sub    %ebp,%eax
  801ee8:	89 c1                	mov    %eax,%ecx
  801eea:	d3 ef                	shr    %cl,%edi
  801eec:	89 e9                	mov    %ebp,%ecx
  801eee:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801ef2:	8b 3c 24             	mov    (%esp),%edi
  801ef5:	09 74 24 08          	or     %esi,0x8(%esp)
  801ef9:	89 d6                	mov    %edx,%esi
  801efb:	d3 e7                	shl    %cl,%edi
  801efd:	89 c1                	mov    %eax,%ecx
  801eff:	89 3c 24             	mov    %edi,(%esp)
  801f02:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801f06:	d3 ee                	shr    %cl,%esi
  801f08:	89 e9                	mov    %ebp,%ecx
  801f0a:	d3 e2                	shl    %cl,%edx
  801f0c:	89 c1                	mov    %eax,%ecx
  801f0e:	d3 ef                	shr    %cl,%edi
  801f10:	09 d7                	or     %edx,%edi
  801f12:	89 f2                	mov    %esi,%edx
  801f14:	89 f8                	mov    %edi,%eax
  801f16:	f7 74 24 08          	divl   0x8(%esp)
  801f1a:	89 d6                	mov    %edx,%esi
  801f1c:	89 c7                	mov    %eax,%edi
  801f1e:	f7 24 24             	mull   (%esp)
  801f21:	39 d6                	cmp    %edx,%esi
  801f23:	89 14 24             	mov    %edx,(%esp)
  801f26:	72 30                	jb     801f58 <__udivdi3+0x118>
  801f28:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f2c:	89 e9                	mov    %ebp,%ecx
  801f2e:	d3 e2                	shl    %cl,%edx
  801f30:	39 c2                	cmp    %eax,%edx
  801f32:	73 05                	jae    801f39 <__udivdi3+0xf9>
  801f34:	3b 34 24             	cmp    (%esp),%esi
  801f37:	74 1f                	je     801f58 <__udivdi3+0x118>
  801f39:	89 f8                	mov    %edi,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	e9 7a ff ff ff       	jmp    801ebc <__udivdi3+0x7c>
  801f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801f48:	31 d2                	xor    %edx,%edx
  801f4a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4f:	e9 68 ff ff ff       	jmp    801ebc <__udivdi3+0x7c>
  801f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f58:	8d 47 ff             	lea    -0x1(%edi),%eax
  801f5b:	31 d2                	xor    %edx,%edx
  801f5d:	83 c4 0c             	add    $0xc,%esp
  801f60:	5e                   	pop    %esi
  801f61:	5f                   	pop    %edi
  801f62:	5d                   	pop    %ebp
  801f63:	c3                   	ret    
  801f64:	66 90                	xchg   %ax,%ax
  801f66:	66 90                	xchg   %ax,%ax
  801f68:	66 90                	xchg   %ax,%ax
  801f6a:	66 90                	xchg   %ax,%ax
  801f6c:	66 90                	xchg   %ax,%ax
  801f6e:	66 90                	xchg   %ax,%ax

00801f70 <__umoddi3>:
  801f70:	55                   	push   %ebp
  801f71:	57                   	push   %edi
  801f72:	56                   	push   %esi
  801f73:	83 ec 14             	sub    $0x14,%esp
  801f76:	8b 44 24 28          	mov    0x28(%esp),%eax
  801f7a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  801f7e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  801f82:	89 c7                	mov    %eax,%edi
  801f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f88:	8b 44 24 30          	mov    0x30(%esp),%eax
  801f8c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  801f90:	89 34 24             	mov    %esi,(%esp)
  801f93:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f97:	85 c0                	test   %eax,%eax
  801f99:	89 c2                	mov    %eax,%edx
  801f9b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f9f:	75 17                	jne    801fb8 <__umoddi3+0x48>
  801fa1:	39 fe                	cmp    %edi,%esi
  801fa3:	76 4b                	jbe    801ff0 <__umoddi3+0x80>
  801fa5:	89 c8                	mov    %ecx,%eax
  801fa7:	89 fa                	mov    %edi,%edx
  801fa9:	f7 f6                	div    %esi
  801fab:	89 d0                	mov    %edx,%eax
  801fad:	31 d2                	xor    %edx,%edx
  801faf:	83 c4 14             	add    $0x14,%esp
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    
  801fb6:	66 90                	xchg   %ax,%ax
  801fb8:	39 f8                	cmp    %edi,%eax
  801fba:	77 54                	ja     802010 <__umoddi3+0xa0>
  801fbc:	0f bd e8             	bsr    %eax,%ebp
  801fbf:	83 f5 1f             	xor    $0x1f,%ebp
  801fc2:	75 5c                	jne    802020 <__umoddi3+0xb0>
  801fc4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801fc8:	39 3c 24             	cmp    %edi,(%esp)
  801fcb:	0f 87 e7 00 00 00    	ja     8020b8 <__umoddi3+0x148>
  801fd1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  801fd5:	29 f1                	sub    %esi,%ecx
  801fd7:	19 c7                	sbb    %eax,%edi
  801fd9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fdd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801fe1:	8b 44 24 08          	mov    0x8(%esp),%eax
  801fe5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  801fe9:	83 c4 14             	add    $0x14,%esp
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    
  801ff0:	85 f6                	test   %esi,%esi
  801ff2:	89 f5                	mov    %esi,%ebp
  801ff4:	75 0b                	jne    802001 <__umoddi3+0x91>
  801ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffb:	31 d2                	xor    %edx,%edx
  801ffd:	f7 f6                	div    %esi
  801fff:	89 c5                	mov    %eax,%ebp
  802001:	8b 44 24 04          	mov    0x4(%esp),%eax
  802005:	31 d2                	xor    %edx,%edx
  802007:	f7 f5                	div    %ebp
  802009:	89 c8                	mov    %ecx,%eax
  80200b:	f7 f5                	div    %ebp
  80200d:	eb 9c                	jmp    801fab <__umoddi3+0x3b>
  80200f:	90                   	nop
  802010:	89 c8                	mov    %ecx,%eax
  802012:	89 fa                	mov    %edi,%edx
  802014:	83 c4 14             	add    $0x14,%esp
  802017:	5e                   	pop    %esi
  802018:	5f                   	pop    %edi
  802019:	5d                   	pop    %ebp
  80201a:	c3                   	ret    
  80201b:	90                   	nop
  80201c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802020:	8b 04 24             	mov    (%esp),%eax
  802023:	be 20 00 00 00       	mov    $0x20,%esi
  802028:	89 e9                	mov    %ebp,%ecx
  80202a:	29 ee                	sub    %ebp,%esi
  80202c:	d3 e2                	shl    %cl,%edx
  80202e:	89 f1                	mov    %esi,%ecx
  802030:	d3 e8                	shr    %cl,%eax
  802032:	89 e9                	mov    %ebp,%ecx
  802034:	89 44 24 04          	mov    %eax,0x4(%esp)
  802038:	8b 04 24             	mov    (%esp),%eax
  80203b:	09 54 24 04          	or     %edx,0x4(%esp)
  80203f:	89 fa                	mov    %edi,%edx
  802041:	d3 e0                	shl    %cl,%eax
  802043:	89 f1                	mov    %esi,%ecx
  802045:	89 44 24 08          	mov    %eax,0x8(%esp)
  802049:	8b 44 24 10          	mov    0x10(%esp),%eax
  80204d:	d3 ea                	shr    %cl,%edx
  80204f:	89 e9                	mov    %ebp,%ecx
  802051:	d3 e7                	shl    %cl,%edi
  802053:	89 f1                	mov    %esi,%ecx
  802055:	d3 e8                	shr    %cl,%eax
  802057:	89 e9                	mov    %ebp,%ecx
  802059:	09 f8                	or     %edi,%eax
  80205b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80205f:	f7 74 24 04          	divl   0x4(%esp)
  802063:	d3 e7                	shl    %cl,%edi
  802065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802069:	89 d7                	mov    %edx,%edi
  80206b:	f7 64 24 08          	mull   0x8(%esp)
  80206f:	39 d7                	cmp    %edx,%edi
  802071:	89 c1                	mov    %eax,%ecx
  802073:	89 14 24             	mov    %edx,(%esp)
  802076:	72 2c                	jb     8020a4 <__umoddi3+0x134>
  802078:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80207c:	72 22                	jb     8020a0 <__umoddi3+0x130>
  80207e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802082:	29 c8                	sub    %ecx,%eax
  802084:	19 d7                	sbb    %edx,%edi
  802086:	89 e9                	mov    %ebp,%ecx
  802088:	89 fa                	mov    %edi,%edx
  80208a:	d3 e8                	shr    %cl,%eax
  80208c:	89 f1                	mov    %esi,%ecx
  80208e:	d3 e2                	shl    %cl,%edx
  802090:	89 e9                	mov    %ebp,%ecx
  802092:	d3 ef                	shr    %cl,%edi
  802094:	09 d0                	or     %edx,%eax
  802096:	89 fa                	mov    %edi,%edx
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5e                   	pop    %esi
  80209c:	5f                   	pop    %edi
  80209d:	5d                   	pop    %ebp
  80209e:	c3                   	ret    
  80209f:	90                   	nop
  8020a0:	39 d7                	cmp    %edx,%edi
  8020a2:	75 da                	jne    80207e <__umoddi3+0x10e>
  8020a4:	8b 14 24             	mov    (%esp),%edx
  8020a7:	89 c1                	mov    %eax,%ecx
  8020a9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8020ad:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8020b1:	eb cb                	jmp    80207e <__umoddi3+0x10e>
  8020b3:	90                   	nop
  8020b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020b8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8020bc:	0f 82 0f ff ff ff    	jb     801fd1 <__umoddi3+0x61>
  8020c2:	e9 1a ff ff ff       	jmp    801fe1 <__umoddi3+0x71>
