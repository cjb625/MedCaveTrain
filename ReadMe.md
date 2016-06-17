PreloadSteps.R -- Runs all scripts necessary before the live train data can be run trough the decision treee.
PullExcelData.R -- Pulls training data from csv files and saves them as R data frames
LoadRData.R -- Reads the R data frame files into the necessary varibles
LoadXTSFakeTime.R -- Applies a fake timestamp to the variables before training based off of their iterator
CorrandCan.R -- Run corralation tests and creates decision tree through random forset trials
LiveTest.R -- Runs a live test for 50 seconds filling data fron a url and comparing to the decision tree
