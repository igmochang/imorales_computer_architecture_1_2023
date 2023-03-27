section	.text
   global _start         
	
_start:                  

   ;mov word [_d], 1631 ; implementar con input
   ;mov word [_n], 5963 ; implementar con input
 
   ;open the input file
   mov  rax, 5
   mov  rbx, input_filename
   mov  rcx, 0
   int  0x80             ;call kernel
	
   mov [fd_in], rax

   ;open the output file
   mov  rax, 5
   mov  rbx, output_filename
   mov  rcx, 1
   int  0x80             ;call kernel
	
   mov [fd_out], rax

   ;open the key file
   mov  rax, 5
   mov  rbx, key_filename
   mov  rcx, 0
   int  0x80             ;call kernel

   mov [fd_key], rax

_startread_d:
   xor esi, esi

   ;read from file
   mov eax, 3
   mov ebx, [fd_key]
   mov ecx, key
   mov edx, 1
   int 0x80

   movzx esi, byte[key]

   sub esi, '0'

_read_d:

   ;read from file
   mov eax, 3
   mov ebx, [fd_key]
   mov ecx, key
   mov edx, 1
   int 0x80

   movzx ecx, byte[key]

   cmp ecx, 32
   je _startread_n

   sub ecx, '0'

   mov eax, esi
   mov esi, 10
   mul esi
   mov esi, eax

   add esi, ecx

   jmp _read_d

_startread_n:
   xor edi, edi

   ;read from file
   mov eax, 3
   mov ebx, [fd_key]
   mov ecx, key
   mov edx, 1
   int 0x80

   movzx edi, byte[key]

   sub edi, '0'

_read_n:

   mov eax, 3
   mov ebx, [fd_key]
   mov ecx, key
   mov edx, 1
   int 0x80

   movzx ecx, byte[key]

   cmp eax, 0
   je _storeKey

   cmp ecx, 10
   je _storeKey

   cmp ecx, 32
   je _storeKey

   sub ecx, '0'

   mov eax, edi
   mov edi, 10
   mul edi
   mov edi, eax

   add edi, ecx

   jmp _read_n

_storeKey:
   mov dword [_d], esi 
   mov dword [_n], edi

; Close key file
   mov eax, 6
   mov ebx, [fd_key]
   int  0x80    

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
   mov ecx, 0
   jmp _lookup ; jmp a lookup, buscar si ya se hizo calculo

_lookup:

   cmp ecx, 255
   je _modexp ; no se encontro en lookup table

   mov eax, [lookup + 8*ecx]

   cmp word [lookup + 8*ecx], 0
   je _modexp

   cmp esi, [lookup+8*ecx]
   je _found

   add ecx, 1
   jmp _lookup

_found:
   xor rax, rax
   mov rax, [lookup+8*ecx+4]
   jmp _write


_modexp:
mov ebx, [_d]
bsr cx, bx
sub cx, 1
xor rax,rax
mov rax, [_c]

_loop:
cmp cx, 0
jl _checkres

mov edx, 1
shl edx, cl
and edx, ebx
cmp edx, 0
je _bitFalse

mul rax
xor rsi, rsi
mov rsi, [_c]
mul rsi
mov rdx, 0
mov rsi, [_n]
div rsi
mov rax, rdx

sub ecx, 1
jmp _loop


_bitFalse:
mul rax
xor rdx, rdx
mov rsi, [_n]
div rsi
mov rax, rdx

sub cx, 1
jmp _loop

_checkres:
cmp rax, 256
jge _defectuoso
jmp _write

_defectuoso:
mov rax, 0
jmp _write

_updatetable:
   mov ecx, [lu_counter]
   mov edx, [_c]
   mov dword [lookup+8*ecx], edx
   mov dword [lookup+ 8*ecx + 4], eax
   add ecx, 1
   mov dword [lu_counter], ecx
   jmp _write

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
key_filename db "llaves.txt", 0

info db 1
c2w db 1
key db 1

_c dq 0
_d dw 0
_n dq 0
lu_counter dq 0

;lookup: times 512 dd 0

section .bss
lookup resd 512  ; no tiene sentido que sea 510 (255*2), pero no se cual valor es optimo
fd_in  resd 1
fd_out  resd 1
fd_key  resb 1
