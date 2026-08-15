## set tibble sizes via pillar
options(width = 90, pillar.width = 90,
        pillar.print_min = 3, pillar.print_max = 3)

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

## set base size in ggplot2
ggplot2::theme_set(ggplot2::theme_grey(base_size = 20))

## counter for practice slides, to be called with `r next_practice()`
practice_counter <- 0
next_practice <- function() {
  practice_counter <<- practice_counter + 1
  practice_counter
}

knitr::include_graphics("figures/Rstudio.png", dpi = NA) # dpi = NA fix aspect ratio issue

knitr::include_graphics("figures/MHB.png", dpi = NA)

library(tidyverse)

species_count <- read_csv("data_MHB/header-species-count.csv")

species_count

territories <- read_csv("data_MHB/data-territories.csv")

territories

knitr::include_graphics("figures/dplyr.jpg", dpi = NA)

species_count |> select(samplearea_id, year, n_recorded_species)

# species_count |> select(samplearea_id, year, n_recorded_species)

# select(species_count, samplearea_id, year, n_recorded_species)

species_count |> select(n_recorded_species)

species_count |> pull(n_recorded_species)

species_count |> filter(year == 2025)

species_count |> filter(if_any(everything(), is.na)) #everything() selects all columns

territories |> filter(if_any(everything(), is.na))

species_count |> slice(1:3) # keeps the first 3 rows

species_count |>
    slice_max(n_recorded_species, n = 3) # keeps the top 3 sites by n_recorded_species

species_count |> distinct(samplearea_id, lon, lat)

species_count |> 
    filter(year == 2025) |> 
    select(samplearea_id, year)

species_count_2025 <- species_count |> filter(year == 2025)

species_count |> filter(year == 2025) -> species_count_2025

species_count |> arrange(year)

species_count |> 
    select(samplearea_id, route_length, year) |>
    filter(year == 2025) |> 
    mutate(short_transect = route_length < mean(route_length))


species_count |> 
    summarise(min_route_length = min(route_length),
              max_route_length = max(route_length))

species_count |> 
    summarise(max_sp = max(n_recorded_species), .by = year)

territories |> 
    filter(territories_total > 0) |> 
    summarise(sp = list(nameeg), .by = c(samplearea_id, year))

territories |> 
    filter(territories_total > 0) |> 
    summarise(sp = list(nameeg), .by = c(samplearea_id, year)) |> 
    rowwise() |> 
    mutate(mute_swan = "Mute Swan" %in% sp) |> 
    ungroup()

species_count |> count(year)

territories |> left_join(species_count)

territories |> 
    filter(year == 2025) |> 
    select(samplearea_id, nameeg, territories_total) |> 
    pivot_wider(names_from = nameeg, 
                values_from = territories_total)

# territories |>
#     filter(year == 2025) |>
#     select(samplearea_id, nameeg, territories_total) |>
#     pivot_wider(names_from = nameeg,
#                 values_from = territories_total)

library(sf)
species_count |> 
    st_as_sf(coords = c("lon", "lat"), crs = 4326) -> species_count_sf

species_count_sf

species_count_sf |> 
    summarise(geometry = st_combine(geometry)) |> # all points are brought together
    mutate(hull = st_convex_hull(geometry), # create shapes encompassing all points
           area_m2 = st_area(hull), # compute the area in m^2
           area_km2 = units::set_units(area_m2, "km^2")) |> # express area in km^2
    select(-hull) |> # drop the hull
    st_drop_geometry() # drop the geometry

species_count_sf |> 
  distinct(samplearea_id, geometry) |> 
  mutate(centroid = st_centroid(st_combine(geometry)),
         dist = st_distance(centroid, geometry, by_element = TRUE))

ggplot(species_count) +
  geom_point(aes(y = n_recorded_species, x = route_length)) +
  labs(y = "Nb. of recorded species", x = "Length of the transect (m)")

knitr::include_graphics("figures/ggplot_book.jpg", dpi = NA)

knitr::include_graphics("figures/ggplot2.jpg", dpi = NA)

