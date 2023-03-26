section	.text
   global _start         ;must be declared for using gcc
	
_start:                  ;tell linker entry point
   ;open the file
   mov  eax, 5
   mov  ebx, file_name
   mov  ecx, 0
   int  0x80             ;call kernel
	
   mov [fd_in], eax

read_loop:
    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   movzx esi, byte[info]
   

   cmp eax, 0
   je _end

   cmp esi, 10
   je _end

   ; print the info 
   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 1
   int 0x80
   
   jmp read_loop


   _end:

   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
	  
   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel

section	.data
file_name db "myfile.txt", 0
info db 1

section .bss
fd_in  resb 1

