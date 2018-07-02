# rr2018addins

> Exemples d'add-ins RStudio pour notre présentation aux rencontres R à Rennes.

[![Travis build status](https://travis-ci.org/dreamRs/rr2018addins.svg?branch=master)](https://travis-ci.org/dreamRs/rr2018addins)


## Installation

Vous pouvez installer le package depuis GitHub :

``` r
# install.packages("devtools")
devtools::install_github("dreamRs/rr2018addins")
```

## Réorganiser les appels à `library` dans un script

Cet add-in permet de placer en début de script les appels à `library()` disséminés dans un script :

``` r
library(readr)
mes_data <- read_csv(file = "mon_csv.csv")


library(dplyr)
mes_data <- mes_data %>% 
  group_by(colonne) %>% 
  summarise(indicateur = sum(valeur))


library(ggplot2)
ggplot(data = mes_data) + 
  geom_col(aes(colonne, indicateur))

```

devient :

```r
# Packages ----
library(readr)
library(dplyr)
library(ggplot2)


# readr ---
mes_data <- read_csv(file = "mon_csv.csv")


# dplyr ----
mes_data <- mes_data %>% 
  group_by(colonne) %>% 
  summarise(indicateur = sum(valeur))


# ggplot2 ----
ggplot(data = mes_data) + 
  geom_col(aes(colonne, indicateur))

```
