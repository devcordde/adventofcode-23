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

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 2 * 8

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
  imul rdi, 2
  mov r14, rdi
  call alloc

  mov parsed, rax

  mov rdi, rax
  mov rcx, r14
  mov al, 0
  rep stosb

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

.yLoop:

  mov x, 0

.xLoop:

  bt WORD [parsed], 15
  jnc .notSymbol

  movzx rax, WORD [parsed - 2]
  add accumulator, rax
  movzx rax, WORD [parsed + 2]
  add accumulator, rax
  mov rdi, sizer
  neg rdi
  movzx rax, WORD [parsed + 2 * rdi - 4]
  add accumulator, rax
  movzx rax, WORD [parsed + 2 * sizer + 4]
  add accumulator, rax

  mov ax, WORD [parsed + 2 * rdi - 4]
  test ax, ax
  jnz .skipTop

  movzx rax, WORD [parsed + 2 * rdi - 6]
  add accumulator, rax
  movzx rax, WORD [parsed + 2 * rdi - 2]
  add accumulator, rax

.skipTop:

  mov ax, WORD [parsed + 2 * sizer + 4]
  test ax, ax
  jnz .skipBottom

  movzx rax, WORD [parsed + 2 * sizer + 2]
  add accumulator, rax
  movzx rax, WORD [parsed + 2 * sizer + 6]
  add accumulator, rax

.skipBottom:

.notSymbol:

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