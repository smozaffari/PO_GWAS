#R: to format Allphenotypes.fam to make it maternal and paternal specific.

 args <- commandArgs(TRUE)
 phenfile <- args[1]
 trait <- args[2]
 covariates <-  args[3:length(args)]
 cov <- unlist(strsplit(covariates, "__"))
 cov <- c("int",cov)

system(paste("awk '{ print \"HUTTERITES\",$1 }' ",phenfile," | tail -n+2 > Hutterite_gwas",trait, sep = ""))


#system(paste("plink --bfile /group/ober-resources/resources/Hutterites/PRIMAL/data-sets/qc/qc --keep Hutterite_gwas",trait," --extract /scratch/smozaffari/snps_subset  --make-bed --out gwas_imputed_",trait,sep = ""))

system(paste("plink --bfile /group/ober-resources/resources/Hutterites/PRIMAL/data-sets/ARCHIVE/qc-v1__2014-04-01/qc  --keep Hutterite_gwas",trait," --make-bed --out gwas_imputed_",trait,"2",sep=""))

#alter fam file

phen <- read.table(phenfile, header = T)
mphen <- phen
fam <- read.table(paste("gwas_imputed_",trait,"2.fam",sep=""))
mfam <- merge(fam, mphen, by.x=2, by.y=1, all.x=T, sort=F)
mfam2 <- mfam[,c(2,1,3:7)]
write.table(mfam2, paste(trait,"_gwas2.fam", sep =""), quote = F, row.names=F, col.names = F)

covmatrix <- mfam[,cov]
v <- paste(cov, collapse="_")
write.table(covmatrix, paste(v, "_gwas_",trait, "_cov.txt", sep=""), quote = F, row.names=F, col.names = F)


system(paste("mv  gwas_imputed_",trait,"2.bed ", trait,"_gwas2.bed", sep =""))
system(paste("mv  gwas_imputed_",trait,"2.bim ", trait,"_gwas2.bim", sep =""))

system(paste("gemma --bfile ",trait,"_gwas2 -k /group/ober-resources/users/smozaffari/POGWAS/data/relatedness -km 2 -n 2 -c ",v,"_gwas_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o gwas_2",trait, sep=""))

