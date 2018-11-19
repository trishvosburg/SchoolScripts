'''
Created on Oct 17, 2018

@author: trish

'''

# Open blast file and output file:
blast_file = open("/scratch/RNASeq/blastp.outfmt6")
output_file = open("parsed_blast.txt", "w")

# For each line in the blast file, 
for line in blast_file:
    # Split the whole thing on tabs
    variables = line.split('\t')
    
    # Isolate just the first position in the list for later splitting
    transcript_and_isoform = variables[0]
    
    # Isolate just the second position in the list for later splitting
    other_variables = variables[1]
    
    # Get pident
    pident = variables[2]
    
    # Split the transcript and isoform by |
    transcript_and_isoform_split = transcript_and_isoform.split('|')
    
    # Get transcript and isoform
    transcript = transcript_and_isoform_split[0]
    isoform = transcript_and_isoform_split[1]
    
    # Split the other variables by |
    other_variables_split = other_variables.split('|')
    
    # Get swissprot
    swissprot = other_variables_split[3]
    
    # Write everything tab separated to output file
    output_file.write("\t".join([transcript, isoform, swissprot, pident]) + '\n')
    
# Close both files:
output_file.close()
blast_file.close()