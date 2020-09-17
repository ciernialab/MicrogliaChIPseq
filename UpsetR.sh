#!/bin/bash
#
#SBATCH -c 4
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=upsetR
#SBATCH --output=upsetR.out
#SBATCH --time=4:00:00

module load samtools/1.4
module load jre/1.8.0_121
module load R

#enhancers
mergePeaks homer_regions/Homerpeaks_ATAC.bed homer_regions/Homerpeaks_H3K27ac.bed homer_regions/Homerpeaks_H3K4me2.bed homer_regions/Homerpeaks_PU1.bed -prefix mergepeaks -venn homer_regions/venn.MGenhancers.txt -matrix homer_regions/matrix.MGenhancers.txt


Rscript --vanilla multi_peaks_UpSet_plot.R "Enhancers" homer_regions/venn.MGenhancers.txt

mkdir upset

mv *.bed upset