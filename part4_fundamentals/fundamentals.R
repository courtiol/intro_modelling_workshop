## load packages
start <- Sys.time() # for recording duration
library(tidyverse)
library(geomtextpath)

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
theme_set(theme_classic(base_size = 30))

## counter for practice slides, to be called with `r next_practice()`
practice_counter <- 0
next_practice <- function(counter = NULL) {
  if (!is.null(counter)) 
      practice_counter <<- counter
  else
    practice_counter <<- practice_counter + 1
  practice_counter
}

knitr::include_graphics("figures/twin_studies.png", dpi = NA)

knitr::include_graphics("figures/twin_studies_title.png", dpi = NA) # dpi = NA fix aspect ratio issue

ggplot() +
  stat_function(fun = dnorm, n = 100, fill = "#595959",
                xlim = c(-4, 4), geom = "area") +
  labs(y = "Density")

ggplot() +
  stat_function(fun = \(x) dchisq(x, df = 5),
                n = 100, fill = "#595959",
                xlim = c(0, 20), geom = "area") +
  labs(y = "Density")

tibble(x = 0:10,
       density = dpois(x, lambda = 2)) |> 
  ggplot() +
    aes(x = x, y = density) +
    geom_col(fill = "#595959") +
    labs(y = "Density")

iris |> count(Species)

table(iris$Species)

# ggplot(iris) +
#   aes(x = Species) +
#   geom_bar()

ggplot(iris) +
  aes(x = Species) +
  geom_bar()

# ggplot(iris) +
#   aes(x = Petal.Length) +
#   geom_step(stat = "ecdf") +
#   geom_point(stat = "ecdf") +
#   labs(y = "Cumulative probability",
#        x = "Petal length")

ggplot(iris) +
  aes(x = Petal.Length) +
  geom_step(stat = "ecdf") +
  geom_point(stat = "ecdf") +
  labs(y = "Cumulative probability",
       x = "Petal length")

quantile(iris$Petal.Length, probs = 0.75)

ggplot(iris) +
  aes(x = Petal.Length) +
  geom_step(stat = "ecdf") +
  geom_point(stat = "ecdf") +
  geom_segment(y = 0.75, yend = 0.75,
               x = 0, xend = quantile(iris$Petal.Length, 0.75),
               colour = "#3333B3") +
  geom_segment(y = 0.75, yend = 0,
               x = quantile(iris$Petal.Length, 0.75),
               xend = quantile(iris$Petal.Length, 0.75),
               arrow = grid::arrow(), colour = "#3333B3") +
  scale_x_continuous(breaks = c(2, 4, 5.1, 6)) +
  labs(y = "Cumulative probability",
       x = "Petal length")

# set.seed(123) # randomness is "fixed"
# tibble(x = rnorm(n = 50)) |> # normal
# ggplot(aes(sample = x)) +
#   geom_qq(shape = 1) +
#   geom_qq_line()

set.seed(123)
tibble(x = rnorm(n = 50)) |> 
  ggplot(aes(sample = x)) +
  geom_qq(shape = 1) +
  geom_qq_line()

# set.seed(123)
# d <- tibble(x = rchisq(n = 50, df = 4))
# 
# ggplot(d) +
#   aes(sample = x) +
#   geom_qq(shape = 1) +
#   geom_qq_line()
# 
# ## replicate the qqplot (ppoints generates a seq of prob):
# d |>
#   mutate(prob = ppoints(length(x)),
#          theoretical = qnorm(prob)) -> d_qq
# 
# Y <- quantile(d_qq$x, probs = c(0.25, 0.75))
# X <- qnorm(c(0.25, 0.75))
# slope <- diff(Y)/diff(X)
# intercept <- Y[1] - slope*X[1]
# 
# d_qq |>
#   ggplot() +
#     aes(x = theoretical, y = sort(x)) +
#     geom_point() +
#     geom_abline(slope = slope, intercept = intercept)

# set.seed(123) # randomness is "fixed"
# tibble(x = rchisq(n = 50, df = 2)) |> # chi-squared
# ggplot(aes(sample = x)) +
#   geom_qq(shape = 1) +
#   geom_qq_line()

set.seed(123)
tibble(x = rchisq(n = 50, df = 2)) |> 
  ggplot(aes(sample = x)) +
  geom_qq(shape = 1) +
  geom_qq_line()

# ggplot(iris) +
#   aes(x = Petal.Length) +
#   geom_histogram(colour = "white") +
#   geom_rug()

ggplot(iris) +
  aes(x = Petal.Length) +
  geom_histogram(colour = "white") +
  geom_rug()

