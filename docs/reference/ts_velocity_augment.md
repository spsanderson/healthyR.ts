# Augment Function Velocity

Takes a numeric vector and will return the velocity of that vector.

## Usage

``` r
ts_velocity_augment(.data, .value, .names = "auto")
```

## Arguments

- .data:

  The data being passed that will be augmented by the function.

- .value:

  This is passed
  [`rlang::enquo()`](https://rlang.r-lib.org/reference/enquo.html) to
  capture the vectors you want to augment.

- .names:

  The default is "auto"

## Value

A augmented

## Details

Takes a numeric vector and will return the velocity of that vector. The
velocity of a time series is computed by taking the first difference, so
\$\$x_t - x_t1\$\$

This function is intended to be used on its own in order to add columns
to a tibble.

## See also

Other Augment Function:
[`ts_acceleration_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_augment.md),
[`ts_growth_rate_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_augment.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))

len_out    = 10
by_unit    = "month"
start_date = as.Date("2021-01-01")

data_tbl <- tibble(
  date_col = seq.Date(from = start_date, length.out = len_out, by = by_unit),
  a    = rnorm(len_out),
  b    = runif(len_out)
)

ts_velocity_augment(data_tbl, b)
#> # A tibble: 10 × 4
#>    date_col         a     b velocity_b
#>    <date>       <dbl> <dbl>      <dbl>
#>  1 2021-01-01  1.90   0.355  NA       
#>  2 2021-02-01  0.166  0.287  -0.0676  
#>  3 2021-03-01 -0.0544 0.163  -0.125   
#>  4 2021-04-01 -0.615  0.347   0.184   
#>  5 2021-05-01 -0.0294 0.410   0.0632  
#>  6 2021-06-01 -1.45   0.855   0.445   
#>  7 2021-07-01 -0.0385 0.854  -0.000798
#>  8 2021-08-01  1.86   0.749  -0.105   
#>  9 2021-09-01 -1.72   0.469  -0.280   
#> 10 2021-10-01  1.08   0.995   0.527   
```
