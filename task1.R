###############################################################
# Aleksander Petrovskii e-mail: petr0vskjy.aleksander@gmail.com
# tel: +7-988-240-35-45
# #task1 
#   need to find users who have logged in more than 3 times
#   from different IP addresses for a period of 5 minutes.
#   url: https://github.com/YuriyArh/Log-analysis-on-R/projects/1#card-18248943
##########################################################
rm(list=ls())
library(tidyr)
library(dplyr)
library(tibble)

library(stringr)
library(ggplot2)
library(lubridate)
library(tcltk2)
######################### Functions() ###############################

#------------ find_multiply_ip_for_login(login, d_frame)---------------
#the function determines the number of unique addresses 
#from which the connection to the mail server occurred
# 
# arg1 -> login: email adress, typof -> integer
# arg2 -> d_frame: postfix data frame -> data.frame
# return _> number of uniq IP-adress for email addresses -> integer
#--------------------------------------------------------------

find_multiply_ip_for_login <- function(login, d_frame) {

  number_of_ip <- d_frame %>%
    filter(Login==login) %>%
    distinct(rip)%>%
    count()
  return(number_of_ip$n)

}
#------------ find_unique_mail(d_frame)---------------
# the function find list of unique e-mail login`s in dataframe d_frame
# 
# arg1   -> d_frame: postfix data frame -> data.frame
# return -> unique.e_mail -> data.frame
#--------------------------------------------------------------

find_unique_e.mail <- function(d_frame) {

  unique.e_mail <- (unique(d_frame$Login)) %>%
    as_tibble() %>%
    arrange(value)
  return(unique.e_mail)

}
#---------------------------------------------------------------------
########################################################################


#--------------- read the file ------------------------------------
setwd('/home/petr0vsk/WorkR/Log-analysis-on-R/PostfixLogs')   
#---# nrows=35000 --> DEBUG ITEM, MUST BE DELETED BEFORE DEPLOY!!!
#  login is true
mail.dataset <- read.table('result3.csv',  quote="\"", header = T, sep=";")  %>%
  filter(Process.condition == 'login' )
# work with date -------
# convert  user_connection_table_ip$Date to POSIXct format
mail.dataset$Date <-ymd_hms(mail.dataset$Date)
# and sort user_connection_table_ip by date-time
mail.dataset  <-   arrange(mail.dataset, Date)

#-----------------------------------------------------------------------
# зафикируем временное окно и будем сдвигать его от начальной к конечной
# точке по времени исходного датасета mail.dataset
# размер окна определяется переменной window_size, размерность окна - минуты
# найденный срез сохраняем во фрейм delta_time_mail.dataset для дальнейшего
# анализа
# от исходного датафрейма отрезаем срез и так до тех пор, пока длина исх.датафрейма != 0
#-----------------------------------------------------------------------
window_size = 5 # размер окна поиска 5 минут
# подготовим  временный датафрейм в котором будем хранить срез за 5 минут
delta_time_mail.dataset <- data.frame()
# общий результирующий фрейм ля краткой информации: логин, количество IP
short_final_table <- data.frame()
#colnames(short_final_table, c("login", "quantity__ip", "delta_time", "time_begin", "time_end"))
# общий результирующий фрейм для полной информации по нелигитмным подключениям
long_final_table <- data.frame() 
# ###########################################
#browser()
while( nrow(mail.dataset) > 0 )  { # пока длина исх.датафрейма больше нуля
  for (i in 1: nrow(mail.dataset) ) {
    if (i == nrow(mail.dataset)) { # окно меньше 5 минут, но дошли до  конца датафрейма? 
      #print("(i == nrow(mail.dataset))")
      mail.dataset <- data.frame() # обнулим остаток исх.датафрейма  для выхода из while(..)
      break # выход из цикла по концу исходного датафрейма
    }
    # проверим разницу по времени между первой записью и той на которую указывает в цикле i
    delta_time <- (as.numeric( difftime(mail.dataset$Date[i],mail.dataset$Date[1],units="mins") ))
      if (delta_time > window_size ) { # окно больше 5 минут?
        #browser()
        print( paste0("delta_time = ", delta_time)  )
        delta_time_mail.dataset <- mail.dataset[1:(i-1),] # запомним срез для анализа
        mail.dataset %>% # удалим выделенный срез из основого датафрейма
          slice(-seq(1:(i-1))) -> mail.dataset
        # найдем в срезе список уник. логинов для проверки с каких IP был коннект
        unique_logins_table <- (unique(delta_time_mail.dataset$Login)) %>%
          as.data.frame()
        colnames(unique_logins_table) <- c("values")
        # найдем  e-mail  адреса/логины, которые коннектились с трех и более IP
        for (j in 1:nrow(unique_logins_table)) {
          number_of_ip <- find_multiply_ip_for_login(unique_logins_table$value[j], delta_time_mail.dataset)#найдем кол-во IP, с которых были подключения
          e_mail <- as.character(unique_logins_table$value[j])
          if (number_of_ip >= 3 ){ # количество уникальных IP в срезе за 5 минут > 3?
            # сохраним полную трассировку нелигитмных подключений за заданный период временни
            #browser()
            # подбробная информация
            temp_long_final_table <- data.frame()
            delta_time_mail.dataset %>%
              filter(Login == as.character(e_mail)) %>%
              bind_rows() -> temp_long_final_table
            long_final_table <- rbind(long_final_table, temp_long_final_table) # финальная таблица с полной информацией
            # краткая информация
            mult_logins_user <- data.frame(first(temp_long_final_table$Login), number_of_ip, delta_time, first(temp_long_final_table$Date), last(temp_long_final_table$Date) )
            short_final_table <- rbind(short_final_table, mult_logins_user) # финальная таблица с полной информацией
          }
        }
       break # выход из цикла если окно меньше 5 минут
       }#if (delta_time >.. 
    }# for (i in 1:nrow(mail.dataset..
}#while(nrow(mail.dataset.. 
# запомним результаты в csv-файл
colnames(short_final_table) <- c("login", "quantity__ip", "delta_time", "time_begin", "time_end")
write.csv(long_final_table,  file="long_final_table.csv")
write.csv(short_final_table, file="short_final_table.csv")







