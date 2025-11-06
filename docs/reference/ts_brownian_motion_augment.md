# Brownian Motion

Create a Brownian Motion Tibble

## Usage

``` r
ts_brownian_motion_augment(
  .data,
  .date_col,
  .value_col,
  .time = 100,
  .num_sims = 10,
  .delta_time = NULL
)
```

## Arguments

- .data:

  The data.frame/tibble being augmented.

- .date_col:

  The column that holds the date.

- .value_col:

  The value that is going to get augmented. The last value of this
  column becomes the initial value internally.

- .time:

  How many time steps ahead.

- .num_sims:

  How many simulations should be run.

- .delta_time:

  Time step size.

## Value

A tibble/matrix

## Details

Brownian Motion, also known as the Wiener process, is a continuous-time
random process that describes the random movement of particles suspended
in a fluid. It is named after the physicist Robert Brown, who first
described the phenomenon in 1827.

The equation for Brownian Motion can be represented as:

    W(t) = W(0) + sqrt(t) * Z

Where W(t) is the Brownian motion at time t, W(0) is the initial value
of the Brownian motion, sqrt(t) is the square root of time, and Z is a
standard normal random variable.

Brownian Motion has numerous applications, including modeling stock
prices in financial markets, modeling particle movement in fluids, and
modeling random walk processes in general. It is a useful tool in
probability theory and statistical analysis.

## See also

Other Data Generator:
[`tidy_fft()`](https://www.spsanderson.com/healthyR.ts/reference/tidy_fft.md),
[`ts_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion.md),
[`ts_geometric_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion.md),
[`ts_geometric_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion_augment.md),
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

ts_brownian_motion_augment(
  .data = df,
  .date_col = date_col,
  .value_col = value
)
#> # A tibble: 1,041 × 3
#>    sim_number  date_col     value
#>    <fct>       <date>       <dbl>
#>  1 actual_data 2022-01-01 -0.0521
#>  2 actual_data 2022-01-02 -1.05  
#>  3 actual_data 2022-01-03 -0.0223
#>  4 actual_data 2022-01-04 -0.524 
#>  5 actual_data 2022-01-05 -0.599 
#>  6 actual_data 2022-01-06  0.0306
#>  7 actual_data 2022-01-07 -0.809 
#>  8 actual_data 2022-01-08 -0.305 
#>  9 actual_data 2022-01-09 -0.616 
#> 10 actual_data 2022-01-10 -0.435 
#> # ℹ 1,031 more rows
```
