extern exit, mmap, putlong, newline, findws, atol, skipws, isnum, minlong

section .text

%define curr r12
%define arryPtr r13
%define mapPtr r13
%define endOfFile r14

global _start:function
_start:
mov rdi, [rsp + 16]
call mmap

mov curr, rax
add rax, rdx
mov endOfFile, rax

add curr, 7
mov arryPtr, seeds
call readTextTerminatedNumbers

add curr, 18
mov arryPtr, seedToSoilMap
call readTextTerminatedNumbers

add curr, 24
mov arryPtr, soilToFertilizerMap
call readTextTerminatedNumbers

add curr, 25
mov arryPtr, fertilizerToWaterMap
call readTextTerminatedNumbers

add curr, 20
mov arryPtr, waterToLightMap
call readTextTerminatedNumbers

add curr, 26
mov arryPtr, lightToTemperatureMap
call readTextTerminatedNumbers

add curr, 29
mov arryPtr, temperatureToHumidityMap
call readTextTerminatedNumbers

add curr, 26
mov arryPtr, humidityToLocationMap
call readEofTerminatedNumbers

mov curr, seeds
mov mapPtr, seedToSoilMap
call applyMapToRange

mov curr, seeds
mov mapPtr, soilToFertilizerMap
call applyMapToRange

mov curr, seeds
mov mapPtr, fertilizerToWaterMap
call applyMapToRange

mov curr, seeds
mov mapPtr, waterToLightMap
call applyMapToRange

mov curr, seeds
mov mapPtr, lightToTemperatureMap
call applyMapToRange

mov curr, seeds
mov mapPtr, temperatureToHumidityMap
call applyMapToRange

mov curr, seeds
mov mapPtr, humidityToLocationMap
call applyMapToRange

mov rdi, seeds
mov rsi, seeds
.findEndLoop:
cmp QWORD [rsi], 0
je .findEndLoopEnd

add rsi, 8

jmp .findEndLoop
.findEndLoopEnd:

call minlong

mov rdi, rax
call putlong
call newline

mov dil, 0
call exit

applyMapToRange:
mov rdi, mapPtr
mov rsi, [curr]
call applyMapToElement
mov [curr], rax

add curr, 8

cmp QWORD [curr], 0
jne applyMapToRange

ret

applyMapToElement:
mov rax, rsi

.loop:
cmp QWORD [rdi + 2 * 8], 0
je .loopEnd

mov rsi, [rdi + 1 * 8]
cmp rax, rsi
jb .continueLoop
add rsi, [rdi + 2 * 8]
cmp rax, rsi
jae .continueLoop

sub rax, [rdi + 1 * 8]
add rax, [rdi + 0 * 8]
jmp .loopEnd

.continueLoop:

add rdi, 3 * 8

jmp .loop
.loopEnd:
ret

readTextTerminatedNumbers:
mov rdi, curr
call findws
mov rsi, rax
mov curr, rax
call atol
mov [arryPtr], rax

mov rdi, curr
call skipws
mov curr, rax

add arryPtr, 8

mov dil, [curr]
call isnum
test al, al
jnz readTextTerminatedNumbers

ret

readEofTerminatedNumbers:
mov rdi, curr
call findws
mov rsi, rax
mov curr, rax
call atol
mov [arryPtr], rax

inc curr

add arryPtr, 8

cmp curr, endOfFile
jb readEofTerminatedNumbers

ret

section .bss

seeds: resq 32
seedToSoilMap: resq 128 * 3
soilToFertilizerMap: resq 128 * 3
fertilizerToWaterMap: resq 128 * 3
waterToLightMap: resq 128 * 3
lightToTemperatureMap: resq 128 * 3
temperatureToHumidityMap: resq 128 * 3
humidityToLocationMap: resq 128 * 3