#setwd("~/scratch/smozaffari") on tarbell
filenames <- list.files(".", pattern="*permutations.fam", full.names=TRUE)
ldf <- lapply(filenames, read.table, header = F)
names(ldf) <- substr(filenames, 3, 100)
newdf <- lapply(ldf, function(x) {x[,1:106]})
merged.data.frame <- Reduce(function(...) merge(..., by="V2", all=TRUE), newdf)
merged2 <- merged.data.frame[,c(2,1,3:dim(merged.data.frame)[2])]
write.table(merged2, "BMI_LDL_permute.fam", quote = F, row.names=F, col.names = F)
