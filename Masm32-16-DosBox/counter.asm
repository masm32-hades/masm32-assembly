CR      equ 0Dh

.MODEL small
.STACK 100h

.DATA
msg     db 'Liczba wpisanych znakow: $'  ; komunikat (AH=09h wymaga '$' na koncu)
numBuf  db 6 dup(?)                      ; bufor na liczbe: "65535$"
crlf    db 0Dh, 0Ah, '$'                 ; nowa linia

.CODE

; ---------------------------------------
; PrintUInt16:
; Wejscie: AX = liczba 0..65535 (unsigned)
; Wyjscie: wypisuje liczbe na ekran (AH=09h)
; Niszczy: AX, BX, CX, DX, DI (ale zabezpieczamy push/pop)
; ---------------------------------------
PrintUInt16 proc
    push bx
    push cx
    push dx
    push di

    mov bx, 10                  ; dzielnik = 10 (system dziesietny)

    lea di, numBuf + 5          ; DI -> koniec bufora
    mov byte ptr [di], '$'      ; terminator dla AH=09h
    dec di                      ; DI -> miejsce na ostatnia cyfre

    mov cx, ax                  ; CX = kopia liczby

    cmp cx, 0
    jne convert_loop            ; jesli != 0, konwertuj normalnie

    ; przypadek: liczba = 0
    mov byte ptr [di], '0'      ; wpisz '0'
    mov dx, di                  ; DX -> poczatek napisu
    mov ah, 09h
    int 21h
    jmp done

convert_loop:
    xor dx, dx                  ; DX=0 bo dzielimy DX:AX
    mov ax, cx                  ; AX = aktualna wartosc
    div bx                      ; AX=iloraz, DX=reszta (0..9)

    add dl, '0'                 ; reszta -> ASCII
    mov [di], dl                ; wpisz cyfre do bufora
    dec di                      ; cofamy sie w buforze

    mov cx, ax                  ; CX = iloraz
    cmp cx, 0
    jne convert_loop            ; dopoki iloraz != 0, dziel dalej

    inc di                      ; DI wskazuje pierwsza cyfre
    mov dx, di                  ; DX -> poczatek napisu
    mov ah, 09h
    int 21h

done:
    pop di
    pop dx
    pop cx
    pop bx
    ret
PrintUInt16 endp

; ---------------------------------------
; Program glowny
; ---------------------------------------
main PROC
    mov ax, @data               ; ustaw segment danych
    mov ds, ax

    xor cx, cx                  ; CX = 0 (licznik znakow)

read_loop:
    mov ah, 08h                 ; DOS: pobierz znak z klawiatury bez echa
    int 21h                     ; AL = ASCII wcisnietego klawisza

    cmp al, CR                  ; czy to ENTER (0Dh)?
    je  finish                  ; jesli tak, konczymy zliczanie

    inc cx                      ; inny znak -> zwieksz licznik
    jmp read_loop               ; czytaj dalej

finish:
    mov dx, OFFSET msg          ; wypisz komunikat
    mov ah, 09h
    int 21h

    mov ax, cx                  ; przenies licznik do AX (PrintUInt16 bierze AX)
    call PrintUInt16            ; wypisz liczbe

    mov dx, OFFSET crlf         ; wypisz nowa linie
    mov ah, 09h
    int 21h

    mov ax, 4C00h               ; wyjscie z programu
    int 21h
main ENDP

END main