# ggplot(iris) +
#   aes(x = Petal.Length) +
#   geom_histogram(colour = "white", binwidth = 0.5) +
#   geom_rug()

ggplot(iris) +
  aes(x = Petal.Length) +
  geom_histogram(colour = "white", binwidth = 0.5) +
  geom_rug()

knitr::include_graphics("figures/distributions.png", dpi = NA) # dpi = NA fix aspect ratio issue

dbinom(x = 0:10, size = 10, prob = 0.2)

library(tidyverse)
tibble(Successes = 0:10,
       Density = dbinom(Successes, size = 10, prob = 0.2)) |> 
  ggplot() + 
    aes(y = Density, x = Successes) + 
    geom_col(width = 0.5) +
    scale_x_continuous(breaks = 0:10) + 
    labs(x = "Successes")

dbinom(x = 1, size = 10, prob = 0.05)

library(tidyverse)
tibble(Successes = 0:10,
       Density = dbinom(Successes, size = 10, prob = 0.05),
       Select = Successes == 1) |> 
  ggplot() + 
    aes(y = Density, x = Successes, fill = Select) + 
    geom_col(width = 0.5) +
    scale_x_continuous(breaks = 0:10) + 
    scale_fill_manual(values = c("#595959", "#3333B3"), guide = "none") +
    labs(x = "Successes")

pbinom(q = 0:10, size = 10, prob = 0.2)

d <- tibble(Successes = c(0, 0:10),
            Cumulative_prob = c(0, pbinom(q = 0:10, size = 10, prob =  0.2)))
ggplot(d) + 
  aes(y = Cumulative_prob, x = Successes) + 
  geom_step(linewidth = 1) +
  geom_point(data = d[-1, ]) +
  scale_x_continuous(breaks = 0:10) +
  scale_y_continuous(limits = c(0, 1)) +
  labs(y = "Cumulative probability", x = "Successes")

1 - pbinom(q = 1, size = 10, prob = 0.05)

tibble(Successes = 0:10,
       Prob = 1 - pbinom(q = Successes - 1, size = 10, prob = 0.05, lower.tail = TRUE),
       Select = Successes == 2) |> 
  ggplot() + 
    aes(y = Prob, x = Successes) + 
    geom_step(linewidth = 1) +
    geom_point(aes(colour = Select)) +
    scale_x_continuous(breaks = 0:10) +
    scale_y_continuous(limits = c(0, 1)) +
    scale_colour_manual(values = c("black", "#3333B3"), guide = "none") +
    labs(y = "Prob. of at least x successes", x = "Successes")

dnorm(x = seq(-4, 4, length.out = 100))

ggplot() +
  geom_function(fun = dnorm, n = 100,
                xlim = c(-4, 4), size = 1) +
  labs(y = "Density")

 pnorm(q = seq(-4, 4, length.out = 100))

tibble(x = seq(-4, 4, length.out = 1000),
       Cumulative_prob = pnorm(x)) |> 
  ggplot() +
    aes(x = x, y = Cumulative_prob) + 
    geom_line(size = 1) +
    labs(y = "Cumulative probability")

tibble(x = seq(-4, 4, length.out = 1000),
       Density = dnorm(x),
       Density_focus = if_else(abs(x) < qnorm(0.975), Density, 0)) |> 
  ggplot() +
    aes(x = x, y = Density) +
    geom_area(aes(y = Density_focus), fill = "grey") + 
    geom_segment(y = 0, yend = 0, x = -4, xend = 4,
                 linewidth = 2,
                 colour = "#F8766D") +
    geom_segment(y = 0, yend = 0, x = qnorm(0.025), xend = qnorm(0.975),
                 linewidth = 2,
                 colour = "#00BFC4") +
    scale_x_continuous(breaks = c(-4, -1.96, 0, 1.96, 4)) +
    geom_line(size = 1) +
    geom_vline(xintercept = qnorm(0.025), linetype = "dashed", size = 1) +
    geom_vline(xintercept = qnorm(0.975), linetype = "dashed", size = 1) +
    labs(y = "Density")

