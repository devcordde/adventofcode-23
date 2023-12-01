use strict;
use warnings;

sub readFile {
    my $filename = 'input.txt';
    open(my $fh, '<', $filename) or die "Could not open file '$filename' $!";
    my @lines = <$fh>;
    close($fh);
    chomp(@lines);
    return @lines;
}

sub part1 {
    my @lines = readFile();
    my $part1_regex = qr/.*?([0-9]).*?([0-9]){0,1}[^0-9]*?$/;
    my $sum = 0;

    for my $line (@lines) {
        my @matches = $line =~ /$part1_regex/;
        if (@matches) {
            if (not defined $matches[1]) {
                $sum += parsePart1($matches[0] . $matches[0]);
            } else {
                $sum += parsePart1($matches[0] . $matches[1]);
            }
        } else {
            warn "No matches found in line: $line";
            next;
        }
    }

    return $sum;
}

sub part2 {
    my @lines = readFile();
    my $part2_regex2 = qr/^.*?([0-9]|one|two|three|four|five|six|seven|eight|nine).*([0-9]|one|two|three|four|five|six|seven|eight|nine)/;
    my $part2_regex3 = qr/^.*?([0-9]|one|two|three|four|five|six|seven|eight|nine)/;
    my $sum = 0;

    for my $line (@lines) {
        my @matches = $line =~ /$part2_regex2/;
        if (not @matches) {
            @matches = $line =~ /$part2_regex3/;
            if (@matches) {
                $sum += 10 * parsePart2($matches[0]) + parsePart2($matches[0]);
            } else {
                warn "No matches found in line for part2: $line";
                next;
            }
        } else {
            $sum += 10 * parsePart2($matches[0]) + parsePart2($matches[1]);
        }
    }

    return $sum;
}

sub parsePart1 {
    my ($string) = @_;
    return int($string);
}

sub parsePart2 {
    my ($string) = @_;
    my %word_to_num = (
        'one'   => 1,
        'two'   => 2,
        'three' => 3,
        'four'  => 4,
        'five'  => 5,
        'six'   => 6,
        'seven' => 7,
        'eight' => 8,
        'nine'  => 9
    );

    return exists $word_to_num{$string} ? $word_to_num{$string} : int($string);
}

eval {
    print "Part 1 result: ", part1(), "\n";
    print "Part 2 result: ", part2(), "\n";
};

if ($@) {
    die "An error occurred: $@";
}
