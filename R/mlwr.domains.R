#' Malware domains
#' Ref: http://mirror1.malwaredomains.com/files/
#' http://mirror1.malwaredomains.com/files/justdomains

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadMWDData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "malware.domains.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "http://mirror1.malwaredomains.com/files/justdomains"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildMWDDataFrame <- function(local.file = paste(tempdir(),
                                                 "malware.domains.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F, comment.char = "#",
                 col.names = c("domain"), colClasses = c("character"))

  return(df)
}

#' Get Tornodes data.frame
#'
#' @return data.frame
GetMWDData <- function(dowload.time = Sys.time()){
  lf <- DownloadMWDData()
  df <- BuildMWDDataFrame(local.file = lf)
  # Tidy df.mwd
  df$type <- as.factor(rep("domain", nrow(df)))
  df$source <- as.factor(rep("malwaredomains.com", nrow(df)))
  df$timestamp <- rep(dowload.time, nrow(df))
  names(df) <- c("ioc","type", "source", "timestamp")
  df$source.info <- as.character(rep(NA, nrow(df)))

  return(df)
}