tibble(q = seq(-4, 4, length.out = 1000),
       Cumulative_Density = pnorm(q),
       Cumulative_Density_focus = if_else(abs(q) < qnorm(0.975), Cumulative_Density, 0)) |>
  ggplot() +
    aes(x = q, y = Cumulative_Density) +
    geom_area(aes(y = Cumulative_Density_focus), fill = "grey") + 
    scale_x_continuous(breaks = c(-4, -1.96, 0, 1.96, 4), limits = c(-5, 4)) +
    geom_line(size = 1) +
    geom_segment(y = 0.025, yend = 0.025,
                 xend = -5.4, x = qnorm(0.025),
                 arrow = grid::arrow(),
                 linewidth = 1) +
    geom_segment(y = 0.975, yend = 0.975,
                 xend = -5.4, x = qnorm(0.975),
                 arrow = grid::arrow(),
                 linewidth = 1) +
    geom_segment(y = 0.025, yend = 0.975,
                 x = -4.5, xend = -4.5, arrow = grid::arrow(ends = "both")) +
    annotate("text", x = -4, y = 0.5, label = "95%",
             hjust = 0, size = 9) +
    annotate("text", x = -4.2, y = 0.025, label = "pnorm(q = -1.96)",
             hjust = 0, vjust = -0.6, size = 7) +
    annotate("text", x = -4.2, y = 0.975, label = "pnorm(q = 1.96)",
             hjust = 0, vjust = -0.6, size = 7) +
    labs(y = "Cumulative probability", x = "x")

tibble(q = seq(-4, 4, length.out = 1000),
       Cumulative_Density = pnorm(q),
       Cumulative_Density_focus = if_else(abs(q) < qnorm(0.875), Cumulative_Density, 0)) |>
  ggplot() +
    aes(x = q, y = Cumulative_Density) +
    geom_area(aes(y = Cumulative_Density_focus), fill = "grey") + 
    scale_x_continuous(breaks = c(-4, -1.15, 0, 1.15, 4), limits = c(-5, 4)) +
    geom_line(size = 1) +
    geom_segment(y = 0.125, yend = 0.125,
                 x = -10, xend = qnorm(0.125),
                 linetype = "dashed", size = 1) +
    geom_segment(y = 0.875, yend = 0.875,
                 x = -10, xend = qnorm(0.875),
                 linetype = "dashed", size = 1) +
    geom_segment(y = 0.125, yend = 0.875,
                 x = -4.5, xend = -4.5, arrow = grid::arrow(ends = "both")) +
    geom_segment(y = 0.875, yend = 0,
                 x = qnorm(0.875), xend = qnorm(0.875),
                 arrow = grid::arrow(), linewidth = 0.6) +
    geom_segment(y = 0.125, yend = 0,
                 x = qnorm(0.125), xend = qnorm(0.125),
                 arrow = grid::arrow(), linewidth = 0.6) +
    annotate("text", x = -4, y = 0.5, label = "75%",
             hjust = 0, size = 9) +
    annotate("text", x = -1.2, y = 0.075,
             label = "qnorm(p = 0.125)", hjust = 1, size = 7) +
    annotate("text", x = 1.2, y = 0.075,
             label = "qnorm(p = 0.875)", hjust = 0, size = 7) +
    labs(y = "Cumulative probability", x = "x")

tibble(x = seq(-4, 4, length.out = 1000),
       Density = dnorm(x)) |> 
  ggplot() +
    aes(x = x, y = Density) + 
    geom_line(size = 1) +
    geom_segment(y = 0, yend = dnorm(-1), x = -1, xend = -1,
                 linewidth = 2, colour = "#3333B3") +
    geom_segment(y = dnorm(-1), yend = dnorm(-1), x = -1, xend = -4.3,
                 arrow = grid::arrow(), linewidth = 2, colour = "#3333B3")

tibble(x = seq(-4, 4, length.out = 1000),
       Cumulative_prob = pnorm(x)) |> 
  ggplot() +
    aes(x = x, y = Cumulative_prob) + 
    geom_line(size = 1) +
    geom_segment(y = 0, yend = pnorm(1), x = 1, xend = 1,
                 linewidth = 2, colour = "#3333B3") +
    geom_segment(y = pnorm(1), yend = pnorm(1), x = 1, xend = -4.3,
                 arrow = grid::arrow(), linewidth = 2, colour = "#3333B3") +
    labs(y = "Cumulative probability")

tibble(x = seq(-4, 4, length.out = 1000),
       Cumulative_prob = pnorm(x)) |> 
  ggplot() +
    aes(x = x, y = Cumulative_prob) + 
    geom_line(size = 1) +
    geom_segment(y = 0.75, yend = 0.75, x = -4.3, xend = qnorm(0.75),
                 linewidth = 2, colour = "#3333B3") +
    geom_segment(y = 0.75, yend = 0, x = qnorm(0.75), xend = qnorm(0.75),
                 linewidth = 2, colour = "#3333B3",
                 arrow = grid::arrow()) +
    labs(y = "Cumulative probability")

knitr::include_graphics("figures/bean_machine.png", dpi = NA) # dpi = NA fix aspect ratio issue

knitr::include_graphics("figures/CI.png", dpi = NA)

