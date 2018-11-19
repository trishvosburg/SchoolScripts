'''
Created on Oct 11, 2018

@author: trish

Description: Calculating AT content
'''

# Write a program that will print out the AT content of this DNA sequence.

dna = 'ACTGATCGATTACGTATAGTATTTGCTATCATACATATATATCGATGCGTTCAT'
A_count = dna.count('A')
T_count = dna.count('T')
final_count = A_count + T_count
total_length = len(dna)
AT_content = final_count/total_length
print("AT content:", str(AT_content))