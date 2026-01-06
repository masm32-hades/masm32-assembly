ESCAPE  equ 1Bh
CR      equ 0Dh
LR      equ 0Ah

 
.MODEL SMALL    
.STACK 100h

.DATA
    msg         db 'Wpisuj znaki. Wpisanie ESC = Koniec programu: $'
    msg_exit    db 'Koniec programu$'
    
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


main PROC

    mov ax, @data           ;
    mov ds, ax              ; ustaw DS na segment danych (@data)

    mov dx, OFFSET msg      ; do rej. dx wrzuc adres msg
    mov ah, 09h             ; wyswietl
    int 21h

    call print_enter

    loop_until_esc:         ; petla - dopoki nie ma znaku ESC
        mov ah, 01h         ; pobierz znak z echem
        int 21h

        cmp al, ESCAPE
        jne loop_until_esc  ; jesli nierowne znakowi ESC to kontynuuj wpisywanie


    call print_enter    

    mov dx, OFFSET msg_exit     
    mov ah, 09h             ; wyswietl
    int 21h

    mov ax, 4C00h           ; exit DOS
    int 21h


main ENDP

END main
