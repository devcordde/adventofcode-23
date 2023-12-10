extern exit, mmap, putlong, newline, findws, atol, skipws

section .text

%use fp
%define curr r12
%define arryPtr r13
%define accumulator r13

global _start:function
_start:
mov rdi, [rsp + 16]
call mmap

mov curr, rax

add curr, 5

.readLengthsLoop:

mov rdi, curr
call skipws
mov curr, rax

mov rdi, curr
call findws
mov rsi, rax
mov curr, rax
call atol

mov [arryPtr], rax
add arryPtr, 8

cmp BYTE [curr], 0xa
jne .readLengthsLoop

add curr, 10

.readDistancesLoop:

mov rdi, curr
call skipws
mov curr, rax

mov rdi, curr
call findws
mov rsi, rax
mov curr, rax
call atol

mov [arryPtr], rax
add arryPtr, 8

cmp BYTE [curr], 0xa
jne .readDistancesLoop

mov accumulator, 1
mov curr, 0
movsd xmm2, [two]
movsd xmm4, [four]

.countCombinationsLoop:

cvtsi2sd xmm0, [lengths + curr * 8]
cvtsi2sd xmm1, [distances + curr * 8]

mulsd xmm1, xmm4

movsd xmm3, xmm0
mulsd xmm3, xmm3
subsd xmm3, xmm1
sqrtsd xmm3, xmm3
divsd xmm3, xmm2

divsd xmm0, xmm2

movsd xmm1, xmm0
subsd xmm1, xmm3
roundsd xmm5, xmm1, 0b00000010
cvtsd2si rax, xmm5
comisd xmm5, xmm1
jne .noIncrementFirst

inc rax

.noIncrementFirst:

addsd xmm0, xmm3
roundsd xmm5, xmm0, 0b00000001
cvtsd2si rsi, xmm5
comisd xmm5, xmm0
jne .noDecrmementSecond

dec rsi

.noDecrmementSecond:

sub rsi, rax
inc rsi

imul accumulator, rsi

inc curr

cmp QWORD [lengths + curr * 8], 0
jne .countCombinationsLoop

mov rdi, accumulator
call putlong
call newline

mov dil, 0
call exit

section .rodata
two:
dq float64(2.0)
four:
dq float64(4.0)

section .bss
lengths: resq 5
distances: resq 5