###################
#Download passive microwave SIC data and convert to TIFF
#
#Downloads .bin file from NSIDC HTTPS
#This is the data product: http://nsidc.org/data/NSIDC-0051
#Creates header
#Uses GDAL to convert .bin to .tif
#No R packages required
#
#Created by: Casey Youngflesh
###################

#make sure you have GDAL installed and your PATH points to GDAL install location:
#DL binaries here: https://trac.osgeo.org/gdal/wiki/DownloadingGdalBinaries
#You could probably also download GDAL with Macports or Homebrew




#Function produces TIFF files for SIC derived from NSIDC
#Takes 1) start date, 2) end date, and 3) directory (where to put files) as arguments
#NOTE: Dates must be in 'MM-YEAR' (WITH QUOTES)
#NOTE: Directory cannot have a trailing '/'


SIC_fun <- function(START_DATE = '05-2011', END_DATE = '03-2014', DIRECTORY = '~/Desktop')
{
  # Arguments ---------------------------------------------------------------
  
  #for debug
  #START_DATE <- '11-1980'
  #END_DATE <- '12-1980'
  
  
  
  #this login was created by Casey for the mapppd project. It is for the NSIDC site
  LOGIN <- 'wethington.michael@stonybrook.edu'
  PASSWORD <- 'Forward12!'
  
  
  
  #sort dates
  if(typeof(START_DATE) != 'character' | typeof(END_DATE) != 'character')
  {
    stop("Date must be 'in quotes'")
  }
  
  std_splt <- strsplit(START_DATE, '-')
  ST_MONTH <- as.numeric(std_splt[[1]][1])
  ST_YEAR <- as.numeric(std_splt[[1]][2])
  
  endd_splt <- strsplit(END_DATE, '-')
  END_MONTH <- as.numeric(endd_splt[[1]][1])
  END_YEAR <- as.numeric(endd_splt[[1]][2])
  
  
  
  #default DIR is Desktop
  #set dir
  setwd(DIRECTORY)
  
  
  
  #set url HTTPS site
  site <- 'https://daacdata.apps.nsidc.org/pub/DATASETS/nsidc0051_gsfc_nasateam_seaice/final-gsfc/south/monthly/'
  
  
  
  #loop through years
  for (i in ST_YEAR:END_YEAR)
  {
    #i <- ST_YEAR
    #loop through months
    for (j in 1:12)
    {
      #j <- 11
      #skip months before Start date and after End date
      if(i == ST_YEAR & j < ST_MONTH)
      {
        NULL
      }else
      {
        if(i == END_YEAR & j > END_MONTH)
        {
          NULL
        }else{
        
        # Download .bin file from NSIDC HTTPS site --------------------------------
        
        YEAR <- toString(i)
        
        #convert month to string and add 0 if only one digit (needs to have 0 in front for file name)
        MN <- toString(j)
        if(nchar(MN) < 2)
        {
          MONTH <- paste0(0, MN)
        }else{
          MONTH <- MN
        }
        
        #fnumber if file changes with year
        #2008 and onwards f17
        if(i > 2007)
        {
          FD <- 'f17'
        }
        #199510 - 200712 f13
        if(i < 2008 & i > 1995)
        {
          FD <- 'f13'
        }
        if(i == 1995 & j > 9)
        {
          FD <- 'f13'
        }
        #199201 - 199509 f11
        if(i < 1995 & i > 1991)
        {
          FD <- 'f11'
        }
        if(i == 1995 & j < 10)
        {
          FD <- 'f11'
        }
        # 198709 - 199112 f08
        if(i < 1992 & i > 1987)
        {
          FD <- 'f08'
        }
        if(i ==1987 & j > 8)
        {
          FD <- 'f08'
        }
        # start - 198708 n07
        if(i < 1987)
        {
          FD <- 'n07'
        }
        if(i == 1987 & j < 9)
        {
          FD <- 'n07'
        }

        
        #create file name
        FILE <- paste0('nt_', YEAR, MONTH, '_', FD, '_v1.1_s')
        URL <- paste0(site, FILE, '.bin')
        
        #shell commands to dl from HHTPS site using curl - need to create authentication file to do so
        system('touch .netrc')
        system(paste0('echo "machine urs.earthdata.nasa.gov login ', LOGIN, 
                      ' password ', PASSWORD, '" > .netrc'))
        system('touch .urs_cookies')
        system(paste0('curl -b ', DIRECTORY, '/.urs_cookies -c ', 
                      DIRECTORY, '/.urs_cookies -L -O --netrc-file ', 
                      DIRECTORY, '/.netrc ', URL))
        
        
        
        # Create header file ------------------------------------------------------

#DON'T TOUCH THIS PART - the cat seems to get screwed up easily
        
#creates header file used by GDAL to convert to TIFF
sink(paste0(FILE, '.hdr'))
        
cat(
  'ENVI
description = {', sep = '', FILE, '.bin}') 
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
        
        
        
        
        # Run gdal commands -------------------------------------------------------
        
        #shell commands for GDAL conversion from .bin to .tif
        system(paste0("gdal_translate -of GTiff -a_srs '+proj=stere +lat_0=-90 +lat_ts=-70 +lon_0=0 +k=1 +x_0=0 +y_0=0 +a=6378273 +b=6356889.449+units=m +no_defs' -a_nodata 255 -A_ullr -3950000.0 4350000.0 3950000.0 -3950000.0 ", FILE, '.bin ', FILE, '.tif'))
        }
      }
      }
    }
  }








# Test/template -----------------------------------------------------------


SIC_fun(START_DATE = '11-1978', END_DATE = '12-2017', DIRECTORY = '/Users/coldwater/Projects/MAPPPD/SiteCovariates/PassiveMicrowaveSIC')
  

