USING: io.encodings.utf8 io.files io.pathnames command-line ascii namespaces math.parser math sequences strings arrays prettyprint kernel ;
IN: aoc.day1

MEMO: digit-text
    { "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" } [ CHAR: 1 + 2array ] map-index ;

: extract-digits-1 ( str -- seq )
    [ digit? ] filter ;

: find-written-digit ( str -- x/f )
    [ swap first head? ] curry digit-text swap map-find nip ;

: extract-digits-aux ( seq str -- seq )
    dup empty?
    [ drop ]
    [ dup find-written-digit [ second ] [ dup first ] if*
      swapd dup digit? [ suffix ] [ drop ] if
      swap rest extract-digits-aux ]
    if ;

: extract-digits-2 ( str -- seq )
    { } swap extract-digits-aux ;

: first-last-num ( seq -- n )
    [ first ] [ last ] bi 2array >string string>number ;

: calibration-sum ( seq extract -- n )
    [ first-last-num ] compose map sum ; inline

command-line get first utf8 file-lines dup

[ extract-digits-1 ] calibration-sum .
[ extract-digits-2 ] calibration-sum .
