#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=BamSum
#SBATCH --output=BamSummary.out
#SBATCH --time=10:00:00

#######################################################################################
#bam summary 
#######################################################################################
mkdir Deeptools

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

#ATAC
multiBamSummary bins --bamfiles aligned/SRR5617659_dedup.bam aligned/SRR5617660_dedup.bam --labels repl1 repl2 -o Deeptools/ATAC_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20

#H3K27ac
multiBamSummary bins --bamfiles aligned/SRR5617663_dedup.bam aligned/SRR5617664_dedup.bam aligned/SRR5617669_dedup.bam aligned/SRR5617670_dedup.bam aligned/SRR5617671_dedup.bam aligned/SRR5617672_dedup.bam aligned/SRR5617673_dedup.bam aligned/SRR5617674_dedup.bam --labels repl1 repl2 input1 input2 input3 input4 input5 input6 -o Deeptools/H3K27ac_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20

#PU1
multiBamSummary bins --bamfiles aligned/SRR5617677_dedup.bam aligned/SRR5617678_dedup.bam aligned/SRR5617669_dedup.bam aligned/SRR5617670_dedup.bam aligned/SRR5617671_dedup.bam aligned/SRR5617672_dedup.bam aligned/SRR5617673_dedup.bam aligned/SRR5617674_dedup.bam --labels repl1 repl2 input1 input2 input3 input4 input5 input6 -o Deeptools/PU1_BamSum10kbbins.npz --blackListFileName $BL/mm10.blacklist.bed -p 20


 #Plot the correlation between samples as a Correlation Plot:
 
#For ATAC:     
plotCorrelation -in Deeptools/ATAC_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_ATAC.pdf
    
#For H3K27ac:     
plotCorrelation -in Deeptools/H3K27ac_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_H3K27ac.pdf

#For PU1:     
plotCorrelation -in Deeptools/PU1_BamSum10kbbins.npz --corMethod spearman --skipZeros --plotTitle "Spearman Correlation of Sequencing Depth Normalized Read Counts" --whatToPlot heatmap --colorMap RdYlBu --plotNumbers -o Deeptools/SpearmanCorr_PU1.pdf


#######################################################################################
#Coverage Plots
#To see how many bp in the genome are actually covered by (a good number) of sequencing reads, we use plotCoverage which generates two diagnostic plots that help us decide whether we need to sequence deeper or not. It samples 1 million bp, counts the number of overlapping reads and can report a histogram that tells you how many bases are covered how many times. Multiple BAM files are accepted, but they all should correspond to the same genome assembly.

#######################################################################################

#ATAC
plotCoverage --bamfiles aligned/SRR5617659_dedup.bam aligned/SRR5617660_dedup.bam --labels repl1 repl2 -o Deeptools/ATAC_Coverage.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf

#H3K27ac
plotCoverage --bamfiles aligned/SRR5617663_dedup.bam aligned/SRR5617664_dedup.bam --labels repl1 repl2 -o Deeptools/H3K27ac_Coverage.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf

#PU1
plotCoverage --bamfiles aligned/SRR5617677_dedup.bam aligned/SRR5617678_dedup.bam --labels repl1 repl2 -o Deeptools/PU1_Coverage.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf

#######################################################################################
#This tool samples indexed BAM files and plots a profile of cumulative read coverages for each. 
#All reads overlapping a window (bin) of the specified
#length are counted; these counts are sorted and the cumulative sum is finally
#plotted.
#######################################################################################

#ATAC
plotFingerprint -b aligned/SRR5617659_dedup.bam aligned/SRR5617660_dedup.bam --labels repl1 repl2 -o Deeptools/ATAC_Fingerprint.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf

#H3K27ac
plotFingerprint -b aligned/SRR5617663_dedup.bam aligned/SRR5617664_dedup.bam aligned/SRR5617669_dedup.bam aligned/SRR5617670_dedup.bam aligned/SRR5617671_dedup.bam aligned/SRR5617672_dedup.bam aligned/SRR5617673_dedup.bam align -o Deeptools/H3K27ac_Fingerprint.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf

#PU1
plotFingerprint -b aligned/SRR5617677_dedup.bam aligned/SRR5617678_dedup.bam aligned/SRR5617669_dedup.bam aligned/SRR5617670_dedup.bam aligned/SRR5617671_dedup.bam aligned/SRR5617672_dedup.bam aligned/SRR5617673_dedup.bam align -o Deeptools/PU1_Fingerprint.pdf --blackListFileName $BL/mm10.blacklist.bed -p 20 --plotFileFormat pdf




