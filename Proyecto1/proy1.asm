section	.text
   global _start         
	
_start:                  

   mov word [_d], 1631 ; implementar con input
   mov word [_n], 5963 ; implementar con input
 
   ;open the input file
   mov  rax, 5
   mov  rbx, input_filename
   mov  rcx, 0
   int  0x80             ;call kernel
	
   mov [fd_in], rax

   ;open the output file
   mov  eax, 5
   mov  ebx, output_filename
   mov  ecx, 1
   int  0x80             ;call kernel
	
   mov [fd_out], eax


_startB1:

   xor esi, esi

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   movzx esi, byte[info]

   cmp esi, 10
   je _end

   cmp eax, 0
   je _end

   sub esi, '0'

_readByte1:
    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   movzx ecx, byte[info]

   cmp ecx, 32
   je _startB2

   cmp esi, 10 ; no deberia pasar
   je _end

   cmp eax, 0 ; no deberia pasar
   je _end

   sub ecx, '0'

   mov eax, esi
   mov esi, 10
   mul esi
   mov esi, eax

   add esi, ecx

   jmp _readByte1


_startB2:
   xor edi, edi

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   movzx edi, byte[info]

   cmp edi, 10
   je _end

   cmp eax, 0
   je _end

   sub edi, '0'


_readByte2:

   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   movzx ecx, byte[info]

   cmp eax, 0
   je _concatenate

   cmp ecx, 10
   je _concatenate

   cmp ecx, 32
   je _concatenate

   sub ecx, '0'

   mov eax, edi
   mov edi, 10
   mul edi
   mov edi, eax

   add edi, ecx

   jmp _readByte2

_concatenate:
   shl esi, 8
   add esi,edi

   mov dword [_c], esi ; Escribir esi en [_c]
   jmp _modexp ; jmp a expmod y de expmod a _write


_modexp:
mov bx, [_d]
bsr cx, bx
sub cx, 1
mov rax, [_c]

_loop:
cmp cx, 0
jl _write

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

_write:   
   ; cuando termine de escribir pixel saltar a _startB1
   
   mov cx, 10

   xor dx, dx
   div cx
   add dx, '0'
   push dx

   xor dx, dx
   div cx
   add dx, '0'
   push dx

   add eax, '0'
   mov dword [c2w], eax
   
   mov eax, 4
   mov ebx, [fd_out]
   mov ecx, c2w
   mov edx, 1
   int	0x80             ;call kernel

   pop word[c2w]

   mov eax, 4
   mov ebx, [fd_out]
   mov ecx, c2w
   mov edx, 1
   int	0x80             ;call kernel

   pop word[c2w]

   mov eax, 4
   mov ebx, [fd_out]
   mov ecx, c2w
   mov edx, 1
   int	0x80             ;call kernel

   mov byte [c2w], ' '
   
   mov eax, 4
   mov ebx, [fd_out]
   mov ecx, c2w
   mov edx, 1
   int	0x80             ;call kernel

   jmp _startB1


_end:
    
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
	
   ; close the file
   mov eax, 6
   mov ebx, [fd_out]
   int  0x80    

   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel


section	.data
input_filename db "img.txt", 0
output_filename db "output.txt", 0
info db 1
c2w db 1

_c dq 0
_d dw 0
_n dq 0

section .bss
fd_in  resd 1
fd_out  resb 1
