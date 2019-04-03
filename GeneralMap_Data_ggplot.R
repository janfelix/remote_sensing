#Load your data to plot from csv
sample_data = read.csv("/Users/.../.csv")

#Map data with ggplot >>> coord_fixed sets the ratio of units on x and y axis, normally one, necessary to compensate for longitude changes on mercator projection
#!!! In this case the plotting oreder is reversed so that the sampling locations are not overlayed by the coastline polygone

#get coastline data from you lat lon area of interest e.g. 48-50 and -122--128
library(mapdata)
coast = map_data("worldHires", ylim = c(48, 51), xlim = c(-128, -122))
#plot coastline polygone first
library(ggplot2)
coast_map = ggplot(data=coast, aes(x=long, y=lat))+geom_polygon(data = coast, aes(x=long, y = lat, group = group), fill = "grey80")+coord_fixed(1.3, xlim = c(-128,-122), ylim = c(48,51))+theme_bw()

#Overlay the coast_map with you sampling points with x and y being lon and lat, and define data variables to display: VARIABLE 3, 4, 5
#headers in csv must be something like lon, lat, VARIABLE3,4,5... Variables can be displayed as gradient (continous) or manually defined (discrete) depneding on data type
#sample_map = coast_map+geom_point(data = sample_data, aes(x = long, y = lat, shape = VAR3, fill = VAR4, size= VAR5))+scale_shape_manual(values=c(16, 18, 15))+scale_fill_manual(values = c("red", "green"))
sample_map = coast_map+geom_point(data = sample_data, aes(x = long, y = lat, shape = VAR3, color = VAR4, size= VAR5))+scale_shape_manual(values=c(16, 18, 15))+scale_color_manual(values = c("red", "green"))



