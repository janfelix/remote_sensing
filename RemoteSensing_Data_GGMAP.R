###Mapping with ggmap
library(ggmap)

#get map of interest, lat long ranges (bottom left to top right), source maps from stamen design (stamen), open street map (osm) or google maps (google)
#loc = c(-128, 48, -122, 50)
#m = get_map(location=loc, source="stamen", maptype="toner", crop=FALSE)
#m = get_map(location=loc, source="osm", color="bw", crop=FALSE)
#m = get_map(location=loc, source="google", maptype="terrain", crop=FALSE)

#select specifc map design and source
#gg = get_googlemap(center= c(lon = -124, lat = 49), zoom = 8, maptype = "satellite", color = "color")
#st = get_stamenmap(bbox= c(left = -128, bottom = 48, right = -122, top = 50), zoom = 8, maptype = "toner-lite", crop = TRUE, color = "bw")
st = get_stamenmap(bbox= c(left = -128, bottom = 48, right = -122, top = 50), zoom = 8, maptype = "terrain-background", crop = TRUE, color = "bw")

#points to map
coord = read.csv("/Users/jan/Documents/PhD/MpV_Genomes/GOB_analysis/GOB_LonLat.csv")

#plot map with points
latlon = ggmap(st) + geom_point(data=coord, size=4, aes(x=lon, y=lat, shape=Station))


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

#plot data, eg linear or log
chl = ggmap(st) + geom_point(data=chl4, shape=15, size=5, aes(x=long, y=lat, colour=chl)) + scale_colour_gradientn(colours=c("purple", "blue", "cyan", "green", "yellow", "red" ), limits = c(min(chl4$chl), max(chl4$chl)))
#chl_log = ggmap(st) + geom_point(data=chl4, shape=15, size=5, aes(x=long, y=lat, colour=chl)) + scale_colour_gradientn(colours=c("purple", "blue", "cyan", "green", "yellow", "red" ), limits = c(min(chl4$chl), max(chl4$chl)), trans="log")

#extract values for points, eg chlororphyll at station GOB1
CHL_GOB1=chl4$chl[(chl4$long==coord$lon[coord$Station == 'GOB1']) & (chl4$lat==coord$lat[coord$Station == 'GOB1']),]

