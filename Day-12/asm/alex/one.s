extern exit, mmap, putlong, findnotnum, atol, newline

section .text

%define curr rbx
%define eof [rsp + 0]
%define accumulator [rsp + 8]
%define springPtr rbp
%define runPtr r12
%define OPERATIONAL 0b00000001
%define DAMAGED     0b00000010
%define unknownPtr r13

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 2 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax

  mov QWORD accumulator, 0
.lineLoop:
  mov springPtr, springs
  mov runPtr, runs
  mov unknownPtr, unknowns

.readSprings:
  mov al, [curr]

  cmp al, '.'
  jne .readSpringsNotDot

  mov BYTE [springPtr], OPERATIONAL
  inc springPtr

  inc curr

  jmp .readSprings
.readSpringsNotDot:

  cmp al, '#'
  jne .readSpringsNotHash

  mov BYTE [springPtr], DAMAGED
  inc springPtr

  inc curr

  jmp .readSprings
.readSpringsNotHash:

  cmp al, '?'
  jne .readSpringsNotQuestion

  mov BYTE [springPtr], OPERATIONAL
  mov [unknownPtr], springPtr
  inc springPtr
  add unknownPtr, 8

  inc curr

  jmp .readSprings
.readSpringsNotQuestion:

  mov BYTE [springPtr], 0
  mov QWORD [unknownPtr], 0

.readRuns:
  inc curr

  mov rdi, curr
  call findnotnum
  mov rdi, curr
  mov rsi, rax
  mov curr, rax
  call atol

  mov [runPtr], rax
  add runPtr, 8

  cmp BYTE [curr], `\n`
  jne .readRuns

  mov QWORD [runPtr], 0

  inc curr

.countPossibiltiesLoop:
  mov rdi, springs
  mov rsi, runs
  call checkValid
  add accumulator, rax

  mov rdi, unknowns
  mov rsi, unknownPtr
  call increment

  test rax, rax
  jz .countPossibiltiesLoop

  cmp curr, eof
  jb .lineLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

%define currRun rax
%define runs rsi
%define springs rdi

checkValid:
  mov currRun, [runs]
  add runs, 8

.checkRuns:

.skipInitOperational:
  test BYTE [springs], OPERATIONAL
  jz .endSkipInitOperational

  inc springs

  jmp .skipInitOperational
.endSkipInitOperational:

.checkDamagedRun:
  test BYTE [springs], DAMAGED
  jz .endCheckDamagedRun

  dec currRun
  inc springs

  jmp .checkDamagedRun
.endCheckDamagedRun:

  test currRun, currRun
  jnz .false

  mov currRun, [runs]
  add runs, 8

  test currRun, currRun
  jnz .checkRuns

.checkTail:
  cmp BYTE [springs], 0
  je .true

  test BYTE [springs], DAMAGED
  jnz .false

  inc springs

  jmp .checkTail

.false:
  mov rax, 0
  ret

.true:
  mov rax, 1
  ret

%undef springs
%undef runs
%undef currRun

%define carry al
%define currDigitPtr rdi
%define endOfDigits rsi
%define currDigit rdx

increment:
  mov carry, 1

.incrementLoop:
  mov currDigit, [currDigitPtr]

.isOne:

  and BYTE [currDigit], ~OPERATIONAL
  or BYTE [currDigit], DAMAGED
  mov carry, 0
  ret

.isOne:

  and BYTE [currDigit], ~DAMAGED
  or BYTE [currDigit], OPERATIONAL

  add currDigitPtr, 8

  cmp currDigitPtr, endOfDigits
  jb .incrementLoop

  ret

%undef currDigit
%undef endOfDigits
%undef currDigitPtr
%undef carry

section .bss
springs: resb 32
unknowns: resq 32
runs: resq 16
