;  Name: Althea Leigh Hicks
;  NSHE ID: 5000520000
;  Section: 1003
;  Assignment: Assignment 5
;  Description: Find volumes and areas for a list of cubes



; *****************************************************************
;  Data Declarations

section	.data

;  Standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

;Variables

sides           dw 10, 14, 13, 37, 54 
                dw 14, 29, 64, 67, 34 
                dw 31, 13, 20, 61, 36 
                dw 14, 53, 44, 19, 42 
                dw 44, 52, 31, 42, 56 
                dw 15, 24, 36, 75, 46 
                dw 27, 41, 53, 62, 10 
                dw 33, 4, 73, 31, 15 
                dw 5, 11, 22, 33, 70 
                dw 15, 23, 15, 63, 26 
                dw 16, 13, 64, 53, 65 
                dw 26, 12, 57, 67, 34 
                dw 24, 33, 10, 61, 15 
                dw 38, 73, 29, 17, 93 
                dw 64, 73, 74, 23, 56 
                dw 9, 8, 4, 10, 15 
                dw 13, 23, 53, 67, 35 
                dw 14, 34, 13, 71, 81 
                dw 17, 14, 17, 25, 53 
                dw 23, 73, 15, 6, 13 

length          dd 100 

caMin           dw 0 
caMid           dw 0 
caMax           dw 0 

caSum           dd 0 

caAve           dw 0 

cvMin           dd 0 
cvMid           dd 0 
cvMax           dd 0 
cvSum           dd 0 
cvAve           dd 0 

;Additional Variables 
dSix            dw 6


; -------------------------------------------------------------- 
;  Uninitialized data 
section .bss 
cubeAreas resw 100 
cubeVolumes resd 100 

; *****************************************************************
;  Code Section

section	.text
global _start
_start:

;Calculating areas and volumes
;
; cubeAreas(i) = 6 * sides(i)^2
mov ecx, dword [length]     ;length counter
mov rsi, 0                  ;index

areasLoop:

; cubeAreas(i) = 6 * sides(i)^2
mov ax, word [sides+rsi*2]
mul ax
mul word [dSix]
mov word [cubeAreas+rsi*2], ax

inc rsi
loop areasLoop

;
;cubeVolumes(i) = sides(i)^3
;
mov ecx, dword [length]     ;length counter
mov rsi, 0                  ;index

volumesLoop: 

;cubeVolumes(i) = sides(i)^3
movzx eax, word [sides+rsi*2]
mul eax
movzx r9d, word [sides+rsi*2]
mul r9d
mov dword [cubeVolumes+rsi*4], eax

inc rsi
loop volumesLoop



;initialize registers to find min, max, and sum for the areas and volumes
mov ax, word [cubeAreas]
mov word [caMin], ax
mov word [caMax], ax

mov eax, dword [cubeVolumes]
mov dword [cvMin], eax
mov dword [cvMax], eax

mov dword [caSum], 0
mov dword [cvSum], 0

mov ecx, dword [length]
mov rsi, 0


statsLoop:
;check to see if we have new area minimum
mov ax, word [cubeAreas+rsi*2]
;convert size and add to caSum
movzx eax, word [cubeAreas+rsi*2]
add dword [caSum], eax

mov ax, word [cubeAreas+rsi*2]
cmp ax, word [caMin]
jae notNewCaMin
mov word [caMin], ax

;check to see if we have new are maximum
notNewCaMin:
cmp ax, word [caMax]
jbe notNewCaMax
mov word [caMax], ax

;check to see if we have new volume minimum
notNewCaMax:
mov eax, dword [cubeVolumes+rsi*4]
add dword [cvSum], eax
cmp eax, dword [cvMin]
jae notNewCvMin
mov dword [cvMin], eax

;check to see if we have new volume maximum
notNewCvMin:
cmp eax, dword [cvMax]
jbe notNewCvMax
mov dword [cvMax], eax

;increment rsi and loop to next index in array
notNewCvMax:
inc rsi
loop statsLoop

;Averages
mov eax, dword [caSum]
mov edx, 0
div dword [length]
mov word [caAve], ax

mov eax, dword [cvSum]
mov edx, 0
div dword [length]
mov dword [cvAve], eax

;Calculating Middle value areas
mov eax, dword [length]
mov r8d, 2
mov rdx, 0
div r8d
mov esi, eax

mov eax, dword [cubeAreas+esi*2]
dec esi
add eax, dword [cubeAreas+esi*2]
mov edx, 0
mov r8d, 2
div r8d
mov word[caMid], ax

;calculate middle values volumes
mov eax, dword [length]
mov r8d, 2
mov rdx, 0
div r8d
mov esi, eax

mov eax, dword [cubeVolumes+esi*4]
dec esi
add eax, dword [cubeVolumes+esi*4]
mov edx, 0
mov r8d, 2
div r8d
mov dword[cvMid], eax





; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
