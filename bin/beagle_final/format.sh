#!/bin/bash
# Author: Sahar Mozaffari
# Date: 10/12/16
# Purpose: formats files before running next step that runs newmodel to get difference in PO effect - on each SNP
# Usage: aprun from run2.pbs - look at that file (or masterrun.sh) for how to run
# Notes: input and output files writen to /tmp/sm
set -x

scriptName=$(basename ${0})
echo $scriptName
scriptName=${scriptName%\.sh}
echo $scriptName
scriptDir=$(readlink -f "$(dirname "$0")")
echo $scriptDir

timeTag=$(date "+%y_%m_%d_%H_%M_%S")

setup_log=${scriptName}_${LOGNAME}_${timeTag}.log
echo $setup_log
echo "RUNNING $scriptName as " $(readlink -f $0 ) " on " `date`  | tee  $setup_log


SCRIPTDIR=$1
PHENO=$2
FILE=$3
COUNT=$4

echo "%%% Begin at " $(date) | tee $setup_log
export WHOAMI=$(whoami)
echo "Submitted as:" $WHOAMI
echo "running jobs in "$PWD
echo "$SCRIPTDIR"
echo "$PHENO"
echo "$FILE"
echo "$COUNT"

echo $PBS_O_WORKDIR
cd $PBS_O_WORKDIR/$PHENO

#keep individuals we have phenotype data for
awk '{ print "HUTTERITES",$1"1" }' $FILE | tail -n+2 > Hutterite_paternal${PHENO}
awk '{ print "HUTTERITES",$1"2" }' $FILE | tail -n+2 > Hutterite_maternal${PHENO}

mkdir -p $PBS_O_WORKDIR/${PHENO}_newmodel/$i
cd $PBS_O_WORKDIR/$PHENO

plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_paternal${PHENO} --make-bed --out paternal_imputed_${PHENO}
plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_maternal${PHENO} --make-bed --out maternal_imputed_${PHENO}

#split up bim file into chromosomes to run one chromosome at a time
perl $SCRIPTDIR/chrsnps.pl $PHENO

echo $PBS_O_WORKDIR/${PHENO}_newmodel
for i in {1..22}
do
    cd $PBS_O_WORKDIR/$PHENO
    #per chromosome recode maternal and paternal SNPs
    echo "plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter_chr${i} --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_maternal${PHENO} --recode 12 --out recode_mat_chr_${i}_${PHENO}"
    plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter_chr${i} --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_maternal${PHENO} --recode 12 --out recode_mat_chr_${i}_${PHENO} 

    echo "plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter_chr${i} --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_paternal${PHENO} --recode 12 --out recode_pat_chr_${i}_${PHENO}"
    plink-1.9 --bfile /lustre/beagle2/ober/users/smozaffari/POGWAS/data/imputed_qcfilter_chr${i} --keep /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/Hutterite_paternal${PHENO} --recode 12 --out recode_pat_chr_${i}_${PHENO} 

    cd $PBS_O_WORKDIR/${PHENO}_newmodel/$i/segments
    
    #split chromosome into segments of 2000 SNPs
    echo "split -a 4 -d -l 2000 ../../../$PHENO/chr${i}snps.txt segment${i}"      
    split -a 4 -d -l 2000 ../../../$PHENO/chr${i}snps.txt segment${i}
    echo "%%% Ending at "$(date)
done

cd $PBS_O_WORKDIR/$PHENO

# makes new maternal and paternal fam files that contain all phenotypes
Rscript $SCRIPTDIR/format.R $FILE $PHENO

cd $PBS_O_WORKDIR/${PHENO}_newmodel/

# below used once to get a list of chromosome segments to run newmodel a segment at a time: 
#find . | grep segment | cut -f2,4 -d"/" | grep segment | sed 's/\//\t/g' | sort > chromosome_segments
#awk 'NR%5{printf "%s ",$0;next;}1' chromosome_segments | sed 's/\s/\ /g' > chromosome_segments_by5
