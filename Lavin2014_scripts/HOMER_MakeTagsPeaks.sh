#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=LAvMakeTagsandPeaks
#SBATCH --output=HOMERTagDirPEaks.out
#SBATCH --time=10:00:00
#######################################################################################
#######################################################################################
#HOMER make tag directories and call peaks with HOMER
#http://homer.ucsd.edu/homer/ngs/tagDir.html
#one tag directory per sample

#######################################################################################
#make for individual samples
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121

mkdir TagDirectory/

#CHIP
for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting filtering"

#######################################################################################
#make tag directories for each bam file

makeTagDirectory TagDirectory/tag_${sample} aligned/${sample}_dedup.bam 


##########################################################################################

echo ${sample} "finished filtering"


done


#######################################################################################
#make for pool of all samples


#######################################################################################
#H3K27ac 
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac aligned/SRR1653785_dedup.bam aligned/SRR1653786_dedup.bam aligned/SRR1653787_dedup.bam aligned/SRR1653790_dedup.bam aligned/SRR1653791_dedup.bam aligned/SRR1653792_dedup.bam


#######################################################################################
#H3K4me1
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me1 aligned/SRR1653782_dedup.bam aligned/SRR1653783_dedup.bam aligned/SRR1653784_dedup.bam aligned/SRR1653788_dedup.bam aligned/SRR1653789_dedup.bam


#######################################################################################
#H3K4me2
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me2 aligned/SRR1653793_dedup.bam aligned/SRR1653794_dedup.bam


#######################################################################################
#input
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Input aligned/SRR1699284_dedup.bam 

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
#H3K27ac 
#########################################

#H3K27ac
findPeaks TagDirectory/Pooltag_H3K27ac -style histone -size 500 -minDist 1000 -region -tbp 6 -i TagDirectory/Pooltag_Input -o homer_peaks/Homerpeaks_H3K27ac.txt


#H3K4me1

findPeaks TagDirectory/Pooltag_H3K4me1 -style histone -size 500 -minDist 1000 -region -tbp 4 -i TagDirectory/Pooltag_Input -o homer_peaks/Homerpeaks_H3K4me1.txt

#H3K4me2
findPeaks TagDirectory/Pooltag_H3K4me2 -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input -o homer_peaks/Homerpeaks_H3K4me2.txt



#######################################################################################
#######################################################################################
#convert to bed
#using modified pos2bedmod.pl that keeps peak information
#######################################################################################
#######################################################################################

#######################################################################################
#H3K27ac
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_H3K27ac.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_H3K27ac.bed
   
    rm homer_peaks/tmp*



#######################################################################################
#H3K4me1
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_H3K4me1.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_H3K4me1.bed
   
    rm homer_peaks/tmp*



#######################################################################################
#H3K4me2
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_H3K4me2.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_H3K4me2.bed
   
    rm homer_peaks/tmp*

