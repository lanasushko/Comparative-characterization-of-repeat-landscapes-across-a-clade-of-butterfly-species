setwd("~/3 IBB vanessa/Chromosome masking")

library(ggplot2)
library(tidyr)
library(dplyr)
library(forcats)
library(ggpubr)

#V_card
vcardchrs=read.csv('vcard_chromosome_masking.csv', header=TRUE, sep=';')
count=as.numeric(unlist(vcardchrs[1:32,3]))
bpmasked=as.numeric(unlist(vcardchrs[1:32,4]))
names=as.character(vcardchrs[1:32,1])
vcardchrsizes=as.numeric(unlist(vcardchrs[1:32,5]))

df=data.frame(names=factor(names, levels=unique(names)), count=count, bpmasked=bpmasked, vcardchrsizes=vcardchrsizes)

ggplot(df,aes(x=names, y = bpmasked,fill= count)) + 
  geom_col(position="dodge")

vcardchrplot=ggplot(df) + 
  geom_bar(aes(x=fct_reorder(names, bpmasked), y = vcardchrsizes),stat='identity', fill='white', color='black')+
  geom_col(aes(x=fct_reorder(names, bpmasked), y = bpmasked,fill= count),position="dodge") +
  theme_classic() + ylab('Length (bp)') + xlab('Chromosome') + labs(fill='Number of copies')

#V_atal
vatalchrs=read.csv('vatal_chromosomemasking.csv', header=TRUE, sep=';')
count=as.numeric(unlist(vatalchrs[1:32,2]))
bpmasked=as.numeric(unlist(vatalchrs[1:32,3]))
names=as.character(vatalchrs[1:32,1])
vatalchrsizes=as.numeric(unlist(vatalchrs[1:32,4]))

df=data.frame(names=factor(names, levels=unique(names)), count=count, bpmasked=bpmasked, vatalchrsizes=vatalchrsizes)

ggplot(df,aes(x=names, y = bpmasked,fill= count)) + 
  geom_col(position="dodge")

vatalchrplot=ggplot(df) + 
  geom_bar(aes(x=fct_reorder(names, bpmasked), y = vatalchrsizes),stat='identity', fill='white', color='black')+
  geom_col(aes(x=fct_reorder(names, bpmasked), y = bpmasked,fill= count),position="dodge") +
  theme_classic() + ylab('Length (bp)') + xlab('Chromosome') + labs(fill='Number of copies')

ggarrange(vcardchrplot,vatalchrplot, common.legend=T, legend='right')

### PER TYPE ###
#V_card
vcardtype=read.table('vcard_bptyperepeatsperchr_onlytype.txt', header=TRUE, sep=' ')

vcardtype=vcardtype[!grepl("CAJMZP020000001.1", vcardtype$chr),]
vcardtype=vcardtype[!grepl("CAJMZP020000002.1", vcardtype$chr),]
vcardtype=vcardtype[!grepl("MT", vcardtype$chr),]
vcardtype=vcardtype[!grepl("CAJMZP020000003.1", vcardtype$chr),]
vcardtype=vcardtype[!grepl("CAJMZP020000004.1", vcardtype$chr),]

vcardtype$type = factor(vcardtype$type, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Satellite','Simple_repeat','rRNA','Other','Unknown'))
vcardtype$chr = factor(vcardtype$chr, levels=c(25,30,11,29,16,27,7,20,'Z',17,26,15,18,28,21,14,23,1,6,4,9,24,22,12,19,2,8,13,5,3,10,'W'))
colors2=c('#4472c4','#ed7d31','#a5a5a5','#ffc000','#5b9bd5','#70ad47','#255e91','#9e480e','#636363','#997300','#264478')


ggplot(vcardtype) + 
  geom_col(aes(x=chr, y = bpmasked,fill= type),position="stack") +
  theme_classic() + ylab('Sequence covered (bp)') + xlab('Chromosome') + labs(fill='Repeat type') +
  scale_fill_manual(values=colors2) 



