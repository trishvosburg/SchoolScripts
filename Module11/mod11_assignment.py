'''
Created on Nov 14, 2018

@author: trish
'''
import re

blast_file = open('/scratch/RNASeq/blastp.outfmt6')
diff_expr_file = open('/scratch/RNASeq/diffExpr.P1e-3_C2.matrix')
output_file = open("mod11_report.txt", "w")

# Function to parse a single line of BLAST output and return transcript ID and SwissProt ID
def analyze_blast_line(line):
    m1 = re.search(r"(c\d{1,4}_\w{1}\d{1}_\w{1}\d{1})", line)
    if m1:
        transcript = m1.group(1)
    m2 = re.search(r"sp\|(.*)[.]\d{1}\|", line)
    if m2:
        swissprot = m2.group(1)
    return transcript, swissprot

# Initialize dictionary:
blast_dictionary = {}

# Fill dictionary:
for line in blast_file:
    (transcript, swissprot) = analyze_blast_line(line)
    blast_dictionary[transcript] = swissprot

# Function to parse one line of DE data and make it a tuple:
def parse_DE(DE_line):
    DE_fields = DE_line.rstrip("\n").split("\t")
    # The first element in the tuple should be the protein ID, if not found, first element will be transcript
    if DE_fields[0] in blast_dictionary:
        DE_fields[0] = blast_dictionary[DE_fields[0]]
    # Convert list to tuple to ensure that state never changes and return as tuple
    return(tuple(DE_fields))

# Function to convert one list of tuples to a tab-separated string
def tuple_to_tab_sep(list_of_tuples):
    return "\t".join(list_of_tuples)

# Create list of tuples using map with parse_DE function and the DE file as input
list_of_DE_tuples = map(parse_DE, diff_expr_file.readlines())

# Tab-separate the list of tuples using map with tuple_to_tab function and list of tuples as input
list_of_tabbed_lines = map(tuple_to_tab_sep, list_of_DE_tuples)

# Write everything to output file separated by newlines
output_file.write("\n".join(list_of_tabbed_lines))

blast_file.close()
diff_expr_file.close()