#' Get threats data.frame
#'
#' @return data.frame
#' @export
GetThreats <- function(dstpath = tempdir()){
  dowload.time <- Sys.time()
  df.cc <- inet.intel::GetCCData()
  df.mot <- inet.intel::GetMOTData()
  df.mwd <- inet.intel::GetMWDData()
  df.ptd <- inet.intel::GetPTDData()
  df.rsw <- inet.intel::GetRSWData()
  #df.tor <- inet.intel::GetTorData()

  # Tidy df.cc
  raw.descr.cc <- apply(df.cc, 1,
                        function(x) as.character(jsonlite::toJSON(
                          list(descr = x[2],
                               timestamp = x[3],
                               ref = x[4]))))
  raw.descr.cc <- as.data.frame(raw.descr.cc)
  names(raw.descr.cc) <- c("raw.descr")
  df.cc <- cbind(df.cc, raw.descr.cc)
  df.cc <- df.cc[,c("ip", "raw.descr")]
  df.cc$type <- as.factor(rep("ip", nrow(df.cc)))
  df.cc$source <- as.factor(rep("osint.bambenekconsulting.com", nrow(df.cc)))
  df.cc$timestamp <- rep(dowload.time, nrow(df.cc))
  names(df.cc) <- c("ioc","source.info","type", "source", "timestamp")
  df.cc <- df.cc[,c("ioc","type","source", "timestamp", "source.info")]
  df.cc$ioc <- as.character(df.cc$ioc)
  df.cc$source.info <- as.character(df.cc$source.info)

  # Tidy df.mot
  df.mot$type <- as.factor(rep("domain", nrow(df.mot)))
  df.mot$source <- as.factor(rep("martenson/disposable-email-domains", nrow(df.mot)))
  df.mot$timestamp <- rep(dowload.time, nrow(df.mot))
  names(df.mot) <- c("ioc","type", "source", "timestamp")
  df.mot$source.info <- as.character(rep(NA, nrow(df.mot)))

  # Tidy df.mwd
  df.mwd$type <- as.factor(rep("domain", nrow(df.mwd)))
  df.mwd$source <- as.factor(rep("malwaredomains.com", nrow(df.mwd)))
  df.mwd$timestamp <- rep(dowload.time, nrow(df.mwd))
  names(df.mwd) <- c("ioc","type", "source", "timestamp")
  df.mwd$source.info <- as.character(rep(NA, nrow(df.mwd)))

  # Tidy df.ptd
  raw.descr.ptd <- apply(df.ptd, 1,
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
  df.ptd <- cbind(df.ptd, raw.descr.ptd)

  df.ptd <- df.ptd[,c("url", "raw.descr")]
  df.ptd$type <- as.factor(rep("url", nrow(df.ptd)))
  df.ptd$source <- as.factor(rep("phishtank.com", nrow(df.ptd)))
  df.ptd$timestamp <- rep(dowload.time, nrow(df.ptd))
  names(df.ptd) <- c("ioc","source.info","type", "source", "timestamp")
  df.ptd <- df.ptd[,c("ioc","type","source", "timestamp", "source.info")]
  df.ptd$ioc <- as.character(df.ptd$ioc)
  df.ptd$source.info <- as.character(df.ptd$source.info)

  # Tidy df.rsw
  df.rsw$source <- as.factor(rep("ransomwaretracker.abuse.ch", nrow(df.rsw)))
  df.rsw$timestamp <- rep(dowload.time, nrow(df.rsw))
  names(df.rsw) <- c("ioc","type", "source", "timestamp")
  df.rsw$source.info <- as.character(rep(NA, nrow(df.rsw)))

  # Join data
  df.threats <- rbind(df.cc, df.mot, df.mwd, df.ptd, df.rsw)

  # Save data.frame
  dstfile <- paste(dstpath, "df.threats.rda",
                   sep = ifelse(.Platform$OS.type == "windows", "\\", "/"))
  save(df.threats, file = dstfile)

  return(df.threats)
}