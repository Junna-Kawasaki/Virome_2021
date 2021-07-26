## shirokane
### blastxでウイルスっぽかった配列が、ウイルスゲノムのどれぐらいをカバーしているかを算出する

#!/bin/bash
#$ -S /bin/bash
#$ -pe def_slot 1
#$ -t 1-40334:1
### 1-40334:1  ## job 1でtime=15min
#$ -tc 200
#$ -masterl s_vmem=3G,mem_req=3G ## メモリは1G以下しか使用していない
#$ -l os7
#$ -R y
#$ -o /home/junna/workspace/qsub_out
#$ -e /home/junna/workspace/qsub_out

export PATH=/home/junna/miniconda3/bin:$PATH

archive="/archive/data/hgc0863/junna/virome_horie/summary/"
refseq="/usr/local/db/blast/refseq/refseq-genomic-viral"

i=${SGE_TASK_ID}
# mammal test : i=10067
# aves test : i=101
#id=$(printf "%03d" ${i})

if [ ${i} -le 40334 ];then
### 哺乳類
mammal_sra=$(awk -v I=${i} 'NR==I{print $1}' ${archive}mammal_list.txt)

size=$(cat ${archive}blastx_mammal/${i}_viral_contig_sra.fasta | wc -l)
if [ ${size} > 0 ];then
rm -r ${archive}blastx_mammal/${i}_viral_contig_sra.fasta.split
seqkit split ${archive}blastx_mammal/${i}_viral_contig_sra.fasta  -s 10

n=0
ls ${archive}blastx_mammal/${i}_viral_contig_sra.fasta.split | while read fasta
do
n=`expr 1 + $n`
tblastx \
	-db ${refseq} \
	-query ${archive}blastx_mammal/${i}_viral_contig_sra.fasta.split/${fasta} \
	-out ${archive}tblastx/tblastx_${mammal_sra}_${n}.txt \
    -outfmt "7 qseqid sseqid length qlen slen mismatch gapopen qstart qend sstart send evalue bitscore pident qseq sseq staxids sscinames scomnames" \
    -evalue 1e-2
done
rm ${archive}tblastx/tblastx_${mammal_sra}.txt
rm ${archive}tblastx/tblastx_${mammal_sra}_coverage.txt
cat ${archive}tblastx/tblastx_${mammal_sra}_*.txt \
	> ${archive}tblastx/tblastx_${mammal_sra}.txt

rm ${archive}tblastx/tblastx_${mammal_sra}_*.txt

python script/virome_summary_tblastx.py \
	${archive}tblastx/tblastx_${mammal_sra}.txt

fi
fi

if [ ${i} -le 5028 ];then
### 鳥類
ave_sra=$(awk -v I=${i} 'NR==I{print $1}' ${archive}aves_list.txt)

size=$(cat ${archive}blastx_aves/${i}_viral_contig_sra.fasta | wc -l)
if [ ${size} > 0 ];then
rm -r ${archive}blastx_aves/${i}_viral_contig_sra.fasta.split
seqkit split ${archive}blastx_aves/${i}_viral_contig_sra.fasta  -s 10

n=0
ls ${archive}blastx_aves/${i}_viral_contig_sra.fasta.split | while read fasta
do
n=`expr 1 + $n`
tblastx \
	-db ${refseq} \
	-query ${archive}blastx_aves/${i}_viral_contig_sra.fasta.split/${fasta} \
	-out ${archive}tblastx/tblastx_${ave_sra}_${n}.txt \
    -outfmt "7 qseqid sseqid length qlen slen mismatch gapopen qstart qend sstart send evalue bitscore pident qseq sseq staxids sscinames scomnames" \
    -evalue 1e-2
done
rm ${archive}tblastx/tblastx_${ave_sra}.txt
rm ${archive}tblastx/tblastx_${ave_sra}_coverage.txt
cat ${archive}tblastx/tblastx_${ave_sra}_*.txt \
	> ${archive}tblastx/tblastx_${ave_sra}.txt

rm ${archive}tblastx/tblastx_${ave_sra}_*.txt

python script/virome_summary_tblastx.py \
	${archive}tblastx/tblastx_${ave_sra}.txt
fi
fi
