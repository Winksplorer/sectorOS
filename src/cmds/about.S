aboutCmd:
    mov si, msg_about
    call printStr
    ret

msg_about: db "sectorOS is an OS in 512B, made by Wink and xrc2.",0xD,0xA,0x0