#!/usr/bin/env bash
#SBATCH --time=1-00:00:00          # 1 day
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=lja
#SBATCH --partition=pibu_el8
#SBATCH --output=lja_%j.out

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/read_QC/fastp       # PacBio HiFi reads
OUTDIR=$WORKDIR/assembly/lja
mkdir -p $OUTDIR

# Input reads
READS=$DATADIR/ERR11437352.fastq.gz

# Run LJA
apptainer exec \
  --bind /data \
  /containers/apptainer/lja-0.2.sif \
  lja \
    -t $SLURM_CPUS_PER_TASK \
    -o $OUTDIR \
    --reads $READS
