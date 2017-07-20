# Author: Sahar Mozaffari
# Date: 9/20/16
# Purpose: run newmodel to test for difference in PO effects
# Usage: run from third.sh (aprun from run2.pbs ( qsub from masterrun.sh)) look there for directions

#loop through all SNPs in file
args <- commandArgs(trailingOnly = TRUE)
chr <- args[1]
phen <- args[2]
file <- args[3]
num <- args[4]
subnum <- args[5]
print(num);

setwd("/tmp/sm")
print(getwd())

pathtophenfam <- paste("/tmp/sm/",phen,"_",chr,"_",num,"_maternal.fam", sep="")

#read in SNPs
snps <- read.table(subnum, nrows=2000)
print(subnum);
print(head(snps));
allsnps <- snps$V1
str(allsnps)
nn <- length(allsnps)

phenotypefile <- file

#read in fam file with phenotype of interest
fam <- read.table(pathtophenfam, comment.char = "")

tab <- fam

for (i in 1:nn)   {
    snp <-snps$V1[i];
    print(snp);
    snp

    #keep individuals with phenotype
    system(paste("plink-1.9 --file recode_mat_chr_",chr,"_",phen,"_",num," --snp ", snp, " --silent  --recode 12 --out snp_recode_mat",snp, sep = ""))
    system(paste("plink-1.9 --file recode_pat_chr_",chr,"_",phen,"_",num," --snp ", snp, " --silent --recode 12 --out snp_recode_pat",snp, sep = ""))

    #read genotype files
    mat12 <- read.table(paste("snp_recode_mat",snp,".ped", sep = ""))
    pat12 <- read.table(paste("snp_recode_pat",snp,".ped", sep = ""))

    #keep those not missing any values
    matkeep12 <- mat12 #[mat12$V7>0,]
    patkeep12 <- pat12 #[pat12$V7>0,]

    #sort them to keep every file consistent
    matk_order <- matkeep12[match(fam$V2, matkeep12$V2),] 
    patk_order <- patkeep12[match(fam$V2, matkeep12$V2),] 

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
    #add 1's and genotype as covariate
    covariatesdiff <- cbind("1", new)
    covariatesdiff[!!rowSums(is.na(covariatesdiff)),] <- NA
    write.table(covariatesdiff, paste("cov_age_sex_diffXmp_",phen,"_",snp, ".txt",sep=""), quote = F, row.names = F, col.names = F)

    #run gemma with multiple covariates
    pheno <- c("mono", "BRI", "chitin", "cimt", "diastolic", "eos", "feNO", "fev1", "fev1fvc", "HDL", "height", "Ige", "LAVI", "LDL", "BMI", "LVMI", "lymph", "menarche", "neutro", "systolic", "totalchol", "trig,", "YKL")
    print(length(pheno))
	# loop through all phenotypes to get output files
    for (p in 1:length(pheno)){
    system(paste("/lustre/beagle2/ober/resources/opt/bin/gemma -g diffXmp_",phen,"_", snp, ".txt -p phen_", phen, "_",num,".txt -n ",p," -k ",phen,"_",num,"relatedness -lmm 4 -notsnp -c cov_age_sex_diffXmp_",phen,"_",snp,".txt -o ",p,"_",pheno[p],"_",num,"_",chr,"_",subnum,"_",snp,"_",phen, "_bimbam_difference_allcovs ", sep = ""), wait = T)
    }
										
}


