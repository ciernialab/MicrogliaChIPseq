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

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_cxMg_H3K27me3.bed homer_peaks/Homerpeaks_cbMG_H3K27me3.bed homer_peaks/Homerpeaks_StrMG_H3K27me3.bed homer_peaks/Pooltag_H3K27me3_allregions.bed -S UCSCbrowsertracks/cxMg_H3K27me3.bw UCSCbrowsertracks/cbMG_H3K27me3.bw UCSCbrowsertracks/StrMG_H3K27me3.bw UCSCbrowsertracks/Pooltag_H3K27me3_allregions.bw UCSCbrowsertracks/cxMg_Input.bw UCSCbrowsertracks/cbMG_Input.bw UCSCbrowsertracks/StrMG_Input.bw UCSCbrowsertracks/Pooltag_Input.bw -p 20 -o Deeptools/All_peaks_H3K27me3.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/All_peaks_H3K27me3.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/All_peaks_H3K27me3.tab.gz --numPlotsPerRow 4 --regionsLabel "H3K27me3 CTX MG" "H3K27me3 CB MG" "H3K27me3 STR MG" "H3K27me3 All MG" --plotFileFormat "pdf" -out Deeptools/profile_All_peaks_H3K27me3.pdf --averageType mean --samplesLabel "CTX MG H3K27me3" "CB MG H3K27me3" "STR MG H3K27me3" "All MG H3K27me3" "CTX Input" "CB Input" "STR Input" "All Input"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/All_peaks_H3K27me3.tab.gz --regionsLabel "H3K27me3 CTX MG" "H3K27me3 CB MG" "H3K27me3 STR MG" "H3K27me3 All MG" --plotFileFormat "pdf" --samplesLabel "CTX MG H3K27me3" "CB MG H3K27me3" "STR MG H3K27me3" "All MG H3K27me3" "CTX Input" "CB Input" "STR Input" "All Input" -out Deeptools/Heatmap.All_peaks_H3K27me3.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

