library(tidyverse)
library(sf)
library(stars)

# read the NLCD data, pull out its coordinate system
# note this is a stars_proxy object because it's too large
nlcd <- stars::read_stars('/mnt/data/nlcd2016_ny.tif')
nlcd_coords <- st_crs(nlcd)

# load data
substations <- sf::read_sf('/mnt/data/usa_electric_substations.kml')
substations_ny <- filter(substations, STATE == "NY") %>% 
  st_transform(nlcd_coords)
# TODO: filter out inoperational stations

states <- sf::read_sf('/mnt/data/usa_states.geojson.json')
ny_boundary <- filter(states, NAME == "New York") %>% 
  st_transform(nlcd_coords)

buffer <- st_buffer(substations_ny, units::as_units('2mi'))
buffer_together <- st_union(buffer)

st_area(buffer_together) / st_area(ny_boundary)

ggplot(substations_ny) + 
  geom_sf(data=ny_boundary) + 
  geom_sf(data=buffer_together, color='red') +
  coord_sf()

nlcd[buffer_together] %>%
  pull(nlcd2016_ny.tif) %>%
  st_as_stars(downsample=20) %>%
  table() %>%
  as_tibble() %>%
  rename(landtype = 1)


###

# TODO distribution of population distance to a substation; what % of people are within 2 mi?
# further: within 2 mi AND there is at least X acres of solar-able land in that radius

# bar chart: composition land within substation boundaries

# `gdalwarp -t_srs EPSG:4326 nlcd2016_ny.tif nlcd2016_ny-4326.tif`
# TODO: st_warp with use_gdal=TRUE
#nlcd <- stars::read_stars('/mnt/data/nlcd2016_ny.tif')
#new_crs = st_crs(4326)
#nlcd_fixed <- stars::st_warp(nlcd, crs=new_crs, use_gdal = TRUE)
nlcd_fixed <- stars::read_stars('/mnt/data/nlcd2016_ny-4326.tif')

buffer_raster <- stars::st_rasterize(buffer_togther)


#land_around_substations <- aggregate(nlcd_fixed, buffer_together, function(x) x[1], as_points = FALSE)	
#land_around_substations <-  nlcd_fixed[buffer_together_fixed] #? #all of this needs to be redone
land_around_substations <- stars::read_stars('/mnt/output/substation-landuse.tif')
