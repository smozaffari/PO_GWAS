#knownfam <- read.table("../../imputed_qcfilter.fam")
exp <- read.table("../bedfiles/genes_forfamfile.txt", header = T, check.names=F)
texp <- t(exp)
write.table(texp, "transposed_expression", quote=F, row.names=F, col.names=F)
findivs <- rownames(texp)

paternal_findivs <- cbind("HUTTERITES", paste(findivs, "1", sep=""))
maternal_findivs <- cbind("HUTTERITES", paste(findivs, "2", sep=""))

write.table(paternal_findivs, "Paternal_LCLexpression_findivs", quote=F, row.names=F, col.names=F)
write.table(maternal_findivs, "Maternal_LCLexpression_findivs", quote=F, row.names=F, col.names=F)
 
maternalexp <- texp
rownames(maternalexp) <- paste(rownames(maternalexp), "2", sep="")
write.table(maternalexp, "MaternalLCLexp", row.names=T, col.names=T, quote = F)
paternalexp <- texp
rownames(paternalexp) <- paste(rownames(paternalexp), "1", sep="")
write.table(paternalexp, "PaternalLCLexp", row.names=T, col.names=T, quote = F)
