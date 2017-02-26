section .bss
section .data
A_OFFSET equ 0 
B_OFFSET equ 4 
C_OFFSET equ 8 
D_OFFSET equ 12 
F_OFFSET equ 16
G_OFFSET equ 20
DTEMP_OFFSET equ 24 
global md5_block
section .text

md5_block:
	; push rbp
	; mov rbp, rsp
	; Fuck the base pointer, and the stack while we're at it
	; rdi = md5state address
	; rsi = buffer address

	; Move init values ito registers for quick work.
	mov r10d, dword [rdi + A_OFFSET]
	mov r11d, dword [rdi + B_OFFSET]
	mov r12d, dword [rdi + C_OFFSET]
	mov r13d, dword [rdi + D_OFFSET]
	
	; Start rolling
	mov rcx, 0
l:
	cmp rcx, 16
	jb _15
	cmp rcx, 32
	jb _31
	cmp rcx, 48
	jb _47
	cmp rcx, 64
	jb _63
_15:
	mov eax, r12d
	xor eax, r13d
	and eax, r11d
	xor eax, r13d
	mov dword [rdi + F_OFFSET], eax
	mov dword [rdi + G_OFFSET], ecx
	jmp m
_31:
	mov eax, r11d
	xor eax, r12d
	and eax, r13d
	xor eax, r12d
	mov dword [rdi + F_OFFSET], eax
	mov eax, ecx
	imul eax, 5
	inc eax
	and eax, 0xf
	mov dword [rdi + G_OFFSET],eax
	jmp m
_47:
	mov eax, r11d
	xor eax, r12d
	xor eax, r13d
	mov dword [rdi + F_OFFSET],eax
	mov eax, ecx
	imul eax, 3
	add eax, 5
	and eax, 0xf
	mov dword [rdi + G_OFFSET],eax
	jmp m
_63:
	mov eax, r13d
	not eax
	or eax, r11d
	xor eax, r12d
	mov dword [rdi + F_OFFSET],eax
	mov eax, ecx
	imul eax, 7
	and eax, 0xf
	mov dword [rdi + G_OFFSET],eax
m:
	mov dword [rdi + DTEMP_OFFSET], r13d
	mov r13d, r12d
	mov r12d, r11d
	mov eax, r10d
	add eax, dword [rdi + F_OFFSET]
	add eax, dword [K + rcx * 4]
	mov rbx, 0
	mov ebx, dword [rdi + G_OFFSET]
	mov edx, dword [rsi + rbx * 4]
	add eax, edx
	mov bl, byte [S + rcx]
	push rcx
	mov cl,bl
	rol eax, cl
	pop rcx
	add r11d, eax
	mov r10d, dword [rdi + DTEMP_OFFSET]
	inc rcx
	cmp rcx,64
	jne l
	; End of loop, update state
	add dword [rdi + A_OFFSET], r10d
	add dword [rdi + B_OFFSET], r11d
	add dword [rdi + C_OFFSET], r12d
	add dword [rdi + D_OFFSET], r13d
q:
	; pop rbp 
	ret


K:
	dd 0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee
	dd 0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501
	dd 0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be
	dd 0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821
	dd 0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa
	dd 0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8
	dd 0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed
	dd 0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a
	dd 0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c
	dd 0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70
	dd 0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05
	dd 0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665
	dd 0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039
	dd 0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1
	dd 0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1
	dd 0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391

S:
	db 7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22
	db 5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20
	db 4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23
	db 6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21