
library(raster)
library(terra)

data_dir <- "G:/My Drive/Projects/SIC_ssmi/data/205820380"

f <- list.files(data_dir, pattern = '\\.bin$')

f1 <- f[1]


#Make a template raster that matches the described resolution for extent and resolution. 
r <- raster(res=25, 
            xmn = -3950000.0, 
            xmx = 4350000.0, 
            ymn = -3950000.0,
            ymx = 3950000.0,
            crs = 3031)


#Save to file. The datatype sets the file size, that is how I could see that it had to be 'FLT8S'.
terra::writeRaster(r, 'test.grd', datatype='FLT8S', overwrite=T)

#Copy the header 
file.copy('test.grd', extension(f1, '.grd'))



#rename file with the values
file.rename(f1, extension(f1, '.gri'))

r <- raster(extension(f, '.gri'))


NAvalue(r) <- 255



#values are stored from bottom to top, so they need to be 'flipped'. I save them to a tif file in the same step
x <- flip(r, 'y', filename=extension(f, 'tif'))








# Run gdal commands -------------------------------------------------------
# 
# #shell commands for GDAL conversion from .bin to .tif
# system(paste0("gdal_translate -of GTiff -a_srs '+proj=stere +lat_0=-90 +lat_ts=-70 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449+units=m +no_defs' -a_nodata 255 -A_ullr -3950000.0 4350000.0 3950000.0 -3950000.0 ", FILE, '.bin ', FILE, '.tif'))
# }
# }
# }
# }
# }

