#!/bin/bash
#
#SBATCH -c 1
#SBATCH --mem-per-cpu=2000
#SBATCH --job-name=DiffPeaks2
#SBATCH --output=DiffPeaks2.out
#SBATCH --time=10:00:00

#######################################################################################
#merges peaks, annotates and calls DE peaks
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir DEpeaks/
#######################################################################################

#######################################################################################
#H3K27ac WT
#########################################

mergePeaks homer_peaks/Homerpeaks_H3K27ac_WT_1xLPS.txt homer_peaks/Homerpeaks_H3K27ac_WT_4xLPS.txt homer_peaks/Homerpeaks_H3K27ac_WT_PBS.txt > homer_peaks/MergePeaksWendeln_H3K27ac_WT_all.txt
    

#######################################################################################
#H3K27ac WT vs APP23 
#########################################

mergePeaks homer_peaks/Homerpeaks_H3K27ac_WT_1xLPS.txt homer_peaks/Homerpeaks_H3K27ac_WT_4xLPS.txt homer_peaks/Homerpeaks_H3K27ac_WT_PBS.txt homer_peaks/Homerpeaks_H3K27ac_APP23_1xLPS.txt homer_peaks/Homerpeaks_H3K27ac_APP23_4xLPS.txt homer_peaks/Homerpeaks_H3K27ac_APP23_PBS.txt > homer_peaks/MergePeaksWendeln_H3K27ac_APP23.WT_all.txt


#######################################################################################
#H3K4me1 WT
#########################################

mergePeaks homer_peaks/Homerpeaks_H3K4me1_WT_1xLPS.txt homer_peaks/Homerpeaks_H3K4me1_WT_4xLPS.txt homer_peaks/Homerpeaks_H3K4me1_WT_PBS.txt > homer_peaks/MergePeaksWendeln_H3K4me1_WT_all.txt
    

#######################################################################################
#H3K4me1 WT vs APP23 
#########################################

mergePeaks homer_peaks/Homerpeaks_H3K4me1_WT_1xLPS.txt homer_peaks/Homerpeaks_H3K4me1_WT_4xLPS.txt homer_peaks/Homerpeaks_H3K4me1_WT_PBS.txt homer_peaks/Homerpeaks_H3K4me1_APP23_1xLPS.txt homer_peaks/Homerpeaks_H3K4me1_APP23_4xLPS.txt homer_peaks/Homerpeaks_H3K4me1_APP23_PBS.txt > homer_peaks/MergePeaksWendeln_H3K4me1_APP23.WT_all.txt


#######################################################################################
#######################################################################################

#Quantify the reads at the initial putative peaks across each of the target and input tag directories using annotatePeaks.pl. 
#http://homer.ucsd.edu/homer/ngs/diffExpression.html. This generate raw counts file from each tag directory for each sample for the merged peaks.

#IMPORTANT: Make sure you remember the order that your experiments and replicates where entered in for generating these commands.  Because experiment names can be cryptic, you will need to specify which experiments are which when running getDiffExpression.pl to assign replicates and conditions.

#######################################################################################
#H3K27ac WT LPS: PBS PBS 1x 1x 4x 4x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K27ac_WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621162 TagDirectory/tag_SRR3621163 TagDirectory/tag_SRR3621164 TagDirectory/tag_SRR3621165 TagDirectory/tag_SRR3621166 TagDirectory/tag_SRR3621167 > DEpeaks/countTable.Wendeln.H3K27ac_WT.all.peaks.txt


#######################################################################################
#H3K27ac WT LPS: PBS PBS 1x 1x 4x 4x  APP23 LPS: PBS PBS 1x 1x 4x 4x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K4me1_APP23.WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621162 TagDirectory/tag_SRR3621163 TagDirectory/tag_SRR3621164 TagDirectory/tag_SRR3621165 TagDirectory/tag_SRR3621166 TagDirectory/tag_SRR3621167 TagDirectory/tag_SRR3621168 TagDirectory/tag_SRR3621169 TagDirectory/tag_SRR3621170 TagDirectory/tag_SRR3621171 TagDirectory/tag_SRR3621172 TagDirectory/tag_SRR3621173 > DEpeaks/countTable.Wendeln.H3K27ac_WT.APP23.all.peaks.txt

#######################################################################################
#H3K4me1 WT LPS: PBS PBS 1x 1x 4x 4x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K4me1_WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621150 TagDirectory/tag_SRR3621151 TagDirectory/tag_SRR3621152 TagDirectory/tag_SRR3621153 TagDirectory/tag_SRR3621155 TagDirectory/tag_SRR3621154 > DEpeaks/countTable.Wendeln.H3K4me1_WT.all.peaks.txt


