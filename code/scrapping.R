library(tidyverse)
library(rvest)
library(stringr)
library(glue)
library(data.table)
library(stringi)
library(xml2)
library(arrow)

##### Chessmetrics: old website #####
urlbase <- "http://www.chessmetrics.com/cm/DL/DL{thispage}.htm"

# empty list and loop to generate list of dataframes
list_of_results <- list() # empty list

for (thispage in 2:588) {
  thisurl <- glue(urlbase) %>% as.character() %>% URLencode()
  print(thisurl)
  thisurlread <- read_html(x = thisurl) # reading html page (from 2 to 588)
  
  dateranking <- thisurlread %>% 
    html_element("p:nth-child(2)") %>% # CSS selector
    html_element("font:nth-child(5)") %>% # CSS selector
    html_text()  %>% # scraping text, here the elements from date
    # remove unsued elements of text
    str_remove_all(string = ., pattern = "\r\n") %>% 
    str_remove_all(string = ., pattern = "Top 10 active players as of ")
  
  # creation of dataframe
  tableauranking <- thisurlread %>% 
    html_element("div:nth-child(5)") %>% # CSS selector
    html_element("center:nth-child(1)") %>% # CSS selector
    html_element("table") %>% # CSS selector
    html_table() %>% # scraping dataframe
    select(X1, X2, X3, X7) %>%
    filter(X1 != "#") %>% # removing first row related to headers
    select(-X1) %>%
    rename(Player = X2, # rename col var
           Rating = X3,
           Age = X7) %>%
    mutate(dateranking = dateranking) # adding the date of the rating/ranking
  
  list_of_results[[thispage]] <- tableauranking
}

# compilation of list of dataframes
results <- rbindlist(l = list_of_results) %>%
  as_tibble() %>%
  group_by(dateranking) %>%
  arrange(desc(Rating), .by_group = TRUE) %>%
  mutate(ranking = rank(x = desc(Rating), ties.method = "min")) %>%
  ungroup()

# output
write.csv(x = results, file = "csv/ranking_chessplayers_1851_2001.csv", row.names = FALSE)


##### Chessmetrics:new website #####
urlbase <- "http://www.chessmetrics.com/cm/CM2/SingleMonth.asp?Params=199510SSSSS3S000000{thisurl}111000000000000010100"

# creation of list of {thisurl} based on year and month (as numbers)
year <- c(2001, 2002, 2003, 2004)
monthtibble <- tibble(month = seq(1, 12, 1)) %>%
  mutate(month = if_else(month < 10, as.character(str_c(0, month)), as.character(month)))

year_month_tibble <- tibble(month_year = as.character())

for (i in 1:length(year)) {
  year_month_tibble <- year_month_tibble %>%
    bind_rows(tibble(month_year = paste0(as.character(year[i]), monthtibble$month)))
}

thisurl <- year_month_tibble$month_year

# empty list and loop to generate list of dataframes
list_of_results <- list()

for (i in 1:length(thisurl)) {
  thisurl2 <- glue(urlbase) %>% as.character() %>% URLencode()
  print(thisurl2[i])
  thisurlread <- read_html(x = thisurl2[i])
  
  tableauranking <- thisurlread %>% 
    html_element("form:nth-child(1)") %>% 
    html_element("table:nth-child(4)") %>%
    html_table() %>% 
    rename(Player = X2, Rating = X3, Age = X4) %>% 
    filter(X1 != "") %>% 
    select(-X1, -X5) %>%
    mutate(dateranking = thisurl[i])
  
  list_of_results[[i]] <- tableauranking
}

results <- rbindlist(l = list_of_results) %>%
  as_tibble() %>%
  group_by(dateranking) %>%
  arrange(desc(Rating), .by_group = TRUE) %>%
  mutate(ranking = rank(x = desc(Rating), ties.method = "min")) %>%
  ungroup()

write.csv(x = results, file = "csv/ranking_chessplayers_2001_2004.csv", row.names = FALSE)
