#!/usr/bin/env bash
#SBATCH --time=1-00:00:00          # 1 day (increase if needed)
#SBATCH --mem=64G
#SBATCH --cpus-per-task=16
#SBATCH --job-name=hifiasm
#SBATCH --partition=pibu_el8
#SBATCH --output=hifiasm_%j.out

# Paths
WORKDIR=/data/users/lland/assembly_annotation_course
DATADIR=$WORKDIR/read_QC/fastp       # location of cleaned PacBio HiFi reads
OUTDIR=$WORKDIR/assembly/hifiasm
mkdir -p $OUTDIR

# Input PacBio HiFi reads
READS=$DATADIR/ERR11437352.fastq.gz

# Run hifiasm
apptainer exec \
  --bind /data \
  /containers/apptainer/hifiasm_0.25.0.sif \
  hifiasm \
    -o $OUTDIR/istisu1 \
    -t $SLURM_CPUS_PER_TASK \
    $READS

# Convert GFA to FASTA (primary contigs)
awk '/^S/{print ">"$2;print $3}' $OUTDIR/istisu1.bp.p_ctg.gfa > $OUTDIR/istisu1.bp.p_ctg.fa
