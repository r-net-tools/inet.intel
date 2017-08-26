#' Tor nodes data from Daniel (me@dan.me.uk)
#' No more than 1 query every 30min
#' Ref: https://www.dan.me.uk/tornodes

#' Download source data to local file
#'
#' @param dstpath path where source data will be stored, tempdir set as default.
#'
#' @return character, local path of downloaded file
DownloadTorData <- function(dstpath = tempdir()){
  local.file <- paste(tempdir(),
                      "tornodes.txt",
                      sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  source.raw.data <- "https://www.dan.me.uk/tornodes"
  download.file(url = source.raw.data, destfile = local.file)
  return(local.file)
}

#' Read raw data and returns as data.frame
#'
#' @param local.file
#'
#' @return data.frame
BuildTorDataFrame <- function(local.file = paste(tempdir(),
                                              "tornodes.txt",
                                              sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))){
  # Improve with one read: https://stackoverflow.com/questions/25680670/r-reading-lines-from-a-txt-file-after-a-specific-line
  df <- read.csv(file = local.file, header = F, sep = "|",
                 skip = grep("<!-- __BEGIN_TOR_NODE_LIST__ //-->", readLines(local.file)),
                 colClasses = c("character", "character", "factor", "factor", "factor", "integer", "factor", "character"),
                 col.names = c("ip", "name", "port.router", "port.directory", "flags", "uptime", "version", "contactinfo"))
  df <- df[iptools::is_ipv4(df$ip),]

  return(df)
}

#' Get Tornodes data.frame
#'
#' @return data.frame
#' @export
GetTorData <- function(){
  lf <- DownloadTorData()
  df <- BuildTorDataFrame(local.file = lf)
  return(df)
}

#' TODO
#'
#' TorProject
#'
#' Data source metrics: https://metrics.torproject.org/collector.html
#' Server desciptor: https://gitweb.torproject.org/torspec.git/tree/dir-spec.txt#n372
#'
#' TorProject exit nodes
#'
#' List of exit addresses: https://check.torproject.org/exit-addresses
#' How to parse exit-addresses: https://docs.spectx.com/pages/examples/parse/tor_exit_nodes_pattern.html
#'
