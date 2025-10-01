#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=quast_noref
#SBATCH --partition=pibu_el8
#SBATCH --output=quast_noref_%j.out

WORKDIR=/data/users/lland/assembly_annotation_course
OUTDIR=$WORKDIR/quast/no_ref
mkdir -p $OUTDIR

# Assemblies
FLYE=$WORKDIR/assembly/flye/assembly.fasta
HIFIASM=$WORKDIR/assembly/hifiasm/istisu1.bp.p_ctg.fa
LJA=$WORKDIR/assembly/lja/assembly.fasta

apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
  quast.py --eukaryote --est-ref-size 135000000 \
    --threads $SLURM_CPUS_PER_TASK \
    --labels flye,hifiasm,lja \
    $FLYE $HIFIASM $LJA \
    -o $OUTDIR
