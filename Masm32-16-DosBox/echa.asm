CR          equ 0Dh 
LR          equ 0Ah
ZERO_EXIT   equ 30h ; ASCII ZERO = 48 DEC

.MODEL SMALL
.STACK 100h
.DATA

    msg db 'Wpisuj znaki, znak zero - 0 konczy program', CR, LR, '$', 0 

.CODE
main PROC
    mov ax, @data               ; laduje segment danych
    mov ds, ax

    mov dx, OFFSET msg          ; wczytuje komunikat msg
    mov ah, 09h
    int 21h
    
    loop_until:                 ; etykieta dla petli
        
        mov ah, 08h             ; pobieranie znaku bez echa
        int 21h

        cmp al, ZERO_EXIT       ; warunek jesli al czyli nasz znak al == 0 to exit wyjdz z programu
        je exit

        mov dl, al              ; w rejestrze AL jest nasz pobrany znak
        mov ah, 02h             ; wyswietl pobrany znak z klawiatury
                                ; bez 02h znak nie zostanie wyswietlony
        int 21h

        cmp al, ZERO_EXIT       ; warunek cmp jesli al != 0 to kontunuuj petle
        jne loop_until


    exit: 
        mov ax, 4C00h           ; DOS: exit
        int 21h

main ENDP

END main
