extern exit, mmap, putlong, newline, alloc

section .text

%define curr rbx
%define eof [rsp + 0]
%define galaxySize (2 * 8)
%define galaxyPtr rbp
%define x r12
%define y r13
%define endOfGalaxies [rsp + 0]
%define maxX [rsp + 8]
%define maxY [rsp + 16]
%define accumulator r15
%define firstGalaxyPtr rbx
%define secondGalaxyPtr rbp

global _start:function
_start:
  mov rdi, [rsp + 16]
  call mmap

  sub rsp, 1 * 8

  mov curr, rax
  add rax, rdx
  mov eof, rax

  mov y, 0
  mov galaxyPtr, galaxies
.readLinesLoop:

  mov x, 0
.readLineLoop:

  cmp BYTE [curr], '#'
  jne .continueReadLineLoop

  mov [galaxyPtr + 0], x
  mov [galaxyPtr + 8], y
  add galaxyPtr, galaxySize

.continueReadLineLoop:

  inc x
  inc curr

  cmp BYTE [curr], 0xa
  jne .readLineLoop

  inc y
  inc curr

  cmp curr, eof
  jb .readLinesLoop

  mov endOfGalaxies, galaxyPtr

  mov QWORD maxX, 0
  mov QWORD maxY, 0

  mov galaxyPtr, galaxies
.findMaxLoop:

  mov rax, [galaxyPtr + 0]
  cmp rax, maxX
  jng .findMaxLoopKeepX

  mov maxX, rax

.findMaxLoopKeepX:

  mov rax, [galaxyPtr + 8]
  cmp rax, maxY
  jng .findMaxLoopKeepY

  mov maxY, rax

.findMaxLoopKeepY:

  add galaxyPtr, galaxySize

  cmp galaxyPtr, endOfGalaxies
  jb .findMaxLoop

  mov x, 0
.expandXLoop:

  mov galaxyPtr, galaxies
.checkXLoop:

  cmp x, [galaxyPtr + 0]
  je .continueExpandXLoop

  add galaxyPtr, galaxySize

  cmp galaxyPtr, endOfGalaxies
  jb .checkXLoop

  mov galaxyPtr, galaxies
.doExpandXLoop:

  cmp x, [galaxyPtr + 0]
  jge .continueDoExpandXLoop

  add QWORD [galaxyPtr + 0], (1000000 - 1)

.continueDoExpandXLoop:

  add galaxyPtr, galaxySize

  cmp galaxyPtr, endOfGalaxies
  jb .doExpandXLoop

  add x, (1000000 - 1)
  add QWORD maxX, (1000000 - 1)

.continueExpandXLoop:
  inc x

  cmp x, maxX
  jb .expandXLoop

  mov y, 0
.expandYLoop:

  mov galaxyPtr, galaxies
.checkYLoop:

  cmp y, [galaxyPtr + 8]
  je .continueExpandYLoop

  add galaxyPtr, galaxySize

  cmp galaxyPtr, endOfGalaxies
  jb .checkYLoop

  mov galaxyPtr, galaxies
.doExpandYLoop:

  cmp y, [galaxyPtr + 8]
  jge .continueDoExpandYLoop

  add QWORD [galaxyPtr + 8], (1000000 - 1)

.continueDoExpandYLoop:

  add galaxyPtr, galaxySize

  cmp galaxyPtr, endOfGalaxies
  jb .doExpandYLoop

  add y, (1000000 - 1)
  add QWORD maxY, (1000000 - 1)

.continueExpandYLoop:
  inc y

  cmp y, maxY
  jb .expandYLoop

  mov accumulator, 0
  mov firstGalaxyPtr, galaxies
.calculateDistancesLoop:

  lea secondGalaxyPtr, [firstGalaxyPtr + galaxySize]
.calculatePairDistancesLoop:
  cmp secondGalaxyPtr, endOfGalaxies
  jnb .endCalculatePairDistancesLoop

  mov rdi, firstGalaxyPtr
  mov rsi, secondGalaxyPtr
  call taxicab
  add accumulator, rax

  add secondGalaxyPtr, galaxySize

  jmp .calculatePairDistancesLoop
.endCalculatePairDistancesLoop:

  add firstGalaxyPtr, galaxySize

  cmp firstGalaxyPtr, endOfGalaxies
  jb .calculateDistancesLoop

  mov rdi, accumulator
  call putlong
  call newline

  mov dil, 0
  call exit

taxicab:
  movdqu xmm1, [rdi]
  movdqu xmm2, [rsi]
  psubq xmm1, xmm2
  movdqu [rsp - 16], xmm1

  mov rdi, [rsp - 16]
  test rdi, rdi
  jns .xNotNegative
  
  neg rdi

.xNotNegative:

  mov rsi, [rsp - 8]
  test rsi, rsi
  jns .yNotNegative

  neg rsi

.yNotNegative:

  mov rax, rdi
  add rax, rsi
  ret

section .bss
galaxies: resq galaxySize * 512