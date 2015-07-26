setwd("H:/5 Personal Projects/Coursera/Data Science Course/R Data/Hospitals Project")
getwd()
outcome_data <- read.csv("outcome-of-care-measures.csv", colClasses = "character")
head(outcome_data)

#Histogram of 30 day death rates from heart attacks
outcome_data[, 11] <- as.numeric(outcome_data[, 11])
hist(outcome_data[, 11])


# "best" function takes State and outcomes ("heart attack", "heart failure", 
# or "pneumonia"). and returns hospital with 
# the lowest mortality rate for that outcome in that state.
best <- function(state, outcome){
  
  #--Input testing:
possible_state <- (unique(outcome_data$State) == state)
possible_outcome <- (c("heart attack", "heart failure", "pneumonia") == outcome)

  if(sum(possible_state) != 1){
    stop(print("invalid state"))
  } else if(sum(possible_outcome) != 1){
    stop(print("invalid outcome"))
  } else {
  
  #-- Creates State subset
  state_filter <- outcome_data[outcome_data$State == state,]
  
  state_filter[state_filter == "Not Available" ] = NA
  #Turns "Not Availible" string into NA
  
  state_subset <- data.frame(as.character(state_filter$Hospital.Name), 
                             as.character(state_filter$State),
                             as.numeric(state_filter$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack),
                             as.numeric(state_filter$Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure),
                             as.numeric(state_filter$Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia))
  
  colnames(state_subset) <- c("Hospital.Name", "State", "heart_attack", "heart_failure", "pneumonia")
  
  rm(state_filter)
  
  #-- Conditional Min and lookup
  if(outcome == "heart attack") {
    min_outcome <- min(state_subset$heart_attack, na.rm = TRUE)
    lookup_row <- which(state_subset$State == state 
                        & state_subset$heart_attack == min_outcome 
                        & complete.cases(state_subset$heart_attack) == T)
    lookup_col <- which(colnames(state_subset)=="Hospital.Name")
    best_hospitals <- sort(as.vector(state_subset[lookup_row,lookup_col]))
    
  } else if (outcome == "heart failure") {
    min_outcome <- min(state_subset$heart_failure, na.rm = TRUE)
    lookup_row <- which(state_subset$State == state 
                        & state_subset$heart_failure == min_outcome 
                        & complete.cases(state_subset$heart_failure) == T)
    lookup_col <- which(colnames(state_subset)=="Hospital.Name")
    best_hospitals <- sort(as.vector(state_subset[lookup_row,lookup_col]))
    
  } else if (outcome == "pneumonia"){
    min_outcome <- min(state_subset$pneumonia, na.rm = TRUE)
    lookup_row <- which(state_subset$State == state 
                        & state_subset$pneumonia == min_outcome 
                        & complete.cases(state_subset$pneumonia) == T)
    lookup_col <- which(colnames(state_subset)=="Hospital.Name")
    best_hospitals <- sort(as.vector(state_subset[lookup_row,lookup_col]))
    
  } else {
    stop(print("Not valid input for outcome."))
  }
  
  #Gives 1 of best hospital based on name order
  print(best_hospitals[1])
  }
}

best("TX", "heart attack")
#"CYPRESS FAIRBANKS MEDICAL CENTER"
best("TX", "heart failure")
#"FORT DUNCAN MEDICAL CENTER"
best("MD", "heart attack")
#"JOHNS HOPKINS HOSPITAL, THE"
best("MD", "pneumonia")
#"GREATER BALTIMORE MEDICAL CENTER"
