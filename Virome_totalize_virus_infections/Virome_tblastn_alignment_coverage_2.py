#!/usr/bin/env python
import sys, re
argvs = sys.argv
import os
import numpy as np
import pandas as pd
pd.set_option("display.max_colwidth", 100)
pd.set_option("display.max_columns", 200)
pd.set_option("display.max_rows", 300)


# input
sra = argvs[1]
tblastx_f = argvs[2]
virus_taxonomy_f = argvs[3]
intermediate_f = argvs[4]
output_f = argvs[5]


# 2. totalize at the viral family level
# accession number >> virus taxonomy
df_virus = pd.read_csv(virus_taxonomy_f,sep="\t",index_col=0)


# 3. read intermediate file
df_coverage = pd.read_csv(intermediate_f, sep="\t", index_col=0)
df_coverage = df_coverage.rename(columns={"subject":"subject1"})
df_coverage["subject"] = [s.split(".")[0] for s in df_coverage["subject1"]]

# 4. evalue, pident
subject_l = sorted(set(df_coverage["subject"].values.tolist()) & set(df_virus["subject"]))

evalue_d = {}
pident_d = {}

for line in open(tblastx_f):
    if "#" not in line:
        info_l = line.strip().split("\t")
        contig = info_l[0]
        subject1 = info_l[1]
        subject = subject1.split(".")[0]
        if subject in subject_l:
            evalue,pident = [float(c) for c in [info_l[11],info_l[13]]]

            if contig not in evalue_d.keys():
                evalue_d[contig] = [100] * len(subject_l)
                pident_d[contig] = [0] * len(subject_l)

            i = subject_l.index(subject)

            if evalue <  evalue_d[contig][i]:
                evalue_d[contig][i] = evalue
            if pident > pident_d[contig][i]:
                pident_d[contig][i] = pident
    
df_evalue = df_evalue = pd.DataFrame(evalue_d,index=subject_l)
df_pident = pd.DataFrame(pident_d, index=subject_l)


# 5. add virus family

df_evalue = df_evalue.T
df_pident = df_pident.T

virus_family_l = {}
for subject in subject_l:
    df_s = df_virus[df_virus["subject"] == subject]
    
    if df_s.shape[0] == 0:
        print (subject)
    else:
        s = df_s.columns.tolist().index("family")
        virus_family = df_s.iloc[0,s]
    
        virus_family_l[subject] = virus_family


df_v = pd.DataFrame(virus_family_l, columns = subject_l, index=["virus_family_s"])

# add evalue and pident
df_evalue = pd.concat([df_evalue, df_v], axis=0)
df_pident = pd.concat([df_pident, df_v], axis=0)

# 5. Assign contigs into viral familes
contig_family_l = []
for c,contig in enumerate(df_evalue.index.tolist()):
    if c == df_evalue.shape[0] -1:
        virus_family = "None"
    else:
        l = df_evalue.loc[contig,:]
        e = 100
        for s,evalue in enumerate(l):
            if evalue < e:
                e = evalue
                subject = s
                family = df_evalue.iloc[-1,s]
                if family == "undefined":
                    virus_family = family # undefined を除去したい場合は、passに変える
                else:
                    virus_family = family
    
    contig_family_l.append(virus_family)

df_evalue["virus_family_c"] = contig_family_l
df_pident["virus_family_c"] = contig_family_l


# add virus taxonomy
df_coverage_virus = df_coverage.merge(df_virus, on="subject", how = "left")
df_coverage_virus = df_coverage_virus.drop_duplicates()


# 6. Extract RNA viruses
df_coverage_RNA = df_coverage_virus[~(df_coverage_virus["family"].isnull())]
df_coverage_RNA["family"].unique()

#
col_l = ["sra", "subject1", "alen", "slen", "coverage", "subject", "virus tax id", "taxonomy", "name", "seq_size", "genome", "order", "family", "genus", "genome_type", "genome_composition", "species", "virus", "segment_n", "seq_n", "genome_size", "complete_genome", "contigs", "max_pident", "min_evalue"]

# if No hit to RNA viruses
if df_coverage_RNA.shape[0] == 0:
    f = open(output_table,"w")
    f.write("\t".join(map(str,col_l)))
    f.close()
# several hits to RNA viruses
else:
    output_l = []
    df_coverage_RNA = df_coverage_RNA.sort_values(["coverage","complete_genome"],
                                                  ascending=[False,  False])
    # 
    for i,virus in enumerate(df_coverage_RNA["family"].unique()):
        df = df_coverage_RNA[df_coverage_RNA["family"] == virus]
        df1 = df.sort_values(["coverage","complete_genome"],
                        ascending=[False, False])
        
        #
        df_e = df_evalue[df_evalue["virus_family_c"] == virus]
        df_p = df_pident[df_pident["virus_family_c"] == virus]
        contig_l = df_e.index.tolist()
        
        # non-segmented virus
        if df1["segment_n"].max() == 0:
            segment = "non-segmented"
        # segmented virus
        else:
            segment = "segmented"
        
        ## 
        for m,subject in enumerate(df1["subject"]):
            if len(contig_l) > 0:
                # 
                subject_l = df_evalue.columns.tolist()
                if subject in subject_l:
                    n = subject_l.index(subject)
                    df_e_s = df_e.iloc[:,n]
                    df_p_s = df_p.iloc[:,n]

                    subject_evalue_l = df_e_s.values.tolist()
                    subject_pident_l = df_p_s.values.tolist()

                    # min evalue
                    min_evalue = min(subject_evalue_l)
                    # max pident
                    max_pident = max(subject_pident_l)

                    # 
                    subject_index_l = [i for i,s in enumerate(subject_evalue_l) if s < 100]
                    subject_contig_l = [contig for i, contig in enumerate(contig_l) if i in subject_index_l]

                    if virus == "Reoviridae":
                        print (subject, subject_evalue_l, subject_contig_l)
                    if len(subject_contig_l) == 0:
                        pass
                    else:
                        # 
                        subject_contigs = ",".join(map(str, subject_contig_l))

                        # 
                        contig_l = list(set(contig_l) - set(subject_contig_l))

                        # 
                        l = df1.iloc[m,:].values.tolist() + [subject_contigs, max_pident, min_evalue]
                        output_l.append(l)
            else:
                break

    col_l = df_coverage_RNA.columns.tolist() + ["contigs", "max_pident", "min_evalue"]
    df_output = pd.DataFrame(output_l, columns=col_l)
    
    
    df_output.to_csv(output_f, sep="\t")
    