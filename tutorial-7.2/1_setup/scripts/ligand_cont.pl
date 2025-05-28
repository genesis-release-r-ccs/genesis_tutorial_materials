#!/usr/bin/perl
#
use strict;
use warnings;
my $opt={};
$opt->{apo}="GO_apo.param";
$opt->{apopdb}="apo.pdb";
$opt->{holo}="GO_holo.param";
$opt->{holopdb}="holo.pdb";
$opt->{maxres}=0;
$opt->{criterion}=1.2;
$opt->{new}=sprintf("GO.interdom.c%f.param",$opt->{criterion});
@{$opt->{domains}}=(
		"1-103,233-265","104-232,266-271",
		);
@{$opt->{domainpair}}=("1-2");
@{$opt->{lig}}=();
for (my $k = 0; $k<=scalar(@{$opt->{domainpair}}); $k++) {
	@{$opt->{lig}->[$k]}=();
}
&setdomain($opt);
&readpdb($opt,"apo");
&readpdb($opt,"holo");
&readcontact($opt,"apo");
&readcontact($opt,"holo");
&analysis_contact($opt,"apo","holo");
&ligand_contact($opt,"apo");
&out_newparam($opt,"apo");

sub out_newparam {
	my ($opt,$state)=@_;
	open(INFILE,$opt->{$state}) || die "Cannot open $opt->{state}\n";
	open(OUTFILE,">".$opt->{new}) || die "Cannot open $opt->{new}\n";

	@{$opt->{data}->{$state}}=();
	my $flag=0;
	while(<INFILE>) {
		if (/^NBFIX/) {
			printf OUTFILE $_;
			for (my $i = 0;$i<scalar(@{$opt->{datasort}});$i++) {
				printf OUTFILE "%s\n",$opt->{datasort}->[$i];
			}
			$flag=1;
		} elsif ($flag==1) {
			if (/^\s*$/) {
				$flag=0;
				printf OUTFILE $_;
			}
		} else {
			printf OUTFILE $_;
		}
	}
	close(INFILE);
	close(OUTFILE);
}

sub ligand_contact {
	my ($opt,$state)=@_;
	for (my $k = 0; $k<scalar(@{$opt->{domainpair}}); $k++) {
		printf STDOUT "#%s\n",$opt->{domainpair}->[$k];
		for (my $j = 0;$j<scalar(@{$opt->{lig}->[$k]});$j++) {
			printf STDOUT "%s\n",$opt->{lig}->[$k]->[$j];
			$opt->{lig}->[$k]->[$j]=sprintf("%s  !lig",$opt->{lig}->[$k]->[$j]);

			push(@{$opt->{data}->{$state}},$opt->{lig}->[$k]->[$j]);
		}
	}
	 @{$opt->{datasort}} = sort { substr((split(' ',$a))[0],1) <=> substr((split(' ',$b))[0],1) } @{$opt->{data}->{$state}};
}

