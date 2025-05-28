#!/usr/bin/perl
#
use strict;
use warnings;
use Getopt::Long;
my $opt={};
&getopt($opt);

&readpdb($opt);
if ($opt->{climber} != 0) {
	&climber_force($opt);
}
for (my $i = 0;$i<scalar(@{$opt->{paramfiles}});$i++) {
	&getKBparam($i,$opt);
}
&setparams($opt);
&output($opt);
###############################################################################
sub setparams {
	my ($opt)=@_;
	&setbond($opt);
	if (scalar(@{$opt->{paramfiles}}) > 1) {
		&setangle_multi($opt);
	} else {
		&setangle($opt);
	}
	&setdihed($opt);
	&setnonb($opt);
	if (scalar(@{$opt->{paramfiles}}) > 1) {
		&setcontacts_multi($opt);
	} else {
		&setcontacts($opt);
	}
}
sub output {
	my ($opt)=@_;
	open(OUTFILE,">".$opt->{out}) || die "Cannot open $opt->{out}\n";
	&outheader($opt);
	&outatype($opt);
	&outmtype($opt);
	&outatoms($opt);
	&outbonds($opt);
	if (scalar(@{$opt->{paramfiles}}) > 1) {
		&outangles_multi($opt);
	} else {
		&outangles($opt);
	}
	&outdiheds($opt);
	if (scalar(@{$opt->{paramfiles}}) > 1) {
		&outcontacts_multi($opt);
		&outexclusions_multi($opt);
	} else {
		&outcontacts($opt);
		&outexclusions($opt);
	}
	if ($opt->{climber} !=0) {
		&outclimber($opt);
	}
	&outsystem_mol($opt);
	close(OUTFILE);
}
sub outatype {
	my ($opt)=@_;
	printf OUTFILE " [ atomtypes ] \n";
	printf OUTFILE ";name  mass     charge   ptype  rmin   eps\n";
	foreach my $key (sort keys %{$opt->{mass}}) {
		printf OUTFILE " C%s     %6.2f    0.0000   0.000   %f    %f  \n",
			   $key, $opt->{mass}->{$key},$opt->{rmin},$opt->{eps};
	}
	printf OUTFILE "\n";
}

sub outmtype {
	my ($opt)=@_;
	printf OUTFILE " [ moleculetype ] \n";
	printf OUTFILE ";name  nrexcl \n";
	printf OUTFILE " CGprotein     3 \n";
	printf OUTFILE "\n";
}

sub outheader {
	my ($opt)=@_;
	printf OUTFILE " ; KBGO with multi\n";
	printf OUTFILE "\n";
	printf OUTFILE " [ defaults ] \n";
	printf OUTFILE ";nbfunc comb-rule gen-pairs\n";
	printf OUTFILE "  1       2          no\n";
	printf OUTFILE "\n";
	printf OUTFILE " [ gomodel ] \n";
	printf OUTFILE ";GOfunc num_basins\n";
	printf OUTFILE "  1       %d \n",scalar(@{$opt->{paramfiles}});
	printf OUTFILE "\n";
}

sub outatoms {
	my ($opt)=@_;
	printf OUTFILE " [ cg_atoms ] \n";
	printf OUTFILE ";nr  type  resnr residue atom  cgnr charge  mass rmin eps\n";
	for (my $i = 0;$i<scalar(@{$opt->{coor}->{name}});$i++) {
		my $res=$opt->{coor}->{res}->[$i];
		printf OUTFILE "%6d C%3s %10d %3s C%3s %10d %6.3f %6.3f %f %f\n",
			   $i+1,$res, $i+1,$res,
			   $res,$i+1,
			   $opt->{db_nonb}->{charge}->[$i],
			   $opt->{mass}->{$res},
			   $opt->{db_nonb}->{min}->[$i],
			   $opt->{db_nonb}->{const}->[$i];
	}
	printf OUTFILE "\n";
}

