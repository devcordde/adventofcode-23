! SPDX-License-Identifier: 0BSD
USING: arrays assocs combinators.extras command-line hashtables
io io.encodings.utf8 io.files io.pathnames kernel math
math.functions math.parser math.statistics namespaces
prettyprint sequences sorting splitting strings ;
IN: aoc.day7

MEMO: label-order-1 ( -- labels ) "23456789TJQKA" ;
MEMO: label-order-2 ( -- labels ) "J23456789TQKA" ;
MEMO: type-order ( -- types )
    { { { 1 5 } }
      { { 2 1 } { 1 3 } }
      { { 2 2 } { 1 1 } }
      { { 3 1 } { 1 2 } }
      { { 3 1 } { 2 1 } }
      { { 4 1 } { 1 1 } }
      { { 5 1 } } }
    [ >hashtable ] map ;

: parse-line ( str -- pair )
    " " split first2 string>number 2array ;

: total-winnings ( pairs type-quot label-order -- n )
    '[ first2 [ _ [ [ _ index ] map ] bi ] dip 3array ] map
    sort [ [ last ] [ 1 + ] bi* * ] map-index sum ; inline

: type ( hand -- i )
    histogram values histogram type-order index ;

: replace-jokers ( hand -- hand )
    [ [ CHAR: J = ] reject histogram >alist
      [ [ second ] [ first label-order-1 index ] bi 2array ] inv-sort-by
      [ "A" ] [ first first 1array ] if-empty ] keep
    "J" rot replace ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines [ parse-line ] map
[ [ type ] label-order-1 ] [ [ replace-jokers type ] label-order-2 ] bi
[ total-winnings . ] 3bi@
