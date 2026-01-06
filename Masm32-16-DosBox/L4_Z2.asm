.model small
.stack 100h

.data
    lancuch db 'BARTLOMIEJ BARSZCZEWSKI$', 0

.code

print_string PROC NEAR ; skorzystam procedury z LAB3 i dostosuje do wypisywania lancucha zankow
    push bp
    mov  bp, sp

    mov  bx, [bp + 4] ; pobieram 1 argument
    
    mov  ah, 09h ; numer funkcji do wypisywania lancucha znakow
    mov  dx, bx  ; przekazuje adres offsetu lancucha
    int 21h      ; wywoluje przerwanie DOS
    
    pop  bp
    ret

print_string ENDP

start:
    ; ustaw segment danych
    mov ax, @data
    mov ds, ax      ; ustawienie segmentu danych

    ; ustaw wskaznik na poczatek lancucha
    mov si, OFFSET lancuch

    mov byte ptr [si + 2], 'X'
    mov byte ptr [si + 3], 'Y'
    mov byte ptr [si + 4], 'Z'

    push si
    call print_string

    mov ax, 4C00h
    int 21h


END start

