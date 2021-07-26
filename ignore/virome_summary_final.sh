
################################################
# 1. SRAデータの抽出
### 堀江先生がアセンブリしたデータのコピー：必須、一度実行すればいい
shirokane:
qsub -l os7 virome_summary_copy.sh

### 堀江先生がアセンブリしたSRAの情報を取得する：必須、一度すればいい
shirokane:
qsub -l os7 virome_pysradb_first.sh # **アレイジョブ

Your job-array 16318809.1-1:1 ("virome_pysradb_first_array.sh") has been submitted
Your job-array 16324746.1-46360:1 ("virome_pysradb_first_array.sh") has been submitted

## sra to srrの結果をまとめる：必須、一度すればいい
folder="/archive/data/hgc0863/junna/virome_horie/summary/metadata/"
python script/concat_file_df.py \
	"/archive/data/hgc0863/junna/virome_horie/summary/metadata/*_virome_SRP.txt" \
	${folder}virome_SRP_1.txt \
	"True" 

## srrをuniqのみ出力: 1842 SRP
cat ${folder}virome_SRP_1.txt | awk '{print $2}' | sort | uniq > ${folder}virome_SRP.txt

## 中間ファイルは一応保存
mkdir ${folder}SRP
echo ${folder}*_virome_SRP.txt | xargs mv -t ${folder}SRP

## metadataの取得
qsub -l os7 script/virome_pysradb.sh # **アレイジョブ

Your job-array 16445484.1-1842:1 ("virome_pysradb.sh") has been submitted

"""
## 実験感染の情報をマニュアルチェックするためのファイルを作成
qsub -l os7 script/virome_metadata.sh
## >> おかしい、おそらく全てのウイルス感染を取り出せていないので別の方法に変える
"""
## 実験感染の情報をマニュアルチェックするためのファイルを作成
virome_sra_abstract.py
qsub -l os7 script/test_python_20200414.sh 
Your job 17053344 ("test_python_20200414.sh") has been submitted

"""
## sraの由来となった生物種の情報をwebからとる
qsub -l os7 script/test_python_20200325.sh
virome_sra_sql.py

## 必要な情報をrecordから抜き取る
virome_summary_sra.py
>> 366 sra はtax_id = 0とかでアクセスできず: web scraping? 
"""

## beautifulsoupによるwebscraping
virome_sra_organism.py
qsub -l os7 script/test_python_20200407.sh
Your job 16845274 ("test_python_20200407.sh") has been submitted

### 例外処理
cat /archive/data/hgc0863/junna/virome_horie/summary/organism_exception.txt 
## webで検索：ncbiで公開されていないsraには"None", 公開されていたものは種名を入れた

### SRAの元となった生物種の集計ファイル
cat /archive/data/hgc0863/junna/virome_horie/summary/organism.txt | \
	taxonkit name2taxid --name-field 2 | taxonkit lineage -i 3 | taxonkit reformat  -i 4 > organism_20200409_taxonomy.txt

## > /Users/junna/virome_sra.xlsx において例外処理とwebベースで取得できた情報を合わせる

##　最終的なSRAにおける生物種のリスト
organism_20200409_taxonomy.txt
scp organism_20200409_taxonomy.txt junna@slogin.hgc.jp: 
cp organism_20200409_taxonomy.txt /archive/data/hgc0863/junna/virome_horie/summary/
/archive/data/hgc0863/junna/virome_horie/summary/organism_20200409_taxonomy.txt

### 生物種の系統樹＋サンプル数の棒グラフ
mac:
python /Users/junna/Desktop/note/script/virome_summary_organism.py 
# timetreeにおいて以下を入力ファイルとして系統樹を取得
/Users/junna/organism_20200409_taxonomy_species_tree
# timetreeで変換された名前を戻す
python /Users/junna/Desktop/note/script/ncbi2timetree.py 
# Rでvisualize
Rscript /Users/junna/Desktop/note/script/virome_summary_species.R
# 棒グラフではわかりづらいので、サンプル数の分布を表すviolin plot
mac
python /Users/junna/Desktop/note/script/virome_summary_species_violinplot.py

