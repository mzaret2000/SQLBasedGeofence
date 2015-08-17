# SQLBasedGeofence
Geofence queries are slow. Use a decision tree to create a SQL geofence
If you run into a situation in which your geofence query is computationally expensive, you may want to try a SQL based geofence. DOps have often used Lat/Lng boxes in the past to approximate geofences when reasonable. Boxes are great, but they are pretty limited. The methodology described here allows you to more accurately represent your geofence. It also allows you to classify your data into many geofences. 

It takes roughly 30 minutes upfront to set this process up on your own machine and 5-10 minutes each time you want to create a new pattern. I recommend using the awesome Vertica Places library whenever possible and leveraging the process sparingly. 

Examples of when I have used this:
Earnings Calculator
Weekly Stats by Surge Geofence.

In this example we will create a SQL Geofence for New York’s County Tiles. The chart belows shows how the SQL Geofence classifies trips into county tiles based on request lat/lngs.



Here are the tiles:

url removed



We want to run a simple query using the actual geofences to label request lat/lngs with the actual county tiles. This query should run in 1 minutes or less (otherwise it defeats the purpose of this whole exercise). You probably want at least a week of data. The more data you have, the more accurate the SQL-Fence will be. I shoot for 100k to 200k records.

url removed



Things to consider:
You don’t want your geofences to overlap because that will cause one point to receive multiple geo labels.
Any point not in one of your geofences will be labeled ‘Other’

Install R here. I use R-Studio as well, but will just use R for this example
Open R. You should see this


Install RWeka and ggmap packages by typing the following commands.

install.packages(“RWeka”)
install.packages(“ggplot2”)
install.packages(“ggmap”)

Open an R Editor (File -> New Rd Document)

Run treemaker.r. You’ll need to change the data path (remember to export the query as a csv) and the working directory to find your csv. My queries are exported to Downloads


And the tree is below. Copy and paste the tree into a .csv.

