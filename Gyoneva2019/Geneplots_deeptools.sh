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

computeMatrix reference-point --referencePoint TSS -b 1000 -a 500 -R mm10.refseq.bed -S UCSCbrowsertracks/WT_H3k27ac_F.bw UCSCbrowsertracks/WT_H3k27ac_M.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_F.bw UCSCbrowsertracks/Cx3cr1KO_H3k27ac_M.bw UCSCbrowsertracks/WT_Rpb2_F.bw UCSCbrowsertracks/WT_Rpb2_M.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_F.bw UCSCbrowsertracks/Cx3cr1KO_Rpb2_M.bw UCSCbrowsertracks/WT_Input_F.bw UCSCbrowsertracks/WT_Input_M.bw UCSCbrowsertracks/Cx3cr1KO_Input_F.bw UCSCbrowsertracks/Cx3cr1KO_Input_M.bw -p 20 -o Deeptools/mouseTSS.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Deeptools/mouseTSS.out.bed


##########################################################################################

# plot
plotProfile -m Deeptools/mouseTSS.tab.gz --numPlotsPerRow 4 --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" -out Deeptools/profile_mouseTSS.pdf --averageType mean --samplesLabel "WT H2K27ac F" "WT H2K27ac M" "Cx3cr1KO H2K27ac F" "Cx3cr1KO H2K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M" 

# with legend media ymax chosen based on initial graphs
plotHeatmap -m Deeptools/mouseTSS.tab.gz --regionsLabel "Mouse TSS signal" --plotFileFormat "pdf" --samplesLabel "WT H2K27ac F" "WT H2K27ac M" "Cx3cr1KO H2K27ac F" "Cx3cr1KO H2K27ac M" "WT Rbp2 F" "WT Rbp2 M" "Cx3cr1KO Rbp2 F" "Cx3cr1KO Rbp2 M" "WT Input F" "WT Input M" "Cx3cr1KO Input F" "Cx3cr1KO Input M" -out Deeptools/Heatmap.MouseTSS.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12


