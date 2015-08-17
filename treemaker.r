library(RWeka)
library(ggmap)

query1 <- Removed File
query1 <- paste(strsplit(query1, "/")[[1]][5],".csv",sep="")

setwd("/Users/mikezaret/Downloads")

geofence <- read.csv(query1)

geofence$target <- factor(geofence$target)

geofence$combo = geofence$request_lat * geofence$request_lng

tree <- J48(target ~ request_lat + request_lng + geofence$combo, data=geofence, control=Weka_control(M=100))

summary(tree)

tree

geofence$prediction <- predict(tree, geofence)

NYCmap <- qmap("new york", zoom = 09)
NYCmap + geom_point(aes(x = request_lng, y = request_lat, colour = prediction), data = geofence)
