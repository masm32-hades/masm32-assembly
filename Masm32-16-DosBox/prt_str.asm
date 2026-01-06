.MODEL SMALL
.STACK 100h
.DATA

message db 'Dobrze jest poruszac sie wsrod fundamentow$', 0

.CODE
main PROC
    mov ax, @data
    mov ds, ax              ; ustaw DS na segment danych (@data)

    mov ah, 09h             ; 09h - wypisz string zakonczony znakiem '$'
    mov dx, OFFSET message
    int 21h

    mov ax, 4C00h           ; DOS: exit
    int 21h

main ENDP

END main
