use strict;
use warnings;

open(my $f, '<', "input.txt") or die "Cannot open file: $!";

sub part1 {
    my @lines; while (my $l = <$f>) { chomp($l); push @lines, $l; }
    my $sum_part1 = 0;
    
    foreach my $i (0 .. $#lines) {
        my $l = $lines[$i];
        my @line_split = split(':', $l);
        my @sets = split(/\|/, $line_split[1]);
        my $points = 0;
        my @set0 = split(' ', $sets[0]);
        my @set1 = grep { $_ =~ /\d+/ } split(' ', $sets[1]);
    
    foreach my $n (@set0) {
        foreach my $x (@set1) {
            if ($n =~ /\d+/ && $x =~ /\d+/) {
                if ($n == $x) {
                    if ($points == 0) {
                        $points = 1;
                    } else {
                        $points *= 2;
                    }
                }
            }
        }
    }
    $sum_part1 += $points;
    $points = 0;
  }

    return $sum_part1;  
}

sub part2 {
    # Reset file pointer to the beginning (https://perldoc.perl.org/functions/seek)
    seek($f, 0, 0);

    my @lines_part2;
    while (my $l = <$f>) {
        chomp($l);
        push @lines_part2, [$l, 1];
    }

    my $sum_part2 = 0;
    for (my $i = 0; $i < scalar @lines_part2; $i++) {
        my $g = $lines_part2[$i];
        my @l = split(':', $g->[0]);
        my @sets = split(/\|/, $l[1]);
        my $points = 0;
        $sum_part2 += $g->[1];
    
        my $count = 0;
        my @set1 = grep { $_ =~ /\d+/ } split(' ', $sets[1]);
    
    foreach my $n (split(' ', $sets[0])) {
        foreach my $x (@set1) {
            if ($n =~ /\d+/ && $x =~ /\d+/) {
                if ($n == $x) {
                    $count++;
                }
            }
        }
    }

    for (my $x = 0; $x < $count; $x++) {
        $lines_part2[$i + 1 + $x]->[1] += $g->[1];
    }
    $sum_part2 += $points;
    $points = 0;
  }

  return $sum_part2;
}

print "Part 1: " . part1() . "\n";
print "Part 2: " . part2() . "\n";