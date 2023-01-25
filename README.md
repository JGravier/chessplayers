
### Chess players rating and ranking

[![License:
CC-BY](https://img.shields.io/badge/License-CCBY-blue.svg)](http://creativecommons.org/licenses/by/4.0/)

#### Objectives

This repo aims to compile different datasets related to chess players’
ratings and rankings over time. The data are extracted from several
sources:

1.  since 1851 to September 2001 (annual, quarterly and monthly
    snapshots): scraping [chessmetrics old
    website](http://www.chessmetrics.com/cm/OldIndex.html) created by
    [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas). Rate
    calculation is
    [chessmetrics](https://en.wikipedia.org/wiki/Chessmetrics). Output
    is stored as .csv in [csv
    file](https://github.com/JGravier/chessplayers/tree/main/csv).

2.  since September 2001 to December 2004 (monthly snapshots): scraping
    [chessmetrics new
    website](http://www.chessmetrics.com/cm/CM2/Introduction.asp?Params=199510SSSSS3S000000000000111000000000000010100)
    created by [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas).
    Rate calculation is
    [chessmetrics](https://en.wikipedia.org/wiki/Chessmetrics). Output
    is stored as .csv in [csv
    file](https://github.com/JGravier/chessplayers/tree/main/csv).

3.  since January 2001 to December 2019 (quarterly and monthly
    snapshots): [fork](https://github.com/JGravier/FIDE) from [FIDE Data
    Pull](https://github.com/anujdahiya24/FIDE) created by Anuj Dahiya
    in 2022 and based on International Chess Federation rates (FIDE).
    Rate calculation is [Elo rating
    system](https://en.wikipedia.org/wiki/Elo_rating_system). File
    output compilations of chess players’s standard ratings in .csv is
    compiled as .parquet format
    [compilationcsv.R](https://github.com/JGravier/FIDE/blob/main/compilationcsv.R)
    file (output .parquet is bigger than 500Mo and not stored on git).

#### Scraping infos for 1851-2001

Selection of second dataframe in page list, adding date of list and
ranking
![r](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;r "r")
as 1, 2, 3, …, n from rating of each specific date. Example: in
[December 31, 1851](http://www.chessmetrics.com/cm/DL/DL2.htm), scraping
dataframe from CSS selector:

    body > font:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > div:nth-child(5) > center:nth-child(1) > table:nth-child(4) > tbody:nth-child(1)

Output is like:

    ## # A tibble: 241,118 × 5
    ##    Player             Rating   Age dateranking    ranking
    ##    <chr>               <int> <dbl> <chr>            <int>
    ##  1 Kasparov, Garry K    2884  37.0 April 10, 2000       1
    ##  2 Anand, Viswanathan   2796  30.3 April 10, 2000       2
    ##  3 Kramnik, Vladimir    2793  24.8 April 10, 2000       3
    ##  4 Shirov, Alexei       2778  27.8 April 10, 2000       4
    ##  5 Leko, Peter          2765  20.6 April 10, 2000       5
    ##  6 Topalov, Veselin     2746  25.1 April 10, 2000       6
    ##  7 Ivanchuk, Vassily    2738  31.1 April 10, 2000       7
    ##  8 Adams, Michael       2736  28.4 April 10, 2000       8
    ##  9 Gelfand, Boris       2731  31.8 April 10, 2000       9
    ## 10 Kamsky, Gata         2716  25.9 April 10, 2000      10
    ## # … with 241,108 more rows

#### Scraping infos for 2001-2004

Selection of dataframe in page list, adding date of list and ranking
![r](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;r "r")
as 1, 2, 3, …, n from rating of each specific date. Example: in [January
2001](http://www.chessmetrics.com/cm/CM2/SingleMonth.asp?Params=199510SSSSS3S000000200101111000000000000010100),
scraping dataframe from CSS selector:

    body > form:nth-child(1) > table:nth-child(4)

Output is like:

    ## # A tibble: 241,118 × 5
    ##    Player             Rating   Age dateranking    ranking
    ##    <chr>               <int> <dbl> <chr>            <int>
    ##  1 Kasparov, Garry K    2884  37.0 April 10, 2000       1
    ##  2 Anand, Viswanathan   2796  30.3 April 10, 2000       2
    ##  3 Kramnik, Vladimir    2793  24.8 April 10, 2000       3
    ##  4 Shirov, Alexei       2778  27.8 April 10, 2000       4
    ##  5 Leko, Peter          2765  20.6 April 10, 2000       5
    ##  6 Topalov, Veselin     2746  25.1 April 10, 2000       6
    ##  7 Ivanchuk, Vassily    2738  31.1 April 10, 2000       7
    ##  8 Adams, Michael       2736  28.4 April 10, 2000       8
    ##  9 Gelfand, Boris       2731  31.8 April 10, 2000       9
    ## 10 Kamsky, Gata         2716  25.9 April 10, 2000      10
    ## # … with 241,108 more rows