#######################################################################################
#H3K4me1 WT LPS: PBS PBS 1x 1x 4x 4x  APP23 LPS: PBS PBS 1x 1x 4x 4x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K4me1_APP23.WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621150 TagDirectory/tag_SRR3621151 TagDirectory/tag_SRR3621152 TagDirectory/tag_SRR3621153 TagDirectory/tag_SRR3621155 TagDirectory/tag_SRR3621154 TagDirectory/tag_SRR3621156 TagDirectory/tag_SRR3621157 TagDirectory/tag_SRR3621159 TagDirectory/tag_SRR3621158 TagDirectory/tag_SRR3621160 TagDirectory/tag_SRR3621161 > DEpeaks/countTable.Wendeln.H3K4me1_WT.APP23.all.peaks.txt


#######################################################################################

#Calls getDiffExpression.pl and ultimately passes these values to the R/Bioconductor package DESeq2 to calculate enrichment values for each peak, returning only those peaks that pass a given fold enrichment (default: 2-fold) and FDR cutoff (default 5%).

#The getDiffExpression.pl program is executed with the following arguments:
#getDiffExpression.pl <raw count file> <group code1> <group code2> [group code3...] [options] > diffOutput.txt

#Provide sample group annotation for each experiment with an argument on the command line (in the same order found in the file, i.e. the same order given to the annotatePeaks.pl command when preparing the raw count file).
#-AvsA all possible comparisons

#H3K27ac WT
getDiffExpression.pl DEpeaks/countTable.Wendeln.H3K27ac_WT.all.peaks.txt WT_PBS WT_PBS WT_1xLPS WT_1xLPS WT_4xLPS WT_4xLPS -simpleNorm -AvsA > DEpeaks/Wendeln.H3K27ac_WT.all_diffpeaksOutput.txt

    
#H3K4me1 WT
getDiffExpression.pl DEpeaks/countTable.Wendeln.H3K4me1_WT.all.peaks.txt WT_PBS WT_PBS WT_1xLPS WT_1xLPS WT_4xLPS WT_4xLPS -simpleNorm -AvsA > DEpeaks/Wendeln.H3K4me1_WT.all_diffpeaksOutput.txt



#H3K27ac WT vs APP23
getDiffExpression.pl DEpeaks/countTable.Wendeln.H3K27ac_WT.APP23.all.peaks.txt WT_PBS WT_PBS WT_1xLPS WT_1xLPS WT_4xLPS WT_4xLPS APP23_PBS APP23_PBS APP23_1xLPS APP23_1xLPS APP23_4xLPS APP23_4xLPS -simpleNorm -AvsA > DEpeaks/Wendeln.H3K27ac_WTvsAPP23.all.peaks.txt

#H3K4me1 WT vs APP23
getDiffExpression.pl DEpeaks/countTable.Wendeln.H3K4me1_WT.APP23.all.peaks.txt WT_PBS WT_PBS WT_1xLPS WT_1xLPS WT_4xLPS WT_4xLPS APP23_PBS APP23_PBS APP23_1xLPS APP23_1xLPS APP23_4xLPS APP23_4xLPS -simpleNorm -AvsA > DEpeaks/Wendeln.H3K4me1_WTvsAPP23.all.peaks.txt

#######################################################################################
#######################################################################################
#H3K27ac WT LPS: PBS PBS 1x 1x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K27ac_WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621162 TagDirectory/tag_SRR3621163 TagDirectory/tag_SRR3621164 TagDirectory/tag_SRR3621165 > DEpeaks/countTable.Wendeln.H3K27ac_WT.PBSv1xPLPSpeaks.txt

#H3K27ac WT
getDiffExpression.pl DEpeaks/countTable.Wendeln.H3K27ac_WT.PBSv1xPLPSpeaks.txt WT_PBS WT_PBS WT_1xLPS WT_1xLPS -simpleNorm > DEpeaks/Wendeln.H3K27ac_WT.PBSv1xPLPSpeaks_diffpeaksOutput.txt

#######################################################################################
#H3K27ac WT LPS: PBS PBS 4x 4x
#######################################################################################
annotatePeaks.pl homer_peaks/MergePeaksWendeln_H3K27ac_WT_all.txt mm10 -raw -d TagDirectory/tag_SRR3621162 TagDirectory/tag_SRR3621163 TagDirectory/tag_SRR3621166 TagDirectory/tag_SRR3621167 > DEpeaks/countTable.Wendeln.H3K27ac_WT.PBSv4xLPS.peaks.txt

   #H3K27ac WT
getDiffExpression.pl  DEpeaks/countTable.Wendeln.H3K27ac_WT.PBSv4xLPS.peaks.txt WT_PBS WT_PBS WT_4xLPS WT_4xLPS -simpleNorm > DEpeaks/Wendeln.H3K27ac_WT.PBSv4xPLPSpeaks_diffpeaksOutput.txt
 