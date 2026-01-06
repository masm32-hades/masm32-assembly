.model small    ; wybieramy model pamieci, oddzielne segmenty dla danych i kodu
.stack 100h     ; rezerwacja 256 bajtow na stos
.data

.CODE

main PROC

    mov al, 04h  ; mlodsze 8 bitow = 1 bajt mlodszy
    mov ah, 0Ah  ; starsze 8 bitow = 1 bajt starszy

    push ax     ; przekazuje przez 16 bitow = 2 bajty
    call pozycja_kursora    ; wywoluje procedure

    mov ax, 4c00h   ; koczne program
    int 21h         ; wywolanie przerwania dos

main ENDP

pozycja_kursora PROC NEAR ; poczatek procedury
    push bp         ; odkladam stary frame pointer zeby potem powrocic z procedury
    mov  bp, sp     ; nowy frame pointer bedzie posiadala aktualny adres wierzcholka stosu

    mov ax, [bp + 4] ; pobieram argument
    
    mov bh, 0       ;  strona
    mov dl, cl      ;  kolumna
    mov dh, ah      ;  wiersz   
    mov ah, 02h
    int 10h ; wywolanie BIOS dla funkcji AH=02
    
    pop bp  ; odzyskuje adres ramki stosu
    ret     ; wychodze z procedury do adresu nastepnej instrukcji
    
pozycja_kursora ENDP ; koniec procedury

END main 