'''
Created on Oct 24, 2018

@author: trish
'''
import re

go_file = open("/scratch/go-basic.obo")
output_file = open("GO_dictionary.txt", "w")

# Function to split file into records
def split_file(read_go_file):
    records = re.findall(r"^(\[Term].*?)\n\n", read_go_file, re.M | re.S)
    return records

# Function to parse and capture fields
def create_dictionary(record):
    id = ''
    name = ''
    namespace = ''
    m1 = re.search(r"^id:\s+(GO:[0-9]+)\s+", record, re.M)
    if m1:
        id = m1.group(1)
    m2 = re.search(r"^name:\s+(.*)", record, re.M)
    if m2:
        name = m2.group(1)
    m3 = re.search(r"^namespace:\s+(.*)", record, re.M)
    if m3:
        namespace = m3.group(1)
    # Create list of is_a terms
    is_a_list = re.findall(r"^is_a:\s+(.*?\s!.*)", record, re.M)
    # Declare is_as:
    is_as = ''
    # For each individual element in is_a_list,
    for element in is_a_list:
        # Add a tab and a newline to each element
        is_as += "\t" + element + "\n"
    # Create the concatenated values 
    concatenated_values = (name + "\n" + "\t" + namespace + "\n" + is_as + "\n")
    return id, concatenated_values

# Read the go_file with read()
read_go_file = go_file.read()

# Call on split_file to split go_file_read into records
records = split_file(read_go_file)

# For one record in records variable, create the dictionary
# Iterate over the dictionary and write it to output_file
for single_record in records:
    (id, concatenated_values) = create_dictionary(single_record)
    go_dictionary = {}
    go_dictionary[id] = concatenated_values
    for k, val in sorted(go_dictionary.items()):
        output_file.write(k + "\t" + val)

# Close file
go_file.close()
