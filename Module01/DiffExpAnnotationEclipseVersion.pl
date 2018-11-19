#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';
use Data::Dumper;

#my $gene_to_GO_file = '/scratch/gene_association_subset.txt';
my $gene_to_GO_file =
  '/Users/trish/workspace/BINF6200/Module01/gene_association_subset.txt';

#my $blast_file      = '/scratch/RNASeq/blastp.outfmt6';
my $blast_file = '/Users/trish/workspace/BINF6200/Module01/blastp.outfmt6';

#my $diff_exp_file   = '/scratch/RNASeq/diffExpr.P1e-3_C2.matrix';
my $diff_exp_file =
  '/Users/trish/workspace/BINF6200/Module01/diffExpr.P1e-3_C2.matrix';

#my $GO_desc_file    = '/scratch/go-basic.obo';
my $GO_desc_file = '/Users/trish/workspace/BINF6200/Module01/go-basic.obo';

my $report_file = 'report.txt';

# Open a filehandle for the gene ID to GO term.
open( GENE_TO_GO, '<', $gene_to_GO_file ) or die $!;

# Open a filehandle for the BLAST output file.
open( BLAST, '<', $blast_file ) or die $!;

# Open a filehandle for the Trinity output file.
open( DIFF_EXP, '<', $diff_exp_file ) or die $!;

# Open a filehandle for the basic GO file.
open( GO_DESC, '<', $GO_desc_file ) or die $!;

# Open a filehandle to write the report.
open( REPORT, '>', $report_file ) or die $!;

# Hash to store gene-to-GO term mappings.
my %gene_to_GO;
my $transcriptID;
my $proteinID;

# Hash to store gene-to-GO term descriptions mappings.
my %GO_to_description;

# Hash to store BLAST mappings.
my %transcript_to_protein;

# Subroutines
read_GO_desc();
read_blast();
read_gene_to_GO();
print_report();

# Close files.
close GENE_TO_GO;
close BLAST;
close DIFF_EXP;
close GO_DESC;
close REPORT;

# Load transcript IDs of query sequence (qseqid) and SwissProt IDs of subject sequence
# (sseqid) without version number to hash for lookup.
sub read_blast {

	# Read in the BLAST file, chomp each line, and then split each line on tabs
	# Trim the transcriptID so it doesn't include the version number
	# Trim the protein ID column (2nd column) so it's only the protein ID
	# Create a hash with transcriptID as the key and proteinID as the value
	while ( my $line = <BLAST> ) {
		chomp $line;
		my @tabSplitBLAST = split( /\t/, $line );
		my $limit = 99;
		my $blast_percent = $tabSplitBLAST[2];
		my $untrimmedTranscriptID = $tabSplitBLAST[0];
		if ( $untrimmedTranscriptID =~ m/^(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})/g ) {
			$transcriptID = $1;
		}
		my $untrimmedProteinID = $tabSplitBLAST[1];
		if ( $untrimmedProteinID =~ m/sp\|(\w+)\./g ) {
			$proteinID = $1;
		}
		if ( ($transcript_to_protein{$transcriptID}) && ($blast_percent > $limit))  {
			# add it to the hash?
			$transcript_to_protein{$transcriptID} = $proteinID;
	}
}

# Print the hash to make sure it's correct:
print Dumper(\%transcript_to_protein);

# Load protein IDs and corresponding GO terms to hash for lookup.
sub read_gene_to_GO {
	

	# Read in the GO annotation file, chomp each line, split each line on tabs
	# Extract 2nd column which is the object ID
	# Extract the 4th column which is the GO ID
	# Create a hash with the object ID as the key and GO ID as the value
	while ( my $line = <GENE_TO_GO> ) {
		chomp $line;
		my @tabSplitGene = split( /\t/, $line );
		my $objectID              = $tabSplitGene[1];
		my $GoID                  = $tabSplitGene[4];
		# If the object ID already exists,
		if( $gene_to_GO{$objectID} ){  
  			# skip over it
  			next;   
  				# Otherwise, create it in the hash
				} else {                 
  					$gene_to_GO{$objectID} = $GoID;
				}
	}
}

# Print the hash to make sure it's correct:
#print Dumper(\%gene_to_GO);
#say $gene_to_GO{B5BP47};
#say $gene_to_GO{O14044};

