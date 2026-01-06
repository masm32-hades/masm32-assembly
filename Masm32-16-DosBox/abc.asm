CR          equ 0Dh
LR          equ 0Ah

.MODEL SMALL    
.STACK 100h

.DATA
    letters         db 'ABC$'
    msg             db 'Kliknij A, B lub C $'
    msg_info_a      db 'Wpisales A - tryb 1$'
    msg_info_b      db 'Wpisales B - tryb 2$'
    msg_info_c      db 'Wpisales C - tryb 3$'
    
.CODE

print_enter PROC
    mov dl, CR
    mov ah, 02h
    int 21h

    mov dl, LR
    mov ah, 02h
    int 21h

    ret
print_enter ENDP


print_msg_char PROC

    mov     al, dl              ; pobierz argument i wrzuc do al     
    mov     si, OFFSET letters  ; SI = letters[0]

    cmp     al, [si]
    je      print_a

    cmp     al, [si+1]
    je      print_b

    cmp     al, [si+2]
    je      print_c

    print_a:
        cmp al, [si]
        jne exit
        
        mov dx, OFFSET msg_info_a       ; do rej. dx wrzuc adres msg
        mov ah, 09h                     ; wyswietl
        int 21h
        
        call    print_enter        

        jmp exit


    print_b:
        cmp al, [si+1]
        jne exit
        
        mov dx, OFFSET msg_info_b       ; do rej. dx wrzuc adres msg
        mov ah, 09h                     ; wyswietl
        int 21h

        call    print_enter

        jmp exit


    print_c:
        cmp al, [si+2]
        jne exit
        
        mov dx, OFFSET msg_info_c       ; do rej. dx wrzuc adres msg
        mov ah, 09h                     ; wyswietl
        int 21h

        call    print_enter
                
        jmp exit


    exit:
        ret
print_msg_char ENDP


main PROC

    mov ax, @data           ;
    mov ds, ax              ; ustaw DS na segment danych (@data)

    mov dx, OFFSET msg      ; do rej. dx wrzuc adres msg
    mov ah, 09h             ; wyswietl
    int 21h

    call print_enter

    loop_char:              ; petla
        mov ah, 08h         ; pobierz znak bez echa
        int 21h

        mov   dl, al        ; przekaz argument
        call  print_msg_char

        jmp loop_char  ; jesli nierowne znakowi ESC to kontynuuj wpisywanie


    call print_enter    

    mov ax, 4C00h           ; exit DOS
    int 21h


main ENDP

END main