sub outbonds {
	my ($opt)=@_;
	printf OUTFILE " [ bonds ] \n";
	printf OUTFILE ";ai     aj      func    r0(nm)  Kb\n";
	for (my $i = 0;$i<scalar(@{$opt->{db_bonds}->{atoms}});$i++) {
		printf OUTFILE "%s 1 %15.8e %15.8e\n",
			   $opt->{db_bonds}->{atoms}->[$i],
			   $opt->{db_bonds}->{min}->[$i],
			   $opt->{db_bonds}->{const}->[$i];
	}
	printf OUTFILE "\n";
}

sub outangles_multi {
	my ($opt)=@_;
	printf OUTFILE " [ angles ] \n";
	printf OUTFILE " ;ai  aj   ak  func  th0(deg)   Ka\n";
	for (my $i = 0;$i<scalar(@{$opt->{db_angles}->{atoms}});$i++) {
		printf OUTFILE "%s 10 %15.8e %15.8e %15.8e %15.8e %15.8e %15.8e\n",
			   $opt->{db_angles}->{atoms}->[$i],
			   $opt->{db_angles}->{min1}->[$i],
			   $opt->{db_angles}->{min2}->[$i],
			   $opt->{db_angles}->{const1}->[$i],
			   $opt->{db_angles}->{const2}->[$i],
			   $opt->{db_angles}->{gamma}->[$i],
			   $opt->{db_angles}->{epsa}->[$i];
	}
	printf OUTFILE "\n";
}

sub outangles {
	my ($opt)=@_;
	printf OUTFILE " [ angles ] \n";
	printf OUTFILE " ;ai  aj   ak  func  th0(deg)   Ka\n";
	for (my $i = 0;$i<scalar(@{$opt->{db_angles}->{atoms}});$i++) {
		printf OUTFILE "%s 1 %15.8e %15.8e\n",
			   $opt->{db_angles}->{atoms}->[$i],
			   $opt->{db_angles}->{min1}->[$i],
			   $opt->{db_angles}->{const1}->[$i];
	}
	printf OUTFILE "\n";
}

sub outdiheds {
	my ($opt)=@_;
	printf OUTFILE " [ dihedrals ] \n";
	printf OUTFILE ";ai  aj  ak  al  func  phi0(deg) Kd mult\n";
	for (my $i = 0;$i<scalar(@{$opt->{db_dihed}->{atoms}});$i++) {
		printf OUTFILE "%s 1 %15.8e %15.8e %d\n",
			   $opt->{db_dihed}->{atoms}->[$i],
			   $opt->{db_dihed}->{min}->[$i],
			   $opt->{db_dihed}->{const}->[$i],
			   $opt->{db_dihed}->{period}->[$i];
	}
	printf OUTFILE "\n";
}
sub outcontacts_multi {
	my ($opt)=@_;
	printf OUTFILE " [ multicontact ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{db_multi_contacts}->{atoms}});$i++) {
		printf OUTFILE "%s 2 %d %15.8e %15.8e\n",
			   $opt->{db_multi_contacts}->{atoms}->[$i],
			   $opt->{db_multi_contacts}->{model}->[$i]+1,
			   $opt->{db_multi_contacts}->{min}->[$i],
			   $opt->{db_multi_contacts}->{const}->[$i];
	}
	printf OUTFILE "\n";
	printf OUTFILE " [ pairs ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{db_mix_contacts}->{atoms}});$i++) {
		printf OUTFILE "%s 2 %15.8e %15.8e\n",
			   $opt->{db_mix_contacts}->{atoms}->[$i],
			   $opt->{db_mix_contacts}->{min}->[$i],
			   $opt->{db_mix_contacts}->{const}->[$i];
	}
	printf OUTFILE "\n";
}
sub outcontacts {
	my ($opt)=@_;
	printf OUTFILE " [ pairs ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{single_contacts}->{atoms}});$i++) {
		printf OUTFILE "%s 2 %15.8e %15.8e\n",
			   $opt->{single_contacts}->{atoms}->[$i],
			   $opt->{single_contacts}->{min}->[$i],
			   $opt->{single_contacts}->{const}->[$i];
	}
	printf OUTFILE "\n";
}
sub outexclusions_multi {
	my ($opt)=@_;
	printf OUTFILE " [ exclusions ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{db_mix_contacts}->{atoms}});$i++) {
		printf OUTFILE "%s\n", $opt->{db_mix_contacts}->{atoms}->[$i];
	}
	printf OUTFILE "\n";
}
sub outexclusions {
	my ($opt)=@_;
	printf OUTFILE " [ exclusions ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{single_contacts}->{atoms}});$i++) {
		printf OUTFILE "%s\n", $opt->{single_contacts}->{atoms}->[$i];
	}
	printf OUTFILE "\n";
}
sub outclimber {
	my ($opt)=@_;
	printf OUTFILE " [ morph_bb ] \n";
	for (my $i = 0;$i<scalar(@{$opt->{morph}->{atoms}});$i++) {
		printf OUTFILE "%s %15.8e\n",
			   $opt->{morph}->{atoms}->[$i],
			   $opt->{morph}->{min}->[$i];
	}
	printf OUTFILE "\n";
}
sub outsystem_mol {
	my ($opt)=@_;
	printf OUTFILE " [ system ] \n";
	printf OUTFILE ";name\n";
	printf OUTFILE " CGprotein \n";
	printf OUTFILE "\n";
	printf OUTFILE " [ molecules ] \n";
	printf OUTFILE ";name #molec\n";
	printf OUTFILE " CGprotein 1 \n";
	printf OUTFILE "\n";
}

