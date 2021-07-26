#!/bin/bash

input="input_examples/"
output="output_examples/"

mkdir ${output}

# 1. download astroviral ORF2 sequences from the NCBI refseq viral protein database

# 2. sequence alignment
cat \
	${input}Astroviridae_capsid_protein.fasta \
	${input}macaque_MLB_like_astrovirus.fasta \
	> ${output}macaca_astrovirus_capsid.fasta

#change header
python /Users/junna/Desktop/note/script/header_for_iqtree.py \
	${output}macaca_astrovirus_capsid.fasta \
	${output}macaca_astrovirus_capsid_rename.fasta

# 
mafft --auto \
	${output}macaca_astrovirus_capsid_rename.fasta