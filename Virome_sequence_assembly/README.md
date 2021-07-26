# Virome_sequence_assembly  

**  **
## Descriptions  
To perform *de novo* sequence assembly using RNA-seq data, please try the program: **Virome_sequence_assembly_batch.sh** according to the following command.   

```
sra="SRR7755285" # SRA Run No in which goat hepatoviral genome was initially identified.  
genome_fasta="GCF_001704415.1_ARS1_genomic.fna"

bash Virome_sequence_assembly_batch.sh \
	${sra}  \
	${genome_fasta}  
```
  
- Please put files as follow:  
> ${sra}: SRA Run ID  
> 
> ${genome_fasta}: fasta file of host genomic sequence  
- Please download the fasta file of host genomic sequence in **input_examples** before running this program.  
- Output file is **output_examples/${sra}_scaffolds.fasta**.  

**  **
## Scripts  
1. **Virome_sequence_assemblyu_batch.sh**  
This program provides an example to obtain assembled sequences using the RNA-seq data.  