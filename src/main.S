; main.S: the main character
; Copyleft GPL2.

BITS 16
ORG 0x7c00

%macro puts 1
mov si, %1
call printStr
%endmacro

_start:
    ; segment setup
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; stack pointer
    mov sp, 0x7c00

    ; show the name and version of the os
    puts welcomeStr

_loop:
    ; display the prompt
    puts prompt

    ; get keyboard input
    call getString
    mov si, kbdBuffer

    ; about
    mov di, cmdAbout
    call compareStr
    jc .about

    ; cls
    mov di, cmdCls
    call compareStr
    jc .cls

    ; echo (broken)
    mov di, cmdEcho
    call compareStr
    jc .echo

    jmp _loop
.cls:
    mov ax, 3
    int 10h
    jmp _loop
.about:
    puts aboutMsg
    jmp _loop
.echo:
    puts kbdBuffer + 5
    jmp _loop

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
    cmp cl, 77
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

compareStr:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne .notEqual
    inc di
    inc si
    test al, al
    jnz compareStr
    stc
    ret
.notEqual:
    clc
    ret
    
newline: db 0xD, 0xA, 0x0
backspace: db 0x8, ' ', 0x8, 0x0

welcomeStr: db "sectorOS v0.2", 0xD, 0xA, 0x0
prompt: db "$ ", 0x0

cmdCls: db "cls", 0x0
cmdEcho: db "echo", 0x0
cmdAbout: db "about", 0x0
aboutMsg: db "sectorOS is an OS in 512B, made by Wink and xrc2.", 0xD, 0xA, 0x0

times 510-($-$$) db 0
dw 0xaa55

kbdBuffer: