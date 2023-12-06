extern exit, mmap, putlong, newline, findc, atol, alloc, findnl, isnum, findnotnum

section .text

%define accumulator r15
%define parsed rbx
%define currChar r12
%define endOfFile [rsp + 0]
%define size [rsp + 8]
%define currCell r13
%define numLength r15
%define x r13
%define y r14
%define sizer r12
%define negsizer rdi

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 8 * 8

  mov currChar, rax
  lea rdi, [rax + rdx]
  mov endOfFile, rdi

  mov rdi, currChar
  call findnl
  sub rax, rdi
  mov size, rax

  mov rdi, size
  add rdi, 2
  imul rdi, rdi
  shl rdi, 1
  mov r14, rdi
  call alloc

  mov parsed, rax

  mov rdi, rax
  mov rcx, r14
  shr rcx, 1
  mov ax, 0x8000
  rep stosw

  add parsed, size
  add parsed, size
  add parsed, 6

  mov currCell, parsed

.parseLoop:

  cmp BYTE [currChar], 0xa
  jne .notNewline

  inc currChar
  add currCell, 4

  jmp .continueLineLoop
.notNewline:

  cmp BYTE [currChar], '.'
  jne .notDot

  mov ax, 0x8000
  mov [currCell], ax
  inc currChar
  add currCell, 2

  jmp .continueLineLoop
.notDot:

  mov dil, [currChar]
  call isnum
  test al, al
  jz .notNumber

  mov rdi, currChar
  call findnotnum

  mov numLength, rax
  sub numLength, currChar
  
  mov rdi, currChar
  mov rsi, rax
  call atol

.storeLoop:

  mov [currCell], ax
  add currCell, 2
  inc currChar

  dec numLength

  test numLength, numLength
  jnz .storeLoop

  jmp .continueLineLoop
.notNumber:

  mov al, [currChar]
  movzx ax, al
  or ax, 0x8000
  mov [currCell], ax
  inc currChar
  add currCell, 2

.continueLineLoop:

  cmp currChar, endOfFile
  jb .parseLoop

  mov accumulator, 0
  mov sizer, size
  mov negsizer, sizer
  neg negsizer

.yLoop:

  mov x, 0

.xLoop:

  cmp WORD [parsed], '*' | 0x8000
  jne .notGear

  mov rbp, 0
  mov QWORD [rsp + 16], 1
  mov QWORD [rsp + 24], 1
  mov QWORD [rsp + 32], 1
  mov QWORD [rsp + 40], 1
  mov QWORD [rsp + 48], 1
  mov QWORD [rsp + 56], 1

  mov ax, [parsed + negsizer * 2 - 4]
  test ax, ax
  js .topNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 16], rax

  jmp .doneTop
.topNotNumber:

  mov ax, [parsed + negsizer * 2 - 6]
  test ax, ax
  js .topLeftNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 16], rax

.topLeftNotNumber:

  mov ax, [parsed + negsizer * 2 - 2]
  test ax, ax
  js .topRightNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 24], rax

.topRightNotNumber:

.doneTop:

  mov ax, [parsed + sizer * 2 + 4]
  test ax, ax
  js .bottomNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 32], rax

  jmp .doneBottom
.bottomNotNumber:

  mov ax, [parsed + sizer * 2 + 2]
  test ax, ax
  js .bottomLeftNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 32], rax

.bottomLeftNotNumber:

  mov ax, [parsed + sizer * 2 + 6]
  test ax, ax
  js .bottomRightNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 40], rax

.bottomRightNotNumber:

.doneBottom:

  mov ax, [parsed - 2]
  test ax, ax
  js .leftNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 48], rax

.leftNotNumber:

  mov ax, [parsed + 2]
  test ax, ax
  js .rightNotNumber

  inc rbp
  movzx rax, ax
  mov [rsp + 56], rax

.rightNotNumber:

  cmp rbp, 2
  jne .notGear

  mov rax, [rsp + 16]
  imul rax, [rsp + 24]
  imul rax, [rsp + 32]
  imul rax, [rsp + 40]
  imul rax, [rsp + 48]
  imul rax, [rsp + 56]
  add accumulator, rax

.notGear:

  inc x
  add parsed, 2

  cmp x, sizer
  jb .xLoop

  inc y
  add parsed, 4

  cmp y, sizer
  jb .yLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit