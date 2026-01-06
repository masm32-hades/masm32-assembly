.MODEL SMALL
.STACK 100h
.DATA

.CODE
main PROC

    mov ah, 08h             ; pobieranie znaku bez echa
    int 21h

    mov dl, al              ; w rejestrze AL jest nasz pobrany znak
    mov ah, 02h             ; wyswietl pobrany znak z klawiatury
                            ; bez 02h znak nie zostanie wyswietlony
    int 21h
   

    mov ax, 4C00h           ; DOS: exit
    int 21h

main ENDP

END main
