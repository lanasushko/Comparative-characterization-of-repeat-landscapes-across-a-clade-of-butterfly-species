### This script contains commands to generate the genomic windows and calculate the number of bp that each repeat type covers in each chromosome and genomic window of 100KB

# generate windows with bedtools makewindows
bedtools makewindows -g /home/ssushko/analyses/atalanta/gene_annot/Vatalanta_genome_index.genome -w 100000 -i winnum > vatal_windows.bed

## FOR REPEATS ##

# intersect
bedtools intersect -a vatal_windows.bed -b /home/ssushko/analyses/atalanta/repeat_annot/GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_windows-repeats.txt

# Get the number of bp of overlap on each genomic window
awk '{print $1","$4","$18,$19}' intersect_windows-repeats.txt | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort -V > window100KB_analysis_repeats.txt

## FOR GENES ##

# intersect
bedtools intersect -a vatal_windows.bed -b /home/ssushko/analyses/atalanta/gene_annot/Vanessa_atalanta-GCA_905147765.1-2021_05-CDS.gff3 -wao > intersect_windows-cds.txt

# Get the number of bp of overlap on each genomic window
awk '{print $1","$4,$14}' intersect_windows-cds.txt | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort -V > window100KB_analysis_cds.txt

