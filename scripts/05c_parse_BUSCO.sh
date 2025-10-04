#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=2G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=parse_busco
#SBATCH --partition=pibu_el8
#SBATCH --output=parse_busco_%j.out

WORKDIR=/data/users/lland/assembly_annotation_course
BUSCO_DIR=$WORKDIR/busco
OUTFILE=$BUSCO_DIR/busco_summary.tsv

echo -e "species\tS\tD\tF\tM\tn" > $OUTFILE

for summary in $(find $BUSCO_DIR -name "short_summary.*.txt"); do
    asm=$(basename $summary .txt | cut -d'.' -f4)     # e.g. flye_busco
    lin=$(basename $summary .txt | cut -d'.' -f3)     # e.g. brassicales_odb10
    label=${asm}.${lin}

    # Extract values from the BUSCO v5 summary lines
    S=$(grep "Complete and single-copy" $summary | awk '{print $1}')
    D=$(grep "Complete and duplicated" $summary | awk '{print $1}')
    F=$(grep "Fragmented BUSCOs" $summary | awk '{print $1}')
    M=$(grep "Missing BUSCOs" $summary | awk '{print $1}')
    n=$(grep "Total BUSCO groups searched" $summary | awk '{print $1}')

    echo -e "$label\t$S\t$D\t$F\t$M\t$n" >> $OUTFILE
done
