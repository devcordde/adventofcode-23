use strict;
use warnings;

my $input_file = "input.txt";
open(my $fh, "<", $input_file) or die "Cannot open file: $!";
my $input = do { local $/; <$fh> };
close($fh);

sub read_number {
    my ($schematic, $col_index, $row_index) = @_;
    my $begin_row_index = $row_index;
    my @digit_vec = ();

    if (defined $schematic->[$col_index][$row_index] && $schematic->[$col_index][$row_index] =~ /\d/) {
        while ($begin_row_index > 0 && $schematic->[$col_index][$begin_row_index - 1] =~ /\d/) {
            $begin_row_index -= 1;
        }

        my $end_row_index = $begin_row_index;
        while (defined $schematic->[$col_index][$end_row_index] && $schematic->[$col_index][$end_row_index] =~ /\d/) {
            push @digit_vec, $schematic->[$col_index][$end_row_index];
            $end_row_index += 1;
        }
        $end_row_index -= 1;

        my $number = 0;
        foreach my $digit (@digit_vec) {
            $number = $number * 10 + $digit;
        }

        return ($number, $end_row_index);
    } else {
        return (0, $row_index); 
    }
}

sub prepare_schematic {
    my ($input) = @_;
    my @schematic = map { [split(//, $_)] } split(/\n/, $input);
    my $old_row_length = scalar(@{$schematic[0]});
    my @bounding_row = ('.') x $old_row_length;
    unshift @schematic, [@bounding_row];
    push @schematic, [@bounding_row];

    foreach my $row (@schematic) {
        unshift @$row, '.';
        push @$row, '.';
    }

    return @schematic;
}

sub calculate_engine_number_sum {
    my @schematic = @_;
    my $engine_number_sum = 0;

    for my $col_index (0 .. $#schematic) {
        for my $row_index (0 .. $#{$schematic[$col_index]}) {
            my $item = $schematic[$col_index][$row_index];
            if ($item ne '.' && $item !~ /\d/) {
                foreach my $col_diff (-1, 0, 1) {
                    my $begin_row_index = $row_index - 1;
                    while (grep { $_ == ($begin_row_index - $row_index) } (-1, 0, 1)) {
                        my ($number, $last_index) = read_number(\@schematic, $col_index + $col_diff, $begin_row_index);
                        if ($number == 0) {
                            $begin_row_index = $last_index + 1;
                        } else {
                            $begin_row_index = $last_index + 2;
                            $engine_number_sum += $number;
                        }
                    }
                }
            }
        }
    }
    return $engine_number_sum;
}

sub calculate_gear_ratio_sum {
    my @schematic = @_;
    my $gear_ratio_sum = 0;

    for my $col_index (0 .. $#schematic) {
        for my $row_index (0 .. $#{$schematic[$col_index]}) {
            my $item = $schematic[$col_index][$row_index];
            if ($item eq '*') {
                my @numbers = ();
                foreach my $col_diff (-1, 0, 1) {
                    my $begin_row_index = $row_index - 1;
                    while (grep { $_ == ($begin_row_index - $row_index) } (-1, 0, 1)) {
                        my ($number, $last_index) = read_number(\@schematic, $col_index + $col_diff, $begin_row_index);
                        if ($number == 0) {
                            $begin_row_index = $last_index + 1;
                        } else {
                            $begin_row_index = $last_index + 2;
                            push @numbers, $number;
                        }
                    }
                }
                if (scalar(@numbers) == 2) {
                    $gear_ratio_sum += $numbers[0] * $numbers[1];
                }
            }
        }
    }
    return $gear_ratio_sum;
}

sub solve {
    my ($input) = @_;
    my @schematic = prepare_schematic($input);
    my $engine_number_sum = calculate_engine_number_sum(@schematic);
    my $gear_ratio_sum = calculate_gear_ratio_sum(@schematic);
    return ($engine_number_sum, $gear_ratio_sum);
}

my ($part1_result, $part2_result) = solve($input);

print "Part 1: $part1_result\n";
print "Part 2: $part2_result\n";
