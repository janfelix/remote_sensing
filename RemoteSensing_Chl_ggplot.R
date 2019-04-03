library(ncdf4)

setwd("/...")
name = "A20061692006200.L3m_R32_CHL_chlor_a_4km.nc"

ncin = nc_open(name)

#str(ncin)

#prep data
lon = ncvar_get(ncin, "lon")
lat = ncvar_get(ncin, "lat", verbose = F)
array.chl = ncvar_get(ncin, "chlor_a")

#transpose array to lat to rows and lon to columns
chl1 = t(array.chl)

#assign columns names and row names
colnames(chl1) = lon
row.names(chl1) = lat

###Extracting data

#extract region of interest
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

#Map data with ggplot >>> coord_fixed sets the ratio of units on x and y axis, normally one, necessary to compensate for longitude changes on mercator projection
library(ggplot2)
chl_data = ggplot(data = chl4, aes(x = long, y = lat, fill = chl))+geom_raster(interpolate = TRUE)+scale_fill_gradientn(colours = rev(rainbow(7)), na.value = NA)+theme_bw()+coord_fixed(1.3)

#overlay coastline polygone
library(mapdata)
coast = map_data("worldHires", ylim = c(48, 50), xlim = c(-128, -122))
chl_map = chl_data + geom_polygon(data = coast, aes(x=long, y = lat, group = group), fill = "grey80")+coord_fixed(1.3, xlim = c(-128,-122), ylim = c(48,50))+theme_bw()



