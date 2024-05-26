getString:
    mov di, kbdBuffer
    xor cl, cl
.loop:
    ; get the key
    xor ah, ah
    int 16h

    cmp al, 0x08
    je .backspace
    cmp al, 0x0D
    je .done

    ; amount of characters to take
    cmp cl, 0x40
    je .loop

    ; print it
    mov ah, 0xE
    int 10h

    stosb
    inc cl
    jmp .loop

.backspace:
    test cl, cl
    je .loop

    dec di
    mov byte [di], 0
    dec cl

    puts backspace

    jmp .loop

.done:
    ; store the string terminator
    xor al, al
    stosb
    
    ; print a new line
    puts newline

    ret

printStr:
    lodsb
    test al, al
    jz .done
        
    mov ah, 0xE
    int 0x10

    jmp printStr

    .done: ret

newline: db 0x0D, 0x0A, 0x00
backspace: db 0x08, 0x20, 0x08, 0x00