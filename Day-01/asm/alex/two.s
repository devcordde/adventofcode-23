extern exit, mmap, isnum, findnl, putlong, newline

section .text

%define endOfFile r12
%define currLine r13
%define accumulator r14
%define currChar r15
%define currCharb r15b
%define endOfLine rbx

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  mov currLine, rax
  lea endOfFile, [rax + rdx]

.lineLoop:

  mov rdi, currLine
  call findnl
  mov endOfLine, rax

  mov currChar, currLine

.findFirstLoop:

  mov dil, [currChar]
  call isnum
  test al, al
  jz .notDigitFirst

  mov currCharb, [currChar]
  mov dil, currCharb
  sub currCharb, '0'
  movzx currChar, currCharb
  lea accumulator, [accumulator + currChar * 8]
  lea accumulator, [accumulator + currChar * 2]
  jmp .endFindFirstLoop

.notDigitFirst:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 3
  jl .tooShortFirst

  cmp BYTE [currChar + 0], 'o'
  jne .not1First
  cmp BYTE [currChar + 1], 'n'
  jne .not1First
  cmp BYTE [currChar + 2], 'e'
  jne .not1First

  add accumulator, 10
  jmp .endFindFirstLoop

.not1First:

  cmp BYTE [currChar + 0], 't'
  jne .not2First
  cmp BYTE [currChar + 1], 'w'
  jne .not2First
  cmp BYTE [currChar + 2], 'o'
  jne .not2First

  add accumulator, 20
  jmp .endFindFirstLoop

.not2First:

  cmp BYTE [currChar + 0], 's'
  jne .not6First
  cmp BYTE [currChar + 1], 'i'
  jne .not6First
  cmp BYTE [currChar + 2], 'x'
  jne .not6First

  add accumulator, 60
  jmp .endFindFirstLoop

.not6First:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 4
  jl .tooShortFirst

  cmp BYTE [currChar + 0], 'f'
  jne .not4First
  cmp BYTE [currChar + 1], 'o'
  jne .not4First
  cmp BYTE [currChar + 2], 'u'
  jne .not4First
  cmp BYTE [currChar + 3], 'r'
  jne .not4First

  add accumulator, 40
  jmp .endFindFirstLoop

.not4First:

  cmp BYTE [currChar + 0], 'f'
  jne .not5First
  cmp BYTE [currChar + 1], 'i'
  jne .not5First
  cmp BYTE [currChar + 2], 'v'
  jne .not5First
  cmp BYTE [currChar + 3], 'e'
  jne .not5First

  add accumulator, 50
  jmp .endFindFirstLoop

.not5First:

  cmp BYTE [currChar + 0], 'n'
  jne .not9First
  cmp BYTE [currChar + 1], 'i'
  jne .not9First
  cmp BYTE [currChar + 2], 'n'
  jne .not9First
  cmp BYTE [currChar + 3], 'e'
  jne .not9First

  add accumulator, 90
  jmp .endFindFirstLoop

.not9First:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 5
  jl .tooShortFirst

  cmp BYTE [currChar + 0], 't'
  jne .not3First
  cmp BYTE [currChar + 1], 'h'
  jne .not3First
  cmp BYTE [currChar + 2], 'r'
  jne .not3First
  cmp BYTE [currChar + 3], 'e'
  jne .not3First
  cmp BYTE [currChar + 4], 'e'
  jne .not3First

  add accumulator, 30
  jmp .endFindFirstLoop

.not3First:

  cmp BYTE [currChar + 0], 's'
  jne .not7First
  cmp BYTE [currChar + 1], 'e'
  jne .not7First
  cmp BYTE [currChar + 2], 'v'
  jne .not7First
  cmp BYTE [currChar + 3], 'e'
  jne .not7First
  cmp BYTE [currChar + 4], 'n'
  jne .not7First

  add accumulator, 70
  jmp .endFindFirstLoop

.not7First:

  cmp BYTE [currChar + 0], 'e'
  jne .not8First
  cmp BYTE [currChar + 1], 'i'
  jne .not8First
  cmp BYTE [currChar + 2], 'g'
  jne .not8First
  cmp BYTE [currChar + 3], 'h'
  jne .not8First
  cmp BYTE [currChar + 4], 't'
  jne .not8First

  add accumulator, 80
  jmp .endFindFirstLoop

.not8First:

