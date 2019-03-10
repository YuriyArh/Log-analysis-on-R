###############################################################
# Aleksander Petrovskii e-mail: petr0vskjy.aleksander@gmail.com
# tel: +7-988-240-35-45
#
##########################################################
rm(list=ls())
library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)
#--------------- read the file ------------------------------------
setwd('/root/WorkR/Log-analysis-on-R/PostfixLogs')
mail.dataset <- read.table('result.csv',  quote="\"", header = T, sep=";")
#-----  we will filter appeals only by mail protocols -----
mail.dataset.with.proto <- filter(mail.dataset, Protocol != "N/A" )
# --- filter non-protocol calls (bots?) ---------
mail.dataset.with.bots <- filter(mail.dataset, Protocol == "N/A" )

# ------ consider the simplest protocol statistics. ----
proto.table <- table(mail.dataset.with.proto$Protocol) %>%
  as.data.frame() %>%
  arrange(Freq)%>%
  print()
theme_set(theme_bw()) # choose a black and white rendering scheme
proto.table$Var1 <- factor(proto.table$Var1, levels = proto.table$Var1)# align for ascending
ggplot(proto.table, aes(x=Var1, y=Freq)) + 
  geom_bar(stat="identity", fill="tomato3", color = "black") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title="Кол-во подключений по протоколам", 
       y="К-во подключений", 
       x="Почтовый протокол", 
       caption = "Source: result.csv") + 
  geom_text(position = position_stack(vjust = 0.5), aes(label = Freq)) 
# ----- find out how many unique e-mail addresses we have --- 
uniq.mail <- unique(mail.dataset.with.proto$Login)%>%
  length() %>%
  print()






