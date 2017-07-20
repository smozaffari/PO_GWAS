#!/bin/bash

# Author: Sahar Mozaffari 
# Date: 09/20/16
# Purpose: run PO-GWAS multiple chromosomes, one phenotype : qsub 5 chr segments at a time to get PO effect
# Usage: bash masterrun.sh <phenotype> <phenotypefile> <covariates>
# Note: Covariates separated by __ (2 underscores)
# Ex: bash masterrun.sh BMI BMIComb... sex__age

PHENO=$1
FILE=$2
COVS=$3


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

cd /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel

#function to QSUB files
QSUB_FILE() {
  PHENO=$1
  FILE=$2
  COVS=$3
  scriptDir=$4
  CHR1=$5
  SEGMENT1=$6
  CHR2=$7
  SEGMENT2=$8
  CHR3=$9
  SEGMENT3=${10}
  CHR4=${11}
  SEGMENT4=${12}
  CHR5=${13}
  SEGMENT5=${14}
  echo "qsub -v CHR1=\"$CHR1\",SEGMENT1=\"$SEGMENT1\",CHR2=\"$CHR2\",SEGMENT2=\"$SEGMENT2\",CHR3=\"$CHR3\",SEGMENT3=\"$SEGMENT3\",CHR4=\"$CHR4\",SEGMENT4=\"$SEGMENT4\",CHR5=\"$CHR5\",SEGMENT5=\"$SEGMENT5\",PHENO=\"$PHENO\",FILE=\"$FILE\",COVS=\"$COVS\",SCRIPTDIR=\"$scriptDir\" -N $phenotype  $scriptDir/run2_2.pbs" | tee -a $setup_log
  
  qsub -v CHR1=$CHR1,SEGMENT1=$SEGMENT1,CHR2=$CHR2,SEGMENT2=$SEGMENT2,CHR3=$CHR3,SEGMENT3=$SEGMENT3,CHR4=$CHR4,SEGMENT4=$SEGMENT4,CHR5=$CHR5,SEGMENT5=$SEGMENT5,PHENO=$PHENO,FILE=$FILE,COVS=$COVS,SCRIPTDIR=$scriptDir  -N ${PHENO}_${SEGMENT1} $scriptDir/run2_2.pbs 2>&1
}
export -f QSUB_FILE

# file chromosome_segments_by5 created in format.sh to submit 5 segments in parallel
echo "parallel  --colsep '\ ' QSUB_FILE $PHENO $FILE $COVS $scriptDir  :::: chromosome_segments_by5  2>&1" | tee $plog
parallel  --colsep '\ ' QSUB_FILE $PHENO $FILE $COVS $scriptDir  :::: chromosome_segments_by5 2>&1


