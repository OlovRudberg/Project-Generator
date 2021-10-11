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
# the numbers will be close to uniformly distributed. Same for binary choice where
# the median of vector acts as cut-off point, the "mean" of our vector will not
# work in our case sice it does not break it into even 50% quantiles.
WindVec <- log(vec) 
Vec <- sort(WindVec)
ThreshD <- split(Vec,((seq(length(Vec))-1)*10)%/%length(Vec)+1)
ThreshB <- split(Vec,Vec%/%median(Vec))
Val <- c()


# Assert digits [0:9] to each quantile of the value length of the
# wind direction vector.  
 if (choice == "Digits"){
   
  for (i in 1:length(WindVec)){
  
    if (WindVec[i] < max(ThreshD[[1]])){Val[i] <- 0}
     else if (max(ThreshD[[1]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[2]])){Val[i] <- 1}
      else if (max(ThreshD[[2]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[3]])){Val[i] <- 2} 
       else if (max(ThreshD[[3]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[4]])){Val[i] <- 3}
        else if (max(ThreshD[[4]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[5]])){Val[i] <- 4}
         else if (max(ThreshD[[5]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[6]])){Val[i] <- 5}
          else if (max(ThreshD[[6]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[7]])){Val[i] <- 6}
           else if (max(ThreshD[[7]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[8]])){Val[i] <- 7}
            else if (max(ThreshD[[8]]) <= WindVec[i] & WindVec[i] < max(ThreshD[[9]])){Val[i] <- 8}
             else if (max(ThreshD[[9]]) <= WindVec[i] & WindVec[i] <= max(ThreshD[[10]])){Val[i] <- 9}
 } 
} else if (choice == "Binary"){

# If we choose a binary sequence, the same method applies but we do not need to
# divide into 10 quantiles, rather we assert all vector values less than mean of
# of vector a 0 and all others 1.
  for (j in 1:length(WindVec)){
   
    if (WindVec[j] <= max(ThreshB[[1]])){Val[j] <- 0}
    else if (max(ThreshB[[1]]) < WindVec[j] & WindVec[j] <= max(ThreshB[[2]])){Val[j] <- 1}
  }
}
# We end by combining the unpredictability of wind direction with Pseudo Random
# Algorithm to output a non-replicable sequence of random digits. Note that the
# input given from the wind direction vector is approximately uniformly distributed
# but the Pseudo Random Algorithm may not output evenly distributed fractions.
# This means for example that there might be more 1s than 0s in the sequence.
# However, that is not really important, what is important is its property of not
# being reproducible or predicted.
 return(sample(Val, size, replace = TRUE))
}
