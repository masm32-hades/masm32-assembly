.586
.MODEL flat, stdcall

OPTION CASEMAP:NONE   ;Case sensitive

Include windows.inc
Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

Main		PROTO
;;macros

PrintIntNumber MACRO number:REQ, outbuffer:REQ
	invoke	dwtoa, number, ADDR outbuffer
	invoke 	StdOut, ADDR outbuffer
endm

PrintIntNumberLn	MACRO num:REQ, outbuffer:REQ
	invoke	dwtoa, num, ADDR outbuffer
	invoke 	StdOut, ADDR outbuffer
	; We need enter sign
	invoke StdOut, ADDR CRLF
endm

PrintStringLn MACRO msg:REQ
	invoke 	StdOut, ADDR msg
	invoke StdOut, ADDR CRLF
endm

PrintString MACRO msg:REQ
	invoke 	StdOut, ADDR msg
endm

PrintLn MACRO
	invoke 	StdOut, ADDR CRLF
endm

InputInt	MACRO
	LOCAL not_neg, done_parse
	;
	invoke StdIn, ADDR num, LENGTHOF num
	
	lea	esi, num
	mov al, [esi]
	
	cmp al, '-'	; check if it is negative number
	jne	not_neg	; if doesn't go to not_neg label
	
	inc	esi	; jump after '-' and show number
	invoke atodw, esi
	neg eax	; set negative number
	jmp	done_parse
	
	not_neg:
		invoke atodw, ADDR num
	
	done_parse:
		; after macro
		; eax register has ready negative number or positive number
endm

.DATA
	MsgEnd	DB "Finish program good bye!", 0
	CRLF	DB 0Ah, 0Dh, 0

.DATA?
	outbuffer DB 32 dup(?)