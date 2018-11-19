'''
Created on Oct 11, 2018

@author: trish

Description: learning maketrans() and translate() functions
'''
dna = 'ACTGATCGATTACGTATAGTATTTGCTATCATACATATATATCGATGCGTTCAT'
compl_table = dna.maketrans('ATGC','TACG')
complement = dna.translate(compl_table)
print(complement)
