
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthyR.ts <img src="man/figures/healthyR_ts6.png" width="147" height="170" align="right" />

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of `healthyR.ts` is to provide a consistent verb framework for
performing time-series analysis and forecasting.

## Installation

You can install the released version of healthyR.ts from
[CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("healthyR.ts")
```

And the development version from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("spsanderson/healthyR.ts")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(healthyR.ts)
library(ggplot2)

df <- ts_random_walk()

head(df)
#> # A tibble: 6 x 4
#>     run     x        y cum_y
#>   <dbl> <dbl>    <dbl> <dbl>
#> 1     1     1 -0.135    865.
#> 2     1     2 -0.00989  857.
#> 3     1     3 -0.110    762.
#> 4     1     4  0.165    888.
#> 5     1     5  0.0564   938.
#> 6     1     6  0.0581   993.
```

Now that the data hs been generated, lets take a look at it.

``` r
df %>%
   ggplot(
       mapping = aes(
           x = x
           , y = cum_y
           , color = factor(run)
           , group = factor(run)
        )
    ) +
    geom_line(alpha = 0.8) +
    ts_random_walk_ggplot_layers(df)
#> Registered S3 method overwritten by 'quantmod':
#>   method            from
#>   as.zoo.data.frame zoo
```

<img src="man/figures/README-ts_random_walk_ggplot_layers-1.png" width="100%" />
