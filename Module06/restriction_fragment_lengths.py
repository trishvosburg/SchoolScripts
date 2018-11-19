'''
Created on Oct 11, 2018

@author: trish

Description: Restriction fragment lengths
'''

# The sequence contains a recognition site for the EcoRI restriction
# enzyme, which cuts at the motif G*AATTC (the position of cut is indicated
# by an asterisk). Write a program which will calculate the size of the 
# two fragments that will be produced when the DNA sequence is digested
# With EcoRI.

dna = 'ACTGATCGATTACGTATAGTAGAATTCTATCATACATATATATCGATGCGTTCAT'
# print(str(dna.find('AATTC'))) 
# GAATTC starts at position 22
fragment_1 = dna[:22]
print("Length of fragment #1:", str(len(fragment_1)))
fragment_2 = dna[22:]
print("Length of fragment #2:", str(len(fragment_2)))
