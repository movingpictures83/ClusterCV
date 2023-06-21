#Now the data is generated with the package clustergeneration, where plsda does very good

rm(list=ls())

library(mixOmics)
library(plotly)
library(clusterGeneration)

source("RPluMA.R")
source("RIO.R")


input <- function(inputfile) {
        parameters <<- readParameters(inputfile)


ncomp <<- as.integer(parameters["ncomp", 2]) #Number of components for plsda
#nonSignalSeq = seq(0,1000 , by = 75) 
#samplesSeq = seq(10, 150, by = 10)
#nRepetitions = 100
#repetitionsSeq = seq(1, nRepetitions, by = 1)
#nSignal = 10
print(parameters)
print(parameters["nSSFrom", 1])
print(as.integer(parameters["nSSInc", 2]))
nssFrom <<- parameters["nSSFrom", 2]
nssTo <<- parameters["nSSTo", 2]
nssBy <<- parameters["nSSInc", 2]
nonSignalSeq <<- seq(nssFrom, nssTo, by = nssBy)
samplesSeq <<- seq(parameters["sSSFrom", 2], parameters["sSSTo", 2], by = parameters["sSSInc", 2])
nRepetitions <<- parameters["nRepetitions", 2]
repetitionsSeq <<- seq(1, nRepetitions, by = 1)
nSignal <<- parameters["nSignals", 2]
}

run <- function() {
outputMatrixPLSDA <<- array(0, dim=c(length(nonSignalSeq),length(samplesSeq))) #First dimension number of features, second number of signal, 

start.time <- Sys.time()


#We execute with different matrixes to minimize random effects
for (repetition in repetitionsSeq) {
  print("REPETITION")
  print(repetition)
  print(as.numeric(repetition/nRepetitions)*100)
  
  outputMatrixPLSDAAux = array(0, dim=c(length(nonSignalSeq),length(samplesSeq))) #First dimension number of features, second number of signal, 

 
  #We iterate over different number of features
  noiseCount = 0
  for (nNoise in nonSignalSeq) {
    noiseCount = noiseCount +1
    print(nNoise)

    
    samplesCount = 0
    #We iterate over different number of signals
    for (nSamples in samplesSeq) {
      samplesCount = samplesCount +1
      print(nSamples)
      #We create the data
      
      
      c <- genRandomClust(numClust=2, sepVal=0.5, numNonNoisy=nSignal, numNoisy=nNoise, 
                          numOutlier=0, numReplicate=1,clustszind= 1,clustSizeEq=(nSamples+nNoise*(1.5)))
      
      
      X <- as.data.frame(c$datList$test_1[1:(nSamples*2),1:(nSignal+nNoise)])
      Y <- c$memList$test_1[1:(nSamples*2)]

      
      plsda <- splsda(X, Y, ncomp = ncomp, scale = TRUE)
      
      perf <- perf(plsda, validation = "Mfold",dist = "all", folds = 5, progressBar = FALSE, nrepeat = 10,auc = TRUE)
      print(str(perf$auc))
      outputMatrixPLSDAAux[noiseCount,samplesCount] = as.numeric(perf$auc$comp1[1])
    }
  }
  outputMatrixPLSDA <<- outputMatrixPLSDA + outputMatrixPLSDAAux
}

outputMatrixPLSDA <<- outputMatrixPLSDA/nRepetitions
}

output <- function(outputfile) {
write.csv(outputMatrixPLSDA, outputfile)
}


#plsdaP <- plot_ly(y = nonSignalSeq, x = samplesSeq, z = outputMatrixPLSDA) %>%   layout(title = "Performance of PLSDA",
#c49b3587420e1  scene = list(
#  xaxis = list(title = "# Samples"), 
#  yaxis = list(title = "# Noise"), 
#  zaxis = list(title = "Performance"))) %>% add_surface()
#plsdaP

#print(plsdaP)
#print(str(plsdaP))


#end.time <- Sys.time()
#time.taken <- end.time - start.time
#time.taken





#title = paste("ClusterCVPerformance", "nSignal",nSignal,"nRepetitions",nRepetitions,".html",sep="")
#Sys.setenv("plotly_username" = "druiz072")
#Sys.setenv("plotly_api_key" = "Gnv8DXsx4cKYFt8uVD90")
# setwd("D:/Google Drive/FIU/RESEARCH/PLS-DA/graphs")
#htmlwidgets::saveWidget(plsdaP,title)





