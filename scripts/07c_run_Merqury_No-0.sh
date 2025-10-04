#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=merqury_No0
#SBATCH --partition=pibu_el8
#SBATCH --output=merqury_No0_%j.out

set -euo pipefail

# -----------------------
# Paths
# -----------------------
WORKDIR=/data/users/lland/assembly_annotation_course
COLLEAGUEDIR=/data/users/kweisensee/assembly
READS=$WORKDIR/raw_data/No-0/ERR11437335.fastq   # uncompressed FASTQ
OUTDIR=$WORKDIR/merqury/No-0
mkdir -p $OUTDIR

# Assemblies
FLYE=$COLLEAGUEDIR/output/flye/assembly.fasta
HIFIASM=$COLLEAGUEDIR/output/hifiasm/No-0.fa
LJA=$COLLEAGUEDIR/output/LJA/No-0/assembly.fasta

# Merqury container + path
export MERQURY="/usr/local/share/merqury"
CONTAINER=/containers/apptainer/merqury_1.3.sif

# -----------------------
# Step 1: Build meryl DB once
# -----------------------
if [ ! -d "$OUTDIR/hifi.meryl" ]; then
  echo "Building meryl DB from reads..."
  apptainer exec --bind /data $CONTAINER \
    meryl count k=21 output $OUTDIR/hifi.meryl $READS
else
  echo "Using existing meryl DB: $OUTDIR/hifi.meryl"
fi

# -----------------------
# Step 2: Run Merqury for each assembly
# -----------------------
for ASM in flye hifiasm lja; do
    echo "Running Merqury for $ASM..."
    mkdir -p $OUTDIR/$ASM
    cd $OUTDIR/$ASM

    if [ "$ASM" == "flye" ]; then
        ASMFILE=$FLYE
    elif [ "$ASM" == "hifiasm" ]; then
        ASMFILE=$HIFIASM
    elif [ "$ASM" == "lja" ]; then
        ASMFILE=$LJA
    fi

    apptainer exec --bind /data $CONTAINER \
      $MERQURY/merqury.sh $OUTDIR/hifi.meryl $ASMFILE $ASM
done

echo "Merqury analysis complete for No-0"
