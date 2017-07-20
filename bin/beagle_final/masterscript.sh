#!/bin/bash

# Author: SVM
# Purpose: run PO-GWAS multiple chromosomes, one phenotype
# Usage:

#inputDir=$(readlink -f $1)
#echo "Input files will be searched in " $inputDir

phenotype=$1
phenfile=$2

#jobsPerNode=$3 #How many jobs per node = 1..32 what parallel gets 1-32 specific to Beagle
#NNodes=$4 #Number of nodes you want to use /available (for 1000 files, and about 20 jobs/node only need 50 nodes)

#outDir=$(readlink -f $5)

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


echo "qsub -v PHENO=\"$phenotype\",FILE=\"$phenfile\",SCRIPTDIR=\"$scriptDir\" -N $phenotype  $scriptDir/second.pbs" | tee -a $setup_log
qsub -v PHENO=$phenotype,FILE=$phenfile,SCRIPTDIR=$scriptDir  -N $phenotype $scriptDir/second.pbs 2>&1

