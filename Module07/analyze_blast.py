'''
Created on Oct 17, 2018

@author: trish

'''

# Open blast file and output file:
blast_file = open("/scratch/RNASeq/blastp.outfmt6")
output_file = open("blast_analysis.txt", "w")

# Takes in a single line of the blast file, parses on appropriate delimiters, and returns
# percent identity and message based on its value
def analyze_blast_pident(line):
    variables = line.replace("|", "\t").rstrip("\n").split("\t")
    transcript = variables[0]
    swissprot_with_version = variables[5]
    swissprot_split = swissprot_with_version.split('.')
    swissprot = swissprot_split[0]
    pident = float(variables[7])
    if pident == 100:
        message = (transcript + " is a perfect match for " + swissprot)
    elif 75 < pident < 100:
        message = (transcript + " is a good match for " + swissprot)
    elif 50 < pident < 75:
        message = (transcript + " is a fair match for " + swissprot)
    else:
        message = (transcript + " is a bad match for " + swissprot)
    return message, pident

# Test function:
test_line = blast_file.readline().rstrip("\n")
assert analyze_blast_pident(test_line) == ('c0_g1_i1 is a perfect match for Q9HGP0', 100.0)

# Run function on blast_file
for line in blast_file:
    (message, pident) = analyze_blast_pident(line)
    output_file.write(message + "\t" + str(pident) + "\n")
    
# Close file:
blast_file.close()