sub setbond {
	my ($opt)=@_;
	@{$opt->{db_bonds}->{atoms}}=();
	@{$opt->{db_bonds}->{min}}=();
	@{$opt->{db_bonds}->{const}}=();
	for (my $ibond = 0;$ibond<scalar(@{$opt->{bonds}->[0]});$ibond++) {
		my $average=0;
		my (@dum0)=split(' ',$opt->{bonds}->[0]->[$ibond]);
		my $min = $dum0[0];
		my $max = $dum0[1];
		$min=~s/G//;
		$max=~s/G//;
		for (my $i = 0;$i< 2; $i++) {
			$dum0[$i]=~s/G//;
			if ($min > $dum0[$i]) {
				$min = $dum0[$i];
			}
			if ($max < $dum0[$i]) {
				$max = $dum0[$i];
			}
		}
		my $fc = $dum0[2];
		for (my $inum = 0;$inum<scalar(@{$opt->{bonds}});$inum++) {
			my (@dum)=split(' ',$opt->{bonds}->[$inum]->[$ibond]);
			$average+=$dum[3];
		}
		$average=$average/scalar(@{$opt->{bonds}});
		$average=$average*$opt->{ang2nm};
		$fc=2*$fc*$opt->{kcal2kj};
		my $str=sprintf("%6s %6s",$min,$max);
		push(@{$opt->{db_bonds}->{atoms}},$str);
		push(@{$opt->{db_bonds}->{min}},$average);
		push(@{$opt->{db_bonds}->{const}},$fc);
	}
}

