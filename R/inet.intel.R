#' inet.intel
#'

#' Get threats data.frame
#'
#' @return data.frame
#' @export
GetThreats <- function(){
  dowload.time <- Sys.time()
  df.cc <- inet.intel::GetCCData()
  df.mot <- inet.intel::GetMOTData()
  df.mwd <- inet.intel::GetMWDData()
  df.ptd <- inet.intel::GetPTDData()
  df.rsw <- inet.intel::GetRSWData()
  df.tor <- inet.intel::GetTorData()

  # Tidy df.cc
  df.cc <- dplyr::mutate(df.cc,
                         raw.descr = jsonlite::toJSON(list(descr = descr,
                                                           timestamp = timestamp,
                                                           ref = ref)))
  df.cc <- df.cc[,c("ip", "raw.descr")]
  df.cc$type <- as.factor(rep("ip", nrow(df.cc)))
  df.cc$source <- as.factor(rep("osint.bambenekconsulting.com", nrow(df.cc)))
  df.cc$timestamp <- rep(dowload.time, nrow(df.cc))
  names(df.cc) <- c("ioc","source.info","type", "source", "timestamp")
  df.cc <- df.cc[,c("ioc","type","source", "timestamp", "source.info")]
  df.cc$ioc <- as.character(df.cc$ioc)

  # Tidy df.mot
  df.mot$type <- as.factor(rep("domain", nrow(df.mot)))
  df.mot$source <- as.factor(rep("martenson/disposable-email-domains", nrow(df.mot)))
  df.mot$timestamp <- rep(dowload.time, nrow(df.mot))
  names(df.mot) <- c("ioc","type", "source", "timestamp")
  df.mot$source.info <- as.factor(rep(NA, nrow(df.mot)))

  # Tidy df.mwd
  df.mwd$type <- as.factor(rep("domain", nrow(df.mwd)))
  df.mwd$source <- as.factor(rep("malwaredomains.com", nrow(df.mwd)))
  df.mwd$timestamp <- rep(dowload.time, nrow(df.mwd))
  names(df.mwd) <- c("ioc","type", "source", "timestamp")
  df.mwd$source.info <- as.factor(rep(NA, nrow(df.mwd)))

  # Tidy df.ptd
  df.ptd <- dplyr::mutate(df.ptd,
                         raw.descr = jsonlite::toJSON(list(phish_id = phish_id,
                                                           phish_detail_url = phish_detail_url,
                                                           submission_time = submission_time,
                                                           verified = verified,
                                                           verification_time = verification_time,
                                                           online = online,
                                                           target = target)))
  df.ptd <- df.ptd[,c("url", "raw.descr")]
  df.ptd$type <- as.factor(rep("url", nrow(df.ptd)))
  df.ptd$source <- as.factor(rep("phishtank.com", nrow(df.ptd)))
  df.ptd$timestamp <- rep(dowload.time, nrow(df.ptd))
  names(df.ptd) <- c("ioc","source.info","type", "source", "timestamp")
  df.ptd <- df.ptd[,c("ioc","type","source", "timestamp", "source.info")]
  df.ptd$ioc <- as.character(df.ptd$ioc)

  # Tidy df.rsw
  df.rsw$source <- as.factor(rep("ransomwaretracker.abuse.ch", nrow(df.rsw)))
  df.rsw$timestamp <- rep(dowload.time, nrow(df.rsw))
  names(df.rsw) <- c("ioc","type", "source", "timestamp")
  df.rsw$source.info <- as.factor(rep(NA, nrow(df.rsw)))


  # Join data
  df <- rbind(df.cc, df.mot, df.mwd, df.ptd, df.rsw)

  return(df)
}