.model small
.stack 100h

.data
    lancuch db 'BARTLOMIEJ BARSZCZEWSKI$', 0

.code

print_char PROC NEAR ; skorzystalem z procedury z LAB3 do wypisywania znakow
    push bp
    mov  bp, sp

    mov  ax, [bp + 4] ; pobieram argument ze stosu [bp+0] stary BP, [bp+2] adres powrotu, [bp+4] argument pierwszy

    mov  dl, al
    mov  ah, 02h
    int  21h
    
    pop  bp
    ret

print_char ENDP

start:
    ; ustaw segment danych
    mov ax, @data
    mov ds, ax      ; ustawienie segmentu danych

    ; ustaw wskaznik na poczatek lancucha
    mov si, OFFSET lancuch

    mov al, byte ptr [si + 4]
    push ax
    call print_char

    mov al, byte ptr [si + 2]
    push ax
    call print_char

    mov al, byte ptr [si + 1]
    push ax
    call print_char

    mov ax, 4C00h
    int 21h


END start

