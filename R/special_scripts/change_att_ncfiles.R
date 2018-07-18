library(ncdf4)

dirpath <- 'G:/ICHTHYOP/final/output_4th/RUN4/clim_lobos/'
ncfiles <- list.files(path = dirpath, pattern = '.nc', full.names = T, recursive = T)
ncfiles <- ncfiles[758:length(ncfiles)]
atts <- c('app.output.output_path',
          'action.recruitment.zone.zone_file',
          'release.zone.zone_file',
          'dataset.roms_3d.input_path',
          'xml_file')

oldstr <- '/run/media/cimobp/'
newstr <- '/run/media/lmoecc/'

for(i in 1:length(ncfiles)){
  nc <- nc_open(filename = ncfiles[i], write = T)
  
  for(j in 1:length(atts)){
    # print(paste(i,j))
    att <- ncatt_get(nc = nc, varid = 0, attname = atts[j])$value
    newatt <- gsub(pattern = oldstr, replacement = newstr, x = att)
    ncatt_put(nc = nc, varid = 0, attname = atts[j], attval = newatt)$value
  }
  nc_close(nc)
  print(ncfiles[i])
}
