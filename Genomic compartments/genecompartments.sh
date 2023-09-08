### This script contains commands that count the number of bp that each repeat type cover in each genomic compartment

# 1 Change chromosome seq names to numbers because the gene annotation has this format. I did it with changenumbers.sh script for cardui

### Get the number of bp masked with repeats per each genomic compartment ###
# 2 Intersect gene annotation with repeat annotation
bedtools intersect -a Vanessa_cardui-GCA_905220365.2-2022_03-genes.gff3 -b GCA_905220365.2_ilVanCard2.2_genomic_chrnumbers.fna.out.gff -wao > intersect_genes-repeats.txt

# 3 Remove the intersections with chromosome region
grep -v 'ID=region' 

# 4 Remove the gene records that don't contain intersection with repeats
grep 'Target' intersect_genes-repeats_noregion.txt > intersect_genes-repeats_noregion_onlyintersectwithTEs.txt

# 5 Get the number of bp of overlap between each annotation and repeat
cut -f3,19 intersect_genes-repeats_noregion_onlyintersectwithTEs.txt | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > compartment-bpmasked.txt 

### Get the type of repeats and the bp they mask inside each genomic compartment ###
# Get a gff file containing the names of repeat classes (not only family names)
grep -v '##' GCA_905220365.2_ilVanCard2.2_genomic_chrnumbers.fna.out.gff > GCA_905220365.2_ilVanCard2.2_genomic_chrnumbers_no##.fna.out.gff

paste -d' ' GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##.fna.out.gff <(tail -n 804097 GCF_905147765.1_ilVanAtal1.2_genomic.fna.out | awk '{print $10" "$11}') > GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff

# Intersect as before
bedtools intersect -a Vanessa_cardui-GCA_905220365.2-2022_03-genes.gff3 -b GCA_905220365.2_ilVanCard2.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_genes-repeatswithnames.txt

# Remove the intersections with chromosome region
grep -v 'ID=region' intersect_genes-repeatswithnames.txt >intersect_genes-repeatswithnames_noregion.txt

# Remove the gene records that don't contain intersection with repeats
grep 'Target' intersect_genes-repeatswithnames_noregion.txt > intersect_genes-repeatswithnames_noregion_onlyintersectwithTEs.txt

# Get the number of bp of overlap between each gene annotation and repeat
paste <(cut -f3 intersect_genes-repeatswithnames_noregion_onlyintersectwithTEs.txt) <(cut -f18 intersect_genes-repeatswithnames_noregion_onlyintersectwithTEs.txt | cut -f6 -d' ') <(cut -f19 intersect_genes-repeatswithnames_noregion_onlyintersectwithTEs.txt) | awk '{print $1","$2,$3}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > compartment-bpmasked-repeatnames.txt

### Add introns and flanking regions to the gene annotation file ###

# Add introns with gt
/home/ssushko/repeatmasker_resources/genometools-1.5.9/bin/gt gff3 infile.gff -addintrons -retainids > outfile.gff

# Create index for bedtools flank
head -n 37 Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons.gff3 | awk '{print $2"\t"$4}' | sort -V > Vcardui_genome_index.genome

# Extract flanking regions (these regions can intersect with other genes and other annotations)
bedtools flank -i Vanessa_atalanta-GCA_905147765.1-2021_05-genes_withintrons_sorted_onlygenes.gff3 -g Vatalanta_genome_index.genome -b 1000 > Vanessa_atalanta-GCA_905147765.1-2021_05-geneflanks1KB.gff3

# Extract intergenic regions
# First, sort the gff and extract only gene annotations
grep '#' -v Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons.gff3 | grep 'ID=gene' | sort -k1,1V -k4,4n -k5,5n > Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons_sorted_onlygenes.gff3

# Obtain genome index file
head Vanessa_atalanta-GCA_905147765.1-2021_05-genes.gff3 -n 150 #more less 150 but later you have to remove the ones that are not chromosomic coordinates
awk '{print $1"\t"$3}' Vatalanta_genome_index.genome | sort -V > Vatalanta_genome_index.genomex #to obtain the 2-column file with chromosome names and lengths

# Extract intergenic with bedtools complement
bedtools complement -i Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons_sorted_onlygenes.gff3 -g Vcardui_genome_index.genome > Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons_intergenic.gff3

# Intersect intergenic
bedtools intersect -a ../gene_annot/Vanessa_cardui-GCA_905220365.2-2022_03-genes_withintrons_intergenic.bed -b ../repeat_annot/GCA_905220365.2_ilVanCard2.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_intergenic.txt

