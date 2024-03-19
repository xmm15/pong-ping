%include "help.asm"

section .data
title:          db "Pong Game", 0
screen_width:   equ 1280
screen_height:  equ 800
player_height:  equ 120
player_width:   equ 25
player_speed:   equ 6

ball: istruc Ball
    at Ball.x,       dw screen_width/2
    at Ball.y,       dw screen_height/2
    at Ball.speed_x, dw 7
    at Ball.speed_y, dw 7
    at Ball.radius,  dw 20
iend


player: istruc Paddle
    at Paddle.x,         dw screen_width - player_width - 10
    at Paddle.y,         dw screen_height/2 - player_height/2
    at Paddle.width,     dw player_width
    at Paddle.height,    dw player_height
    at Paddle.speed,     dw 6
iend

cpu_ai: istruc Paddle
    at Paddle.x,         dw 10
    at Paddle.y,         dw screen_height/2 - player_height/2
    at Paddle.width,     dw player_width
    at Paddle.height,    dw player_height
    at Paddle.speed,     dw 6
iend

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

    clear_background(0x00000000)
    draw_line(screen_width/2, 0, screen_width/2 ,screen_height, 0xffffffff)
    ;draw_circle(screen_width/2, screen_height/2, 20, 0xffffffff)

    call UpdateBall

    mov rdi, player
    call UpdatePlayer

    mov rdi, cpu_ai
    call UpdatePlayer

    call DrawBall

    mov rdi, player
    call DrawPlayer

    mov rdi, cpu_ai
    call DrawPlayer

    
    ;draw_rectangle(screen_width - 35,screen_height/2 - 60, 25, 120, 0xffffffff)

    end_drawing()
    jmp .gloop

.exitgloop:
    close_window()
    sys_exit(0)

DrawBall:
    begin
    draw_circle(dword[ball+Ball.x], dword[ball+Ball.y], dword[ball+Ball.radius], 0xffffffff)
    end 0

DrawPlayer:
    begin
    mov rax, rdi
       ;draw_rectangle(screen_width - 35,screen_height/2 - 60, 25, 120, 0xffffffff)
    draw_rectangle(dword[rax+Paddle.x],dword[rax+Paddle.y],dword[rax+Paddle.width], dword[rax+Paddle.height], 0xffffffff)
    end 0

UpdateBall:
    begin
    mov eax, dword[ball+Ball.speed_x]
    add dword[ball+Ball.x], eax
    mov eax, dword[ball+Ball.speed_y]
    add dword[ball+Ball.y], eax

    mov eax, dword[ball+Ball.y]
    sub eax, dword[ball+Ball.radius]
    cmp eax, 0
    ;add eax, dword[ball+Ball.radius]
    jg .L1
    neg dword[ball+Ball.speed_y]
.L1:
    mov eax, dword[ball+Ball.y]
    add eax, dword[ball+Ball.radius]
    cmp eax, screen_height
    jl .L2
    neg dword[ball+Ball.speed_y]
.L2:
    mov eax, dword[ball+Ball.x]
    sub eax, dword[ball+Ball.radius]
    cmp eax, 0
    ;add eax, dword[ball+Ball.radius]
    jg .L3
    neg dword[ball+Ball.speed_x]
.L3:
    mov eax, dword[ball+Ball.x]
    add eax, dword[ball+Ball.radius]
    cmp eax, screen_width
    jl .L4
    neg dword[ball+Ball.speed_x]
.L4:
    end 0

UpdatePlayer:
    begin
    cmp rdi, cpu_ai
    je .L2C

    push rdi
    is_key_down(KEY_UP)
    pop rdi
    cmp rax, 0
    jne .L1
    ;mov eax, dword[rdi+Paddle.speed]
    sub dword[rdi+Paddle.y], player_speed
.L1:
    push rdi
    is_key_down(KEY_DOWN)
    pop rdi
    cmp rax, 0
    jne .L2
    ;mov eax, dword[rdi+Paddle.speed]
    add dword[rdi+Paddle.y], player_speed
    jmp .L2

.L2C:
    mov eax, dword[rdi+Paddle.y]
    add eax, player_height/2
    cmp eax, dword[ball+Ball.y]
    jle .L2Ca
    sub dword[rdi+Paddle.y], player_speed
.L2Ca:
    mov eax, dword[rdi+Paddle.y]
    add eax, player_height/2
    cmp eax, dword[ball+Ball.y]
    jg .L2
    add dword[rdi+Paddle.y], player_speed
.L2:
    cmp dword[rdi+Paddle.y], 0
    jg .L3
    mov dword[rdi+Paddle.y], 0
.L3:
    mov eax, dword[rdi+Paddle.y]
    ;add eax, dword[rdi+Paddle.height]
    add eax, player_height
    cmp eax, screen_height
    jl .L4
    ;mov eax, dword[rdi+Paddle.height]
    mov dword[rdi+Paddle.y], screen_height
    sub dword[rdi+Paddle.y], player_height
.L4:
    end 0

section '.note.GNU-stack'


