! SPDX-License-Identifier: 0BSD
USING: arrays command-line io io.encodings.utf8 io.files
io.pathnames kernel math math.parser math.vectors
namespaces prettyprint sequences splitting strings ;
IN: aoc.day9

: parse-line ( str -- history )
    " " split [ string>number ] map ;

: diff-seq ( history -- diffs )
    [ [ dup [ 0 = ] all? not ] [ [ rest-slice ] keep [ - ] 2map dup ] produce nip ] keep prefix ;

: extrapolate ( histories -- results )
    [ diff-seq
      [ [ last ] map ]
      [ [ [ first ] [ even? 1 -1 ? ] bi* * ] map-index ]
      bi
      [ sum ] bi@ 2array ]
    [ v+ ] map-reduce ;

command-line get first <pathname> absolute-path pathname> utf8 file-lines [ parse-line ] map
extrapolate [ . ] each
