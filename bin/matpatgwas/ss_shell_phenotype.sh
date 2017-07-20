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

echo "Rscript ../../../bin/matpatgwas/ss_phenotype_po.R $PHENOTYPEFILE $PHEN $COV"
Rscript ../../../bin/matpatgwas/ss_phenotype_po.R $PHENOTYPEFILE $PHEN $COV


rm female_${PHEN}_maternal.*
rm female_${PHEN}_paternal.*
rm male_${PHEN}_maternal.*
rm male_${PHEN}_paternal.*
rm male_maternal_${PHEN}.*
rm male_paternal_${PHEN}.*
rm female_maternal_${PHEN}.*
rm female_paternal_${PHEN}.*
