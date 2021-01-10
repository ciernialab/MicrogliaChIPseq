#!/bin/bash
#
#SBATCH -c 12
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=UCSC
#SBATCH --output=HOMERUCSC.out
#SBATCH --time=12:00:00

#######################################################################################
#makeUCSCfile <tag directory-res 10 > -fragLength given -res 10 > UCSCbrowsertracks/
#10bp resolution
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121
module load R/3.6.1

#######################################################################################
mkdir UCSCbrowsertracks/
echo "making bedGraphs"
#######################################################################################
# normalized bedgraphs
#######################################################################################

# SRR5617659	Mouse_ATAC_ExVivo_Rep1
# SRR5617660	Mouse_ATAC_ExVivo_Rep2
# SRR5617663	Mouse_H3K27ac_ExVivo_Rep1
# SRR5617664	Mouse_H3K27ac_ExVivo_Rep2
# SRR5617667	Mouse_H3K4me2_ExVivo_Rep1
# SRR5617668	Mouse_H3K4me2_ExVivo_Rep2
# SRR5617669	Mouse_Input_ExVivo_Rep1
# SRR5617670	Mouse_Input_ExVivo_Rep2
# SRR5617671	Mouse_Input_ExVivo_Rep3
# SRR5617672	Mouse_Input_ExVivo_Rep4
# SRR5617673	Mouse_Input_ExVivo_Rep5
# SRR5617674	Mouse_Input_ExVivo_Rep6
# SRR5617677	Mouse_Pu1_ExVivo_Rep1
# SRR5617678	Mouse_Pu1_ExVivo_Rep2

#ATAC
makeUCSCfile TagDirectory/tag_SRR5617659 -fragLength given -name ATAC_Repl1 -res 10 > UCSCbrowsertracks/ATAC_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR5617660 -fragLength given -name ATAC_Repl2 -res 10 > UCSCbrowsertracks/ATAC_Repl2.bedGraph

#H3K27ac
makeUCSCfile TagDirectory/tag_SRR5617663 -fragLength given -name H3K27ac_Repl1 -res 10 > UCSCbrowsertracks/H3K27ac_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR5617664 -fragLength given -name H3K27ac_Repl2 -res 10 > UCSCbrowsertracks/H3K27ac_Repl2.bedGraph

#H3K4me2
makeUCSCfile TagDirectory/tag_SRR5617667 -fragLength given -name H3K4me2_Repl1 -res 10 > UCSCbrowsertracks/H3K4me2_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR5617668 -fragLength given -name H3K4me2_Repl2 -res 10 > UCSCbrowsertracks/H3K4me2_Repl2.bedGraph

#PU1
makeUCSCfile TagDirectory/tag_SRR5617677 -fragLength given -name PU1_Repl1 -res 10 > UCSCbrowsertracks/PU1_Repl1.bedGraph

makeUCSCfile TagDirectory/tag_SRR5617678 -fragLength given -name PU1_Repl2 -res 10 > UCSCbrowsertracks/PU1_Repl2.bedGraph

#pooled input files
makeUCSCfile TagDirectory/Pooltag_Input -fragLength given -name Input_Pool -res 10 > UCSCbrowsertracks/Input_Pool.bedGraph



##########################################################################################
#######################################################################################
#make into ucsc format
#sed -i 's/old-text/new-text/g' input.txt
echo "converting to UCSC format"
#######################################################################################
#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/ATAC_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/ATAC_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/H3K27ac_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/H3K27ac_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/H3K4me2_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/H3K4me2_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/PU1_Repl1.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/PU1_Repl1.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/ATAC_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/ATAC_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/H3K27ac_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/H3K27ac_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/H3K4me2_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/H3K4me2_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/PU1_Repl2.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/PU1_Repl2.bedGraph

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/Input_Pool.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/Input_Pool.bedGraph


#######################################################################################
#######################################################################################
#convert to bigwigs
echo "making bigwigs"
#######################################################################################
#convert to bigwig
#The input bedGraph file must be sort, use the unix sort command:

#replicate 1
sort -k1,1 -k2,2n UCSCbrowsertracks/ATAC_Repl1.bedGraph > UCSCbrowsertracks/ATAC_Repl1.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/ATAC_Repl1.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/ATAC_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/ATAC_Repl1.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/ATAC_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/ATAC_Repl1.bw

#replicate 2
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/ATAC_Repl2.bedGraph > UCSCbrowsertracks/ATAC_Repl2.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/ATAC_Repl2.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/ATAC_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/ATAC_Repl2.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/ATAC_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/ATAC_Repl2.bw

#replicate 1
sort -k1,1 -k2,2n UCSCbrowsertracks/H3K27ac_Repl1.bedGraph > UCSCbrowsertracks/H3K27ac_Repl1.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/H3K27ac_Repl1.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/H3K27ac_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K27ac_Repl1.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/H3K27ac_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K27ac_Repl1.bw

#replicate 2
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/H3K27ac_Repl2.bedGraph > UCSCbrowsertracks/H3K27ac_Repl2.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/H3K27ac_Repl2.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/H3K27ac_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K27ac_Repl2.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/H3K27ac_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K27ac_Repl2.bw

#replicate 1
sort -k1,1 -k2,2n UCSCbrowsertracks/H3K4me2_Repl1.bedGraph > UCSCbrowsertracks/H3K4me2_Repl1.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/H3K4me2_Repl1.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/H3K4me2_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K4me2_Repl1.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/H3K4me2_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K4me2_Repl1.bw

#replicate 2
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/H3K4me2_Repl2.bedGraph > UCSCbrowsertracks/H3K4me2_Repl2.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/H3K4me2_Repl2.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/H3K4me2_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K4me2_Repl2.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/H3K4me2_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/H3K4me2_Repl2.bw

#replicate 1
sort -k1,1 -k2,2n UCSCbrowsertracks/PU1_Repl1.bedGraph > UCSCbrowsertracks/PU1_Repl1.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/PU1_Repl1.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/PU1_Repl1.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/PU1_Repl1.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/PU1_Repl1.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/PU1_Repl1.bw

#replicate 2
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/PU1_Repl2.bedGraph > UCSCbrowsertracks/PU1_Repl2.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/PU1_Repl2.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/PU1_Repl2.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/PU1_Repl2.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/PU1_Repl2.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/PU1_Repl2.bw


#replicate 1
sort -k1,1 -k2,2n UCSCbrowsertracks/Input_Pool.bedGraph > UCSCbrowsertracks/Input_Pool.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/Input_Pool.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/Input_Pool.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/Input_Pool.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/Input_Pool.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/Input_Pool.bw



#zip bedgraphs
gzip UCSCbrowsertracks/*.bedGraph

echo "complete"
