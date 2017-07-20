#R: to format Allphenotypes.fam to make it maternal and paternal specific and sex specific
#11-15-16

 args <- commandArgs(TRUE)
 phenall <- args[1]
 trait <- args[2]
 covariates <-  args[3:length(args)]
 cov <- unlist(strsplit(covariates, "__"))
 cov <- c("int", cov)
 print(cov);

ph <- read.table(phenall, header = T)
ph$MF <- sapply(strsplit(as.character(ph$findiv), ""), tail, 1)
phfemale <- ph[which(ph$MF==2),]
phmale <- ph[which(ph$MF==1),]

write.table(phmale, paste("male_",phenall,sep=""), col.names=T, row.names=F, quote=F)
write.table(phfemale, paste("female_",phenall,sep=""), col.names=T, row.names=F, quote=F)


system(paste("awk '{ print \"HUTTERITES\",$1\"1\" }' male_",phenall," | tail -n+2 > Hutterite_paternal_male_",trait, sep = ""))
system(paste("awk '{ print \"HUTTERITES\",$1\"1\" }' female_",phenall," | tail -n+2 > Hutterite_paternal_female_",trait, sep = ""))
system(paste("awk '{ print \"HUTTERITES\",$1\"2\" }' male_",phenall," | tail -n+2 > Hutterite_maternal_male_",trait, sep = ""))
system(paste("awk '{ print \"HUTTERITES\",$1\"2\" }' female_",phenall," | tail -n+2 > Hutterite_maternal_female_",trait, sep = ""))


system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_paternal_male_",trait," --make-bed --out paternal_imputed_male_",trait,sep = ""))
system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_maternal_male_",trait," --make-bed --out maternal_imputed_male_",trait,sep = ""))
system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_paternal_female_",trait," --make-bed --out paternal_imputed_female_",trait,sep = ""))
system(paste("plink --bfile /group/ober-resources/users/smozaffari/POGWAS/data/imputed_qcfilter --keep Hutterite_maternal_female_",trait," --make-bed --out maternal_imputed_female_",trait,sep = ""))


#alter fam file
phenfile <- paste("male_",phenall,sep="")
phen <- read.table(phenfile, header = T)
mphen <- phen
mphen$findiv <- paste(mphen$findiv,"2", sep="")
fam <- read.table(paste("maternal_imputed_male_",trait,".fam",sep=""))
mfam <- merge(fam, mphen, by.x=2, by.y=1, all.x=T, sort=F)
mfam2 <- mfam[,c(2,1,3:7)]
print(head(mfam2))
write.table(mfam2, paste("male_",trait,"_maternal.fam", sep =""), quote = F, row.names=F, col.names = F)

covmatrix <- mfam[,cov]
v <- paste(cov, collapse="_")
head(covmatrix)
write.table(covmatrix, paste("male_",v, "_",trait, "_cov.txt", sep=""), quote = F, row.names=F, col.names = F)


pphen<- phen
pphen$findiv <- paste(pphen$findiv, "1", sep="")
fam <- read.table(paste("paternal_imputed_male_",trait,".fam", sep = ""))
pfam  <- merge(fam, pphen, by.x=2, by.y=1, all.x=T, sort = F)
#write.table(pfam, "merge.fam", quote = F, row.names = F, col.names= F)
pfam2 <- pfam[,c(2,1,3:7)]
head(pfam2)
write.table(pfam2, paste("male_",trait,"_paternal.fam", sep =""), quote = F, row.names=F, col.names = F)
        
system(paste("mv maternal_imputed_male_",trait,".bed male_", trait,"_maternal.bed", sep =""))
system(paste("mv maternal_imputed_male_",trait,".bim male_", trait,"_maternal.bim", sep =""))

system(paste("mv  paternal_imputed_male_",trait,".bed male_", trait,"_paternal.bed", sep =""))
system(paste("mv  paternal_imputed_male_",trait,".bim male_", trait,"_paternal.bim", sep =""))

system(paste("gemma --bfile male_",trait,"_paternal -k /group/ober-resources/users/smozaffari/POGWAS/data/paternalrelatedness -km 2 -n 2 -c male_",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o male_paternal_",trait, sep=""))
system(paste("gemma --bfile male_",trait,"_maternal -k /group/ober-resources/users/smozaffari/POGWAS/data/maternalrelatedness -km 2 -n 2 -c male_",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o male_maternal_",trait, sep=""))

#FEMALE-SPECIFIC

phenfile <- paste("female_",phenall,sep="")
phen <- read.table(phenfile, header = T)
mphen <- phen
mphen$findiv <- paste(mphen$findiv,"2", sep="")
fam <- read.table(paste("maternal_imputed_female_",trait,".fam",sep=""))
mfam <- merge(fam, mphen, by.x=2, by.y=1, all.x=T, sort=F)
mfam2 <- mfam[,c(2,1,3:7)]
head(mfam2)
write.table(mfam2, paste("female_",trait,"_maternal.fam", sep =""), quote = F, row.names=F, col.names = F)

covmatrix <- mfam[,cov]
v <- paste(cov, collapse="_")
head(covmatrix)
write.table(covmatrix, paste("female_",v, "_",trait, "_cov.txt", sep=""), quote = F, row.names=F, col.names = F)

pphen<- phen
pphen$findiv <- paste(pphen$findiv, "1", sep="")
fam <- read.table(paste("paternal_imputed_female_",trait,".fam", sep = ""))
pfam  <- merge(fam, pphen, by.x=2, by.y=1, all.x=T, sort = F)
#write.table(pfam, "merge.fam", quote = F, row.names = F, col.names= F)
pfam2 <- pfam[,c(2,1,3:7)]
head(pfam2)
write.table(pfam2, paste("female_",trait,"_paternal.fam", sep =""), quote = F, row.names=F, col.names = F)

system(paste("mv  maternal_imputed_female_",trait,".bed female_", trait,"_maternal.bed", sep =""))
system(paste("mv  maternal_imputed_female_",trait,".bim female_", trait,"_maternal.bim", sep =""))

system(paste("mv  paternal_imputed_female_",trait,".bed female_", trait,"_paternal.bed", sep =""))
system(paste("mv  paternal_imputed_female_",trait,".bim female_", trait,"_paternal.bim", sep =""))


system(paste("gemma --bfile female_",trait,"_paternal -k /group/ober-resources/users/smozaffari/POGWAS/data/paternalrelatedness -km 2 -n 2 -c female_",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o female_paternal_",trait, sep=""))
system(paste("gemma --bfile female_",trait,"_maternal -k /group/ober-resources/users/smozaffari/POGWAS/data/maternalrelatedness -km 2 -n 2 -c female_",v,"_",trait,"_cov.txt -miss 1 -maf 0 -lmm 4 -o female_maternal_",trait, sep=""))