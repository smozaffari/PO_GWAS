### PO GWAS on Beagle

1. `bash masterscript.sh <phenotype> <phenotypefile> `
  * ex. `bash  ../bin/beagle_final/masterscript.sh systolic systolic2SNP_04202014.ph-cvt`
  * ex. `bash  ../bin/beagle_final/masterscript.sh ALL Allphenotypes_bimbam.txt`
  * runs second.pbs
    * runs format.sh (separate SNPs and make plink files)
      * runs chrsnps.pl
      * runs format.R (make phenotype file and relatedness matrix)
        * runs relatednessmatrix.pl 


2. `bash masterrun_2.sh <phenotype> <phenotypefile> <covariate1__covariate2> `
  * ex. `bash  ../../bin/beagle_final/masterrun_2.sh systolic systolic2SNP_04202014.ph-cvt sex__age__age_sex__technician_164__technician_179__technician_186`
  * ex. `bash  ../../bin/beagle_final/masterrun_2.sh ALL Allphenotypes_bimbam.txt covs` (no actual covariates needed since covariates regressed out to run one SNP at a time across all phenotypes)
  * runs run2_2.pbs
      * runs third_2.sh (5 aprun of third_2.sh)
         * runs newmodel_2.R in parallel




##ALL phenotypes at once (using residuals and same genotype covariate file for every phenotype at each SNP no other covariates)
bash  ../../bin/beagle_final/masterrun_2.sh ALL Allphenotypes_bimbam.txt_noheader  covs

##Permutations:
bash  ../../bin/beagle_final/permute_master.sh permute_BMI_LDL permute_BMI_LDL_101 covs


(to find out which didn't work - space on /tmp/sm:
``for x in `seq 1 22`
do
ls -l $x/segments/ | cut -f 9 -d" " |  grep segment > ${x}_segments
find $x  -mindepth 2 -type f | awk '/output/ {split($0, a, "/"); split(a[3], b, "_"); print  b[9]}' | sort | uniq -c | grep 203 | cut -f6 -d" " | grep -vf  -  ${x}_segments | awk '{print '$x', $0}' >>redo_segments
done``
)


Permute_x were used to see if significance from permutations is near 5e-08 and it was for BMI & LDL. 
