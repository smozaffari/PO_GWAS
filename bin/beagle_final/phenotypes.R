# Author: Sahar Mozaffari
# Date: 1.19.16 
# Purpose: combine phenotypefiles into one, including residuals; regress out covariates for age at menarche and height that weren't regressed out before
# Usage: Rscript phenotypes.R 
# Notes: phenotypes in right location

setwd("~/lustre/beagle2/ober/users/smozaffari/POGWAS/data")
men <- read.table("Phenotypes/menarche_ph-cvt.txt_nofid", header = T)
men$residuals <- lm(men$menarche~men$byear)$residuals
write.table(men,"Phenotypes/menarche_ph-cvt.txt_nofid", col.names = T, row.names = F, quote=F)

height <- read.table("Phenotypes/height_comb_ph-cvt.txt_nofid", header = T)
height$residuals <- lm(height$height~height$age+height$agesexgrp1+height$agesexgrp2+height$agesexgrp1_age+height$agesexgrp2_age)$residuals
write.table(height,"Phenotypes/height_comb_ph-cvt.txt_nofid", col.names = T, row.names = F, quote=F)

filenames <- list.files("Phenotypes", pattern="*cvt*", full.names=TRUE)
ldf <- lapply(filenames, read.table, header = T)

names(ldf) <- substr(filenames, 12, 70)
names <- c(substr(filenames, 12, 70))

newdf <- lapply(ldf, function(x) {x[, c("findiv","residuals")]})

for (i in 1:23) {
  colnames(newdf[[i]])[2] <- paste("residuals", names[i], sep="_")
}


merged.data.frame <- Reduce(function(...) merge(..., by="findiv", all=TRUE), newdf)
write.table(merged.data.frame, "Allphenotypes_bimbam.txt", col.names=T, row.names=F, quote=F)
