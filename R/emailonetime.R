#' One time email domains
#' Ref: https://raw.githubusercontent.com/martenson/disposable-email-domains/master/disposable_email_blacklist.conf
#' MOT = Mail One Time

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadMOTData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "mailonetime.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://raw.githubusercontent.com/martenson/disposable-email-domains/master/disposable_email_blacklist.conf"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildMOTDataFrame <- function(local.file = paste(tempdir(),
                                                 "mailonetime.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F,
                 col.names = c("domain"), colClasses = c("character"))

  return(df)
}

#' Get Tornodes data.frame
#'
#' @return data.frame
#' @export
GetMOTData <- function(){
  lf <- DownloadMOTData()
  df <- BuildMOTDataFrame(local.file = lf)
  return(df)
}
