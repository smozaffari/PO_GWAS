

#make bed files
awk  '$20 <5e-08  {print "chr"$1,$3-1000000,$3+1000000,$2,$9,$4,$5,$7,$20}' OFS="\t" /group/ober-resources/users/smozaffari/POGWAS/results/correctnames_subset_maf_0.01/BMI_subset > BMI.bed




#make gencode bed file
tail -n+6  Downloads/gencode.v19.annotation.gtf | awk '$3=="gene" {print $1,$4,$5,$18}' OFS="\t" | sed 's/\"//g' | sed 's/;//g'  > genes_gencode_v19.bed