! SPDX-License-Identifier: 0BSD
USING: arrays accessors combinators.short-circuit command-line hash-sets
hashtables io io.encodings.utf8 io.files io.pathnames kernel
math math.order math.parser namespaces prettyprint ranges regexp
sequences sets splitting splitting.extras strings ;
IN: aoc.day5

: parse-ints ( str -- ints )
    R/ \d+/ all-matching-slices [ string>number ] map ;

: src+len>range ( src len -- range )
    [ + ] keepd swap [a..b) ;

: parse-input ( lines -- seeds maps )
    { "" } split unclip swap
    [ first parse-ints ]
    ! the below line would have been used for factor 0.100
    ! [ [ rest [ parse-ints first3 [ [ - ] keep ] [ src+len>range ] bi* 2array ] map ] map ]
    [ [ rest [ parse-ints first3 [ [ - ] keep ] [ [ + ] keepd ] bi* 3array ] map ] map ]
    bi* ;

! can only be used in factor 0.100 and if the parsing code is adjusted
! : get-mapping-new ( val map -- newval )
!     [| val |
!      val
!      [ first2
!        [ val + ]
!        [ val swap in? ]
!        bi* swap and ] ]
!     dip swap map-find drop swap or ;

: get-mapping ( val map -- newval )
    [| val |
     val
     [ first3
       [ val + ]
       [ val < ]
       [ val >= ]
       tri* and [ drop f ] unless ] ]
    dip swap map-find drop swap or ;

! intersect range with each entry in map, add diff + to from and to
! create new ranges from remainder

! : get-range-mappings ( range map -- ranges )
!     [| range |
!      range];

: lowest-location ( seeds maps -- n )
    '[ _ swap [ get-mapping ] reduce ] [ min ] map-reduce ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines parse-input lowest-location .
