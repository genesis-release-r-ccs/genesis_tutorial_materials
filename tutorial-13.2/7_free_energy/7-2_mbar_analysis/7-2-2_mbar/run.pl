#!/usr/bin/perl
#
use strict;
use warnings;
my $opt={};
$opt->{head}="mbar";
$opt->{template}=sprintf("%s_template.in",$opt->{head});
$opt->{pathfile}="../../../1_setup/setpath.sh";
&get_path($opt);
$opt->{program}=sprintf("%s/mbar_analysis",$opt->{dir});
&read_temp($opt);
$opt->{mdstep}=1200000;
$opt->{mdout}=400;
$opt->{nreplicas}=16;
$opt->{FC_one}=0.02;

$opt->{FC}="";
for (my $i=1;$i<=$opt->{nreplicas};$i++) {
	$opt->{FC}=sprintf("%s %f",$opt->{FC},$opt->{FC_one});
}
$opt->{FC}=sprintf("%s \n",$opt->{FC});
$opt->{outfile}=sprintf("%s.in",$opt->{head});

&out_temp($opt);

$opt->{logfile}=sprintf("%s.log",$opt->{head});
if (-e $opt->{logfile}) {
	unlink($opt->{logfile});
}
my $command=sprintf("%s %s > %s",
		$opt->{program},$opt->{outfile},$opt->{logfile});
printf STDOUT "%s\n",$command;
system($command);

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

