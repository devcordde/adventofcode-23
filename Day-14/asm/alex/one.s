extern exit, mmap, putlong, newline

section .text

%define curr rbx
%define eof [rsp + 0]
%define SIZE 128
%define x rbp
%define y r12
%define changed bl
%define lastLine [rsp + 0]
%define lineIndex rbx
%define accumulator r15

global _start:function
_start:
mov rdi, [rsp + 16]
call mmap

sub rsp, 1 * 8

mov curr, rax
add rax, rdx
mov eof, rax

mov y, 0
.readLoop:

mov x, 0
.readLineLoop:

mov al, [curr]
mov [map + x + y], al

inc curr
inc x

cmp BYTE [curr], \n
jne .readLineLoop

inc curr
add y, SIZE

cmp curr, eof
jb .readLoop

mov lastLine, y

.rollLoop:
mov changed, 0

mov y, SIZE
.rollOnceLoop:

mov x, 0
.rollLineOnceLoop:

cmp BYTE [map + x + y], 'O'
jne .continueRollLineOnceLoop

cmp BYTE [map + x + y - SIZE], '.'
jne .continueRollLineOnceLoop

mov BYTE [map + x + y], '.'
mov BYTE [map + x + y - SIZE], 'O'
mov changed, 1

.continueRollLineOnceLoop:

inc x

cmp BYTE [map + x + y], 0
jne .rollLineOnceLoop

add y, SIZE

cmp BYTE [map + y], 0
jne .rollOnceLoop

test changed, changed
jnz .rollLoop

mov y, lastLine
mov lineIndex, 0
mov accumulator, 0
.calculateLoadLoop:
sub y, SIZE
inc lineIndex

mov x, 0
.calculateLineLoadLoop:

cmp BYTE [map + y + x], 'O'
jne .continueCalculateLineLoadLoop

add accumulator, lineIndex

.continueCalculateLineLoadLoop:
inc x

cmp BYTE [map + y + x], 0
jne .calculateLineLoadLoop

cmp y, 0
jne .calculateLoadLoop

mov rdi, accumulator
call putlong
call newline

mov dil, 0
call exit

section .bss
map: resb SIZE * SIZE