## Create XTS time-series object in R from the read data
library(xts)
temp <- xts(payloadlog, (as.POSIXct(payloadlog$iteration, origin = "1970-1-1", tz = "GMT")))
head(temp)          ## FINAL XTS for pattern matching
storage.mode(temp) <- "numeric"
temp <- temp[,c(1:13,14,15)]  #Keep the raw data and the final derailed and derailment event signal itself
timestampFake <- seq(c(ISOdate(1900,3,20)), by = "sec", length.out = NROW(temp))
rownames(temp) <- timestampFake
ttt2 <- xts(temp, (as.POSIXct(timestampFake, format="%Y-%m-%d %H:%M:%S")))
head(ttt2)          ## FINAL XTS for pattern matching
storage.mode(ttt2) <- "numeric"
payloadlog <- ttt2