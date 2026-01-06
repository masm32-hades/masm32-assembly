Include Console.Inc

.CODE

CountCircleArea PROTO

Start:
    Invoke Main
    Invoke ExitProcess, 0

Main Proc
    lea      eax, sCircle
    
    movss     xmm0, PI
    movss     [eax], xmm0

    movss     xmm0, fRadius
    movss     [eax+4], xmm0

    movss     xmm0, fResult
    movss     [eax+8], xmm0
    
    sub    esp, 12
    movss  xmm3, [sCircle.PI]
    movss  [esp], xmm3
    
    movss  xmm3, [sCircle.rad]
    movss  [esp+4], xmm3

    movss  xmm3, [sCircle.area.res]
    movss  [esp+8], xmm3

    call    CountCircleArea
    add     esp, 12

    PrintFloat4Ln sCircle.area.res, outBuffer, tmpReal8   
    
    Ret
Main EndP

CountCircleArea Proc
    push    ebp
    mov     ebp, esp

    movss   xmm0, [esp+8]  ; PI
    movss   xmm1, [esp+12] ; RADIUS
    movss   xmm2, [esp+16] ; RESULT

    mulss   xmm1, xmm1
    mulss   xmm1, xmm0
    movss   xmm2, xmm1

    movss   sCircle.area.res, xmm2
    leave
    Ret

CountCircleArea EndP

End Start