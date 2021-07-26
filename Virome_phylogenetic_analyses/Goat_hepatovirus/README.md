# Virome_phylogenetic_analyses/Goat_hepatovirus  

## Descriptions  
To construct a phylogenetic tree shown as Figure 4A in out paper, please try the program: **Virome_phylogenetic_analysis_ICTV_batch.sh**.  
- Output file is **output_examples/OPSR.Pic.Fig4A.v8_P1-147.add.out.fasta.treefile**.  

## Scripts  
1. **Virome_phylogenetic_analysis_ICTV_batch.sh**  

2. nexus_to_fasta.py  
This script can convert nex file to fasta file as follow.  
```  
python \
	${input_name}.nex \
	${output_name}.fasta
```

3. iqtree_outgroup_fasta.py  
This script can set outgroup sequence to construct phylogenetic tree by IQTREE.  
```  
python \
	${input_name}.fasta \
	${output_name}.fasta \
	${outgroup_sequence_name}
```

## Inputs  
- goat_hepatovirus.fasta  
The genome sequence of goat hepatovirus (BR001716).  

- OPSR.Pic.Fig4A.v8_P1-147.nex  
The reference alignment file provided by the ICTV on Oct 2020 (https://talk.ictvonline.org/ictv-reports/ictv_online_report/positive-sense-rna-viruses/picornavirales/w/picornaviridae/714/resources-picornaviridae).  
