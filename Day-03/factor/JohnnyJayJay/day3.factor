! SPDX-License-Identifier: 0BSD
USING: accessors ranges combinators.smart sequences regexp strings math math.parser io io.encodings.utf8 io.files io.pathnames kernel prettyprint ;
IN: aoc.day3

: symbol? ( ch/f -- ? )
    [ [ digit? ] [ CHAR: . = ] bi or not ] [ f ] if* ;

: ?deep-nth ( idx-seq seq -- elt/f )
    [ swap ?nth ] reduce ;

: block ( from to line-idx -- seq )
    '[ _ dup [ 1 - ] [ 1 + ] bi ] output>array
    -rot [ 1 - ] dip [a..b]
    cartesian-product concat ;

: numbers ( line-idx grid -- seq )
    2dup nth R/ \d+/ all-matching-slices -rot
    '[ dup >slice< drop  _ block [ _ ?deep-nth symbol? ] any? [ string>number ] [ drop 0 ] if ] map ;

: part-number-sum ( grid -- n )
    dup '[ _ numbers sum nip ] map-index sum ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines dup
part-number-sum .
