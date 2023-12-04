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
    [ 1 2array ] map
    [ dup dup '[ [ first2 swap ] dip [ + _ length 1 - min ] keep swap (a..b] _ rot '[ first2 _ + 2array ] change-nths ] each-index ]
    keep [ second ] map sum ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines [ parse-card ] map dup
point-sum .
card-sum .
