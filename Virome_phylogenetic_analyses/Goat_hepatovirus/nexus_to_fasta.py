#!/usr/bin/env python
import sys, re
argvs = sys.argv

nexus_f = argvs[1]
fasta_f = argvs[2]

f = open(fasta_f, "w")

for n,line in enumerate(open(nexus_f)):
	if ";" in line:
		pass
		
	elif n > 6:
		info_l = line.strip().split()
		header = info_l[0]
		seq = info_l[-1]
		
		f.write(">" + header + "\n")
		f.write(seq + "\n")
	
	else:
		pass


f.close()