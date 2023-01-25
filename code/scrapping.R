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
  mutate(ranking = row_number()) %>% # order of row in website is ordering by rates (descending), so row number <=> ranking
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
  mutate(ranking = row_number()) %>%
  ungroup()

write.csv(x = results, file = "csv/ranking_chessplayers_2001_2004.csv", row.names = FALSE)

##### FIDE rating: standard rating #####
`%ni%` <- Negate(`%in%`) # function inverse of %in%

urlbase <- "http://ratings.fide.com/download/standard_{thisurl}frl_xml.zip"

# creation of list of {thisurl} based on year and month (as 3 first letters)
year <- seq(19, 22, 1)
monthtibble <- tibble(month = c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"))

year_month_tibble <- tibble(month_year = as.character())

for (i in 1:length(year)) {
  year_month_tibble <- year_month_tibble %>%
    bind_rows(tibble(month_year = paste0(monthtibble$month, as.character(year[i]))))
}

year_month_tibble <- year_month_tibble %>%
  # filtering month already compiled by Anuj Dahiya
  filter(month_year %ni% c("jan19", "feb19", "mar19", "apr19", "may19", "jun19", "jul19", "aug19", "sep19"))

thisurl <- year_month_tibble$month_year


# empty list and loop to generate list of dataframes
list_of_results <- list()

for (i in 1:length(thisurl)) {
  thisurl2 <- glue(urlbase) %>% as.character() %>% URLencode()
  print(thisurl2[i])
  thisurldownload <- download.file(url = thisurl2[i], "temp_data.zip")
  
  unzip(zipfile = "temp_data.zip")
  
  # xml data
  xmlranking <- read_xml(x = paste0("standard_", thisurl[i], "frl_xml.xml"))
  
  # extract infos from xml files (they are very nested)
  xmlranking <- xmlranking %>% 
    as_list()
  
  tableauranking <- tibble(ID_Number = character(), Name = character(), Rating = character())
  
  length(xmlranking$playerslist)
  
  for (j in 1:length(xmlranking$playerslist)) {
    
    baseline <- xmlranking$playerslist[j]$player
    
    compilation <- tibble(
      ID_Number = as.character(unlist(baseline$fideid)), # very ugly: preventing empty list
      Name = as.character(baseline$name), 
      Rating = as.character(unlist(baseline$rating)),
      dateranking = thisurl[i]
    )
    
    tableauranking <- tableauranking %>%
      bind_rows(compilation)
    
  }
  
  list_of_results[[i]] <- tableauranking
}

results <- rbindlist(l = list_of_results) %>%
  as_tibble() %>%
  group_by(dateranking) %>%
  arrange(desc(Rating), .by_group = TRUE) %>%
  mutate(ranking = rank(x = Rating, ties.method = "max")) %>%
  ungroup()

write_parquet(x = results, sink = "FIDE_standard_compilations.parquet")
