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
GetCCData <- function(dowload.time = Sys.time()){
  lf <- DownloadCCData()
  df <- BuildCCDataFrame(local.file = lf)
  # Tidy
  raw.descr.cc <- apply(df, 1,
                        function(x) as.character(jsonlite::toJSON(
                          list(descr = x[2],
                               timestamp = x[3],
                               ref = x[4]))))
  raw.descr.cc <- as.data.frame(raw.descr.cc)
  names(raw.descr.cc) <- c("raw.descr")
  df <- cbind(df, raw.descr.cc)
  df <- df[,c("ip", "raw.descr")]
  df$type <- as.factor(rep("ip", nrow(df)))
  df$source <- as.factor(rep("osint.bambenekconsulting.com", nrow(df)))
  df$timestamp <- rep(dowload.time, nrow(df))
  names(df) <- c("ioc","source.info","type", "source", "timestamp")
  df <- df[,c("ioc","type","source", "timestamp", "source.info")]
  df$ioc <- as.character(df$ioc)
  df$source.info <- as.character(df$source.info)

  return(df)
}