section	.text
   global _start         ;must be declared for using gcc
	
_start:                  ;tell linker entry point
   ;open the file
   mov  eax, 5
   mov  ebx, file_name
   mov  ecx, 0
   int  0x80             ;call kernel
	
   mov [fd_in], eax

    
   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   ; print the info 
   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 1
   int 0x80

   ;read from file
   mov eax, 3
   mov ebx, [fd_in]
   mov ecx, info
   mov edx, 1
   int 0x80

   ; print the info 
   mov eax, 4
   mov ebx, 1
   mov ecx, info
   mov edx, 1
   int 0x80
    
   ; close the file
   mov eax, 6
   mov ebx, [fd_in]
   int  0x80    
	

       
   mov	eax,1             ;system call number (sys_exit)
   int	0x80              ;call kernel

section	.data
file_name db "myfile.txt", 0
info db 1
msg db 'Welcome to Tutorials Point'
len equ  10


section .bss
fd_out resb 1
fd_in  resb 1

