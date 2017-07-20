#!/bin/bash
#PBS -N ${PHEN}_po
#PBS -l walltime=2:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e ${PHEN}_po.err
#PBS -o ${PHEN}_po.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load gcc/6.2.0
module load R
module load plink
module load gemma

echo "Rscript ../../../bin/poscripts/phenotype_all.R $PHENOTYPEFILE  $PHEN $COV"
Rscript ../../../bin/poscripts/phenotype_all.R $PHENOTYPEFILE  $PHEN $COV
