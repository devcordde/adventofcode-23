extern exit, mmap, putlong, newline, atol, skipws, findws

section .text

%define accumulator [rsp + 0]
%define curr r12
%define endOfFile [rsp + 8]
%define endOfWinning r13
%define numMatching r14
%define numMatchingb r14b

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 2 * 8

  mov curr, rax
  add rax, rdx
  mov endOfFile, rax

  mov QWORD accumulator, 0

.lineLoop:

  mov endOfWinning, winning
  mov numMatching, 0

  add curr, 4

  mov rdi, curr
  call skipws
  mov curr, rax

  mov rdi, curr
  call findws
  mov curr, rax

.readWinningLoop:

  mov rdi, curr
  call skipws
  mov curr, rax

  cmp BYTE [curr], '|'
  je .endReadWinningLoop

  mov rdi, curr
  call findws
  mov rsi, rax
  mov curr, rax
  call atol
  mov [endOfWinning], al
  inc endOfWinning
  
  jmp .readWinningLoop

.endReadWinningLoop:

  inc curr

.readHaveLoop:

  mov rdi, curr
  call skipws
  mov curr, rax

  mov rdi, curr
  call findws
  mov rsi, rax
  mov curr, rax
  call atol

  mov rdi, winning

.checkWinningLoop:

  cmp [rdi], al
  jne .continueCheckWinningLoop

  inc numMatching
  jmp .endCheckWinningLoop

.continueCheckWinningLoop:
  inc rdi

  cmp rdi, endOfWinning
  jb .checkWinningLoop
.endCheckWinningLoop:

  cmp BYTE [curr], 0xa
  jne .readHaveLoop

  test numMatching, numMatching
  jz .noneToAdd

  dec numMatching
  mov cl, numMatchingb
  mov rax, 1
  shl rax, cl
  add accumulator, rax

.noneToAdd:

  inc curr

  cmp curr, endOfFile
  jb .lineLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

section .bss

winning: resb 10