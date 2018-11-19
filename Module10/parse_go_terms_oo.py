'''
Created on Nov 7, 2018

@author: trish
'''
import re

go_file = open("/scratch/go-basic.obo")
output_file = open("GO_dictionary.txt", "w")

# Function for splitting file into records
def split_file(read_go_file):
    records = re.findall(r"^(\[Term].*?)\n\n", read_go_file, re.M | re.S)
    return records  

# Define a class that will contain the necessary attribute values of a single
# GO term record, contains regex to parse these fields
class GOterms(object):
    
    # Constructor
    def __init__(self, record):
        id_search = re.search(r"^id:\s+(GO:[0-9]+)\s+", record, re.M)
        name_search = re.search(r"^name:\s+(.*)", record, re.M)
        namespace_search = re.search(r"^namespace:\s+(.*)", record, re.M)
    
        # Check to make sure GO term was found
        if id_search:
            self.id = id_search.group(1)
            self.name = name_search.group(1)
            self.namespace = namespace_search.group(1)
            self.is_a_list = re.findall(r"^is_a:\s+(.*?\s!.*)", record, re.M)
            self.is_as = ''
            for element in self.is_a_list:
                self.is_as += "\t" + element + "\n"
        # If no GO term found, set id attribute to None
        else:
            self.id = None
            
    # Method to return id to create key for dictionary
    def get_id(self):
        return self.id
    
    # Method to output record in same format as before 
    def print_all(self):
        output_file.write(self.id + "\t" + self.namespace + "\n" + "\t" + self.name + "\n"  + self.is_as)
        
            
# Read the go_file with read()
read_go_file = go_file.read()

# Call on split_file to split go_file_read into records
records = split_file(read_go_file)

# Iterate over each individual record
for single_record in records:
    go_term_object = GOterms(single_record)
    id = go_term_object.get_id()
    go_dictionary = {}
    go_dictionary[id] = go_term_object
    # Iterate through dictionary and invoke object's printing method
    for k, val in sorted(go_dictionary.items()):
        go_term_object.print_all()

# Close file
go_file.close()