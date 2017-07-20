#!/bin/bash
#PBS -N annotate_$PHENO
#PBS -l walltime=02:12:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -e ann_$PHENO.err
#PBS -o ann_$PHENO.log
#PBS -m e
#PBS -M smozaffari@uchicago.edu



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

declare -a arr=("maternal" "paternal" "female_paternal" "female_maternal" "male_maternal" "male_paternal")

for i in "${arr[@]}"
do
    echo "$i"
    sort -k12g ${i}_${PHENO}.assoc.txt  > $PBS_O_WORKDIR/sorted_${i}_${PHENO}
done
    
perl /group/ober-resources/users/smozaffari/POGWAS/bin/plotscripts/annotate_beagle.pl sorted_${arr[0]}_${PHENO} sorted_${arr[1]}_${PHENO} sorted_${arr[2]}_${PHENO} sorted_${arr[3]}_${PHENO} sorted_${arr[4]}_${PHENO} sorted_${arr[5]}_${PHENO} 

declare -a arr=("maternal" "paternal" "female_paternal" "female_maternal" "male_maternal" "male_paternal")


for i in "${arr[@]}"
do
    echo "$i"
#    rm annotated_sorted_*.gz
    tail -n+2 annotated_sorted_${i}_${PHENO} > temp_${i}_${PHENO}
    mv temp_${i}_${PHENO} annotated_sorted_${i}_${PHENO}
    gzip annotated_sorted_${i}_${PHENO}
done

cd $FILEPATH/$PHENO/output/
echo "Rscript /group/ober-resources/users/smozaffari/POGWAS/bin/plotscripts/manhattan_paper.R $PHENO"
Rscript /group/ober-resources/users/smozaffari/POGWAS/bin/plotscripts/manhattan_paper.R $PHENO
wait

