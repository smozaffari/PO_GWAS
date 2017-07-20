#!/bin/bash
# Author: Sahar Mozaffari
# Date: 09/20/16
# Purpose: runs Newmodel to get difference in PO effect - on each SNP
# Usage: aprun from run2.pbs - look at that file (or masterrun.sh) for how to run
# Notes: input and output files writen to /tmp/sm

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
CHR=$2
PHENO=$3
FILE=$4
COVS=$5
COUNT=$6


echo "%%% Begin at " $(date) | tee $setup_log
export WHOAMI=$(whoami)
echo "Submitted as:" $WHOAMI
echo "running jobs in "$PWD
echo "$SCRIPTDIR"
echo "$PHENO"
echo "$FILE"
echo "$COVS"
echo "$COUNT"



timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time before moving files to /tmp : $timeTag "| tee $setup_log
#make folder on /tmp for all files I will put there.
mkdir /tmp/sm

#put script on tmp
dd bs=8M if=$SCRIPTDIR/newmodel_allphen.R of=/tmp/sm/newmodel_allphen.R

#put maternal fam file on /tmp
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/${PHENO}_maternal.fam of=/tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam

#and recode snp files (map and ped) on /tmp
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.map  of=/tmp/sm/recode_mat_chr_${CHR}_${PHENO}_${COUNT}.map
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_pat_chr_${CHR}_${PHENO}.map  of=/tmp/sm/recode_pat_chr_${CHR}_${PHENO}_${COUNT}.map

dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.ped  of=/tmp/sm/recode_mat_chr_${CHR}_${PHENO}_${COUNT}.ped
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_pat_chr_${CHR}_${PHENO}.ped  of=/tmp/sm/recode_pat_chr_${CHR}_${PHENO}_${COUNT}.ped

echo $FILE

dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/data/${FILE} of=/tmp/sm/${COUNT}_${FILE}
#for allphenotypes in one:
cut -f7-30 -d" "  /tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam  > /tmp/sm/phen_${PHENO}_${COUNT}.txt   

#and relatedness
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/${PHENO}relatedness of=/tmp/sm/${PHENO}_${COUNT}relatedness

NEWFILE=${COUNT}_${FILE}

timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after moving files to /tmp & before running newmodel : $timeTag" | tee $setup_log


#extract information columns (covariates) from ped file and put on /tmp
cut -f1-7 -d" " /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.ped > /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}.txt
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}.txt of=/tmp/sm/covmat_${CHR}_${PHENO}.txt

#function to run "newmodel"
NEWMODEL () {
    CHR=$1
    PHENO=$2
    NEWFILE=$3
    COVS=$4
    COUNT=$5
    SUB=$6
    echo "Rscript /tmp/sm/newmodel_allphen.R $CHR $PHENO $NEWFILE $COUNT ${COUNT}${PHENO}${SUB} $COVS" | tee -a $setup_log
    head ${COUNT}${PHENO}${SUB}
    Rscript /tmp/sm/newmodel_allphen.R $CHR $PHENO $NEWFILE $COUNT ${COUNT}${PHENO}${SUB} $COVS
}

export -f NEWMODEL
cd /tmp/sm

#split segments into more segments
split --number=l/32 /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/segments/$COUNT -d  ${COUNT}${PHENO} -a 3

#run in parallel 
parallel -j 32 NEWMODEL $CHR $PHENO $NEWFILE $COVS $COUNT ::: $(seq -w  000 031)
echo "parallel -j 32 NEWMODEL $CHR $PHENO $NEWFILE $COVS $COUNT ::: $(seq -w 000 031)"


timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after script running  : $timeTag" | tee $setup_log
cd /tmp/sm/


#loop through all phenotypes and combine output from all segments
for p in `seq 1 30`;
do
cat output/${p}_*${COUNT}_${CHR}*.assoc.txt > output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}
head output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}

#make directory and transfer back to lustre
mkdir -p /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/output/
dd bs=8M if=output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}  of=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}
done

timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after output file moved from  /tmp : $timeTag" | tee $setup_log

#remove all the files from /tmp and just leftover
rm /tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam
rm output/${COUNT}_*
rm /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}_${COUNT}.txt
rm covmat_${CHR}_${PHENO}_${COUNT}.txt
rm ${PHENO}_${CHR}_maternal.fam

rm recode_mat_chr_${CHR}_${PHENO}_${COUNT}.map
rm recode_mat_chr_${CHR}_${PHENO}_${COUNT}.ped
rm recode_pat_chr_${CHR}_${PHENO}_${COUNT}.map
rm recode_pat_chr_${CHR}_${PHENO}_${COUNT}.ped

#to check what is on there/how much space left.
#ls /tmp/sm
du -hc /tmp/sm | tail

echo "%%%" $(date) "$scriptName completed its execution " | tee -a $setup_log
