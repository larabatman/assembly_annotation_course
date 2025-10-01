#!/usr/bin/env bash
#SBATCH --time=1-00:00:00          # give Flye plenty of time (assemblies can be long)
#SBATCH --mem=64G                  # memory (adjust if needed)
#SBATCH --cpus-per-task=16         # Flye scales with threads
#SBATCH --job-name=flye
#SBATCH --partition=pibu_el8
#SBATCH --output=flye_%j.out       # log file

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=/data/users/lland/assembly_annotation_course/read_QC/fastp
OUTDIR=$WORKDIR/assembly
mkdir -p $OUTDIR

# Input PacBio HiFi reads
READS=$DATADIR/ERR11437352.fastq.gz

# Run Flye inside Apptainer
apptainer exec \
  --bind /data /containers/apptainer/flye_2.9.5.sif \
  flye \
    --pacbio-hifi $READS \
    --threads $SLURM_CPUS_PER_TASK \
    --out-dir $OUTDIR
