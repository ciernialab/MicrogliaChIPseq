#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=1000
#SBATCH --job-name=TrimFastqc
#SBATCH --output=TrimFastqc.out
#SBATCH --time=2:00:00

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
