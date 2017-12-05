library(ggplot2)
#setwd("Desktop/BMI")


#mat <- read.table("Documents/Parent of Origin/Paper/maternal_BMI_5414017.ped")
#pat <- read.table("Documents/Parent of Origin/Paper/paternal_BMI_5414017.ped")
#fam <- read.table("Documents/Parent of Origin/Paper/maternal_BMI_5414017.fam")

#mat <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4136278.ped")
#pat <- read.table("Documents/Parent of Origin/Paper/paternalbmi_4136278.ped")
#fam <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4136278.fam")

#mat <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4124292.ped")
#pat <- read.table("Documents/Parent of Origin/Paper/paternalbmi_4124292.ped")
#fam <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4124292.fam")
#mat <- read.table("Documents/Parent of Origin/Paper/genotypes/maternalbmi_4132296.ped")
#pat <- read.table("Documents/Parent of Origin/Paper/genotypes/paternalbmi_4132296.ped")
#fam <- read.table("Documents/Parent of Origin/Paper/genotypes/maternalbmi_4132296.fam")

mat <- read.table("Documents/Parent of Origin/Paper/genotypes/maternalbmi_4604643.ped")
pat <- read.table("Documents/Parent of Origin/Paper/genotypes/paternalbmi_4604643.ped")
fam <- read.table("Documents/Parent of Origin/Paper/genotypes/maternalbmi_4604643.fam")


#for 4132296
a2$GG <- factor(a2$GG, levels=c("A:A", "G:A", "A:G"))

ggplot(a2, aes(gtype, residuals, fill= gtype)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_brewer(name = "Genotype",
                    #  scale_fill_manual(name = "Genotype",
                    breaks = c("A(m)A(p)",   "G(m)A(p)","A(m)G(p)", "G(m)G(p)"),
                    labels = c(expression(A[m]~A[p]),
                               expression(G[m]~A[p]),
                               expression(A[m]~G[p]),
                               expression(G[m]~G[p])),
                    #                  values=c("#e66101", "#fd8b63", "#a6dba0", "#008837"))+
                    #palette = "PRGn")+
                    palette="Purples")+
  labs(y = "BMI residuals\n", x = "Genotype", title = "BMI by Genotype\n") +
  scale_x_discrete("\nrs77785972 (chr5)", labels=c(expression(A[m]~A[p]),
                                                   expression(G[m]~A[p]),
                                                   expression(A[m]~G[p]),
                                                   expression(G[m]~G[p])))


mat <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4604643.ped")
pat <- read.table("Documents/Parent of Origin/Paper/paternalbmi_4604643.ped")
fam <- read.table("Documents/Parent of Origin/Paper/maternalbmi_4604643.fam")



phen <- read.table("Documents/Parent of Origin/needtoorganize/Re__LDL_residuals-2/BMIComb_04042014.ph-cvt", header = T)
phen$findiv <- paste(phen$findiv, "2", sep="")
fam2 <- fam[(fam$V2%in%mat$V2),]
fam3 <- fam2[order(fam2$V2),]
pat2 <- pat[(mat$V2%in%fam3$V2),]
pat3<- pat2[order(pat2$V2),]
mat2 <- mat[(mat$V2%in%fam3$V2),]
mat3<- mat2[order(mat2$V2),]
phen2 <- phen[which(phen$findiv%in%fam2$V2),]
phen3 <- phen2[match(mat3$V2, phen2$findiv),]
fam2 <- cbind(fam3, phen3$logBMI, pat3$V7, mat3$V7)
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
a2$GG <- paste(a2$pat, a2$mat, sep=":")

t <- table(a2$GG)

ggplot(a2, aes(GG, residuals, fill=GG)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_brewer(name = "Parental Genotype \n Paternal: Maternal",
                    breaks = c(names(t)),
                    labels = c(paste(names(t), "N=", t)),
                    palette = "PRGn")+
  labs(y = "BMI residuals\n", x = "Genotype", title = "BMI by Genotype\n") +
  scale_x_discrete("\nrs77785972 (chr5)", labels=c(paste(names(t))))

a2$gtype <- factor(a2$gtype, levels=c("A(m)A(p)", "G(m)A(p)", "A(m)G(p)", "G(m)G(p)"))
ggplot(a2, aes(gtype, residuals, fill= gtype)) +
  geom_boxplot(notch =F) +
  geom_point() + theme_bw() +  theme(text = element_text(size=20))+
  theme(axis.text=element_text(size=15),
        axis.title=element_text(size=15),
        title = element_text(size=15), panel.border = element_rect(fill = NA, colour = "black"))+
  scale_fill_brewer(name = "Genotype",
                    #  scale_fill_manual(name = "Genotype",
                    breaks = c("A(m)A(p)",   "G(m)A(p)","A(m)G(p)", "G(m)G(p)"),
                    labels = c(expression(A[m]~A[p]),
                               expression(G[m]~A[p]),
                               expression(A[m]~G[p]),
                               expression(G[m]~G[p])),
                    #                  values=c("#e66101", "#fd8b63", "#a6dba0", "#008837"))+
                    #palette = "PRGn")+
                    palette="Purples")+
  labs(y = "BMI residuals\n", x = "Genotype", title = "BMI by Genotype\n") +
  scale_x_discrete("\nrs77785972 (chr5)", labels=c(expression(A[m]~A[p]),
                                                   expression(G[m]~A[p]),
                                                   expression(A[m]~G[p]),
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
  labs(y = "BMI residuals\n", x = "Maternal Allele", title = "BMI by Parent of Origin Alleles\n") 


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
  labs(y = "BMI residuals\n", x = "Paternal Allele", title = "BMI by Parent of Origin Alleles\n") 

