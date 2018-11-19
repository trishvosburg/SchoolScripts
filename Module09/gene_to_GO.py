'''
Created on Oct 31, 2018

@author: trish
'''
import re

go_file = open("/scratch/go-basic.obo")
gene_file = open("/scratch/gene_association_subset.txt")
output_file = open("genes_plus_GO_terms.txt", "w")

# Function to split file into records
def split_file(read_go_file):
    records = re.findall(r"^(\[Term].*?)\n\n", read_go_file, re.M | re.S)
    return records

# Function to parse and capture ID and is_a terms
def parse_file(record):
    id = ''
    m1 = re.search(r"^id:\s+(GO:[0-9]+)\s+", record, re.M)
    if m1:
        id = m1.group(1)
    parent_terms = re.findall(r"^is_a:\s+(.*?) !", record, re.M)
    return (id, parent_terms)

# Function to recursively look for all parent terms of a given GO term
# using sets in order to check for duplicates
def get_parents(gene_go_term):
    # Create empty set to hold results: DOESN'T WORK, won't return any results
    #result = set()
    # DOES WORK:
    result  = {gene_go_term}
    # Look up parents of that term:
    parents = go_dictionary.get(gene_go_term, [])
    # For each parent, add its parents to result using recursive function call:
    for parent in parents:
        # Only works when result isn't already empty
        # .add does not work
        result.update(get_parents(parent))
    # Return set:
    return(result)
    
# Read the go_file with read()
read_go_file = go_file.read()

# Call on split_file to split go_file_read into records
records = split_file(read_go_file)

go_dictionary = {}
# For each record in records variable, call on parse_file
# to retrieve id and parent terms and create dictionary
for single_record in records:
    (id, parent_terms) = parse_file(single_record)
    go_dictionary[id] = parent_terms

gene_dictionary = {}
# For each of the GO: terms in the gene_file,
for line in gene_file:
    variables = line.split('\t')
    gene_go_term = variables[4]
    # Use the gene and the gene_go_term to create a dictionary
    # If the gene is already in the dictionary, add the GO
    # term to the existing value for the key-value pair
    if variables[1] in gene_dictionary:
        gene_dictionary[variables[1]].add(gene_go_term)
    # Otherwise, create the gene and the GO term as a new 
    # key-value pair. 
    else:
        gene_dictionary[variables[1]] = {gene_go_term}

# For the keys and values in the gene dictionary,
for k, val in sorted(gene_dictionary.items()):
    # Write the keys to the output file
    output_file.write(k)
    # For each go term in the values,
    # Call upon get_parents to retrieve all the parent terms
    for gene_go_term in val:
        result = get_parents(gene_go_term)
        final_result = ''
        for element in result:
            final_result += "\t" + "\t" + element + "\n"
        # Create summary report
        output_file.write("\t" + gene_go_term + "\n"  + final_result)

# Close file
go_file.close()
gene_file.close()
