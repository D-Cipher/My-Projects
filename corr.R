setwd("C:/Users/Win/Desktop/Coursera/Data Science Course/R Data")
getwd()
data_directory <- "C:/Users/Win/Desktop/Coursera/Data Science Course/R Data"

corr <- function(directory, threshold = 0) {
  setwd(paste(data_directory,"/", directory, sep= ""))
  
  id = 1:332
  combined_file <- vector(mode="character", length=length(id))
  for(i in id) {
    x <- id[i]
    if (x >= 1 && x <= 9) {  
      name_file <- paste("00", i, ".csv", sep="")
    }
    else if (x >= 10 && x <= 99) {
      name_file <- paste("0", i, ".csv", sep="")
    }
    else {
      name_file <- paste(i, ".csv", sep="") 
    }
    combined_file[i] <- name_file      
  }

  result <-vector(mode="numeric", length=0)
  for(i in seq(combined_file)) {
    airquality <- read.csv(combined_file[i])
    obs <- complete.cases(airquality)
    airquality <- airquality[obs, ]
    if (nrow(airquality) > threshold) {
      correlation <- cor(airquality[["sulfate"]], airquality[["nitrate"]])
      result <- append(result, correlation)
    }
  }
  result
}

cr <- corr("specdata", 150)
head(cr)
summary(cr)

cr <- corr("specdata", 400)
head(cr)
summary(cr)

cr <- corr("specdata", 5000)
summary(cr)
length(cr)

cr <- corr("specdata")
summary(cr)
length(cr)