library(tidyverse)
library(purrr)
library(lubridate)

# reading in google trends data
files <- list.files(pattern="trends_up_to_", full.names=TRUE)
trends <- map_df(files, read_csv)
# date data
trends <- trends %>% mutate(startDate = ymd(str_sub(monthorweek, start = 1, end = 10)))
# index data
trends <- trends %>% group_by(schname, keyword) %>% mutate(stdInd = (index-mean(index)/sd(index)))
# read in scorecard data
cohorts <- read_csv("Most+Recent+Cohorts.csv")
IDName <- read_csv("id_name_link.csv")
# scorecard data
IDName <- IDName %>% group_by(schname) %>% mutate(n=n()) %>% filter(n < 2)
trends$schname <- stringr::str_trim(trends$schname)
df <- merge(x = IDName, y = trends, by="schname", all = TRUE)
df <- df %>% rename(OPEID = opeid)
df <- merge(x = df, y = cohorts, by = "OPEID", all = TRUE)

