#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=TSSplot
#SBATCH --output=TSSplot.out
#SBATCH --time=12:00:00


########################################################################################
#plot for signal over TSS regions of mouse genes: WT H3K27ac
########################################################################################
mkdir Deeptools/

computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/WT_H3K27ac_PBSrepl1.bw UCSCbrowsertracks/WT_H3K27ac_PBSrepl2.bw UCSCbrowsertracks/WT_H3K27ac_1xLPSrepl1.bw UCSCbrowsertracks/WT_H3K27ac_1xLPSrepl2.bw UCSCbrowsertracks/WT_H3K27ac_4xLPSrepl1.bw UCSCbrowsertracks/WT_H3K27ac_4xLPSrepl2.bw UCSCbrowsertracks/WT_input_mixedrepl1.bw UCSCbrowsertracks/WT_input_mixedrepl2.bw -p 20 -o Deeptools/WT.H3K27ac.mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/WT.H3K27ac.mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/WT.H3K27ac.mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS H3K27ac signal WT samples" --plotFileFormat "pdf" -out Deeptools/profile.WT.H3K27ac.mouseTSS.pdf --averageType mean --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/WT.H3K27ac.mouseTSS.tab.gz --regionsLabel "Mouse TSS H3K27ac signal WT samples" --plotFileFormat "pdf" --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2" -out Deeptools/Heatmap.WT.H3K27ac.mouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


########################################################################################
#plot for signal over TSS regions of mouse genes: APP23 H3K27ac
########################################################################################


computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/APP23_H3K27ac_PBSrepl1.bw UCSCbrowsertracks/APP23_H3K27ac_PBSrepl2.bw UCSCbrowsertracks/APP23_H3K27ac_1xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K27ac_1xLPSrepl2.bw UCSCbrowsertracks/APP23_H3K27ac_4xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K27ac_4xLPSrepl2.bw UCSCbrowsertracks/APP23_input_mixedrepl1.bw UCSCbrowsertracks/APP23_input_mixedrepl2.bw -p 20 -o Deeptools/APP23.H3K27ac.mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/APP23.H3K27ac.mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/APP23.H3K27ac.mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS H3K27ac signal APP23 samples" --plotFileFormat "pdf" -out Deeptools/profile.APP23.H3K27ac.mouseTSS.pdf --averageType mean --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/APP23.H3K27ac.mouseTSS.tab.gz --regionsLabel "Mouse TSS H3K27ac signal APP23 samples" --plotFileFormat "pdf" --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2" -out Deeptools/Heatmap.APP23.H3K27ac.mouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


########################################################################################
#plot for signal over TSS regions of mouse genes: WT H3K4me1
########################################################################################


computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/WT_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/WT_input_mixedrepl1.bw UCSCbrowsertracks/WT_input_mixedrepl2.bw -p 20 -o Deeptools/WT.H3K4me1.mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/WT.H3K4me1.mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/WT.H3K4me1.mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS H3K4me1 signal WT samples" --plotFileFormat "pdf" -out Deeptools/profile.WT.H3K4me1.mouseTSS.pdf --averageType mean --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/WT.H3K4me1.mouseTSS.tab.gz --regionsLabel "Mouse TSS H3K4me1 signal WT samples" --plotFileFormat "pdf" --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2" -out Deeptools/Heatmap.WT.H3K4me1.mouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


########################################################################################
#plot for signal over TSS regions of mouse genes: APP23 H3K4me1
########################################################################################


computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/APP23_H3K4me1_PBSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_PBSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl2.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl1.bw UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl2.bw UCSCbrowsertracks/APP23_input_mixedrepl1.bw UCSCbrowsertracks/APP23_input_mixedrepl2.bw -p 20 -o Deeptools/APP23.H3K4me1.mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/APP23.H3K4me1.mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/APP23.H3K4me1.mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS H3K4me1 signal APP23 samples" --plotFileFormat "pdf" -out Deeptools/profile.APP23.H3K4me1.mouseTSS.pdf --averageType mean --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2"

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/APP23.H3K4me1.mouseTSS.tab.gz --regionsLabel "Mouse TSS H3K4me1 signal APP23 samples" --plotFileFormat "pdf" --samplesLabel "PBS 1" "PBS 2" "1xLPS 1" "1xLPS 2" "4x LPS 1" "4x LPS 2" "Input 1" "Input 2" -out Deeptools/Heatmap.APP23.H3K4me1.mouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12