use strict;
use warnings;

open(my $fh,'<',"input.txt") or die "Cannot open file: $!";my $file_content=do{local$/;<$fh>};close($fh);

my @splitfile = split("\n\n", $file_content);

sub step {my($input, $output, $start, $range)=@_;return $input>=$start&&$input<=$start+$range?$input-$start+$output:undef;} 

sub part1 {
    my @seeds=map{int($_)}(split(' ',substr($splitfile[0], 7)));
    my @unprocessed_steps=map{[split("\n", $_)]}@splitfile[1..$#splitfile];my @steps;

foreach my $unprocessed_step(@unprocessed_steps) {
    my @step = map{my($output, $start, $range)=(split(' ',$_))[0, 1, 2];{"output"=>int($output),"start"=>int($start),"range"=>int($range)};}@{$unprocessed_step}[1..$#{$unprocessed_step}];
    push @steps,\@step;
}

my @locations;

foreach my $seed(@seeds) {
    my $value=$seed;foreach my $step(@steps){my $old_result=$value;foreach my $f(@$step){my $result=step($value,$f->{"output"},$f->{"start"},$f->{"range"});if(defined $result){$value=$result;last;}}}
    push @locations,$value;print("Seed: $seed, Location: $value\r\r\r");}my $min_location=(sort{$a<=>$b}@locations)[0];return $min_location;
}

sub part2 {
    my @seed_array=split(' ',substr($splitfile[0],7));
    my @seeds;for(my $i=0;$i<int(@seed_array)/2;$i++){push @seeds,[int($seed_array[$i*2]),int($seed_array[$i*2+1])];}my @unprocessed_steps=map{[split("\n", $_)]} @splitfile[1..$#splitfile];my $seeds_processed=0;
    my $total_seeds=0;$total_seeds+=$_->[1] foreach @seeds;my @steps;

foreach my $unprocessed_step (@unprocessed_steps) {
    my @step=map{my($output,$start,$range)=(split(' ',$_))[0, 1, 2];{"output"=>int($output),"start"=>int($start),"range"=>int($range)};}@{$unprocessed_step}[1..$#{$unprocessed_step}];push @steps,\@step;
}

my $smallest_location = "inf";

foreach my $seed_tuple(@seeds) {
    for my $seed($seed_tuple->[0]..($seed_tuple->[0]+$seed_tuple->[1]-1)){my $value=$seed;foreach my $step(@steps){my $old_resul=$value;foreach my $f(@$step){my $result=step($value,$f->{"output"},$f->{"start"},$f->{"range"});
    if(defined$result){$value=$result;last;}}}if($value<$smallest_location){$smallest_location=$value;}$seeds_processed++;print("Seeds processed: $seeds_processed, Seeds total: $total_seeds, Smallest so far: $smallest_location\r\r\r");}}
    return $smallest_location;
}

print("Part 1: " . part1() . "\n");
print("Part 2: " . part2() . "\n");