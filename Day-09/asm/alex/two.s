extern exit, mmap, putslong, newline, findws, atosl, alloc

section .text

%define curr [rsp + 0]
%define eof [rsp + 8]
%define accumulator [rsp + 16]
%define sequenceStackPtr rbx
%define sequencePtr rbp
%define SLONG_MIN 0x8000000000000000
%define prevSequencePtr r12
%define zeroCheck [rsp + 24]

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 4 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax
  mov QWORD accumulator, 0

.lineLoop:

  mov sequenceStackPtr, sequenceStack

  mov rdi, 256 * 8
  call alloc

  mov [sequenceStackPtr], rax
  add sequenceStackPtr, 8

  mov sequencePtr, [sequenceStackPtr - 8]

.readLineLoop:

  mov rdi, curr
  call findws
  mov rdi, curr
  mov rsi, rax
  mov curr, rax
  call atosl

  mov [sequencePtr], rax
  add sequencePtr, 8

  mov rax, curr
  mov al, [rax]

  inc QWORD curr

  cmp al, 0xa
  jne .readLineLoop

  mov rax, SLONG_MIN
  mov [sequencePtr], rax
  add sequencePtr, 8

.calculateTrendLoop:

  mov prevSequencePtr, [sequenceStackPtr - 8]
  add prevSequencePtr, 8

  mov rdi, 256 * 8
  call alloc

  mov [sequenceStackPtr], rax
  add sequenceStackPtr, 8

  mov sequencePtr, [sequenceStackPtr - 8]

.calculateTrendOnceLoop:

  mov rax, [prevSequencePtr]
  sub rax, [prevSequencePtr - 8]
  mov [sequencePtr], rax
  add sequencePtr, 8
  or zeroCheck, rax

  add prevSequencePtr, 8

  mov rax, SLONG_MIN
  cmp QWORD [prevSequencePtr], rax
  jne .calculateTrendOnceLoop

  mov rax, SLONG_MIN
  mov [sequencePtr], rax
  add sequencePtr, 8

  cmp QWORD zeroCheck, 0
  jne .calculateTrendLoop

  mov prevSequencePtr, [sequenceStackPtr - 8]
  sub sequenceStackPtr, 8

.extrapolateLoop:

  mov sequencePtr, [sequenceStackPtr - 8]
  sub sequenceStackPtr, 8

  mov rax, [sequencePtr]
  sub rax, [prevSequencePtr]
  mov [sequencePtr], rax

  mov prevSequencePtr, sequencePtr

  cmp sequenceStackPtr, sequenceStack
  jne .extrapolateLoop

  mov rax, [prevSequencePtr]
  add accumulator, rax

  mov rax, curr
  cmp rax, eof
  jb .lineLoop

  mov rdi, accumulator
  call putslong
  call newline

  mov dil, 0
  call exit

section .bss
sequenceStack: resq 256