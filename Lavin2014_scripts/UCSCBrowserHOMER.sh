#!/bin/bash
#
#SBATCH -c 12
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=UCSC2
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
# H3K27ac
#######################################################################################

#make normalized bedgraphs:

makeUCSCfile TagDirectory/tag_SRR1653785 -fragLength given -name H3K27ac_1 -res 10 > UCSCbrowsertracks/H3K27ac_1.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653786 -fragLength given -name H3K27ac_2 -res 10 > UCSCbrowsertracks/H3K27ac_2.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653787 -fragLength given -name H3K27ac_3 -res 10 > UCSCbrowsertracks/H3K27ac_3.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653790 -fragLength given -name H3K27ac_4 -res 10 > UCSCbrowsertracks/H3K27ac_4.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653791 -fragLength given -name H3K27ac_5 -res 10 > UCSCbrowsertracks/H3K27ac_5.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653792 -fragLength given -name H3K27ac_6 -res 10 > UCSCbrowsertracks/H3K27ac_6.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653782 -fragLength given -name H3K4me1_1 -res 10 > UCSCbrowsertracks/H3K4me1_1.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653783 -fragLength given -name H3K4me1_2 -res 10 > UCSCbrowsertracks/H3K4me1_2.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653784 -fragLength given -name H3K4me1_3 -res 10 > UCSCbrowsertracks/H3K4me1_3.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653788 -fragLength given -name H3K4me1_4 -res 10 > UCSCbrowsertracks/H3K4me1_4.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653789 -fragLength given -name H3K4me1_5 -res 10 > UCSCbrowsertracks/H3K4me1_5.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653793 -fragLength given -name H3K4me2_1 -res 10 > UCSCbrowsertracks/H3K4me2_1.bedGraph
makeUCSCfile TagDirectory/tag_SRR1653794 -fragLength given -name H3K4me2_2 -res 10 > UCSCbrowsertracks/H3K4me2_2.bedGraph
makeUCSCfile TagDirectory/tag_SRR1699284 -fragLength given -name Input_1 -res 10 > UCSCbrowsertracks/Input.bedGraph

#######################################################################################
#pooled tag directories

makeUCSCfile TagDirectory/PPooltag_H3K27ac -fragLength given -name Pooltag_H3K27ac -res 10 > UCSCbrowsertracks/Pooltag_H3K27ac.bedGraph

makeUCSCfile TagDirectory/Pooltag_H3K4me1 -fragLength given -name Pooltag_H3K4me1 -res 10 > UCSCbrowsertracks/Pooltag_H3K4me1.bedGraph

makeUCSCfile TagDirectory/Pooltag_H3K4me2 -fragLength given -name Pooltag_H3K4me2 -res 10 > UCSCbrowsertracks/Pooltag_H3K4me2.bedGraph

makeUCSCfile TagDirectory/Pooltag_Input -fragLength given -name Pooltag_Input -res 10 > UCSCbrowsertracks/Pooltag_Input.bedGraph



#########################################################################################
#######################################################################################
#make into ucsc format
#sed -i 's/old-text/new-text/g' input.txt
#make new file name text file: BedGraphNames.txt
echo "converting to UCSC format"
#######################################################################################


for sample in `cat BedGraphNames.txt`
do

echo ${sample} "starting name fix"

#skip the first line, then add "chr" to each chromosome
sed -i "1n; s/^/chr/" UCSCbrowsertracks/${sample}.bedGraph
sed -i "1n; s/MT/M/g" UCSCbrowsertracks/${sample}.bedGraph

#convert to bigwigs
echo "making bigwig"

#convert to bigwig
#The input bedGraph file must be sort, use the unix sort command:
sort -k1,1 -k2,2n UCSCbrowsertracks/${sample}.bedGraph > UCSCbrowsertracks/${sample}.sort.bedGraph

#remove track line (now at the end of sort files)
sed -i '$d' UCSCbrowsertracks/${sample}.sort.bedGraph

#fix extensions beyond chromosomes > removes entry
#bedClip [options] input.bed chrom.sizes output.bed
bedClip UCSCbrowsertracks/${sample}.sort.bedGraph $mm10chrsizes UCSCbrowsertracks/${sample}.sort2.bedGraph

#bedGraphToBigWig in.bedGraph chrom.sizes out.bw
bedGraphToBigWig UCSCbrowsertracks/${sample}.sort2.bedGraph $mm10chrsizes UCSCbrowsertracks/${sample}.bw

rm UCSCbrowsertracks/${sample}.sort.bedGraph
rm UCSCbrowsertracks/${sample}.bedGraph

echo ${sample} "finished"


done


#zip bedgraphs
gzip UCSCbrowsertracks/*.bedGraph

echo "complete"
