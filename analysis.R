# Load libraries
library(dplyr)
library(sf)
library(janitor)
library(ggplot2)

# Read in incinerator sites
# Data from EPA: https://www.epa.gov/household-medication-disposal/map-commercial-waste-combustors-us
sites <- read.csv("data/incinerator-sites.csv") %>% 
  clean_names()

# Filtering to get MSW sites only (large and small municipal waste combustors)
MSW_sites <- sites %>% filter(type == "MSW Combustors") %>% select(facility_name, city, state, lat, lon)

# Convert sites to sf and reproject to a CRS with meters
MSW_sites_sf <- st_as_sf(MSW_sites,
                           coords = c("lon", "lat"),
                           crs = 4326)

MSW_sites_sf <- st_transform(MSW_sites_sf, 3857)  # Use a projected CRS for distance

st_write(MSW_sites_sf, "output/MSW_sites_sf.geojson", append=FALSE)

# Buffer each site location by 3 miles (~4828 meters)
site_buffers <- st_buffer(MSW_sites_sf, dist = 4828)

st_write(site_buffers, "output/site_buffers.geojson", append=FALSE)

# Read the shapefile and filter for SN_C == TRUE (disadvantaged tracts)
justice_40_data <- st_read("data/justice_40/usa/usa.shp")
justice_40_data <- justice_40_data %>%
  filter(SN_C == 1) %>%
  select(SF, SN_C)

# Reproject Justice40 tracts to match plant buffers
justice_40_proj <- st_transform(justice_40_data, 3857)

# Count tracts by SN_C status (1 = disadvantaged, 0 = not)
tract_counts <- justice_40_data %>%
  st_drop_geometry() %>%
  mutate(SN_C = case_when(
    SN_C == 1 ~ "Disadvantaged",
    SN_C == 0 ~ "Not Disadvantaged",
    TRUE ~ as.character(SN_C)
  )) %>%
  group_by(SN_C) %>%
  summarise(total = n())

# Perform spatial join: check if buffer overlaps a disadvantaged tract
buffers_with_overlap <- st_join(site_buffers, justice_40_proj, join = st_intersects)

# Count unique plant names that overlap with a disadvantaged tract
num_unique_incinerators_near_disadvantaged <- buffers_with_overlap %>%
  filter(!is.na(SN_C)) %>%
  distinct(facility_name) %>%
  nrow()


site_buffers_wgs84 <- st_transform(site_buffers, crs = 4326)
st_write(site_buffers_wgs84, "data/for-map/site_buffers_wgs84.geojson", delete_dsn = TRUE)

MSW_sites_sf_wgs84 <- st_transform(MSW_sites_sf, crs = 4326)
st_write(MSW_sites_sf_wgs84, "data/for-map/MSW_sites_sf_wgs84.geojson", delete_dsn = TRUE)
