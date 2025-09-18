# assembly_annotation_course
In this course, we aim to de novo assemble an Arabidopsis thaliana accession Istisu-1. 
This genome assembly will be annotated thanks to transcriptomics data coming from another accession line: Sha. 

The first step is to control the quality of the genome and transcriptome sequence reads using fastqc tool. 
Run script 01_run_fastqc.sh

The sequence length for the genomic dataset is 98-49665 while the sequence length for the transcriptomic dataset is 101 for both R1 and R2. 
These quality of these datasets could be improved by dismissing low quality reads, since the per base sequence is poor for the transcriptomic datset. 

To improve the quality of the datasets, we are further going to use the preprocessing tool fastp, which is able to handle both short and long reads. 

