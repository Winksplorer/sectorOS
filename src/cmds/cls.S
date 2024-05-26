clsCmd:
    xor ah, ah
    mov ax, 3
    xor bh, bh
    int 10h
    ret