# Load GO terms and GO descriptions to hash for lookup.
sub read_GO_desc {
	

	# Change the EOL from "\n" to "[Term]" so that one entire GO term record will be read
	#	in for easier parsing.
	# Read in the GO_desc file, chomp each line
	# Use regex to extract just the GO Terms from the "id:" field
	# Use regex to extract just the GO Names from the "name:" field
	# Create a hash with GO Term as the key and GO Name as the value
	local $/ = '[Term]';
	my $GoID2;
	my $GoName;
	while ( my $line = <GO_DESC> ) {
		chomp $line;
		if ( $line =~ /id:\s(GO:[0-9]+)/ ) {
			$GoID2 = $1;
		}
		if ( $line =~ /name:\s(.*)/ ) {
			$GoName = $1;
		}
#		if( $GO_to_description{$GoID2} ){  
#  			# skip over it
#  			next;   
#  				# Otherwise, create it in the hash
#				} else {                 
#  					$GO_to_description{$GoID2} = $GoName;
#				}
		$GO_to_description{$GoID2} = $GoName if defined $GoID2
		;
	}
}

# Print hash to make sure it's correct:
print Dumper(\%GO_to_description);
say $GO_to_description{'GO:0000463'};

# Declare globals for the print_report subroutine:
my $protein_ID;
my $finalGoTerm = 'NA';
my $finalGoDesc = 'NA';
my $trinityID;
my $dataSample1;
my $dataSample2;
my $dataSample3;
my $dataSample4;

# Loop through differential expression file; lookup the (SwissProt) protein ID + description
# and GO term + name; print results to REPORT output.
sub print_report {

	# Read in Differential expression file, chomp each line, split it on tabs
	# Create trinityID and 4 data samples variables for easier parsing
	while ( my $line = <DIFF_EXP> ) {
		chomp $line;
		my @tabSplitTrinity = split( /\t/, $line );
		$trinityID   = $tabSplitTrinity[0];
		$dataSample1 = $tabSplitTrinity[1];
		$dataSample2 = $tabSplitTrinity[2];
		$dataSample3 = $tabSplitTrinity[3];
		$dataSample4 = $tabSplitTrinity[4];

	   # Check if the trinityID is in the %transcript_to_protein hash; if it is:
		if ( defined $transcript_to_protein{$trinityID} ) {

			# Get corresponding protein ID
			$protein_ID = $transcript_to_protein{$trinityID};

			# Check if protein ID is found in GENE_TO_GO hash, if it is:
			if ( defined $gene_to_GO{$protein_ID} ) {

				# Get its corresponding GO term
				$finalGoTerm = $gene_to_GO{$protein_ID};

				# Check if GO term is found in GENE_DESC hash, if it is:
				if ( defined $GO_to_description{$finalGoTerm} ) {

					# Get corresponding GO description
					$finalGoDesc = $GO_to_description{$finalGoTerm};
				}
				else { $finalGoDesc = 'NA'; }
			}
			else { $finalGoTerm = 'NA'; }
		}
		else { $protein_ID = 'NA'; }

		#get_protein_info_from_blast_DB($protein_ID);
		print REPORT join( "\t",
			$trinityID,   $protein_ID,  $finalGoTerm, $dataSample1,
			$dataSample2, $dataSample3, $dataSample4, $finalGoDesc ),
		  "\n";
	}
}

# Get description of $protein_id from BLAST database.
#sub get_protein_info_from_blast_DB {
#	my ( $protein_id ) = @_;
#	my $db = '/blastDB/swissprot';
#	my $exec = 'blastdbcmd -db '
#	  . $db
#	  . ' -entry '
#	  . $protein_id
#	  . ' -outfmt "%t" -target_only | ';
#
#	open( SYSCALL, $exec ) or die "Can't open the SYSCALL ", $!;
#
#	# Set default description as "NA". If protein is found in DB, overwrite description.
#	my $protein_description = 'NA';
#	while (<SYSCALL>) {
#		chomp;
#		if ( $_ =~ /RecName:\s+(.*)/i ) {
#			$protein_description = $1;
#		}
#	}
#	close SYSCALL;
#	return $protein_description;
#}
