'''
Created on Oct 11, 2018

@author: trish

Description: Complementing DNA
'''
# Write a program that will print the complement of this sequence. 
# To find the complement we replace each base with its pair: A with T, T 
# with A, C with G and G with C.
dna = 'ACTGATCGATTACGTATAGTATTTGCTATCATACATATATATCGATGCGTTCAT'
compl_table = dna.maketrans('ATGC','TACG')
complement = dna.translate(compl_table)
print(complement)

bases="ATCGA"
print(bases[2:])

