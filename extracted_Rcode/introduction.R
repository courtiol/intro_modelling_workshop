knitr::include_graphics("figures/Alexandre_Courtiol.jpg", dpi = NA) # dpi = NA fix aspect ratio issue

knitr::include_graphics("figures/Rahel_Sollmann.jpg", dpi = NA) # dpi = NA fix aspect ratio issue

article_figs <- dir(path = "figures/article_selection/normalized/",
                    pattern = "article_", full.names = TRUE)
years <- as.integer(sub(".*?(\\d{4})\\.[^.]+$", "\\1", article_figs))
knitr::include_graphics(article_figs[order(years, decreasing = TRUE)])

knitr::include_graphics("figures/Culture_map_FR_VN.png")
