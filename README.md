# MicrogliaChIPseq
Reanalysis of published mouse microglia ChIPseq datasets

Goal: Analyze ChIPseq data from mouse microglia from published papers:
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE62826
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM1545960

https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE89960

Dataset #1 H3K27ac ChIPseq from acutely isolated microglia 

Dataset #2 H3K4me2 ChIPseq acutely isolated microglia:

Dataset #3 ATAC-seq from acutely isolated microglia: 

Dataset #4 Inupt samples

Dataset #5 PU.1 ChIPseq acutely isolated microglia

# See DataSetInfo.txt for more details etc.

# 1. Get SRR files
To find a comprehensive list of the SRR files, we use the Run Selector.
Navigate to the bottom of the page and click “send to” and select “Run Selector”, and then press “go”.
https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE89960

Under the Select section click on the Metadata and List Accession to dowload the information on the experiment and the list of SRR files.
See screen shot image.
Use the SRR_Acc_List.txt as the samples list for the SRRpull.sh script

 single-end sequenced for 51 cycles 
 adjust SRRpull.sh for single end seq files

SRR5617659	Mouse_ATAC_ExVivo_Rep1
SRR5617660	Mouse_ATAC_ExVivo_Rep2
SRR5617663	Mouse_H3K27ac_ExVivo_Rep1
SRR5617664	Mouse_H3K27ac_ExVivo_Rep2
SRR5617667	Mouse_H3K4me2_ExVivo_Rep1
SRR5617668	Mouse_H3K4me2_ExVivo_Rep2
SRR5617669	Mouse_Input_ExVivo_Rep1
SRR5617670	Mouse_Input_ExVivo_Rep2
SRR5617671	Mouse_Input_ExVivo_Rep3
SRR5617672	Mouse_Input_ExVivo_Rep4
SRR5617673	Mouse_Input_ExVivo_Rep5
SRR5617674	Mouse_Input_ExVivo_Rep6
SRR5617677	Mouse_Pu1_ExVivo_Rep1
SRR5617678	Mouse_Pu1_ExVivo_Rep2

# 2. Trim with Trimmomatic for SE reads
    TrimSE.sh
    
# 3. Run FastQC on pre and post trim reads
    FastQC.sh
    
# 4. Run FastqScreen on post trimmed reads
    Fastqscreen.sh
    
# 5. Align using bowtie2 for SE reads
    sbatch Bowtie2alignment.sh
    
# 6.  Filter reads to remove PCR duplicates, remove unmapped reads and secondary alignments (multi-mappers)
We remove PCR duplicates using -F 0x400 
We then indext the reads and collect additional QC metrics using picard tools and samtools flagstat
QC meterics are then collected into one report using multiqc.

  sbatch samtoolsFilter.sh
  
# 7. Run additional QC with Deeptools
  
    sbatch Deeptools.sh
    
# 8. shift ATAC seq for Tn5 cut sites
    https://github.com/TheJacksonLaboratory/ATAC-seq
> fails on SE data > not run. No shifting performed on this dataset.

# 9. Make Tag directories on individual samples and pools. 
 From GEO: The tag directories for the input DNA were likewise combined. Peaks were then called on the pooled tags with the pooled input DNA as background using HOMER’s findPeaks command with the following parameters for the PU.1 ChIP-seq: “-style factor -size 200 -minDist 200” and the following parameters for the H3K27ac and H3K4me2 ChIP-seq: “-style histone -size 500 -minDist 1000 -region.” The “-tbp” parameter was set to the number of replicates in the pool.
 
Tag directories for the ATAC-seq experiments were combined into an ex vivo and in vitro pool for both mouse and human. Peaks were then called on the pooled tags using HOMER’s findPeaks command with the following parameters: “-style factor -size 200 -minDist 200” with the “-tbp” parameter was set to the number of replicates in the pool.
 
 sbatch HOMER_MakeTags.sh

# 10. Make UCSC genome browser bedgraph and bigwig files
  sbatch UCSCBrowserHOMER.sh 
  
  
# 11. Make plots of normalized signal over peak regions
  Peaks_Deeptool_Plots.sh
  
# 12. Look at overalpping peaks with Upset plots in R
  upset.sh

