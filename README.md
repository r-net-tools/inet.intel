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
## basic example code
df.threats <- inet.intel::GetThreats(dstpath = ".\\data")
```
