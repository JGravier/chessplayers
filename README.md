
### Chess players rating and ranking

[![License:
CC-BY](https://img.shields.io/badge/License-CCBY-blue.svg)](http://creativecommons.org/licenses/by/4.0/)

#### Objectives

This repo aims to compile different datasets related to chess players’
ratings and rankings over time. The data are extracted from several
sources:

1.  since 1851 to September 2001: scraping [chessmetrics old
    website](http://www.chessmetrics.com/cm/OldIndex.html) created by
    [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas). Rate
    calculation is
    [chessmetrics](https://en.wikipedia.org/wiki/Chessmetrics). Output
    is stored as .csv in [csv
    file](https://github.com/JGravier/chessplayers/tree/main/csv).

2.  since September 2001 to December 2004 (monthly): scraping
    [chessmetrics new
    website](http://www.chessmetrics.com/cm/CM2/Introduction.asp?Params=199510SSSSS3S000000000000111000000000000010100)
    created by [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas).
    Rate calculation is
    [chessmetrics](https://en.wikipedia.org/wiki/Chessmetrics). Output
    is stored as .csv in [csv
    file](https://github.com/JGravier/chessplayers/tree/main/csv).

3.  since January 2001 to December 2019 (\~ monthly):
    [fork](https://github.com/JGravier/FIDE) from [FIDE Data
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
    ##    Player                Rating   Age dateranking       ranking
    ##    <chr>                  <int> <dbl> <chr>               <int>
    ##  1 Staunton, Howard        2768  42.0 December 31, 1851       1
    ##  2 Kieseritzky, Lionel A   2701  46.0 December 31, 1851       2
    ##  3 Anderssen, Adolf        2653  33.5 December 31, 1851       3
    ##  4 Horwitz, Bernhard       2593  44.6 December 31, 1851       4
    ##  5 Williams, Elijah        2550  42.1 December 31, 1851       5
    ##  6 von Jaenisch, Carl F    2525  38.4 December 31, 1851       6
    ##  7 Szén, Jósef             2512  46.5 December 31, 1851       7
    ##  8 Bird, Henry E           2495  21.5 December 31, 1851       8
    ##  9 von der Lasa, Tassilo   2477  33.2 December 31, 1851       9
    ## 10 Löwenthal, Johann J     2473  41.4 December 31, 1851      10
    ## # … with 241,108 more rows

#### Scraping infos for 2001-2004

Selection of dataframe in page list, adding date of list and ranking
![r](https://latex.codecogs.com/png.image?%5Cdpi%7B110%7D&space;%5Cbg_white&space;r "r")
as 1, 2, 3, …, n from rating of each specific date. Example: in [January
2001](http://www.chessmetrics.com/cm/CM2/SingleMonth.asp?Params=199510SSSSS3S000000200101111000000000000010100),
scraping dataframe from CSS selector:

    body > form:nth-child(1) > table:nth-child(4)

Output is like:

    ## # A tibble: 4,800 × 5
    ##    Player               Rating Age    dateranking ranking
    ##    <chr>                 <int> <chr>        <int>   <int>
    ##  1 Garry Kasparov         2850 37y9m       200101       1
    ##  2 Viswanathan Anand      2820 31y1m       200101       2
    ##  3 Vladimir Kramnik       2815 25y7m       200101       3
    ##  4 Peter Leko             2768 21y4m       200101       4
    ##  5 Alexander Morozevich   2757 23y6m       200101       5
    ##  6 Alexei Shirov          2750 28y6m       200101       6
    ##  7 Vassily Ivanchuk       2749 31y10m      200101       7
    ##  8 Michael Adams          2743 29y2m       200101       8
    ##  9 Evgeny Bareev          2739 34y2m       200101       9
    ## 10 Boris Gelfand          2738 32y7m       200101      10
    ## # … with 4,790 more rows
