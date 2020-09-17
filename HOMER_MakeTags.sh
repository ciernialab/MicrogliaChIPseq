#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=MakeTags
#SBATCH --output=HOMERTagDir.out
#SBATCH --time=10:00:00
#######################################################################################
#######################################################################################
#HOMER make tag directories
#http://homer.ucsd.edu/homer/ngs/tagDir.html
#one tag directory per sample

#######################################################################################
#make for individual samples
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121

mkdir TagDirectory/

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
#make for pools

########################################################################################
mkdir homer_regions/
#######################################################################################

#SRR5617659	Mouse_ATAC_ExVivo_Rep1
# SRR5617660	Mouse_ATAC_ExVivo_Rep2
# SRR5617663	Mouse_H3K27ac_ExVivo_Rep1
# SRR5617664	Mouse_H3K27ac_ExVivo_Rep2
# SRR5617667	Mouse_H3K4me2_ExVivo_Rep1
# SRR5617668	Mouse_H3K4me2_ExVivo_Rep2
# SRR5617669	Mouse_Input_ExVivo_Rep1
# SRR5617670	Mouse_Input_ExVivo_Rep2
# SRR5617671	Mouse_Input_ExVivo_Rep3
# SRR5617672	Mouse_Input_ExVivo_Rep4
# SRR5617673	Mouse_Input_ExVivo_Rep5
# SRR5617674	Mouse_Input_ExVivo_Rep6
# SRR5617677	Mouse_Pu1_ExVivo_Rep1
# SRR5617678	Mouse_Pu1_ExVivo_Rep2



#######################################################################################
#ATAC
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_ATAC aligned/SRR5617660_dedup.bam aligned/SRR5617663_dedup.bam

#######################################################################################
#H3K27ac
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27ac aligned/SRR5617663_dedup.bam aligned/SRR5617664_dedup.bam

#######################################################################################
#H3K4me2
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K4me2 aligned/SRR5617667_dedup.bam aligned/SRR5617668_dedup.bam

#######################################################################################
#input
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Input aligned/SRR5617669_dedup.bam aligned/SRR5617670_dedup.bam aligned/SRR5617671_dedup.bam aligned/SRR5617672_dedup.bam aligned/SRR5617673_dedup.bam aligned/SRR5617674_dedup.bam

#######################################################################################
#PU1
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_PU1 aligned/SRR5617677_dedup.bam aligned/SRR5617678_dedup.bam

