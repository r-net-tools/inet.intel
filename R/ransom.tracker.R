#' Ransomware Tracker
#' Ref: https://ransomwaretracker.abuse.ch/blocklist/
#' Domain: https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt
#' URL: https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt
#' IP: https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt
#'

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadRWDData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "ransom.tracker.domains.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://ransomwaretracker.abuse.ch/downloads/RW_DOMBL.txt"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildRWDDataFrame <- function(local.file = paste(tempdir(),
                                                 "ransom.tracker.domains.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F, comment.char = "#",
                 col.names = c("ransom.ioc"), colClasses = c("character"))
  df$type <- rep("domain",nrow(df))
  df$source.info <- as.character(rep(NA, nrow(df)))

  return(df)
}

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadRWUData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "ransom.tracker.urls.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://ransomwaretracker.abuse.ch/downloads/RW_URLBL.txt"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildRWUDataFrame <- function(local.file = paste(tempdir(),
                                                 "ransom.tracker.urls.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F, comment.char = "#",
                 col.names = c("ransom.ioc"), colClasses = c("character"))
  df$type <- rep("url",nrow(df))
  # TODO: source.info stored as JSON
  df$source.info <- as.character(df$ransom.ioc)
  df$ransom.ioc <- urltools::url_parse(df$ransom.ioc)$domain

  return(df)
}

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadRWIData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "ransom.tracker.ips.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://ransomwaretracker.abuse.ch/downloads/RW_IPBL.txt"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildRWIDataFrame <- function(local.file = paste(tempdir(),
                                                 "ransom.tracker.ips.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F, comment.char = "#",
                 col.names = c("ransom.ioc"), colClasses = c("character"))
  df$type <- rep("ip",nrow(df))
  df$source.info <- as.character(rep(NA, nrow(df)))

  return(df)
}

#' Get ransom.tracker data.frame
#'
#' @return data.frame
GetRSWData <- function(dowload.time = Sys.time()){
  lf <- DownloadRWDData()
  df.d <- BuildRWDDataFrame(local.file = lf)
  lf <- DownloadRWUData()
  df.u <- BuildRWUDataFrame(local.file = lf)
  lf <- DownloadRWIData()
  df.i <- BuildRWIDataFrame(local.file = lf)

  df <- dplyr::bind_rows(df.d, df.u, df.i)
  df$type <- as.factor(df$type)

  # Tidy df.rsw
  df$source <- as.factor(rep("ransomwaretracker.abuse.ch", nrow(df)))
  df$timestamp <- rep(dowload.time, nrow(df))
  names(df) <- c("ioc","type", "source.info", "source", "timestamp")
  df <- df[,c("ioc","type", "source", "timestamp", "source.info")]

  return(df)
}
