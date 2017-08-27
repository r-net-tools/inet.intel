#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadCCData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "cctracker.txt",
                    sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "http://osint.bambenekconsulting.com/feeds/c2-ipmasterlist.txt"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildCCDataFrame <- function(local.file = paste(tempdir(),
                                            "cctracker.txt",
                                            sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, sep = ",",
                 comment.char = "#",
                 header = FALSE,
                 col.names = c("ip", "descr", "timestamp", "ref"))
  return(df)
}

#' Get C&C data.frame
#'
#' @return data.frame
#' @export
GetCCData <- function(){
  lf <- DownloadCCData()
  df <- BuildCCDataFrame(local.file = lf)
  return(df)
}