.MODEL small
.STACK 100h

.DATA

.CODE

ustawKursor MACRO wiersz, kolumna ; poczatek makra
    mov ah, 02h ; numer procedury ustawiajacej kursor
    mov bh, 0
    mov dh, wiersz
    mov dl, kolumna
    int 10h  ; wywolanie BIOS 
ENDM

main PROC

    ustawKursor 09h, 20h ; wywolanie makra

    mov ax, 4C00h ; wyjscie z programu
    int 21h
    
main ENDP

END main