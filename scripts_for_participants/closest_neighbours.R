## Example of application: flagging sites too far from others (by Alex)

library(tidyverse)
library(sf)

species_count <- read_csv("data_MHB/header-species-count.csv")

species_count |> 
  st_as_sf(coords = c("lon", "lat"), crs = 4326) |> 
  distinct(samplearea_id, geometry) -> sites ## dataset with unique sites

sites |> 
  rename(otherarea_id = samplearea_id, other_geometry = geometry) -> sites2

expand_grid(sites, sites2) |> # generate all pairwise combination
  st_as_sf() |> 
  filter(otherarea_id != samplearea_id) |> # remove duplicates
  mutate(distance = st_distance(geometry, other_geometry, by_element = TRUE)) |> # measure distance by row
  slice_min(distance, by = samplearea_id) |> # retain closest
  mutate(distance = as.numeric(distance)) -> data_closest

## check distribution of distance to closest neighbours
ggplot(data_closest) +
  aes(x = distance) +
  geom_step(stat = "ecdf")

## checks pairs further than 15 km apart
data_closest |> 
  filter(distance > 15000)

## create lines join closest neighbours (for plotting)
data_closest |> 
  rowwise() |> 
  mutate(line = st_combine(c(geometry, other_geometry)),
         line = st_cast(line, "LINESTRING")) |> 
  ungroup() |> 
  mutate(too_far = distance > 15000) -> data_closest_with_lines

## create site with those too far identified (for plotting)
data_closest_with_lines |> 
  summarise(too_far = any(too_far),
            across(geometry, st_union),
            .by = samplearea_id) -> sites_info

## plot
ggplot() +
  geom_sf(aes(colour = too_far, geometry = line), data = data_closest_with_lines) +
  geom_sf(aes(geometry = geometry, colour = too_far), alpha = 0.3, data = sites_info) +
  scale_colour_manual(values = c("blue", "red")) +
  labs(colour = "distance > 15km") +
  theme_void()
