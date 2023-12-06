extern exit, mmap, putlong, newline, atol, skipws, findws

section .text

%define curr r12
%define endOfFile [rsp + 0]
%define endOfWinning r13
%define numMatching r14
%define numMatchingb r14b
%define cardNum r15
%define accumulator [rsp + 8]

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 2 * 8

  mov curr, rax
  add rax, rdx
  mov endOfFile, rax

  mov cardNum, 0

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
  
  mov [cardWins + cardNum * 8], numMatching
  mov QWORD [cardCounts + cardNum * 8], 1

  inc curr
  inc cardNum

  cmp curr, endOfFile
  jb .lineLoop

  mov QWORD accumulator, 0

  mov cardNum, 0

.cardSummingLoop:

  mov rax, [cardWins + cardNum * 8]
  add rax, cardNum

  mov rsi, [cardCounts + cardNum * 8]

.cardAddingLoop:
  cmp rax, cardNum
  jbe .endCardAddingLoop

  add [cardCounts + rax * 8], rsi
  dec rax
  jmp .cardAddingLoop

.endCardAddingLoop:

  mov rax, [cardCounts + cardNum * 8]
  add accumulator, rax

  inc cardNum

  mov rax, [cardCounts + cardNum * 8]
  test rax, rax
  jnz .cardSummingLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

section .bss

winning: resb 10
cardWins: resq 214
cardCounts: resq 215