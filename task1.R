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
########################################################################
 
 
  #--------------- read the file ------------------------------------
  setwd('/root/WorkR/Log-analysis-on-R/PostfixLogs')   
  #---# nrows=100 --> DEBUG ITEM, MUST BE DELETED BEFORE DEPLOY!!!
  mail.dataset <- read.table('result3.csv',  quote="\"", header = T, sep=";", nrows = 35000)                             
                                                                                                                                                                                    
  # filter user connections
  user_connection_table <- filter(mail.dataset, Login != "N/A" ) %>%
    filter(Login !="") %>%
    filter(Process == "connect")
  # get a list of unique logins
  unique_logins_table <- (unique(user_connection_table$Login)) %>%
    as_tibble() %>%
    arrange(value) 
  # find multiply ip for login -----------------------
  # create empty dataframe
  mult_logins_user <- data.frame()
  # find e-mail addresses that have more than three IP
 
   pb <- txtProgressBar(min = 1, max = nrow(unique_logins_table), style = 3) 
  for (i in 1:nrow(unique_logins_table)) {
    number_of_ip <- find_multiply_ip_for_login(unique_logins_table$value[i], user_connection_table)
    e_mail <- as.character(unique_logins_table$value[i])
    if (number_of_ip > 2){
      #print(e_mail)
      #print(number_of_ip)
      setTxtProgressBar(pb, i)
      # datatable with e-mail addresses and the number of unique ip addresses
      mult_logins_user <- rbind( mult_logins_user, data.frame(e_mail, number_of_ip))
    }
  }
  length(mult_logins_user$e_mail) # number of e-mail
  table(mult_logins_user)  # static table of uniq ip
  # create data.frame for analysis
  pb <- txtProgressBar(min = 1, max = nrow(mult_logins_user), style = 3) 
  user_connection_table_ip <- data.frame()
  for (i in 1:nrow(mult_logins_user)) {
    user_connection_table_ip_temp <- filter(user_connection_table, Login == as.character(mult_logins_user$e_mail[i] ))
    user_connection_table_ip <- rbind( user_connection_table_ip, user_connection_table_ip_temp)
    setTxtProgressBar(pb, i)
  }
  # work with date -------
  # convert  user_connection_table_ip$Date to POSIXct format
  user_connection_table_ip$Date <-ymd_hms(user_connection_table_ip$Date)
  # and sort user_connection_table_ip by date-time
  user_connection_table_ip  <-   arrange(user_connection_table_ip, Date)
  
  #-----------------------------------------------------------------------
  # fix the time window and move it along the frame user_connection_table_ip 
  # inside each step we will check the connection from at least 
  # three unique ip-addresses, if the conditions are met, 
  # we display the rows in the summary table  user_connection_table_final
  #-----------------------------------------------------------------------
  
 # debug-zone-------- 
  start_time <- user_connection_table_ip$Date[1]
  
  user_connection_table_ip %>% 
    filter(Date == start_time )
  
  
  
  X1 <- user_connection_table_ip$Date[9] %>%
    ymd_hms()
  
  X2 <- user_connection_table_ip$Date[10] %>%
    ymd_hms()
    
  XXX <- X2 - X1
  XXX
  Q <- difftime(X2,X1,units="mins")
    
  
  X37 <- user_connection_table_ip$Date[37] %>%
    ymd_hms()
  
  X38 <- user_connection_table_ip$Date[38] %>%
    ymd_hms()
  
  Q <- difftime(X38,X37,units="mins")
  as.numeric(Q)  
  
  
  
    ## Create Time Sequence -
    x <- timeSequence(from = "2001-01-01", to = "2009-01-01", by = "day")
    
    ## Generate Periods -
    periods(x, "2m", "1m")
    periods(x, "52w", "4w")
    
    ## Roll Periodically -
    periodicallyRolling(x)
    
    ## Roll Monthly -
    monthlyRolling(x)
   
  