sub setangle_multi {
	my ($opt)=@_;
	@{$opt->{db_angles}->{atoms}}=();
	@{$opt->{db_angles}->{min1}}=();
	@{$opt->{db_angles}->{min2}}=();
	@{$opt->{db_angles}->{const1}}=();
	@{$opt->{db_angles}->{const2}}=();
	@{$opt->{db_angles}->{gamma}}=();
	@{$opt->{db_angles}->{epsa}}=();
	for (my $iangl = 0;$iangl<scalar(@{$opt->{angles}->[0]});$iangl++) {
		my (@dum0)=split(' ',$opt->{angles}->[0]->[$iangl]);
		my $str="";
		for (my $i = 0;$i < 3; $i++) {
			$dum0[$i]=~s/G//;
			$str=sprintf("%s%6s ",$str,$dum0[$i]);
		}
		my $angles1=1.60/$opt->{rad};
		my $angles2=2.27/$opt->{rad};
#		my $angles1=$dum0[4];
#		my $fc1 = 2*$dum0[3]*$opt->{kcal2kj};
		my $fc1 = 2*106.4*$opt->{kcal2kj};
		my $fc2 = 2*26.3*$opt->{kcal2kj};
		my $gamma = 0.1;
		my $epsa  = 4.3*$opt->{kcal2kj};
		push(@{$opt->{db_angles}->{atoms}},$str);
		push(@{$opt->{db_angles}->{min1}},$angles1);
		push(@{$opt->{db_angles}->{min2}},$angles2);
		push(@{$opt->{db_angles}->{const1}},$fc1);
		push(@{$opt->{db_angles}->{const2}},$fc2);
		push(@{$opt->{db_angles}->{gamma}},$gamma);
		push(@{$opt->{db_angles}->{epsa}},$epsa);
	}
}
sub setangle {
	my ($opt)=@_;
	@{$opt->{db_angles}->{atoms}}=();
	@{$opt->{db_angles}->{min1}}=();
	@{$opt->{db_angles}->{const1}}=();
	for (my $iangl = 0;$iangl<scalar(@{$opt->{angles}->[0]});$iangl++) {
		my (@dum0)=split(' ',$opt->{angles}->[0]->[$iangl]);
		my $str="";
		for (my $i = 0;$i < 3; $i++) {
			$dum0[$i]=~s/G//;
			$str=sprintf("%s%6s ",$str,$dum0[$i]);
		}
		my $fc1 = 2*$dum0[3]*$opt->{kcal2kj};
		my $angles1=$dum0[4];
		push(@{$opt->{db_angles}->{atoms}},$str);
		push(@{$opt->{db_angles}->{min1}},$angles1);
		push(@{$opt->{db_angles}->{const1}},$fc1);
	}
}
sub setdihed {
	my ($opt)=@_;
	@{$opt->{db_dihed}->{atoms}}=();
	@{$opt->{db_dihed}->{min}}=();
	@{$opt->{db_dihed}->{const}}=();
	@{$opt->{db_dihed}->{period}}=();
	for (my $idihe = 0;$idihe<scalar(@{$opt->{diheds}->[0]});$idihe++) {
		my (@dum0)=split(' ',$opt->{diheds}->[0]->[$idihe]);
		my $str="";
		for (my $i = 0;$i < 4; $i++) {
			$dum0[$i]=~s/G//;
			$str=sprintf("%s%6s ",$str,$dum0[$i]);
		}
		my $fc = $dum0[4]*$opt->{kcal2kj};
		my $period = $dum0[5];
		my $dihed = $dum0[6];
		push(@{$opt->{db_dihed}->{atoms}},$str);
		push(@{$opt->{db_dihed}->{min}},$dihed);
		push(@{$opt->{db_dihed}->{const}},$fc);
		push(@{$opt->{db_dihed}->{period}},$period);
	}
}

sub setnonb {
	my ($opt)=@_;
	@{$opt->{db_nonb}->{atoms}}=();
	@{$opt->{db_nonb}->{charge}}=();
	@{$opt->{db_nonb}->{const}}=();
	@{$opt->{db_nonb}->{min}}=();
	for (my $inonb = 0;$inonb<scalar(@{$opt->{nonbonds}->[0]});$inonb++) {
		my (@dum0)=split(' ',$opt->{nonbonds}->[0]->[$inonb]);
		$dum0[0]=~s/G//;
		my $str=sprintf("%6s",$dum0[0]);

		my $min = $dum0[3];
		for (my $inum = 0;$inum<scalar(@{$opt->{nonbonds}});$inum++) {
			my (@dum)=split(' ',$opt->{nonbonds}->[$inum]->[$inonb]);
			if ($min > $dum[3]) {
				$min=$dum[3];
			}
		}
		my $charge = $dum0[1];
		my $fc = -$dum0[2]*$opt->{kcal2kj}/4.0;
		$min = $min*$opt->{ang2nm};
		push(@{$opt->{db_nonb}->{atoms}},$str);
		push(@{$opt->{db_nonb}->{charge}},$charge);
		push(@{$opt->{db_nonb}->{min}},$min);
		push(@{$opt->{db_nonb}->{const}},$fc);
	}
}

