#!/bin/bash
#PBS -N ${PHEN}_gwas
#PBS -l walltime=6:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e ${PHEN}_gwas.err
#PBS -o ${PHEN}_gwas.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load gcc/6.2.0
module load R
module load plink
module load gemma

echo "Rscript ../../../bin/poscripts/phenotype_gwas.R $PHENOTYPEFILE $PHEN $COV"
Rscript ../../../bin/poscripts/phenotype_gwas.R $PHENOTYPEFILE $PHEN $COV
#age__agesexgrp1__agesexgrp2__agesexgrp1_age__agesexgrp2_age