iris |>
  filter(Species == "versicolor") |> 
  mutate(density = dnorm(x = Petal.Length, mean = 4.5, sd = 0.5),
         log_density = dnorm(x = Petal.Length, mean = 4.5, sd = 0.5, log = TRUE)) |> 
  summarise(Lik = prod(density),
            logLik = sum(log_density))

iris |>
    filter(Species == "versicolor") -> iris2

plot_logLik <- function(mu, sigma) {
    tibble(x = seq(2, 6, length = 100),
           y = dnorm(x, mean = mu, sd = sigma)) |> 
        ggplot() +
        aes(y = y, x = x) +
        geom_line() +
        geom_segment(aes(x = Petal.Length,
                         xend = Petal.Length,
                         y = 0,
                         yend = density),
                     data = iris2 |>
                         mutate(density = dnorm(Petal.Length,
                                                mean = mu, sd = sigma)),
                     colour = "#3333B3", linewidth = 0.3) +
        geom_segment(aes(xend = 2,
                         x = Petal.Length,
                         y = density,
                         yend = density),
                     data = iris2 |>
                         mutate(density = dnorm(Petal.Length,
                                                mean = mu, sd = sigma)),
                     colour = "#3333B3",
                     arrow = grid::arrow(length = unit(7, "pt")),
                     linewidth = 0.3) +
        geom_point(aes(x = Petal.Length), y = 0,
                   data = iris2, shape = 21) +
        labs(y = "Density", x = "Petal Length (cm)") +
        annotate("text", y = 0.8, x = 4.7, hjust = 0,
                 label = paste("logLik =", round(sum(dnorm(iris2$Petal.Length,
                                                           mean = mu, sd = sigma, log = TRUE)), digit = 1))) +
        coord_cartesian(ylim = c(0, 0.8))
}

plot_logLik(4, 0.7)

plot_logLik(4.5, 0.7)

plot_logLik(4.5, 0.5)

# I use known ML estimates and CI from spaMM to avoid having to compute them numerically
ML <- sum(dnorm(iris2$Petal.Length,
                mean = mean(iris2$Petal.Length),
                sd = sd(iris2$Petal.Length)*sqrt((nrow(iris2) - 1)/nrow(iris2)),
                log = TRUE))
y_CI <- ML - qchisq(0.95, df = 1)/2
x_CI <- confint(spaMM::fitme(Petal.Length ~ 1, data = iris2),
                parm = "(Intercept)", verbose = FALSE)$interval

tibble(mu = seq(4, 4.5, length = 100),
       logLik = sapply(mu, \(m) {
    optimise(\(sd) sum(dnorm(x = iris2$Petal.Length, mean = m, sd = sd, log = TRUE)), interval = c(0.35, 0.7), maximum = TRUE)$objective
    })) |> 
    ggplot() +
      aes(y = logLik, x = mu) +
      geom_line() +
      geom_segment(y = ML,
               yend = -100,
               x = mean(iris2$Petal.Length),
               xend = mean(iris2$Petal.Length),
               linetype = "dashed",
               colour = "#3333B3") +
      geom_segment(y = ML, yend = ML, xend = 4, x = mean(iris2$Petal.Length),
                   colour = "red", linetype = "dotted") +
      labs(x = expression(mu)) +
      scale_y_continuous(breaks = c(-40:-30, round(ML, digits = 2)))

expand.grid(mu = seq(4, 4.5, length = 40),
            sd = seq(0.35, 0.6, length = 40)) |> 
    rowwise() |> 
    mutate(logLik = sum(dnorm(x = iris2$Petal.Length, mean = mu, sd = sd, log = TRUE))) |> 
    ungroup() |> 
    ggplot() +
      aes(z = logLik, x = mu, y = sd) +
      geom_textcontour(breaks = c(-40:-34, -33.5, -33, -32.8)) +
    geom_point(y = sd(iris2$Petal.Length)*sqrt((nrow(iris2) - 1)/nrow(iris2)),
               x = mean(iris2$Petal.Length), colour = "red",
               shape = "+", size = 5) +
    labs(y = expression(sigma), x = expression(mu))

# I use known ML estimates and CI from spaMM to avoid having to compute them numerically
y_CI <- ML - qchisq(0.95, df = 1)/2
x_CI <- confint(spaMM::fitme(Petal.Length ~ 1, data = iris2),
                parm = "(Intercept)", verbose = FALSE)$interval

