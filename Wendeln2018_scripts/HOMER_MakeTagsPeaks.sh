#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=MakeTagsandPeaks
#SBATCH --output=HOMERTagDirPEaks.out
#SBATCH --time=20:00:00
#######################################################################################
#######################################################################################
#HOMER make tag directories and call peaks with HOMER
#http://homer.ucsd.edu/homer/ngs/tagDir.html
#one tag directory per sample

####################################################################################
#make for individual samples
####################################################################################
#module load samtools/1.4
#module load jre/1.8.0_121

# mkdir TagDirectory/
# 
# CHIP
# for sample in `cat SRR_Acc_List.txt`
# do
# 
# echo ${sample} "starting filtering"

####################################################################################
#make tag directories for each bam file

#makeTagDirectory TagDirectory/tag_${sample} aligned/${sample}_dedup.bam 


#######################################################################################

#echo ${sample} "finished filtering"


#done

module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1
#######################################################################################
#make for pool of all samples

#######################################################################################
#H3K27ac APP23 1xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_APP23_1xLPS aligned/SRR3621170_dedup.bam aligned/SRR3621171_dedup.bam

#######################################################################################
#H3K27ac APP23 4xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_APP23_4xLPS aligned/SRR3621172_dedup.bam aligned/SRR3621173_dedup.bam

#######################################################################################
#H3K27ac APP23 PBS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_APP23_PBS aligned/SRR3621168_dedup.bam aligned/SRR3621169_dedup.bam

#######################################################################################
#H3K27ac WT 1xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_WT_1xLPS aligned/SRR3621164_dedup.bam aligned/SRR3621165_dedup.bam

#######################################################################################
#H3K27ac WT 4xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_WT_4xLPS aligned/SRR3621166_dedup.bam aligned/SRR3621167_dedup.bam

#######################################################################################
#H3K27ac WT PBS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_WT_PBS aligned/SRR3621162_dedup.bam aligned/SRR3621163_dedup.bam


#######################################################################################
#H3K4me1 APP23 1xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_APP23_1xLPS aligned/SRR3621159_dedup.bam aligned/SRR3621158_dedup.bam

#######################################################################################
#H3K4me1 APP23 4xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_APP23_4xLPS aligned/SRR3621160_dedup.bam aligned/SRR3621161_dedup.bam

#######################################################################################
#H3K4me1 APP23 PBS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_APP23_PBS aligned/SRR3621156_dedup.bam aligned/SRR3621157_dedup.bam

#######################################################################################
#H3K4me1 WT 1xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_WT_1xLPS aligned/SRR3621152_dedup.bam aligned/SRR3621153_dedup.bam

#######################################################################################
#H3K4me1 WT 4xLPS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_WT_4xLPS aligned/SRR3621155_dedup.bam aligned/SRR3621154_dedup.bam

#######################################################################################
#H3K4me1 WT PBS
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1_WT_PBS aligned/SRR3621150_dedup.bam aligned/SRR3621151_dedup.bam



#######################################################################################
#input
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Input_APP23 aligned/SRR3621148_dedup.bam aligned/SRR3621149_dedup.bam


makeTagDirectory TagDirectory/Pooltag_Input_WT aligned/SRR3621146_dedup.bam aligned/SRR3621147_dedup.bam

#######################################################################################
#######################################################################################
#http://homer.ucsd.edu/homer/ngs/peaksReplicates.html
#http://homer.ucsd.edu/homer/ngs/peaks.html
#######################################################################################
#peak calling based on Gosselin et al 2017 ATACseq
#########################################


mkdir homer_peaks


#Peaks were then called on the pooled tags using
#HOMER’s “findPeaks” command with the following parameters: “-style factor -size 200 -
#minDist 200” where the “-tbp” parameter was set to the number of replicates in the pool.

#findPeaks -style factor -size 200 -minDist 200 -tbp 4


#######################################################################################
#H3K27ac APP23
#########################################

#H3K27ac APP23 1xLPS
findPeaks TagDirectory/Pooltag_H3K27ac_APP23_1xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K27ac_APP23_1xLPS.txt

#H3K27ac APP23 4xLPS
findPeaks TagDirectory/Pooltag_H3K27ac_APP23_4xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K27ac_APP23_4xLPS.txt

#H3K27ac APP23 PBS
findPeaks TagDirectory/Pooltag_H3K27ac_APP23_PBS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K27ac_APP23_PBS.txt

#######################################################################################
#H3K27ac WT
#########################################

#H3K27ac WT 1xLPS
findPeaks TagDirectory/Pooltag_H3K27ac_WT_1xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K27ac_WT_1xLPS.txt

#H3K27ac WT 4xLPS
findPeaks TagDirectory/Pooltag_H3K27ac_WT_4xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K27ac_WT_4xLPS.txt

#H3K27ac WT PBS
findPeaks TagDirectory/Pooltag_H3K27ac_WT_PBS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K27ac_WT_PBS.txt


#######################################################################################
#H3K4me1 APP23
#########################################

#H3K4me1 APP23 1xLPS
findPeaks TagDirectory/Pooltag_H3K4me1_APP23_1xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K4me1_APP23_1xLPS.txt

#H3K4me1 APP23 4xLPS
findPeaks TagDirectory/Pooltag_H3K4me1_APP23_4xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K4me1_APP23_4xLPS.txt

#H3K4me1 APP23 PBS
findPeaks TagDirectory/Pooltag_H3K4me1_APP23_PBS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_APP23 -o homer_peaks/Homerpeaks_H3K4me1_APP23_PBS.txt

#######################################################################################
#H3K4me1 WT
#########################################

#H3K4me1 WT 1xLPS
findPeaks TagDirectory/Pooltag_H3K4me1_WT_1xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K4me1_WT_1xLPS.txt

#H3K4me1 WT 4xLPS
findPeaks TagDirectory/Pooltag_H3K4me1_WT_4xLPS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K4me1_WT_4xLPS.txt

#H3K4me1 WT PBS
findPeaks TagDirectory/Pooltag_H3K4me1_WT_PBS -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_WT -o homer_peaks/Homerpeaks_H3K4me1_WT_PBS.txt

#######################################################################################
#######################################################################################
#convert to bed
#using modified pos2bedmod.pl that keeps peak information
#make a text fil (homerpeaks.txt) with the peak file base name
#######################################################################################
#######################################################################################
for sample in `cat homerpeaks.txt`
do


echo ${sample} "starting bed conversion"

#######################################################################################
#H3K27ac
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_${sample}.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_${sample}.bed
   
    rm homer_peaks/tmp*


done



