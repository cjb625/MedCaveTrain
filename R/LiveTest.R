
## Example of an OOS test:  Use trained Random Forest on live streaming new data
payloadlogTest <- as.data.frame(cbind(0,0,0,0,0,0,0,0,0,0, FALSE))
colnames(payloadlogTest) <- c("accelX","accelY","accelZ","gyroX","gyroY","gyroZ","magX","magY","magZ", "iteration","Derail")
rownames(payloadlogTest) <- Sys.time()
library(RCurl)
for (i in 1:50) {
  
  #Sections pulls incomplete data from sensor tag and discards incomplete light data adn completes json string
  
  htmlData<- getURL("http://ti-tag.mybluemix.net/api/tidata")
  htmlData = paste(rev(substring(htmlData,1:nchar(htmlData),1:nchar(htmlData))),collapse="")
  htmlData = paste(rev(substring(htmlData,regexpr(',',htmlData)[1]+1:nchar(htmlData),regexpr(',',htmlData)[1]+1:nchar(htmlData))),collapse="")
  htmlData = paste(htmlData,',"iteration":"0","Derail":"0"}')
  jsonCollectedData <- fromJSON(htmlData)
  msg <- jsonCollectedData[6:16]
  
  
  json_file <- lapply(msg, function(x) {
    x[sapply(x, is.null)] <- NA
    unlist(x)
  })
  
  msg_dataFrame <- do.call("rbind", json_file)
  # View(msg_dataFrame)
  
  #latest issues
  #print(paste('Instantaneous Temperature:', format(msg$payload$d$temp), "degrees Celsius.  High Temperature Alert Status: ", highTemperatureFlag$payload))
  
  payloadlogTemp <- as.data.frame(msg)
  
  # rownames(payloadlogTemp) <- Sys.time()
  
  payloadlogTest <- rbind(payloadlogTest,payloadlogTemp)
  
  # XXtest <- payloadlogTemp[, c(1)] # Temperature Data
  # YYtest <- payloadlogTemp[, c(2)] # Alert Status
  
  ## GroomData
  XX <- payloadlogTemp[, c(1:9)] # Temperature Data
  YY <- payloadlogTemp[, c(11)] # Alert Status
  
  if (NCOL(XX)>1){
    XX <- XX[!(is.na(rownames(as.data.frame(XX)))),]
  }else {
    XX <- XX[!(is.na(rownames(as.data.frame(XX))))]
  }
  
  XX[is.na(XX)] <- 0  #Replace NAs by 0
  
  if (NCOL(YY)>1){
    YY <- YY[!(is.na(rownames(as.data.frame(YY)))),]
    YY[is.na(YY)] <- 0  #Replace NAs by 0
  }else {
    YY <- YY[!(is.na(rownames(as.data.frame(YY))))]
    YY[is.na(YY)] <- 0  #Replace NAs by 0
  }
  
  # for (kk in NCOL(XX)) {
  # class(XX[[kk]]) <- "numeric"}
  
  numsNumeric <- sapply(XX, is.numeric)
  nums2 <- !numsNumeric
  
  if (NCOL(XX)>1){
    X <- XX[,numsNumeric]
  }else {
    X <- XX[numsNumeric]
  }
  
  numsNumeric <- sapply(YY, is.numeric)
  nums2 <- !numsNumeric
  
  if (NCOL(YY)>1){
    Y <- YY[,numsNumeric]
  }else {
    Y <- YY[numsNumeric]
  }
  
  TestClassificationData <- as.data.frame(cbind(XX,YY))
  indx <- sapply(TestClassificationData,is.factor)   
  TestClassificationData[indx] <- lapply(TestClassificationData[indx], function(x) as.numeric(as.character(x)))
  tr.pred = treeresponse(ct, newdata=TestClassificationData, type="prob")  ## Assuming we test on the training data and not on out-of-sample data.  
  print(i)
  if (tr.pred>0.5) {
    print(paste('Conditional Interference Tree Prediction:  Derailed!'))
  } else {
    print(paste('Conditional Interference Tree Prediction:  Train is stable.'))
  }  
  
  WaitBeforeSampling(1)
}
