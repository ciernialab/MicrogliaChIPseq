#!/bin/bash
#
#SBATCH -c 12
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=UCSC2
#SBATCH --output=HOMERUCSC2.out
#SBATCH --time=24:00:00

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

makeUCSCfile TagDirectory/tag_SRR3621170 -fragLength given -name APP23_H3K27ac_1xLPS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_1xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621171 -fragLength given -name APP23_H3K27ac_1xLPS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_1xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621172 -fragLength given -name APP23_H3K27ac_4xLPS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_4xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621173 -fragLength given -name APP23_H3K27ac_4xLPS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_4xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621168 -fragLength given -name APP23_H3K27ac_PBS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_PBSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621169 -fragLength given -name APP23_H3K27ac_PBS -res 10 > UCSCbrowsertracks/APP23_H3K27ac_PBSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621164 -fragLength given -name WT_H3K27ac_1xLPS -res 10 > UCSCbrowsertracks/WT_H3K27ac_1xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621165 -fragLength given -name WT_H3K27ac_1xLPS -res 10 > UCSCbrowsertracks/WT_H3K27ac_1xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621166 -fragLength given -name WT_H3K27ac_4xLPS -res 10 > UCSCbrowsertracks/WT_H3K27ac_4xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621167 -fragLength given -name WT_H3K27ac_4xLPS -res 10 > UCSCbrowsertracks/WT_H3K27ac_4xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621162 -fragLength given -name WT_H3K27ac_PBS -res 10 > UCSCbrowsertracks/WT_H3K27ac_PBSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621163 -fragLength given -name WT_H3K27ac_PBS -res 10 > UCSCbrowsertracks/WT_H3K27ac_PBSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621159 -fragLength given -name APP23_H3K4me1_1xLPS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621158 -fragLength given -name APP23_H3K4me1_1xLPS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_1xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621160 -fragLength given -name APP23_H3K4me1_4xLPS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621161 -fragLength given -name APP23_H3K4me1_4xLPS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_4xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621156 -fragLength given -name APP23_H3K4me1_PBS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_PBSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621157 -fragLength given -name APP23_H3K4me1_PBS -res 10 > UCSCbrowsertracks/APP23_H3K4me1_PBSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621152 -fragLength given -name WT_H3K4me1_1xLPS -res 10 > UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621153 -fragLength given -name WT_H3K4me1_1xLPS -res 10 > UCSCbrowsertracks/WT_H3K4me1_1xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621155 -fragLength given -name WT_H3K4me1_4xLPS -res 10 > UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621154 -fragLength given -name WT_H3K4me1_4xLPS -res 10 > UCSCbrowsertracks/WT_H3K4me1_4xLPSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621150 -fragLength given -name WT_H3K4me1_PBS -res 10 > UCSCbrowsertracks/WT_H3K4me1_PBSrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621151 -fragLength given -name WT_H3K4me1_PBS -res 10 > UCSCbrowsertracks/WT_H3K4me1_PBSrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621148 -fragLength given -name APP23_input_mixed -res 10 > UCSCbrowsertracks/APP23_input_mixedrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621149 -fragLength given -name APP23_input_mixed -res 10 > UCSCbrowsertracks/APP23_input_mixedrepl2.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621146 -fragLength given -name WT_input_mixed -res 10 > UCSCbrowsertracks/WT_input_mixedrepl1.bedGraph
makeUCSCfile TagDirectory/tag_SRR3621147 -fragLength given -name WT_input_mixed -res 10 > UCSCbrowsertracks/WT_input_mixedrepl2.bedGraph
#######################################################################################
#pooled tag directories

makeUCSCfile TagDirectory/Pooltag_H3K27ac_APP23_1xLPS -fragLength given -name H3K27ac_APP23_1xLPS -res 10 > UCSCbrowsertracks/H3K27ac_APP23_1xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K27ac_APP23_4xLPS -fragLength given -name H3K27ac_APP23_4xLPS -res 10 > UCSCbrowsertracks/H3K27ac_APP23_4xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K27ac_APP23_PBS -fragLength given -name H3K27ac_APP23_PBS -res 10 > UCSCbrowsertracks/H3K27ac_APP23_PBS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K27ac_WT_1xLPS -fragLength given -name H3K27ac_WT_1xLPS -res 10 > UCSCbrowsertracks/H3K27ac_WT_1xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K27ac_WT_4xLPS -fragLength given -name H3K27ac_WT_4xLPS -res 10 > UCSCbrowsertracks/H3K27ac_WT_4xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K27ac_WT_PBS -fragLength given -name H3K27ac_WT_PBS -res 10 > UCSCbrowsertracks/H3K27ac_WT_PBS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_APP23_1xLPS -fragLength given -name H3K4me1_APP23_1xLPS -res 10 > UCSCbrowsertracks/H3K4me1_APP23_1xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_APP23_4xLPS -fragLength given -name H3K4me1_APP23_4xLPS -res 10 > UCSCbrowsertracks/H3K4me1_APP23_4xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_APP23_PBS -fragLength given -name H3K4me1_APP23_PBS -res 10 > UCSCbrowsertracks/H3K4me1_APP23_PBS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_WT_1xLPS -fragLength given -name H3K4me1_WT_1xLPS -res 10 > UCSCbrowsertracks/H3K4me1_WT_1xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_WT_4xLPS -fragLength given -name H3K4me1_WT_4xLPS -res 10 > UCSCbrowsertracks/H3K4me1_WT_4xLPS.bedGraph
makeUCSCfile TagDirectory/Pooltag_H3K4me1_WT_PBS -fragLength given -name H3K4me1_WT_PBS -res 10 > UCSCbrowsertracks/H3K4me1_WT_PBS.bedGraph
makeUCSCfile TagDirectory/Pooltag_Input_APP23 -fragLength given -name Input_APP23 -res 10 > UCSCbrowsertracks/Input_APP23.bedGraph
makeUCSCfile TagDirectory/Pooltag_Input_WT -fragLength given -name Input_WT -res 10 > UCSCbrowsertracks/Input_WT.bedGraph

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
