# Geometric Brownian Motion

Create a Geometric Brownian Motion.

## Usage

``` r
ts_geometric_brownian_motion_augment(
  .data,
  .date_col,
  .value_col,
  .num_sims = 10,
  .time = 25,
  .mean = 0,
  .sigma = 0.1,
  .delta_time = 1/365
)
```

## Arguments

- .data:

  The data you are going to pass to the function to augment.

- .date_col:

  The column that holds the date

- .value_col:

  The column that holds the value

- .num_sims:

  Total number of simulations.

- .time:

  Total time of the simulation.

- .mean:

  Expected return

- .sigma:

  Volatility

- .delta_time:

  Time step size.

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
[`ts_geometric_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion.md),
[`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
rn <- rnorm(31)
df <- data.frame(
 date_col = seq.Date(from = as.Date("2022-01-01"),
                      to = as.Date("2022-01-31"),
                      by = "day"),
 value = rn
)

ts_geometric_brownian_motion_augment(
  .data = df,
  .date_col = date_col,
  .value_col = value
)
#> # A tibble: 291 × 3
#>    sim_number  date_col    value
#>    <fct>       <date>      <dbl>
#>  1 actual_data 2022-01-01 -0.897
#>  2 actual_data 2022-01-02  0.446
#>  3 actual_data 2022-01-03 -0.182
#>  4 actual_data 2022-01-04  0.699
#>  5 actual_data 2022-01-05 -0.557
#>  6 actual_data 2022-01-06  0.364
#>  7 actual_data 2022-01-07  0.946
#>  8 actual_data 2022-01-08  0.292
#>  9 actual_data 2022-01-09  1.43 
#> 10 actual_data 2022-01-10 -0.502
#> # ℹ 281 more rows
```
