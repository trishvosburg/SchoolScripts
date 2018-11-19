'''
Created on Oct 11, 2018

@author: trish

Description: Splicing introns, part I, II, and III
'''
###############################################
# Splicing introns I:
# This DNA segment comprises two exons and an intron. The first exon runs from the start of 
# the sequence to base number 63 (starting counting from zero), and the second 
# exon runs from base 91 (also counting from zero) to the end of the sequence. 
# Write a program that will print just the coding regions of the DNA sequence.

dna = 'ATCGATCGATCGATCGACTGACTAGTCATAGCTATGCATGTAGCTACTCGATCGATCGATCGATCGATCGATCGATCGATCGATCATGCTATCATCGATCGATATCGATGCATCGACTACTAT'
exon_1 = dna[:62] 
print("Exon 1:", exon_1)
exon_2 = dna[90:]
print("Exon 2:", exon_2)

###############################################
# Splicing introns II:
# Using the data from part one, write a program that will calculate what 
# percentage of the DNA sequence is coding.

length_exon_1 = len(exon_1)
length_exon_2 = len(exon_2)
total_exon_length = length_exon_1 + length_exon_2
print("Percent coding DNA:", str(100*total_exon_length / len(dna)))

###############################################
# Splicing introns III:
# Using the data from part one, write a program that will print out the original genomic DNA 
# sequence with coding bases in uppercase and non-coding bases in lowercase.

intron = dna[62:90]
print(exon_1 + intron.lower() + exon_2)