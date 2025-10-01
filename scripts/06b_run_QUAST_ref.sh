#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=quast_ref
#SBATCH --partition=pibu_el8
#SBATCH --output=quast_ref_%j.out

WORKDIR=/data/users/lland/assembly_annotation_course
OUTDIR=$WORKDIR/quast/with_ref
mkdir -p $OUTDIR

# Assemblies
FLYE=$WORKDIR/assembly/flye/assembly.fasta
HIFIASM=$WORKDIR/assembly/hifiasm/istisu1.bp.p_ctg.fa
LJA=$WORKDIR/assembly/lja/assembly.fasta

# Reference + annotation
REF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa
GFF=/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.57.gff3

apptainer exec --bind /data /containers/apptainer/quast_5.2.0.sif \
  quast.py --eukaryote --est-ref-size 135000000 \
    --threads $SLURM_CPUS_PER_TASK \
    --labels flye,hifiasm,lja \
    -r $REF --features $GFF \
    $FLYE $HIFIASM $LJA \
    -o $OUTDIR
