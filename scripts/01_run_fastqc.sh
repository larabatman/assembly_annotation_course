#!/usr/bin/env bash
#SBATCH --time=1-00:00:00          # 1 day
#SBATCH --mem=16G                  # memory
#SBATCH --cpus-per-task=4          # CPUs
#SBATCH --job-name=fastqc          # job name
#SBATCH --partition=pibu_el8       # partition/queue
#SBATCH --output=fastqc_%j.out     # log file

# 1. Define paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/raw_data
OUTDIR=$WORKDIR/read_QC

# 2. Create output directory
mkdir -p $OUTDIR

# 3. Input files
GENOMIC=$DATADIR/Istisu-1/ERR11437352.fastq.gz
TRANS_R1=$DATADIR/RNAseq_Sha/ERR754081_1.fastq.gz 
TRANS_R2=$DATADIR/RNAseq_Sha/ERR754081_2.fastq.gz

# 4. Run FastQC inside Apptainer
apptainer exec \
  --bind $WORKDIR \
  --bind /data/courses/assembly-annotation-course \
  /containers/apptainer/fastqc-0.12.1.sif \
  fastqc \
  --threads $SLURM_CPUS_PER_TASK \
  --outdir $OUTDIR \
  $GENOMIC $TRANS_R1 $TRANS_R2
