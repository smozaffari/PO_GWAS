#!/bin/bash
#PBS -N manplot_$PHENO
#PBS -l walltime=02:12:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=8gb
#PBS -e man_$PHENO.err
#PBS -o man_$PHENO.log
#PBS -M smozaffari@uchicago.edu
#PBS -m abe 


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

echo $PBS_O_WORKDIR
cd $PBS_O_WORKDIR

module load R

echo $PHENO
echo $FILEPATH

Rscript /group/ober-resources/users/smozaffari/POGWAS/bin/beagle_final/manhattan_qqplot_all.R $PHENO $FILEPATH

    
