#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=1G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=merqury_summary_sf2
#SBATCH --partition=pibu_el8
#SBATCH --output=merqury_summary_sf2_%j.out

set -euo pipefail

OUTDIR=/data/users/lland/assembly_annotation_course/merqury/merqury_Sf-2
OUTFILE=$OUTDIR/merqury_summary.tsv

echo -e "assembly\tQV\terror_rate\tcompleteness_percent" > $OUTFILE

# Flye
QV=$(awk '{print $4}' $OUTDIR/flye/eval_flye.qv)
ERR=$(awk '{print $5}' $OUTDIR/flye/eval_flye.qv)
COMP=$(awk '{print $5}' $OUTDIR/flye/eval_flye.completeness.stats)
echo -e "flye\t$QV\t$ERR\t$COMP" >> $OUTFILE

# Hifiasm
QV=$(awk '{print $4}' $OUTDIR/hifiasm/eval_hifiasm.qv)
ERR=$(awk '{print $5}' $OUTDIR/hifiasm/eval_hifiasm.qv)
COMP=$(awk '{print $5}' $OUTDIR/hifiasm/eval_hifiasm.completeness.stats)
echo -e "hifiasm\t$QV\t$ERR\t$COMP" >> $OUTFILE

# LJA
QV=$(awk '{print $4}' $OUTDIR/LJA/eval_lja.qv)
ERR=$(awk '{print $5}' $OUTDIR/LJA/eval_lja.qv)
COMP=$(awk '{print $5}' $OUTDIR/LJA/eval_lja.completeness.stats)
echo -e "lja\t$QV\t$ERR\t$COMP" >> $OUTFILE

echo "Summary written to $OUTFILE"
