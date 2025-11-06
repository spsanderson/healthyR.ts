# Geometric Brownian Motion

Create a Geometric Brownian Motion.

## Usage

``` r
ts_geometric_brownian_motion(
  .num_sims = 100,
  .time = 25,
  .mean = 0,
  .sigma = 0.1,
  .initial_value = 100,
  .delta_time = 1/365,
  .return_tibble = TRUE
)
```

## Arguments

- .num_sims:

  Total number of simulations.

- .time:

  Total time of the simulation.

- .mean:

  Expected return

- .sigma:

  Volatility

- .initial_value:

  Integer representing the initial value.

- .delta_time:

  Time step size.

- .return_tibble:

  The default is TRUE. If set to FALSE then an object of class matrix
  will be returned.

## Value

A tibble/matrix

## Details

Geometric Brownian Motion (GBM) is a statistical method for modeling the
evolution of a given financial asset over time. It is a type of
stochastic process, which means that it is a system that undergoes
random changes over time.

GBM is widely used in the field of finance to model the behavior of
stock prices, foreign exchange rates, and other financial assets. It is
based on the assumption that the asset's price follows a random walk,
meaning that it is influenced by a number of unpredictable factors such
as market trends, news events, and investor sentiment.

The equation for GBM is:

     dS/S = mdt + sdW

where S is the price of the asset, t is time, m is the expected return
on the asset, s is the volatility of the asset, and dW is a small random
change in the asset's price.

GBM can be used to estimate the likelihood of different outcomes for a
given asset, and it is often used in conjunction with other statistical
methods to make more accurate predictions about the future performance
of an asset.

This function provides the ability of simulating and estimating the
parameters of a GBM process. It can be used to analyze the behavior of
financial assets and to make informed investment decisions.

## See also

Other Data Generator:
[`tidy_fft()`](https://www.spsanderson.com/healthyR.ts/reference/tidy_fft.md),
[`ts_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion.md),
[`ts_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_augment.md),
[`ts_geometric_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion_augment.md),
[`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
ts_geometric_brownian_motion()
#> # A tibble: 2,600 × 3
#>    sim_number        t     y
#>    <fct>         <int> <dbl>
#>  1 sim_number 1      1   100
#>  2 sim_number 2      1   100
#>  3 sim_number 3      1   100
#>  4 sim_number 4      1   100
#>  5 sim_number 5      1   100
#>  6 sim_number 6      1   100
#>  7 sim_number 7      1   100
#>  8 sim_number 8      1   100
#>  9 sim_number 9      1   100
#> 10 sim_number 10     1   100
#> # ℹ 2,590 more rows
```
