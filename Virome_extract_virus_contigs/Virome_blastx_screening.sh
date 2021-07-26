#!/bin/bash

input="input_examples/"
output="output_examples/"
nr_database=$1

mkdir ${output}

# 1. BLASTX screening in the custum database consisting of RNA viral proteins

makeblastdb \
	-in ${input}Riboviria_viral_protein.fasta \
	-out ${output}Riboviria_viral_protein.DB \
	-dbtype prot \
	-parse_seqids

blastx \
	-db  ${output}Riboviria_viral_protein.DB \
	-query ${input}SRR7755285_contigs.fa \
	-word_size 2 \
	-evalue 1E-3 \
	-max_target_seqs 1 \
	-outfmt "7 qseqid sseqid sscinames pident evalue bitscore" \
	-out ${output}SRR7755285_riboviria_blastout.txt

# 2. BLAST screening in the NCBI nr database
blastx \
	-db  ${nr_database} \
	-query ${input}SRR7755285_contigs.fa \
	-word_size 2 \
	-evalue 1E-4 \
	-max_target_seqs 10 \
	-outfmt "7 qseqid sseqid sscinames pident evalue bitscore" \
	-out ${output}SRR7755285_nr_blastout.txt