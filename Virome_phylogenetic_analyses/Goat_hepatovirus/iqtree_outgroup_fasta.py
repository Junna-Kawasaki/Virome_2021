#!/usr/bin/env python
import sys, re
argvs = sys.argv

fasta_f = argvs[1]
keyword = argvs[3]
output_f = argvs[2]

fasta_d = {}
for line in open(fasta_f):
	if ">" in line:
		header = line
		fasta_d[header] = ""
	else:
		seq = line
		fasta_d[header] += seq

f = open(output_f,"w")
for header in fasta_d.keys():
	if keyword in header:
		f.write(header)
		f.write(fasta_d[header])


for header in fasta_d.keys():
	if keyword in header:
		pass
	else:
		f.write(header)
		f.write(fasta_d[header])
		
f.close()