species_count |>
  mutate(n_visits = factor(n_visits)) |> 
  ggplot() +
    geom_point(aes(y = median_elevation, x = n_visits))

species_count |>
  mutate(n_visits = factor(n_visits)) |> 
  ggplot() +
    geom_boxplot(aes(y = median_elevation, x = n_visits))

species_count_sf |>
  filter(year == 2025) |>
  ggplot() +
    geom_sf(aes(size = n_recorded_species)) # geometry = geometry is assumed

# ggplot(species_count) +
#   geom_point(aes(y = n_recorded_species, x = route_length, colour = "blue"))

# ggplot(species_count) +
#   geom_point(aes(y = n_recorded_species, x = route_length), colour = "blue")

species_count |>
    filter(year == 2025) |> 
    mutate(n_visits = factor(n_visits)) |> 
    ggplot(aes(y = median_elevation, x = n_visits)) +
      geom_violin() +
      geom_jitter(height = 0, width = 0.1)

species_count_sf |>
    mutate(hotspot = factor(n_recorded_species > 50)) |> 
    ggplot() +
      geom_sf(aes(colour = hotspot, alpha = hotspot)) +
      facet_wrap(~ year)

species_count_sf |>
    filter(year == 2025) |> 
    ggplot() +
        geom_sf(aes(size = n_recorded_species,
                    colour = n_recorded_species)) +
        scale_color_binned(palette = rainbow, name = "Nb. of species") +
        scale_size_binned(range = c(0.5, 5), name = "Nb. of species") +
        guides(size = guide_bins(), color = guide_bins()) + # unusually needed here
        theme_bw(base_size = 25)

ggplot(species_count) +
  geom_point(aes(y = n_recorded_species, x = route_length)) +
  theme_sub_axis(text = element_text(size = 15, face = "bold", colour = "red"),
                 title = element_text(face = "italic", hjust = 1)) +
  theme_sub_panel(grid.major.x = element_line(linetype = "dotted", colour = "black"),
                  background = element_rect(fill = "lightgreen")) +
  theme_sub_plot(background = element_rect(fill = "dodgerblue", colour = "goldenrod",
                                           linewidth = 10))

(theme_bw(base_size = 20) +
  theme_sub_axis(text = element_text(colour = "red"))) |> 
  theme_set()

ggplot(species_count) +
  geom_point(aes(y = n_recorded_species, x = route_length))

species_count |> 
    summarise(mean_nb_sp = mean(n_recorded_species), .by = year)

results <- data.frame(year = unique(species_count$year), mean_nb_sp = NA)
for (y in unique(species_count$year)) {
    n_recorded_species_year <- species_count$n_recorded_species[species_count$year == y]
    results[results$year == y, "mean_nb_sp"] <- mean(n_recorded_species_year)
}
head(results, n = 3)

results <- with(species_count, 
                aggregate(list(mean_nb_sp = n_recorded_species),
                          by = list(year = year), FUN = mean))
head(results, n = 3)

some_vector <- letters
some_vector
some_vector[c(1, 12, 5, 24)]
some_vector[some_vector %in% c("a", "l", "e", "x")]

some_namedvector <- c(a = 1, b = 5)
some_namedvector["b"]

some_list <- list(1, 1:5)
some_list
some_list[2]
some_list[[2]]
some_list[[2]][2]

some_namedlist <- list(a = 1, b = 1:5)
some_namedlist["b"]
some_namedlist[["b"]]
some_namedlist$b

some_matrix <- matrix(1:9, nrow = 3)
some_matrix
some_matrix[2, ]
some_matrix[, 2]
some_matrix[2, 2]

some_matrix[c(1, 3), c(1, 3)]
some_matrix[cbind(c(1, 3), c(1, 3))]

colnames(some_matrix) <- paste0("col_", 1:3)
rownames(some_matrix) <- paste0("row_", 1:3)
some_matrix
some_matrix["row_2", "col_3"]

species_count[1, ]
species_count[, 1]

species_count[, "year"]
species_count["year"]

species_count_small <- slice(species_count, 1:10) # for smaller data
species_count_small[["year"]]
species_count_small$year
