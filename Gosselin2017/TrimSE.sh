#!/bin/bash
#
#SBATCH -c 2
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Trim
#SBATCH --output=Trim.out
#SBATCH --time=10:00:00
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

