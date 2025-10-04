#!/usr/bin/env bash
#SBATCH --time=24:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=8
#SBATCH --job-name=mummer_cross
#SBATCH --partition=pibu_el8
#SBATCH --output=mummer_cross_%j.out

# -----------------------
# Paths
# -----------------------
WORKDIR=/data/users/lland/assembly_annotation_course
OUTDIR=$WORKDIR/mummer_between_accessions
mkdir -p $OUTDIR

# Preferred assemblies per accession (adjust these!)
ACC1=/data/users/lland/assembly_annotation_course/assembly/hifiasm/istisu1.bp.p_ctg.fa # Accession A
ACC2=/data/users/aballah/assembly_annotation_course/outputs/hifiasm/assembly.fasta   # Accession B
ACC3=/data/users/kweisensee/assembly/output/hifiasm/No-0.fa      # Accession C

# Container
CONTAINER=/containers/apptainer/mummer4_gnuplot.sif

# -----------------------
# Helper function
# -----------------------
run_mummer () {
    PREFIX=$1
    REFSEQ=$2
    QRYSEQ=$3

    echo "Running nucmer: $QRYSEQ vs $REFSEQ"
    apptainer exec --bind /data $CONTAINER \
        nucmer --prefix=$PREFIX --breaklen 1000 --mincluster 1000 $REFSEQ $QRYSEQ

    echo "Filtering delta for $PREFIX..."
    apptainer exec --bind /data $CONTAINER \
        delta-filter -1 ${PREFIX}.delta > ${PREFIX}.filter.delta

    echo "Plotting with mummerplot for $PREFIX..."
    apptainer exec --bind /data $CONTAINER \
        mummerplot --prefix=$PREFIX --filter -t png --large --layout --fat \
          -R $REFSEQ -Q $QRYSEQ ${PREFIX}.filter.delta
}

# -----------------------
# Pairwise cross-accession comparisons
# -----------------------
run_mummer $OUTDIR/Isitsu-1_vs_Sf-2 $ACC1 $ACC2
run_mummer $OUTDIR/Isitsu-1_vs_No-0 $ACC1 $ACC3
run_mummer $OUTDIR/Sf-2_vs_No-0 $ACC2 $ACC3
