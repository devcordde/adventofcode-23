! SPDX-License-Identifier: 0BSD
USING: ascii assocs combinators.smart command-line hashtables io
io.encodings.utf8 io.files io.pathnames kernel math math.parser
namespaces prettyprint ranges regexp sequences sets strings ;
IN: aoc.day3

: symbol? ( ch/f -- ? )
    [ [ digit? ] [ CHAR: . = ] bi or not ] [ f ] if* ;

: ?deep-nth ( idx-seq seq -- elt/f )
    [ swap ?nth ] reduce ;

: block ( from to line-idx -- seq )
    '[ _ dup [ 1 - ] [ 1 + ] bi ] output>array
    -rot [ 1 - ] dip [a..b]
    cartesian-product concat ;

: into-part-map ( line-idx grid part-map -- )
    [ 2dup nth R/ \d+/ all-matching-slices -rot ] dip
    '[ dup >slice< drop _ block [ _ ?deep-nth symbol? ] filter swap string>number _ swap
       '[ _ [ _ suffix ] change-at ] each ] each ;

: part-map ( grid -- part-map )
    H{ } clone [ dupd '[ _ _ into-part-map ] [ length [0..b) ] dip each ] keep ;

: part-number-sum ( part-map -- n )
    values concat members sum ;

: gear-ratio-sum ( part-map grid -- n )
    '[ [ _ ?deep-nth CHAR: * = ] [ length 2 = ] bi* and ] assoc-filter values [ product ] map sum ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines dup part-map dup
part-number-sum .
swap gear-ratio-sum .
