extern exit, mmap, putlong, newline, findc, atol, findspace

section .text

%define curr r12
%define endOfFile r13
%define accumulator rbx
%define id [rsp + 0 * 8]
%define red [rsp + 1 * 8]
%define green [rsp + 2 * 8]
%define blue [rsp + 3 * 8]
%define count rax

global _start:function
_start:
mov rdi, [rsp + 16]
call mmap

sub rsp, 8 * 4

.lineLoop:
add curr, 5

mov rdi, curr
mov sil, ':'
call findc
mov curr, rax
mov rsi, rax
call atol
mov id, rax

add curr, 2

mov QWORD red, 0
mov QWORD green, 0
mov QWORD blue, 0

.setLoop:

.cubeLoop:

mov rdi, curr
call findspace
mov curr, rax
mov rsi, rax
call atol

inc curr

cmp BYTE [curr], 'r'
jne .notRed

add curr, 3

cmp count, red
jng .endColours

mov red, count

jmp .endColours
.notRed:

cmp BYTE [curr], 'g'
jne .notGreen

add curr, 5

cmp count, green
jng .endColours

mov green, count

jmp .endColours
.notGreen:

add curr, 4

cmp count, blue
jng .endColours

mov blue, count

.endColours:

cmp BYTE [curr], ';'
je .endCubeLoop
cmp BYTE [curr], 0xa
je .endCubeLoop

add curr, 2

jmp .cubeLoop
.endCubeLoop:

cmp BYTE [curr], 0xa
je .endSetLoop

add curr, 2

jmp .setLoop
.endSetLoop:

inc curr

cmp QWORD red, 12
jg .notPossible
cmp QWORD green, 13
jg .notPossible
cmp QWORD blue, 14
jg .notPossible

add accumulator, id

.notPossible:

cmp curr, endOfFile
jl .lineLoop

mov rdi, accumulator
call putlong
call newline

mov dil, 0
call exit