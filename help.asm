%macro __syscall 1
    push r11
    push rcx
    mov rax,  %1
    syscall
    pop rcx
    pop r11
%endmacro

%define syscall(num) __syscall num

%macro __exit 1
    mov rdi,    %1
    call exit
%endmacro sys_exit

%define sys_exit(status) __exit status

%macro __init_window 3
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    call InitWindow
%endmacro

%macro __close_window 0
    call CloseWindow
%endmacro

%macro __window_should_close 0
    call WindowShouldClose
%endmacro

%macro __set_target_fps 1
    mov rdi, %1
    call SetTargetFPS
%endmacro

%macro __begin_drawing 0
    call BeginDrawing
%endmacro

%macro __end_drawing 0
    call EndDrawing
%endmacro

%define void 0

%define init_window(a, b, c)    __init_window a, b, c
%define close_window(a)         __close_window
%define window_should_close(a)  __window_should_close
%define set_target_fps(a)       __set_target_fps a
%define begin_drawing(a)        __begin_drawing
%define end_drawing(a)             __end_drawing

extern InitWindow
extern CloseWindow
extern WindowShouldClose
extern exit
extern SetTargetFPS
extern BeginDrawing
extern EndDrawing

;If the size of the structure, in bytes, is ≤ 8, 
;then the the entire structure 
;is packed into a single 64-bit register and passed through it. 