#!/usr/bin/env bash
#SBATCH --time=2-00:00:00        # Trinity can take longer than genome assembly
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=trinity
#SBATCH --partition=pibu_el8
#SBATCH --output=trinity_%j.out

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/read_QC/fastp       # where trimmed RNA-seq reads are
OUTDIR=$WORKDIR/assembly/trinity
mkdir -p $OUTDIR

# Input RNA-seq paired reads
LEFT=$DATADIR/ERR754081_1.trimmed.fastq.gz
RIGHT=$DATADIR/ERR754081_2.trimmed.fastq.gz

# Load Trinity module
module load Trinity/2.15.1-foss-2021a

# Run Trinity
Trinity \
  --seqType fq \
  --left $LEFT \
  --right $RIGHT \
  --CPU $SLURM_CPUS_PER_TASK \
  --max_memory 64G \
  --output $OUTDIR
