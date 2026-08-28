library(tidyverse)

territories <- read_csv("data_MHB/data-territories.csv")
species_count <- read_csv("data_MHB/header-species-count.csv")

territories |> 
    summarise(territories_sum = sum(territories_total, na.rm = TRUE),
              .by = c(nameeg, namelt)) |> 
    slice_max(territories_sum, n = 6) |> 
    pull(namelt) -> top6sp

territories |> 
    filter(namelt %in% top6sp & year == 2000) |> 
    summarise(territories_top6 = sum(territories_total, na.rm = TRUE),
              .by = c(nameeg, samplearea_id)) |> 
    left_join(species_count |> filter(year == 2000)) -> territories_top6_2000

fit_bird_glm <- glm(territories_top6 ~ scale(median_elevation) + n_visits, data = territories_top6_2000,
                    family = poisson(link = "log"))

fit_bird_glm

20460/1581 # residual deviance / residual df -> the model is overdispersed

DHARMa::testDispersion(fit_bird_glm)
DHARMa::testZeroInflation(fit_bird_glm)

library(glmmTMB)
fit_bird_glm2 <- glmmTMB(territories_top6 ~ scale(median_elevation) + n_visits,
                         ziformula = ~ 1,
                         data = territories_top6_2000,
                         family = truncated_poisson(link = "log"))

fit_bird_glm3 <- glmmTMB(territories_top6 ~ scale(median_elevation) + n_visits,
                         ziformula = ~ 1,
                         data = territories_top6_2000,
                         family = poisson(link = "log"))

fit_bird_nb <- glmmTMB(territories_top6 ~ scale(median_elevation) + n_visits,
                       data = territories_top6_2000,
                       family = nbinom2(link = "log"))

fit_bird_nb2 <- glmmTMB(territories_top6 ~ scale(median_elevation) + n_visits,
                        ziformula = ~ 1,
                        data = territories_top6_2000,
                        family = nbinom2(link = "log"))

fit_bird_nb3 <- glmmTMB(territories_top6 ~ scale(median_elevation) + n_visits,
                        ziformula = ~ 1,
                        data = territories_top6_2000,
                        family = truncated_nbinom2(link = "log"))

AIC(fit_bird_glm, fit_bird_glm2, fit_bird_glm3,
    fit_bird_nb, fit_bird_nb2, fit_bird_nb3)

summary(fit_bird_nb2)
summary(fit_bird_glm)


DHARMa::testDispersion(fit_bird_nb2)
DHARMa::testZeroInflation(fit_bird_nb2)


library(brms)

fit_bird_glm_brms <- brm(
  territories_top6 ~ scale(median_elevation) + n_visits,
  data = territories_top6_2000,
  family = poisson(link = "log"),
  chains = 4, cores = 4, iter = 10000
)

fit_bird_nb2_brms <- brm(
  brmsformula(territories_top6 ~ scale(median_elevation) + n_visits,
              zi ~ 1),
  data = territories_top6_2000,
  family = zero_inflated_negbinomial(link = "log"),
  chains = 4, cores = 4, iter = 10000
)

WAIC(fit_bird_glm_brms)
WAIC(fit_bird_nb2_brms)

summary(fit_bird_nb2_brms)

mcmc_plot(fit_bird_nb2_brms, type = "dens")
