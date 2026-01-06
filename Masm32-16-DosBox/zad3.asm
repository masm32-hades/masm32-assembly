.MODEL small
.STACK 100h
.DATA

.CODE

wypiszZnak MACRO znak
    mov ah, 02h
    mov dl, znak
    int 21h
ENDM

main PROC

    wypiszZnak 'B'
    wypiszZnak 'A'
    wypiszZnak 'R'
    wypiszZnak 'T'
    wypiszZnak 'E'
    wypiszZnak 'K'

    mov ah, 4C00h
    int 21h    
    

main ENDP

END main