geofence$combo <= -3012.353528
|   request_lng <= -73.931822
|   |   request_lng <= -74.018797: Other (5325.0/63.0)
|   |   request_lng > -74.018797
|   |   |   request_lng <= -73.960397
|   |   |   |   geofence$combo <= -3018.999634: Other (250.0/37.0)
|   |   |   |   geofence$combo > -3018.999634
|   |   |   |   |   geofence$combo <= -3017.652664
|   |   |   |   |   |   request_lng <= -73.978201: Other (100.0/30.0)
|   |   |   |   |   |   request_lng > -73.978201: New York (2283.0)
|   |   |   |   |   geofence$combo > -3017.652664: New York (149547.0/12.0)
|   |   |   request_lng > -73.960397
|   |   |   |   geofence$combo <= -3014.313836
|   |   |   |   |   geofence$combo <= -3021.792252: Other (59.0/16.0)
|   |   |   |   |   geofence$combo > -3021.792252: New York (19562.0/20.0)
|   |   |   |   geofence$combo > -3014.313836
|   |   |   |   |   request_lat <= 40.73886: Kings (607.0)
|   |   |   |   |   request_lat > 40.73886
|   |   |   |   |   |   geofence$combo <= -3013.526587
|   |   |   |   |   |   |   request_lng <= -73.94946
|   |   |   |   |   |   |   |   geofence$combo <= -3013.603196: New York (120.0/53.0)
|   |   |   |   |   |   |   |   geofence$combo > -3013.603196: Queens (148.0/6.0)
|   |   |   |   |   |   |   request_lng > -73.94946: Queens (285.0/3.0)
|   |   |   |   |   |   geofence$combo > -3013.526587: Queens (1984.0/2.0)
|   request_lng > -73.931822
|   |   request_lat <= 40.784714: Queens (3902.0/5.0)
|   |   request_lat > 40.784714
|   |   |   request_lat <= 40.904768
|   |   |   |   geofence$combo <= -3020.003324
|   |   |   |   |   request_lng <= -73.907517
|   |   |   |   |   |   geofence$combo <= -3021.3381: Bronx (257.0/6.0)
|   |   |   |   |   |   geofence$combo > -3021.3381: New York (1217.0/41.0)
|   |   |   |   |   request_lng > -73.907517: Bronx (1038.0/13.0)
|   |   |   |   geofence$combo > -3020.003324
|   |   |   |   |   request_lat <= 40.799706: New York (149.0/7.0)
|   |   |   |   |   request_lat > 40.799706: Bronx (6339.0/83.0)
|   |   |   request_lat > 40.904768
|   |   |   |   request_lng <= -73.659962
|   |   |   |   |   request_lng <= -73.895953: Bronx (119.0/58.0)
|   |   |   |   |   request_lng > -73.895953: Westchester (1379.0/13.0)
|   |   |   |   request_lng > -73.659962: Other (251.0/9.0)
geofence$combo > -3012.353528
|   request_lng <= -73.907318
|   |   request_lat <= 40.73437
|   |   |   request_lng <= -74.040352
|   |   |   |   request_lat <= 40.57293: Other (100.0/8.0)
|   |   |   |   request_lat > 40.57293: Richmond (227.0/3.0)
|   |   |   request_lng > -74.040352
|   |   |   |   geofence$combo <= -3011.834885
|   |   |   |   |   request_lng <= -73.964205: New York (666.0/11.0)
|   |   |   |   |   request_lng > -73.964205: Kings (749.0/1.0)
|   |   |   |   geofence$combo > -3011.834885
|   |   |   |   |   request_lng <= -73.921494
|   |   |   |   |   |   request_lat <= 40.565983: Other (74.0/2.0)
|   |   |   |   |   |   request_lat > 40.565983: Kings (46339.0/36.0)
|   |   |   |   |   request_lng > -73.921494
|   |   |   |   |   |   request_lat <= 40.698326: Kings (1697.0/7.0)
|   |   |   |   |   |   request_lat > 40.698326
|   |   |   |   |   |   |   request_lng <= -73.910838
|   |   |   |   |   |   |   |   request_lat <= 40.708799
|   |   |   |   |   |   |   |   |   request_lat <= 40.704221: Kings (393.0/12.0)
|   |   |   |   |   |   |   |   |   request_lat > 40.704221
|   |   |   |   |   |   |   |   |   |   request_lng <= -73.919132: Kings (105.0/7.0)
|   |   |   |   |   |   |   |   |   |   request_lng > -73.919132: Queens (100.0/34.0)
|   |   |   |   |   |   |   |   request_lat > 40.708799: Queens (102.0)
|   |   |   |   |   |   |   request_lng > -73.910838: Queens (156.0)
|   |   request_lat > 40.73437: Queens (1088.0/2.0)
|   request_lng > -73.907318
|   |   request_lng <= -73.733774
|   |   |   request_lng <= -73.875524
|   |   |   |   request_lat <= 40.69457: Kings (1278.0/20.0)
|   |   |   |   request_lat > 40.69457: Queens (2993.0/7.0)
|   |   |   request_lng > -73.875524
|   |   |   |   request_lng <= -73.857488
|   |   |   |   |   request_lat <= 40.689962
|   |   |   |   |   |   request_lng <= -73.865395: Kings (195.0/14.0)
|   |   |   |   |   |   request_lng > -73.865395: Queens (123.0/45.0)
|   |   |   |   |   request_lat > 40.689962: Queens (5865.0/2.0)
|   |   |   |   request_lng > -73.857488: Queens (12723.0/85.0)
|   |   request_lng > -73.733774
|   |   |   request_lng <= -73.42986
|   |   |   |   request_lng <= -73.703632
|   |   |   |   |   geofence$combo <= -2997.166598
|   |   |   |   |   |   request_lat <= 40.767757
|   |   |   |   |   |   |   geofence$combo <= -3002.275265: Queens (167.0/5.0)
|   |   |   |   |   |   |   geofence$combo > -3002.275265
|   |   |   |   |   |   |   |   request_lng <= -73.724344: Queens (101.0/18.0)
|   |   |   |   |   |   |   |   request_lng > -73.724344: Nassau (171.0/8.0)
|   |   |   |   |   |   request_lat > 40.767757: Nassau (180.0)
|   |   |   |   |   geofence$combo > -2997.166598: Nassau (198.0)
|   |   |   |   request_lng > -73.703632: Nassau (2721.0/29.0)
|   |   |   request_lng > -73.42986: Suffolk (577.0/5.0)


I saved mine as nyc_tile_tree.csv

What you see here is a set of rules that uses latitude, longitude and latitude * longitude (for curved boundaries) to map a point to a geofence. The decision tree algorithm was able to learn these rules from our data set. We now want to translate this rule set into a SQL CASE WHEN statement so we can use it in a query.

Run the below script. It should prompt you to choose your newly made .csv. Change the regions in bold to whatever your geo regions are.

treeTranslator.r

The output is a funky nested case when like this: 

I usually copy/paste this over to Sublime Text Editor and remove the [1]’s and the double quotes. At this point, we are ready to query!






