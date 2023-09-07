
###############################################################################
############################  Diagonal dot plot  ##############################
###############################################################################
# We need to import the functions in the asynt.R script.
# You need to have the Intervals package installed on your system for this to work
source("asynt.R")

# We will start with a whole-genome diagnoal 'dot plot'

# First we import the alignment file. In this case we import .paf format, produced my minimap2.
# There are also options for importing blast table format (output format 6) and nucmer coords files
alignments <- import.paf("../../alignment_chrnumbers.paf")

#we can filter for only long alignments and long scaffolds, which is sometimes necessary when viewing things at a large scale
alignments_5k <- subset(alignments, Rlen>= 5000 & Qlen>= 5000)

# We also need to import information about the assembly contig lengths
# These muct be the reference and query genomes that you aligned
# Note that in blast the reference is called the target
ref_data <- import.genome(fai_file="../../vcardANALYSES/GENOME Vanessa_cardui-GCA_905220365.2/GCA_905220365.2_ilVanCard2.2_genomic.fna_chrnumbers.fai")
query_data <- import.genome(fai_file="../../vatalANALYSES/GCF_905147765.1_ilVanAtal1.2_genomic.fna_chrnumbers.fai")

#Now we can plot a diagonal alignment 'dot plot'
par(mar=c(1.5,1.5,0,0), xpd=NA)
plot.alignments.diagonal(alignments_5k, reference_lens=ref_data$seq_len, query_lens=query_data$seq_len)
