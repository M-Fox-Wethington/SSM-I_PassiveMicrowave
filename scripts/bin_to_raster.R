library(raster)
library(terra)
library(rgdal)
library(maptools)




#Using Terra package

#Create a temporary filename
f <- "C:/Users/wmichael/Desktop/SIC_ssmi/arctest/nt_20201230_f17_v1.1_s.bin"

#open bin as a raster
# r <- rast("C:/Users/wmichael/Desktop/SIC_ssmi/nt_20201230_f17_v1.1_s.bin")

ext <- c(-3837500, 3762500, -5362500, 5837500)
dims <- c(304, 448)
prj <-  "+proj=stere +lat_0=-90 +lat_ts=-70 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449 +units=m +no_defs"

con <- file(f, open = "rb")
dat <- try(readBin(con, "integer", size = 1, n = prod(dims), endian = "little", signed = FALSE))
r <- raster(t(matrix(dat, dims[1])), xmn=ext[1], xmx=ext[2], ymn=ext[3], ymx=ext[4], crs = CRS(prj))

r

#set the crs
terra::crs(r)  <- "epsg:3031"

#set values of 255 to NA
r <- terra::classify(r, cbind(0,NA)) #classify all 0 values as NA

f <- paste0("test", 1:nlyr(r), ".tif")

#Write raster
writeRaster(r, f, overwrite=TRUE)




#using Raster
data("wrld_simpl")
south <- raster("C:/Users/wmichael/Desktop/SIC_ssmi/arctest/nt_20201230_f17_v1.1_s.vrt", crs = CRS(prj))
raster::crs(south) <- CRS('+init=EPSG:3031')
plot(spTransform(wrld_simpl, projection(south)), add = TRUE)
