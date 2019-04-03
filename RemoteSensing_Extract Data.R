###Pull data to plot, eg from ncdf4 format
library(ncdf4)

setwd("/Users/...")
name = "A20061692006200.L3m_R32_CHL_chlor_a_4km.nc"
ncin = nc_open(name)

#prep data
lon = ncvar_get(ncin, "lon")
lat = ncvar_get(ncin, "lat", verbose = F)
array.chl = ncvar_get(ncin, "chlor_a")

#transpose array to lat to rows and lon to columns
chl1 = t(array.chl)

#assign columns names and row names
colnames(chl1) = lon
row.names(chl1) = lat

#define site coordinates to extract data for
coord = read.csv("/Users/.../GOB_LonLat.csv")

#define region of interest
lat_range = which(lat > 48 & lat < 50)
lon_range = which(lon > -128 & lon < -122)
chl2 = chl1[lat_range, lon_range]

#convert data to data.frame
library(reshape)
chl3 = melt(chl2, id.var = row.names(chl2) )
#change the colnames.
colnames(chl3) = c('lat', 'long', 'chl')
#remove!!! (not just NaN) the clouds and soil, scale if necessary!
#chl4 = chl3[!(chl3$chl == NA),] 
chl4 = chl3[!(is.na(chl3$chl)),]

#extract values for specific sites, eg chlororphyll at station GOB1
CHL_GOB1=chl4$chl[(chl4$long==coord$lon[coord$Station == 'GOB1']) & (chl4$lat==coord$lat[coord$Station == 'GOB1']),]

