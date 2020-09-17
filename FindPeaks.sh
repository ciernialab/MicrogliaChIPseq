#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=findpeaks
#SBATCH --output=findpeaks.out
#SBATCH --time=6:00:00


#######################################################################################
#find peaks
#######################################################################################
#From GEO: The tag directories for the input DNA were likewise combined. Peaks were then called on the pooled tags with the pooled input DNA as background using HOMER’s findPeaks command with the following parameters for the PU.1 ChIP-seq: “-style factor -size 200 -minDist 200” and the following parameters for the H3K27ac and H3K4me2 ChIP-seq: “-style histone -size 500 -minDist 1000 -region.” The “-tbp” parameter was set to the number of replicates in the pool = 2.

#Tag directories for the ATAC-seq experiments were combined into an ex vivo and in vitro pool for both mouse and human. Peaks were then called on the pooled tags using HOMER’s findPeaks command with the following parameters: “-style factor -size 200 -minDist 200” with the “-tbp” parameter was set to the number of replicates in the pool.
#######################################################################################
#H3K27ac
findPeaks TagDirectory/Pooltag_H3K27ac -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input -o homer_regions/Homerpeaks_H3K27ac.txt

#H3K27ac
findPeaks TagDirectory/Pooltag_H3K4me2 -style histone -size 500 -minDist 1000 -region -tbp 2 -i TagDirectory/Pooltag_Input -o homer_regions/Homerpeaks_H3K4me2.txt

#PU1
findPeaks TagDirectory/Pooltag_PU1 -style factor -size 200 -minDist 200 -tbp 2 -i TagDirectory/Pooltag_Input -o homer_regions/Homerpeaks_PU1.txt

#ATAC
findPeaks TagDirectory/Pooltag_ATAC -style factor -size 200 -minDist 200 -tbp 2 -i TagDirectory/Pooltag_Input -o homer_regions/Homerpeaks_ATAC.txt

#######################################################################################
#convert to bed
#######################################################################################

#H3K27ac
grep -v '^#' homer_regions/Homerpeaks_H3K27ac.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/Homerpeaks_H3K27ac.bed
   
    rm homer_regions/tmp*

#H3K4me2
grep -v '^#' homer_regions/Homerpeaks_H3K4me2.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/Homerpeaks_H3K4me2.bed
   
    rm homer_regions/tmp*
    
#PU1
grep -v '^#' homer_regions/Homerpeaks_PU1.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/Homerpeaks_PU1.bed
   
    rm homer_regions/tmp*
    
 #ATAC
grep -v '^#' homer_regions/Homerpeaks_ATAC.txt > homer_regions/tmp.txt
   
    perl pos2bedmod.pl homer_regions/tmp.txt > homer_regions/tmp.bed
   
    sed 's/^/chr/' homer_regions/tmp.bed > homer_regions/Homerpeaks_ATAC.bed
   
    rm homer_regions/tmp*