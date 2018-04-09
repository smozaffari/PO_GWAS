# Author: Sahar Mozaffari
# Date: 12/3/17
# Purpose: run newmodel to test for difference in PO effects - made to make replication easier (one snp, one phenotype at a time).
# Files format : plink files with genotypes: each individual has two ids in the plink files, one for maternal genotype and one for paternal genotype. 
#               ex. individual 1 has A from mom and C from dad, in plink file, there will be two ids for individual 1: 12 and 11, where 12 has genotype A A and 11 has genotype C C (coded as diploid).
#               plink bfiles are separated into paternal and maternal (mine named recode_mat_chr_{chr}_{phen}) (line #33/34)
#               Separate fam file that has phenotypes (mine named {phen}_maternal.fam} with maternal ids.

# Usage: Rscript newmodel_onephenotype.R {chr} {snpname} {phenotype} {pathtofamfilewithphenotypes}



#loop through all SNPs in file
args <- commandArgs(trailingOnly = TRUE)
chr <- args[1] #chr testing
snp <- args[2]
phen <- args[3] #phenotype name
pathtophenfam <- args[4] #path to fam file that has phenotypes. Only used maternal.fam here. 
#ex. pathtophenfam <- paste("/tmp/sm/",phen,"_maternal.fam", sep="")

#set working directory as needed. 
print(getwd())

#read in fam file with phenotype of interest
fam <- read.table(pathtophenfam, comment.char = "")


#modified to run only one snp
print(snp);
snp

#recode plink files
system(paste("plink-1.9 --file recode_mat_chr_",chr,"_",phen," --snp ", snp, " --silent --recode 12 --out snp_recode_mat",snp, sep = ""))
system(paste("plink-1.9 --file recode_pat_chr_",chr,"_",phen," --snp ", snp, " --silent --recode 12 --out snp_recode_pat",snp, sep = ""))

#read genotype files
mat12 <- read.table(paste("snp_recode_mat",snp,".ped", sep = ""))
pat12 <- read.table(paste("snp_recode_pat",snp,".ped", sep = ""))

#sort them to keep every file consistent
matk_order <- mat12[match(fam$V2, mat12$V2),] 
patk_order <- pat12[match(fam$V2, mat12$V2),] 
# the paternal file is reordered to match the fam file to the maternal file, because the fam file has maternally coded findivs (with an extra 2 at the end of the id)

#average parental genotype 
matk_order[matk_order==0] <- NA
patk_order[patk_order==0] <- NA
avg <- (patk_order$V7-matk_order$V7)

#Genotype file
new <- (matk_order$V7*patk_order$V7)
new[new=="0"] <- "NA"
new[new=="1"] <- 0
new[new=="2"] <- 1
new[new=="4"] <- 2

####For Difference effect:
#when average parental genotype is put in as genotype:
#beta will be difference Bp-Bm
avggtype <- cbind(snp, "A", "G", t(avg))
write.table(avggtype, paste("diffXmp_",phen,"_",snp,".txt",sep=""), quote = F, row.names = F, col.names = F, sep = ", ")

    
#when genotype is put in as covariate in model:
#beta will be difference Bp-Bm
#add 1's and genotype as covariate (and other covariates if phenotype not corrected for covariates already)
covariatesdiff <- cbind("1", new)
covariatesdiff[!!rowSums(is.na(covariatesdiff)),] <- NA
write.table(covariatesdiff, paste("cov_age_sex_diffXmp_",phen,"_",snp, ".txt",sep=""), quote = F, row.names = F, col.names = F)


# pheno is the vector of phenotypes to run. If you only have one, you can define it and then no need to loop through the file for the association analyses
pheno <- c("mono", "BRI", "chitin", "cimt", "diastolic", "eos", "feNO", "fev1", "fev1fvc", "HDL", "height", "Ige", "LAVI", "LDL", "BMI", "LVMI", "lymph", "menarche", "neutro", "systolic", "totalchol", "trig,", "YKL")
# loop through all phenotypes to get output files

for (p in 1:length(pheno)){
# run association using GEMMA, using bimbam files: genotype is coded as the difference, phenotype is phenotype being tested, relatedness matrix and covariates (avg genotype) specified. Also used -notsnp flag. 
    system(paste("/lustre/beagle2/ober/resources/opt/bin/gemma -g diffXmp_",phen,"_", snp, ".txt -p phen_", phen, ".txt  -k ",phen,"relatedness -lmm 4 -notsnp -c cov_age_sex_diffXmp_",phen,"_",snp,".txt -o ",p,"_",pheno[p],"_",chr,"_",snp,"_",phen, "_bimbam_difference_allcovs ", sep = ""), wait = T)
}

