setwd("C:/Users/susvi/Documents/3 IBB vanessa/genomic compartments")

library(ggplot2)
library(ggpubr)

# these inputs are csv files formatted as 'compartment;type;bp_masked;perc'
comp_card=read.csv('compartments_cardui.csv', sep=';')
comp_atal=read.csv('compartments_atalanta.csv', sep=';')

comp_card$type = factor(comp_card$type, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Satellite','Simple_repeat','rRNA', 'snRNA','Other','Unknown'))
comp_atal$type = factor(comp_atal$type, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Satellite','Simple_repeat','rRNA', 'snRNA','Other','Unknown'))

comp_card_geneflankinter=comp_card[comp_card$compartment  %in% c('gene','gene_flank','intergenic','ncRNA_gene','ncRNA_gene_flank'),]
comp_atal_geneflankinter=comp_atal[comp_atal$compartment  %in% c('gene','gene_flank','intergenic','ncRNA_gene','ncRNA_gene_flank'),]

comp_card_transcriptsubc=comp_card[comp_card$compartment  %in% c('five_prime_UTR','CDS','exon','intron','three_prime_UTR'),]
comp_atal_transcriptsubc=comp_atal[comp_atal$compartment  %in% c('five_prime_UTR','CDS','exon','intron','three_prime_UTR'),]

comp_card_transcriptsubc$compartment = factor(comp_card_transcriptsubc$compartment, levels=c('five_prime_UTR','CDS', 'exon', 'intron','three_prime_UTR'))
comp_atal_transcriptsubc$compartment = factor(comp_atal_transcriptsubc$compartment, levels=c('five_prime_UTR','CDS', 'exon', 'intron','three_prime_UTR'))

comp_card_bytransctype=comp_card[comp_card$compartment  %in% c('lnc_RNA','mRNA','ncRNA','rRNA','snoRNA','snRNA','tRNA'),]
comp_atal_bytransctype=comp_atal[comp_atal$compartment  %in% c('lnc_RNA','mRNA','ncRNA','rRNA','snoRNA','snRNA','tRNA'),]


colors2=c('#4472c4','#ed7d31','#a5a5a5','#ffc000','#5b9bd5','#70ad47','#255e91','#9e480e','#ddf542','#636363','#997300','#264478')

card_geneflankinter=ggplot(comp_card_geneflankinter,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2,) +ylab('% compartment') + xlab('Compartment')+ labs(fill='Repeat class') + scale_x_discrete(labels=c('gene', 'gene flank', 'intergenic', 'non-coding gene','non-coding gene flank')) + ylim(0,100) + theme_classic()

atal_geneflankinter=ggplot(comp_atal_geneflankinter,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2) +ylab('') + xlab('')+ labs(fill='Repeat class') + scale_x_discrete(labels=c('gene', 'gene flank', 'intergenic', 'non-coding gene','non-coding gene flank'))+ ylim(0,100)+ theme_classic()

card_transcriptsubc=ggplot(comp_card_transcriptsubc,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2,) +ylab('') + xlab('')+ labs(fill='Repeat class') + scale_x_discrete(labels=c("5' UTR",'CDS', 'exon', 'intron',"3' UTR"))+ ylim(0,100)+ theme_classic()

atal_transcriptsubc=ggplot(comp_atal_transcriptsubc,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2,) +ylab('') + xlab('')+ labs(fill='Repeat class') + scale_x_discrete(labels=c("5' UTR",'CDS', 'exon', 'intron',"3' UTR"))+ ylim(0,100)+ theme_classic()

card_bytranscrc=ggplot(comp_card_bytransctype,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2,) +ylab('') + xlab('')+ labs(fill='Repeat class') + scale_x_discrete(labels=c('lncRNA','mRNA','ncRNA','rRNA','snoRNA','snRNA','tRNA'))+ theme_classic()

atal_bytranscrc=ggplot(comp_atal_bytransctype,aes(x=compartment,y=perc, fill=type)) +
  geom_col(width=0.5) + scale_fill_manual(values=colors2,) +ylab('') + xlab('')+ labs(fill='Repeat class') + scale_x_discrete(labels=c('lncRNA','mRNA','ncRNA','rRNA','snoRNA','snRNA','tRNA'))+ ylim(0,100)+ theme_classic()

ggarrange(card_geneflankinter,atal_geneflankinter,card_transcriptsubc,atal_transcriptsubc,card_bytranscrc,atal_bytranscrc,nrow=3,ncol=2, common.legend = T)
