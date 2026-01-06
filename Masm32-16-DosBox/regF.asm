ESCAPE      equ 1Bh
CR          equ 0Dh
LR          equ 0Ah
LETTER_A    equ 41h ; 65 decimal A
LETTER_Z    equ 5Ah ; 90 decimal Z


; kody bledow przerwania 3Ch - create file
ERROR_CREATE_FILE_NOT_FOUND_PATH        equ     3
ERROR_CREATE_FILE_NO_HANDLE_AVAILABLE   equ     4
ERROR_CREATE_FILE_ACCESS_DENIED         equ     5
; ------------------------------------------------

ERROR_OPEN_FILE_NOT_FOUND               equ     2
ERROR_OPEN_FILE_PATH_NOT_EXIST          equ     3
ERROR_OPEN_FILE_HANDLE_NOT_AVAILABLE    equ     4
ERROR_OPEN_FILE_ACCESS_DENIED           equ     5
ERROR_OPEN_FILE_WRONG_ACCESS_CODE       equ     0Ch

.MODEL SMALL
.STACK 512h

.DATA
    file_name                   db 'C:\litery.txt', 0                            ; DOSBOX widzi tylko katalog zamontowany
    msg_info                    db 'Dane zostana zapisane do pliku litery.txt$'
    msg_success                 db 'Plik zostal otwarty$'

    msg_capslock                db 'WCISNIJ CAPSLOCK - Male litery sa niedozwolone$', 0

    sign                        db 0
    handle                      dw ?

    ;-------------------------------------------------------------------------
    ; wiadomosci bledow przerwania 3Ch - create file
    ;-------------------------------------------------------------------------
    msg_error_create_file_not_found_path         db 'Blad: Nie znaleziono sciezki$'
    msg_error_create_file_no_handle_available    db 'Blad: Brak dostepnego uchwytu$'
    msg_error_create_file_access_denied          db 'Blad: Dostep zabroniony$'
    ;-------------------------------------------------------------------------


    ;-------------------------------------------------------------------------
    ; wiadomosci bledow przerwania 3Dh - open file
    ;-------------------------------------------------------------------------
    msg_error_open_file_not_found              db 'Blad: Nie znaleziono pliku$'
    msg_error_open_file_path_not_exist         db 'Blad: Sciezka nie istnieje$'
    msg_error_open_file_handle_not_available   db 'Blad: Brak dostepnego uchwytu do pliku$'
    msg_error_open_file_access_denied          db 'Blad: Odmowa dostepu$'
    msg_error_open_file_wrong_access_code      db 'Blad: Nieprawidlowy kod dostepu$'        
    ;-------------------------------------------------------------------------


    ; ------------------------------------------------------------------------
    ; wiadomosc bledu przerwania 3Eh
    ; ------------------------------------------------------------------------
    msg_error_close_file    db 'Blad: Wystapil blad podczas zamykania pliku$'
    ;-------------------------------------------------------------------------
    
.CODE


main PROC
    mov ax, @data       ; 
    mov ds, ax          ; ustaw DS na segment danych @data

    ; ------------------------------------------------------------
    ; tworzymy plik - create file
    ; ------------------------------------------------------------
    mov ah, 3Ch                 ; stworz plik
    mov cx, 0                   ;
    mov dx, OFFSET file_name
    int 21h
    ;-------------------------------------------------------------


    jc  handle_error_create_file
    mov handle, ax                      ; zachowaj uchwyt do pliku (adres do pliku)
    jmp move_file_offset                ; jesli sukces to skocz do etykiety open_file


    ; ------------------------------------------------------------
    ; obsluga bledow dla przerwania 3Ch - create file 
    ; sprawdzamy co zawiera sie w ax - jaki kod bledu?
    ; ------------------------------------------------------------

    print_error_msg_capslock:
        mov dx, OFFSET msg_capslock       
        mov ah, 09h                   
        int 21h
        call print_enter
        jmp loop_until_esc
    
    handle_error_create_file:
        cmp ax, ERROR_CREATE_FILE_NOT_FOUND_PATH
        je print_error_create_file_not_found_path
    
        cmp ax, ERROR_CREATE_FILE_NO_HANDLE_AVAILABLE
        je print_error_create_file_no_handle_available
    
        cmp ax, ERROR_CREATE_FILE_ACCESS_DENIED
        je print_error_create_file_access_denied

        jmp exit
    
    print_error_create_file_not_found_path:
        mov dx, OFFSET msg_error_create_file_not_found_path       
        mov ah, 09h                   
        int 21h
        call print_enter
        jmp exit
        
    print_error_create_file_no_handle_available:
        mov dx, OFFSET msg_error_create_file_no_handle_available       
        mov ah, 09h                   
        int 21h
        call print_enter
        jmp exit
        
    print_error_create_file_access_denied:
        mov dx, OFFSET msg_error_create_file_access_denied       
        mov ah, 09h                   
        int 21h
        call print_enter
        jmp exit
    ; -------------------------------------------------------------
    
    ; ------------------------------------------------------------------- 
    ; przesuwanie wskaznika pliku
    ; ------------------------------------------------------------------- 
    move_file_offset:
        mov ah, 42h
        mov bx, handle
        xor cx, cx          ; pozycja
        xor dx, dx          ;
        mov al, 2           ; na koniec pliku
        int 21h
    ; --------------------------------------------------------------------

    ; -------------------------------------------------------------------
    ; petla obslugujaca naciskanie klawiszy i zapis do pliku
    ; -------------------------------------------------------------------
    loop_until_esc:           ; petla - dopoki nie ma znaku ESC
       mov al, 0
       mov ah, 01h            ; pobierz znak z echem
       int 21h

       mov sign, al           

       cmp sign, LETTER_A     ; odrzucam znaki ponizej numeru litery A w kodzie ASCII
       jb print_error_msg_capslock

       cmp sign, LETTER_Z     ; odrzucam znaki powyzej numeru litery Z w kodzie ASCII
       ja print_error_msg_capslock

       cmp sign, ESCAPE       ; nie chcemy znaku ESCAPE w pliku
       je  continue
       
       mov ah, 40h            ; zapis do pliku lub urzadzenia
       mov bx, handle
       mov cx, 1
       mov dx, OFFSET sign
       int 21h

       continue:
           cmp sign, ESCAPE
           jne loop_until_esc  ; jesli nierowne znakowi ESC to kontynuuj wpisywanie
    ; --------------------------------------------------------------------       

    ; ----------------------------------------------------------------------
    ; zamykanie pliku ktorego adres (pointer) jest juz w rejestrze bx
    ; w takim wypadku nie potrzebuje juz wywolywac mov bx, bx
    ; ----------------------------------------------------------------------        
    mov ah, 3Eh
    int 21h

    jc  error_close_file        ; jesli CF = 1 to wystapil blad, jesli blad to wyswietl komunikat msg_error_close_file
    jmp exit                    ; jesli nie ma bledu to zakoncz program

    error_close_file:        
        mov dx, OFFSET msg_error_close_file       
        mov ah, 09h                   
        int 21h
        call print_enter
        jmp exit    
    

    ; wyjscie z programu
    exit:
       mov ax, 4C00h
       int 21h

main ENDP

print_enter PROC
    mov dl, CR
    mov ah, 02h
    int 21h

    mov dl, LR
    mov ah, 02h
    int 21h
    ret
print_enter ENDP

END main
