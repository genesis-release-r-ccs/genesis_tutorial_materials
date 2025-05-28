#!/usr/bin/perl
#
use strict;
use warnings;
use Getopt::Long;
my $opt={};
&getopt($opt);
#&getdssp($opt);
&getKBparam($opt);
#&cutting($opt);
&getMT($opt);
&getMBCG($opt);
&outparm($opt);

sub outparm {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{out}) || die "Cannot open $opt->{out}\n";
	for (my $i = 0;$i<scalar(@{$opt->{goparam}});$i++) {
		printf OUTFILE $opt->{goparam}->[$i];
		if ($opt->{goparam}->[$i]=~/^NBFIX/) {
			for (my $j = 0;$j<scalar(@{$opt->{contdist}});$j++) {
				printf OUTFILE "G%d    G%d   %f  %s\n",
					   $opt->{contnum}->[0]->[$j],
					   $opt->{contnum}->[1]->[$j],
					   $opt->{eps}->[$j],$opt->{contdist}->[$j];
			}
		}
	}
	close(OUTFILE);
}
sub getMBCG {
	my ($opt)=@_;
	my $toteps=0;
	@{$opt->{eps}}=();
	for (my $icont = 0;$icont<scalar(@{$opt->{contdist}});$icont++){
		my $cont0=$opt->{contnum}->[0]->[$icont];
		my $cont1=$opt->{contnum}->[1]->[$icont];
		$opt->{eps}->[$icont] = 0;
		for (my $inode = 0;$inode<scalar(@{$opt->{node_res}});$inode++) {
			if ($opt->{node_res}->[$inode]->[$cont0] != 0 &&
					$opt->{node_res}->[$inode]->[$cont1] != 0 &&
					$opt->{node_res}->[$inode]->[$cont0] != 
					$opt->{node_res}->[$inode]->[$cont1] ) {
				$opt->{eps}->[$icont] = 
					1.0/($opt->{height}->[$inode]);
				last;
			}
		}
		if ($opt->{eps}->[$icont] == 0) {
			$opt->{eps}->[$icont] = 
				1.0/($opt->{min_height});
		}
		$toteps+=$opt->{eps}->[$icont];
	}
#	printf "current %f\n",$toteps;
	my $cont=-$opt->{helix_scaled}*$opt->{min_height};
	$toteps=0;
	my $toteps_h=0;
	for (my $icont = 0;$icont<scalar(@{$opt->{contdist}});$icont++){
		$opt->{eps}->[$icont] = $opt->{eps}->[$icont]*$cont;
		$toteps+=$opt->{eps}->[$icont];
	}
#	printf "%f %f\n",$opt->{maxres}*$opt->{Eres},$toteps;
}

sub getMT {
	my ($opt)=@_;
	open(INFILE,$opt->{MT}) || die "Cannot open $opt->{MT}\n";
	my $ichk=0;
	my $curr=-1;
	while(<INFILE>){
		my (@dum)=split(' ');
		if (/^\@\@ Height:/) {
			$curr++;
#			if ($curr >= $opt->{node_criterion} && $opt->{node_set}) {
#				last;
#			}
			if ($dum[2] < $opt->{min_height}) {
				last;
			}
			$opt->{height}->[$curr]=$dum[2];
			printf "Height: %s\n",$opt->{height}->[$curr];
			@{$opt->{node_res}->[$curr]}=();
			for (my $i = 0 ; $i<=$opt->{maxres};$i++) {
				$opt->{node_res}->[$curr]->[$i]=0;
			}
		}
		if (/^== Input1/) {
			$_=<INFILE>;
			$_=<INFILE>;
			&nodecheck($opt,$curr,substr($_,13),1);
			$_=<INFILE>;
			$_=<INFILE>;
			&nodecheck($opt,$curr,substr($_,13),2);
		}
	}
	close(INFILE);
}

sub nodecheck {
	my ($opt, $curr, $line,$num)=@_;
#	my (@dum)=split(',',substr($_,13));
	my (@dum)=split(',',$line);
	for (my $i = 0;$i<scalar(@dum);$i++) {
		my ($fst, $end)=split('-',$dum[$i]);
		$fst =~ s/ //g; 
		if (defined($end)) {
			$end =~ s/ //g; 
		} else {
			$end=$fst;
		}
		for (my $j = $fst;$j<=$end;$j++) {
			$opt->{node_res}->[$curr]->[$j]=$num;
#		printf "%d %d %d\n",$j,$curr,$num;
		}

	}
}

