#' Return valid source options
#'
#' @return character
#' @export
ValidSources <- function() {
  valid <- c("all", "cc", "mot", "mwd", "ptd", "rsw", "fho")
  return(valid)
}

#' Get threats data.frame
#'
#' @export
UpdateThreats <- function(dstpath = tempdir(), source.db = "all"){
  valid <- ValidSources()
  source.db <- valid[valid %in% source.db]

  if (any(c("all","cc") %in% source.db)) {
    df.cc <- GetCCData()
  } else {
    df.cc <- NewIOC()
  }

  if (any(c("all","mot") %in% source.db)) {
    df.mot <- GetMOTData()
  } else {
    df.mot <- NewIOC()
  }

  if (any(c("all","mwd") %in% source.db)) {
    df.mwd <- GetMWDData()
  } else {
    df.mwd <- NewIOC()
  }

  if (any(c("all","ptd") %in% source.db)) {
    df.ptd <- GetPTDData()
  } else {
    df.ptd <- NewIOC()
  }

  if (any(c("all","rsw") %in% source.db)) {
    df.rsw <- GetRSWData()
  } else {
    df.rsw <- NewIOC()
  }

  if (any(c("all","fho") %in% source.db)) {
    df.fho <- GetFHOData()
  } else {
    df.fho <- NewIOC()
  }

  #df.tor <- inet.intel::GetTorData()

  # Join data
  print("Join data...")
  df.threats <- rbind(df.cc, df.mot, df.mwd, df.ptd, df.rsw, df.fho)

  # Save data.frame
  print("Save data...")
  dstfile <- paste(dstpath, "df.threats.rda",
                   sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  save(df.threats, file = dstfile)
  print(dstfile)
  dstfile <- paste(dstpath, "threats.csv",
                   sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  write.csv(x = df.threats, file = dstfile, quote = FALSE, row.names = FALSE)
  print(dstfile)
}

#' Returns empty IOC data.frame
#'
#' @return data.frame
#' @export
NewIOC <- function(){
  df <- data.frame(ioc = character(),
                   type = factor(),
                   source = factor(),
                   timestamp1 = character(),
                   timestamp2 = character(),
                   source.info = character(),
                   stringsAsFactors = FALSE)
  return(df)
}

#' Check if IOC is in data.frame. It returns info as json.
#'
#' @param ioc
#'
#' @return json
#' @export
CheckIOC <- function(ioc = "github.com") {
  selected <- grepl(pattern = paste(".*", ioc, ".*", sep = ""),
                    ignore.case = T, x = df.threats$ioc)
  if (any(selected)) {
    selected <- df.threats[selected,]
  } else {
    selected <- NewIOC()
  }
  selected <- jsonlite::toJSON(selected)
  return(selected)
}