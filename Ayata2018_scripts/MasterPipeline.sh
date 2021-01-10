#!/bin/bash
#
#SBATCH -c 20
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=Master
#SBATCH --output=Master.out
#SBATCH --time=48:00:00


#SRA pull from list
#######################################################################################
# run from in data directory
#puts data in shared data file for the experiment
#######################################################################################
mkdir -p SRA/
mkdir -p output/SRA_checksum

for sample in `cat SRR_Acc_List.txt`
do

cd SRA/

echo ${sample} "starting SRR pull"
prefetch ${sample}

#######################################################################################
#paired end sra > Fastq.gz
#######################################################################################
echo ${sample} "starting dump"

#paired end
#fastq-dump --origfmt --split-files --gzip ${sample}

#single end
fastq-dump --origfmt --gzip ${sample}

echo ${sample} "done"

cd ..

#######################################################################################
#validate each SRA file and save to output log
#https://reneshbedre.github.io/blog/fqutil.html
#######################################################################################

echo ${sample} "starting sra check"

vdb-validate SRA/${sample} 2> output/SRA_checksum/${sample}_SRAcheck.log

echo ${sample} "done"

done

#combine logs into one output file
cat output/SRA_checksum/*_SRAcheck.log > output/SRA_checksum/SRAcheck.log

#######################################################################################
##Trimmomatic for SE
#trim adapters (TruSeq3-SE.fa)

mkdir trimmed
mkdir -p output/trimlogs

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting trim"

#PE trimming for adapters and quality
java -jar $TRIMMOMATIC/trimmomatic-0.39.jar SE SRA/${sample}.fastq.gz trimmed/${sample}.trim.fastq.gz ILLUMINACLIP:$ADAPTERS/TruSeq2-SE.fa:2:30:10:8:T LEADING:3 TRAILING:3 MINLEN:15 &> output/trimlogs/trim_log_${sample}

	#trimmomatic will look for seed matches of 16 bases with 2 mismatches allowed
	#will then extend and clip if a score of 30 for PE or 10 for SE is reached (~17 base match)
	#minimum adapter length is 8 bases
	#T = keeps both reads even if only one passes criteria
	#trims low quality bases at leading and trailing end if quality score < 15
	#sliding window: scans in a 4 base window, cuts when the average quality drops below 15
	#log outputs number of input reads, trimmed, and surviving

echo ${sample} "finished trim"


done

#multiqc
multiqc output/trimlogs/ --filename output/trimlogs_multiqc_report.html --ignore-samples Undetermined* --interactive

#######################################################################################
#fastqc and then combine reports into one html and save to outputs folder
#######################################################################################
mkdir -p output/pretrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting"

fastqc SRA/${sample}.fastq.gz --outdir output/pretrim

echo ${sample} "finished"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/pretrim --filename output/PretrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive


#######################################################################################
#######################################################################################

#######################################################################################
#post trim QC
#######################################################################################
mkdir -p output/posttrim

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastqc"

fastqc trimmed/${sample}.trim.fastq.gz --outdir output/posttrim

echo ${sample} "finished fastqc"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/posttrim --filename output/PosttrimFastQC_multiqc_report.html --ignore-samples Undetermined* --interactive


#######################################################################################
#fastq screen: http://www.bioinformatics.babraham.ac.uk/projects/fastq_screen/_build/html/index.html


#######################################################################################
mkdir -p output/fastq_screen

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting fastq screen"

fastq_screen --aligner bowtie2 trimmed/${sample}.trim.fastq.gz --outdir output/fastq_screen


echo ${sample} "finished fastq screen"


done


#######################################################################################
#combine
#######################################################################################

multiqc output/fastq_screen --filename output/FastqScreen_multiqc_report.html --ignore-samples Undetermined* --interactive


###############################################################################
#bowtie2 alignment to mm10
#######################################################################################
mkdir aligned
mkdir -p output/bowtielogs


for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting alignment"

#align trimmed reads using bowtie2
# --no-unal          suppress SAM records for unaligned reads
$BT2_HOME/bowtie2 -x $BT2_MM10/genome -U trimmed/${sample}.trim.fastq.gz -S aligned/${sample}.sam -p 20 --no-unal --time 2> output/bowtielogs/${sample}_bowtie2log.log  

echo ${sample} "finished alignment"


done


#######################################################################################
#combine
#######################################################################################
multiqc output/bowtielogs --filename output/bowtie2_multiqc_report.html --ignore-samples Undetermined* --interactive

#######################################################################################
#sort with samtools and filter
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121 #this loads Java 1.8 working environment
module load R/3.6.1 #picard needs this

mkdir -p output/sam/

for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting filtering"

#properly mapped and paired reads:

#pipe samtools: https://www.biostars.org/p/43677/

#flags:
# 0x1 template having multiple segments in sequencing
# 0x2 each segment properly aligned according to the aligner
# 0x4 segment unmapped
# 0x8 next segment in the template unmapped
# 0x10 SEQ being reverse complemented
# 0x20 SEQ of the next segment in the template being reversed
# 0x40 the ﬁrst segment in the template
# 0x80 the last segment in the template
# 0x100 secondary alignment
# 0x200 not passing quality controls
#0x400 PCR or optical duplicate

echo ${sample} "converting sam to bam"

#convert sam to bam and name sort for fixmate
#-@ 16 sets to 16 threads
samtools view -bS aligned/${sample}.sam | samtools sort -n -@ 16 - -o aligned/${sample}_tmp.bam

echo ${sample} "removing unmapped reads"

#Remove unmapped reads and secondary alignments from name sorted input
#samtools view -bS test.sam | samtools sort -n -@ 16 -o test_tmp.bam
samtools fixmate -r aligned/${sample}_tmp.bam aligned/${sample}_tmp2.bam


echo ${sample} "removing PCR duplicates"
#coordinate sort, then filter:
#remove PCR duplicates:https://www.biostars.org/p/318974/
# -F INT   only include reads with none of the bits set in INT set in FLAG [0]
#so include none of 0x400

#samtools sort -@ 16 test_tmp2.bam |samtools view -b -F 0x400 -@ 16 - -o test_dedup.bam 
samtools sort -@ 16 aligned/${sample}_tmp2.bam |samtools view -b -F 0x400 -@ 16 - -o aligned/${sample}_dedup.bam 

echo ${sample} "index"

#index
samtools index aligned/${sample}_dedup.bam 

echo ${sample} "QC metrics"

#fix mate information
#java -jar $PICARD FixMateInformation I=aligned/${sample}_dedup.bam O=output/sam/${sample}_fixmate.txt

#flagstat
samtools flagstat aligned/${sample}_dedup.bam > output/sam/${sample}_dedupFlagstat.txt


rm aligned/${sample}_tmp.bam
rm aligned/${sample}_tmp2.bam

echo ${sample} "finished filtering"


done

#######################################################################################
#combine
#######################################################################################
multiqc output/sam --filename output/sam_multiqc_report.html --ignore-samples Undetermined* --interactive


#######################################################################################
#HOMER make tag directories and call peaks with HOMER
#http://homer.ucsd.edu/homer/ngs/tagDir.html
#one tag directory per sample

#######################################################################################
#make for individual samples
#######################################################################################
module load samtools/1.4
module load jre/1.8.0_121

mkdir TagDirectory/

#CHIP
for sample in `cat SRR_Acc_List.txt`
do

echo ${sample} "starting filtering"

#######################################################################################
#make tag directories for each bam file

makeTagDirectory TagDirectory/tag_${sample} aligned/${sample}_dedup.bam 


##########################################################################################

echo ${sample} "finished filtering"


done



#######################################################################################
#make for pool of all samples


#######################################################################################
#All brain regions H3K27me3
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_H3K27me3_allregions aligned/SRR6396997_dedup.bam aligned/SRR6396999_dedup.bam aligned/SRR7263599_dedup.bam

#######################################################################################
#all regions input
#######################################################################################

makeTagDirectory TagDirectory/Pooltag_Input aligned/SRR6396998_dedup.bam aligned/SRR6397000_dedup.bam aligned/SRR7263600_dedup.bam


#######################################################################################
#######################################################################################
#http://homer.ucsd.edu/homer/ngs/peaksReplicates.html
#http://homer.ucsd.edu/homer/ngs/peaks.html
#######################################################################################
#peak calling based on Gosselin et al 2017 ATACseq
#########################################


mkdir homer_peaks


#Peaks were then called on the pooled tags using
#HOMER’s “findPeaks” command with the following parameters: “-style factor -size 200 -
#minDist 200” where the “-tbp” parameter was set to the number of replicates in the pool.

#findPeaks -style factor -size 200 -minDist 200 -tbp 4


#H3K27me3 all regions:
findPeaks TagDirectory/Pooltag_H3K27me3_allregions -style histone -size 500 -minDist 1000 -region -tbp 3 -i TagDirectory/Pooltag_Input -o homer_peaks/Homerpeaks_Pooltag_H3K27me3_allregions.txt



#H3K27me3 individual regions (no replicates):
findPeaks TagDirectory/tag_SRR6396997 -style histone -size 500 -minDist 1000 -region -tbp 1 -i TagDirectory/tag_SRR6396998 -o homer_peaks/Homerpeaks_SRR6396997.cbMG_H3K27me3.txt

findPeaks TagDirectory/tag_SRR6396999 -style histone -size 500 -minDist 1000 -region -tbp 1 -i TagDirectory/tag_SRR6397000 -o homer_peaks/Homerpeaks_SRR6396999.StrMG_H3K27me3.txt

findPeaks TagDirectory/tag_SRR7263599 -style histone -size 500 -minDist 1000 -region -tbp 1 -i TagDirectory/tag_SRR7263600 -o homer_peaks/Homerpeaks_SRR7263599.cxMg_H3K27me3.txt


#######################################################################################
#######################################################################################
#convert to bed
#using modified pos2bedmod.pl that keeps peak information
#######################################################################################
#######################################################################################


grep -v '^#' homer_peaks/Homerpeaks_Pooltag_H3K27me3_allregions.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Pooltag_H3K27me3_allregions.bed
   
    rm homer_peaks/tmp*


grep -v '^#' homer_peaks/Homerpeaks_SRR6396997.cbMG_H3K27me3.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_cbMG_H3K27me3.bed
   
    rm homer_peaks/tmp*


grep -v '^#' homer_peaks/Homerpeaks_SRR6396999.StrMG_H3K27me3.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_StrMG_H3K27me3.bed
   
    rm homer_peaks/tmp*


grep -v '^#' homer_peaks/Homerpeaks_SRR7263599.cxMg_H3K27me3.txt > homer_peaks/tmp.txt
   
    perl pos2bedmod.pl homer_peaks/tmp.txt > homer_peaks/tmp.bed
   
    sed 's/^/chr/' homer_peaks/tmp.bed > homer_peaks/Homerpeaks_cxMg_H3K27me3.bed
   
    rm homer_peaks/tmp*

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

makeUCSCfile TagDirectory/tag_SRR6396997 -fragLength given -name cbMG_H3K27me3 -res 10 > UCSCbrowsertracks/cbMG_H3K27me3.bedGraph
makeUCSCfile TagDirectory/tag_SRR6396998 -fragLength given -name cbMG_Input -res 10 > UCSCbrowsertracks/cbMG_Input.bedGraph
makeUCSCfile TagDirectory/tag_SRR6396999 -fragLength given -name StrMG_H3K27me3 -res 10 > UCSCbrowsertracks/StrMG_H3K27me3.bedGraph
makeUCSCfile TagDirectory/tag_SRR6397000 -fragLength given -name StrMG_Input -res 10 > UCSCbrowsertracks/StrMG_Input.bedGraph
makeUCSCfile TagDirectory/tag_SRR7263599 -fragLength given -name cxMg_H3K27me3_ChIP -res 10 > UCSCbrowsertracks/cxMg_H3K27me3.bedGraph
makeUCSCfile TagDirectory/tag_SRR7263600 -fragLength given -name cxMg_Input -res 10 > UCSCbrowsertracks/cxMg_Input.bedGraph


#######################################################################################
#pooled tag directories

makeUCSCfile TagDirectory/Pooltag_H3K27me3_allregions -fragLength given -name Pooltag_H3K27me3_allregions -res 10 > UCSCbrowsertracks/Pooltag_H3K27me3_allregions.bedGraph

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


