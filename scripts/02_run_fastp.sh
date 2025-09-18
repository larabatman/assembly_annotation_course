#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=fastp
#SBATCH --partition=pibu_el8
#SBATCH --output=fastp_%j.out

# Load fastp
module load fastp/0.23.4-GCC-10.3.0

WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/raw_data
OUTDIR=$WORKDIR/read_QC/fastp
mkdir -p $OUTDIR

# Illumina RNA-seq (paired-end)
fastp \
  -i $DATADIR/RNAseq_Sha/ERR754081_1.fastq.gz \
  -I $DATADIR/RNAseq_Sha/ERR754081_2.fastq.gz \
  -o $OUTDIR/ERR754081_1.trimmed.fastq.gz \
  -O $OUTDIR/ERR754081_2.trimmed.fastq.gz \
  --thread $SLURM_CPUS_PER_TASK \
  --html $OUTDIR/fastp_illumina.html \
  --json $OUTDIR/fastp_illumina.json

# PacBio HiFi (single-end)
fastp \
  -i $DATADIR/Istisu-1/ERR11437352.fastq.gz \
  -o $OUTDIR/ERR11437352.fastq.gz \
  --thread $SLURM_CPUS_PER_TASK \
  --disable_quality_filtering \
  --disable_length_filtering \
  --disable_adapter_trimming \
  --html $OUTDIR/fastp_pacbio.html \
  --json $OUTDIR/fastp_pacbio.json
