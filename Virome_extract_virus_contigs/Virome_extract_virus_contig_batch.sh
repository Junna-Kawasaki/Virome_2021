#!/bin/bash

input="input_examples/"
output="output_examples/"
email=$1
sra="SRR7755285"

mkdir ${output}

# 1. Compare the bitscore in the BLAST screenings  
python virome_summary_blastx_name.py \
	${input}${sra}_riboviria_blastout.txt.gz \
	${input}${sra}_nr_blastout.txt.gz \
	${input}${sra}_contigs.fa \
	${email} \
	${output}${sra}_viral_contigs.fasta
	