mov si, message
call printStr
ret

printStr:
    lodsb
    test al, al
    jz .done
        
    mov ah, 0xE
    int 0x10

    jmp printStr

    .done: ret

message: db "Hello, world!", 0xD, 0xA, 0x0