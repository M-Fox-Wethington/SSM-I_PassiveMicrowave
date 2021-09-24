vrt_to_tif <- function(vrt_directory){
  
  vrt_list <- list.files(vrt_directory, 
                         pattern = '\\.vrt$',
                         full.names = TRUE)
  
  for(i in 1:length(vrt_list)){
    
    fp <- vrt_list[i]
    
    r <- raster(vrt_list[i])
    raster::crs(r) <- CRS('+init=EPSG:3031')
    
    r_tif <- extension(fp, '.tif')
    
    #Write raster
    writeRaster(x= r,
                filename = r_tif)
    
  }
  
}


vrt_to_tif("C:/Users/wmichael/Desktop/SIC_ssmi/function_test")
