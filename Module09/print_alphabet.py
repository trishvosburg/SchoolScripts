'''
Created on Nov 5, 2018

@author: trish
'''
def print_alphabet(letters):
    # Base case: only one letter left
    if len(letters) == 1:
        print(letters)
    # Recursive case: still more letters left to print
    else:
        letter = letters[:1]
        print(letter)
        print_alphabet(letters[1:])

# Initial function call
print_alphabet("abcdefghijklmnopqrstuvwxyz")

genes=('AB', 'BD', 'CD')
genes[1] = 'TER'