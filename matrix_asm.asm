;..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..
;
; Matrix-Matrix multiplication using nasm
; Copyright 2016 Jimmy Aguilar Mena <spacibba@yandex.com>
;	
;..ooOO00OOoo....ooOO00OOoo....ooOO00OOoo....ooOO00OOoo..

	
global mult_asm:function
	
section .text

%macro split 0
	vmovupd xmm0, [rdi]
	vbroadcastsd ymm3, xmm0

	vshufpd xmm0, xmm0, 1
	vbroadcastsd ymm4, xmm0
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
	push r12
	push r13
	push r14
	push r15

    ; iteraciones
    mov  r8, rcx                       ; auxiliar r8=dim
    xor  r11,  r11                     ; idim=0
    imul r8, rcx	               ; auxiliar r8=dim*dim
	
.loopi:
    
    mov   r9, rcx                      ; j=dim al llamar al loop
    xor  r12, r12  		       ; jdim=0
    .loopj:
	vmovupd ymm0, [rdi]            ; copio el valor de a[idim+j]
	
	split			       ; macro para hacer el broadcast ymm0 en ymm3,4
	
	mov r10, rcx                   ; k=dim al llamar al loop
	lea r14, [rsi+8*r12]           ; it(b)=b[jdim]
	lea r15, [rdx+8*r11]           ; it(c)=c[idim]
        .loopk:

            vmulpd  ymm1,  ymm3, [r14]         ; multiplico ymm1=temp1*b
	    vmulpd  ymm2,  ymm4, [r14+8*rcx]   ; multiplico ymm2=temp2*b[j+1]

	    vaddpd  ymm1,  [r15]                ; sumo 4 elementos de ymm1+=c
	    vaddpd  ymm1,  ymm2                 ; sumo 4 elementos de ymm1=+(temp2*b2)	
	
	    vmovupd [r15], ymm1                 ; move back to c
	
 	    add r14, 32                ; it(b)+=(4*sizeof(doubles))	
	    lea r15, [r15+32]	       ; it(c)+=(4*sizeof(doubles))
	    
	    sub r10, 4          ; k-=4
	    jne .loopk

	lea r12, [r12+2*rcx]    ; jdim+=(2*dim)
	add rdi, 16             ; muevo it(a)+=2*doubles
        sub  r9,  2             ; j-=2
	jne .loopj              ; else goto loop

    lea r11, [r11+rcx]          ; i=i+dim
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


	