tibble(mu = seq(4, 4.5, length = 100),
       logLik = sapply(mu, \(m) {
    optimise(\(sd) sum(dnorm(x = iris2$Petal.Length, mean = m, sd = sd, log = TRUE)), interval = c(0.35, 0.7), maximum = TRUE)$objective
    })) |> 
    ggplot() +
      aes(y = logLik, x = mu) +
      geom_line() +
      geom_segment(y = ML,
               yend = -100,
               x = mean(iris2$Petal.Length),
               xend = mean(iris2$Petal.Length),
               linetype = "dashed",
               colour = "#3333B3") +
      geom_segment(y = y_CI, yend = y_CI, xend = 4, x = x_CI[2],
                   colour = "red", linetype = "dotted") +
      geom_segment(y = ML, yend = ML, xend = 4, x = mean(iris2$Petal.Length),
                   colour = "red", linetype = "dotted") +
      geom_segment(x = x_CI[1], xend = x_CI[1], y = y_CI, yend = -100,
                   linetype = "dashed", colour = "#3333B3", linewidth = 0.5) +
      geom_segment(x = x_CI[2], xend = x_CI[2], y = y_CI, yend = -100,
                   linetype = "dashed", colour = "#3333B3", linewidth = 0.5) +
      geom_segment(x = 4.02, xend = 4.02, y = ML, yend = y_CI, arrow = grid::arrow()) +
      annotate("text", y = (0.9*ML + 0.1*y_CI), x = 4.025, hjust = 0, label = "max - qchisq(0.95, df = 1)/2", size = 5) +
      labs(x = expression(mu)) +
      scale_y_continuous(breaks = c(-40:-30, round(y_CI, digits = 2), round(ML, digits = 2)))

expand.grid(mu = seq(4, 4.5, length = 40),
            sd = seq(0.35, 0.6, length = 40)) |> 
    rowwise() |> 
    mutate(logLik = sum(dnorm(x = iris2$Petal.Length, mean = mu, sd = sd, log = TRUE))) |> 
    ungroup() |> 
    ggplot() +
      aes(z = logLik, x = mu, y = sd) +
      geom_textcontour(breaks = c(-40:-34, -33.5, -33, -32.8)) +
    geom_point(y = sqrt(sd(iris2$Petal.Length)^2*(nrow(iris2) - 1)/nrow(iris2)),
               x = mean(iris2$Petal.Length), colour = "red",
               shape = "+", size = 5) +
    labs(y = expression(sigma), x = expression(mu))

tibble(x = seq(-4, 4, length.out = 1000),
       Density_full = dnorm(x),
       Density = ifelse(x > 1, dnorm(x), 0)) |> 
  ggplot() +
    geom_area(aes(x = x, y = Density), fill = "grey") +
    geom_line(aes(x = x, y = Density_full), linewidth = 1) +
    geom_segment(x = 1, xend = 1, y = -0.02, yend =  dnorm(1),
                 linetype = "dashed", colour = "#3333B3") +
    annotate("text", y = 0.35, x = 1.5, label = "H0") +
    annotate("text", y = -0.04, x = 1, label = "v", colour = "#3333B3",
             fontface = 3) +
    coord_cartesian(ylim = c(0, 0.4), clip = "off")

tibble(x = seq(-4, 4, length.out = 1000),
       Density_full = dnorm(x),
       Density = ifelse(x > 1, dnorm(x), 0),
       Density_alpha = ifelse(x > qnorm(0.975), dnorm(x), 0)) |> 
  ggplot() +
    geom_area(aes(x = x, y = Density), fill = "grey") +
    geom_area(aes(x = x, y = Density_alpha), fill = "red", alpha = 0.2) +
    geom_line(aes(x = x, y = Density_full), linewidth = 1) +
    geom_segment(x = 1, xend = 1, y = -0.02, yend =  dnorm(1),
                 linetype = "dashed", colour = "#3333B3") +
    geom_segment(x = qnorm(0.975), xend = qnorm(0.975),
                 y = -0.02, yend = dnorm(qnorm(0.975)),
                 linetype = "dotted", colour = "red") +
    annotate("text", y = 0.35, x = 1.5, label = "H0") +
    annotate("text", y = -0.04, x = 1, label = "v", colour = "#3333B3",
             fontface = 3) +
    annotate("text", y = -0.04, x = qnorm(0.975), label = "a", colour = "red",
         fontface = 3) +
    scale_x_continuous(breaks = c(-4, -2, 0, 4)) +
    coord_cartesian(ylim = c(0, 0.4), clip = "off")

