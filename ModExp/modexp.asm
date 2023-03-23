section .data
_c dq 0
_d dw 0
_n dq 0
_lenExp dw 1


section .bss

idimagen resd 1
idres resd 1

section .text
global _start

_modexp:
mov bx, [_d]
bsr cx, bx
sub cx, 1
mov rax, [_c]

_loop:
cmp cx, 0
jl _end

mov dx, 1
shl dx, cl
and dx, bx
cmp dx, 0
je _bitFalse

mul rax
mov rsi, [_c]
mul rsi
mov dx, 0
mov rsi, [_n]
div rsi
mov rax, rdx

sub cx, 1
jmp _loop


_bitFalse:
mul rax
mov dx, 0
mov rsi, [_n]
div rsi
mov rax, rdx

sub cx, 1
jmp _loop


_end:
mov eax, 1
mov ebx, 1
int 80h


_start:

mov word [_c], 250
mov word [_d], 1631
mov word [_n], 5963

jmp _modexp



