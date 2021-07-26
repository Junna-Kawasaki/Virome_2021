#!/bin/bash

input="input_examples/"
output="output_examples/"

mkdir ${output}

<<COMMENTOUT
#1. download from the ICTV resources
# Note: we are currently unavailable to use OPSR.Pic.Fig4A.v8_P1-147.nex  
wget \
	https://talk.ictvonline.org/cfs-file/__key/communityserver-wikis-components-files/00-00-00-00-85/OPSR.Pic.Fig4A.v8_P1-147.nex \
	--no-check-certificate \
	-P ${input}
COMMENTOUT

# 2. nex to fasta
python \
	nexus_to_fasta.py \
	${input}OPSR.Pic.Fig4A.v8_P1-147.nex \
	${output}OPSR.Pic.Fig4A.v8_P1-147.fasta

# 3. add novel virus into the reference alignment
mafft --keeplength \
	--add ${input}goat_hepatovirus.fasta \
	${output}OPSR.Pic.Fig4A.v8_P1-147.fasta \
	> ${output}OPSR.Pic.Fig4A.v8_P1-147.add.fasta

# 4. set outgroup
python \
	iqtree_outgroup_fasta.py \
	${output}OPSR.Pic.Fig4A.v8_P1-147.add.fasta \
	${output}OPSR.Pic.Fig4A.v8_P1-147.add.out.fasta \
	"KP770140" # the ICTV rooted the reference tree by the ampivirus as outgroup

# 5. make phylogenetic tree
rm ${output}OPSR.Pic.Fig4A.v8_P1-147.add.out.fasta.*

iqtree \
	-s ${output}OPSR.Pic.Fig4A.v8_P1-147.add.out.fasta \
	-m TESTNEW \
	-bb 1000 \
	-redo \
	-nt AUTO