tibble(x = seq(-4, 4, length.out = 1000),
       Density_full = dnorm(x),
       Density = ifelse(abs(x) > qnorm(0.975), dnorm(x), 0)) |> 
  ggplot() +
    geom_area(aes(x = x, y = Density), fill = "#3333B3", alpha = 0.2) +
    geom_line(aes(x = x, y = Density_full), linewidth = 1) +
    geom_segment(x = -qnorm(0.975), xend = -qnorm(0.975),
                 y = dnorm(qnorm(0.975)), yend = 0,
                 linetype = "dotted") +
    geom_segment(x = qnorm(0.975), xend = qnorm(0.975),
                 y = dnorm(qnorm(0.975)), yend = 0,
                 linetype = "dotted") +
    annotate("text", y = 0.35, x = 1.5, label = "H0") +
    scale_x_continuous(breaks = c(-1.96, 0, 1.96)) +
    coord_cartesian(ylim = c(0, 0.4), clip = "off")

tibble(x = seq(-4, 4, length.out = 1000),
       Density_full = dnorm(x),
       Density = ifelse(x > qnorm(0.95), dnorm(x), 0),
       Density_alpha = ifelse(abs(x) > qnorm(0.975), dnorm(x), 0)) |> 
  ggplot() +
    geom_area(aes(x = x, y = Density), fill = "grey") +
    geom_line(aes(x = x, y = Density_full), linewidth = 1) +
    geom_segment(x = -qnorm(0.975), xend = -qnorm(0.975),
                 y = dnorm(qnorm(0.975)), yend = 0,
                 linetype = "dotted") +
    geom_segment(x = qnorm(0.975), xend = qnorm(0.975),
                 y = dnorm(qnorm(0.975)), yend = 0,
                 linetype = "dotted") +
    geom_segment(x = qnorm(0.95), xend = qnorm(0.95),
                 y = dnorm(qnorm(0.95)), yend = 0,
                 linetype = "dashed") +
    annotate("text", y = 0.35, x = 1.5, label = "H0") +
    scale_x_continuous(breaks = c(-1.64, 0, 1.64)) +
    coord_cartesian(ylim = c(0, 0.4), clip = "off")

1 - dbinom(x = 0, size = 10, prob = 0.05)

tibble(x = 1:50,
       Prob = 1 - dbinom(0, size = 1:50, prob = 0.05))  |> 
  ggplot() +
    aes(x = x, y = Prob) +
    geom_line() +
    geom_point(x = 10, y = 1 - dbinom(0, size = 10, prob = 0.05),
               colour = "red", size = 5) +
    scale_y_continuous(limits = c(0, 1)) +
    labs(y = "Prob of rejecting H0\n at least once", x = "Number of tests")

knitr::include_graphics("figures/xkcd_significance_wide.png", dpi = NA)

tibble(x = 1:50,
       Prob = 1 - dbinom(0, size = 1:50, prob = 0.05),
       Prob_corr = 1 - dbinom(0, size = 1:50, prob = 0.05/(1:50)))  |> 
  ggplot() +
    aes(x = x, y = Prob) +
    geom_line() +
    geom_point(x = 10, y = 1 - dbinom(0, size = 10, prob = 0.05),
               colour = "red", size = 5) +
    geom_line(aes(y = Prob_corr, x = x), linetype = "dashed") +
    geom_point(x = 10, y = 1 - dbinom(0, size = 10, prob = 0.005),
               colour = "darkgreen", size = 5) +
    annotate("text", y = 1 - dbinom(0, size = 10, prob = 0.05),
             x = 10, label = "without correction", hjust = -0.1,
             size = 9) +
    annotate("text", y = 1 - dbinom(0, size = 10, prob = 0.005),
             x = 10, label = "with Bonferroni correction",
             hjust = -0.1, vjust = -0.1,
             size = 9) +
    scale_y_continuous(limits = c(0, 1)) +
    labs(y = "Prob of rejecting H0\n at least once", x = "Number of tests")

1 - dbinom(x = 0, size = 3, prob = 0.05) # = 1 - 0.95^3

dbinom(x = 3, size = 3, prob = 0.05) # = 0.05^3

