#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=merqury
#SBATCH --partition=pibu_el8
#SBATCH --output=merqury_%j.out

# -----------------------
# Paths
# -----------------------
WORKDIR=/data/users/lland/assembly_annotation_course
READS=$WORKDIR/read_QC/fastp/ERR11437352.fastq.gz   # PacBio HiFi reads
OUTDIR=$WORKDIR/merqury
mkdir -p $OUTDIR

# Assemblies
FLYE=$WORKDIR/assembly/flye/assembly.fasta
HIFIASM=$WORKDIR/assembly/hifiasm/istisu1.bp.p_ctg.fa
LJA=$WORKDIR/assembly/lja/assembly.fasta

# Path inside container
export MERQURY="/usr/local/share/merqury"

# -----------------------
# Step 1: Build meryl DB from HiFi reads
# -----------------------
if [ ! -d "$OUTDIR/hifi.meryl" ]; then
  echo "Building meryl DB from reads..."
  apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
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

    apptainer exec --bind /data /containers/apptainer/merqury_1.3.sif \
      $MERQURY/merqury.sh $OUTDIR/hifi.meryl $ASMFILE $ASM
done

echo "Merqury analysis complete!"
