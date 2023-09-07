setwd("~/3 IBB vanessa/Repeat Landscape")

#V_cardui
landvcard=read.csv('landscape_card.csv', sep=';')

#V_atalanta
landvatal=read.csv('landscape_vatal.csv', sep=';')

library(ggplot2)
library(ggpubr)

colors2=c('#4472c4','#ed7d31','#a5a5a5','#ffc000','#5b9bd5','#70ad47','#997300','#264478')

landvcard$Type = factor(landvcard$Type, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Other','Unknown'))
landvatal$Type = factor(landvatal$Type, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Other','Unknown'))


vcard=ggplot(landvcard, aes(x=Kimura, y=Count, fill=Type)) +
  geom_col(width=1) + theme_classic() + labs(fill='Repeat class') +
  scale_fill_manual(values=colors2) + ylab('Number of base pairs') + xlab('Kimura substitution level (CpG adjusted)')
  #ggtitle('__')

vatal=ggplot(landvatal, aes(x=Kimura, y=Count, fill=Type)) +
  geom_col(width=1) + theme_classic() + labs(fill='Repeat class') +
  scale_fill_manual(values=colors2) + ylab('Number of base pairs') + xlab('Kimura substitution level (CpG adjusted)')
#ggtitle('__')

ggarrange(vcard,vatal, common.legend=T, legend='right')
