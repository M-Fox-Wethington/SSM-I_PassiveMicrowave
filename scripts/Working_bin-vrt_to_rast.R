## packages for read/plot/coast data
library(raster)
library(rgdal)
library(maptools)

data(wrld_simpl)

#what we need to do for each file
# 1. download .bin file
# 2. create a vrt file (template file is here, so just edit line 3 - C:\Users\wmichael\Desktop\SIC_ssmi\vrt_template)
# 3. place the vrt in the same directory as the bin file
# 4. cast to raster 
# 5. export raster to geotiff\]



south <- raster("C:/Users/wmichael/Desktop/SIC_ssmi/git2/nt_20201230_f17_v1.1_s.vrt")
plot(south)
plot(spTransform(wrld_simpl, projection(south)), add = TRUE)

