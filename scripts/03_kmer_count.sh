#!/usr/bin/env bash
#SBATCH --time=02:00:00
#SBATCH --mem=40G
#SBATCH --cpus-per-task=4
#SBATCH --job-name=jellyfish
#SBATCH --partition=pibu_el8
#SBATCH --output=jellyfish_%j.out

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=/data/courses/assembly-annotation-course/raw_data/Istisu-1   # resolved symlink dir
OUTDIR=$WORKDIR/kmer_counts
mkdir -p $OUTDIR

# Input PacBio HiFi reads
READS=$DATADIR/ERR11437352.fastq.gz

# Uncompress first (avoids Apptainer <() issue)
zcat $READS > $OUTDIR/pacbio.fastq

# Count 21-mers
apptainer exec \
  --bind $WORKDIR \
  --bind /data/courses/assembly-annotation-course \
  /containers/apptainer/jellyfish:2.2.6--0 \
  jellyfish count \
    -C \
    -m 21 \
    -s 5G \
    -t $SLURM_CPUS_PER_TASK \
    $OUTDIR/pacbio.fastq \
    -o $OUTDIR/reads.jf

# Build histogram
apptainer exec \
  --bind $WORKDIR \
  /containers/apptainer/jellyfish:2.2.6--0 \
  jellyfish histo \
    -t $SLURM_CPUS_PER_TASK \
    $OUTDIR/reads.jf \
    > $OUTDIR/reads.histo
