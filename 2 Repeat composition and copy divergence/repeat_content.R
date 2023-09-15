setwd("~/3 IBB vanessa/vcardANALYSES/repeat content")

datacardui=data.frame(class=c('DNA','LINE','Other','LTR','MITE','Other','RC','Other','rRNA','Satellite','Simple repeat','SINE','Other','Unknown','Non-repetitive'),
                      bpmasked=c(8889747,53582592,844905,17466087,25022684,66490,19526802,1813,187215,6345,4913332,9662479,632,21433225,263211100),
                      perc=c(2.09,12.61,0.20,4.11,5.89,0.02,4.60,0.00,0.04,0.00,1.16,2.27,0.00,5.05,61.96),
                      perc2=c('2.09%','12.61%','0.20%','4.11%','5.89%','0.02%','4.60%','0.00%','0.04%','0.00%','1.16%','2.27%','0.00%','5.05%','61.96%'))


dataatalanta=data.frame(class=c('DNA','LINE','Other','LTR','MITE','Other','RC','Other','rRNA','Satellite','Simple repeat','SINE','Other','Unknown','Non-repetitive'),
                      bpmasked=c(2636856,26247344,942406,8214838,7391869,44716,18262714,1821,1560774,8421,5451480,20163817,11376,22032522,257449595),
                      perc=c(2.09,12.61,0.20,4.11,5.89,0.02,4.60,0.00,0.04,0.00,1.16,2.27,0.00,5.05,61.96),
                      perc2=c('0.71%','7.09%','0.25%','2.22%','2.00%','0.01%','4.93%','0.00%','0.42%','0.00%','1.47%','5.44%','0.00%','5.95%','69.50%'))

# Load ggplot2
library(ggplot2)
library(ggrepel)
library(tidyverse)
library(grid)
library(cowplot)
theme_set(theme_cowplot())
library(data.table)
library(plyr)
library(dplyr)
library(scales)
library(forcats)
library(ggbreak) 
library(ggpubr)

datacardui$class = factor(datacardui$class, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Satellite','Simple repeat','rRNA','Other','Unknown','Non-repetitive'))
dataatalanta$class = factor(dataatalanta$class, levels=c('DNA','LINE','LTR','MITE','RC','SINE','Satellite','Simple repeat','rRNA','Other','Unknown','Non-repetitive'))


# Get the positions (for % markers)
# df2 <- datacardui %>% 
#   mutate(csum = rev(cumsum(rev(bpmasked))), 
#          pos = bpmasked/2 + lead(csum, 1),
#          pos = if_else(is.na(pos), bpmasked/2, pos))
# 
# df3 <- dataatalanta %>% 
#   mutate(csum = rev(cumsum(rev(bpmasked))), 
#          pos = bpmasked/2 + lead(csum, 1),
#          pos = if_else(is.na(pos), bpmasked/2, pos))

#colors=c('#4472c4','#ed7d31','#a5a5a5','#ffc000','#5b9bd5','#70ad47','#255e91','#9e480e','#636363','#997300','#264478','#43682b','#7cafdd','#c00000','#000000')
colors=c('#4472c4','#ed7d31','#a5a5a5','#ffc000','#5b9bd5','#70ad47','#255e91','#9e480e','#636363','#997300','#264478','#000000')


# Basic piechart
carduicontent=ggplot(datacardui, aes(x="", y=bpmasked, fill=class)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0, direction=-1) + theme_void() +
  #geom_text(aes(x=1.8,label = perc2), position=position_stack(vjust=0.5)) 
  # geom_label_repel(data = df2,
  #                  aes(y = pos, label = perc2, color=rep('black',15)),
  #                  segment.color='grey',
  #                  size = 4.5, nudge_x = 1, show.legend = FALSE) +
  scale_fill_manual(values=colors) +
  labs(fill='Repeat class')
  #scale_color_manual(values=rep('white',15))

atalantacontent=ggplot(dataatalanta, aes(x="", y=bpmasked, fill=class)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0, direction=-1) + theme_void() +
  #geom_text(aes(x=1.8,label = perc2), position=position_stack(vjust=0.5)) 
  #geom_label_repel(data = df3,
                   # aes(y = pos, label = perc2, color=rep('black',15)),
                   # segment.color='grey',
                   # size = 4.5, nudge_x = 1, show.legend = FALSE) +
  scale_fill_manual(values=colors) +
  labs(fill='Repeat class')
  #scale_color_manual(values=rep('white',15))

plot_grid(carduicontent,atalantacontent)
ggarrange(carduicontent,atalantacontent, common.legend=T, legend='right')
                     