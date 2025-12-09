# Random Walk Function

This function takes in four arguments and returns a tibble of random
walks.

## Usage

``` r
ts_random_walk(
  .mean = 0,
  .sd = 0.1,
  .num_walks = 100,
  .periods = 100,
  .initial_value = 1000
)
```

## Arguments

- .mean:

  The desired mean of the random walks

- .sd:

  The standard deviation of the random walks

- .num_walks:

  The number of random walks you want generated

- .periods:

  The length of the random walk(s) you want generated

- .initial_value:

  The initial value where the random walks should start

## Value

A tibble

## Details

Monte Carlo simulations were first formally designed in the 1940’s while
developing nuclear weapons, and since have been heavily used in various
fields to use randomness solve problems that are potentially
deterministic in nature. In finance, Monte Carlo simulations can be a
useful tool to give a sense of how assets with certain characteristics
might behave in the future. While there are more complex and
sophisticated financial forecasting methods such as ARIMA
(Auto-Regressive Integrated Moving Average) and GARCH (Generalized
Auto-Regressive Conditional Heteroskedasticity) which attempt to model
not only the randomness but underlying macro factors such as seasonality
and volatility clustering, Monte Carlo random walks work surprisingly
well in illustrating market volatility as long as the results are not
taken too seriously.

## See also

Other Data Generator:
[`tidy_fft()`](https://www.spsanderson.com/healthyR.ts/reference/tidy_fft.md),
[`ts_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion.md),
[`ts_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_augment.md),
[`ts_geometric_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion.md),
[`ts_geometric_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion_augment.md)

## Examples

``` r
ts_random_walk(
.mean = 0,
.sd = 1,
.num_walks = 25,
.periods = 180,
.initial_value = 6
)
#> # A tibble: 4,500 × 4
#>      run     x       y  cum_y
#>    <dbl> <dbl>   <dbl>  <dbl>
#>  1     1     1  1.14    12.8 
#>  2     1     2 -1.54    -6.89
#>  3     1     3 -0.225   -5.34
#>  4     1     4  2.78   -20.1 
#>  5     1     5  1.36   -47.5 
#>  6     1     6  0.0815 -51.4 
#>  7     1     7 -0.104  -46.1 
#>  8     1     8 -0.217  -36.1 
#>  9     1     9 -1.21     7.44
#> 10     1    10 -0.456    4.05
#> # ℹ 4,490 more rows
```
