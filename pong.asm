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


    ;clear_background(0xffffffff)
    draw_circle(600, 400, 20, 0xffffffff)

    draw_rectangle(10,screen_height/2 - 60, 25, 120, 0xffffffff)
    draw_rectangle(screen_width - 35,screen_height/2 - 60, 25, 120, 0xffffffff)

    end_drawing()
    jmp .gloop

.exitgloop:
    close_window()
    sys_exit(0)

section '.note.GNU-stack'


