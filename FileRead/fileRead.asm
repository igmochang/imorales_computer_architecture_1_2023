section .data

encimg db "/home/igmo/Documents/GitHub/imorales_computer_architecture_1_2023/FileRead/img.txt"

section .bss

fd_in resb 1
fd_out resb 1
content resb 10

section .text
global _start

_start:

mov eax, 5
mov ebx, encimg
mov ecx, 0
int 0x80
mov ebx, eax

mov eax, 3
mov ecx, buffer
mov edx, 1024
mov ebx, eax
int 0x80

mov eax, 4
mov ebx, 1
mov ecx, buffer
mov edx, eax
int 0x80

mov eax, 6
mov ebx, [ebp-4]
int 0x80

xor eax, eax
inc eax 
int 0x80
