#!/usr/bin/perl 
#
use strict;
use warnings;
my $opt={};
my $idir=$ARGV[0];
$opt->{nimage}=16;
$opt->{nskip}=200;
$opt->{path_suf}="rpath";
$opt->{pdbfile} = "../../1_setup/rbp_closed_CA.pdb";
$opt->{refdir} = "../6-2_rpath_equilibrate_2/";
$opt->{pathfile}="../../1_setup/setpath.sh";
$opt->{refheader} = "eq2";
$opt->{template}="../../script/rmsd_fit_rpath.in";
$opt->{outdir}="rmsdir";
$opt->{header}=sprintf("pr%d",$idir);

get_path($opt);
$opt->{program}=sprintf("%s/rmsd_analysis",$opt->{dir});
if (! -d $opt->{outdir}) {
   mkdir($opt->{outdir});
}
readpdb($opt);
readin($opt);
readpath($opt);


sub readpath {
	my ($opt)=@_;
	my $rmsf_file=sprintf("%s.rms",$opt->{header});
	open(OUTRMSF,">".$rmsf_file)|| die "Cannot open $rmsf_file\n";
	for (my $i = 1;$i<=$opt->{nimage};$i++) {
		my $file=sprintf("%s.%d.%s",$opt->{header},$i,$opt->{path_suf});
		open(INFILE,$file)|| die "Cannot open $file\n";
		my $nstp=0;
		my $ifile=0;
		while(<INFILE>){
			if (/^\s+[0-9]./) {
				$nstp++;
				if ($nstp == $opt->{nskip}) {
					my (@dum)=split(' ');
					$ifile++;
					my $ofile=sprintf("%s/%s.%d-%d.pdb",
							$opt->{outdir},$opt->{header},$i,$ifile);
					open(OUTFILE,">".$ofile) or die "Cannot open $ofile\n";
					my $ic=0;
					for (my $j = 1;$j<scalar(@dum);$j+=3) {
						printf OUTFILE "%s%8.3f%8.3f%8.3f%s",
							   $opt->{atom}->[$ic],
							   $dum[$j], $dum[$j+1], $dum[$j+2],
							   $opt->{segid}->[$ic];
							   $ic++;
					}
					printf OUTFILE "END\n";
					close(OUTFILE);
					$nstp=0;
				}
			}
		}
		close(INFILE);
		my $tmpin=sprintf("%s/rmsin.%d",$opt->{outdir},$i);
		my $tmpout=sprintf("%s/rmsout.%d",$opt->{outdir},$i);
		my $output_rms=sprintf("%s/%s.%d.rms",
				$opt->{outdir},$opt->{header},$i);
		open(TMPIN,">".$tmpin) or die "Cannot open $tmpin\n";
		for (my $of=0;$of<scalar(@{$opt->{tempd}});$of++) {
			my $str=$opt->{tempd}->[$of];
			if ($str=~/^rmsfile/) {
				$str=sprintf("rmsfile  = %s",$output_rms);
			} elsif ($str=~/^reffile/) {
				$str=sprintf("reffile  = %s/%s.%d.pdb\n",
						$opt->{refdir},$opt->{refheader}, $i);
			} elsif ($str=~/^pdbfile/) {
				$str=sprintf("pdbfile  = %s/%s.%d.pdb\n",
						$opt->{refdir},$opt->{refheader}, $i);
			} elsif ($str=~/^trjfile1/) {
				$str="";
				for (my $j = 1;$j<=$ifile;$j++) {
					my $ofile=sprintf("%s/%s.%d-%d.pdb",
							$opt->{outdir},$opt->{header},$i,$j);
					$str=sprintf("%strjfile%d = %s\n",$str,$j,$ofile);
				}
			} elsif ($str=~/^repeat1/) {
				$str=sprintf("repeat1 = %d\n",$ifile);
			}
			printf TMPIN "%s",$str;
		}
		close(TMPIN);
		unlink($output_rms);
		my $command=sprintf("%s %s > %s",$opt->{program},$tmpin,$tmpout);
		system($command);
		open(RMSFILE,$output_rms) or die "Cannot open $output_rms\n";
		printf OUTRMSF " %3d ",$i;
		while(<RMSFILE>) {
			my (@dum)=split(' ');
			printf OUTRMSF "  %8.5f",$dum[1];
		}
		close(RMSFILE);
		printf OUTRMSF "\n";
#		unlink($output_rms);
#		for (my $j = 1;$j<=$ifile;$j++) {
#			my $ofile=sprintf("%s.%d-%d.pdb",$opt->{header},$i,$j);
#			unlink($ofile);
#		}
	}
	close(OUTRMSF);
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
sub readin {
	my ($opt)=@_;
	open(TEMPLATE,$opt->{template}) or die "Cannot open $opt->{template}\n";
	@{$opt->{tempd}}=();
	while(<TEMPLATE>){
		push(@{$opt->{tempd}},$_);
	}
	close(TEMPLATE);
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
