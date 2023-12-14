extern exit, mmap, putlong, newline, alloc

section .text

%define curr rbx
%define eof [rsp + 0]
%define SIZE 128
%define x rbp
%define y r12
%define lastLine [rsp + 0]
%define map r13
%define mapPtr r14

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 1 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax

  mov mapPtr, maps

  mov rdi, SIZE * SIZE
  call alloc
  mov [mapPtr], rax
  add mapPtr, 8

  mov map, [mapPtr - 8]

  mov y, 0
.readLoop:

  mov x, 0
.readLineLoop:
  mov rdi, map
  add rdi, x
  add rdi, y

  mov al, [curr]
  mov [rdi], al

  inc curr
  inc x

  cmp BYTE [curr], `\n`
  jne .readLineLoop

  inc curr
  add y, SIZE

  cmp curr, eof
  jb .readLoop

  mov lastLine, y

.findCycleLoop:
  mov rdi, SIZE * SIZE
  call alloc
  mov [mapPtr], rax
  add mapPtr, 8

  mov rdi, [mapPtr - 8]
  mov rsi, [mapPtr - 16]
  call spinCycle

  mov curr, maps
.checkCycleLoop:
  mov rdi, [mapPtr - 8]
  mov rsi, [curr]
  mov rcx, SIZE * SIZE
  repe cmpsb
  jne .continueCheckCycleLoop

  mov rdi, curr
  sub rdi, maps
  shr rdi, 3

  lea rsi, [mapPtr - 8]
  sub rsi, curr
  shr rsi, 3

  jmp .endFindCycleLoop
.continueCheckCycleLoop:

  add curr, 8

  lea rax, [mapPtr - 8]
  cmp curr, rax
  jb .checkCycleLoop

  jmp .findCycleLoop
.endFindCycleLoop:

  mov rax, 1000000000
  sub rax, rdi
  cqo
  div rsi
  add rdi, rdx
  
  mov rdi, [maps + rdi * 8]
  mov rsi, lastLine
  call calculateLoad

  mov rdi, rax
  call putlong
  call newline

  mov dil, 0
  call exit

%define map r8
%define changed sil
%define x rdx
%define y rcx

spinCycle:
  mov map, rdi

  mov rcx, SIZE * SIZE
  rep movsb

.rollNorthLoop:
  mov changed, 0

  mov y, SIZE
.rollNorthOnceLoop:

  mov x, 0
.rollLineNorthOnceLoop:
  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 'O'
  jne .continueRollLineNorthOnceLoop

  cmp BYTE [rax - SIZE], '.'
  jne .continueRollLineNorthOnceLoop

  mov BYTE [rax], '.'
  mov BYTE [rax - SIZE], 'O'
  mov changed, 1

.continueRollLineNorthOnceLoop:

  inc x

  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 0
  jne .rollLineNorthOnceLoop

  add y, SIZE

  cmp BYTE [map + y], 0
  jne .rollNorthOnceLoop

  test changed, changed
  jnz .rollNorthLoop

.rollWestLoop:
  mov changed, 0

  mov y, 0
.rollWestOnceLoop:

  mov x, 1
.rollLineWestOnceLoop:
  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 'O'
  jne .continueRollLineWestOnceLoop

  cmp BYTE [rax - 1], '.'
  jne .continueRollLineWestOnceLoop

  mov BYTE [rax], '.'
  mov BYTE [rax - 1], 'O'
  mov changed, 1

.continueRollLineWestOnceLoop:

  inc x

  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 0
  jne .rollLineWestOnceLoop

  add y, SIZE

  cmp BYTE [map + y], 0
  jne .rollWestOnceLoop

  test changed, changed
  jnz .rollWestLoop
  
.rollSouthLoop:
  mov changed, 0

  mov y, 0
.rollSouthOnceLoop:

  mov x, 0
.rollLineSouthOnceLoop:
  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 'O'
  jne .continueRollLineSouthOnceLoop

  cmp BYTE [rax + SIZE], '.'
  jne .continueRollLineSouthOnceLoop

  mov BYTE [rax], '.'
  mov BYTE [rax + SIZE], 'O'
  mov changed, 1

.continueRollLineSouthOnceLoop:

  inc x

  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 0
  jne .rollLineSouthOnceLoop

  add y, SIZE

  cmp BYTE [map + y + SIZE], 0
  jne .rollSouthOnceLoop

  test changed, changed
  jnz .rollSouthLoop

.rollEastLoop:
  mov changed, 0

  mov y, 0
.rollEastOnceLoop:

  mov x, 0
.rollLineEastOnceLoop:
  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax], 'O'
  jne .continueRollLineEastOnceLoop

  cmp BYTE [rax + 1], '.'
  jne .continueRollLineEastOnceLoop

  mov BYTE [rax], '.'
  mov BYTE [rax + 1], 'O'
  mov changed, 1

.continueRollLineEastOnceLoop:

  inc x

  mov rax, map
  add rax, x
  add rax, y

  cmp BYTE [rax + 1], 0
  jne .rollLineEastOnceLoop

  add y, SIZE

  cmp BYTE [map + y], 0
  jne .rollEastOnceLoop

  test changed, changed
  jnz .rollEastLoop

  ret

%undef map
%undef x
%undef y
%undef changed

%define map rdi
%define y rsi
%define x rdx

calculateLoad:
  mov lineIndex, 0
  mov accumulator, 0
.calculateLoadLoop:
  sub y, SIZE
  inc lineIndex

  mov x, 0
.calculateLineLoadLoop:
  mov r8, map
  add r8, y
  add r8, x

  cmp BYTE [r8], 'O'
  jne .continueCalculateLineLoadLoop

  add accumulator, lineIndex

.continueCalculateLineLoadLoop:
  inc x

  mov r8, map
  add r8, y
  add r8, x

  cmp BYTE [r8], 0
  jne .calculateLineLoadLoop

  cmp y, 0
  jne .calculateLoadLoop

  ret

%undef map
%undef y
%undef x

section .bss
maps: resq 4096