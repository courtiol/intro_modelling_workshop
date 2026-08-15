quarto_files <- dir(pattern = "\\.qmd", recursive = TRUE, full.names = TRUE)

for (q in quarto_files) {
    quarto::quarto_render(q)
}