sub setcontacts_multi {
	my ($opt)=@_;
	&countcont($opt);
	&separation_cont($opt);
}

sub setcontacts {
	my ($opt)=@_;
	&countcont_single($opt);
}

sub separation_cont {
	my ($opt)=@_;

	@{$opt->{db_multi_contacts}->{atoms}}=();
	@{$opt->{db_multi_contacts}->{const}}=();
	@{$opt->{db_multi_contacts}->{min}}=();
	@{$opt->{db_multi_contacts}->{model}}=();
	@{$opt->{db_mix_contacts}->{atoms}}=();
	@{$opt->{db_mix_contacts}->{const}}=();
	@{$opt->{db_mix_contacts}->{min}}=();
	for (my $i = 0;$i<scalar(@{$opt->{db_contacts}->{atoms_min}});$i++) {
		my $str=sprintf("%6s %6s",
				$opt->{db_contacts}->{atoms_min}->[$i],
				$opt->{db_contacts}->{atoms_max}->[$i]);
		if (scalar(@{$opt->{db_contacts}->{models}->[$i]}) == 
				scalar(@{$opt->{paramfiles}})) {
			my $mindist=0;
			my $maxdist=0;
			my $average=0;
			my $contmp=0;
			my $minflag=-1;
			for (my $if = 0; $if < scalar(@{$opt->{db_contacts}->{models}->[$i]});
					$if++) {
				my $icont=$opt->{db_contacts}->{contnum}->[$i]->[$if];
				my $imodel=$opt->{db_contacts}->{models}->[$i]->[$if];
				my $contstr = $opt->{contacts}->[$imodel]->[$icont];
				my (@dum)=split(' ',$contstr);
				if ($if==0) {
					$contmp=$dum[2];
				}
				if ($if==0 || $mindist > $dum[3]) {
					$mindist = $dum[3];
					$minflag=$if;
				}
				if ($if==0 || $maxdist < $dum[3]) {
					$maxdist = $dum[3];
				}
				$average+=$dum[3];
			}
			if ($maxdist-$mindist < $opt->{distcrit}) {
				my $dtmp=$average/scalar(@{$opt->{db_contacts}->{models}->[$i]});
#			printf STDERR "%d %f %f %f %f\n",
#				   scalar(@{$opt->{db_mix_contacts}->{atoms}}),
#				   $mindist, $maxdist, $average, $dtmp;
				$dtmp=$dtmp*$opt->{ang2nm};
				$contmp=-$contmp*$opt->{kcal2kj}*$opt->{contact_ratio};
				push(@{$opt->{db_mix_contacts}->{atoms}},$str);
				push(@{$opt->{db_mix_contacts}->{const}},$contmp);
				push(@{$opt->{db_mix_contacts}->{min}},$dtmp);
			} else {
				my $icont=$opt->{db_contacts}->{contnum}->[$i]->[$minflag];
				my $imodel=$opt->{db_contacts}->{models}->[$i]->[$minflag];
				my $contstr = $opt->{contacts}->[$imodel]->[$icont];
				my (@dum)=split(' ',$contstr);
				$dum[3]=$dum[3]*$opt->{ang2nm};
				$dum[2]=-$dum[2]*$opt->{kcal2kj}*$opt->{contact_ratio};
				push(@{$opt->{db_multi_contacts}->{atoms}},$str);
				push(@{$opt->{db_multi_contacts}->{model}},$imodel);
				push(@{$opt->{db_multi_contacts}->{const}},$dum[2]);
				push(@{$opt->{db_multi_contacts}->{min}},$dum[3]);
			}

		} else {
			for (my $if = 0; $if < scalar(@{$opt->{db_contacts}->{models}->[$i]});
					$if++) {
				my $icont=$opt->{db_contacts}->{contnum}->[$i]->[$if];
				my $imodel=$opt->{db_contacts}->{models}->[$i]->[$if];
				my $contstr = $opt->{contacts}->[$imodel]->[$icont];
				my (@dum)=split(' ',$contstr);
				$dum[3]=$dum[3]*$opt->{ang2nm};
				$dum[2]=-$dum[2]*$opt->{kcal2kj}*$opt->{contact_ratio};
				push(@{$opt->{db_multi_contacts}->{atoms}},$str);
				push(@{$opt->{db_multi_contacts}->{model}},$imodel);
				push(@{$opt->{db_multi_contacts}->{const}},$dum[2]);
				push(@{$opt->{db_multi_contacts}->{min}},$dum[3]);
			}
		}
	}
}

