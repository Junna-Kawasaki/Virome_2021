## genebank to gtf and fasta

from Bio import SeqIO
from Bio.SeqRecord import SeqRecord
import sys
argvs = sys.argv

in_file = argvs[1]
out_file_gtf = argvs[2]
out_file_fasta = argvs[3]

out_gtf = open(out_file_gtf, "w")
out_fasta = open(out_file_fasta, "w")

name = in_file.replace(".gb","")
for record in SeqIO.parse(in_file, 'genbank'):
	# get entire sequence
	parental_seq = record.seq
	seq_r = SeqRecord(parental_seq)
	ID = name.split("/")[-1]
	seq_r.id = ID
	seq_r.description = name.split("/")[-2].split("_")[-1]
	SeqIO.write(seq_r, out_fasta, "fasta")
	out_fasta.close()
	
	for r_feature in record.features:
		source = ""
		feature = r_feature.type
		start = r_feature.location.start.position
		end = r_feature.location.end.position
		score = "."
		strand = r_feature.strand
		if strand == -1:
			s = "-"
		elif strand == 0:
			s = "."
		else:
			s = "+"
		frame = "."
		if "label" in r_feature.qualifiers:
			attribute = r_feature.qualifiers['label'][0]
		else:
			attribute = "."
		
		if feature == "source":
			pass
		else:
			l = [ID, source, feature, start, end, score, s, frame, attribute]
			out_gtf.write("\t".join(map(str, l)) + "\n")

out_gtf.close()