.text

#if defined(__APPLE__) || defined(_WIN32)
#define RECORD_SP_LIMIT    _record_sp_limit
#define GET_SP_LIMIT       _get_sp_limit
#define GET_SP             _get_sp
#define CHECK_STACK        _check_stack_alignment
#else
#define RECORD_SP_LIMIT    record_sp_limit
#define GET_SP_LIMIT       get_sp_limit
#define GET_SP             get_sp
#define CHECK_STACK        check_stack_alignment
#endif

.globl RECORD_SP_LIMIT
.globl GET_SP_LIMIT
.globl GET_SP
.globl CHECK_STACK

#if defined(__linux__) || defined(__FreeBSD__)
RECORD_SP_LIMIT:
	movl 4(%esp), %eax
	movl %eax, %gs:48
	ret
#endif

#if defined(__APPLE__)
RECORD_SP_LIMIT:
	movl $0x48+90*4, %eax
	movl 4(%esp), %ecx
	movl %ecx, %gs:(%eax)
	ret
#endif

#if defined(_WIN32)
RECORD_SP_LIMIT:
	movl 4(%esp), %eax
	movl %eax, %fs:0x14
	ret
#endif

#if defined(__linux__) || defined(__FreeBSD__)
GET_SP_LIMIT:
	movl %gs:48, %eax
	ret
#endif

#if defined(__APPLE__)
GET_SP_LIMIT:
	movl $0x48+90*4, %ecx
	movl %gs:(%ecx), %eax
	ret
#endif

#if defined(_WIN32)
GET_SP_LIMIT:
	movl %fs:0x14, %eax
	ret
#endif

GET_SP:
	movl %esp, %eax
	ret

// This will segfault if not called on a 16-byte boundary
CHECK_STACK:
	subl $28, %esp
	movaps %xmm0, (%esp)
	addl $28, %esp
	ret