sub countcont {
	my ($opt)=@_;

	@{$opt->{db_contacts}->{atoms_min}}=();
	@{$opt->{db_contacts}->{atoms_max}}=();
	@{$opt->{db_contacts}->{models}}=();
	@{$opt->{db_contacts}->{contnum}}=();

	for (my $inum = 0;$inum<scalar(@{$opt->{contacts}});$inum++) {
		for (my $icont = 0;$icont<scalar(@{$opt->{contacts}->[$inum]});
				$icont++) {
			my (@dum0)=split(' ',$opt->{contacts}->[$inum]->[$icont]);
			my $min = $dum0[0];
			my $max = $dum0[1];
			$min=~s/G//;
			$max=~s/G//;
			if ($min > $max) {
				$min = $dum0[1];
				$max = $dum0[0];
			}
			my $flag=-1;
			for (my $imin = 0;$imin<scalar(@{$opt->{db_contacts}->{atoms_min}});
					$imin++) {
				if ($opt->{db_contacts}->{atoms_min}->[$imin] == $min &&
						$opt->{db_contacts}->{atoms_max}->[$imin] == $max) {
					$flag=$imin;
					last;
				}
			}
			if ($flag == -1) {
				push(@{$opt->{db_contacts}->{atoms_max}},$max);
				push(@{$opt->{db_contacts}->{atoms_min}},$min);
				$flag=scalar(@{$opt->{db_contacts}->{atoms_min}})-1;
				@{$opt->{db_contacts}->{models}->[$flag]}=();
				@{$opt->{db_contacts}->{contnum}->[$flag]}=();
			}
			push(@{$opt->{db_contacts}->{models}->[$flag]},$inum);
			push(@{$opt->{db_contacts}->{contnum}->[$flag]},$icont);
		}
	}
}

sub countcont_single {
	my ($opt)=@_;

	@{$opt->{single_contacts}->{atoms}}=();
	@{$opt->{single_contacts}->{const}}=();
	@{$opt->{single_contacts}->{min}}=();

	for (my $inum = 0;$inum<scalar(@{$opt->{contacts}});$inum++) {
		for (my $icont = 0;$icont<scalar(@{$opt->{contacts}->[$inum]});
				$icont++) {
			my (@dum0)=split(' ',$opt->{contacts}->[$inum]->[$icont]);
			my $min = $dum0[0];
			my $max = $dum0[1];
			$min=~s/G//;
			$max=~s/G//;
			if ($min > $max) {
				$min = $dum0[1];
				$max = $dum0[0];
			}
			my $str=sprintf("%6s %6s",$min,$max);
			push(@{$opt->{single_contacts}->{atoms}},$str);
			$dum0[3]=$dum0[3]*$opt->{ang2nm};
			$dum0[2]=-$dum0[2]*$opt->{kcal2kj};
			push(@{$opt->{single_contacts}->{const}},$dum0[2]);
			push(@{$opt->{single_contacts}->{min}},$dum0[3]);
		}
	}
}

