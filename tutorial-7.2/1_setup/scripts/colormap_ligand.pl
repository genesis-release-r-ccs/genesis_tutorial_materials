#!/usr/bin/perl
#
use strict;
use warnings;
use Getopt::Long;
my $opt={};
&getopt($opt);
&getparam($opt);
&searchmax_min($opt);
&output($opt);
&searchmax_minlig($opt);
&outputlig($opt);

sub output {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{out}) || die "Cannot open $opt->{out} \n";
	for (my $i = 0;$i <scalar(@{$opt->{eps}});$i++ ) {
		printf OUTFILE "%4s %4s",
			   $opt->{contnum}->[0]->[$i],$opt->{contnum}->[1]->[$i];
		for (my $j = 0;$j<scalar(@{$opt->{epscount}->[$i]});$j++) {
			printf OUTFILE " %d",$opt->{epscount}->[$i]->[$j];
		}
		printf OUTFILE "\n";
		printf OUTFILE "%4s %4s",
			   $opt->{contnum}->[1]->[$i],$opt->{contnum}->[0]->[$i];
		for (my $j = 0;$j<scalar(@{$opt->{epscount}->[$i]});$j++) {
			printf OUTFILE " %d",$opt->{epscount}->[$i]->[$j];
		}
		printf OUTFILE "\n";
	}
	close(OUTFILE);
}

sub outputlig {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{lig}) || die "Cannot open $opt->{lig} \n";
	for (my $i = 0;$i <scalar(@{$opt->{ligeps}});$i++ ) {
		printf OUTFILE "%4s %4s",
			   $opt->{ligcontnum}->[0]->[$i],$opt->{ligcontnum}->[1]->[$i];
		for (my $j = 0;$j<scalar(@{$opt->{ligepscount}->[$i]});$j++) {
			printf OUTFILE " %d",$opt->{ligepscount}->[$i]->[$j];
		}
		printf OUTFILE "\n";
		printf OUTFILE "%4s %4s",
			   $opt->{ligcontnum}->[1]->[$i],$opt->{ligcontnum}->[0]->[$i];
		for (my $j = 0;$j<scalar(@{$opt->{ligepscount}->[$i]});$j++) {
			printf OUTFILE " %d",$opt->{ligepscount}->[$i]->[$j];
		}
		printf OUTFILE "\n";
	}
	close(OUTFILE);
}

sub searchmax_min {
	my ($opt)=@_;
	my $min=$opt->{eps}->[0];
	@{$opt->{epscount}}=();
	my $count = int(($opt->{max}-$opt->{min})/$opt->{delta})+1;
	for (my $i = 0;$i<scalar(@{$opt->{eps}});$i++) {
		@{$opt->{epscount}->[$i]}=();
		my $jj = 0;
		$opt->{epscount}->[$i]->[$jj]=0;
		if ($opt->{eps}->[$i] < $opt->{min}) {
			$opt->{epscount}->[$i]->[$jj]=1;
		}
		$jj++;
		for (my $j = 0;$j<$count;$j++) {
			$opt->{epscount}->[$i]->[$jj]=0;
			my $cur_min =  $opt->{min}+$j*$opt->{delta};
			my $cur_max =  $cur_min+$opt->{delta};
			if ($opt->{eps}->[$i] >= $cur_min && 
					$opt->{eps}->[$i] < $cur_max) {
				$opt->{epscount}->[$i]->[$jj]=1;
			}
			$jj++;
		}
		$opt->{epscount}->[$i]->[$jj]=0;
		if ($opt->{eps}->[$i] > $opt->{max}) {
			$opt->{epscount}->[$i]->[$jj]=1;
		}
	}
}

sub searchmax_minlig {
	my ($opt)=@_;
#	my $min=$opt->{ligeps}->[0];
	@{$opt->{ligepscount}}=();
	my $count = int(($opt->{max}-$opt->{min})/$opt->{delta})+1;
	for (my $i = 0;$i<scalar(@{$opt->{ligeps}});$i++) {
		@{$opt->{ligepscount}->[$i]}=();
		my $jj = 0;
		$opt->{ligepscount}->[$i]->[$jj]=0;
		if ($opt->{ligeps}->[$i] < $opt->{min}) {
			$opt->{ligepscount}->[$i]->[$jj]=1;
		}
		$jj++;
		for (my $j = 0;$j<$count;$j++) {
			$opt->{ligepscount}->[$i]->[$jj]=0;
			my $cur_min =  $opt->{min}+$j*$opt->{delta};
			my $cur_max =  $cur_min+$opt->{delta};
			if ($opt->{ligeps}->[$i] >= $cur_min && 
					$opt->{ligeps}->[$i] < $cur_max) {
				$opt->{ligepscount}->[$i]->[$jj]=1;
			}
			$jj++;
		}
		$opt->{ligepscount}->[$i]->[$jj]=0;
		if ($opt->{ligeps}->[$i] > $opt->{max}) {
			$opt->{ligepscount}->[$i]->[$jj]=1;
		}
	}
}

sub getparam {
	my ($opt)=@_;
	open(INFILE,$opt->{param}) || die "Cannot open $opt->{param}\n";
	@{$opt->{goparam}}=();
	@{$opt->{contnum}->[0]}=();
	@{$opt->{contnum}->[1]}=();
	@{$opt->{eps}}=();
	@{$opt->{ligcontnum}->[0]}=();
	@{$opt->{ligcontnum}->[1]}=();
	@{$opt->{ligeps}}=();
	$opt->{maxres}=0;
	my $ichk=0;
	my $ibond=0;
	while(<INFILE>){
		if ($ichk==1) {
			if (/^\s*$/) {
				$ichk=0;
			} else {
				my (@dum)=split(' ',$_);
				if (scalar(@dum) < 4) {
					printf STDERR "Error: contact is not correct";
					die;
				}
				$dum[0]=~s/G//;
				$dum[1]=~s/G//;
				if (scalar(@dum) == 4) {
					push(@{$opt->{contnum}->[0]},$dum[0]);
					push(@{$opt->{contnum}->[1]},$dum[1]);
					push(@{$opt->{eps}},$dum[2]);
#				} elsif ($dum[4]=~/lig/){
				} elsif ($dum[4]=~/com/){
					push(@{$opt->{ligcontnum}->[0]},$dum[0]);
					push(@{$opt->{ligcontnum}->[1]},$dum[1]);
					push(@{$opt->{ligeps}},$dum[2]);
				}
			}
		} elsif ($ibond==1) {
			if (/^\s*$/) {
				$ibond=0;
			} else {
				my (@dum)=split(' ',$_);
				$dum[1]=~s/G//;
				$opt->{maxres}=$dum[1];
			}
		}
		if ($ichk==0) {
			push(@{$opt->{goparam}},$_);
		}
		if (/^NBFIX/) {
			$ichk=1;
		}
		if (/^BOND/) {
			$ibond=1;
		}
	}
	close(INFILE);
}

sub getopt {
	my ($opt)=@_;
	if ($ARGV[0] eq "") {
		printf STDERR "colormap.pl -param param -out out.data -lig out_lig.data -delta -0.1 \n";
		exit;
	}
	$opt->{param}="";
	$opt->{delta}=0.5;
	$opt->{max}=-0.4;
	$opt->{min}=-1.2;
	$opt->{out}="out.data";
	GetOptions ( 'param=s' => \$opt->{param},
			'out=s' => \$opt->{out},
			'lig=s' => \$opt->{lig},
			'delta=s' => \$opt->{delta},
			'max=s' => \$opt->{max},
			);
}

