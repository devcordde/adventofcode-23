extern exit, mmap, putlong, newline, streq, puts

section .text

%define curr rbx
%define eof r13
%define SIZE 32
%define x rbp
%define y r12
%define accumulator r15
%define originalReflection r14

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  mov curr, rax
  add rax, rdx
  mov eof, rax

.patternsLoop:
  mov rdi, map
  mov al, 0
  mov rcx, SIZE * SIZE
  rep stosb

  mov rdi, transposed
  mov al, 0
  mov rcx, SIZE * SIZE
  rep stosb

  mov y, 0
.readPatternLoop:
  mov x, 0

.readPatternLineLoop:
  mov al, [curr]
  mov rdi, x
  mov rsi, y
  shl rdi, 5
  shl rsi, 5
  mov [map + x + rsi], al
  mov [transposed + y + rdi], al

  inc x
  inc curr

  cmp BYTE [curr], `\n`
  jne .readPatternLineLoop

  inc curr
  inc y

  cmp BYTE [curr], `\n`
  je .endReadPatternLoop
  cmp curr, eof
  jb .readPatternLoop
.endReadPatternLoop:

  inc curr

  mov rdi, transposed
  mov rsi, 0
  call findReflection
  test rax, rax
  jnz .skipFindOtherOriginalReflection

  mov rdi, map
  mov rsi, 0
  call findReflection
  mov rdi, 100
  imul rax, rdi

.skipFindOtherOriginalReflection:
  mov originalReflection, rax

  mov y, 0
  mov x, 0
.unsmudgeLoop:

.unsmudgeLineLoop:

  mov rdi, x
  mov rsi, y
  shl rdi, 5
  shl rsi, 5

  cmp BYTE [map + x + rsi], '.'
  jne .unsmudgeOneIsHash

  mov BYTE [map + x + rsi], '#'
  mov BYTE [transposed + y + rdi], '#'

  push rsi
  push rdi

  mov rdi, transposed
  mov rsi, 0
  cmp originalReflection, 100
  cmovb rsi, originalReflection
  call findReflection
  test rax, rax
  jnz .skipFindOtherSmudgedReflectionNotHash

  mov rdi, map
  mov rsi, 0
  mov rax, originalReflection
  cqo
  mov rcx, 100
  div rcx
  cmp originalReflection, 100
  cmovge rsi, rax
  call findReflection
  mov rdi, 100
  imul rax, rdi

.skipFindOtherSmudgedReflectionNotHash:

  test rax, rax
  jnz .endUnsmudgeLoop

  pop rdi
  pop rsi

  mov BYTE [map + x + rsi], '.'
  mov BYTE [transposed + y + rdi], '.'

  jmp .endUnsmudgeOne
.unsmudgeOneIsHash:

  mov BYTE [map + x + rsi], '.'
  mov BYTE [transposed + y + rdi], '.'

  push rsi
  push rdi

  mov rdi, transposed
  mov rsi, 0
  cmp originalReflection, 100
  cmovb rsi, originalReflection
  call findReflection
  test rax, rax
  jnz .skipFindOtherSmudgedReflectionHash

  mov rdi, map
  mov rsi, 0
  mov rax, originalReflection
  cqo
  mov rcx, 100
  div rcx
  cmp originalReflection, 100
  cmovge rsi, rax
  call findReflection
  mov rdi, 100
  imul rax, rdi

.skipFindOtherSmudgedReflectionHash:

  test rax, rax
  jnz .endUnsmudgeLoop

  pop rdi
  pop rsi

  mov BYTE [map + x + rsi], '#'
  mov BYTE [transposed + y + rdi], '#'

.endUnsmudgeOne:

  inc x

  cmp BYTE [map + x + rsi], 0
  jne .unsmudgeLineLoop
  
  inc y
  mov x, 0

  mov rsi, y
  shl rsi, 5
  cmp BYTE [map + x + rsi], 0
  jne .unsmudgeLoop
.endUnsmudgeLoop:

  add accumulator, rax

  cmp curr, eof
  jb .patternsLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

%define currRow rcx
%define reflectionRow rdx
%define index rax
%define arry rdi
%define skipIndex rsi

findReflection:
  mov index, 1
  lea currRow, [arry + SIZE]
  mov reflectionRow, arry

.findCandidateLoop:
  cmp index, skipIndex
  je .continueFindCandidateLoop

  push arry
  push reflectionRow
  push index
  push currRow
  push skipIndex
  mov rdi, currRow
  mov rsi, reflectionRow
  call streq
  test al, al
  pop skipIndex
  pop currRow
  pop index
  pop reflectionRow
  pop arry
  jz .continueFindCandidateLoop

  push currRow
  push reflectionRow
.confirmCandidateLoop:
  add currRow, SIZE
  sub reflectionRow, SIZE
  
  cmp BYTE [currRow], 0
  je .isReflection
  cmp reflectionRow, arry
  jb .isReflection

  push arry
  push reflectionRow
  push index
  push currRow
  push skipIndex
  mov rdi, currRow
  mov rsi, reflectionRow
  call streq
  test al, al
  pop skipIndex
  pop currRow
  pop index
  pop reflectionRow
  pop arry
  jnz .confirmCandidateLoop

  pop reflectionRow
  pop currRow

.continueFindCandidateLoop:
  inc index
  add currRow, SIZE
  add reflectionRow, SIZE

  cmp BYTE [currRow], 0
  jne .findCandidateLoop

  mov rax, 0
  ret

.isReflection:
  add rsp, 2 * 8
  ret

section .bss
map: resb SIZE * SIZE
transposed: resb SIZE * SIZE