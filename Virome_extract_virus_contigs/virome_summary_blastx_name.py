#!/usr/bin/env python
import sys, re
import os
argvs = sys.argv

import numpy as np
import math
import pandas as pd
import gzip
pd.set_option("display.max_colwidth", 200)
pd.set_option("display.max_columns", 200)
pd.set_option("display.max_rows", 300)

## input
first_blastx_f = argvs[1] # result file of blastx using the custam database consisting RNA viral proteins
second_blastx_f = argvs[2] # result file of blastx using the NCBI nr database
contig_f = argvs[3] # sequence file using blastx screening
email = argvs[4] # provide for the NCBI Entrez
output_f = argvs[5] # name of outputfile

## read blast result (zcat format)
def blast_reader(blast_d, blast_f,db):
	with gzip.open(blast_f, "r") as fi:
		for line in fi:
			line = line.decode('utf-8')
			if "#" not in line:
				line = line.strip().split("\t")
				if len(line) == 6:
					qseqid,sseqid,name,pident,evalue,bitscore = line[:6]
				elif len(line) == 10:
					qseqid,sseqid,name,pident,qstart,qend,sstart,send,evalue,bitscore = line[:10]
				if qseqid not in blast_d.keys():
					blast_d[qseqid] = []
				
				l = [qseqid,sseqid,name,pident,evalue,bitscore]
				l.append(db)
				blast_d[qseqid].append(l)
			
	return (blast_d)

blast_d = {}
blast_d = blast_reader(blast_d,first_blastx_f,"virus")
blast_d = blast_reader(blast_d,second_blastx_f,"nr")

## obtain sequence information via the NCBI Entrez
from Bio import Entrez, SeqIO
from Bio.Entrez import efetch, read
Entrez.email = email 

## bitscore comparison 
viral_contig_d = {}
viral_contig_l = []
for query in blast_d.keys():
	if query in viral_contig_d.keys():
		pass
	else:
		# the contig hits a sequence
		if len(blast_d[query]) == 1:
			l = blast_d[query][0]
			qseqid,sseqid,name,pident,evalue,bitscore,db = l[:7]
			if db == "virus" and query not in viral_contig_d.keys():
				viral_contig_d[query] = "virus"
				viral_contig_l.append(query)
			elif db != "virus" and query not in viral_contig_d.keys():
				if "virus" in name.lower():
					viral_contig_d[query] = name
					viral_contig_l.append(query)
					
		#	the contig hits several sequences
		else:
			df = pd.DataFrame(blast_d[query], columns = ["qseqid","sseqid","name","pident","evalue","bitscore","db"])
			df = df.astype({"bitscore" :float})
			df = df.sort_values("bitscore", ascending = False)
			#print (df)
			
			i = 0
			l = df.iloc[i,:]
			qseqid,sseqid,name,pident,evalue,bitscore,db = l[:7]
			if db == "virus" and query not in viral_contig_d.keys():
				viral_contig_d[query] = "virus"
				viral_contig_l.append(query)
			elif db != "virus" and query not in viral_contig_d.keys():
				if "virus" in name.lower():
					viral_contig_d[query] = name
					viral_contig_l.append(query)
				# if there is no information of the top-hit sequence
				elif name == "NA":
					acc = sseqid
					# obtain sequence information via the NCBI Entrez
					try:
						handle = Entrez.efetch(db="protein", id=acc, rettype = 'gb' , retmode = 'text')
						handle = Entrez.efetch(db="protein", id=acc, rettype = 'gb' , retmode = 'text')
						taxonomy =  record.annotations["taxonomy"]
						handle.close()
					except: 
						record = {}
						taxonomy_id = -10
						for n,i in enumerate(handle):
							if "ORGANISM" in i:
								taxonomy_id = n+1
							if n == taxonomy_id:
								record["taxonomy"] = i.strip().split("\t")
								record["taxonomy"] = [i.replace(";","") for i in record["taxonomy"] ]
						taxonomy = record["taxonomy"]
						handle.close()
					
					# check the sequence taxonomy
					if "Viruses" in taxonomy:
						viral_contig_d[query] = taxonomy
						viral_contig_l.append(query)
					else:
						viral_contig_d[query] = taxonomy


## output fasta 
f = open(output_f,"w")

for line in open(contig_f):
	if ">" in line:
		s = 0
		for contig in viral_contig_l:
			if contig in line:
				s = 1
				f.write(line)
			else:
				pass
	else:
		if s == 1:
			f.write(line)
		else:
			pass

f.close()