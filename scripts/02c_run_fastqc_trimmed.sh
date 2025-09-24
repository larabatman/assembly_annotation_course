#!/usr/bin/env bash
#SBATCH --time=1-00:00:00          # 1 day
#SBATCH --mem=16G                  # memory
#SBATCH --cpus-per-task=4          # CPUs
#SBATCH --job-name=fastqc          # job name
#SBATCH --partition=pibu_el8       # partition/queue
#SBATCH --output=fastqc_%j.out     # log file

# 1. Define paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/read_QC/fastp        # where trimmed files are
OUTDIR=$WORKDIR/read_QC/fastqc_trimmed
mkdir -p $OUTDIR

# 2. Input files (trimmed Illumina RNA-seq)
TRANS_R1=$DATADIR/ERR754081_1.trimmed.fastq.gz
TRANS_R2=$DATADIR/ERR754081_2.trimmed.fastq.gz

# 3. Run FastQC inside Apptainer
apptainer exec \
  --bind $WORKDIR \
  --bind /data/courses/assembly-annotation-course \
  /containers/apptainer/fastqc-0.12.1.sif \
  fastqc \
  --threads $SLURM_CPUS_PER_TASK \
  --outdir $OUTDIR \
  $TRANS_R1 $TRANS_R2
