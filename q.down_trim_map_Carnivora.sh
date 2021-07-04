#/bin/sh

#-- Auburn University High Performance and Parallel Computing
#-- Hopper Cluster Sample Job Submission Script

#-- This script provides the basic scheduler directives you
#-- can use to submit a job to the Hopper scheduler.
#-- Other than the last two lines it can be used as-is to
#-- send a single node job to the cluster. Normally, you
#-- will want to modify the #PBS directives below to reflect
#-- your workflow...

####-- For convenience, give your job a name

#PBS -N IGFs_metatheria

#-- Provide an estimated wall time in which to run your job
#-- The format is DD:HH:MM:SS.  


#PBS -l walltime=00:12:00:00 

#-- Indicate if\when you want to receive email about your job
#-- The directive below sends email if the job is (a) aborted, 
#-- when it (b) begins, and when it (e) ends

#PBS -m abe tss0019@auburn.edu

#-- Inidicate the working directory path to be used for the job.
#-- If the -d option is not specified, the default working directory 
#-- is the home directory. Here, we set the working directory
#-- current directory

#PBS -d /home/tss0019/IGFs_CrossSpecies
#-- We recommend passing your environment variables down to the
#-- compute nodes with -V, but this is optional

#PBS -V

#-- Specify the number of nodes and cores you want to use
#-- Hopper's standard compute nodes have a total of 20 cores each
#-- so, to use all the processors on a single machine, set your
#-- ppn (processors per node) to 20.

#PBS -l nodes=1:ppn=20

#-- Now issue the commands that you want to run on the compute nodes.
#-- With the -V option, you can load any software modules
#-- either before submitting, or in the job submission script.

#-- You should modify the lines below to reflect your own
#-- workflow...

#module load <myprogram_modulefile>
module load sratoolkit/2.8.0
module load fastqc/11.5
module load trimmomatic/0.37
module load samtools/1.3.1
module load gcc/5.1.0
module load bwa/0.7.15
module load bowtie2/2.2.9
module load tophat/2.1.1
module load hisat/2.0.5
module load stringtie/1.3.2d
module load gnu_parallel/201612222



#./myprogram <parameters>

#--  After saving this script, you can submit your job to the queue
#--  with...

#--  qsub sample_job.sh
##########################################


#PBS -j oe
#PBS -q debug


#  Set the stack size to unlimited
ulimit -s unlimited

# Turn echo on so all commands are echoed in the output log
set -x

#  Define the GROUP and the name of the reference sequences file
GROUP=Carnivora
REF=Carnivora_Reference

# Make the Group directory in Scratch 
mkdir /scratch/tss0019/IGFs_CrossSpecies/$GROUP

#Copy the reference file to the group directory in scratch
cp $REF.fasta /scratch/tss0019/IGFs_CrossSpecies/$GROUP/$REF.fasta

# Move to the group directory in Scratch
cd /scratch/tss0019/IGFs_CrossSpecies/new_Oct2020/$GROUP

#### Download the Run files from NCBI SRA
	#from SRA use the SRA tool kit - see NCBI
	# this downloads the SRA file and converts to fastq
	# -F 	Defline contains only original sequence name.
	# -I 	Append read id after spot id as 'accession.spot.readid' on defline.
	# splits the files into R1 and R2, 

fastq-dump -F --split-files SRR2308103
fastq-dump -F --split-files SRR11301091
fastq-dump -F --split-files SRR11301092
fastq-dump -F --split-files SRR11301095
fastq-dump -F --split-files SRR5889315
fastq-dump -F --split-files SRR5889322
fastq-dump -F --split-files SRR5889330
fastq-dump -F --split-files SRR5889334
fastq-dump -F --split-files ERR1331678
fastq-dump -F --split-files ERR1331679
fastq-dump -F --split-files ERR3417928
fastq-dump -F --split-files ERR3417934
fastq-dump -F --split-files SRR6131252
fastq-dump -F --split-files SRR6131259
fastq-dump -F --split-files SRR6131270
fastq-dump -F --split-files SRR6131275


##################  Now for the Cleaning and Mapping ################################
#### Create list of names (see above for description) and put into file called list. 
## example file SRR629667_1.fastq
rm list
ls | grep ".fastq" |cut -d "_" -f 1 | sort | uniq > list

### Do a while loop to process through the names in the list and clean them with Trimmomatic
while read i
do
	##### Trimmomatic. Quality of 20, Minimum length of 36 bp
java -jar /tools/trimmomatic-0.37/bin/trimmomatic.jar PE  -phred33 "$i"_1.fastq "$i"_2.fastq "$i"_1_paired.fastq "$i"_1_unpaired.fastq "$i"_2_paired.fastq "$i"_2_unpaired.fastq LEADING:20 TRAILING:20 SLIDINGWINDOW:6:20 MINLEN:36 

done<list

### Indexing reference library for BWA mapping:
        # -p is the prefix
        #-a is the algorithm (is) then the input file
bwa index -p $REF  -a is $REF.fasta

#### Create list of names for mapping and put into file called list. 
    ls | grep "paired.fastq" |cut -d "_" -f 1 | sort | uniq > list


###### Mapping, Sorting, and Counting ######
###	Do a while loop to process through the names in the list. First Map with BWA, then sort the BAM with Samtools, then count reads mapped with Samtools
	
while read i
do
	##  Map paired files with BWA to the indexed reference 
	## Example
		#bwa mem ref.fa read1.fq read2.fq > aln-pe.sam
		# -t is the number of threads
bwa mem -t 12 -M $REF "$i"_1_paired.fastq "$i"_2_paired.fastq > "$i".sam 
	## convert .sam to .bam and sort the alignments
	 # -@ is the number of threads
samtools view -@ 8 -bS "$i".sam  | samtools sort -@ 8 -o  "$i"_sorted.bam   # Example Input: HS06_GATCAG_All.sam; Output: HS06_GATCAG_sorted.bam
	## index the sorted .bam
samtools index 	"$i"_sorted.bam
	#  Tally counts of reads mapped to each transcript; and calcuate the stats. 
samtools idxstats   "$i"_sorted.bam     > 	"$i"_Counts.txt
samtools flagstat   "$i"_sorted.bam 	>	"$i"_Stats.txt

#Remove unmapped reads, keep the mapped reads:
samtools view -F 0x04 -b "$i"_sorted.bam > "$i"_sorted_mapOnly.bam
done<list


###  Make a directory for the counts files for this group
mkdir /scratch/tss0019/IGFs_CrossSpecies/counts/$GROUP
	# Move a copy of the counts file to that directory
cp *Counts.txt /scratch/tss0019/IGFs_CrossSpecies/counts/$GROUP/


