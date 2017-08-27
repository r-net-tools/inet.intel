# inet.intel

The goal of inet.intel is to get updated internet threats as list of IOCs based on IP adresses, domains and URLs.

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
