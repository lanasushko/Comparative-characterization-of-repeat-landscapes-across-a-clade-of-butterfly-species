
# minimap2 alignment with asm20
# the input are ilVanCard2.2 and ilVanAtal1.2 assemblies and the output is a .paf file

minimap2 -t 5 -x asm20 -o alignment.paf /home/ssushko/vanessa_genomes/complete_seqs/cardui_GCA_905220365.2/ncbi_dataset/data/GCA_905220365.2/GCA_905220365.2_ilVanCard2.2_genomic.fna /home/ssushko/vanessa_genomes/complete_seqs/atalanta_GCF_905147765.1/data/GCF_905147765.1/GCF_905147765.1_ilVanAtal1.2_genomic.fna