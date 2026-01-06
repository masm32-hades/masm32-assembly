.686
.XMM
.MODEL flat, stdcall

OPTION  CASEMAP:NONE

Include windows.inc
Include kernel32.inc
Include masm32.inc

IncludeLib kernel32.lib
IncludeLib masm32.lib

Main    PROTO

PrintIntNumberLn MACRO num:REQ, outbuffer:REQ
	invoke	dwtoa, num, ADDR outbuffer
	invoke 	StdOut, ADDR outbuffer
	; We need enter sign
	invoke StdOut, ADDR CRLF
endm

PrintFloat4Ln MACRO floatMem:REQ, outBuffer:REQ, tmp64:REQ
    fld  REAL4 PTR floatMem
    fstp REAL8 PTR tmp64
    invoke FloatToStr2, tmp64, ADDR outBuffer
    invoke StdOut, ADDR outBuffer
    invoke StdOut, ADDR CRLF
ENDM

CircleArea STRUCT

    res   REAL4 ? ; 4 bytes
CircleArea ENDS

CircleStruct  STRUCT
    PI      REAL4 ?               ; 4 bytes
    rad     REAL4 ?               ; 4 bytes
    area    CircleArea <>
CircleStruct ENDS

PointStruct STRUCT
    x   REAL4 ?
    y   REAL4 ?
PointStruct ENDS

.CONST

.DATA
    sCircle     CircleStruct <>
    fRadius     REAL4   5.00
    fResult     REAL4   0.00
    PI          REAL4   3.14159

    outBuffer db 64 dup(0)
    tmpReal8  REAL8 0.0

    CRLF        DB  0Ah, 0Dh, 0
.DATA?
    buff        DB  512 (?)
    