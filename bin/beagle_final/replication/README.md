This folder/file was made to run opposite effect GWAS on one SNP/one phenotype at a time.

Code written in R. 
Need to have plink loaded to extract SNP from genotype files.
Used GEMMA (BIMBAM format) for association analyses.

Run:

Rscript newmodel_onephenotype.R {chr} {snpname} {phenotype} {pathtofamfilewithphenotypes}


###  1. Need plink files with genotypes
      - each individual has two ids in the plink files, one for maternal genotype and one for paternal genotype. 
            - ex. individual 1 has A from mom and C from dad, in plink file, 
               there will be two ids for individual 1: 12 and 11, where 12 has genotype A A and 11 has genotype C C 
               (haploid coded as diploid).
            
      -  plink bfiles are separated into paternal and maternal (mine named recode_mat_chr_{chr}_{phen}) (line #33 & #34)


###  2. {pathtofamfilewithphenotypes} is a separate fam file that has phenotypes 
        - (mine named {phen}_{chr}_maternal.fam} with maternal ids.
        - to make BIMBAM phenotype file to run association in GEMMA (rows = individuals, columns = phenotypes) :
        
               `cut -f7-30 -d" "  /tmp/sm/${PHENO}_maternal.fam  > /tmp/sm/phen_${PHENO}.txt `
              
###  3. relatedness matrix (additive model) to correct for population substructure in association analyses. In my file named {phen}relatedness.
        - Built as matrix to correspond to BIMBAM format of files that GEMMA accepts.
  
              
###  {chr} is chromosome SNP is on. Used in plink command to extract SNP.

###  {snpname} is identifier in plink file. Used in plink command to extract SNP.

###  {phenotype} is the name of the phenotype for output file and corresponding phenotype file (2. above).
  




#### GEMMA:
Xiang Zhou and Matthew Stephens (2012). Genome-wide efficient mixed-model analysis for association studies. Nature Genetics. 44: 821-824.

#### BIMBAM: 
Software here: http://www.haplotype.org/bimbam.html
Servin, B and Stephens, M (2007). Imputation-based analysis of association studies: candidate genes and quantitative traits. PLoS Genetics, 2007. 
