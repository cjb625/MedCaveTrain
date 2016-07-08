ttt = as.data.frame(as.vector(t(as.matrix(data2)))) #transpose because the columns form the time series and the rows form different time series' at different instants of recording

## Create XTS data from file read data
# temp <- as.data.frame(as.numeric(as.character((file1Data1$time))))

timestampFake <- seq(c(ISOdate(1900,3,20)), by = "sec", length.out = NROW(temp))
rownames(temp) <- timestampFake
ttt2 <- xts(temp, (as.POSIXct(timestampFake, format="%Y-%m-%d %H:%M:%S")))
head(ttt2)          ## FINAL XTS for pattern matching
storage.mode(ttt2) <- "numeric"