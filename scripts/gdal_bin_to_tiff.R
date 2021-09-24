library(gdalUtils)

data_dir <- "G:/My Drive/Projects/SIC_ssmi/data/205820380"

f <- list.files(data_dir, pattern = '\\.bin$')

f1 <- f[1]

#DON'T TOUCH THIS PART - the cat seems to get screwed up easily

#creates header file used by GDAL to convert to TIFF
sink(paste0(f1, '.hdr'))

cat(
  'ENVI
description = {', sep = '', f1, '.bin}') 
cat('
samples = 316
lines   = 332
bands   = 1
header offset = 300
file type = ENVI Standard
data type = 1
interleave = bsq
byte order = 0
map info = {Polar Stereographic, 1, 1, -3949916.40183233, 4349907.86077719, 25000, 25000,WGS-84}
projection info = {31, 6378137, 6356752.314245179, -70, 0, 0, 0,WGS-84, Polar Stereographic}
coordinate system string = {PROJCS["Stereographic_South_Pole",GEOGCS["GCS_WGS_1984",DATUM["D_WGS_1984,SPHEROID["WGS_1984",6378137,298.257223563]],PRIMEM["Greenwich",0],UNIT["Degree",0.017453292519943295]],PROJECTION["Stereographic_South_Pole"],PARAMETER["standard_parallel_1",-70],PARAMETER["central_meridian",0],PARAMETER["false_easting",0],PARAMETER["false_northing",0],UNIT["Meter",1]]}
band names = {Band 1}', fill = TRUE)

sink()

gdal_translate(src_dataset = f1,
               of="GTiff",
               a_srs = 31,
               a_nodata = 255,
               A_ullr = "-3950000.0 4350000.0 3950000.0 -3950000.0" ,  f1, '.bin ', f1, '.tif')


system(paste0("gdal_translate -of GTiff -a_srs '+proj=stere +lat_0=-90 +lat_ts=-70 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449+units=m +no_defs' -a_nodata 255 -A_ullr -3950000.0 4350000.0 3950000.0 -3950000.0 ", FILE, '.bin ', FILE, '.tif'))



