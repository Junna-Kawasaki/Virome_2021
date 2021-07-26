#!/bin/bash

input="input_examples/"
output="output_examples/"
refseq_database=$1

mkdir ${output}

# 1. TBLAST using the NXBI RefSeq viral genomic database
tblastx \
	-db ${refseq_database} \
	-query ${input}SRR7755285_scaffolds.fasta \
	-evalue 1e-2 \
	-outfmt "7 qseqid sseqid length qlen slen mismatch gapopen qstart qend sstart send evalue bitscore pident qseq sseq staxids sscinames scomnames" \
	-out ${output}tblastx_SRR7755285.txt