variable_max_min = function(){ 
  
  library(ncdf)
  dirpath = "/home/jorge/Documentos/ICHTHYOP/ichthyop_1/input/"
#   dirpath = "/run/media/jorge/TOSHIBA EXT/ROMS_SIMULATIONS/ROMS6B_VINCENT_SIMULATION/"
  compute_variable_max_file = function(filename){
    
    nc <- open.ncdf(filename)
    
    #Gets the values for variables
    U     = get.var.ncdf(nc,'u')
#     Ub    = get.var.ncdf(nc,'ubar')    
    V     = get.var.ncdf(nc,'v')
#     Vb    = get.var.ncdf(nc,'vbar')
    
#     temp  = get.var.ncdf(nc,'temp') ; a = dim(temp)
#     salt  = get.var.ncdf(nc,'salt')
#     mask = get.var.ncdf(nc, "mask_rho") ; mask[mask!=1] = NA
    
#     temp = temp[250:341,,28:42,]
#     salt = salt[250:341,,28:42,]
#     mask = mask[250:341,]
#     mask = array(rep(mask,a[4]) , dim = c(92,251,15,a[4]))
       
#     temp = temp[100:181,,23:32,]                            # ROMS 16km
#     salt = salt[100:181,,23:32,]                            # ROMS 16km
#     mask = mask[100:181,]                                   # ROMS 16km
#     mask = array(rep(mask,a[4]) , dim = c(82,355,10,a[4]))  # ROMS 16km
#     
#     temp2 = temp * mask ; salt2 = salt*mask
    
    #Gets the maximun an minimun value for variables
    U_max = max(U); U_min = min(U)
# Ubmax = max(Ub)
V_max = max(V); V_min = min(V)
# Vbmax=max(Vb)
#     temp_max = max(temp2,na.rm=TRUE) ; temp_min = min(temp2,na.rm=TRUE)
#     salt_max = max(salt2,na.rm=TRUE) ; salt_min = min(salt2,na.rm=TRUE)
    
    close.ncdf(nc)
#     return(cbind(U_max,Ubmax,Vmax,Vbmax,temp_max,temp_min,salt_max,salt_min))
    return(cbind(U_max,V_max, U_min, V_min))

  }
    
    # Gets filenames of all files in the dirpath directory 
    filenames <- list.files(path = dirpath, full.names = TRUE)
    
    # Computes U_max for the first file 
    dataset <- compute_variable_max_file (filenames[1])
    
    # Computes U_max for all subsequent files 
    if (length(filenames) >1){
      for (i in seq(2, length(filenames))){
        # Shows name of opened file on the console
        print(filenames[i])
        flush.console()
        # Computes recruitment data for file i
        data <- compute_variable_max_file (filenames[i])
        # Adds recruitment data computed for file i to those computed from all previous files
        dataset <- rbind(dataset,data)
      }
    }
  dataset <- as.data.frame(cbind(dataset))
#   colnames(dataset) <- c('U','Ubar','V','Vbar','temp_max','temp_min','salt_max','salt_min') 
#   colnames(dataset) <- c('U','Ubar','V','Vbar')
   colnames(dataset) <- c('Umax','Vmax','Umin','Vmin')
  #colnames(dataset) <- c('temp_max','temp_min')
  return(dataset)
  }


