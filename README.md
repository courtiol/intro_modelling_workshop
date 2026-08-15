# Introduction to Basic and Advanced Statistical Modelling

This is the content of an introductory course to statistical modelling.

Here is a list of the R packages used in the course:

```r
packages_needed_for_user <- c("tidyverse", "sf", "units", "geomtextpath",
                              "nimble", "posterior", "bayesplot",
                              "spaMM")
                     
packages_needed_for_devel <- c("quarto", "knitr", "kableExtra")
```

After running the previous chunk in R, you can install those packages like this:
```r
install.packages(packages_needed_for_user)
install.packages(packages_needed_for_devel) # only if you need to re-render the slides
```


Here is a list of the LaTeX packages used to create the slides:

```latex
caption
textpos
xcolor
colortbl
makecell
tcolorbox
etoolbox
forest
amssymb
```

On my linux Fedora-based system, those can be installed in the terminal as:

```bash
sudo dnf install texlive-xxx
```

with `xxx` corresponding to the name of the LaTeX package.

