#!/bin/bash

# Author: SVM
# Purpose: prepare bed files from opposite pogwas to check for overlap with gene expression
# Usage:


# make gencode file
# tail -n+6 gencode.v19.annotation.gtf | awk '$3=="gene" {print $1,$4,$5,$18}' OFS="\t" | sed 's/"//g' | sed 's/;//g' > genes_gencode_v19.bed


module load gcc/6.2.0
module load bedtools
module load R
module load plink

#overlap significant genes with location of gens +/-1MB
FILES="/group/ober-resources/users/smozaffari/POeQTL/data/*/*/output/annotated_sorted2_paternal_*"
echo $FILES
for f in $FILES
do
    echo $f
    bf1=${f##*/}
    echo $bf1
    bf=$(echo $bf1 | cut -f1 -d"." | cut -f4 -d"_")
    awk  '$20 <5e-08  {print "chr"$1,$3-1000000,$3+1000000,$3,$2,$9,$4,$5,$7,$20}' OFS="\t" <(gzip -dc $f)  | awk '$7 > 0.01 {print $0}' > pat_${bf%_subset}.bed
    bedtools intersect -wo -a ../../genes_gencode_v19.bed -b ${bf%_subset}.bed > pat_${bf%_subset}_genes.txt 
    awk  '$20 <5e-08  {print "chr"$1,$3-1000000,$3+1000000,$3,$2,$9,$4,$5,$7,$20}' OFS="\t" <(gzip -dc $f)  | awk '$7 > 0.01 {print $0}' > ${bf%_subset}.bed
    bedtools intersect -wo -a ../../genes_gencode_v19.bed -b ${bf%_subset}.bed > ${bf%_subset}_genes.txt    

done

FILES="/group/ober-resources/users/smozaffari/POeQTL/data/*/*/output/annotated_sorted2_maternal_*"
echo $FILES
for f in $FILES
do
    echo $f
    bf1=${f##*/}
    echo $bf1
    bf=$(echo $bf1 | cut -f1 -d"." | cut -f4 -d"_")
    awk  '$20 <5e-08  {print "chr"$1,$3-1000000,$3+1000000,$3,$2,$9,$4,$5,$7,$20}' OFS="\t" <(gzip -dc $f)  | awk '$7 > 0.01 {print $0}' > mat_${bf%_subset}.bed
    bedtools intersect -wo -a ../../genes_gencode_v19.bed -b ${bf%_subset}.bed > mat_${bf%_subset}_genes.txt    
    awk  '$20 <5e-08  {print "chr"$1,$3-1000000,$3+1000000,$3,$2,$9,$4,$5,$7,$20}' OFS="\t" <(gzip -dc $f)  | awk '$7 > 0.01 {print $0}' >> ${bf%_subset}.bed
    bedtools intersect -wo -a ../../genes_gencode_v19.bed -b ${bf%_subset}.bed >> ${bf%_subset}_genes.txt    

done



NEWFILES="/group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_bedfiles/*_genes.txt"

head -1 /group/ober-resources/users/smozaffari/ASE/data/expression/Total_gene_normalized_v19log.txt >genes_forfamfile.txt

#find out how many genes are expressed in each phenotypelist of genes
echo $NEWFILES
for n in $NEWFILES
do
    echo $n
    genestosearch=$(cut -f5 $n |sort | uniq )
    genestosearchlist=(`echo ${genestosearch}`);
    for gene in ${genestosearchlist[@]}
    do
    awk -v gene="$gene" '$1==gene {print $0}' /group/ober-resources/users/smozaffari/ASE/data/expression/Total_gene_normalized_v19log.txt >>genes_forfamfile.txt
    done
done

#how many of the genes we want to test are expressed in LCLs
tail -n+2 genes_forfamfile.txt | cut -f1 -d" " | sort | uniq > 107genes
cat *_genes.txt > allgenes.txt

cd ../po_famfiles
cut -f5,11 ../po_bedfiles/allgenes.txt | grep -wf ../po_bedfiles/107genes  > genes_SNP
cut -f5,11 ../po_bedfiles/allgenes.txt | grep -wf ../po_bedfiles/107genes  | cut -f2 | sort | uniq > SNPs

#grab findivs we have expression data for
Rscript /group/ober-resources/users/smozaffari/POGWAS/bin/expression_opposite/po_famfiles.R

#extract people/snps for those that we have expression for
plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Paternal_LCLexpression_findivs --extract SNPs --recode --out Paternal_LCL_sigPOGWASsnps
plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Maternal_LCLexpression_findivs --extract SNPs --recode --out Maternal_LCL_sigPOGWASsnps

#make fam files that have gene expression in each column
awk 'FNR==NR{a[$1]=$0;next} ($2) in a{print  $1,$2,$3,$4,$5,$6,a[$2]}'  PaternalLCLexp  Paternal_LCL_sigPOGWASsnps.ped > Paternal.fam
awk 'FNR==NR{a[$1]=$0;next} ($2) in a{print  $1,$2,$3,$4,$5,$6,a[$2]}'  MaternalLCLexp  Maternal_LCL_sigPOGWASsnps.ped > Maternal.fam

#save gene names/which gene in which column
head -1 PaternalLCLexp > genenames

#make relatedness matrix only for those we have gene expression for
perl   ../../../../POeQTL/bin/poscripts/relatednessmatrix.pl LCL_geneexpression  Maternal.fam 

#splits gene/snp file by gene name so we can run one gene at a time. 
awk  '{print >  $1}' genes_SNP 
