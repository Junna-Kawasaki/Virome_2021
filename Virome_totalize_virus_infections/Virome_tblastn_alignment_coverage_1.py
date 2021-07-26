#!/usr/bin/env python
import sys, re
argvs = sys.argv
import os
import collections
import numpy as np
import pandas as pd
pd.set_option("display.max_colwidth", 100)
pd.set_option("display.max_columns", 20)
pd.set_option("display.max_rows", 300)


# input
sra = argvs[1]
tblastx_f = argvs[2]
intermediate_f = argvs[3]


# 1. calculating the alignment coverage
# read tblastx_file
coverage_d = {}
evalue_d = {}
pident_d = {}
all_contig_l = []

for line in open(tblastx_f):
    if "#" in line:
        pass
    else:
        contig,subject,alen,qlen,slen,mismatch,gap,qstart,qend,sstart,send,evalue,bitscore,pident = line.strip().split("\t")[:14]
        alen,qlen,slen,qstart,qend,sstart,send = [int(c) for c in [alen,qlen,slen,qstart,qend,sstart,send]]
        
        if subject not in coverage_d.keys():
            coverage_d[subject] = {}
            coverage_d[subject]["total_coverage"] = [0] * slen
            evalue_d[subject] = {}
            pident_d[subject] = {}
        
        if contig not in coverage_d[subject].keys():
            coverage_d[subject][contig] = [0] * slen
            evalue_d[subject][contig] = 100
            pident_d[subject][contig] = 0
        
        if contig not in all_contig_l:
            all_contig_l.append(contig)
            
        ## coverage to a contig
        if sstart < send:
            start = sstart
            end = send
        else:
            start = send
            end = sstart
        alen_l = list(range(start,end+1))

        l = []
        for n,i in enumerate(coverage_d[subject][contig]):
            if n in alen_l:
                a = 1
            elif i > 0:
                a = i
            else:
                a = 0
            l.append(a)

        coverage_d[subject][contig] = l
        
        ## 
        l = []
        for n,i in enumerate(coverage_d[subject]["total_coverage"]):
            if n in alen_l:
                a = 1
            elif i > 0:
                a = i
            else:
                a = 0
            l.append(a)
        
        coverage_d[subject]["total_coverage"] = l

        ## E-value
        if float(evalue) < evalue_d[subject][contig]:
            evalue_d[subject][contig] = float(evalue)
        
        ## Pident
        if float(pident) > pident_d[subject][contig]:
            pident_d[subject][contig] = float(pident)


# make intermediate file
all_contig_l = all_contig_l + ["total_coverage"]

table_d = {}
out_lengths_l = []

for subject in coverage_d.keys():
    table_d[subject] = [0] * len(all_contig_l)
    for c,contig in enumerate(all_contig_l):
        if contig in coverage_d[subject].keys():
            alen_l = [i for i in coverage_d[subject][contig]
                      if i > 0]
            coverage = len(alen_l) / len(coverage_d[subject][contig]) * 100
            table_d[subject][c] = coverage
            
            out_lengths_l.append([sra, subject, len(alen_l), len(coverage_d[subject][contig]), coverage])


# output: intermediate file
df_lengths = pd.DataFrame(out_lengths_l, columns=["sra", "subject", "alen","slen","coverage"])
df_lengths = df_lengths.drop_duplicates()
df_lengths = df_lengths.sort_values("alen", ascending=False)
df_lengths.to_csv(intermediate_f, sep="\t")