library(ggplot2)
#setwd("Desktop/BMI")
mat <- read.table("Documents/Parent of Origin/Paper/genotypes/menarche_mat_10523456.ped")
pat <- read.table("Documents/Parent of Origin/Paper/genotypes/menarche_pat_10523456.ped")
fam <- read.table("Documents/Parent of Origin/Paper/genotypes/menarche_mat_10523456.fam")

phen <- read.table("Documents/Parent of Origin/Phenotypes/menarche_ph-cvt.txt_nofid", header = T)
phen$residuals<- lm(phen$menarche~phen$byear)$residuals
phen$findiv <- paste(phen$findiv, "2", sep="")
fam2 <- fam[(fam$V2%in%mat$V2),]
fam3 <- fam2[order(fam2$V2),]
pat2 <- pat[(mat$V2%in%fam3$V2),]
pat3<- pat2[order(pat2$V2),]
mat2 <- mat[(mat$V2%in%fam3$V2),]
mat3<- mat2[order(mat2$V2),]
phen2<- phen[which(phen$findiv%in%mat3$V2),]
fam2 <- cbind(fam3, phen2$menarche, pat3$V7, mat3$V7)
head(fam2)
c <- colnames(fam2)
c
colnames(fam2) <- c("Hutt", "findiv", "father", "mother", "sex", "phen_0", "cimt", "pat", "mat")
gtype <- paste(fam2$mat, "(m)", fam2$pat, "(p)", sep="")
head(gtype)
fam4 <- cbind(fam2, gtype)
fam5 <- fam4
fam6 <- fam5[which(!fam5$pat==0),]
fam7 <- as.data.frame(fam6)
a <- droplevels(fam7)
a2 <- merge(a, phen, by="findiv")

ggplot(a2, aes(gtype, residuals, fill= gtype)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_brewer(name = "Genotype",
                    #  scale_fill_manual(name = "Genotype",
                    breaks = c("C(m)C(p)",  "C(m)T(p)", "T(m)C(p)", "T(m)T(p)"),
                    labels = c(expression(C[m]~C[p]),
                               expression(C[m]~T[p]),
                               expression(T[m]~C[p]),
                               expression(T[m]~T[p])),
                    #                  values=c("#e66101", "#fd8b63", "#a6dba0", "#008837"))+
                    #palette = "PRGn")+
                    palette="Purples")+
  labs(y = "Age of Menarche residuals\n", x = "Genotype", title = "Age of menarche by Genotype\n") +
  scale_x_discrete("\nrs58758386 (chr16)", labels=c(expression(C[m]~C[p]),
                                                   expression(C[m]~T[p]),
                                                   expression(T[m]~C[p]),
                                                   expression(T[m]~T[p])))


ggplot(a2, aes(mat, residuals, fill= mat)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_manual(name = "Maternal Allele",
                    breaks = c("C",  "T"),
                    labels = c(expression(C[m]),
                               expression(T[m])),
                    values = c("#de2d26", "#fc9272"))+
  labs(y = "Age of Menarche residuals\n", x = "Maternal Allele", title = "Menarche by Parent of Origin Alleles\n") 


ggplot(a2, aes(pat, residuals, fill= pat)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_manual(name = "Paternal Allele",
                    breaks = c("C",  "T"),
                    labels = c(expression(C[m]),
                               expression(T[m])),
                    values = c("#3182bd", "#9ecae1"))+
  labs(y = "Age of Menarche residuals\n", x = "Paternal Allele", title = "Menarche by Parent of Origin Alleles\n") 

