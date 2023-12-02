! SPDX-License-Identifier: 0BSD
USING: arrays assocs assocs.extras command-line fry
grouping io io.encodings.utf8 io.files io.pathnames kernel math
math.order math.parser namespaces prettyprint sequences
splitting splitting.extras strings vectors ;
IN: aoc.day2

: parse-set ( str -- seq )
    ", " split-harvest 2 group [ dup first string>number suffix rest ] map >vector ;

: parse-game ( str -- game )
    "Game " length tail ":;" split
    [ first string>number ]
    [ rest [ parse-set ] map ]
    bi 2array ;

: game-possible? ( game-sets inv -- ? )
    '[ _ '[ [ second ] [ first _ at ] bi <= ] all? ] all? ;

: possible-id-sum ( game-seq inv -- n )
    '[ second  _ game-possible? ] filter [ first ] map sum ;

MEMO: part-1-inv ( -- inv )
    { { "blue" 14 } { "green" 13 } { "red" 12 } } ;

: min-cubes ( game-sets -- inv )
    f [ [ max ] assoc-merge ] reduce ;

: cube-power-sum ( game-seq -- n )
    [ second min-cubes values product ] map sum ;

command-line get first  <pathname> absolute-path pathname> dup print utf8 file-lines [ parse-game ] map dup part-1-inv
possible-id-sum .
cube-power-sum .
