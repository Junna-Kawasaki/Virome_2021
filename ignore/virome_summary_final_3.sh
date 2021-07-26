### ウイルス感染の有無を集計する

# 1. 構築されたcontigをtblastnによってウイルスゲノムにマッピング
qsub -l os7 script/virome_summary_tblastx_array.sh

# 2. ウイルス由来contigが検出されたSRAのみ抽出
rm /archive/data/hgc0863/junna/virome_horie/summary/tblastx_file_exists_sra.txt
python script/virome_tblastx_file_exists.py


# 3: alignmetn lengthに基づく集計: blastの場合、alenはほぼほぼevalueを反映するはず
# shirokane
virome_tblastn_coverage_count_shirokane.sh ## ** array job
virome_tblastn_coverage_count_shirokane_3.py

python script/concat_file_df.py \
	"/archive/data/hgc0863/junna/virome_horie/summary/coverage/tblastx_coverage_count_*_tophit.txt" \
	"/archive/data/hgc0863/junna/virome_horie/summary/coverage/tblastx_coverage_count_tophit_alen.txt" \
	"True"

### 既知のウイルスとの配列類似性の比較
1. 見つかったウイルス配列が、既知のRdRpに対してどれくらいの配列類似性をもつか？
1-1: blastxからアミノ酸レベルでの類似性抽出
shirokane
virome_similarity_blastx_shirokane.sh

1-2: blastxに使用したウイルスタンパク質の情報を取得
Entrez_genebank_table_protein.ipynb

"""
1-3: tblasdtxでの集計結果とblastxでの集計結果を比較: いらなかった？、1-4が兼ねる？
virome_similarity_blastx_contig.ipynb
"""

1-4: tblastxとblastxの配列類似性の一致度
virome_blastx_DB_info.ipynb


###### 集計
# 4. detection rate 検討
# 4-1. non-segmented virus detection rate
virome_coverage_detection_rate_experiment_non_segment.ipynb

# 4-2 segmented virus totalization
virome_segmented_virus_before_remove_experiment.ipynb

# detection rate of segmented virus
virome_coverage_detection_rate_experiment_segment.ipynb

# defined the criteria

# 5. totalization
# exclusion experiment viral infection
virome_exclusion_experiment.ipynb

# blastx similarityをmerge
virome_similarity_blastx_contig_remove_experiment.ipynb

# segmented
virome_segmented_virus.ipynb

# non-segmented
virome_non_segmented_virus.ipynb

# all virus
virome_totalization.ipynb
virome_summary_tblastn_virus_taxonomy_visualize.ipynb

# 既知のウイルスとの配列類似性の比較
virome_blastx_DB_info.ipynb

### 5. virus-host relationship
5-1: 
virome_virus_host_relationship_20201201.ipynb
> manual check済：20201117時点

5-2: enrichment
virome_enrichment_virus_sra

## 6. search novel virus 
virome_similarity_blastx_contig.ipynb :: alignment coverage vs blastx score
virome_virus_novel_80%_coverage.ipynb :: alignment coverage > 70%

### 6. contig length vs viral genome lengths
6-1. virome_novel_virus_contig_lengths.ipynb :: alignment_cov < 20% & contig_cov > 70%
virome_novel_virus_contig_len_80.txt

shirokane
6-2. extraction of sequences
1. viral contigsの集約：virome_summary_blastx_re.sh が終了後
virome_database.sh
archive="/archive/data/hgc0863/junna/virome_horie/summary/"
echo ${archive}blastx_mammal/*_viral_contig_sra.fasta | xargs cat > ${archive}blastx_mammal/virome_mammal.fasta
echo ${archive}blastx_aves/*_viral_contig_sra.fasta | xargs cat > ${archive}blastx_aves/virome_aves.fasta

mac
2. 目的配列の抽出
virome_extract_contigs.ipynb


#### 7. SRAの数から期待されるウイルス同定数との比較 >> なんか時間かかる：要修正
virome_fisher_multiple.ipunb


#### 8. 哺乳類と鳥類という2群でウイルスが同定されたSRAの数を比較
## 脊椎動物に感染するウイルス
python /Users/junna/Desktop/note/script/Fisher_exact_test.py \
	/Users/junna/Desktop/note/jupyter/Virome_2020/virome_fisher_mammal_bird_vertebrate_virus.txt

## 全てのウイルス
python /Users/junna/Desktop/note/script/Fisher_exact_test.py \
	/Users/junna/Desktop/note/jupyter/Virome_2020/virome_fisher_mammal_bird_all_virus.txt