sub getKBparam {
	my ($inum, $opt)=@_;
	open(INFILE,$opt->{paramfiles}->[$inum]) 
		|| die "Cannot open $opt->{paramfiles}->[$inum]\n";
	@{$opt->{bonds}->[$inum]}=();
	@{$opt->{angles}->[$inum]}=();
	@{$opt->{diheds}->[$inum]}=();
	@{$opt->{contacts}->[$inum]}=();
	@{$opt->{nonbonds}->[$inum]}=();
	$opt->{maxres}=0;
	my $ichk=0;
	my $ibond=0;
	my $iangl=0;
	my $idihe=0;
	my $inonb=0;
	while(<INFILE>){
		if ($ichk==1) {
			if (/^\s*$/) {
				$ichk=0;
			} else {
				push(@{$opt->{contacts}->[$inum]},$_);
			}
		} elsif ($ibond==1) {
			if (/^\s*$/) {
				$ibond=0;
			} else {
				my (@dum)=split(' ',$_);
				$dum[1]=~s/G//;
				$opt->{maxres}=$dum[1];
				push(@{$opt->{bonds}->[$inum]},$_);
			}
		} elsif ($iangl==1) {
			if (/^\s*$/) {
				$iangl=0;
			} else {
				push(@{$opt->{angles}->[$inum]},$_);
			}
		} elsif ($idihe==1) {
			if (/^\s*$/) {
				$idihe=0;
			} else {
				push(@{$opt->{diheds}->[$inum]},$_);
			}
		} elsif ($inonb==1) {
			if (/^NBF/) {
				$inonb=0;
			} else {
				if (!/^\s*$/) {
					push(@{$opt->{nonbonds}->[$inum]},$_);
				}
			}
		}
		if (/^NBFIX/) {
			$ichk=1;
		}
		if (/^BOND/) {
			$ibond=1;
		}
		if (/^ANGLE/) {
			$iangl=1;
		}
		if (/^DIHED/) {
			$idihe=1;
		}
		if (/^NONBON/) {
			$_=<INFILE>;
			$_=<INFILE>;
			$inonb=1;
		}
	}
	close(INFILE);
}
sub readpdb {
	my ($opt)=@_;
	open(INFILE,$opt->{pdbfiles}->[0]) || die "Cannot open $opt->{pdbfiles}->[0]\n";
	@{$opt->{coor}->{name}}=();
	@{$opt->{coor}->{res}}=();
	while(<INFILE>){
		if (/^ATOM/) {
			my $atom=substr($_,11,4);
			my $res=substr($_,17,3);
			push(@{$opt->{coor}->{name}},$atom);
			push(@{$opt->{coor}->{res}},$res);
		}
	}
	close(INFILE);
}
sub readpdb_coord {
	my ($opt)=@_;
	@{$opt->{cx}}=();
	@{$opt->{cy}}=();
	@{$opt->{cz}}=();

	for (my $inum = 0;$inum<scalar(@{$opt->{pdbfiles}});$inum++) {
		open(INFILE,$opt->{pdbfiles}->[$inum]) || 
			die "Cannot open $opt->{pdbfiles}->[$inum]\n";
		@{$opt->{cx}->[$inum]}=();
		@{$opt->{cy}->[$inum]}=();
		@{$opt->{cz}->[$inum]}=();
		while(<INFILE>){
			if (/^ATOM/) {
				my $x=substr($_,30,8);
				my $y=substr($_,38,8);
				my $z=substr($_,46,8);
				push(@{$opt->{cx}->[$inum]},$x);
				push(@{$opt->{cy}->[$inum]},$y);
				push(@{$opt->{cz}->[$inum]},$z);
			}
		}
		close(INFILE);
	}
}
sub climber_force {
	my ($opt)=@_;
	@{$opt->{morph}->{atoms}}=();
	@{$opt->{morph}->{min}}=();

	&readpdb_coord($opt);
	for (my $iatm = 0;$iatm <scalar(@{$opt->{cx}->[0]});$iatm++) {
		my ($c0x,$c0y,$c0z,$c1x,$c1y,$c1z);
		$c0x=$opt->{cx}->[0]->[$iatm];
		$c0y=$opt->{cy}->[0]->[$iatm];
		$c0z=$opt->{cz}->[0]->[$iatm];
		$c1x=$opt->{cx}->[1]->[$iatm];
		$c1y=$opt->{cy}->[1]->[$iatm];
		$c1z=$opt->{cz}->[1]->[$iatm];
		for (my $jatm = $iatm+1;$jatm <scalar(@{$opt->{cx}->[0]});$jatm++) {
			my ($d0x,$d0y,$d0z,$d1x,$d1y,$d1z,$r0,$r1);
			$d0x=$c0x-$opt->{cx}->[0]->[$jatm];
			$d0y=$c0y-$opt->{cy}->[0]->[$jatm];
			$d0z=$c0z-$opt->{cz}->[0]->[$jatm];
			$r0 = sqrt($d0x*$d0x+$d0y*$d0y+$d0z*$d0z);

			$d1x=$c1x-$opt->{cx}->[1]->[$jatm];
			$d1y=$c1y-$opt->{cy}->[1]->[$jatm];
			$d1z=$c1z-$opt->{cz}->[1]->[$jatm];
			$r1 = sqrt($d1x*$d1x+$d1y*$d1y+$d1z*$d1z);
			my $rdiff=abs($r1-$r0);
			my $rmin= $r0;
			if ($r0 > $r1) {
				$rmin=$r1;
			}
			if ($r0 > $opt->{climber_dist} && 
					$r1 > $opt->{climber_dist} && 
					$rdiff > $opt->{climber_min_diff} &&
					$rmin < $opt->{climber_max_dist}) {
				my $str=sprintf("%6s %6s",$iatm+1,$jatm+1);
				push(@{$opt->{morph}->{atoms}},$str);
				push(@{$opt->{morph}->{min}},$r1*$opt->{ang2nm});
			}
		}
	}
}

