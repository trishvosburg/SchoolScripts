'''
Created on Oct 24, 2018

@author: trish
'''
import re

blast_file = open('/scratch/RNASeq/blastp.outfmt6')
diff_expr_file = open('/scratch/RNASeq/diffExpr.P1e-3_C2.matrix')
output_file = open("BLAST_protein_stress_conditions.txt", "w")

# Function to parse a single line of BLAST output and return transcript ID and SwissProt ID
def analyze_blast_line(line):
    m1 = re.search(r"(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})", line)
    if m1:
        transcript = m1.group(1)
    m2 = re.search(r"sp\|(.*)[.]\d{1}\|", line)
    if m2:
        swissprot = m2.group(1)
    return transcript, swissprot

# Test function:
test_line = blast_file.readline().rstrip("\n")
assert analyze_blast_line(test_line) == ('c0_g1_i1', 'Q9HGP0')

# Initialize dictionary:
blast_dictionary = {}

# Fill dictionary:
for line in blast_file:
    (transcript, swissprot) = analyze_blast_line(line)
    blast_dictionary[transcript] = swissprot

# Read in DE transcript and parse all fields
# Use dictionary to get corresponding SwissProt ID for each transcript ID
# Print SwissProt ID and 4 DE samples to output_file separated by tabs
for line in diff_expr_file:
    diff_transcript = ''
    sp_ds = ''
    sp_hs = ''
    sp_log = ''
    sp_plat = ''
    m1 = re.search(r"(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})", line)
    if m1:
        diff_transcript = m1.group(1)
    m2 = re.search(r"(\d+[.]\d+)[\t](\d+[.]\d+)[\t](\d+[.]\d+)[\t](\d+[.]\d+)", line)
    if m2:
        sp_ds = m2.group(1)
        sp_hs = m2.group(2)
        sp_log = m2.group(3)
        sp_plat = m2.group(4)
    if diff_transcript in blast_dictionary:
        output_file.write("\t".join([blast_dictionary[diff_transcript], sp_ds, sp_hs, sp_log, sp_plat]) + "\n")
    else:
        output_file.write("\t".join([diff_transcript, sp_ds, sp_hs, sp_log, sp_plat]) + "\n")
        
# Close files
blast_file.close()
diff_expr_file.close()