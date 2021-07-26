# Virome_totalize_virus_infections  

**  **
## Descriptions  
1. To calculate the alignment coverage between viral contigs in each RNA-seq data and reference viral genomes, please try the program: **Virome_totalize_virus_infection_batch.sh**.  

- This program provides an example to obtain alignment coverage between contigs in the RNA-seq data (SRR7755285) and reference viral genomes.  
- Output file is **output_examples/tblastx_coverage_count_${sra}_tophit.txt **.    

2. To construct sequence alignments batween the viral contigs identified in the RNA-seq data and reference viral genomes, please try the program: **Virome_TBLASTX.sh** as follow:  

```
refseq_database="file_path_of_refseq_viral_genomic_database"

bash Virome_TBLASTX.sh \
	${refseq_database}
```

- This program provides an example to obtain alignment result by TBLASTX.  
- Please prepare the following files before running this program:  

> 1. The NCBI RefSeq viral genomic database  

**  **
## Scripts  
1. **Virome_alignment_coverage_batch.sh**  

2. **Virome_tblastn_alignment_coverage_1.py**  
Using this program, we can calculate alignment coverage between each viral genomes and contigs.    

3. **Virome_tblastn_alignment_coverage_2.py**  
Using this program, we can determine alignment coverage at the viral family levels.

4. **Virome_TBLASTX.sh**  

**  **
## Inputs  
- tblastx_${sra}.txt  
The result file of TBLASTX using the NCBI RefSeq genomic viral database.  

- refseq-genomic-viral_taxonomy_info_20210216.txt  
The information of sequenes in the NCBI RefSeq genomic viral database.  
The sequence information were obtained from the [Virus-Host DB](https://www.genome.jp/virushostdb/).  

## Data  
- Alignment_coverage.txt  
This file lists RNA viral infections identified in this study and is disclosed at the [Mendeley Data](http://dx.doi.org/10.17632/stscmh9mr3.1).    
