#R: to format Allphenotypes.fam to make it maternal and paternal specific.

 args <- commandArgs(TRUE)
 phenfile <- args[1]
 trait <- args[2]
 covariates <-  args[3:length(args)]
 cov <- unlist(strsplit(covariates, "__"))
 cov <- c("int",cov)

system(paste("awk '{ print \"HUTTERITES\",$1\"1\" }' ",phenfile," | tail -n+2 > Hutterite_paternal",trait, sep = ""))
system(paste("awk '{ print \"HUTTERITES\",$1\"2\" }' ",phenfile," | tail -n+2 > Hutterite_maternal",trait, sep = ""))

system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_paternal",trait," --make-bed --out paternal_imputed_",trait,sep = ""))
system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_maternal",trait," --make-bed --out maternal_imputed_",trait,sep = ""))


#alter fam file

phen <- read.table(phenfile, header = T)
mphen <- phen
mphen$findiv <- paste(mphen$findiv,"2", sep="")
fam <- read.table(paste("maternal_imputed_",trait,".fam",sep=""))
mfam <- merge(fam, mphen, by.x=2, by.y=1, all.x=T, sort=F)
mfam2 <- mfam[,c(2,1,3:7)]
write.table(mfam2, paste(trait,"_maternal.fam", sep =""), quote = F, row.names=F, col.names = F)

covmatrix <- mfam[,cov]
v <- paste(cov, collapse="_")
write.table(covmatrix, paste(v, "_",trait, "_cov.txt", sep=""), quote = F, row.names=F, col.names = F)


pphen<- phen
pphen$findiv <- paste(pphen$findiv, "1", sep="")
fam <- read.table(paste("paternal_imputed_",trait,".fam", sep = ""))
pfam  <- merge(fam, pphen, by.x=2, by.y=1, all.x=T, sort = F)
write.table(pfam, "merge.fam", quote = F, row.names = F, col.names= F)
pfam2 <- pfam[,c(2,1,3:7)]
write.table(pfam2, paste(trait,"_paternal.fam", sep =""), quote = F, row.names=F, col.names = F)
        
system(paste("mv  maternal_imputed_",trait,".bed ", trait,"_maternal.bed", sep =""))
system(paste("mv  maternal_imputed_",trait,".bim ", trait,"_maternal.bim", sep =""))

system(paste("mv  paternal_imputed_",trait,".bed ", trait,"_paternal.bed", sep =""))
system(paste("mv  paternal_imputed_",trait,".bim ", trait,"_paternal.bim", sep =""))

system(paste("gemma --bfile ",trait,"_paternal -k /group/ober-resources/users/smozaffari/POGWAS/data/paternalrelatedness -km 2 -n 2 -c ",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o paternal_",trait, sep=""))
system(paste("gemma --bfile ",trait,"_maternal -k /group/ober-resources/users/smozaffari/POGWAS/data/maternalrelatedness -km 2 -n 2 -c ",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o maternal_",trait, sep=""))

