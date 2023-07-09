## Functions in Parts for Fuzzy matching

# Function to open connection and write table to the database

uploadedData <- function(uploadedDataPath){
  # read the csv file 
  the_nominations <- read.csv(uploadedDataPath)
  # Load package
  library(RSQLite)
  # Open connection to the database
  conn <- dbConnect(RSQLite::SQLite(), "AwardDB.db")
  # write table to the database
  dbWriteTable(conn, "Nominations", the_nominations, overwrite = TRUE)
  # Pull out the name column
  Noms <- dbGetQuery(conn, "SELECT Q6 FROM Nominations")
  # Unlist the pulled data for easy processing 
  Nominations <- unlist(as.vector.data.frame(Noms))
  return(Nominations)
}






# A function to pull out staff data from the database

AllPotentialNominee <- function(){
  # load package
  library(RSQLite)
  # Open connection to the database
  conn <- dbConnect(RSQLite::SQLite(), "AwardDB.db")
  # Pull out the staff data from the database
  Potential_Nominee <- dbGetQuery(conn, "SELECT Full_Name FROM Potential_Nominee")
  # unlist for easy process
  Potential_Nominee <- unlist(as.vector.data.frame(Potential_Nominee))
  return(Potential_Nominee)
}









# Perform fuzzy matching

matching <- function(strings1, strings2){
  #load packages
  library(tidyverse)
  library(reticulate)
  POLYFUZZ <- reticulate::import("polyfuzz")
  
  # match the results
  matches <- POLYFUZZ$PolyFuzz("TF-IDF")$match(strings1, strings2)$get_matches()
 
  # return a subset where similarity is greater than 0.8
   return(subset(matches, Similarity > 0.8))
}


# Test of the functions

the_nominations <- uploadedData("C:/Users/alexa/Documents/working/21-22 Symons Award for Excellence in Teaching 2021-2022_May 25, 2023_12.19.csv")
Nominee_db <- AllPotentialNominee()
matching(the_nominations, Nominee_db)


