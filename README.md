
### Chess players rating and ranking

[![License:
CC-BY](https://img.shields.io/badge/License-CCBY-blue.svg)](http://creativecommons.org/licenses/by/4.0/)

#### Objectives

This repo aims to compile different datasets related to chess players’
ratings and rankings over time. The data are extracted from several
sources:

1.  since 1851 to September 2001: scraping [chessmetrics old
    website](http://www.chessmetrics.com/cm/OldIndex.html) created by
    [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas)

2.  since September 2001 to December 2004 (monthly): scraping
    [chessmetrics new
    website](http://www.chessmetrics.com/cm/CM2/Introduction.asp?Params=199510SSSSS3S000000000000111000000000000010100)
    created by [Jeff Sonas](https://en.wikipedia.org/wiki/Jeff_Sonas)

3.  since February 2015 to December 2022 (monthly for Standard and Blitz
    rating): scrapping [FIDE download
    list](https://ratings.fide.com/download_lists.phtml)

#### Scraping infos for 1851-2001

Selection of second dataframe in page list and adding date of list.
Example: in [December 31,
1851](http://www.chessmetrics.com/cm/DL/DL2.htm), scraping dataframe
from CSS selector:

    body > font:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(2) > div:nth-child(5) > center:nth-child(1) > table:nth-child(4) > tbody:nth-child(1)