.tooShortFirst:

  inc currChar

  jmp .findFirstLoop
.endFindFirstLoop:

  lea currChar, [endOfLine - 1]

.findLastLoop:

  mov dil, [currChar]
  call isnum
  test al, al
  jz .notDigitLast

  mov currCharb, [currChar]
  sub currCharb, '0'
  movzx currChar, currCharb
  add accumulator, currChar
  jmp .endFindLastLoop

.notDigitLast:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 3
  jl .tooShortLast

  cmp BYTE [currChar + 0], 'o'
  jne .not1Last
  cmp BYTE [currChar + 1], 'n'
  jne .not1Last
  cmp BYTE [currChar + 2], 'e'
  jne .not1Last

  add accumulator, 1
  jmp .endFindLastLoop

.not1Last:

  cmp BYTE [currChar + 0], 't'
  jne .not2Last
  cmp BYTE [currChar + 1], 'w'
  jne .not2Last
  cmp BYTE [currChar + 2], 'o'
  jne .not2Last

  add accumulator, 2
  jmp .endFindLastLoop

.not2Last:

  cmp BYTE [currChar + 0], 's'
  jne .not6Last
  cmp BYTE [currChar + 1], 'i'
  jne .not6Last
  cmp BYTE [currChar + 2], 'x'
  jne .not6Last

  add accumulator, 6
  jmp .endFindLastLoop

.not6Last:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 4
  jl .tooShortLast

  cmp BYTE [currChar + 0], 'f'
  jne .not4Last
  cmp BYTE [currChar + 1], 'o'
  jne .not4Last
  cmp BYTE [currChar + 2], 'u'
  jne .not4Last
  cmp BYTE [currChar + 3], 'r'
  jne .not4Last

  add accumulator, 4
  jmp .endFindLastLoop

.not4Last:

  cmp BYTE [currChar + 0], 'f'
  jne .not5Last
  cmp BYTE [currChar + 1], 'i'
  jne .not5Last
  cmp BYTE [currChar + 2], 'v'
  jne .not5Last
  cmp BYTE [currChar + 3], 'e'
  jne .not5Last

  add accumulator, 5
  jmp .endFindLastLoop

.not5Last:

  cmp BYTE [currChar + 0], 'n'
  jne .not9Last
  cmp BYTE [currChar + 1], 'i'
  jne .not9Last
  cmp BYTE [currChar + 2], 'n'
  jne .not9Last
  cmp BYTE [currChar + 3], 'e'
  jne .not9Last

  add accumulator, 9
  jmp .endFindLastLoop

.not9Last:

  mov rax, endOfLine
  sub rax, currChar
  cmp rax, 5
  jl .tooShortLast

  cmp BYTE [currChar + 0], 't'
  jne .not3Last
  cmp BYTE [currChar + 1], 'h'
  jne .not3Last
  cmp BYTE [currChar + 2], 'r'
  jne .not3Last
  cmp BYTE [currChar + 3], 'e'
  jne .not3Last
  cmp BYTE [currChar + 4], 'e'
  jne .not3Last

  add accumulator, 3
  jmp .endFindLastLoop

.not3Last:

  cmp BYTE [currChar + 0], 's'
  jne .not7Last
  cmp BYTE [currChar + 1], 'e'
  jne .not7Last
  cmp BYTE [currChar + 2], 'v'
  jne .not7Last
  cmp BYTE [currChar + 3], 'e'
  jne .not7Last
  cmp BYTE [currChar + 4], 'n'
  jne .not7Last

  add accumulator, 7
  jmp .endFindLastLoop

.not7Last:

  cmp BYTE [currChar + 0], 'e'
  jne .not8Last
  cmp BYTE [currChar + 1], 'i'
  jne .not8Last
  cmp BYTE [currChar + 2], 'g'
  jne .not8Last
  cmp BYTE [currChar + 3], 'h'
  jne .not8Last
  cmp BYTE [currChar + 4], 't'
  jne .not8Last

  add accumulator, 8
  jmp .endFindLastLoop

.not8Last:

.tooShortLast:

  dec currChar

  jmp .findLastLoop
.endFindLastLoop:

  mov currLine, endOfLine
  inc currLine

  cmp currLine, endOfFile
  jl .lineLoop

  mov rdi, accumulator
  call putlong
call newline

mov dil, 0
call exit