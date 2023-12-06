! SPDX-License-Identifier: 0BSD
USING: arrays command-line io io.encodings.utf8 io.files io.pathnames kernel
math math.quadratic math.functions math.parser namespaces prettyprint regexp
sequences strings ;
IN: aoc.day6

: parse-input ( time distance -- pairs )
    [ R/ \d+/ all-matching-slices [ string>number ] map ] bi@ [ 2array ] 2map ;

: win-opportunities ( race -- n )
    first2 neg swap -1 quadratic [ ceiling ] [ floor ] bi* - - 1 >fixnum ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines first2
[ parse-input [ win-opportunities ] map product . ]
[ [ [ CHAR: \s = ] reject ] bi@ parse-input first win-opportunities . ]
2bi
