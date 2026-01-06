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

PrintMsg	MACRO msg
	invoke	StdOut, ADDR msg
endm

ScanInput	MACRO
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


PrintNumber MACRO number:REQ, outbuffer:REQ
	invoke	dwtoa, number, ADDR outbuffer
	invoke 	StdOut, ADDR outbuffer
endm

PrintNumberLn	MACRO num:REQ, outbuffer:REQ
	invoke	dwtoa, num, ADDR outbuffer
	invoke 	StdOut, ADDR outbuffer
	; We need enter sign
	invoke StdOut, ADDR CRLF
endm

PrintLine MACRO
	invoke StdOut, ADDR CRLF
endm

.DATA
	MsgPrompt		DB	"Enter some number: ", 0
	MsgInfoAfterEnc DB	"Binary number after encode to Gray code:	", 0
	MsgInfoAfterDec	DB	"Binary number after decode from Gray code:	", 0
	CRLF			DB 0AH,0DH,0

.DATA?
	numToDecode dd	?
	num 		db 32 	dup(?)
	buffer		db 32 	dup(?)
	bits		db 64   dup(?)
	
	
	