
0. 
- virome_refseq_info_20210215.ipynb

1. tblastx >> alignment coverage
- virome_tblastn_coverage_count_shirokane_20210203.sh  
- virome_tblastn_coverage_count_shirokane_20210318.py

```	
python script/concat_file_df.py \
	"/archive/data/hgc1211/virome_horie/summary/coverage/tblastx_coverage_count_*_20210318.txt" \
	"/archive/data/hgc1211/virome_horie/summary/coverage/tblastx_coverage_count_tophit_alen_20210318.txt" \
	"True"
```

2. ウイルス感染の集計：ウイルス種ごとのアライメントカバレッジの算出
- virome_segmented_virus_20210318.ipynb
- virome_non_segmented_virus_20210309.ipynb

3. 脊椎動物ウイルスのみに対象を絞る
- virome_vertebrate_viruses_20210402.ipynb

4. 実験感染の除去
- virome_exclusion_experiment_20210322.ipynb
non-segmented, non-experiment: 2352
non-semented, experiment: 547
segmented, non-experiment: 719
segmented, experiment: 81

4. 実験感染ウイルスの検出感度
Figure S1
segmentedもnon-segmentedも集計方法統一したので別図にする必要なし？
1つの図にした方が説得力ある  
- virome_coverage_detection_rate_experiment_20210322.ipynb
AUCを入れる
- virome_alignment_coverage_AUC_20210322.ipynb

Criteriaをどうするか >> とりあえず 20% alignment coverage

<<COMMENTOUT
previous data
- virome_coverage_detection_rate_experiment_segment_20210312.ipynb
- virome_coverage_detection_rate_experiment_non_segment_20210312.ipynb
COMMENTOUT

4. 最終的な集計＋visualization
Figure 2A, C, D
- virome_totalization_20210309.ipynb

5. fisher's exact test
Figure 2B
- virome_fisher.sh
bash /Users/junna/Desktop/note/script/virome_fisher.sh

6. virus-host relationship
Figure 3A, B, C
- virome_virus_host_relationship_20210323.ipynb
- virome_similarity_blastx_contig_20210323.ipynb

7. characterization of novel viruses

