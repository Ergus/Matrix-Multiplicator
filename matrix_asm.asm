global mult_asm:function
	
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
    mov  r8, rcx                       ; auxiliar r8=dim
    xor  r11,  r11                     ; idim=0
    imul r8, rcx	               ; auxiliar r8=dim*dim
	
.loopi:
    
    mov   r9, rcx                      ; j=0 al llamar al loop
    xor  r12, r12  		       ; jdim=0
    .loopj:
	vbroadcastsd ymm0, [rdi]        ; copio el valor de a
	
	mov r10, rcx                   ; k=dim al llamar al loop
	lea r14, [rsi+8*r12]           ; it(b)=b[jdim]
	lea r15, [rdx+8*r11]           ; it(c)=c[idim]
        .loopk:
	
;           vmovupd ymm1, [r14]        ; copio 4 elementos de b a ymm1
;           vmulpd ymm1, ymm0          ; multiplico temp*b
	
	    vmulpd ymm1, ymm0, [r14]   ; multiplico  temp*b y lo pongo en ymm1

	    lea r14, [r14+32]          ; it(b)+=(4*sizeof(doubles))
	
            vaddpd ymm1, [r15]         ; sumo 4 elementos de c a ymm1

	    vmovupd [r15], ymm1        ; move back to register
	
	    lea r15, [r15+32]	       ; Incremento el contador
	    
	    sub r10, 4
	    jne .loopk

	add r12, rcx            ; jdim+=dim
	lea rdi, [rdi+8]        ; muevo it(a)++
        dec r9                  ; j++	
	jne .loopj              ; else goto loop

    add r11, rcx                ; i=i+dim
    cmp r11, r8                 ; i==dim*dim
    jne .loopi	                ; else goto .loop_i

; Recover regiters from stack
pop r15
pop r14
pop r13
pop r12	

; Restauro el stack
pop rbp

ret


	
