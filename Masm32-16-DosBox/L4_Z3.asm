.model small
.stack 100h

.data
    lancuch db 'ABCDEF$', 0     ; lancuch zakonczony znakiem '$' (dla int 21h / AH=09h)

.code
start:
    ; --- ustaw DS na segment danych (.data) ---
    mov ax, @data               ; AX = segment danych programu
    mov ds, ax                  ; DS = segment danych (potrzebne dla [si] i OFFSET)

    ; --- ustaw SI na poczatek lancucha ---
    mov si, OFFSET lancuch      ; SI = offset pierwszego znaku (adres to DS:SI)

petla:
    ; --- odczytaj biezacy znak ---
    mov al, [si]                ; AL = biezacy znak z DS:SI
    cmp al, '$'                 ; czy to koniec lancucha?
    je  koniec                  ; jesli '$' -> nie zamieniamy, idziemy do wypisania

    ; --- zamien biezacy znak na 'x' ---
    mov byte ptr [si], 'x'      ; wpisz 'x' pod DS:SI

    ; --- przejdz do nastepnego znaku ---
    inc si                      ; SI = SI + 1 (nastepny bajt)
    jmp petla                   ; powrot na poczatek petli

koniec:
    ; --- wypisz caly lancuch (do znaku '$') ---
    mov dx, OFFSET lancuch      ; DX = offset lancucha (adres to DS:DX)
    mov ah, 09h                 ; DOS: wypisz lancuch zakonczony '$'
    int 21h

    ; --- zakoncz program ---
    mov ax, 4C00h               ; DOS: koniec programu (AL = kod wyjscia)
    int 21h

end start
