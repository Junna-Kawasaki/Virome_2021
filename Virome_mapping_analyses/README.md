# Virome_mapping_analyses  

**  **
## Descriptions  
To perform mapping analysis using a viral genome, please try the program: **Virome_mapping_analyses_batch.sh**.  

- This program provides an example to mapping analyses using the goat hepatovirus and the RNA-seq data in which this virus genome was initially identified (SRR7755285).  
- Output files are **output_examples/mapped/Aligned_coverage.pdf** (S3A Fig) and **output_examples/mapped/RPM_SRR7755285.txt** (Fig 5A).  

**  **
## Scripts  
1. **Virome_mapping_analyses_batch.sh**  

2. **gb_to_gft.py**  
This script can make gtf and fasta file from gb file.  

```  
python \
	gb_to_gtf.py  \
	${gb_file_name}.gb \
	${output_name}.gtf \
	${output_name}.fasta
```

3. **virome_read_coverage_plot.py**  
This script can make a coverage plot to viral genome.  


**  **
## Inputs  
- Goat_hepatovirus.gb    
This viral genome sequence was disclosed as BR001716.  

