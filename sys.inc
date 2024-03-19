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
    syscall(60)
%endmacro sys_exit

%define sys_exit(status) __exit status