# Author: Sahar Mozaffari
# Date: 
# Purpose: Manhattan plot for difference/newmodel GWAS
# Usage: Rscript manhattan_qqplot_all.R <trait name> <annotated gwas result file>
# Notes: These were ultimately run on CRI/gardner

args <- commandArgs(TRUE)

trait <- args[1]
file <- args[2]
#annotated file

library(qqman)

tab <- read.table(file, header = F)
tab2 <- tab[which(tab$V4>0.01),]
newtab <- tab2[,c(2,1,3,20)]
names(newtab) <- names(gwasResults)
tab3 <- as.data.frame(newtab)

png(filename =paste("Diff_",trait, ".png", sep = ""),type ="cairo", width = 1000, height = 500)
manhattan(tab3, suggestiveline = F, genomewideline = -log10(5e-08), main = paste("Parent of Origin GWAS - ",trait, sep=""), cex.lab=1.5, cex.axis=1.5, cex.main=2, cex.sub=1.5, ylim=c(0,-log10(1e-10)))
dev.off()


png(filename=paste("QQplot_diff_all_",trait,".png", sep = ""), type = "cairo")
qq(tab3$P)
dev.off()

