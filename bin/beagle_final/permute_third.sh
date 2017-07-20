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
du -hc /tmp/sm | tail
rm -rf /tmp/sm
mkdir /tmp/sm


dd bs=8M if=$SCRIPTDIR/newmodel_permute.R of=/tmp/sm/newmodel_permute.R

dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/${PHENO}_maternal.fam of=/tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam

dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.map  of=/tmp/sm/recode_mat_chr_${CHR}_${PHENO}_${COUNT}.map
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_pat_chr_${CHR}_${PHENO}.map  of=/tmp/sm/recode_pat_chr_${CHR}_${PHENO}_${COUNT}.map
echo "dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_pat_chr_${CHR}_${PHENO}.map  of=/tmp/sm/recode_pat_chr_${CHR}_${PHENO}_${COUNT}.map"


dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.ped  of=/tmp/sm/recode_mat_chr_${CHR}_${PHENO}_${COUNT}.ped
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_pat_chr_${CHR}_${PHENO}.ped  of=/tmp/sm/recode_pat_chr_${CHR}_${PHENO}_${COUNT}.ped


echo $FILE

dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/data/${FILE} of=/tmp/sm/${COUNT}_${FILE}
#for allphenotypes in one:
cut -f7-300 -d" "  /tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam  > /tmp/sm/phen_${PHENO}_${COUNT}.txt   
#cut -f7 -d" "  /tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam  > /tmp/sm/phen_${PHENO}_${COUNT}.txt

#dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/phen_${PHENO}.txt of=/tmp/sm/phen_${PHENO}_${COUNT}.txt
dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/${PHENO}relatedness of=/tmp/sm/${PHENO}_${COUNT}relatedness



NEWFILE=${COUNT}_${FILE}
#NEWPHEN=/tmp/sm/phen_${PHENO}_${COUNT}.txt

timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after moving files to /tmp & before running newmodel : $timeTag" | tee $setup_log
  
#cd /tmp/sm  

#cut -f1-7 -d" " /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/recode_mat_chr_${CHR}_${PHENO}.ped > /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}.txt
#dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}.txt of=/tmp/sm/covmat_${CHR}_${PHENO}.txt

#cd /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/
NEWMODEL () {
    CHR=$1
    PHENO=$2
    NEWFILE=$3
    COVS=$4
    COUNT=$5
    SUB=$6
    echo "Rscript /tmp/sm/newmodel_permute.R $CHR $PHENO $NEWFILE $COUNT ${COUNT}${PHENO}${SUB} $COVS" | tee -a $setup_log
    head ${COUNT}${PHENO}${SUB}
    Rscript /tmp/sm/newmodel_permute.R $CHR $PHENO $NEWFILE $COUNT ${COUNT}${PHENO}${SUB} $COVS
    du -hc /tmp/sm | tail
}

export -f NEWMODEL
cd /tmp/sm


#dd bs=8M if=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/segments/$COUNT of=/tmp/sm/${COUNT}${PHENO}000
split --number=l/32 /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/segments/$COUNT -d  ${COUNT}${PHENO} -a 3

#NEWMODEL $CHR $PHENO $NEWFILE $COUNT $COVS  >>$setup_log 2>&1
#echo "NEWMODEL $CHR $PHENO $NEWFILE $COUNT $COVS  >>$setup_log 2>&1"



parallel -j 32 NEWMODEL $CHR $PHENO $NEWFILE $COVS $COUNT ::: $(seq -w  000 031)

#NEWMODEL $CHR $PHENO $NEWFILE $COVS $COUNT
echo "parallel -j 32 NEWMODEL $CHR $PHENO $NEWFILE $COVS $COUNT ::: $(seq -w 000 031)"


timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after script running  : $timeTag" | tee $setup_log
cd /tmp/sm/

for p in `seq 1 203`;
do
grep -v p_wald output/${p}_*${COUNT}_${CHR}*.assoc.txt | sort -k12g | head -5  > output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}
head output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}

mkdir -p /lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/output/

dd bs=8M if=output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}  of=/lustre/beagle2/ober/users/smozaffari/POGWAS/results/${PHENO}_newmodel/$CHR/output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}
done

timeTag=$(date "+%y_%m_%d_%H_%M_%S")
echo "Time after output file moved from  /tmp : $timeTag" | tee $setup_log

rm /tmp/sm/${PHENO}_${CHR}_${COUNT}_maternal.fam
rm /tmp/sm/${COUNT}_${FILE}
rm /tmp/sm/output/${p}_newmodel_results_${PHENO}_diff_chr${CHR}_${COUNT}

rm /tmp/sm/${PHENO}_${COUNT}relatedness
rm output/${COUNT}_*
rm /tmp/sm/phen_${PHENO}_${COUNT}.txt

rm /lustre/beagle2/ober/users/smozaffari/POGWAS/results/$PHENO/covmat_${CHR}_${PHENO}_${COUNT}.txt
rm covmat_${CHR}_${PHENO}_${COUNT}.txt

rm ${PHENO}_${CHR}_maternal.fam


rm recode_mat_chr_${CHR}_${PHENO}_${COUNT}.map
rm recode_mat_chr_${CHR}_${PHENO}_${COUNT}.ped

rm recode_pat_chr_${CHR}_${PHENO}_${COUNT}.map
rm recode_pat_chr_${CHR}_${PHENO}_${COUNT}.ped

#ls /tmp/sm
du -hc /tmp/sm | tail

echo "%%%" $(date) "$scriptName completed its execution " | tee -a $setup_log
