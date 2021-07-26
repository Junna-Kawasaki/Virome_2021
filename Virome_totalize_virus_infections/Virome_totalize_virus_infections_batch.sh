#!/bin/bash

input="input_examples/"
output="output_examples/"

mkdir ${output}

python \
	Virome_tblastn_alignment_coverage_1.py \
	"SRR7755285" \
	${input}tblastx_SRR7755285.txt \
	${output}tblastx_coverage_count_SRR7755285_table.txt 

python \
	Virome_tblastn_alignment_coverage_2.py \
	"SRR7755285" \
	${input}tblastx_SRR7755285.txt \
	${input}refseq-genomic-viral_taxonomy_info_20210216.txt  \
	${output}tblastx_coverage_count_SRR7755285_table.txt \
	${output}tblastx_coverage_count_SRR7755285_tophit.txt 
