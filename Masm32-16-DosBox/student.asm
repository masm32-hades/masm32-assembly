; Uzyto stalych
; Dwie stale CR, LR razem reprezentuja znak ENTER
CR      equ 0Dh 
LR      equ 0Ah

.MODEL small ; jeden segment danych kazdy max 64KB
.STACK 100h ; laduje 256 bajtow pamieci dla stosu

.DATA
    ; W sekcji data zastosowalem CR, LR jako reprezentacja ENTER 
    
    student_1 db 'Imie: Adam Kowalski', CR, LR, 'Numer indexu: WK/123123/2026/1', CR, LR,CR, LR, '$', 0
    student_2 db 'Imie: Jan Nowak', CR, LR, 'Numer indexu: WK/1236663/2026/2', CR, LR, CR, LR, '$', 0
    student_3 db 'Imie: Marek Kondrad', CR, LR, 'Numer indexu: WK/12555/2026/3', CR, LR, CR, LR, '$', 0


.CODE

main PROC
    mov ax, @data ; wczytanie segmentu .DATA
    mov ds, ax    ; do rejestru ds 

    mov dx, OFFSET student_1    ; laduje do DX offset napisu student_1 zebyu DOS mogl czytac go spod adresu DS:DX
    mov ah, 09h                 ; wywoluje numer funkcji 09h do wyswietlania na ekran
    int 21h                     ; wywoluje numer przerwania 21h dla DOSa

    mov dx, OFFSET student_2    ; analogicznie jak wyzej
    mov ah, 09h
    int 21h

    mov dx, OFFSET student_3    ; analogicznie jak wyzej
    mov ah, 09h
    int 21h

    mov ax, 4C00h               ; wyjscie z programu
    int 21h
    
main ENDP

END main 
