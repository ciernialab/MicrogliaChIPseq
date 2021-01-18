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

computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_peaks/Homerpeaks_H3K27ac.bed homer_peaks/Homerpeaks_H3K4me1.bed homer_peaks/Homerpeaks_H3K4me2.bed -S UCSCbrowsertracks/H3K27ac_1.bw UCSCbrowsertracks/H3K27ac_2.bw UCSCbrowsertracks/H3K27ac_3.bw UCSCbrowsertracks/H3K27ac_4.bw UCSCbrowsertracks/H3K27ac_5.bw UCSCbrowsertracks/H3K27ac_6.bw UCSCbrowsertracks/H3K4me1_1.bw UCSCbrowsertracks/H3K4me1_2.bw UCSCbrowsertracks/H3K4me1_3.bw UCSCbrowsertracks/H3K4me1_4.bw UCSCbrowsertracks/H3K4me1_5.bw UCSCbrowsertracks/H3K4me2_1.bw UCSCbrowsertracks/H3K4me2_2.bw UCSCbrowsertracks/Pooltag_Input.bw -p 20 -o Deeptools/All_peaks_LavinChIP.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/All_peaks_LavinChIP.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/All_peaks_LavinChIP.tab.gz --numPlotsPerRow 4 --regionsLabel "H3K27ac peaks" "H3K4me1 peaks" "H3K4me2 peaks" --plotFileFormat "pdf" -out Deeptools/profile_All_peaks_H3K27ac.pdf --averageType mean --samplesLabel "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me2" "H3K4me2" "Input"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/All_peaks_LavinChIP.tab.gz --regionsLabel "H3K27ac peaks" "H3K4me1 peaks" "H3K4me2 peaks" --plotFileFormat "pdf" --samplesLabel "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me2" "H3K4me2" "Input" -out Deeptools/Heatmap.All_peaks_LavinChIP.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

#