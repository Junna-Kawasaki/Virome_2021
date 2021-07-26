# Identification of contigs originated from viruses  

**  **
## Descriptions  
1. To detemine the contig origins by comparing the bitscores in BLASTX screenings, please try the program: **Virome_extract_virus_contig_batch.sh** as follows.  
```
bash Virome_extract_virus_contig_batch.sh \
	${your_email}
```

- This program provides an example to obtain RNA viral sequences from the assembled file.  
- Please put your emali adress in ${your_email} to use the NCBI Entrez database.  
- Output file is **output_examples/${sra}_viral_contigs.fasta**.  

2. To obtain BLASTX results, please try the program: **Virome_blast_screening.sh**  as follows.

```
nr_database="file_path_of_nr_database"

bash Virome_blastx_screening.sh \
	${nr_database}
```

- This program performs BLASTX screenings in the custum database consisting of RNA viral proteins and the NCBI nr database.  
- Please prepare the following files before running this program:  

> 1. Riboviria_viral_protein.fasta  
> This file contains RNA viral proteins. Please download this file in input_examples directory from the Mendeley data.    
> 
> 2. The NCBI NR database  

**  **
## Scripts  
1. **Virome_extract_virus_contig_batch.sh**  
This program provides an example to determine the contig orign: whether virus or the others.  

2. **Virome_summary_blastx_name.py**  
This program determines the contig origins by comparing the bitscores in the first and second BLASTX screening.  

3. **Virome_blast_screening.sh**  
This program performs BLASTX screenings in the custum database consisting of RNA viral proteins and the NCBI nr database.  

**  **
## Inputs  
1. ${sra}_riboviria_blastout.txt.gz  
The result file of BLASTX screening in a database consisting of RNA viral proteins.  
The RNA viral protein sequences were disclosed in Mendeley Data.  

2. ${sra}_nr_blastout.txt.gz   
The result file of BLASTX screening in the NCBI nr database.  

3. ${sra}_contigs.fa  
The assembled sequence file used for the BLASTX screening.  

**  **
## Data  
These data are available at the [Mendeley Data](http://dx.doi.org/10.17632/stscmh9mr3.1).  

- Riboviria_viral_protein.fasta  
This file contains the RNA viral proteins used for constructing the custum database.  
- RNA_viral_contigs.fasta  
This file contains the contigs encoding RNA viral proteins.  