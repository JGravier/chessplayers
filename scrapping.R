library(tidyverse)
library(rvest)
library(stringr)
library(glue)
library(httr) # for timeout option response
library(jsonlite)

##### Chessmetrics #####
urlbase <- "http://www.chessmetrics.com/cm/DL/DL{thispage}.htm"

list_of_results <- list()

for (thispage in 2:588) {
  thisurl <- glue(urlbase) %>% as.character() %>% URLencode()
  print(thisurl)
  thisurlread <- read_html(x = thisurl)
  
  dateranking <- thisurlread %>% 
    html_element("p:nth-child(2)") %>% 
    html_element("font:nth-child(5)") %>% 
    html_text()  %>%
    str_remove_all(string = ., pattern = "\r\n") %>% 
    str_remove_all(string = ., pattern = "Top 10 active players as of ")
  
  tableauranking <- thisurlread %>% 
    html_element("div:nth-child(5)") %>% 
    html_element("center:nth-child(1)") %>% 
    html_element("table") %>% 
    html_table() %>%
    select(X1, X2, X3, X7) %>%
    filter(X1 != "#") %>%
    select(-X1) %>%
    rename(Player = X2,
           Rating = X3,
           Age = X7) %>%
    mutate(dateranking = dateranking)
  
  list_of_results[[thispage]] <- tableauranking
}

results <- data.table::rbindlist(l = list_of_results) %>%
  as_tibble() %>%
  group_by(dateranking) %>%
  mutate(ranking = row_number())

write.csv(x = results, file = "csv/ranking_chessplayers_1851_2001.csv", row.names = FALSE)
openxlsx::write.xlsx(x = results, file = "csv/ranking_chessplayers_1851_2001.xlsx", overwrite = TRUE)

