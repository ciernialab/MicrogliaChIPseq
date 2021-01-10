#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Allpeaks_deeptools
#SBATCH --output=Allpeaks_deeptools.out
#SBATCH --time=5:00:00


# uses the bigwig files created by UCSCBrowserHOMER.sh instead of the bigwig files in the BigWigs directory
#to make plots for each sample over each set of peak files (peaks from pooled tag directories)

########################################################################################
#plot H3K27ac peaks
########################################################################################

##########################################################################################

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_H3K27ac_Cx3cr1KO.bed homer_peaks/Homerpeaks_H3K27ac_Cx3cr1WT.bed -S UCSCbrowsertracks/WT_H3k27ac_F.bw UCSCbrowsertracks/WT_H3k27ac_M.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_F.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_M.bw UCSCbrowsertracks/WT_Rpb2_F.bw UCSCbrowsertracks/WT_Rpb2_M.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_F.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_M.bw UCSCbrowsertracks/WT_Input_F.bw UCSCbrowsertracks/WT_Input_M.bw UCSCbrowsertracks/Cx3cr1KO_Input_F.bw UCSCbrowsertracks/Cx3cr1KO_Input_M.bw -p 20 -o Deeptools/All_peaks_H3K27ac.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/All_peaks_H3K27ac.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/All_peaks_H3K27ac.tab.gz --numPlotsPerRow 4 --regionsLabel "H3K27ac Cx3cr1KO peaks" "H3K27ac WT peaks" --plotFileFormat "pdf" -out Deeptools/profile_All_peaks_H3K27ac.pdf --averageType mean --samplesLabel "WT H3K27ac F" "WT H3K27ac M" "Cx3cr1KO H3K27ac F" "Cx3cr1KO H3K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/All_peaks_H3K27ac.tab.gz --regionsLabel "H3K27ac Cx3cr1KO peaks" "H3K27ac WT peaks" --plotFileFormat "pdf" --samplesLabel "WT H3K27ac F" "WT H3K27ac M" "Cx3cr1KO H3K27ac F" "Cx3cr1KO H3K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M" -out Deeptools/Heatmap.All_peaks_H3K27ac.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

##########################################################################################

########################################################################################
#plot Rbp2 peaks
########################################################################################
computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_Rpb2_Cx3cr1KO.bed homer_peaks/Homerpeaks_Rpb2_Cx3cr1WT.bed -S UCSCbrowsertracks/WT_H3k27ac_F.bw UCSCbrowsertracks/WT_H3k27ac_M.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_F.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_M.bw UCSCbrowsertracks/WT_Rpb2_F.bw UCSCbrowsertracks/WT_Rpb2_M.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_F.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_M.bw UCSCbrowsertracks/WT_Input_F.bw UCSCbrowsertracks/WT_Input_M.bw UCSCbrowsertracks/Cx3cr1KO_Input_F.bw UCSCbrowsertracks/Cx3cr1KO_Input_M.bw -p 20 -o Deeptools/All_peaks_Rpb2.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/All_peaks_Rpb2.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/All_peaks_Rpb2.tab.gz --numPlotsPerRow 4 --regionsLabel "Rpb2 Cx3cr1KO peaks" "Rpb2 WT peaks" --plotFileFormat "pdf" -out Deeptools/profile_All_peaks_Rpb2.pdf --averageType mean --samplesLabel "WT H3K27ac F" "WT H3K27ac M" "Cx3cr1KO H3K27ac F" "Cx3cr1KO H3K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/All_peaks_Rpb2.tab.gz --regionsLabel "Rpb2 Cx3cr1KO peaks" "Rpb2 WT peaks" --plotFileFormat "pdf" --samplesLabel "WT H3K27ac F" "WT H3K27ac M" "Cx3cr1KO H3K27ac F" "Cx3cr1KO H3K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M" -out Deeptools/Heatmap.All_peaks_Rpb2.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12
