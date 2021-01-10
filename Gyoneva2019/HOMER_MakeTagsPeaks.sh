#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=MakeTagsandPEAks2
#SBATCH --output=HOMERTagDirPEaks2.out
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
#H3K27ac Cx3cr1KO
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_Cx3cr1KO aligned/SRR9034494_dedup.bam aligned/SRR9034495_dedup.bam

#######################################################################################
#H3K27ac Cx3cr1WT
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac_Cx3cr1WT aligned/SRR9034500_dedup.bam aligned/SRR9034501_dedup.bam


#######################################################################################
#Rpb2 CHIP
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Rpb2_Cx3cr1KO aligned/SRR9034498_dedup.bam aligned/SRR9034499_dedup.bam

#######################################################################################
#Rpb2 CHIP
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Rpb2_Cx3cr1WT aligned/SRR9034504_dedup.bam aligned/SRR9034505_dedup.bam

#######################################################################################
#input
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Input_Cx3cr1KO aligned/SRR9034502_dedup.bam aligned/SRR9034503_dedup.bam

makeTagDirectory TagDirectory/Pooltag_Input_Cx3cr1WT aligned/SRR9034502_dedup.bam aligned/SRR9034503_dedup.bam

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
findPeaks TagDirectory/Pooltag_H3K27ac_Cx3cr1KO -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_Cx3cr1KO -o homer_peaks/Homerpeaks_H3K27ac_Cx3cr1KO.txt

findPeaks TagDirectory/Pooltag_H3K27ac_Cx3cr1WT -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input_Cx3cr1WT -o homer_peaks/Homerpeaks_H3K27ac_Cx3cr1WT.txt


#Rbp2
findPeaks TagDirectory/Pooltag_Rpb2_Cx3cr1KO -style factor -size 200 -minDist 200 -tbp 2 -i TagDirectory/Pooltag_Input_Cx3cr1KO -o homer_peaks/Homerpeaks_Rbp2_Cx3cr1KO.txt

findPeaks TagDirectory/Pooltag_Rpb2_Cx3cr1WT -style factor -size 200 -minDist 200 -tbp 2 -i TagDirectory/Pooltag_Input_Cx3cr1WT -o homer_peaks/Homerpeaks_Rbp2_Cx3cr1WT.txt




#######################################################################################
#######################################################################################
#convert to bed
#using modified pos2bedmod.pl that keeps peak information
#######################################################################################
#######################################################################################

#######################################################################################
#H3K27ac
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_H3K27ac_Cx3cr1KO.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_H3K27ac_Cx3cr1KO.bed
   
    rm homer_peaks/tmp*


grep -v '^#' homer_peaks/Homerpeaks_H3K27ac_Cx3cr1WT.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_H3K27ac_Cx3cr1WT.bed
   
    rm homer_peaks/tmp*

#######################################################################################
#Rbp2
#######################################################################################

grep -v '^#' homer_peaks/Homerpeaks_Rbp2_Cx3cr1KO.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_Rbp2_Cx3cr1KO.bed
   
    rm homer_peaks/tmp*


grep -v '^#' homer_peaks/Homerpeaks_Rbp2_Cx3cr1WT.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_Rbp2_Cx3cr1WT.bed
   
    rm homer_peaks/tmp*



