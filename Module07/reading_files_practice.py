'''
Created on Oct 17, 2018

@author: trish

Description: learning different approaches to reading files
'''

# read() example:
# This method reads in and retusn the entire content of the file as-is a single string
# Not the best idea if the file is really large, could potentially overload machine
f = open('some_file.txt')
print("read():")
print(f.read())
print("\n")
f.close()

# readline() example:
# Returns single line from file
# If current line its reading is not the last line, will leave newline character at end
# If it is the last line, the newline character will be omitted only if it doesn't end with newline
# Comes in handy for testing or parsing before moving forward
# If your file has a header, can first use readline():
    # f = open("example.csv")
    # f.readline() # header line
    # for line in f:
        # print(line)
    # f.close()
f = open('some_file.txt')
print("readline():")
print(f.readline())
f.close()

# readlines() example:
# returns a list of all the lines in the file with each line as own element in list
# Similar to the file object approach described in the book, you can use a for loop to 
# iterate through the list to perform some task
f = open('some_file.txt')
print("readlines():")
print(f.readlines())
print("\n")
f.close()

# open() then for loop:
f = open('some_file.txt')
print("open() then for loop:")
for line in f:
    print(line)
f.close()