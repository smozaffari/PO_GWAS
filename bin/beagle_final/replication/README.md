This folder/file was made to run opposite effect GWAS on one SNP/one phenotype at a time.

Run:
Rscript newmodel_onephenotype.R 


Need plink files



`cut -f7-30 -d" "  /tmp/sm/${PHENO}_${CHR}_maternal.fam  > /tmp/sm/phen_${PHENO}.txt `
