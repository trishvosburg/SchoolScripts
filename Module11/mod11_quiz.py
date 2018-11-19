'''
Created on Nov 17, 2018

@author: trish
'''

matrix_file = open('/scratch/SampleDataFiles/matrix.txt')

class Matrix(object):
    
    def __init__(self, line_of_input):
        self.single_matrix = line_of_input
    
def create_single_record(single_record):
    single_record_object = Matrix(single_record)
    return single_record_object

list_of_matrix_objects = map(create_single_record, matrix_file.readlines())   