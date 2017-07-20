p=0;

while IFS=" "  read -r line; do
#    echo $line                                                                                                                                                                                                                 
    declare -a genes=($line)
    for gene in "${genes[@]}"
    do
        p=$(($p+1))
        while IFS=" " read -r allsnp; do
            snp=$(echo $allsnp | cut -f2 -d" ")
#           echo $snp                                                                                                                                                                                                           
            awk '{print "1", $5}' Maternal.fam > cov_sex_${snp}.txt
#            plink --file Maternal_LCL_sigPOGWASsnps --snp $snp --silent --make-bed --out snp_recode_mat${snp}
#            plink --file Paternal_LCL_sigPOGWASsnps --snp $snp --silent --make-bed --out snp_recode_pat${snp}
#            cp Maternal.fam snp_recode_mat${snp}.fam
#            cp Paternal.fam snp_recode_pat${snp}.fam
            newp=$(($p+8))
           echo $newp                                                                                                                                                                                                         
            echo "gemma -bfile snp_recode_mat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o mat_${gene}_${snp}"
            echo "gemma -bfile snp_recode_pat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o pat_${gene}_${snp}"
            gemma -bfile snp_recode_mat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o mat_${gene}_${snp}
            wait
            gemma -bfile snp_recode_pat${snp} -n $newp  -km 1 -notsnp -miss 1  -k LCL_geneexpressionrelatedness -lmm 4  -c cov_sex_${snp}.txt  -o pat_${gene}_${snp}
            wait
#           rm snp_recode_pat${snp}.*                                                                                                                                                                                           
#           rm snp_recode_mat${snp}.*                                                                                                                                                                                           
#           rm cov_sex_${snp}.txt                                                                                                                                                                                               
        done < /group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_famfiles/$gene
    done
done < /group/ober-resources/users/smozaffari/POGWAS/data/expression_opposite/po_famfiles/tailgenenames
