## Learn from CSV data on SensorTag acquisitions to predict the instant of a derailment event - how can we make this predict 'x' seconds in advance..?  Is this even possible..?
rm(list=ls())

library(jsonlite)
library(xts)
# require(xlsx)
require(openxlsx)
library(plyr) 
library(gdata)
library(DT)
library(readxl)

## Global function defintions
coln = function(x) { # A function to see column numbers
  y = rbind(seq(1, ncol(x)))
  colnames(y) = colnames(x)
  rownames(y) = "col.number"
  return(y)
}

WaitBeforeSampling <- function(x)
{
  p1 <- proc.time()
  Sys.sleep(x)
  proc.time() - p1 # The cpu usage should be negligible
}
# WaitBeforeSampling(3.7)

panel.cor <- function(x, y, digits=2, prefix="", cex.cor) 
{
  usr <- par("usr"); on.exit(par(usr)) 
  par(usr = c(0, 1, 0, 1)) 
  r <- cor(x, y)  #abs(cor(x, y)) 
  txt <- format(c(r, 0.123456789), digits=digits)[1] 
  txt <- paste(prefix, txt, sep="") 
  if(missing(cex.cor)) cex <- 0.8/strwidth(txt) 
  
  test <- cor.test(x,y) 
  # borrowed from printCoefmat
  Signif <- symnum(test$p.value, corr = FALSE, na = FALSE, 
                   cutpoints = c(0, 0.001, 0.01, 0.05, 0.1, 1),
                   symbols = c("****", "***", "**", "*", " ")) 
  
  text(0.5, 0.5, txt, cex = cex) #cex * r) #The latter bit resizes the text by the R value!
  text(.8, .8, Signif, cex=cex, col=2) 
}


## Live stream data to R or read in data to R or load RDATA files - Update the following two lines as needed for your run!
getNewData = 0
readFromExcel = 1 

if (getNewData) {  ## This section on getNewData is only applicable if we wish to collect live data from a SensorTag - the Json content being retrieved will require to be updated based on what data is being collected.  Below is an example only for Temperature Data
  payloadlog <- as.data.frame(cbind(0, FALSE))
  colnames(payloadlog) <- c("Temperature", "AlertStatus")
  rownames(payloadlog) <- Sys.time()
  
  for (i in 1:20) {
    msg <- fromJSON("http://sensortag001-pgm.mybluemix.net/api/latestMessage")
    highTemperatureFlag <- fromJSON("http://sensortag001-pgm.mybluemix.net/api/TemperatureAlert")
    
    json_file <- lapply(msg, function(x) {
      x[sapply(x, is.null)] <- NA
      unlist(x)
    })
    
    msg_dataFrame <- do.call("rbind", json_file)
    # View(msg_dataFrame)
    
    #latest issues
    print(paste('Instantaneous Temperature:', format(msg$payload$d$temp), "degrees Celsius.  Temperature Alert Status: ", highTemperatureFlag$payload))
    
    payloadlogTemp <- as.data.frame(cbind(msg$payload$d$temp, highTemperatureFlag$payload))
    colnames(payloadlogTemp) <- c("Temperature", "AlertStatus")
    rownames(payloadlogTemp) <- Sys.time()
    
    payloadlog <- rbind(payloadlog,payloadlogTemp)
    
    WaitBeforeSampling(1)
  }
  
  save.image(paste(getwd(), "/rawData",Sys.Date(), ".RData", sep = "", collapse = ""))
  rm(getNewData)
} else if (readFromExcel) { ## This is the mode we are using to read new data in from CSVs and then save them as RDATA files for the purpose of further work.
  AllXlsx = list.files('TrainData/', pattern = "*csv")
  
  for (i in 1:length(AllXlsx)) {
    filePath0 = 'TrainData/' #getwd()
    filePath1 = paste(filePath0,"/", AllXlsx[i], sep = "", collapse = "")
    
    file1Data1 =read.csv(file=filePath1,header=TRUE,sep=",")
    print(coln(file1Data1))
    save.image(paste(getwd(), "/", substr(AllXlsx[i],1,nchar(AllXlsx[i])-4), ".RData", sep = "", collapse = ""))
    # }
    
  }
} else {  ## Read in RDATA files which were prepared from CSVs in step 1, to proceed with machine learning model building etc.
  
  AllRdata = Sys.glob("*RData")       
  
  for (k in 1:length(AllRdata)) {
    load(AllRdata[k])    
    if (k==1) {
      fileNet <- file1Data1
    }
    else {
      fileNet <- rbind(fileNet,file1Data1)
      print(dim(fileNet))
    }
  }
  
  tempp <- cbind(fileNet, c(0,diff(fileNet$Derail)))
  colnames(tempp)[NCOL(tempp)] <- "derailmentEvent"  ##  An instantaneous derailment-event flag is computed from the derailment status column (which was manually entered into the CSVs!) after loading the saved RDATA files
  tempp$derailmentEvent[tempp$derailmentEvent<0] = 0
  
  payloadlog = tempp
  
}
