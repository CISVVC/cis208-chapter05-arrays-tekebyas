;
; file: asm_main.asm

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
        syswrite: equ 4
        stdout: equ 1
        exit: equ 1
        SUCCESS: equ 0
        kernelcall: equ 80h

        arr     db  1,2,3,4,5           ; declares an array with 5 positions containing
                                        ; the range 1 to 5
        size    db  5
        scalar  db  4



; uninitialized data is put in the .bss segment
;
segment .bss

;
; code is put in the .text segment
;
segment .text
        global  asm_main
asm_main:
        enter   0,0               ; setup routine
        pusha
; *********** Start  Assignment Code *******************

        xor     eax, eax
        mov     eax, arr            ; moves the address of the first position 
                                    ; of the array to eax
        xor     ebx, ebx
        mov     ebx, 5              ; move the size of the array to ebx

        xor     ecx, ecx
        mov     ecx, 4              ; ecx holds scalar

        push    eax
        push    ebx
        push    ecx

        call    scale

        add     esp, 12             ; clear used data off of stack

        mov     eax, [arr]
        call    print_int
        call    print_nl


; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret


scale:
        push    ebp
        mov     ebp, esp

        mov     ecx, [ebp+12]               ; stores size in ecx for loop
        mov     ebx, [ebp+8]                ; stores scalar in ebx
        mov     esi, [ebp+16]               ; store first positon of array in esi
                                            ; what is stored in eax is the address of the array
                                            ; as opposed to moving the entire array

        loop_start:
            mov     eax, [esi + ecx]        ; moves the contents of the beginning of the
                                            ; array offset by what position we are at
                                            ; into eax for multiplication
            mul     ebx                     ; multiplies what is in eax by bx
            loop    loop_start

        pop     ebp
        ret

