#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=DiffPeaks
#SBATCH --output=DiffPeaks.out
#SBATCH --time=4:00:00

#######################################################################################
#merges peaks, annotates and calls DE peaks
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir DEpeaks/
#######################################################################################
#Combine WT and KO peaks into one file for annotation using mergPeaks.
#For H3K27ac peaks:

mergePeaks homer_peaks/Homerpeaks_H3K27ac_Cx3cr1KO.txt homer_peaks/Homerpeaks_H3K27ac_Cx3cr1WT.txt > homer_peaks/HomerpeaksGyoneva_H3K27ac_all.txt
    


#For Rbp2 peaks:

mergePeaks homer_peaks/Homerpeaks_Rbp2_Cx3cr1KO.txt homer_peaks/Homerpeaks_Rbp2_Cx3cr1WT.txt > homer_peaks/HomerpeaksGyoneva_Rbp2_all.txt

#######################################################################################

#Quantify the reads at the initial putative peaks across each of the target and input tag directories using annotatePeaks.pl. 
#http://homer.ucsd.edu/homer/ngs/diffExpression.html. This generate raw counts file from each tag directory for each sample for the merged peaks.

#IMPORTANT: Make sure you remember the order that your experiments and replicates where entered in for generating these commands.  Because experiment names can be cryptic, you will need to specify which experiments are which when running getDiffExpression.pl to assign replicates and conditions.
  
  #WT WT KO KO
annotatePeaks.pl homer_peaks/HomerpeaksGyoneva_H3K27ac_all.txt mm10 -raw -d TagDirectory/tag_SRR9034500 TagDirectory/tag_SRR9034501 TagDirectory/tag_SRR9034494 TagDirectory/tag_SRR9034495 > DEpeaks/countTable.Gyoneva.H3K27ac_all.peaks.txt

 #WT WT KO KO
annotatePeaks.pl  homer_peaks/HomerpeaksGyoneva_Rbp2_all.txt mm10 -raw -d TagDirectory/tag_SRR9034504 TagDirectory/tag_SRR9034505 TagDirectory/tag_SRR9034498 TagDirectory/tag_SRR9034499 > DEpeaks/countTable.Gyoneva.Rbp2_all.peaks.txt
	

#######################################################################################

#Calls getDiffExpression.pl and ultimately passes these values to the R/Bioconductor package DESeq2 to calculate enrichment values for each peak, returning only those peaks that pass a given fold enrichment (default: 2-fold) and FDR cutoff (default 5%).

#The getDiffExpression.pl program is executed with the following arguments:
#getDiffExpression.pl <raw count file> <group code1> <group code2> [group code3...] [options] > diffOutput.txt

#Provide sample group annotation for each experiment with an argument on the command line (in the same order found in the file, i.e. the same order given to the annotatePeaks.pl command when preparing the raw count file).

#H3K27ac  
getDiffExpression.pl DEpeaks/countTable.Gyoneva.H3K27ac_all.peaks.txt WT WT Cx3cr1KO Cx3cr1KO -simpleNorm > DEpeaks/Gyoneva.H3K27ac_diffpeaksOutput.txt
    
#Rbp2 
getDiffExpression.pl DEpeaks/countTable.Gyoneva.Rbp2_all.peaks.txt WT WT Cx3cr1KO Cx3cr1KO -simpleNorm > DEpeaks/Gyoneva.Rbp2_diffpeaksOutput.txt
    