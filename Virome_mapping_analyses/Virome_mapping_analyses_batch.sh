#!/bin/bash

input="input_examples/"
output="output_examples/"
sra="SRR7755285"

mkdir ${output}

# 1. make genome index
python \
	gb_to_gft.py  \
	${input}Goat_hepatovirus.gb \
	${output}Goat_hepatovirus.gtf \
	${output}Goat_hepatovirus.fasta

# 
STAR --runMode genomeGenerate \
	--genomeDir ${output}goat_hepatovirus_index \
	--genomeFastaFiles ${output}Goat_hepatovirus.fasta \
	--sjdbGTFfeatureExon ${output}Goat_hepatovirus.gtf \
	--genomeSAindexNbases 5 # log2(3000)/2 -1 = 4.77 = 5
	
# 2. mapping analyses
# download the RNA-seq file

prefetch ${sra}
fastq-dump --split-files ${sra}/${sra}.sra \
	-O ${sra}/

# mapping analyis
mkdir ${output}mapped

STAR \
	--genomeDir ${output}goat_hepatovirus_index  \
	--readFilesIn ${sra}/${sra}_1.fastq \
	${sra}/${sra}_2.fastq \
	--sjdbGTFfeatureExon ${output}Goat_hepatovirus.gtf  \
	--outSAMtype BAM Unsorted \
	--chimSegmentMin 20 \
	--chimOutType WithinBAM Junctions \
	--outFileNamePrefix ${output}mapped/
	
samtools view -b \
	${output}mapped/Aligned.out.bam  | \
	samtools sort | \
	bedtools genomecov -ibam stdin -d -split \
	> ${output}mapped/Aligned_coverage.txt

# 3. visualization: S3 Figure
python \
	virome_read_coverage_plot.py \
	${output}mapped/Aligned_coverage.txt \
	${output}mapped/Aligned_coverage.pdf

# 4. quantifying expression level (RPM)
output_f=${output}mapped/RPM_${sra}.txt
rm ${output_f}
echo -e "sra\ttotal\taligned" > ${output_f}

## total read amount, aligned read amount
total=$( cat ${sra}/${sra}_1.fastq | grep "@" | wc -l)
aligned=$(samtools view -c ${output}mapped/Aligned.out.bam)

echo -e ${sra}"\t"${total}"\t"${aligned}>> ${output_f}
