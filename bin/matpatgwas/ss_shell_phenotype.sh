#!/bin/bash
#PBS -N ${PHEN}_po_ss
#PBS -l walltime=4:00:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e ${PHEN}_po_ss.err
#PBS -o ${PHEN}_po_ss.log
#PBS -M smozaffari@uchicago.edu

export TMPDIR=$WORKDIR
cd $PBS_O_WORKDIR
export TEMP=$WORKDIR

module load gcc/6.2.0
module load R
module load plink
module load gemma

Rscript ../../../bin/poscripts/ss_phenotype_po.R $PHENOTYPEFILE $PHEN $COV
