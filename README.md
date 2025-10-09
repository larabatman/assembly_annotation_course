# Genome and Transcriptome Assembly

In this course, we aim to de novo assemble the genome of an Arabidopsis thaliana accession Istisu-1, as well as the transcriptome of another accession, Sha. 

Published data is openly accessible at https://www.nature.com/articles/s41588-024-01715-9 and https://www.nature.com/articles/s41467-020-14779-y. 

## Datasets 

For genomic data: whole genome PacBio HiFi long reads
For transcriptomic data: whole transcriptome Illumina paired-end short reads

## Table of Content

0. [Quality Control](#quality-control-of-long-and-short-reads)
1. [Estimated genome length, coverage and heterozygosity](#estimated-genome-length-coverage-heterozygosity)
2. [Genome and Transcriptome Assembly](#genome-and-transcriptome-assembly)
3. [Genome Assembly Evaluation](#genome-assembly-evaluation)
4. [Genome Comparison](#genome-comparison)

## Quality Control of long and short reads

The first step is to control the quality of the genome and transcriptome sequence reads using fastqc tool. 

Run script 01_run_fastqc.sh

The read lengths for the genomic PacBio dataset ranges from 98 (shortest) to 49665 (longest) pb, while the sequence length for the transcriptomic Illumina dataset is 101 bp for both R1 and R2. 
In all datasets, there seems to be adapter contamination. Regarding the transcriptomic dataset, there additionally appears to be lacking per base quality as well as over-represented reads. The latter is to be expected in transcriptomic analysis. 
Nonetheless, the quality of the transcriptomic datasets could be improved by dismissing low quality reads and adapter contaminants. 

To improve the quality of the datasets, we are further going to use the preprocessing tool fastp, which is able to handle both short and long reads. 

Run script 02a_run_fastp_transcriptomic.sh

Before filtering, total reads in the transcriptomic datasets were 45.241360 Mb. After filtering, 40.704842 M reads remain, representing 89.972631% of total reads; most discarded reads were of low quality (10.026834%). 

Run script 02b_run_fastp_genomic.sh

The total number of bases on the PacBio WGS data is of 5.993795 Gb, which approximates to 5.99 x 10^9 sequenced bases.
The haploid genome size of A. thaliana is approximately 135 Mb (https://plants.ensembl.org/Arabidopsis_thaliana/Info/Index#:~:text=Arabidopsis%20thaliana%20has%20a%20genome,haploid%20chromosome%20number%20of%20five.). Since coverage is defined as Coverage = Total Bases Sequenced / Genome Size, we can assume that the expected coverage is around 44.4X for the PacBio dataset. 

## Estimated genome length, coverage and heterozygosity

To further validate the quality of the sequencing data, coverage depth, error rate, heterozygosity and genome size consistency can be assessed using k-mer analysis. 
To that end, we use jellyfish to count canonical k-mers (k = 21) and use the kmer counts to build an histogram using the model-fittig GenomeScope tool. 

Run script 03_kmer_count.sh

The outputed reads.histo file can then be uploaded to GenomeScope http://genomescope.org/genomescope2.0/ to interpret the k-mer spectrum: http://genomescope.org/genomescope2.0/analysis.php?code=owAfXbMQJA8oLr6II18J. 
The estimated genome size from the k-mer histogram appears to be between 134,298,918 bp (min) and 134,403,675 bp (max), roughly 134.3-134.4 Mb. This suggests that the dataset is properly sequenced and covers the genome evenly, since it is very close to the referenced A. thaliana length of 135 Mb. 
Interestingly, the 44x coverage expectation from fastp does not match the peak fitted by GenomeScope, that appears rather around 38-39x. This is likely due to very short reads and low-quality k-mers reported earlier, as well as error k-mers that inflate the denominator in the previous fastp calculation. 

## Genome and Transcriptome assembly

After k-mer counting, four different assembly tools are used: flye, hifiasm and LJA for genomic assembly of the Istisu-1 PacBio HiFi long reads, and Trinity for transcriptomic assembly of Sha Illumina short reads. 

Flye is a straightforward tool that contains a complete pipeline from raw reads to polished contigs. Here, the only notable option use is --pacbio that specifies the type of genomic data sequences. 

Hifiasm, while also handling PacBio reads, allows for haplotype-resolved assemblies which could be of interest four our somewhat heterozygous line. Here, we primarly focused on getting a primary assembly. This tool outputs a .gfa graph file, which needs to be converted to a .fa file using a simple awk command. 

LJA is a powerful assembly tool based on De Brujin graphs, consisting of three modules and a polisher that allow exploration of different DBGs at different k-mer lengths. 

Finally, Trinity allows for de novo transcriptomic assembly by constructing De Brujin graphs per genes. 

Run scripts 04_a_runflye.sh, 04b_run_hifiasm.sh, 04c_run_LJA.sh and 04d_run_trinity.sh

## Genome Assembly Evaluation

To assess the quality of our assemblies, BUSCO, QUAST and Merqury analysis are performed. 

BUSCO estimates the completeness and redundancy based on universal single-copy orthologs. Here, we are using the brassicales lineage against our accession. Completeness percentages, as single copy or duplicated scores, fragmentation and missing matches are reported into short.summary.txt files for each assembly, that can  thenbe plotted using the provided R script. Transcriptome assemblies can also be assessed using this tool. 

Run 05a_BUSCO_genome.sh and 05b_BUSCO_transcriptome.sh to perform the assessment, and 05d_busco_plot.R to build the barplots.

QUAST works both with and without reference, and gives completness and correctness measured when references are provided. Here, the Arabidopsis thaliana TAIR10 line is used as reference. It directly reports metrics on multiple assemblies. 

Run06a_run_QUAST_noref.sh and 06b_run_QUAST_ref.sh

Finally, Mequry is a reference-free assembly that performs k-mers analysis on the assembly by comparing it to the unassembled reads. It reports a consensus quality score QV on the Phred scale and the error rate, as well as copy-number plots. 

Run 07a_run_merqury.sh

## Genome Comparison

Additionally, it is possible to perform pairwise genome comparisons on our assemblies, as well as genome comparison of each against the reference. In that end, we are using MUMmer and NUCmer genome alignemnet and comparison tools. MUMmer identifies MUMs (Maximal Unique Matches) between two or more DNA sequences and allows for visualization of their similarities and differences. 
NUSmer is MUMmer's main aligment module, which is optimized for nucleotide-level comparisons of long DNA sequences such as contigs or complete genomes. 

Run 08_run_nucmer_mummer.sh

Finally, it can be of interest to compare the chosen final assembly of one accession against that of a colleague. 

Run 09_run_mummer_between_accessions.sh


