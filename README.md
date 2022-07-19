
<!-- README.md is generated from README.Rmd. Please edit that file -->

# healthyR.ts <img src="man/figures/test1.png" width="147" height="170" align="right" />

<!-- badges: start -->

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/healthyR.ts)](https://cran.r-project.org/package=healthyR.ts)
![](https://cranlogs.r-pkg.org/badges/healthyR.ts)
![](https://cranlogs.r-pkg.org/badges/grand-total/healthyR.ts)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![PRs
Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](https://makeapullrequest.com/)
<!-- badges: end -->

The goal of `healthyR.ts` is to provide a consistent verb framework for
performing time series analysis and forecasting on both administrative
and clinical hospital data.

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

This is a basic example which shows you how to generate random walk
data.

``` r
library(healthyR.ts)
library(ggplot2)

df <- ts_random_walk()

head(df)
#> # A tibble: 6 × 4
#>     run     x       y cum_y
#>   <dbl> <dbl>   <dbl> <dbl>
#> 1     1     1 -0.0314  969.
#> 2     1     2  0.0576 1024.
#> 3     1     3  0.0249 1050.
#> 4     1     4 -0.0645  982.
#> 5     1     5  0.0271 1009.
#> 6     1     6  0.157  1167.
```

Now that the data has been generated, lets take a look at it.

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
```

<img src="man/figures/README-ts_random_walk_ggplot_layers-1.png" width="100%" />

That is still pretty noisy, so lets see this in a different way. Lets
clear this up a bit to make it easier to see the full range of the
possible volatility of the random walks.

``` r
library(dplyr)
library(ggplot2)

df %>%
    group_by(x) %>%
    summarise(
        min_y = min(cum_y),
        max_y = max(cum_y)
    ) %>%
    ggplot(
        aes(x = x)
    ) +
    geom_line(aes(y = max_y), color = "steelblue") +
    geom_line(aes(y = min_y), color = "firebrick") +
    geom_ribbon(aes(ymin = min_y, ymax = max_y), alpha = 0.2) +
    ts_random_walk_ggplot_layers(df)
```

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />
