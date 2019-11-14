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

        arr     dd  1,2,3,4,5           ; declares an array with 5 positions containing
                                        ; the range 1 to 5
        size    dd  5
        scalar  dd  4



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

        mov     eax, arr
        push    eax
        mov     eax, [size]
        push    eax

        call    print_arr
        call    print_nl

        add     esp, 8


        mov     eax, arr
        push    eax
        mov     eax, [size]
        push    eax
        mov     eax, [scalar]
        push    eax

        call    scale               ; call function

        add     esp, 12             ; clear used data off of stack


        mov     eax, arr
        push    eax
        mov     eax, [size]
        push    eax

        call    print_arr
        call    print_nl

        add     esp, 8

; *********** End Assignment Code **********************

        popa
        mov     eax, SUCCESS       ; return back to the C program
        leave                     
        ret

;   Prints the contents of an array with a space 
;   between each index
;   Takes two parameters:
;       *arr - the address of the array start position ( ebp + 12 )
;       n    - the size of the array                   ( ebp + 8 )

print_arr:
        push    ebp
        mov     ebp, esp

        mov     ecx, [ebp+8]        ; ecx = n
        mov     ebx, [ebp+12]       ; ebx = &arr
        xor     edx, edx            ; counter

        print_loop:
            mov     eax, [ebx + 4*edx]
            call    print_int
            mov     eax, 0x20       ; ASCII code for space ' '
            call    print_char

            inc     edx
            loop    print_loop

        pop     ebp
        ret


;   Scales the contents of each index of an array
;   Takes three parameters:
;       *arr   - the address of the array   ( ebp + 16 )
;       n      - the size of the array      ( ebp + 12 )
;       scalar - the number to scale by     ( ebp + 8 )

scale:
        push    ebp
        mov     ebp, esp

        mov     ebx, [ebp + 16]     ; arr start
        mov     ecx, [ebp + 12]     ; arr size
        mov     edx, [ebp + 8]      ; scalar
        
        lp:
            push    edx             ; store scalar so that it is not lost
                                    ; with mul
            ; -4 needed to zero index the array, ( i.e. size() - 1, not size() )
            mov     eax, [ebx - 4 + 4*ecx]
            mul     edx

            mov     [ebx - 4 + 4*ecx], eax

            pop     edx             ; restore scalar before loop
            loop    lp

        pop     ebp
        ret

