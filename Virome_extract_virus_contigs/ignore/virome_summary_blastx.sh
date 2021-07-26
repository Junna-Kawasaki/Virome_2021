## shirokane
### 1st blastx(riboviria) vs 2nd blastx (nr) 

#!/bin/bash
#$ -S /bin/bash
#$ -pe def_slot 1
#$ -l s_vmem=5G,mem_req=5G
#$ -t 1-40334:1
### 1-40334
#$ -tc 10 ## 10より多くしない、web接続でブロックされる
#$ -l os7
#$ -l ljob
#$ -R y
#$ -o /home/junna/workspace/qsub_out
#$ -e /home/junna/workspace/qsub_out

export PATH=/usr/bin/:$PATH
export PATH=/home/junna/miniconda3/bin:$PATH
archive="/archive/data/hgc0863/junna/virome_horie/summary/"

i=${SGE_TASK_ID}
#i=15

if [ ${i} -le 40334 ];then
### 哺乳類
mkdir ${archive}blastx_mammal
mammal_sra=$(awk -v I=${i} 'NR==I{print $1}' ${archive}mammal_list.txt)
echo ${mammal_sra}
echo ${SGE_TASK_ID}


## 1. blastxの結果比較
#which python
python script/virome_summary_blastx_name.py \
	${archive}mammals_blastx_first/${i}_blastout.txt.gz \
	${archive}mammals_blastx_second/${i}_blastout.txt.gz \
	${archive}mammal_list.txt

ls -l ${archive}mammals_blastx_first/${i}_viral_contig.txt 
size=$(cat ${archive}mammals_blastx_first/${i}_viral_contig.txt | wc -l )
if [ ${size} > 0 ];then
## 2. ウイルスにヒットした配列の抽出
#which mv
/usr/bin/mv ${archive}mammals_blastx_first/${i}_viral_contig.txt ${archive}blastx_mammal

cat /archive/data/hgc0863/junna/virome_horie/mammals/${mammal_sra}_contigs.clstr95.fa | \
seqkit grep -f ${archive}blastx_mammal/${i}_viral_contig.txt \
> ${archive}blastx_mammal/${i}_viral_contig.fasta

## データベースの作成のためにヘッダーにSRA名前をつける
python script/seqkit_rename.py \
	${archive}blastx_mammal/${i}_viral_contig.fasta \
	${mammal_sra}

## データベースに含まれる配列のblastxの結果をまとめたファイルを作る
python script/virome_database_blastx.py \
	${archive}blastx_mammal/${i}_viral_contig.txt \
	${archive}mammals_blastx_first/${i}_blastout.txt.gz \
	${archive}mammals_blastx_second/${i}_blastout.txt.gz \
	${mammal_sra}

else
/usr/bin/rm ${archive}mammals_blastx_first/${i}_viral_contig.txt
	
fi
fi

if [ ${i} -le 5028 ];then
### 鳥類
mkdir ${archive}blastx_aves
ave_sra=$(awk -v I=${i} 'NR==I{print $1}' ${archive}aves_list.txt)

## 1. blastxの結果比較
python script/virome_summary_blastx_name.py \
	${archive}aves_blastx_first/${i}_blastout.txt.gz \
	${archive}aves_blastx_second/${i}_blastout.txt.gz \
	${archive}aves_list.txt

ls -l ${archive}aves_blastx_first/${i}_viral_contig.txt 
## 2. ウイルスにヒットした配列の抽出
size=$(cat ${archive}aves_blastx_first/${i}_viral_contig.txt | wc -l )
if [ ${size} > 0 ];then
#which mv
/usr/bin/mv ${archive}aves_blastx_first/${i}_viral_contig.txt ${archive}blastx_aves

cat /archive/data/hgc0863/junna/virome_horie/aves/${ave_sra}_scaffolds.fasta | \
seqkit grep -f ${archive}blastx_aves/${i}_viral_contig.txt \
> ${archive}blastx_aves/${i}_viral_contig.fasta

## データベースの作成のためにヘッダーにSRA名前をつける
python script/seqkit_rename.py \
	${archive}blastx_aves/${i}_viral_contig.fasta \
	${ave_sra}

## データベースに含まれる配列のblastxの結果をまとめたファイルを作る
python script/virome_database_blastx.py \
	${archive}blastx_aves/${i}_viral_contig.txt \
	${archive}aves_blastx_first/${i}_blastout.txt.gz \
	${archive}aves_blastx_second/${i}_blastout.txt.gz \
	${ave_sra}

else
/usr/bin/rm ${archive}aves_blastx_first/${i}_viral_contig.txt
	
fi

fi