# assembly_annotation_course
In this course, we aim to de novo assemble an Arabidopsis thaliana accession Istisu-1. 
This genome assembly will be annotated thanks to transcriptomics data coming from another accession line, Sha. 

Published data is openly accessible at https://www.nature.com/articles/s41588-024-01715-9 and https://www.nature.com/articles/s41467-020-14779-y. 

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
To further validate the quality of the sequencing data, coverage depth, error rate, heterozygosity and genome size consistency can be assessed using k-mer analysis. 
To that end, we use jellyfish to count canonical k-mers (k = 21) and use the kmer counts to build an histogram using the model-fittig GenomeScope tool. 

Run script 03_kmer_count.sh

The outputed reads.histo file can then be uploaded to GenomeScope http://genomescope.org/genomescope2.0/ to interpret the k-mer spectrum: http://genomescope.org/genomescope2.0/analysis.php?code=owAfXbMQJA8oLr6II18J. 
The estimated genome size from the k-mer histogram appears to be between 134,298,918 bp (min) and 134,403,675 bp (max), roughly 134.3-134.4 Mb. This suggests that the dataset is properly sequenced and covers the genome evely, since it is very close to the referenced A. thaliana length of 135 Mb. 
Interestingly, the 44x coverage expectation from fastp does not match the peak fitted by GenomeScope, that appears rather around 38-39x. This is likely due to very short reads and low-quality k-mers reported earlier, as well as error k-mers that inflate the denominator in the previous fastp calculation. 
The percentage of heterozygosity is of 0.0571348% (min) - 0.0704555% (max), which is not expected: 
