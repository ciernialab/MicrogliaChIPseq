#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=H3K4me1Allpeaks_deeptools
#SBATCH --output=H3K4me1Allpeaks_deeptools.out
#SBATCH --time=20:00:00


# uses the bigwig files created by UCSCBrowserHOMER.sh instead of the bigwig files in the BigWigs directory
#to make plots for each sample over each set of peak files (peaks from pooled tag directories)

########################################################################################
#plot H3K4me1 WT peaks
########################################################################################

##########################################################################################

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_H3K4me1_WT_PBS.bed homer_peaks/Homerpeaks_H3K4me1_WT_1xLPS.bed homer_peaks/Homerpeaks_H3K4me1_WT_4xLPS.bed -S UCSCbrowsertracks/WT_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/WT_input_mixedrepl1.bw UCSCbrowsertracks/WT_input_mixedrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/APP23_input_mixedrepl1.bw UCSCbrowsertracks/APP23_input_mixedrepl2.bw -p 20 -o Deeptools/WT_peaks_H3K4me1.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/WT_peaks_H3K4me1.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/WT_peaks_H3K4me1.tab.gz --numPlotsPerRow 3 --regionsLabel "H3K4me1 WT PBS peaks" "H3K4me1 WT 1xLPS peaks" "H3K4me1 WT 4xLPS peaks" --plotFileFormat "pdf" -out Deeptools/profile_WT_peaks_H3K4me1.pdf --averageType mean --samplesLabel "PBS WT 1" "PBS WT 2" "1xLPS WT 1" "1xLPS WT 2" "4x LPS WT 1" "4x LPS WT 2" "Input WT 1" "Input WT 2" "PBS APP23 1" "PBS APP23 2" "1xLPS APP23 1" "1xLPS APP23 2" "4x LPS APP23 1" "4x LPS APP23 2" "Input APP23 1" "Input APP23 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/WT_peaks_H3K4me1.tab.gz --regionsLabel "H3K4me1 WT PBS peaks" "H3K4me1 WT 1xLPS peaks" "H3K4me1 WT 4xLPS peaks" --plotFileFormat "pdf" --samplesLabel "PBS WT 1" "PBS WT 2" "1xLPS WT 1" "1xLPS WT 2" "4x LPS WT 1" "4x LPS WT 2" "Input WT 1" "Input WT 2" "PBS APP23 1" "PBS APP23 2" "1xLPS APP23 1" "1xLPS APP23 2" "4x LPS APP23 1" "4x LPS APP23 2" "Input APP23 1" "Input APP23 2" -out Deeptools/Heatmap.WT_peaks_H3K4me1.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


########################################################################################
#plot H3K4me1 APP23 peaks
########################################################################################

##########################################################################################

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_H3K4me1_APP23_PBS.bed homer_peaks/Homerpeaks_H3K4me1_APP23_1xLPS.bed homer_peaks/Homerpeaks_H3K4me1_APP23_4xLPS.bed -S UCSCbrowsertracks/WT_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/WT_input_mixedrepl1.bw UCSCbrowsertracks/WT_input_mixedrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/APP23_input_mixedrepl1.bw UCSCbrowsertracks/APP23_input_mixedrepl2.bw -p 20 -o Deeptools/APP23_peaks_H3K4me1.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/APP23_peaks_H3K4me1.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/APP23_peaks_H3K4me1.tab.gz --numPlotsPerRow 3 --regionsLabel "H3K4me1 APP23 PBS peaks" "H3K4me1 APP23 1xLPS peaks" "H3K4me1 APP23 4xLPS peaks" --plotFileFormat "pdf" -out Deeptools/profile_APP23_peaks_H3K4me1.pdf --averageType mean --samplesLabel "PBS WT 1" "PBS WT 2" "1xLPS WT 1" "1xLPS WT 2" "4x LPS WT 1" "4x LPS WT 2" "Input WT 1" "Input WT 2" "PBS APP23 1" "PBS APP23 2" "1xLPS APP23 1" "1xLPS APP23 2" "4x LPS APP23 1" "4x LPS APP23 2" "Input APP23 1" "Input APP23 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/APP23_peaks_H3K4me1.tab.gz --regionsLabel "H3K4me1 APP23 PBS peaks" "H3K4me1 APP23 1xLPS peaks" "H3K4me1 APP23 4xLPS peaks" --plotFileFormat "pdf" --samplesLabel "PBS WT 1" "PBS WT 2" "1xLPS WT 1" "1xLPS WT 2" "4x LPS WT 1" "4x LPS WT 2" "Input WT 1" "Input WT 2" "PBS APP23 1" "PBS APP23 2" "1xLPS APP23 1" "1xLPS APP23 2" "4x LPS APP23 1" "4x LPS APP23 2" "Input APP23 1" "Input APP23 2" -out Deeptools/Heatmap.APP23_peaks_H3K4me1.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

#