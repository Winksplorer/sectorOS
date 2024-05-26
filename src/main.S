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
.about:
    call aboutCmd
    jmp _loop
.cls:
    call clsCmd
    jmp _loop
.echo:
    call echoCmd
    jmp _loop

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

%include "src/cli.S"
%include "src/cmds/about.S"
%include "src/cmds/cls.S"
%include "src/cmds/echo.S"

welcomeStr: db "sectorOS v0.2", 0x0D, 0x0A, 0x00
prompt: db "$ ", 0x00

cmdAbout: db "about",0x00
cmdCls: db "cls",0x00
cmdEcho: db "echo",0x00

times 510-($-$$) db 0
dw 0xaa55

kbdBuffer: