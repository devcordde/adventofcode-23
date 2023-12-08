extern exit, mmap, putlong, newline, findws, atol, skipws

section .text

%use fp
%define curr r12
%define bufferptr r13
%define length r14
%define distance r15

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  mov curr, rax

  add curr, 5

.readTimeLoop:

  mov al, [curr]

  cmp al, ' '
  je .continueReadTimeLoop

  mov [bufferptr], al
  inc bufferptr

.continueReadTimeLoop:

  inc curr

  cmp BYTE [curr], 0xa
  jne .readTimeLoop

  mov rdi, buffer
  mov rsi, bufferptr
  call atol
  mov length, rax

  add curr, 10

.readDistanceLoop:

  mov al, [curr]

  cmp al, ' '
  je .continueReadDistanceLoop

  mov [bufferptr], al
  inc bufferptr

.continueReadDistanceLoop:

  inc curr

  cmp BYTE [curr], 0xa
  jne .readDistanceLoop

  mov rdi, buffer
  mov rsi, bufferptr
  call atol
  mov distance, rax

  movsd xmm2, [two]
  movsd xmm4, [four]

  cvtsi2sd xmm0, length
  cvtsi2sd xmm1, distance

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

  mov rdi, rsi
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
buffer: resb 32