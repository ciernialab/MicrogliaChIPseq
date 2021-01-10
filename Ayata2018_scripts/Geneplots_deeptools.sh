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

computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/cxMg_H3K27me3.bw UCSCbrowsertracks/cbMG_H3K27me3.bw UCSCbrowsertracks/StrMG_H3K27me3.bw UCSCbrowsertracks/Pooltag_H3K27me3_allregions.bw UCSCbrowsertracks/cxMg_Input.bw UCSCbrowsertracks/cbMG_Input.bw UCSCbrowsertracks/StrMG_Input.bw UCSCbrowsertracks/Pooltag_Input.bw -p 20 -o Deeptools/mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" -out Deeptools/profile_mouseTSS.pdf --averageType mean --samplesLabel "CTX MG H3K27me3" "CB MG H3K27me3" "STR MG H3K27me3" "All MG H3K27me3" "CTX Input" "CB Input" "STR Input" "All Input"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/mouseTSS.tab.gz --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" --samplesLabel "CTX MG H3K27me3" "CB MG H3K27me3" "STR MG H3K27me3" "All MG H3K27me3" "CTX Input" "CB Input" "STR Input" "All Input" -out Deeptools/Heatmap.MouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


