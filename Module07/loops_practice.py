'''
Created on Oct 17, 2018

@author: trish

Description: practicing loops in Python
'''
sequence = "ATGCGTAGGTAG"
seq_len = len(sequence)
# length is 12

# Iterate through each character in the string:
#for base in sequence:
#    print(base)
    
# Iterate over a sequence of numbers, in this case,
# from 0-12 -- remember, start IN-clusive but end-EXclusive
#for i in range(seq_len):
#    print(sequence[i])
    
# Iterate over a sequence of numbers, in this case,
# starting at 4 and stopping before 10
#for i in range(4, 10):
#    print(sequence[i])

# Similar to Perl's "for (initialize, test, step)" loop
# Will iterate over a sequence of numbers starting at
# 3 and stopping before seq_len and stepping by 3
for i in range(3, seq_len, 3):
    print(sequence[i:i+3])