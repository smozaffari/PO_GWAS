# Author: Sahar Mozaffari
# Date: 03/21/17
# Purpose: opposite effect model on gene expression for each significant opposite POGWAS
# Usage: 

#loop through all SNPs in each gene's file
args <- commandArgs(trailingOnly = TRUE)

pheno <- read.table("genenames", stringsAsFactors=F)
print(length(pheno))
#    for (p in 1:length(pheno)){
 p <- 3   
    
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
    #keep individuals with systolic
    print( paste("plink --file Maternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --make-bed --out snp_recode_mat",snp, sep = ""))
#    system(paste("plink --file Maternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --make-bed --out snp_recode_mat",snp, sep = ""))
    print (paste("plink --file Paternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --make-bed --out snp_recode_pat",snp, sep = ""))
#    system(paste("plink --file Paternal_LCL_sigPOGWASsnps --snp ", snp, " --silent --make-bed --out snp_recode_pat",snp, sep = ""))

    write.table(cov, paste("cov_sex_",snp, ".txt",sep=""), quote = F, row.names = F, col.names = F)    
    system(paste("cp Maternal.fam snp_recode_pat",snp,".fam", sep=""))
    system(paste("cp Maternal.fam snp_recode_mat",snp,".fam", sep=""))

    newp <- p+8
    #run gemma with multiple covariates	
    system(paste("gemma -bfile snp_recode_mat",snp," -n ",newp," -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_",snp,".txt  -o ",p,"_mat_",pheno[p],"_",snp, sep = ""), wait = T)
    system(paste("gemma -bfile snp_recode_pat",snp," -n ",newp," -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_",snp,".txt  -o ",p,"_pat_",pheno[p],"_",snp, sep = ""), wait = T)


#}
}