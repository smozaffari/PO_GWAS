# Author: Sahar Mozaffari
# Date: 
# Purpose: converts maternal and paternal fam files to have all phenotypes in phenotype columns
# Usage: Rscript format.R <phenotypefile> <phenotype>

args <- commandArgs(TRUE)
phenfile <- args[1]
trait <- args[2]

phen <- read.table(phenfile, header = T)
   
mphen <- phen
mphen$findiv <- paste(mphen$findiv, "2", sep="")
fam <- read.table(paste("maternal_imputed_",trait,".fam", sep = ""))
mfam  <- merge(fam, mphen, by.x=2, by.y=1, all.x=T, sort = F)
mfam2 <- mfam[,c(2,1,3:dim(mfam)[2])]
write.table(mfam2, paste(trait,"_maternal.fam", sep =""), quote = F, row.names=F, col.names = F)
	
pphen <- phen
pphen$findiv <- paste(pphen$findiv, "1", sep="")
fam <- read.table(paste("paternal_imputed_",trait,".fam", sep = ""))
pfam  <- merge(fam, pphen, by.x=2, by.y=1, all.x=T, sort = F)
pfam2 <- pfam[,c(2,1,3:dim(pfam)[2])]
write.table(pfam2, paste(trait,"_paternal.fam", sep =""), quote = F, row.names=F, col.names = F)

system(paste("perl /lustre/beagle2/ober/users/smozaffari/POGWAS/bin/beagle_final/relatednessmatrix.pl ",trait," ",trait,"_maternal.fam",sep=""))


