#' PhisTank
#' Ref: https://www.phishtank.com/developer_info.php
#' http://data.phishtank.com/data/online-valid.csv

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadPTDData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "phishtank.txt",
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

#' Get phistank data.frame
#'
#' @return data.frame
GetPTDData <- function(dowload.time = Sys.time()){
  lf <- DownloadPTDData()
  df <- BuildPTDDataFrame(local.file = lf)
  # Tidy df.ptd
  raw.descr.ptd <- apply(df, 1,
                         function(x) as.character(jsonlite::toJSON(
                           list(phish_id = x[1],
                                phish_detail_url = x[3],
                                submission_time = x[4],
                                verified = x[5],
                                verification_time = x[6],
                                online = x[7],
                                target = x[8]))))
  raw.descr.ptd <- as.data.frame(raw.descr.ptd)
  names(raw.descr.ptd) <- c("raw.descr")
  df <- cbind(df[,c("url")], raw.descr.ptd)

  # TODO: add df$url inside json as ioc variable
  df$url <- urltools::url_parse(df$url)$domain

  df$type <- as.factor(rep("url", nrow(df)))
  df$source <- as.factor(rep("phishtank.com", nrow(df)))
  df$timestamp <- rep(dowload.time, nrow(df))
  names(df) <- c("ioc","source.info","type", "source", "timestamp")
  df <- df[,c("ioc","type","source", "timestamp", "source.info")]
  df$ioc <- as.character(df$ioc)
  df$source.info <- as.character(df$source.info)
  return(df)
}
