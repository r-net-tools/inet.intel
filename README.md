# inet.intel  

## Description
The goal of inet.intel is to get updated internet threats as list of IOCs based on IP adresses, domains and URLs.
It's just a PoC based on github list [Awesome Threat Intelligence](https://github.com/hslatman/awesome-threat-intelligence#sources).
  
### C&C Tracker  
Reference:  
Raw Source: http://osint.bambenekconsulting.com/feeds/c2-ipmasterlist.txt  

### MalwareDomains.com  
Reference:  
Raw Source: http://mirror1.malwaredomains.com/files/justdomains  

### PhishTank  
Reference:  
Raw Source: http://data.phishtank.com/data/online-valid.csv   

### RansomTracker  
Reference:  
Raw Source:  

  - https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt  
  - https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt  
  - https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt  

### Disposable Email Domains  
Reference:  
Raw Source: https://raw.githubusercontent.com/martenson/disposable-email-domains/master/disposable_email_blacklist.conf  

### Firehole  
Reference:  
Raw Source: https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset  
This source includes:  

  - bambenek_c2  
  - dshield  
  - feodo  
  - fullbogons  
  - spamhaus_drop  
  - spamhaus_edrop  
  - sslbl  
  - zeus_badips  
  - ransomware_rw  

This package download, parse and join all information to `data.frame` and save it as CSV.  
  
### ***NOTE: Most of them will block your IP if you try to download more often than every 30 minutes.  ***
  
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
