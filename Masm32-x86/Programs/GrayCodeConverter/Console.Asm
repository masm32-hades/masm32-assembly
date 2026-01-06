Include Console.Inc

.CODE

EncodeToGrayCode PROC
	mov	eax, [esp+4]
	
	mov	ebx, eax
	sar	ebx, 1
	xor	eax, ebx
	
	Ret
EncodeToGrayCode endp

DecodeFromGrayCode Proc
	mov		eax, [esp+4]	
	xor		ebx, ebx
	
	loop_until:
		xor ebx, eax
		sar eax, 1
		cmp	eax, 0
		jne loop_until
	
	mov eax, ebx	; przenies wynik z ebx do eax
	Ret
DecodeFromGrayCode endp

ConvertToBin PROC
	xor	eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov eax, [esp+4] ; get the first argument from stack
	
	mov numToDecode, eax
	
	loop_until:
		xor 	edx, edx
		mov		ecx, 2
		div		ecx
		
		mov		bits[ebx], dl
		inc		ebx
		cmp 	eax, 0
		jne 	loop_until
	
	mov	ecx, ebx
	
	loop_print_binary:
		dec			ecx
		push		ecx
		movzx		eax, bits[ecx]
		PrintNumber	eax, buffer			; we dont have PrintNumber MACRO
		pop			ecx
		
		cmp			ecx, 0
		jne			loop_print_binary
	
	PrintLine
	
	Ret
ConvertToBin endp

Start:

  Invoke Main
  Invoke ExitProcess,0

Main Proc
	XOR EAX,EAX

	PrintMsg	MsgPrompt
	ScanInput
	
	; lets see if we pass correct number positive or negative
	; result from ScanInput is in eax register
	
	cmp		eax, 0
	jge		is_ok
	jmp		exit
	
	is_ok:
		sub		esp, 4
		mov		[esp], eax	; push our number to stack
		call	EncodeToGrayCode
		add		esp, 4		; adjust the stack
	
		push	eax
		PrintMsg	MsgInfoAfterEnc
		pop		eax
		
		; Now we have to convert decimal number to binary number
		
		sub		esp, 4	; reserve 4 bytes of memory in stack
		mov		[esp], eax
		call	ConvertToBin
		add		esp, 4	; adjust stack
	
		mov		eax, numToDecode
		sub		esp, 4
		mov		[esp], eax
		call	DecodeFromGrayCode
		add		esp, 4
		
		push	eax
		PrintMsg MsgInfoAfterDec
		pop		eax
		
		sub		esp, 4
		mov		[esp], eax
		call	ConvertToBin
		add		esp, 4
		
	exit:
		RET
Main EndP

End Start
