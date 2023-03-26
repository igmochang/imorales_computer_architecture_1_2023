section	.text
   global _start         ;must be declared for using gcc
	
_start:                  ;tell linker entry point
   ;open the file
   mov  eax, 5
   mov  ebx, file_name
   mov  ecx, 0
   int  0x80             ;call kernel
	
   mov [fd_in], eax



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

   ; Escribir esi en [_c]
   jmp _startB1 ; jmp a expmod y de expmod a _startB1



_end:
    
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
	
   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel


section	.data
file_name db "img.txt", 0
info db 1


section .bss

fd_in  resb 1
