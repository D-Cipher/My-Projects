setwd("C:/Users/Win/Desktop/Coursera/Data Science Course/R Data")
getwd()
data_directory <- "C:/Users/Win/Desktop/Coursera/Data Science Course/R Data"

#Function creates a table of number of observation and non-observations in each file.

complete <- function(directory, id = 1:332) {
  id <- as.integer(id)
  directory <- as.character(directory)
  setwd(paste(data_directory,"/", directory, sep= ""))
  comp.data <- data.frame(id= rep(NA,length(id)) ,nobs = rep(NA,length(id)))
  
  x <- 0
  
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
    
    x <- x+1
    obs <- complete.cases(data)
    nobs <- nrow(data[obs,])
    comp.data[x, ] <- c(i, nobs)
  }
  comp.data
}
  
  complete("specdata", 1)
  complete("specdata", c(2, 4, 8, 10, 12))
  complete("specdata", 30:25)
  complete("specdata", 3)
  