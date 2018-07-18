#===============================================================================
# Name   : MaxDistFromBeginning
# Author : Jorge Flores
# Date   : 
# Version:
# Aim    : Calculate the distance from the beginning through each point 
#          in the path of a particle.
#          You need a matrix of the form [lon, lat]
# URL    : 
#===============================================================================
MaxDistFromBeginning <- function(mat){
  library(geosphere)

  StartingPoint <- mat[1,] # Starting point of the particle
  
  DistFromBeginning <- NULL
  for(k in 1:dim(mat)[1]){
    distance <- distm(StartingPoint, mat[k,])
    DistFromBeginning <- c(DistFromBeginning, distance)
    MaxDistanceFromBeginning <- max(DistFromBeginning)
  }
  return(MaxDistanceFromBeginning)
}

#===============================================================================
# END OF PROGRAM
#===============================================================================