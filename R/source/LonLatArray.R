#===============================================================================
# Name   : LonLatArray
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : 
# URL    : 
#===============================================================================
LonLatArray <- function(df){
  dim3 <- length(levels(factor(df$Drifter)))
  indexes <- 1:28
  # traits <- NULL
  arr <- NULL
  for(i in 1:dim3){
    D2 <- as.matrix(df[indexes,2:3])
    arr <- abind(arr, D2, along = 3)
    indexes <- indexes + 28
  }
  return(arr)
}



# LonLatArray <- function(df){
#   dim3 <- length(levels(factor(df$Drifter)))
#   indexes <- 1:28
#   # traits <- NULL
#   arr <- NULL
#   for(i in 1:dim3){
#     # D2 <- df[indexes,]
#     # trait <- c( D2$Drifter[1], D2$Month[1], toString(D2$ReleaseDepth[1]), D2$Age[1])
#     # traits <- rbind(traits, trait)
#     D2 <- as.matrix(df[indexes,2:3])
#     arr <- abind(arr, D2, along = 3)
#     indexes <- indexes + 28
#   }
#   # return(list(arr,traits))
#   return(arr)
# }

#===============================================================================
# END OF PROGRAM
#===============================================================================