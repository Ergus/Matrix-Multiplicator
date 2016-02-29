global mult_asm:function
	
section .text

%macro multip 2

%endmacro

%macro split 0
	vmovupd ymm0, [rdi]
	vbroadcastsd ymm12, xmm0

	vshufpd ymm0, ymm0, ymm0, 9
	vbroadcastsd ymm13, xmm0
	
	vextracti128 xmm0, ymm0, 1       
	vbroadcastsd ymm14, xmm0

	vshufpd ymm0, ymm0, ymm0, 9
	vbroadcastsd ymm15, xmm0	
%endmacro
	
	
mult_asm:
	; RDI Matrix A
	; RSI Matrix B
	; RDX Matrix C
	;  CX dimension

	; Iterator stack
	push rbp
	mov rbp, rsp

	; registros a preservar al stack
	push rbx
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
	vmovupd ymm0, [rdi]            ; copio el valor de a
	
	split
	
	mov r10, rcx                   ; k=dim al llamar al loop
	lea r14, [rsi+8*r12]           ; it(b)=b[jdim]
	lea r15, [rdx+8*r11]           ; it(c)=c[idim]
        .loopk:

            vmulpd  ymm1,  ymm12, [r14]         ; multiplico temp1*b
	    vaddpd  ymm1,  [r15]                ; sumo 4 elementos de c a ymm1
	
 	    lea rbx, [r14+8*rcx]
	    vmulpd  ymm2,  ymm13, [rbx]         ; multiplico temp2*b
	    vaddpd  ymm1,  ymm2                 ; sumo 4 elementos de c a ymm1

	    lea rbx, [rbx+8*rcx]
	    vmulpd  ymm2,  ymm14, [rbx]  ; multiplico temp2*b
    	    vaddpd  ymm1,  ymm2                 ; sumo 4 elementos de c a ymm1

	    lea rbx, [rbx+8*rcx]
	    vmulpd  ymm2,  ymm15, [rbx]  ; multiplico temp2*b
	    vaddpd  ymm1,  ymm2                 ; sumo 4 elementos de c a ymm1	
	
	    vmovupd [r15], ymm1                 ; move back to register
	
	
 	    lea r14, [r14+32]          ; it(b)+=(4*sizeof(doubles))	
	    lea r15, [r15+32]	       ; Incremento el contador
	    
	    sub r10, 4
	    jne .loopk

	lea r12, [r12+4*rcx]    ; jdim+=dim
	add rdi, 32             ; muevo it(a)++
        sub r9, 4                  ; j++	
	jne .loopj              ; else goto loop

    lea r11, [r11+rcx]        ; i=i+dim
    cmp r11, r8                 ; i==dim*dim
    jne .loopi	                ; else goto .loop_i

; Recover regiters from stack
pop r15
pop r14
pop r13
pop r12	
pop rbx
; Restauro el stack
pop rbp

ret


	