#sub getdssp {
#	my ($opt)=@_;
#	open(INFILE,$opt->{dssp}) || die "Cannot open $opt->{dssp}\n";
#	@{$opt->{second}}=();
#	my $flg=0;
#	while(<INFILE>) {
#		if ($flg==1) {
#			if (substr($_,13,1) !~/[A-Z]/) {
##				$flg=0;
#				last;
#			} else {
#				my $second=substr($_,16,1);
#				my $ff=0;
#				if ($second eq "H") {
#					$ff=1;
#				}
#				push(@{$opt->{second}},$ff);
#			}
#		} elsif (/^  #  RESIDUE AA /) {
#			$flg=1;
#		} 
#	}
#	close(INFILE);
#
#}

sub getKBparam {
	my ($opt)=@_;
	open(INFILE,$opt->{param}) || die "Cannot open $opt->{param}\n";
	@{$opt->{goparam}}=();
	@{$opt->{contnum}->[0]}=();
	@{$opt->{contnum}->[1]}=();
	@{$opt->{contdist}}=();
	@{$opt->{helix_pair}}=();
	$opt->{maxres}=0;
	$opt->{helix_tot}=0;
	my $ichk=0;
	my $ibond=0;
	while(<INFILE>){
		if ($ichk==1) {
			if (/^\s*$/) {
				$ichk=0;
			} else {
				my (@dum)=split(' ',$_);
				if (scalar(@dum) != 4) {
					printf STDERR "Error: contact is not correct";
					die;
				}
				$dum[0]=~s/G//;
				$dum[1]=~s/G//;

				push(@{$opt->{contnum}->[0]},$dum[0]);
				push(@{$opt->{contnum}->[1]},$dum[1]);
				push(@{$opt->{contdist}},$dum[3]);
#				if ($opt->{helix} == 1) {
#					my $helix=0;
#					if ($opt->{second}->[$dum[0]-1]==1  
#							&& $opt->{second}->[$dum[1]-1]==1 
#							&& $dum[1] == $dum[0]+4) {
#						printf "CKCK %d %d %f\n",$dum[0],$dum[1],$dum[2];
#						$opt->{helix_tot}+=$dum[2];
#						$helix=1;
#					}
#					push(@{$opt->{helix_pair}},$helix);
#				}
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

#sub cutting {
#	my ($opt)=@_;
#	my (@dum)=split(',',$opt->{cutting});
#	@{$opt->{cutting_res}}=();
#	for (my $ires = 0 ; $ires<= $opt->{maxres};$ires++) {
#		$opt->{cutting_res}->[$ires]=0;
#	}
#	for (my $icutting = 0;$icutting<scalar(@dum); $icutting++) {
#		my ($fst,$end)=split('-',$dum[$icutting]);
#		if (!defined($end)) {
#			$end=$fst;
#		}
#		for (my $jcut =$fst; $jcut<=$end ; $jcut++) {
#			$opt->{cutting_res}->[$jcut]=1;
#		}
#	}
#}

sub getopt {
	my ($opt)=@_;
	if ($ARGV[0] eq "") {
		printf STDERR "MBGO_parm.pl -min_height height -mt MT.info -out out.parm\n";
	}
	$opt->{MT}="MT.info";
#	$opt->{dssp}="dssp.txt";
	$opt->{param}="";
	$opt->{out}="";
	$opt->{omega}=0.0054;
	$opt->{Tf}=350;
#	$opt->{node_criterion}=6;
#	$opt->{node_set}=0;
	$opt->{min_height}=5;
	$opt->{helix}=1;
	$opt->{helix_scaled}=1.158474;
	$opt->{flexible}=$opt->{min_height}*2;
	$opt->{cutting}="";

	GetOptions ('node_criterion=s' => \$opt->{node_criterion},
			'min_height=s' => \$opt->{min_height},
	        'mt=s' => \$opt->{MT},
			'param=s' => \$opt->{param},
			'out=s' => \$opt->{out},
#			'helix_scaled=s' => \$opt->{helix_scaled},
			'const' => \$opt->{helix_scaled},
#			'node_set' => \$opt->{node_set},
#			'Tf=s' => \$opt->{Tf},
#			'helix' => \$opt->{helix},
			);
	$opt->{Eres}=$opt->{omega}*$opt->{Tf};
}

