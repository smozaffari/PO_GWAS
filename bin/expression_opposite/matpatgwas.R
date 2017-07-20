# Author: Sahar Mozaffari
# Date: 03/21/17
# Purpose: opposite effect model on gene expression for each significant opposite POGWAS
# Usage: 

#loop through all SNPs in each gene's file
args <- commandArgs(trailingOnly = TRUE)

pheno <- read.table("genenames", stringsAsFactors=F)
print(length(pheno))
    for (p in 1:length(pheno)){
#p <- 3

snps <- read.table(paste(pheno[p]))
print(head(snps));

allsnps <- snps$V2

#read in fam file with phenotype of interest
fam <- read.table("Maternal.fam", comment.char = "")
expcol <- p+7
write.table(fam[,c(2,expcol)], paste(pheno[p],"gexp.txt", sep="_"), col.names=F, row.names=F, quote = F)

cov <- cbind("1",fam[,5])


tab <- fam

for (i in 1:length(allsnps))   {
    snp <-allsnps[i];
    print(snp);
    snp

    #keep individuals with systolic
    print( paste("plink --file Maternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --recode 12 --out snp_recode_mat",snp, sep = ""))
    system(paste("plink --file Maternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --recode 12 --out snp_recode_mat",snp, sep = ""))
    print (paste("plink --file Paternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --recode 12 --out snp_recode_pat",snp, sep = ""))
    system(paste("plink --file Paternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --recode 12 --out snp_recode_pat",snp, sep = ""))

    #read genotype files
    mat12 <- read.table(paste("snp_recode_mat",snp,".ped", sep = ""))
    pat12 <- read.table(paste("snp_recode_pat",snp,".ped", sep = ""))

    #keep those not missing any values
    matkeep12 <- mat12 #[mat12$V7>0,]
    patkeep12 <- pat12 #[pat12$V7>0,]

    #sort them to keep every file consistent
    matk_order <- matkeep12[match(fam$V2, matkeep12$V2),] 
    patk_order <- patkeep12[match(fam$V2, matkeep12$V2),] 


    #average parental genotype 
#    matk_order[matk_order==0] <- NA
#    patk_order[patk_order==0] <- NA

    ####For Difference effect:
    #when average parental genotype is put in as genotype:
    #beta will be difference Bp-Bm

    matgtype <- cbind(snp, "A", "G", t(matk_order$V7))
    write.table(matgtype, paste("mat_",snp,".txt",sep=""), quote = F, row.names = F, col.names = F, sep = ", ")
    

    #when genotype is put in as covariate in model:
    #beta will be difference Bp-Bm
    #add covariates from new model into new covariate file

    covariatesdiff <- cov
#    covariatesdiff[!!rowSums(is.na(covariatesdiff)),] <- NA
    write.table(covariatesdiff, paste("cov_age_sex_",snp, ".txt",sep=""), quote = F, row.names = F, col.names = F)

    #run gemma with multiple covariates
    system(paste("gemma -g mat_", snp, ".txt -p ",pheno[p],"_gexp.txt -n 2 -k LCL_geneexpressionrelatedness -lmm 4 -notsnp -c cov_age_sex_",snp,".txt -o ",p,"_",pheno[p],"_",snp,"_bimbam_mat_allcovs ", sep = ""), wait = T)

    ####For Average effect:
    #when difference parental genotype is put in as genotype:
    #beta will be average B: Bp+Bm/2

    patgtype <- cbind(snp, "A", "G", t(patk_order$V7))
    write.table(patgtype, paste("pat_",snp,".txt",sep=""), quote = F, row.names = F, col.names = F, sep = ", ")


    #when genotype is put in as covariate in model:
    #beta will be difference Bp-Bm
    #add covariates from new model into new covariate file

    #run gemma with multiple covariates
    system(paste("gemma -g pat_", snp, ".txt -p ",pheno[p],"_gexp.txt -n 2 -k LCL_geneexpressionrelatedness -lmm 4 -notsnp -c cov_age_sex_",snp,".txt -o ",p,"_",pheno[p],"_",snp,"_bimbam_pat_allcovs ", sep = ""), wait = T)


}
}