sub analysis_contact {
	my ($opt,$calcstate,$refstate)=@_;
	for (my $i = 0;$i<scalar(@{$opt->{data}->{$refstate}});$i++) {
		my (@dum)=split(' ',$opt->{data}->{$refstate}->[$i]);
		my $flag=0;
		for (my $j = 0;$j<scalar(@{$opt->{data}->{$calcstate}});$j++) {
			my (@dum2)=split(' ',$opt->{data}->{$calcstate}->[$j]);
			if ($dum[0] eq $dum2[0] && $dum[1] eq $dum2[1]) {
				$flag =1;
				last;
			}
		}
		if ($flag==0) {
			my $f1 = $dum[0];
			my $f2 = $dum[1];
			$f1 =~s/G//;
			$f2 =~s/G//;
			$f1--;
			$f2--;
			my $drx = $opt->{coord}->{$refstate}->{x}->[$f1]-
				$opt->{coord}->{$refstate}->{x}->[$f2];
			my $dry = $opt->{coord}->{$refstate}->{y}->[$f1]-
				$opt->{coord}->{$refstate}->{y}->[$f2];
			my $drz = $opt->{coord}->{$refstate}->{z}->[$f1]-
				$opt->{coord}->{$refstate}->{z}->[$f2];
			my $dr  = sqrt($drx*$drx+$dry*$dry+$drz*$drz);

			my $dcx = $opt->{coord}->{$calcstate}->{x}->[$f1]-
				$opt->{coord}->{$calcstate}->{x}->[$f2];
			my $dcy = $opt->{coord}->{$calcstate}->{y}->[$f1]-
				$opt->{coord}->{$calcstate}->{y}->[$f2];
			my $dcz = $opt->{coord}->{$calcstate}->{z}->[$f1]-
				$opt->{coord}->{$calcstate}->{z}->[$f2];
			my $dc  = sqrt($dcx*$dcx+$dcy*$dcy+$dcz*$dcz);
			$opt->{data}->{$refstate}->[$i]=sprintf("%s !com %f %f",
					$opt->{data}->{$refstate}->[$i] ,$dr,$dc);
			if ($dc < $opt->{criterion}*$dr) {
				$flag =1;
			}
		}
		if ($flag==0) {
			for (my $k = 0; $k<scalar(@{$opt->{domainpair}}); $k++) {
				my ($fst,$end)=split(/-/,$opt->{domainpair}->[$k]);
				$fst--;
				$end--;
				my $f1 = $dum[0];
				my $f2 = $dum[1];
				$f1 =~s/G//;
				$f2 =~s/G//;
				if (($opt->{residues}->[$f1] == $fst &&
							$opt->{residues}->[$f2] == $end) || 
						($opt->{residues}->[$f1] == $end &&
						 $opt->{residues}->[$f2] == $fst) ) {
					push(@{$opt->{lig}->[$k]},$opt->{data}->{$refstate}->[$i]);
				}
			}
		}
	}
}

sub setdomain {
	my ($opt)=@_;
	@{$opt->{residues}}=();
	for (my $i = 0 ;$i<=$opt->{maxres};$i++) {
		push(@{$opt->{residues}},-1);
	}
	for (my $i = 0;$i<scalar(@{$opt->{domains}});$i++) {
		my (@dum)=split(/,/,$opt->{domains}->[$i]);
		for (my $j = 0;$j<scalar(@dum);$j++) {
			my ($fst,$end)=split(/-/,$dum[$j]);
			for (my $k =$fst ;$k<=$end;$k++) {
				$opt->{residues}->[$k] = $i;
			}
		}
	}
}
sub readpdb {
	my ($opt,$state)=@_;
	my $statepdb=sprintf("%spdb",$state);
	open(INFILE,$opt->{$statepdb}) || die "Cannot open $opt->{statepdb}\n";
	@{$opt->{coord}->{$state}->{x}}=();
	@{$opt->{coord}->{$state}->{y}}=();
	@{$opt->{coord}->{$state}->{z}}=();
	while(<INFILE>) {
		if (/^ATOM/) {
			my $name=substr($_,12,4);
			$name=~s/ //g;
			if ($name eq "CA") {
				my $x = substr($_,30,8);
				my $y = substr($_,38,8);
				my $z = substr($_,46,8);
				push(@{$opt->{coord}->{$state}->{x}},$x);
				push(@{$opt->{coord}->{$state}->{y}},$y);
				push(@{$opt->{coord}->{$state}->{z}},$z);
			}
		}
	}
	close(INFILE);
}

sub readcontact {
	my ($opt,$state)=@_;
	open(INFILE,$opt->{$state}) || die "Cannot open $opt->{state}\n";
	@{$opt->{data}->{$state}}=();
	my $flag=0;
	while(<INFILE>) {
		if (/^NBFIX/) {
			$flag=1;
		} 
		if ($flag == 1) {
			my (@dum)=split(' ');
			if (scalar(@dum) == 4) {
				chomp;
				push(@{$opt->{data}->{$state}},$_);
			}
		}
	}
	close(INFILE);
}
