global mult_asm

section .text

mult_asm:
	; RDI Matrix A
	; RSI Matrix B
	; RDX Matrix C
	;  CX dimension

	; Iterator stack
	push rbp
	mov rbp, rsp

	; registros a preservar al stack
	push r12
	push r13
	push r14
	push r15

    ; iteraciones
    mov  r8, rcx                ; auxiliar r8=dim
    xor  r11,  r11              ; idim=0
    imul r8, rcx	        ; auxiliar r8=dim*dim
	
.loopi:
    
    xor   r9,  r9               ; j=0 al llamar al loop
    xor  r12, r12  		; jdim=0
    .loopj:
	movsd xmm0, [rdi]
	punpcklqdq xmm0, xmm0   ; copy xmm15 dos veces en el registro 15 (temp)
	
	xor r10, r10            ; k=0 al llamar al loop
	lea r14, [rsi+8*r12]    ; it(b)=b[jdim]
	lea r15, [rdx+8*r11]    ; it(c)=c[idim]
        .loopk:
	
            movapd xmm1, [r14]  ; copio 2 elementos de b a xmm1
	    lea r14, [r14+16]    ; it(b)+=2

	    mulpd xmm1, xmm0    ; multiplico los valores por temp

            movapd xmm2, [r15]  ; copio 2 elementos de c a xmm2
	    addpd xmm2, xmm1    ; c+=tmp*b
	    movapd [r15], xmm2  ; move back to register

	    lea r15, [r15+16]
	    
	    add r10, 2
	    cmp r10, rcx
.loopkout2:
	    jne .loopk
.loopkout1:
        inc  r9                 ; j++
	add r12, rcx            ; jdim+=dim
	lea rdi, [rdi+8]        ; muevo it(a)++
	cmp r9, rcx             ; j==dim
	jne .loopj             ; else goto loop
.loopjout:
    add r11, rcx                ; i=i+dim
    cmp r11, r8                 ; i==dim*dim
    jne .loopi	                ; else goto .loop_i
loopiout:

	; Recover regiters from stack
	pop r15
	pop r14
	pop r13
	pop r12	

	; Restauro el stack
	pop rbp

	ret


	
