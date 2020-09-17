#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Peaks_Deeptools
#SBATCH --output=Peaks_Deeptools.out
#SBATCH --time=5:00:00


# This script is modified from the old script (Geneplots_deeptols.sh) by
# - creating a new directory
# - using the BED file from the DEpeak finding instead of the mm10refseq.bed
# - using the bigwig files created by UCSCBrowserHOMER.sh instead of the bigwig files in the BigWigs directory



########################################################################################
#create new directory to store files
########################################################################################

mkdir Peaks_Deeptools

########################################################################################
#plot DEpeaks using DEpeaks
########################################################################################
#ATAC
##########################################################################################

# this was changed to include the bed file from the DEpeak finding
# the bigwig files from the UCSSCBroswerHOMER.sh script is used as well. Note how they match up exactly
# with the --samplesLabel labels listed in the plotProfile command. This is important
computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_regions/Homerpeaks_ATAC.bed -S UCSCbrowsertracks/ATAC_Repl1.bw UCSCbrowsertracks/ATAC_Repl2.bw -p 20 -o Peaks_Deeptools/Peaks.ATAC.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Peaks_Deeptools/ATACpeaks_out.bed

# plot
plotProfile -m Peaks_Deeptools/Peaks.ATAC.tab.gz --numPlotsPerRow 2 --regionsLabel "ATAC Peaks" --plotFileFormat "pdf" -out Peaks_Deeptools/profile_ATAC.pdf --averageType mean --samplesLabel "Repl1" "Repl2"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Peaks_Deeptools/Peaks.ATAC.tab.gz --regionsLabel "ATAC Peaks" --plotFileFormat "pdf" --samplesLabel "Repl1" "Repl2" -out Peaks_Deeptools/Heatmap.ATAC.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12

##########################################################################################

########################################################################################
#H3K27ac
##########################################################################################

# this was changed to include the bed file from the DEpeak finding
# the bigwig files from the UCSSCBroswerHOMER.sh script is used as well. Note how they match up exactly
# with the --samplesLabel labels listed in the plotProfile command. This is important
computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_regions/Homerpeaks_H3K27ac.bed -S UCSCbrowsertracks/H3K27ac_Repl1.bw UCSCbrowsertracks/H3K27ac_Repl2.bw UCSCbrowsertracks/Input_Pool.bw -p 20 -o Peaks_Deeptools/Peaks.H3K27ac.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Peaks_Deeptools/H3K27acpeaks_out.bed

# plot
plotProfile -m Peaks_Deeptools/Peaks.H3K27ac.tab.gz --numPlotsPerRow 2 --regionsLabel "H3K27ac Peaks" --plotFileFormat "pdf" -out Peaks_Deeptools/profile_H3K27ac.pdf --averageType mean --samplesLabel "Repl1" "Repl2" "Input"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Peaks_Deeptools/Peaks.H3K27ac.tab.gz --regionsLabel "H3K27ac Peaks" --plotFileFormat "pdf" --samplesLabel "Repl1" "Repl2" "Input" -out Peaks_Deeptools/Heatmap.H3K27ac.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12
##########################################################################################

########################################################################################
#H3K4me2
##########################################################################################

# this was changed to include the bed file from the DEpeak finding
# the bigwig files from the UCSSCBroswerHOMER.sh script is used as well. Note how they match up exactly
# with the --samplesLabel labels listed in the plotProfile command. This is important
computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_regions/Homerpeaks_H3K4me2.bed -S UCSCbrowsertracks/H3K4me2_Repl1.bw UCSCbrowsertracks/H3K4me2_Repl2.bw UCSCbrowsertracks/Input_Pool.bw -p 20 -o Peaks_Deeptools/Peaks.H3K4me2.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Peaks_Deeptools/H3K4me2peaks_out.bed

# plot
plotProfile -m Peaks_Deeptools/Peaks.H3K4me2.tab.gz --numPlotsPerRow 2 --regionsLabel "H3K4me2 Peaks" --plotFileFormat "pdf" -out Peaks_Deeptools/profile_H3K4me2.pdf --averageType mean --samplesLabel "Repl1" "Repl2" "Input"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Peaks_Deeptools/Peaks.H3K4me2.tab.gz --regionsLabel "H3K4me2 Peaks" --plotFileFormat "pdf" --samplesLabel "Repl1" "Repl2" "Input" -out Peaks_Deeptools/Heatmap.H3K4me2.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12
##########################################################################################
########################################################################################
#PU1
##########################################################################################

# this was changed to include the bed file from the DEpeak finding
# the bigwig files from the UCSSCBroswerHOMER.sh script is used as well. Note how they match up exactly
# with the --samplesLabel labels listed in the plotProfile command. This is important
computeMatrix reference-point --referencePoint center -b 500 -a 500 -R homer_regions/Homerpeaks_PU1.bed -S UCSCbrowsertracks/PU1_Repl1.bw UCSCbrowsertracks/PU1_Repl2.bw UCSCbrowsertracks/Input_Pool.bw -p 20 -o Peaks_Deeptools/Peaks.PU1.tab.gz --skipZeros --missingDataAsZero --binSize 10 --outFileSortedRegions Peaks_Deeptools/PU1peaks_out.bed

# plot
plotProfile -m Peaks_Deeptools/Peaks.PU1.tab.gz --numPlotsPerRow 2 --regionsLabel "PU1 Peaks" --plotFileFormat "pdf" -out Peaks_Deeptools/profile_PU1.pdf --averageType mean --samplesLabel "Repl1" "Repl2" "Input"


# with legend media ymax chosen based on initial graphs
plotHeatmap -m Peaks_Deeptools/Peaks.PU1.tab.gz --regionsLabel "PU1 Peaks" --plotFileFormat "pdf" --samplesLabel "Repl1" "Repl2" "Input" -out Peaks_Deeptools/Heatmap.PU1.pdf --averageType mean --perGroup --colorMap bwr --averageTypeSummaryPlot mean --legendLocation upper-right --heatmapWidth 12
##########################################################################################
