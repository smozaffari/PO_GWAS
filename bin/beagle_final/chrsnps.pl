#!/usr/bin/perl
# Author: Sahar Mozaffari
# Date: 
# Purpose: split bim file into chromosomes to run one chromosome at a time for newmodel. Called in format.sh
# Usage: perl chrsnps.pl <pheno>
print $ARGV[0];

my $trait = $ARGV[0];
#print $trait;
my $file = "paternal_imputed_".$trait.".bim";
my $cmd = qq(awk -F \"\t\" '\$1 == "1" { print \$2 }' $file  > chr1snps.txt);
#print $cmd;
system($cmd);
my $cmd2 =qq(awk -F \"\t\" '\$1 == "2" { print \$2 }' $file > chr2snps.txt);
system($cmd2);
my $cmd3 =qq(awk -F \"\t\" '\$1 ==  "3" { print \$2 }' $file > chr3snps.txt);
print $cmd3
system($cmd3);
my $cmd4 =qq(awk -F \"\t\" '\$1 == "4" { print \$2 }' $file > chr4snps.txt);
system($cmd4);
my $cmd5 =qq(awk -F \"\t\" '\$1 == "5" { print \$2 }' $file > chr5snps.txt);
system($cmd5);
my $cmd6 =qq(awk -F \"\t\" '\$1 == "6" { print \$2 }' $file > chr6snps.txt);
system($cmd6);
my $cmd7 =qq(awk -F \"\t\" '\$1 == "7" { print \$2 }' $file > chr7snps.txt);
system($cmd7);
my $cmd8 =qq(awk -F \"\t\" '\$1 == "8" { print \$2 }' $file > chr8snps.txt);
system($cmd8);
my $cmd9 =qq(awk -F \"\t\" '\$1 == "9" { print \$2 }' $file > chr9snps.txt);
system($cmd9);
my $cmd10 =qq(awk -F \"\t\" '\$1 == "10" { print \$2 }' $file > chr10snps.txt);
system($cmd10);
my $cmd11 =qq(awk -F \"\t\" '\$1 == "11" { print \$2 }' $file > chr11snps.txt);
system($cmd11);
my $cmd12 =qq(awk -F \"\t\" '\$1 == "12" { print \$2 }' $file > chr12snps.txt);
system($cmd12);
my $cmd13 =qq(awk -F \"\t\" '\$1 == "13" { print \$2 }' $file > chr13snps.txt);
system($cmd13);
my $cmd14 =qq(awk -F \"\t\" '\$1 == "14" { print \$2 }' $file > chr14snps.txt);
system($cmd14);
my $cmd15 =qq(awk -F \"\t\" '\$1 == "15" { print \$2 }' $file > chr15snps.txt);
system($cmd15);
my $cmd16 =qq(awk -F \"\t\" '\$1 == "16" { print \$2 }' $file > chr16snps.txt);
system($cmd16);
my $cmd17 =qq(awk -F \"\t\" '\$1 == "17" { print \$2 }' $file > chr17snps.txt);
system($cmd17);
my $cmd18 =qq(awk -F \"\t\" '\$1 == "18" { print \$2 }' $file > chr18snps.txt);
system($cmd18);
my $cmd19 =qq(awk -F \"\t\" '\$1 == "19" { print \$2 }' $file > chr19snps.txt);
system($cmd19);
my $cmd20 =qq(awk -F \"\t\" '\$1 == "20" { print \$2 }' $file > chr20snps.txt);
system($cmd20);
my $cmd21 =qq(awk -F \"\t\" '\$1 == "21" { print \$2 }' $file > chr21snps.txt);
system($cmd21);
my $cmd22 =qq(awk -F "\t" '\$1 == "22" { print \$2 }' $file > chr22snps.txt);
system($cmd22);

