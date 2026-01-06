.model small
.stack 100h
.data
.code

start:
    mov al, 'A'
    call pisz_znak

    mov ah, 4ch
    int 21h


; --------------------
; procedura wypisujaca znak
;---------------------
pisz_znak PROC NEAR
    push    ax
    mov     dl, al
    mov     ah, 02h
    int     21h
    pop     ax
    ret
pisz_znak ENDP

end start
