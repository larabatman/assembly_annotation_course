#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=merqury_hap
#SBATCH --partition=pibu_el8
#SBATCH --output=merqury_hap_%j.out

# -----------------------
# Paths
# -----------------------
WORKDIR=/data/users/lland/assembly_annotation_course
READS=$WORKDIR/read_QC/fastp/ERR11437352.fastq.gz
OUTDIR=$WORKDIR/merqury/hifiasm_haplotypes
mkdir -p $OUTDIR

# Assemblies
HIFIASM_DIR=$WORKDIR/assembly/hifiasm
HAP1=$HIFIASM_DIR/istisu1.bp.hap1.p_ctg.fa
HAP2=$HIFIASM_DIR/istisu1.bp.hap2.p_ctg.fa

# Container & internal path
CONTAINER=/containers/apptainer/merqury_1.3.sif
export MERQURY="/usr/local/share/merqury"

# -----------------------
# Step 1: Build meryl DB once
# -----------------------
if [ ! -d "$OUTDIR/hifi.meryl" ]; then
  echo "Building meryl DB from HiFi reads..."
  apptainer exec --bind /data $CONTAINER \
    meryl count k=21 output $OUTDIR/hifi.meryl $READS
else
  echo "Using existing meryl DB: $OUTDIR/hifi.meryl"
fi

# -----------------------
# Step 2: Run Merqury on both haplotypes
# -----------------------
for ASM in $HAP1 $HAP2; do
    ASMNAME=$(basename $ASM .fa)
    echo "Running Merqury for $ASMNAME ..."
    mkdir -p $OUTDIR/$ASMNAME
    cd $OUTDIR/$ASMNAME
    apptainer exec --bind /data $CONTAINER \
      $MERQURY/merqury.sh $OUTDIR/hifi.meryl $ASM $ASMNAME
done

echo "Merqury haplotype analysis complete!"
