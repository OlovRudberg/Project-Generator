require(jsonlite)

TRDG <- function(choice, size){
  
# Import data from JavaScript
# Select time series containing real time wind direction data
URL <- paste("https://opendata-download-metfcst.smhi.se/api/category/pmp3g/version/2/geotype/point/lon/18.518120/lat/67.898160/","data.json", sep="")
stock <- fromJSON(URL)                                                          
TS <- stock$timeSeries[[2]]                                                     


# Loop through length of wind direction data point except first 6 values since 
# they are unfortunately reversed in the data set given by SMHI.
vec <- NULL                                                                     
 for (i in 1:(length(TS)-6)) {                                                  
   vec <- c(vec,TS[[i+6]][["values"]][[4]])
}

# Make logarithmic to get corresponding values from natural numbers to rational 
# numbers, create a new variable which is the sorted logarithmic wind direction
# vector then divide it into equal 10% quantiles such that when we assert [0:9],
# the numbers will be close to uniformly distributed.
WindVec <- log(vec) 
Vec <- sort(WindVec)
Thresh <- split(Vec,((seq(length(Vec))-1)*10)%/%length(Vec)+1)
Val <- c()


# Assert digits [0:9] to each quantile of the value length of the
# wind direction vector.  
 if (choice == "Digits"){
   
  for (i in 1:length(WindVec)){
  
    if (WindVec[i] < max(Thresh[[1]])){Val[i] <- 0}
     else if (max(Thresh[[1]]) <= WindVec[i] & WindVec[i] < max(Thresh[[2]])){Val[i] <- 1}
      else if (max(Thresh[[2]]) <= WindVec[i] & WindVec[i] < max(Thresh[[3]])){Val[i] <- 2} 
       else if (max(Thresh[[3]]) <= WindVec[i] & WindVec[i] < max(Thresh[[4]])){Val[i] <- 3}
        else if (max(Thresh[[4]]) <= WindVec[i] & WindVec[i] < max(Thresh[[5]])){Val[i] <- 4}
         else if (max(Thresh[[5]]) <= WindVec[i] & WindVec[i] < max(Thresh[[6]])){Val[i] <- 5}
          else if (max(Thresh[[6]]) <= WindVec[i] & WindVec[i] < max(Thresh[[7]])){Val[i] <- 6}
           else if (max(Thresh[[7]]) <= WindVec[i] & WindVec[i] < max(Thresh[[8]])){Val[i] <- 7}
            else if (max(Thresh[[8]]) <= WindVec[i] & WindVec[i] < max(Thresh[[9]])){Val[i] <- 8}
             else if (max(Thresh[[9]]) <= WindVec[i] & WindVec[i] <= max(Thresh[[10]])){Val[i] <- 9}
 } 
} else if (choice == "Binary"){

# If we choose a binary sequence, the same method applies but we do not need to
# divide into 10 quantiles, rather we assert all vector values less than mean of
# of vector a 0 and all others 1.
  for (j in 1:length(WindVec)){
   
    if (WindVec[j] < mean(WindVec)){Val[j] <- 0}
     else if (mean(WindVec) <= WindVec[j]){Val[j] <- 1}
 }
}
# We end by combining the unpredictability of wind direction with Pseudo Random
# Algorithm to output a non-replicable sequence of random digits.
 return(sample(Val, size, replace = TRUE))
}
