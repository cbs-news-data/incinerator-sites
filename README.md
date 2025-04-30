# U.S. Incinerators

Code and analysis for examining municipal waste incinerators and their proximity to disadvantaged communities identified by the Justice40 initiative.

## Overview

This project analyzes the location of 72 municipal solid waste (MSW) incinerators across the U.S. and how they intersect with disadvantaged Census tracts as defined by the federal Justice40 initiative. The analysis includes spatial buffers to assess how many communities fall within three miles of these facilities – a distance commonly used in environmental justice studies.

## Data
- data/incinerator-sites.csv: List of commercial waste combustors from the EPA. Filtered to include only MSW incinerators.
- data/J40.geojson: GeoJSON of Justice40-designated disadvantaged Census tracts.
- data/for-map/: Folder containing processed GeoJSONs used in the interactive map.

## Script
- analysis.R: Main R script that processes incinerator location data, generates 3-mile buffers, performs spatial joins with Justice40 tracts, and prepares data for visualization.

## Output
These files are created by the script and used for mapping and data visualization:
- output/MSW_sites_sf.geojson: GeoJSON of incinerator point locations.
- output/site_buffers.geojson: GeoJSON of 3-mile buffer zones around incinerators.

## Visualization
An interactive map was created using MapLibre with layers for:
	•	MSW incinerator sites
	•	3-mile site buffer zones
	•	Justice40 disadvantaged areas


## Contact
Please contact Taylor Johnston at taylor.johnston@cbsnews.com with any questions.
