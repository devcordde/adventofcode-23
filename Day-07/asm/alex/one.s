extern exit, mmap, putlong, newline, findnl, atol

section .text

%define curr r12
%define eof [rsp + 0]
%define arryPtr r13
%define accumulator r12
%define arryIdx r13

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 1 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax

  mov arryPtr, hands
.readLoop:

  call readHandChar
  call readHandChar
  call readHandChar
  call readHandChar
  call readHandChar

  inc curr
  inc arryPtr

  mov rdi, curr
  call findnl
  mov rdi, curr
  mov rsi, rax
  mov curr, rax
  call atol

  mov [arryPtr], ax

  add arryPtr, 2
  inc curr

  cmp curr, eof
  jb .readLoop

  mov rdi, hands
  mov rsi, hands
.findEndOfHandsLoop:

  add rsi, 8

  cmp QWORD [rsi], 0
  jne .findEndOfHandsLoop
  call qsortHands

  mov accumulator, 0
  mov arryIdx, 0
.sumBidsLoop:

  mov ax, [hands + arryIdx * 8 + 6]
  movzx rax, ax

  inc arryIdx

  imul rax, arryIdx
  add accumulator, rax

  cmp QWORD [hands + arryIdx * 8], 0
  jne .sumBidsLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

readHandChar:

  cmp BYTE [curr], 'A'
  jne .notAce

  mov BYTE [arryPtr], 14

  jmp .end
.notAce:

  cmp BYTE [curr], 'K'
  jne .notKing

  mov BYTE [arryPtr], 13

  jmp .end
.notKing:

  cmp BYTE [curr], 'Q'
  jne .notQueen

  mov BYTE [arryPtr], 12

  jmp .end
.notQueen:

  cmp BYTE [curr], 'J'
  jne .notJack

  mov BYTE [arryPtr], 11

  jmp .end
.notJack:

  cmp BYTE [curr], 'T'
  jne .notTen

  mov BYTE [arryPtr], 10

  jmp .end
.notTen:

  mov al, [curr]
  sub al, '0'
  mov [arryPtr], al

.end:

  inc curr
  inc arryPtr
  ret

%define end [rsp + 0]
%define start [rsp + 8]
%define pivot [rsp + 16]

qsortHands:

  cmp rdi, rsi
  je .end

  sub rsp, 3 * 8

  mov end, rsi
  mov start, rdi

  mov rdx, [rdi]
  mov rsi, rdi

.loop:

  push rdi
  push rdx
  push rsi

  mov rdi, [rsi]
  mov rsi, rdx
  call compareHands
  cmp rax, 0

  pop rsi
  pop rdx
  pop rdi

  jge .continue

  mov rax, [rsi]
  mov [rdi], rax
  
  mov rax, [rdi + 8]
  mov [rsi], rax

  add rdi, 8

.continue:
  add rsi, 8

  cmp rsi, end
  jl .loop

  mov [rdi], rdx
  mov pivot, rdi

  mov rdi, start
  mov rsi, pivot
  call qsortHands

  mov rdi, pivot
  add rdi, 8
  mov rsi, end
  call qsortHands

  add rsp, 3 * 8

.end:
  ret

compareHands:
  push rdi
  push rsi
  call compareRank
  pop rsi
  pop rdi
  cmp rax, 0
  jne .end

  bswap rdi
  shr rdi, 24
  bswap rsi
  shr rsi, 24
  sub rdi, rsi
  mov rax, rdi

.end:
  ret

compareRank:
  push rsi
  call getHandRank
  pop rdi

  push rax
  call getHandRank
  mov rdi, rax
  pop rax

  sub rax, rdi
  ret

getHandRank:
  mov [handBuffer], rdi

  mov rdi, counts + 2 * 8
  mov rcx, 13
  mov rax, 1
  rep stosq

  mov al, [handBuffer + 0]
  inc QWORD [counts + rax * 8]
  mov al, [handBuffer + 1]
  inc QWORD [counts + rax * 8]
  mov al, [handBuffer + 2]
  inc QWORD [counts + rax * 8]
  mov al, [handBuffer + 3]
  inc QWORD [counts + rax * 8]
  mov al, [handBuffer + 4]
  inc QWORD [counts + rax * 8]

  mov rdi, 0
  mov rsi, counts + 2 * 8
  mov rcx, 13

.productLoop:

  lodsq
  imul rax, rax
  add rdi, rax

  loop .productLoop

  mov rax, rdi
  ret

section .bss

hands: resq 1001
handBuffer: resq 1
counts: resq 15