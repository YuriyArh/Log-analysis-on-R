rm(list=ls())
library(tidyr)
library(dplyr)
library(stringr)
library(ggplot2)
# ======================== чистка данных ============================
#--------------- прочитаем файл ------------------------------------
setwd('/root/WorkR/LogAnalysisOnR')
mail.dataset <- read.table('result.csv',  quote="\"", header = T, sep=";")
#-----  выделим обращения только по почтовым протоколам -----
mail.dataset.with.proto <- filter(mail.dataset, Protocol != "N/A" )
# --- отфильтруем обращения не по протоколам (боты?) ---------
mail.dataset.with.bots <- filter(mail.dataset, Protocol == "N/A" )

# ------ помотрим простейшую статистику по протколам ----
proto.table <- table(mail.dataset.with.proto$Protocol) %>%
  as.data.frame() %>%
  arrange(Freq)%>%
  print()
theme_set(theme_bw()) # выберем скромную черно-белую схему визуализации
proto.table$Var1 <- factor(proto.table$Var1, levels = proto.table$Var1)# выровняем для отображения по возрастанию
ggplot(proto.table, aes(x=Var1, y=Freq)) + 
  geom_bar(stat="identity", fill="tomato3", color = "black") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  labs(title="Кол-во подключений по протоколам", 
       y="К-во подключений", 
       x="Почтовый протокол", 
       caption = "Source: result.csv") + 
  geom_text(position = position_stack(vjust = 0.5), aes(label = Freq)) 
# ----- узнаем сколько у нас уникальных e-mail адресов --- 
uniq.mail <- unique(mail.dataset.with.proto$Login)%>%
  length() %>%
  print()
#----  кол-во подключений ----





