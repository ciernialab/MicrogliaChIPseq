#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=TSSplot
#SBATCH --output=TSSplot.out
#SBATCH --time=5:00:00


########################################################################################
#plot for signal over TSS regions of mouse genes
########################################################################################
mkdir Deeptools/

computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/H3K27ac_1.bw UCSCbrowsertracks/H3K27ac_2.bw UCSCbrowsertracks/H3K27ac_3.bw UCSCbrowsertracks/H3K27ac_4.bw UCSCbrowsertracks/H3K27ac_5.bw UCSCbrowsertracks/H3K27ac_6.bw UCSCbrowsertracks/H3K4me1_1.bw UCSCbrowsertracks/H3K4me1_2.bw UCSCbrowsertracks/H3K4me1_3.bw UCSCbrowsertracks/H3K4me1_4.bw UCSCbrowsertracks/H3K4me1_5.bw UCSCbrowsertracks/H3K4me2_1.bw UCSCbrowsertracks/H3K4me2_2.bw UCSCbrowsertracks/Pooltag_Input.bw -p 20 -o Deeptools/mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" -out Deeptools/profile_mouseTSS.pdf --averageType mean --samplesLabel "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me2" "H3K4me2" "Input"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/mouseTSS.tab.gz --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" --samplesLabel "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K27ac" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me1" "H3K4me2" "H3K4me2" "Input" -out Deeptools/Heatmap.MouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


