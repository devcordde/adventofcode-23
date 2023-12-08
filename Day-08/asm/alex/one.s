extern exit, mmap, putlong, newline

section .text

%define curr r12
%define eof [rsp + 0]
%define arryPtr r13
%define twentysix r13
%define currPlace r12
%define currStep r13
%define stepCount r14

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 1 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax

  mov al, 0xff
  mov rdi, instructions
  mov rcx, 1024
  rep stosb

  mov eax, 0xffffffff
  mov rdi, map
  mov rcx, 17576
  rep stosd

  mov arryPtr, instructions

.readInstructionsLoop:
  mov al, 0
  mov dil, 2
  cmp BYTE [curr], 'R'
  cmove ax, di
  mov [arryPtr], al

  inc curr
  inc arryPtr

  cmp BYTE [curr], 0xa
  jne .readInstructionsLoop

  add curr, 2

  mov twentysix, 26

.readMapLoop:
  mov al, BYTE [curr + 0]
  movzx rax, al
  sub rax, 'A'
  imul rax, twentysix
  imul rax, twentysix

  mov dil, BYTE [curr + 1]
  movzx rdi, dil
  sub rdi, 'A'
  imul rdi, twentysix
  add rax, rdi

  mov dil, BYTE [curr + 2]
  movzx rdi, dil
  sub rdi, 'A'
  add rax, rdi

  add curr, 7

  mov dil, BYTE [curr + 0]
  movzx rdi, dil
  sub rdi, 'A'
  imul rdi, twentysix
  imul rdi, twentysix

  mov sil, BYTE [curr + 1]
  movzx rsi, sil
  sub rsi, 'A'
  imul rsi, twentysix
  add rdi, rsi

  mov sil, BYTE [curr + 2]
  movzx rsi, sil
  sub rsi, 'A'
  add rdi, rsi

  add curr, 5

  mov sil, BYTE [curr + 0]
  movzx rsi, sil
  sub rsi, 'A'
  imul rsi, twentysix
  imul rsi, twentysix

  mov dl, BYTE [curr + 1]
  movzx rdx, dl
  sub rdx, 'A'
  imul rdx, twentysix
  add rsi, rdx

  mov dl, BYTE [curr + 2]
  movzx rdx, dl
  sub rdx, 'A'
  add rsi, rdx

  add curr, 5

  mov [map + rax * 4], di
  mov [map + rax * 4 + 2], si

  cmp curr, eof
  jb .readMapLoop

  mov currPlace, map
  mov currStep, instructions
  mov stepCount, 0

.traverseLoop:
  mov al, [currStep]
  movzx rax, al

  mov ax, [currPlace + rax]
  movzx rax, ax

  lea currPlace, [map + rax * 4]

  inc currStep
  mov rax, instructions
  cmp BYTE [currStep], 0xff
  cmove currStep, rax

  inc stepCount

  cmp currPlace, map + 17575 * 4
  jne .traverseLoop

  mov rdi, stepCount
  call putlong
  call newline

  mov dil, 0
  call exit

section .bss
instructions: resb 1024
map: resd 17576