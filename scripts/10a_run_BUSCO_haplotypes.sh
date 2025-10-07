#!/usr/bin/env bash
#SBATCH --time=12:00:00
#SBATCH --mem=32G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=busco_hap
#SBATCH --partition=pibu_el8
#SBATCH --output=busco_hap_%j.out

# -----------------------
# Paths
# -----------------------
WORKDIR=/data/users/lland/assembly_annotation_course
HIFIASM_DIR=$WORKDIR/assembly/hifiasm
OUTDIR=$WORKDIR/busco/hifiasm_haplotypes
mkdir -p $OUTDIR

# Convert haplotypes GFA → FASTA (only if not done yet)
for HAP in hap1 hap2; do
    GFA=$HIFIASM_DIR/istisu1.bp.${HAP}.p_ctg.gfa
    FA=$HIFIASM_DIR/istisu1.bp.${HAP}.p_ctg.fa
    if [ -f "$GFA" ] && [ ! -f "$FA" ]; then
        echo "Converting $GFA → $FA"
        awk '/^S/{print ">"$2;print $3}' $GFA > $FA
    fi
done

# -----------------------
# Run BUSCO for haplotypes
# -----------------------
CONTAINER=/containers/apptainer/busco_5.7.1.sif
LINEAGE=/data/courses/assembly-annotation-course/references/brassicales_odb10

for HAPFA in $HIFIASM_DIR/istisu1.bp.hap*.p_ctg.fa; do
    HAPNAME=$(basename $HAPFA .fa)
    echo "Running BUSCO on $HAPNAME ..."
    apptainer exec --bind /data $CONTAINER busco \
        -i $HAPFA \
        -l $LINEAGE \
        -o ${OUTDIR}/${HAPNAME}_busco \
        -m genome \
        --cpu $SLURM_CPUS_PER_TASK\
        --lineage brassicales_odb10

done

echo "BUSCO haplotype analysis complete!"
