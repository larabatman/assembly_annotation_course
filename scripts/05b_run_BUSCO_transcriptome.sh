#!/usr/bin/env bash
#SBATCH --time=1-00:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=busco
#SBATCH --partition=pibu_el8
#SBATCH --output=busco_%j.out

# Load BUSCO
module load BUSCO/5.4.2-foss-2021a

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
OUTDIR=$WORKDIR/busco
mkdir -p $OUTDIR

# Input assemblies (update names if different!)
TRINITY=$WORKDIR/assembly/trinity/trinity.Trinity.fasta

# Trinity
busco --in $TRINITY --out trinity_busco \
  --mode transcriptome --lineage brassicales_odb10 \
  --cpu $SLURM_CPUS_PER_TASK --out_path $OUTDIR