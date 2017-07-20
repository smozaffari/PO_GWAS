args <- commandArgs(TRUE)

trait <- args[1]
#annotated file
#colors <- args[2:length(args)]

library(qqman)
#source("/group/ober-resources/users/smozaffari/POeQTL/bin/poscripts/qqplot.R")

tab <- read.table(paste("subset_annotated_sorted_maternal_",trait, sep=""), header = F)
newtab <- tab
names(newtab) <- names(gwasResults)

tab2 <- as.data.frame(newtab)
gwideline <- 5e-08
#head(newtab)
#head(tab2)
##png(filename=paste("Manhattan_maternal_",trait,"_5.31.17.png", sep = ""), type="cairo",width=1200, height=300)
png(filename=paste("Manhattan_maternal_",trait,"_6.11.17.png", sep = ""), type="cairo",width=600, height=500)
manhattan(tab2, col=c("#CC0621","#897074"),  genomewideline = -log10(gwideline), suggestiveline = F, main = paste("Maternal ", trait,sep=""), ylim=c(-log10(1e-01),-log10(1e-10)), cex.lab =1, cex.axis=1.5, cex.main = 3)
dev.off()


##old red = c("#CC0621","#897074")
##purple = c("#7F4A88","#796982")

#png(filename=paste("QQplot_maternal_",trait,"_5.31.17.png",sep = ""), type = "cairo", width=400, height=400)
#qq(tab2$P, cex.lab=1.5)
#dev.off()

tab <- read.table(paste("subset_annotated_sorted_paternal_",trait, sep=""), header = F)
gwideline <- 5e-08
head(tab)
#newtab <- tab[which(tab$V4>0.01),c(2,1,3,20)]
#names(newtab) <- names(gwasResults)
newtab <- tab
names(newtab) <- names(gwasResults)
tab2 <- as.data.frame(newtab)

png(filename=paste("Manhattan_paternal_",trait,"_6.11.17.png", sep = ""), type="cairo",width=600, height=500)
manhattan(tab2, col=c("#255488","#697582"), genomewideline = -log10(gwideline), suggestiveline = F, main = paste("Paternal ", trait, sep = ""), ylim = c(-log10(1e-01), -log10(1e-10)), cex.lab =1, cex.axis=1.5, cex.main = 3)
dev.off()

#png(filename=paste("QQplot_paternal_",trait,"_5.31.17.png", sep = ""), type = "cairo")
#qq(tab2$P, cex.lab=1.5)
#dev.off()


#tab <- read.table(paste("subset_annotated_gwas_",trait, sep=""), header = F)
#head(tab)
##newtab <- tab[which(tab$V4>0.01),c(2,1,3,20)]
##names(newtab) <- names(gwasResults)
#newtab <- tab
#names(newtab) <- names(gwasResults)
#tab2 <- as.data.frame(newtab)

#png(filename=paste("Manhattan_gwas_",trait,"_5.31.17.png", sep = ""), type="cairo",width=1200, height=300)
#manhattan(tab2, col=c("#7F4A88","#796982"), genomewideline = -log10(gwideline), suggestiveline = F, main = trait, ylim = c(-log10(1e-01), -log10(1e-20)), cex.lab =1.5, cex.axis=1.5, cex.main = 3)
#dev.off()

#png(filename=paste("QQplot_gwas_",trait,"_5.31.17.png", sep = ""), type = "cairo")
#qq(tab2$P, cex.lab=1.5)
#dev.off()
