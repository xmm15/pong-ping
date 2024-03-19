%include "help.asm"

section .data
title:          db "Pong Game", 0
screen_width:   equ 1280
screen_height:  equ 800

section .text
global _start
_start:
    init_window(screen_width, screen_height, title)
    set_target_fps(60)

.gloop:
    window_should_close()
    cmp rax, 0
    jne .exitgloop

    begin_drawing()

    end_drawing()
    jmp .gloop

.exitgloop:
    close_window()
    sys_exit(0)

section '.note.GNU-stack'


