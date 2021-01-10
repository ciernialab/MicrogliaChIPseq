#!/bin/bash
#
#SBATCH -c 16
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Master
#SBATCH --output=Master.out
#SBATCH --time=30:00:00


#SRA pull from list
#######################################################################################
# run from in data directory
#puts data in shared data file for the experiment
#######################################################################################
mkdir -p SRA/
mkdir -p output/SRA_checksum

for sample in `cat SRR_Acc_List.txt`
do

cd SRA/

echo ${sample} "starting SRR pull"
prefetch ${sample}

#######################################################################################
#paired end sra > Fastq.gz
#######################################################################################
echo ${sample} "starting dump"

#paired end
#fastq-dump --origfmt --split-files --gzip ${sample}

#single end
fastq-dump --origfmt --gzip ${sample}

echo ${sample} "done"

cd ..

#######################################################################################
#validate each SRA file and save to output log
#https://reneshbedre.github.io/blog/fqutil.html
#######################################################################################

echo ${sample} "starting sra check"

vdb-validate SRA/${sample} 2> output/SRA_checksum/${sample}_SRAcheck.log

echo ${sample} "done"

done

#combine logs into one output file
cat output/SRA_checksum/*_SRAcheck.log > output/SRA_checksum/SRAcheck.log

#######################################################################################
##Trimmomatic for SE
#trim adapters (TruSeq3-SE.fa)

mkdir trimmed
mkdir -p output/trimlogs

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting trim"

#PE trimming for adapters and quality
java -jar $TRIMMOMATIC/trimmomatic-0.39.jar SE SRA/${sample}.fastq.gz trimmed/${sample}.trim.fastq.gz ILLUMINACLIP:$ADAPTERS/TruSeq2-SE.fa:2:30:10:8:T LEADING:3 TRAILING:3 MINLEN:15 &> output/trimlogs/trim_log_${sample}

	#trimmomatic will look for seed matches of 16 bases with 2 mismatches allowed
	#will then extend and clip if a score of 30 for PE or 10 for SE is reached (~17 base match)
	#minimum adapter length is 8 bases
	#T = keeps both reads even if only one passes criteria
	#trims low quality bases at leading and trailing end if quality score < 15
	#sliding window: scans in a 4 base window, cuts when the average quality drops below 15
	#log outputs number of input reads, trimmed, and surviving

echo ${sample} "finished trim"


done

#multiqc
multiqc output/trimlogs/ --filename output/trimlogs_multiqc_report.html --ignore-samples Undetermined* --interactive

#######################################################################################
#fastqc and then combine reports into one html and save to outputs folder
#######################################################################################
mkdir -p output/pretrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting"

fastqc SRA/${sample}.fastq.gz --outdir output/pretrim

echo ${sample} "finished"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/pretrim --filename output/PretrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive


#######################################################################################
#######################################################################################

#######################################################################################
#post trim QC
#######################################################################################
mkdir -p output/posttrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastqc"

fastqc trimmed/${sample}.trim.fastq.gz --outdir output/posttrim

echo ${sample} "finished fastqc"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/posttrim --filename output/PosttrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive


#######################################################################################
#fastq screen: http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/_build/html/index.html


#######################################################################################
mkdir -p output/fastq_screen

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastq screen"

fastq_screen --aligner bowtie2 trimmed/${sample}.trim.fastq.gz --outdir output/fastq_screen


echo ${sample} "finished fastq screen"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/fastq_screen --filename output/FastqScreen_multiqc_report.html --ignore-samples Undetermined* --interactive


###############################################################################
#bowtie2 alignment to mm10
#######################################################################################
mkdir aligned
mkdir -p output/bowtielogs


for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting alignment"

#align trimmed reads using bowtie2
# --no-unal          suppress SAM records for unaligned reads
$BT2_HOME/bowtie2 -x $BT2_MM10/genome -U trimmed/${sample}.trim.fastq.gz -S aligned/${sample}.sam -p 16 --no-unal --time 2> output/bowtielogs/${sample}_bowtie2log.log  

echo ${sample} "finished alignment"


done


#######################################################################################
#combine
#######################################################################################
multiqc output/bowtielogs --filename output/bowtie2_multiqc_report.html --ignore-samples Undetermined* --interactive

#######################################################################################
#sort with samtools and filter
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121 #this loads Java 1.8 working environment
module load R/3.6.1 #picard needs this

mkdir -p output/sam/

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting filtering"

#properly mapped and paired reads:

#pipe samtools: https://www.biostars.org/p/43677/

#flags:
# 0x1 template having multiple segments in sequencing
# 0x2 each segment properly aligned according to the aligner
# 0x4 segment unmapped
# 0x8 next segment in the template unmapped
# 0x10 SEQ being reverse complemented
# 0x20 SEQ of the next segment in the template being reversed
# 0x40 the ﬁrst segment in the template
# 0x80 the last segment in the template
# 0x100 secondary alignment
# 0x200 not passing quality controls
#0x400 PCR or optical duplicate

echo ${sample} "converting sam to bam"

#convert sam to bam and name sort for fixmate
#-@ 16 sets to 16 threads
samtools view -bS aligned/${sample}.sam | samtools sort -n -@ 16 - -o aligned/${sample}_tmp.bam

echo ${sample} "removing unmapped reads"

#Remove unmapped reads and secondary alignments from name sorted input
#samtools view -bS test.sam | samtools sort -n -@ 16 -o test_tmp.bam
samtools fixmate -r aligned/${sample}_tmp.bam aligned/${sample}_tmp2.bam


echo ${sample} "removing PCR duplicates"
#coordinate sort, then filter:
#remove PCR duplicates:https://www.biostars.org/p/318974/
# -F INT   only include reads with none of the bits set in INT set in FLAG [0]
#so include none of 0x400

#samtools sort -@ 16 test_tmp2.bam |samtools view -b -F 0x400 -@ 16 - -o test_dedup.bam 
samtools sort -@ 16 aligned/${sample}_tmp2.bam |samtools view -b -F 0x400 -@ 16 - -o aligned/${sample}_dedup.bam 

echo ${sample} "index"

#index
samtools index aligned/${sample}_dedup.bam 

echo ${sample} "QC metrics"

#fix mate information
#java -jar $PICARD FixMateInformation I=aligned/${sample}_dedup.bam O=output/sam/${sample}_fixmate.txt

#flagstat
samtools flagstat aligned/${sample}_dedup.bam > output/sam/${sample}_dedupFlagstat.txt


rm aligned/${sample}_tmp.bam
rm aligned/${sample}_tmp2.bam

echo ${sample} "finished filtering"


done

#######################################################################################
#combine
#######################################################################################
multiqc output/sam --filename output/sam_multiqc_report.html --ignore-samples Undetermined* --interactive


