
## Correlation Analysis - just for the sake of curiosity!
XX <- payloadlog[, c(1:13)] # Input Data Fields
YY <- payloadlog[, c(14:15)] # Alert Statuses :  Derailment flag and Instantaneous Derailment Flag are the two columns here.  The instantaneous derailment flag was computed before saving the RDATA files

if (NCOL(XX)>1){
  XX <- XX[!(is.na(rownames(as.data.frame(payloadlog)))),]
}else {
  XX <- XX[!(is.na(rownames(as.data.frame(payloadlog))))]
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

print(cor(X,Y))

library(gclus)
dta <- as.matrix(cbind(X,Y)) # get data and omit NA rows as well as any non-numeric columns
dta.r <<- (cor(dta))
# write.csv(dta.r, paste("corrResult.csv",sep="",collapse=""))
dta.r <- abs(cor(dta)) # get correlations
dta.r[is.na(dta.r)] <- 0
dta.col <- dmat.color(dta.r) # get colors
# reorder variables so those with highest correlation
# are closest to the diagonal
dta.o <- order.single(dta.r)

# dev.new()
# cpairs(dta, dta.o, panel.colors=dta.col, gap=.5, main="Variables Ordered and Colored by Correlation")
# pairs(dta,lower.panel=panel.smooth, upper.panel=panel.cor)


## Canonical Correlation:
cca <- cancor(X,Y)
print(cca[["cor"]])

# Highest correlation between pairs of linear combinations
print(cca[["cor"]][1])
# Corresponding linear combination in X (90 coefficients)
print(cca[["xcoef"]][,1])
# Corresponding linear combination in Y (10 coefficients)
print(cca[["ycoef"]][,1])

# Dot product of Y-coeffs with Y
if (NCOL(YY)>1){
  linCombY <- as.matrix(subset(Y, select=names(cca[["ycoef"]][,1]))) %*% cca[["ycoef"]][,1]
}else {
  linCombY <- as.matrix(Y) %*% cca[["ycoef"]][,1]
}

# Dot product of X-coeffs with X
if (NCOL(XX)>1){
  linCombX <- as.matrix(subset(X, select=names(cca[["xcoef"]][,1]))) %*% cca[["xcoef"]][,1]
}else {
  linCombX <- as.matrix(X) %*% cca[["xcoef"]][,1]
}

plot(linCombX,linCombY)
DF <- data.frame(VAR1 = linCombY, VAR2 = linCombX)
abline(fit <- lm(VAR1 ~ VAR2, data=DF), col='red')
legend("topright", bty="n", legend=paste("R2 is", format(summary(fit)$adj.r.squared, digits=4)))
print(summary(fit))
# plot(as.vector(X), as.vector(Y))

# write.csv(as.data.frame(cbind(XX,YY)), paste("TrainingData_temp.csv",sep="",collapse=""))




## Attempt 1 at learning:  Random forests Version4 - using instantaneous data for prediction using a buch of the data we have - not the time series!
## Conditional interference tree classifier for instantaneous events
## This tries to predict an alert contemporeneously as it occured
graphics.off()
YYtoPredict = as.data.frame(YY$DERAIL)
# YYtoPredict = as.data.frame(YY$derailmentEvent)
YYtoPredict = as.data.frame(YYtoPredict)
colnames(YYtoPredict) = "YY"
XXXtemp = as.data.frame(XX)
ClassificationData <- as.data.frame(cbind(XXXtemp,YYtoPredict));

# PARTY package
library(party)
frmla =  YY ~   accelX + accelY + accelZ + gyroX + gyroY + gyroZ + magX + magY + magZ
# frmla = YY ~ gyroX + gyroY + gyroZ + magX + magY + magZ 

(ct = ctree(frmla, data = ClassificationData))
dev.new()
plot(ct, main="Conditional Inference Tree")

#Table of prediction errors
ErrorDat <- table(predict(ct), ClassificationData$YY)
print(ErrorDat) #Confusion Matrix

#Table of prediction errors 2:  Threshold the continuous metric of classification outputted by the classification tree into a binary output using a threshold of <= 0.5 and > 0.5
predictionsTemp <- predict(ct)
predictionsTemp[predictionsTemp>0.5] = 1
predictionsTemp[predictionsTemp<=0.5] = 0

ErrorDat2 <- table(predictionsTemp, ClassificationData$YY)
print(ErrorDat2) #Confusion Matrix

# Estimated class probabilities
# Replace ClassificationData with the new XX and YY data for an out-of-sample (OOS) test!
tr.pred = predict(ct, newdata=ClassificationData, type="prob")  ## Assuming we test on the training data and not on out-of-sample data.  
print(paste0(((ErrorDat2[1,2] + ErrorDat2[2,1])/nrow(YY))*100, '% error in Alert Classification based on classification tree!')) # Classification error rate of the binary tree result

