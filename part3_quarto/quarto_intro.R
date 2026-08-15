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

df <- data.frame(Tool = c("R script", "R package*", "sweave", "rmarkdown/quarto"),
                 "Literate programming**" = c("no", "yes", "yes", "yes"),
                 Setup = c("simple", "difficult", "medium", "simple"),
                 "Learning curve" = c("low", "high", "high", "low/mid"),
                 check.names = FALSE)

knitr::kable(df, booktabs = TRUE, align = "lccc") |> 
  kableExtra::kable_styling(font_size = 10)

knitr::include_graphics("figures/rstudio-qmd-how-it-works.png", dpi = NA) # dpi = NA fix aspect ratio issue
