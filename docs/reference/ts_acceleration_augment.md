# Augment Function Acceleration

Takes a numeric vector and will return the acceleration of that vector.

## Usage

``` r
ts_acceleration_augment(.data, .value, .names = "auto")
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

A augmented tibble

## Details

Takes a numeric vector and will return the acceleration of that vector.
The acceleration of a time series is computed by taking the second
difference, so \$\$(x_t - x_t1) - (x_t - x_t1)\_t1\$\$

This function is intended to be used on its own in order to add columns
to a tibble.

## See also

Other Augment Function:
[`ts_growth_rate_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_augment.md),
[`ts_velocity_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_augment.md)

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

ts_acceleration_augment(data_tbl, b)
#> # A tibble: 10 × 4
#>    date_col         a      b acceleration_b
#>    <date>       <dbl>  <dbl>          <dbl>
#>  1 2021-01-01 -1.04   0.874          NA    
#>  2 2021-02-01  1.02   0.0115         NA    
#>  3 2021-03-01 -0.702  0.888           1.74 
#>  4 2021-04-01  0.973  0.996          -0.769
#>  5 2021-05-01 -0.0768 0.500          -0.604
#>  6 2021-06-01  0.893  0.359           0.355
#>  7 2021-07-01 -0.778  0.775           0.557
#>  8 2021-08-01  0.437  0.584          -0.606
#>  9 2021-09-01  0.413  0.634           0.240
#> 10 2021-10-01  0.976  0.859           0.175
```
