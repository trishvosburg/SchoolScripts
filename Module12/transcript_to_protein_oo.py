'''
Created on Nov 23, 2018

@author: trish
'''
import re

blast_file = open('/scratch/RNASeq/blastp.outfmt6')
diff_expr_file = open('/scratch/RNASeq/diffExpr.P1e-3_C2.matrix')
output_file = open("transcript_to_protein_oo.txt", "w")

# BLAST class: 
class Blast(object):
    def __init__(self, line):
        qseqid, sseqid, pident, *other_fields = line.rstrip('\n').split('\t')
        self.transcript = qseqid.split('|')[0]
        self.swissprot, self.sp_version = sseqid.split('|')[3].split('.')
        self.identity = pident

# MATRIX class:
class Matrix(object):
    def __init__(self, line):
        variables = line.rstrip("\n").split('\t')
        self.protein = variables[0]
        self.sp_ds = variables[1]
        self.sp_hs = variables[2]
        self.sp_log = variables[3]
        self.sp_plat = variables[4]
    def attributes_to_tuple(self):
        list = (self.protein, self.sp_ds, self.sp_hs, self.sp_log, self.sp_plat)
        return(tuple(list))
    
# Function that accepts a BLAST object and returns whether its identity is >95
def passes_identity_check(single_object):
    return float(single_object.identity) > 95

# Function that takes a single DE object, performs transcript-to-protein lookup
def lookup_swissprot(single_DE_object):
    # The first element should be the Swissprot ID, if not, the transcript:
    if single_DE_object.protein in blast_dictionary:
        single_DE_object.protein = blast_dictionary[single_DE_object.protein]
    return(single_DE_object)
    
# Function that accepts a tuple and returns it as tab-separated string:
def tuple_to_tab(list_of_tuples):
    return "\t".join(list_of_tuples)
 
# Parse BLAST into object:
blast_object_list = [Blast(line) for line in blast_file.readlines()]

# Loads BLAST object into a dictionary using one of the functions above as a filter
blast_dictionary = {single_object.transcript:single_object.swissprot for single_object in blast_object_list if passes_identity_check(single_object)} 
    
# Parse DE file into object:
DE_object_list = [Matrix(line) for line in diff_expr_file.readlines()]

# Create a final list of DE objects with swissprot using lookup_swissprot
final_DE_object_list = [lookup_swissprot(single_DE_object) for single_DE_object in DE_object_list]

# Create list of tuples by calling attributes_to_tuple() from Matrix class
list_of_tuples = [single_object.attributes_to_tuple() for single_object in final_DE_object_list]

# Tab-separate list of tuples
list_of_tabbed_lines = map(tuple_to_tab, list_of_tuples)

# Write everything to output file
output_file.write("\n".join(list_of_tabbed_lines))

blast_file.close()
diff_expr_file.close()
