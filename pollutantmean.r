setwd("C:/Users/Win/Desktop/Coursera/Data Science Course/R Data")
getwd()
data_directory <- "C:/Users/Win/Desktop/Coursera/Data Science Course/R Data"

#Function calculates means given file directory, pollutant type, and file id


pollutantmean <- function(directory, pollutant, id = 1:332) {
  x <-c()
  setwd(paste(data_directory,"/", directory, sep= ""))
  for (i in id) {
    if (i <= 9){
      name_file <-paste("00", i, sep="")
    }
    else if (10 <= i && i <= 99){
      name_file <- paste("0", i, sep ="")
    }
    else if (i >= 100){
      name_file <- paste(i, sep ="")
    }
    else {
      name_file <- i
    }
    data <- read.csv(paste(name_file, ".csv", sep =""))
    
    
    if (pollutant == "sulfate"){
      y <- c(data[,2])
    } 
    else if (pollutant == "nitrate") {
      y <- c(data[,3])
    }
    x <- c(x, y)
  }
  mean_data <- mean (x, na.rm = TRUE)
  round(mean_data, 3)
}

pollutantmean("specdata", "sulfate", 1:10)
pollutantmean("specdata", "nitrate", 70:72)
pollutantmean("specdata", "nitrate", 23)