# Extrats repeat intersects
grep 'Target' intersect_intergenic.txt > intersect_intergenic_onlyintersectwithTEs.txt

# Counts intergenic
paste <(cut -f12 intersect_intergenic_onlyintersectwithTEs.txt | cut -f6 -d' ') <(cut -f13 intersect_intergenic_onlyintersectwithTEs.txt) | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > intergenic-bpmasked.txt


# Counts for gene flanks
paste <(cut -f3 intersect_geneflanks_onlyintersectwithTEs.txt) <(cut -f18 intersect_geneflanks_onlyintersectwithTEs.txt | cut -f6 -d' ') <(cut -f19 intersect_geneflanks_onlyintersectwithTEs.txt) | awk '{print $1","$2,$3}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > geneflanks-bpmasked.txt


#### ATALANTA ####

# I used the same procedure as with cardui to add introns, extract intergenic regions and gene flanks

# bedtools intersect genes and introns
bedtools intersect -a /home/ssushko/analyses/atalanta/gene_annot/Vanessa_atalanta-GCA_905147765.1-2021_05-genes_withintrons.gff3 -b /home/ssushko/analyses/atalanta/repeat_annot/GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_genesintrons.txt

# bedtools intersect intergenic
bedtools intersect -a /home/ssushko/analyses/atalanta/gene_annot/Vanessa_atalanta-GCA_905147765.1-2021_05-intergenic.bed -b /home/ssushko/analyses/atalanta/repeat_annot/GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_intergenic.txt

# bedtools intersect gene flanks
bedtools intersect -a /home/ssushko/analyses/atalanta/gene_annot/Vanessa_atalanta-GCA_905147765.1-2021_05-geneflanks1KB.gff3 -b /home/ssushko/analyses/atalanta/repeat_annot/GCF_905147765.1_ilVanAtal1.2_genomic_chrnumbers_no##_withrepeatnames.fna.out.gff -wao > intersect_geneflanks1KB.txt

# extract only the records where repeats intersect with genomic compartments -> this is done for all 3 intersect files except intergenic (for this one I only did the grep 'Target' part)
grep -v 'ID=region' intersect_genesintrons.txt | grep 'Target' > intersect_genesintrons_onlyintersectwithrepeats.txt

# extract counts for genesintrons and geneflanks (bp of each compartment masked by repeats)
paste <(cut -f3 intersect_genesintrons_onlyintersectwithrepeats.txt) <(cut -f18 intersect_genesintrons_onlyintersectwithrepeats.txt | cut -f6 -d' ') <(cut -f19 intersect_genesintrons_onlyintersectwithrepeats.txt) | awk '{print $1","$2,$3}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > genesintrons-bpmasked.txt

paste <(cut -f3 intersect_geneflanks1KB_onlyintersectwithrepeats.txt) <(cut -f18 intersect_geneflanks1KB_onlyintersectwithrepeats.txt | cut -f6 -d' ') <(cut -f19 intersect_geneflanks1KB_onlyintersectwithrepeats.txt) | awk '{print $1","$2,$3}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > geneflanks1KB-bpmasked.txt

# extract counts for intergenic regions (bp of each compartment masked by repeats)
paste <(cut -f12 intersect_intergenic_onlyintersectwithrepeats.txt | cut -f6 -d' ') <(cut -f13 intersect_intergenic_onlyintersectwithrepeats.txt) | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' | sort > intergenic-bpmasked.txt

#### OBTAIN COMPARTMENT SIZE FROM ANNOTATION ####

# Obtain the sizes of gene, intron and flank compartments
grep -v -E '#|ID=region' Vanessa_atalanta-GCA_905147765.1-2021_05-genes_withintrons.gff3 | awk '{print $3,($5-$4+1)}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' > genesintrons_compartment_sizes.txt

grep -v -E '#|ID=region' Vanessa_atalanta-GCA_905147765.1-2021_05-geneflanks1KB.gff3 | awk '{print $3,($5-$4+1)}' | awk '{arr[$1]+=$2} END {for (i in arr) {print i,arr[i]}}' > geneflanks1KB_compartment_sizes.txt

# Obtain the size of intergenic compartment
awk '{print $3-$2}' Vanessa_atalanta-GCA_905147765.1-2021_05-intergenic.bed | paste -s -d+ - | bc