plot_power <- function(mu0 = 0, mu1 = 3, sd0 = 1, sd1 = 1, alpha = 0.05,
                       xlim = c(-4, 9),
                       show_mu_labels = TRUE,
                       threshold_arrow_label = "sign. threshold",
                       show_legend = TRUE,
                       alpha_label = "Type I error (\u03b1)",
                       beta_label  = "Type II error (\u03b2)",
                       power_label = "Power (1 \u2212 \u03b2)",
                       base_size = 30) {

  ## one-sided critical value for simplicity: reject H0 when X > threshold
  threshold <- qnorm(1 - alpha, mean = mu0, sd = sd0)

  x <- seq(xlim[1], xlim[2], length.out = 1000)

  d <- tibble(x  = x,
              H0 = dnorm(x, mean = mu0, sd = sd0),
              H1 = dnorm(x, mean = mu1, sd = sd1))

  d_beta <- d |> mutate(H1 = if_else(x <= threshold, H1, 0))
  d_alpha <- d |> mutate(H0 = if_else(x >= threshold, H0, 0))
  d_power <- d |> mutate(H1 = if_else(x >= threshold, H1, 0))

  region_colors <- c("#D55E00", "#E69F00", "#0072B2")
  names(region_colors) <- c(alpha_label, beta_label, power_label)

  p <- ggplot(d) +
    geom_area(data = d_beta,  aes(x = x, y = H1, fill = beta_label),
              alpha = 0.2) +
    geom_area(data = d_power, aes(x = x, y = H1, fill = power_label),
              alpha = 0.45) +
    geom_area(data = d_alpha, aes(x = x, y = H0, fill = alpha_label),
              alpha = 0.2) +
    geom_segment(y = 0, yend = dnorm(mu0, mean = mu0, sd = sd0),
                 x = mu0, xend = mu0, linetype = "dashed") +
    geom_segment(y = 0, yend = dnorm(mu1, mean = mu1, sd = sd1),
                 x = mu1, xend = mu1, linetype = "dashed") + 
    geom_segment(y = 0, yend = max(c(dnorm(threshold, mean = mu1, sd = sd1),
                                     dnorm(threshold, mean = mu0, sd = sd0))),
                 x = threshold, xend = threshold, linetype = "dotted",
                 colour = "red") + 
    geom_line(aes(x = x, y = H0), linewidth = 1) +
    geom_line(aes(x = x, y = H1), linewidth = 1) +
    annotate("text", x = mu0, y = max(d$H0) * 1.1, label = "H0",
             hjust = 0.5, size = base_size * 0.35) +
    annotate("text", x = mu1, y = max(d$H1) * 1.1, label = "H1",
             hjust = 0.5, size = base_size * 0.35) +
    scale_fill_manual(name = NULL, values = region_colors,
                       breaks = c(alpha_label, beta_label, power_label)) +
    coord_cartesian(clip = "off") +
    theme_void(base_size = base_size) +
    theme(plot.margin = margin(10, 15, 30, 15),
          legend.position = if (show_legend) "top" else "none",
          legend.text = element_text(size = base_size * 0.65),
          legend.key.size = unit(2, "lines"))

  if (show_mu_labels) {
    p <- p +
      annotate("text", x = mu0, y = -max(d$H0, d$H1) * 0.1,
               label = "mu[0]", parse = TRUE,
               size = base_size / 2.8, hjust = 0.5) +
      annotate("text", x = mu1, y = -max(d$H0, d$H1) * 0.1,
               label = "mu[1]", parse = TRUE,
               size = base_size / 2.8, hjust = 0.5)
  }

  p
}

plot_power(mu0 = 0, mu1 = 3, sd0 = 1, sd1 = 1, alpha = 0.05)

plot_power(mu0 = 0, mu1 = 3, sd0 = 1, sd1 = 1, alpha = 0.1)

plot_power(mu0 = 0, mu1 = 3, sd0 = 1, sd1 = 1, alpha = 0.01)

plot_power(mu0 = 0, mu1 = 5, sd0 = 1, sd1 = 1, alpha = 0.05)

plot_power(mu0 = 0, mu1 = 3, sd0 = 0.5, sd1 = 0.5, alpha = 0.05)

tibble(Pcancer = seq(0, 0.2, length = 100),
       Pfalsepositive = 0.01,
       Pdetection = 0.99,
       Ptruepositive = Pcancer * Pdetection / (Pcancer * Pdetection + (1 - Pcancer) * Pfalsepositive)) |>
  ggplot() +
    aes(y = Ptruepositive, x = Pcancer) +
    geom_line(size = 2) +
    theme_classic(base_size = 30) +
    labs(y = "P for a positive to have cancer",
         x = "Freq cancer in pop")

# Build a grid over psi (occupancy) and p11 (true detection prob)
grid <- expand.grid(psi = seq(0, 1, length.out = 200),
                    p11 = seq(0, 1, length.out = 200))

grid$z <- with(grid, (1 - psi) / (1 - psi * p11))

ggplot(grid, aes(x = p11, y = psi, z = z)) +
  geom_contour_filled(breaks = seq(0, 1, by = 0.1)) +
  scale_fill_viridis_d(name = "P(absence | not detected)") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  labs(x = expression(p[11]),
       y = expression(psi)) +
  coord_equal() +
  theme_classic(base_size = 20) +
  theme(legend.position = "right")

