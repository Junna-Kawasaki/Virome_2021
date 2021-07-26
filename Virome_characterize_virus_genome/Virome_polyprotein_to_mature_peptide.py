#!/usr/bin/env python
import sys, re
argvs = sys.argv
import os
import collections
import numpy as np
import pandas as pd
pd.set_option("display.max_colwidth", 200)
pd.set_option("display.max_columns", 200)
pd.set_option("display.max_rows", 300)

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord


## input
mafft_f = argvs[1] 
gb_f = argvs[2] 
query_seq = argvs[3] # name of novel viral sequence
output_f = argvs[4]

key_feature = "mat_peptide" ## annotation that you want to extract
key_qualifiers = "product"
ref_seq = gb_f.replace(".fasta", "") ## name of reference sequence

# 1. read gb file + extract annotation
gb_l = []
for record in SeqIO.parse(gb_f, 'genbank'):
    for feature in record.features:
        if feature.type == key_feature:
            l = []
            start = feature.location.start.position
            end = feature.location.end.position
            strand_int = feature.location.strand
            #print (feature)
            if key_qualifiers in feature.qualifiers.keys():
                peptide = feature.qualifiers["product"]
                l.extend(peptide)
                l.extend([start, end, strand_int])
                gb_l.append(l)
            else:
                print ("Error: no key_qualifiers in gb file")

df_gb = pd.DataFrame(gb_l, columns=["peptide", "start", "end", "strand"])


# 2. read alignment file
mafft_d = {}
for line in open(mafft_f):
    line = line.strip()
    
    if ">" in line:
        header = line.replace(">","")
        mafft_d[header] = []
    else:
        seq = [s for s in line]
        mafft_d[header].extend(seq)

df_mafft = pd.DataFrame(mafft_d)
df_mafft_t = df_mafft.T


# convert alignment positions
ref_l = df_mafft_t[df_mafft_t.index.str.contains(ref_seq)]
ref_l = ref_l.values.tolist()
ref_l = sum(ref_l,[])

columns_d = {}
i = 0
for n,r in enumerate(ref_l):
    if r != "-":
        columns_d[n] = i
        i += 1
    else:
        columns_d[n] = "-"

df_annotate = df_mafft_t.rename(columns=columns_d)


# 
query_l = df_mafft_t[df_mafft_t.index.str.contains(query_seq)]
query_l = query_l.values.tolist()
query_l = sum(query_l,[])

index_l = ["-"] * df_mafft_t.shape[1]

i = 0
for n,q in enumerate(query_l):
    if q != "-":
        index_l[n] = i
        i += 1
    else:
        pass

df_annotate.loc[query_seq,:] = index_l


#
annotation_d = {}

for i,row in df_gb.iterrows():
    peptide, start, end, strand = row[:4]
    
    location = df_annotate.iloc[-1,start:end]
    location_l = [n for n in location if n != "-"]
    
    qstart = location_l[0]
    qend = location_l[-1]
    
    annotation_d[peptide] = [start, end, strand, qstart, qend]
    
df_result = pd.DataFrame(annotation_d, 
                         index=["start", "end", "strand", "qstart", "qend"])
df_result_t = df_result.T

## output
df_result_t.to_csv(output_f, sep="\t")
