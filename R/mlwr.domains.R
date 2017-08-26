#' Malware domains
#' Ref: http://mirror1.malwaredomains.com/files/
#' http://mirror1.malwaredomains.com/files/justdomains

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadMWDData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "malware.domains.txt",
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
#' @export
GetMWDData <- function(){
  lf <- DownloadMWDData()
  df <- BuildMWDDataFrame(local.file = lf)
  return(df)
}
