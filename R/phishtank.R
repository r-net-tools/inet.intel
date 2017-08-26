#' PhisTank
#' Ref: https://www.phishtank.com/developer_info.php
#' http://data.phishtank.com/data/online-valid.csv

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadPTDData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "phishtank.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "http://data.phishtank.com/data/online-valid.csv"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildPTDDataFrame <- function(local.file = paste(tempdir(),
                                                 "phishtank.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = T,
                 colClasses = c("integer", "character", "character", "character", "factor", "character", "factor", "factor"))

  return(df)
}

#' Get Tornodes data.frame
#'
#' @return data.frame
#' @export
GetPTDData <- function(){
  lf <- DownloadPTDData()
  df <- BuildPTDDataFrame(local.file = lf)
  return(df)
}
