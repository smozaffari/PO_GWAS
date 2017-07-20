#!/bin/bash
#PBS -N expression_matpatgwas
#PBS -l walltime=02:00:00
#PBS -l nodes=1:ppn=1
#PBS -l mem=15gb
#PBS -M smozaffari@uchicago.edu

# Author: SVM
# Purpose: prepare bed files from opposite pogwas to check for overlap with gene expression: maternal + paternal only
# Usage:


# make gencode file
# tail -n+6 gencode.v19.annotation.gtf | awk '$3=="gene" {print $1,$4,$5,$18}' OFS="\t" | sed 's/"//g' | sed 's/;//g' > genes_gencode_v19.bed
#cd $PBS_O_WORKDIR
#echo $PBS_O_WORKDIR

cd /group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_famfiles/
module purge
module load gcc/6.2.0
module load bedtools
#module load plink
module load gemma
module unload R
# Author: Sahar Mozaffari
# Date: 03/21/17
# Purpose: opposite effect model on gene expression for each significant opposite POGWAS
# Usage:

#loop through all SNPs in each gene's file

p=0;

while IFS=" "  read -r line; do
#    echo $line
    declare -a genes=($line)
    for gene in "${genes[@]}"
    do
	p=$(($p+1))
	while IFS=" " read -r allsnp; do
	    snp=$(echo $allsnp | cut -f2 -d" ")
#	    echo $snp
	    awk '{print "1", $5}' Maternal.fam > cov_sex_${snp}.txt
#	    plink --file Maternal_LCL_sigPOGWASsnps --snp $snp --silent --make-bed --out snp_recode_mat${snp}
#	    plink --file Paternal_LCL_sigPOGWASsnps --snp $snp --silent --make-bed --out snp_recode_pat${snp}
	    cp Maternal.fam snp_recode_mat${snp}.fam
	    cp Paternal.fam snp_recode_pat${snp}.fam
	    newp=$(($p+8))
#	    echo $newp
	    echo "gemma -bfile snp_recode_mat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o mat_${gene}_${snp}"
	    echo "gemma -bfile snp_recode_pat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o pat_${gene}_${snp}"
	    gemma -bfile snp_recode_mat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o mat_${gene}_${snp} 
	    wait
	    gemma -bfile snp_recode_pat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o pat_${gene}_${snp} 
	    wait
#	    rm snp_recode_pat${snp}.*
#	    rm snp_recode_mat${snp}.*
#	    rm cov_sex_${snp}.txt
	done < /group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_famfiles/$gene
    done
done < /group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_famfiles/genenames
