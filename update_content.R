## this script renders all quarto files and extract the R code from them

quarto_files <- dir(pattern = "\\.qmd", recursive = TRUE, full.names = TRUE)

system.time({
  for (q in quarto_files) {
      quarto::quarto_render(q)
  }
})


for (q in quarto_files) {
    filename <- sub(".qmd", ".R", basename(q))
    knitr::purl(q, output = paste0(dirname(q), "/", filename), documentation = 0)
}

