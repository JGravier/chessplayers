library(tidyverse)

#### data import ####
chessmetrics_1 <- read.csv(file = "csv/ranking_chessplayers_1851_2001.csv") %>%
  as_tibble()

#### reordering data ####
# objectives: make diverses .csv by coherent snapshots
datetime <- str_split_fixed(string = chessmetrics_1$dateranking, pattern = ",", n = 2) %>%
  as_tibble() %>%
  mutate(month = sub(" .*", "", V1)) %>%
  mutate(day = sub(".* ", "", V1)) %>%
  mutate(year =  str_sub(string = V2, start = 2, end = 5)) %>%
  select(day, month, year)

chessmetrics_1 <- chessmetrics_1 %>%
  bind_cols(datetime)

# yearly data
yearly <- chessmetrics_1 %>%
  filter(month == "December") %>%
  filter(as.numeric(day) > 24) # in 1999 and 2000, date is 25 and 27 of december

write.csv(x = yearly, file = "csv/ranking_chessplayers_1851_2000_yearly.csv")


# bi-annual data
biannual <- chessmetrics_1 %>%
  filter(year > 1948) %>%
  filter(month %in% c("December", "June")) %>%
  filter(as.numeric(day) > 24) # in 1999 to 2001, date are not 31/06

write.csv(x = biannual, file = "csv/ranking_chessplayers_1851_2001_biannual.csv")

# quarterly
quarterly <- chessmetrics_1 %>%
  filter(year > 1979) %>%
  filter(month %in% c("December", "June", "March", "September")) %>%
  filter(as.numeric(day) > 24)

write.csv(x = quarterly, file = "csv/ranking_chessplayers_1851_2001_quarterly.csv")
