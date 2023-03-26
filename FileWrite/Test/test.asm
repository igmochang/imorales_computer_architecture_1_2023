section	.text
   global _start         ;must be declared for using gcc
	
_start:                  ;tell linker entry point

   mov word [info], 'B'
   ;open the file
   mov  eax, 5
   mov  ebx, file_name
   mov  ecx, 1
   int  0x80             ;call kernel
	
   mov [fd_in], eax

_write:

   ;write A into file
   mov eax, 4
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80  

   ;move pointer
   ;mov eax, 19
   ;mov ebx, [fd_in]
   ;mov ecx, 1
   ;mov edx, 1
   ;int 0x80


   ; write 1 into file 
   mov byte [info], 49

   mov eax, 4
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

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

