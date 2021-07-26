#!/bin/bash

input="input_examples/"
output="output_examples/"

mkdir ${output}

# 1. make sequence file of reference and novel viral sequences 
cat \
	${input}NC_001489.fasta \
	${input}goat_hepatovirus.fasta \
	> ${output}hepatovirus_annotation.fasta

# 2. alignment
mafft --auto ${output}hepatovirus_annotation.fasta \
	> ${output}hepatovirus_annotation.mafft.fasta

# 3. extract genomic annotation
python \
	Virome_polyprotein_to_mature_peptide.py \
	${output}hepatovirus_annotation.mafft.fasta \
	${input}NC_001489.gb \
	"goat_hepatovirus" \
	${output}annotation_goat_hepatovirus.txt