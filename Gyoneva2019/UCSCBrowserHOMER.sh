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
# H3K27ac
#######################################################################################

#make normalized bedgraphs:

makeUCSCfile TagDirectory/tag_SRR9034494 -fragLength given -name Cx3cr1KO_H3k27ac_F -res 10 > UCSCbrowsertracks/Cx3cr1KO_H3k27ac_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034495 -fragLength given -name Cx3cr1KO_H3k27ac_M -res 10 > UCSCbrowsertracks/Cx3cr1KO_H3k27ac_M.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034496 -fragLength given -name Cx3cr1KO_Input_F -res 10 > UCSCbrowsertracks/Cx3cr1KO_Input_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034497 -fragLength given -name Cx3cr1KO_Input_M -res 10 > UCSCbrowsertracks/Cx3cr1KO_Input_M.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034498 -fragLength given -name Cx3cr1KO_Rpb2_F -res 10 > UCSCbrowsertracks/Cx3cr1KO_Rpb2_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034499 -fragLength given -name Cx3cr1KO_Rpb2_M -res 10 > UCSCbrowsertracks/Cx3cr1KO_Rpb2_M.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034500 -fragLength given -name WT_H3k27ac_F -res 10 > UCSCbrowsertracks/WT_H3k27ac_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034501 -fragLength given -name WT_H3k27ac_M -res 10 > UCSCbrowsertracks/WT_H3k27ac_M.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034502 -fragLength given -name WT_Input_F -res 10 > UCSCbrowsertracks/WT_Input_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034503 -fragLength given -name WT_Input_M -res 10 > UCSCbrowsertracks/WT_Input_M.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034504 -fragLength given -name WT_Rpb2_F -res 10 > UCSCbrowsertracks/WT_Rpb2_F.bedGraph
makeUCSCfile TagDirectory/tag_SRR9034505 -fragLength given -name WT_Rpb2_M -res 10 > UCSCbrowsertracks/WT_Rpb2_M.bedGraph


#######################################################################################
#pooled tag directories

makeUCSCfile TagDirectory/Pooltag_H3K27ac_Cx3cr1KO -fragLength given -name Pooltag_H3K27ac_Cx3cr1KO -res 10 > UCSCbrowsertracks/Pooltag_H3K27ac_Cx3cr1KO.bedGraph

makeUCSCfile TagDirectory/Pooltag_H3K27ac_Cx3cr1WT -fragLength given -name Pooltag_H3K27ac_Cx3cr1WT -res 10 > UCSCbrowsertracks/Pooltag_H3K27ac_Cx3cr1WT.bedGraph

makeUCSCfile TagDirectory/Pooltag_Rpb2_Cx3cr1KO -fragLength given -name Pooltag_Rpb2_Cx3cr1KO -res 10 > UCSCbrowsertracks/Pooltag_Rpb2_Cx3cr1KO.bedGraph

makeUCSCfile TagDirectory/Pooltag_Rpb2_Cx3cr1WT -fragLength given -name Pooltag_Rpb2_Cx3cr1WT -res 10 > UCSCbrowsertracks/Pooltag_Rpb2_Cx3cr1WT.bedGraph

makeUCSCfile TagDirectory/Pooltag_Input_Cx3cr1KO -fragLength given -name Pooltag_Input_Cx3cr1KO -res 10 > UCSCbrowsertracks/Pooltag_Input_Cx3cr1KO.bedGraph

makeUCSCfile TagDirectory/Pooltag_Input_Cx3cr1WT -fragLength given -name Pooltag_Input_Cx3cr1WT -res 10 > UCSCbrowsertracks/Pooltag_Input_Cx3cr1WT.bedGraph




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
