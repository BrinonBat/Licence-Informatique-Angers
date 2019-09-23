global main
extern atoi
extern printf
extern malloc
extern free
extern memcpy
extern posix_memalign
section .data

	N	EQU	128000
	tab1	dd	0
	tab2	dd	0
	msg	db	"iterations = %d",10,0

section .text

main:
	push	ebp
	mov	ebp, esp
	pushad

	;maxi=atoi . . . .
	mov	eax, [ebp+12]	;eax<=&argv[0]
	push	dword [eax+4]
	call	atoi
	add	esp, 4
	mov	ebx, eax

	;tab1
	mov	eax, N
	shl	eax, 2
	push	eax
	push	dword 16
	push	dword tab1
	call	posix_memalign
	add	esp, 12

	;tab2
	mov	eax, N
	shl	eax, 2
	push	eax
	push	dword 16
	push	dword tab2
	call	posix_memalign
	add	esp, 12

	;boucle
	mov	edx, 1
.for_number:
	cmp	edx,ebx
	jg	.endfor_number

	mov	esi, [tab1]
	mov	edi, [tab2]
	mov	eax, N
	shl	eax, 2
	xor	ecx, ecx

.for_j:
	cmp	ecx, eax
	jge	.endfor_j

		movdqa	xmm0, [esi + ecx]
		movdqa	[esi + ecx],xmm0


	add	ecx, 16
	jmp	.for_j

.endfor_j:

	inc	edx
	jmp	.for_number

.endfor_number:

	push	edx

	;free tab 1
	push	dword [tab1]
	call	free
	add 	esp,	4

	;free tab 2
	push	dword [tab2]
	call	free
	add 	esp,	4

	pop	edx

	;printf number
	push	edx
	push	dword msg
	call	printf
	add	esp, 8


	popad
	xor eax,eax
	mov esp,ebp
	pop ebp
	ret
