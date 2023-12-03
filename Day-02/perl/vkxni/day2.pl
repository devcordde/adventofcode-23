use List::Util qw(reduce);

open my $fh, '<', 'input.txt' or die "Cannot open file: $!";
my @input = <$fh>;
close $fh;

my %bag = (
    'red' => 12,
    'green' => 13,
    'blue' => 14
);

sub get_color_choices_for_line {
    my ($line) = @_;
    my @game_rounds = map { $_ =~ s/^\s+|\s+$//g; $_ } (split /:/, $line)[1] =~ /([^;]+)/g;
    my @color_choices;
    foreach my $round (@game_rounds) {
        my @choices = map { [split /\s+/, $_] } map { $_ =~ s/^\s+|\s+$//g; $_ } (split /,/, $round);
        foreach my $choice (@choices) {
            push @color_choices, [$choice->[1], int($choice->[0])];
        }
    }
    return @color_choices;
}

sub game_is_possible {
    my ($line) = @_;
    my @color_choices = get_color_choices_for_line($line);
    foreach my $choice (@color_choices) {
        my ($color, $n) = @$choice;
        return 0 if ($bag{$color} // 0) < $n;
    }
    return 1;
}

my @possible_game_ids = ();
my $id = 1;
foreach my $line (@input) {
    push @possible_game_ids, $id if game_is_possible($line);
    $id++;
}

sub part1 {
    my $sum_possible_game_ids = 0;
    $sum_possible_game_ids += $_ for @possible_game_ids;
    print "Part 1 result: $sum_possible_game_ids\n";
}

my @powers = ();
foreach my $line (@input) {
    %bag = map { $_ => 0 } keys %bag;
    my @color_choices = get_color_choices_for_line($line);
    foreach my $choice (@color_choices) {
        my ($color, $n) = @$choice;
        $bag{$color} = $n if $n > ($bag{$color} // 0);
    }
    my $power = reduce { $a * $b } values %bag;
    push @powers, $power;
}

sub part2 {
    my $sum_powers = 0;
    $sum_powers += $_ for @powers;
    print "Part 2 result: $sum_powers\n";
}

eval {
    part1();
    part2();
};

if ($@) {
    die "An error occurred: $@";
}
