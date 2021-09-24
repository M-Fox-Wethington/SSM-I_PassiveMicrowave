library(tidyverse)
library(raster)
library(rgdal)


SSMI_bin_to_vrt <- function(template_vrt, binDirectory){
  
  require(tidyverse)
  
  #Template_vrt: filepath to template of your vrt file 
  #binDirectory: directory where you have the newly downloaded .bin files
  
  
  #Template (create a new file with .vrt extension)
  # <VRTDataset rasterXSize="316" rasterYSize="332"> 
  #   <VRTRasterBand dataType="Byte" band="1" subClass="VRTRawRasterBand"> 
  #     <SourceFilename relativetoVRT="1">text</SourceFilename> 
  #       <ImageOffset>300</ImageOffset> 
  #       <PixelOffset>1</PixelOffset> 
  #       <LineOffset>316</LineOffset> 
  #       </VRTRasterBand> 
  #       <SRS>PROJCS["NSIDC Sea Ice Polar Stereographic South",GEOGCS["Unspecified datum based upon the Hughes 1980 ellipsoid",DATUM["Not_specified_based_on_Hughes_1980_ellipsoid",SPHEROID["Hughes 1980",6378273,298.279411123064,AUTHORITY["EPSG","7058"]],AUTHORITY["EPSG","6054"]],PRIMEM["Greenwich",0,AUTHORITY["EPSG","8901"]],UNIT["degree",0.01745329251994328,AUTHORITY["EPSG","9122"]],AUTHORITY["EPSG","4054"]],UNIT["metre",1,AUTHORITY["EPSG","9001"]],PROJECTION["Polar_Stereographic"],PARAMETER["latitude_of_origin",-70],PARAMETER["central_meridian",0],PARAMETER["scale_factor",1],PARAMETER["false_easting",0],PARAMETER["false_northing",0],AUTHORITY["EPSG","3412"],AXIS["X",UNKNOWN],AXIS["Y",UNKNOWN]]</SRS>
  #       <GeoTransform> -3.9500000000000000e+06,  2.5000000000000000e+04,  0.0000000000000000e+00,  4.3500000000000000e+06,  0.0000000000000000e+00, -2.5000000000000000e+04</GeoTransform>
  #       </VRTDataset>
  
  
  #Open the template vrt 
  vrt_to_text <- readLines(template_vrt)
  
  #string pattern to replace 
  bin_name <- "text"
  

  #create a list of existing .bin files in the directory
  bin_files <- list.files(binDirectory, pattern = '\\.bin$' )
  
  for(i in 1:length(bin_files)){
    
    #if(list.files is empty, throw an error here
    
    
    #pull the filename of the present file
    bin_fn <- as.character(bin_files[1])
    
    
    #str_replace(string, pattern, replacement)
    updated_vrt_template <- str_replace(string = vrt_to_text, pattern = "ENTERTHEBINFILENAMEHEREINCLUDINGEXTENSION", replacement = bin_fn)
    
    #change the .bin extension to .vrt
    vrt_fn <- extension(bin_fn, '.vrt')
    
    vrt_fp <- paste0(binDirectory, "/", vrt_fn)
    
    #output the new vrt back into the directory
    write_lines(
      x = updated_vrt_template,
      file = vrt_fp,
      sep = ""
    )

    
  }

}



SSMI_bin_to_vrt("C:/Users/wmichael/Desktop/SIC_ssmi/vrt_template/template_vrt.vrt", "C:/Users/wmichael/Desktop/SIC_ssmi/function_test")