################################################
# 2. virome_DBの構築
### contigをblastx: 堀江先生が実行
# その時に使用したriboviria DBに含まれている配列の特徴づけ
qsub -l os7 script/virome_Riboviria_DB.sh 
Your job 17044031 ("virome_Riboviria_DB.sh") has been submitted

### tblastxに使用したウイルスゲノムの分類
virome_refseq_viral_acc.py
qsub -l os7 script/test_python_20200420.sh
Your job 17084189 ("test_python_20200420.sh") has been submitted
virome_refseq_protein_acc.py 
qsub -l os7 script/test_python_20200420.sh 
Your job 17217497 ("test_python_20200420.sh") has been submitted

### ウイルスゲノムサイズの分布
virome_refseq_viral_histogram.py

### blastxの結果からウイルスにヒットしたcontigの抽出
shirokane
virome_summary_blastx.sh # **アレイジョブ

Your job-array 16448693.1-40334:1 ("virome_summary_blastx.sh") has been submitted

## いくつかうまくいっていないSRAはやり直す
today=$(date "+%Y%m%d")
#job_number="16448693"
job_number="20360202"
qreport -l -f -j ${job_number} | python script/array_fail.py > fail_${job_number}_${today}.txt
qsub -l os7 script/virome_summary_blastx_re.sh fail_${job_number}_${today}.txt

## うまくいっていないSRAの原因は最終的にはマニュアルチェックして、以下ファイルにまとめた
virome_summary_error_manual_checked.txt

## blastxからウイルス由来だと考えられたcontigのみを抽出：データベース化
## + このスクリプトで気になる配列の検索も可能
qsub -l os7 script/virome_database.sh

 
################################################
# 3. ウイルス感染が確実なサンプルを抽出する
## tblastxでウイルスゲノムの何%をcoverしたかを算出する？
shirokane
qsub -l os7 script/virome_summary_tblastx_pre.sh ## 結局必要なかったが作ってしまった
qsub -l os7 script/virome_summary_tblastx_array.sh  # ** array job

## いくつかうまくいっていないSRAはやり直す
today=$(date "+%Y%m%d")
job_number="16448693"
qreport -l -f -j ${job_number} | python script/array_fail.py > fail_${job_number}_${today}.txt

qsub -l os7 script/virome_summary_tblastx_re.sh fail_${job_number}_${today}.txt

## criteriaを決めるために実験感染データを確認する
 python script/virome_summary_tblastx_experiment.py

## ウイルスゲノムの20%以上をカバーした場合：感染あり
virome_summary_tblastx.sh
criteria=20.0
qsub -l os7 script/virome_summary_tblastx_criteria.sh ${criteria}

## ウイルス科・ウイルス属ごとに集計
virome_summary_tblastn_virus_taxonomy.py
qsub -l os7 script/test_python_20200406.sh 
Your job 17014638 ("test_python_20200406.sh") has been submitted ### 20%

qsub -l os7 script/test_python_20200406.sh 
Your job 17023293 ("test_python_20200406.sh") has been submitted ### all contigs: 5/4終了

## 積み上げ棒グラフ、散布図の作成
mac
scp junna@slogin.hgc.jp:tblastx_coverage_20.0_contig* ~
virome_summary_tblastn_virus_taxonomy_visualize.py

####### 解析フローにおける基礎的な情報
## ウイルス由来contigの長さのヒストグラム
virome_summary_contig.py
qsub -l os7 script/test_python_20200403.sh
Your job 16952566 ("test_python_20200403.sh") has been submitted
all contigs: 422615820
viral contigs: 17060
all SRA: 46360
virus infected SRA: 4699

## refseq-genome-viral, refseq-protein-viral
## 登録配列数の偏り、ゲノムサイズの分布、系統樹作成

################################################
# 3. 新規ウイルスのみの集計
virome_summary_novel.sh


################################################
# 4. 既知ウイルスを含めた集計

### マニュアルチェックした実験感染srrプロジェクトを除く

################################################
# 4. その他
### alignment coverageの算出

