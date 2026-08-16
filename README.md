# Introduction to Basic and Advanced Statistical Modelling

**NB:** this repository is a work in progress.

It contains the material used for a course in statistical modelling.

## 🚀 Getting Started

### Course Materials
The course is divided into five parts. To access the presentations, navigate to the corresponding folder and download the **PDFs**:

*   `part1_introduction` $\rightarrow$ introduction.pdf
*   `part2_R` $\rightarrow$ Rintro.pdf
*   `part3_quarto` $\rightarrow$ quarto_intro.pdf
*   `part4_fundamentals` $\rightarrow$ fundamentals.pdf
*   `part5_modelling` $\rightarrow$ modelling_intro.pdf

### Running the Code
If you wish to run the examples from the slides, use the `.R` files. These contain all code used in the presentations, including hidden code used to generate figures.

**Dependencies:**

To run the code, install the following R packages:

```r
install.packages(c("tidyverse", "sf", "units", "geomtextpath", 
                   "nimble", "brms", "posterior", "bayesplot",
                   "spaMM"))
```

## Technical Notes & Development

Here is a short synthesis of my notes. For more details, see: NOTES.md

### Rendering the Slides

The main folders contain the Quarto documents (`.qmd` files) used to generate each PDF.

You will need additional packages to render them:

```r
install.packages(c("quarto", "knitr", "kableExtra"))
```

### LLM Usage Disclosure
I did not use LLMs to produce slides or R content from scratch.

Claude Sonnet 3.5 and Gemma 4 were used for:

- converting LibreOffice slides to Quarto (text extraction)
- troubleshooting Quarto/LaTeX formatting issues
- content review (checking for typos, statistical inaccuracies, and conceptual gaps)

### Toolchain & Pain Points

I used the Quarto/Beamer combination to generate PDF slides.
While the prospect of writing Markdown was attractive, the need for precise formatting led to extensive use of LaTeX.
This resulted in a "polyglot" mix of YAML, Markdown and LaTeX, which often led to unpredictable interactions between Quarto, Pandoc, and LaTeX (particularly regarding spacing and environment nesting).
So I spent a lot of time debugging LaTeX compilation failure for an output not as beautiful HTML ioslides despite more formatting effort put into it.
For rendering the Quarto files, you will need as least the following LaTeX packages:
`caption`, `textpos`, `xcolor`, `colortbl`, `makecell`, `tcolorbox`, `etoolbox`, `forest`, `amssymb`.
