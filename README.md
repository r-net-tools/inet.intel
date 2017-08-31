# inet.intel

The goal of inet.intel is to get updated internet threats as list of IOCs based on IP adresses, domains and URLs.
It's just a PoC based on github list [Awesome Threat Intelligence](https://github.com/hslatman/awesome-threat-intelligence#sources).
  
This package download, parse and join all information to `data.frame` from:  
 - C&C Tracker  
 - MalwareDomains.com  
 - PhishTank  
 - RansomTracker  
 - Disposable Email Domains  
  
NOTE: Most of them will block your IP if you try to download more often than every 30 minutes.  
  
## Installation

You can install inet.intel from github with:


``` r
# install.packages("devtools")
devtools::install_github("r-net-tools/inet.intel")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(inet.intel)
inet.intel::UpdateThreats(dstpath = ".\\data", source.db = "all")
``` 

trying URL 'http://osint.bambenekconsulting.com/feeds/c2-ipmasterlist.txt'  
Content type 'text/plain' length unknown  
downloaded 48 KB  

trying URL 'https://raw.githubusercontent.com/martenson/disposable-email-domains/master/disposable_email_blacklist.conf'  
Content type 'text/plain; charset=utf-8' length 34221 bytes (33 KB)  
downloaded 33 KB  

trying URL 'http://mirror1.malwaredomains.com/files/justdomains'  
Content type 'application/octet-stream' length 672645 bytes (656 KB)  
downloaded 656 KB  

trying URL 'http://data.phishtank.com/data/online-valid.csv'  
Content type 'text/csv' length 5005934 bytes (4.8 MB)  
downloaded 4.8 MB  

trying URL 'https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt'  
Content type 'text/plain' length 50949 bytes (49 KB)  
downloaded 49 KB  

trying URL 'https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt'  
Content type 'text/plain' length 350910 bytes (342 KB)  
downloaded 342 KB  

trying URL 'https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt'  
Content type 'text/plain' length 4991 bytes  
downloaded 4991 bytes  

[1] "Join data..."  
[1] "Save data..."  
[1] ".\\data\\df.threats.rda"  
[1] ".\\data\\threats.csv"  

``` r
inet.intel::CheckIOC("mot....nepa")
```
``` json
[{"ioc":"mot....nepa","type":"domain","source":"malwaredomains.com","timestamp":"2017-09-01 00:21:26"}] 
```
``` r
inet.intel::CheckIOC("github.com")
```
``` json
[] 
``` 
``` r
inet.intel::CheckIOC("127.0.0.1")
```
``` json
[] 
``` 
