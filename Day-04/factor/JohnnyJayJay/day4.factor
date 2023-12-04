! SPDX-License-Identifier: 0BSD
USING: combinators.smart command-line hashtables io
io.encodings.utf8 io.files io.pathnames kernel math math.order math.parser
namespaces prettyprint splitting.extras splitting ranges regexp sequences sets strings ;
IN: aoc.day4

! card string -> winning number amount
: parse-card ( str -- n )
    CHAR: : over index 1 + tail "|" split
    [ " " split-harvest [ string>number ] map >hash-set ] map
    first2 intersect cardinality ;

: point-sum ( cards -- n )
    [ 1 - 2^ ] map sum ;

: card-sum ( cards -- n )
    dup [ length ] [ last ] bi + 1 <array>
    [ [ unclip-slice swap ] dip cut-slice [ swap '[ _ + ] map ] dip append ]
    accumulate [ first ] map sum nip ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines [ parse-card ] map dup
point-sum .
card-sum .