iris |> 
  filter(Species == "versicolor") |> 
  pull(Petal.Length) -> y

tibble(y = y) |> 
  ggplot() +
    aes(x = y) +
    geom_histogram() +
    labs(y = "Petal Length")

my_prior_mu <- function(mu, log = TRUE) {
  # normal distribution
  dnorm(x = mu, mean = 5, sd = 5,
        log = log)
}

my_prior_sd <- function(sd, log = TRUE) {
  # uniform distribution
  dunif(x = sd, min = 0, max = 15,
        log = log)
}

my_prior <- function(param) {
  my_prior_mu(mu = param[1], log = TRUE) + 
    my_prior_sd(sd = param[2], log = TRUE)
}

ggplot() +
    geom_function(fun = my_prior_mu,
                  args = list(log = FALSE),
                  xlim = c(-5, 20)) +
    geom_function(fun = my_prior_sd,
                  args = list(log = FALSE),
                  xlim = c(-5, 20),
                  linetype = "dashed") +
    labs(y = "Density", x = expression(theta))

my_logLik <- function(param) {
  # make sure negative SD are not good
  if (param[2] < 0) return(-1e6)
  # compute the log-likelihood
  sum(dnorm(x = y,
            mean = param[1],
            sd = param[2],
            log = TRUE))
}

my_logLik(c(5, 0.5))
my_logLik(c(5, 0.51))

my_posterior_log <- function(param) {
    # adding logs = multiplying originals
    my_logLik(param) + my_prior(param)
}

my_posterior_log(c(5, 0.5))
my_posterior_log(c(5, 0.51))

my_proposal <- function(param) {
  rnorm(n = 2,
        mean = param,
        sd = c(0.1, 0.05))
}

set.seed(123) # "fix" simu for reproducibility
my_proposal(param = c(5, 0.5))
my_proposal(param = c(5, 0.5))
my_proposal(param = c(5, 0.5))

my_MCMC <- function(chain_length = 9999, starting_values = c(5, 0.1)) {
    chain <- matrix(nrow = chain_length + 1, ncol = 2) # for storing values
    chain[1, ] <- starting_values # add starting values
    for (i in seq_len(chain_length)) {
        param_candidate <- my_proposal(chain[i, ])
        proba_accept <- exp(my_posterior_log(param_candidate) -
                              my_posterior_log(chain[i, ]))
        if (runif(1) < proba_accept)
            chain[i + 1, ] <- param_candidate # new values accepted
        else
            chain[i + 1, ] <- chain[i, ] # former values retained
    }
    colnames(chain) <- c("mu", "sd") # name columns
    posterior::as_draws(chain) # convert matrix to "draws"
}

library(posterior)
library(bayesplot)
posterior_samples <- my_MCMC()
bayesplot_theme_set(theme_classic(base_size = 30)) # set the default theme for plots
mcmc_trace(posterior_samples) # draw the chains

burnin <- 1000
posterior_no_burnin <- posterior_samples[-seq_len(burnin), ] # subset (matrix like)
mcmc_trace(posterior_no_burnin) # trace are better -> more fuzzy caterpillar outlook

mcmc_acf(posterior_no_burnin)
posterior_clean <- thin_draws(posterior_no_burnin, thin = 25)

mcmc_trace(posterior_clean)

mcmc_dens(posterior_clean)

summary(posterior_clean)

quantile2(posterior_clean, probs = c(0.025, 0.975)) # 95% credible interval

library(nimble)
## create code object
code <- nimbleCode({ 
  # defining model
  for (i in seq_len(N)) {
      y[i] ~ dnorm(mean = mu, sd = sigma)
  }
  # set priors
  mu ~ dnorm(mean = prior_mu, sd = prior_mu_sd)
  sigma ~ dunif(min = prior_sd_min, max = prior_sd_max)
})

## define constants
constants <- list(N = length(y),
                  prior_mu = 5, prior_mu_sd = 5,
                  prior_sd_min = 0, prior_sd_max = 15)

## estimate parameters
results_nimb <- nimbleMCMC(code = code,
                           constants = constants,
                           data = list(y = y),
                           inits = list(mu = 5, sigma = 0.1),
                           nchains = 1, # 1 for trial, do more for real use (e.g 4)
                           progressBar = FALSE) # FALSE for not cluttering the slide

results_nimb_d <- as_draws(results_nimb)
mcmc_trace(results_nimb_d)

options(width = 140)
duration_min <- round(as.numeric(difftime(Sys.time(), start, units = "min")), digits = 1)
paste(duration_min, "min of R running time")
print(sessionInfo(), locale = FALSE, tzone = FALSE)
