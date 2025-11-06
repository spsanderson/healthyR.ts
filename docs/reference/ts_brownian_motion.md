# Brownian Motion

Create a Brownian Motion Tibble

## Usage

``` r
ts_brownian_motion(
  .time = 100,
  .num_sims = 10,
  .delta_time = 1,
  .initial_value = 0,
  .return_tibble = TRUE
)
```

## Arguments

- .time:

  Total time of the simulation.

- .num_sims:

  Total number of simulations.

- .delta_time:

  Time step size.

- .initial_value:

  Integer representing the initial value.

- .return_tibble:

  The default is TRUE. If set to FALSE then an object of class matrix
  will be returned.

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
[`ts_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_augment.md),
[`ts_geometric_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion.md),
[`ts_geometric_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion_augment.md),
[`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
ts_brownian_motion()
#> # A tibble: 1,010 × 3
#>    sim_number        t     y
#>    <fct>         <int> <dbl>
#>  1 sim_number 1      1     0
#>  2 sim_number 2      1     0
#>  3 sim_number 3      1     0
#>  4 sim_number 4      1     0
#>  5 sim_number 5      1     0
#>  6 sim_number 6      1     0
#>  7 sim_number 7      1     0
#>  8 sim_number 8      1     0
#>  9 sim_number 9      1     0
#> 10 sim_number 10     1     0
#> # ℹ 1,000 more rows
```
