#!/usr/bin/perl
#
use strict;
use warnings;
my $opt={};
$opt->{head}="pathcv";
$opt->{template}=sprintf("%s_template.in",$opt->{head});
$opt->{pathfile}="../../../1_setup/setpath.sh";
&get_path($opt);
$opt->{program}=sprintf("%s/pathcv_analysis",$opt->{dir});
&read_temp($opt);
$opt->{mdstep}=1200000;
$opt->{mdout}=400;
$opt->{nreplicas}=16;

for (my $i=1;$i<=$opt->{nreplicas};$i++) {
	$opt->{num}=$i;
	$opt->{outfile}=sprintf("%s_%d.in",$opt->{head},$opt->{num});
	$opt->{logfile}=sprintf("%s_%d.log",$opt->{head},$opt->{num});
	&out_temp($opt);
	my $command=sprintf("%s %s > %s",
		   $opt->{program},$opt->{outfile},$opt->{logfile});
	printf STDOUT "%s\n",$command;
	system($command);
}

sub get_path {
	my ($opt)=@_;
	open(PATH,$opt->{pathfile}) or die "Cannot open $opt->{pathfile}\n";
	while(<PATH>){
		if (/^program_ana/) {
			chomp;
			my $dum;
			($dum,$opt->{dir})=split(/=/,$_);
		}
	}
	close(PATH);
}


sub out_temp {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{outfile}) or die "Cannot open $opt->{outfile}\n";
	for (my $i =0;$i<scalar(@{$opt->{lines}});$i++) {
		my $str=$opt->{lines}->[$i];
		while($str=~/<([a-zA-Z0-9]+)\>/) {
			$str=~s/\<([a-zA-Z0-9]+)\>/$opt->{$1}/;
		}
		printf OUTFILE "%s",$str;
	}
	close(OUTFILE);
}

sub read_temp {
	my ($opt)=@_;
	@{$opt->{lines}}=();
	open(INFILE,$opt->{template}) or die "Cannot open $opt->{template}\n";
	while(<INFILE>) {
		push(@{$opt->{lines}},$_);
	}
	close(INFILE);
}

