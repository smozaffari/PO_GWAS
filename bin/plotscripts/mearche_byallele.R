library(ggplot2)
#setwd("Desktop/BMI")
mat <- read.table("Documents/Parent of Origin/Paper/menarche_mat_10497965.ped")
pat <- read.table("Documents/Parent of Origin/Paper/menarche_pat_10497965.ped")
fam <- read.table("Documents/Parent of Origin/Paper/menarche_mat_10497965.fam")

phen <- read.table("Documents/Parent of Origin/Phenotypes/menarche_ph-cvt.txt_nofid", header = T)
phen$findiv <- paste(phen$findiv, "2", sep="")
fam2 <- fam[(fam$V2%in%mat$V2),]
fam3 <- fam2[order(fam2$V2),]
pat2 <- pat[(mat$V2%in%fam3$V2),]
pat3<- pat2[order(pat2$V2),]
mat2 <- mat[(mat$V2%in%fam3$V2),]
mat3<- mat2[order(mat2$V2),]

#lmfit <- lm(phen$inv_mean_bl ~phen$age+phen$sex)
#phen$residuals <- lmfit$residuals

fam2 <- cbind(fam3, pat3$V7, mat3$V7)
head(fam2)
c <- colnames(fam2)
c
colnames(fam2) <- c("Hutt", "findiv", "father", "mother", "sex", "phen_0", "pat", "mat")
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
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black", size = 1))+
  scale_fill_brewer(name = "Genotype",
                    breaks = c("A(m)A(p)",  "A(m)G(p)", "G(m)A(p)", "G(m)G(p)"),
                    labels = c(expression(A[m]~A[p]),
                               expression(G[m]~A[p]),
                               expression(A[m]~G[p]),
                               expression(G[m]~G[p])),
                    palette = "PRGn")+
  labs(y = "Systolic Blood Pressure residuals\n", x = "Genotype", title = "SBP by Genotype\n") +
  scale_x_discrete("\nrs114248710 (chr5)", labels=c(expression(A[m]~A[p]),
                                                    expression(A[m]~G[p]),
                                                    expression(G[m]~A[p]),
                                                    expression(G[m]~G[p])))



ggplot(a2, aes(mat, residuals, fill= mat)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_manual(name = "Maternal Allele",
                    breaks = c("A",  "G"),
                    labels = c(expression(A[m]),
                               expression(G[m])),
                    values = c("#de2d26", "#fc9272"))+
  labs(y = "Age of menarche residuals\n", x = "Maternal Allele", title = "Age of Menarche by Parent of Origin Alleles\n") 


ggplot(a2, aes(pat, residuals, fill= pat)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_manual(name = "Paternal Allele",
                    breaks = c("A",  "G"),
                    labels = c(expression(A[p]),
                               expression(G[p])),
                    values = c("#3182bd", "#9ecae1"))+
  labs(y = "Age of menarche residuals\n", x = "Paternal Allele", title = "Age of menarche by Parent of Origin Alleles\n") 

