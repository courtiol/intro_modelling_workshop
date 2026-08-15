## set tibble sizes via pillar
options(width = 90, pillar.width = 90,
        pillar.print_min = 4, pillar.print_max = 4)

## set output text size
knitr::opts_chunk$set(size = "footnotesize")
def.chunk.hook <- knitr::knit_hooks$get("chunk")
knitr::knit_hooks$set(chunk = function(x, options) {
  x <- def.chunk.hook(x, options)
  if (!is.null(options$size) && options$size != "normalsize") {
    paste0("\n\\", options$size, "\n\n", x, "\n\n\\normalsize")
  } else {
    x
  }
})

## counter for practice slides, to be called with `r next_practice()`
practice_counter <- 0
next_practice <- function(counter = NULL) {
  if (!is.null(counter)) 
      practice_counter <<- counter
  else
    practice_counter <<- practice_counter + 1
  practice_counter
}

library(tidyverse)
library(sf)
species_count <- read_csv("data_MHB/header-species-count.csv")
species_count_sf <- st_as_sf(species_count, coords = c("lon", "lat"), crs = 4326)

territories <- read_csv("data_MHB/data-territories.csv")

# species_count |>
#     arrange(desc(n_recorded_species)) |>
#     slice(1) |>
#     select(n_recorded_species)

# species_count |>
#     filter(n_recorded_species == max(n_recorded_species)) |>
#     select(n_recorded_species)

# species_count |>
#     filter(year == 2025) |>
#     filter(n_recorded_species == max(n_recorded_species)) |>
#     select(n_recorded_species)

# species_count |>
#     filter(year == 2025, n_recorded_species == max(n_recorded_species)) |>
#     select(n_recorded_species)

species_count |> 
    summarise(median_elevation_min = min(median_elevation),
              median_elevation_max = max(median_elevation),
              .by = n_visits)

territories |> 
    filter(namelt == "Sturnus vulgaris") |> 
    summarise(territories_sum = sum(territories_total, na.rm = TRUE), # NAs present
              .by = year)

territories |> 
    summarise(territories_sum = sum(territories_total),
              .by = c(year, nameeg, namelt)) |> # aggregate across samplearea_id
    slice_max(territories_sum, n = 3, by = year) |> # pick top 3 per year
    select(year, nameeg, namelt, territories_sum)

territories |> 
    filter(year == 2025) |> 
    select(samplearea_id, nameeg, territories_total) |> 
    pivot_wider(names_from = nameeg, 
                values_from = territories_total) |> 
    pivot_longer(-samplearea_id,
                 names_to = "nameeg",
                 values_to = "territories_total")

species_count_sf |> 
    summarise(geometry = st_combine(geometry), .by = year) |> 
    mutate(hull = st_convex_hull(geometry),
           area = st_area(hull),
           area_km2 = units::set_units(area, "km^2")) |> 
    select(-hull) |> 
    st_drop_geometry()

species_count_sf |> 
  distinct(samplearea_id, geometry) |> 
  mutate(centroid = st_centroid(st_combine(geometry)),
         dist = st_distance(centroid, geometry, by_element = TRUE)) |> 
  arrange(desc(dist)) |> 
  as_tibble() # (for slide only -> skip metadata clutter)

species_count_sf |> 
  distinct(samplearea_id, .keep_all = TRUE) |> 
  mutate(all_points = st_combine(geometry), # combine points into new geometry
         hull = st_concave_hull(all_points, ratio = 0.2), # create concave hull
         perimeter = st_boundary(hull), # extract outer line of the hull
         perimeter = st_buffer(perimeter, dist = 1000), # create buffer zone around it
         on_perim = st_intersects(perimeter, geometry, # test if points fall into buffer
                                  by_element = TRUE)) -> data_perimeter_sf 
  
data_perimeter_sf |> 
    filter(on_perim) |> 
    pull(samplearea_id) # pull() extracts a column

theme_set(theme_bw(base_size = 20)) # setting the theme for all plots
ggplot(data_perimeter_sf) +
  geom_sf(aes(geometry = perimeter)) +
  geom_sf(aes(colour = on_perim)) # geometry = geometry is implicit

territories |> 
    summarise(territories_sum = sum(territories_total),
              .by = c(nameeg, namelt)) |> 
    slice_max(territories_sum, n = 6) |> 
    pull(namelt) -> top6sp

top6sp

territories |> 
    filter(namelt %in% top6sp) |> 
    summarise(territories_sum = sum(territories_total),
              .by = c(nameeg, namelt, year)) -> top6_across_time

top6_across_time

ggplot(top6_across_time) +
  geom_line(aes(y = territories_sum, x = year, colour = nameeg))

ggplot(top6_across_time) +
  geom_line(aes(y = territories_sum, x = year)) +
  facet_wrap(~ nameeg, scales = "free_y")
