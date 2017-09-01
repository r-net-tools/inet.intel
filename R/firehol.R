#' CIDR Black list
#' https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset
#'

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadFHOData <- function(dstpath = tempdir()){
  local.file <- paste(dstpath, "firehol.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildFHODataFrame <- function(local.file = paste(tempdir(),
                                                 "firehol.txt",
                                                 sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  df <- read.csv(file = local.file, header = F, comment.char = "#",
                 col.names = c("ipcidr"), colClasses = c("character"))

  return(df)
}

#' Get firehol data.frame
#'
#' @return data.frame
GetFHOData <- function(dowload.time = Sys.time()){
  lf <- DownloadFHOData()
  df <- BuildFHODataFrame(local.file = lf)
  # Tidy df.fho
  df$type <- rep("cidr", nrow(df))
  df$type[iptools::is_ipv4(df$ipcidr)] <- rep("ip", sum(iptools::is_ipv4(df$ipcidr)))
  df$type <- as.factor(df$type)
  df$source <- as.factor(rep("iplists.firehol.org", nrow(df)))
  df$timestamp <- rep(dowload.time, nrow(df))
  names(df) <- c("ioc","type", "source", "timestamp")
  df$source.info <- as.character(rep(NA, nrow(df)))

  return(df)
}
