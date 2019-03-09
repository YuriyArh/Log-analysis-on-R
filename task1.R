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
library(stringr)
library(ggplot2)
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
########################################################################
 
 
  #--------------- read the file ------------------------------------
  setwd('/root/WorkR/Log-analysis-on-R/PostfixLogs')
  mail.dataset <- read.table('result.csv',  quote="\"", header = T, sep=";")
  
  # filter user connections
  user_connection_table <- filter(mail.dataset, Login != "N/A" ) %>%
    filter(Process == "connect")
  # get a list of unique logins
  unique_logins_table <- (unique(user_connection_table$Login)) %>%
    as_tibble() %>%
    arrange(value) 
  # find multiply ip for login -----------------------
  # create empty dataframe
  mult_logins_user <- data.frame()
  names(mult_logins_use)<-c("e_mail","number_of_ip")
  N <- length(unique_logins_table$value) 
  # find e-mail addresses that have more than three IP
  for (i in 1:N) {
    number_of_ip <- find_multiply_ip_for_login(unique_logins_table$value[i], user_connection_table)
    e_mail <- as.character(unique_logins_table$value[i])
    if (number_of_ip > 2){
      print(e_mail)
      print(number_of_ip)
      # datatable with e-mail addresses and the number of unique ip addresses
      mult_logins_user <- rbind( mult_logins_user, data.frame(e_mail, number_of_ip))
    }
  }
  length(mult_logins_user$e_mail) # number of e-mail
  table(mult_logins_user)  # static table of uniq ip
  # create data.frame for analysis
  user_connection_table_ip <- data.frame()
  Q <- length(mult_logins_user$e_mail)
  for (i in 1:Q) {
    #print(  as.character(mult_logins_user$e_mail[i] ))
    user_connection_table_ip_temp <- filter(user_connection_table, Login == as.character(mult_logins_user$e_mail[i] ))
    user_connection_table_ip <- rbind( user_connection_table_ip, user_connection_table_ip_temp)
  }
  
  
  
  
    