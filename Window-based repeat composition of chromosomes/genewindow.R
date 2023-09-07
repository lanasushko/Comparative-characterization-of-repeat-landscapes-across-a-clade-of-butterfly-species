
setwd("~/3 IBB vanessa/vcardANALYSES/genewindow analysis/")

windows=read.csv('genewindows-analysis.txt', sep=',')
windows20=read.csv('genewindows20-analysis.txt', sep=',')

library(stringr)
windows=data.frame(windows)

windows[c('tetype','tesubtype')]=str_split_fixed(windows$Repeat,'/',2)

windows20=data.frame(windows20)

windows20[c('tetype','tesubtype')]=str_split_fixed(windows20$Repeat,'/',2)
windows20=windows20[!grepl("LINE_L2", windows20$tetype),]

library(ggplot2)


ggplot(NULL) + 
  geom_col(data=windows, aes(x=Window, y=bp, fill=tetype)) + 
  scale_fill_manual(values=pal)

ggplot(NULL) + 
  geom_col(data=windows20, aes(x=Window, y=bp, fill=tetype)) + 
  scale_fill_manual(values=pal)