sub getopt {
	my ($opt)=@_;
	if ($ARGV[0] eq "") {
		printf STDERR "MBGO_parm.pl -out out.parm\n";

	}
	$opt->{param}="";
	$opt->{out}="";
	$opt->{distcrit}=1.5;
	$opt->{climber_dist}=10.0;
	$opt->{climber_max_dist}=50.0;
	$opt->{climber_min_diff}=5.0;
	$opt->{ang2nm}=0.100000000000;
	$opt->{kcal2kj}=4.18400000000000000000;
	$opt->{rmin}=4.0*$opt->{ang2nm};
	$opt->{eps}=0.000132*$opt->{kcal2kj}/4.0;
	$opt->{climber}=0;
	GetOptions (
			'param=s' => \$opt->{param},
			'pdb=s' => \$opt->{pdb},
			'out=s' => \$opt->{out},
			'climber' => \$opt->{climber},
			);
	(@{$opt->{paramfiles}})=split(/,/,$opt->{param});
	(@{$opt->{pdbfiles}})=split(/,/,$opt->{pdb});

	@{$opt->{bonds}}=();
	@{$opt->{angles}}=();
	@{$opt->{diheds}}=();
	@{$opt->{contacts}}=();
	@{$opt->{nonbonds}}=();
	$opt->{pi}=3.14159265358979323846;
	$opt->{rad}=$opt->{pi}/180.0;
	$opt->{contact_ratio}=2.5;
#	$opt->{contact_ratio}=1.0;
	%{$opt->{mass}}= (
			 "ALA"=>71.000000,
			 "ARG"=>157.000000,
			 "ASN"=>114.000000,
			 "ASP"=>114.000000,
			 "CYS"=>103.000000,
			 "GLN"=>128.000000,
			 "GLU"=>128.000000,
			 "GLY"=>57.000000,
			 "HIS"=>138.000000,
			 "ILE"=>113.000000,
			 "LEU"=>113.000000,
			 "LYS"=>128.000000,
			 "MET"=>131.000000,
			 "PHE"=>147.000000,
			 "PRO"=>97.000000,
			 "SER"=>87.000000,
			 "THR"=>101.000000,
			 "TYR"=>163.000000,
			 "TRP"=>186.000000,
			 "VAL"=>99.000000,
		);
}

