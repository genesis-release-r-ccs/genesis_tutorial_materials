#!/usr/bin/perl
#
use strict;
use warnings;
my $opt={};
$opt->{header}=$ARGV[0];
$opt->{nimage}=16;
$opt->{nskip}=1;
$opt->{path_suf}="rpath";
$opt->{pdbfile} = "../../1_setup/rbp_closed_CA.pdb";

readpdb($opt);
readpath($opt);

sub readpath {
	my ($opt)=@_;
	for (my $i = 1;$i<=$opt->{nimage};$i++) {
		my $file=sprintf("%s.%d.%s",$opt->{header},$i,$opt->{path_suf});
		my $ofile=sprintf("%s.trace.%d.pdb",$opt->{header},$i);
		open(OUTFILE,">".$ofile) or die "Cannot open $ofile\n";
		open(INFILE,$file) or die "Cannot open $file\n";
		my $ifile=0;
		my $string="";
		my $imo=0;
		while(<INFILE>){
			if (/^\s+[0-9]./) {
				$string=$_;
				my (@dum)=split(' ',$string);
				$imo++;
				printf OUTFILE "MODEL     %-4d\n",$imo;
				my $ic=0;
				for (my $j = 1;$j<scalar(@dum);$j+=3) {
					printf OUTFILE "%s%8.3f%8.3f%8.3f%s",
						   $opt->{atom}->[$ic],
						   $dum[$j], $dum[$j+1], $dum[$j+2],
						   $opt->{segid}->[$ic];
						   $ic++;
				}
				printf OUTFILE "END\n";

			}
		}
		close(INFILE);
		close(OUTFILE);
	}
}

sub readpdb {
	my ($opt)=@_;
	open(INFILE,$opt->{pdbfile}) or die "Cannot open $opt->{pdbfile}\n";
	@{$opt->{atom}}=();
	@{$opt->{segid}}=();
	while(<INFILE>){
		if (/^ATOM/) {
			my $top=substr($_,0,30);
			push(@{$opt->{atom}},$top);
			my $last=substr($_,54);
			push(@{$opt->{segid}},$last);
		}
	}
	close(INFILE);
}
