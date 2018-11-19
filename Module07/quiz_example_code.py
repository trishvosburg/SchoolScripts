'''
Created on Oct 20, 2018

@author: trish
'''
def search_peptide_motif(motif):
    site_pos = None
    sequence = "AAPSNGRLLGSISPEPSTPAP"
    if motif in sequence:
        site_pos = sequence.find(motif) + 1  # adding 1 to account for 0-index
    return site_pos

my_site_pos = search_peptide_motif("RLLGSISPEPSTP")
print(my_site_pos)
assert search_peptide_motif("RLLGSISPEPSTP") == 7
