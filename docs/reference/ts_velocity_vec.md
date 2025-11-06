# Vector Function Time Series Acceleration

Takes a numeric vector and will return the velocity of that vector.

## Usage

``` r
ts_velocity_vec(.x)
```

## Arguments

- .x:

  A numeric vector

## Value

A numeric vector

## Details

Takes a numeric vector and will return the velocity of that vector. The
velocity of a time series is computed by taking the first difference, so
\$\$x_t - x_t1\$\$

This function can be used on it's own. It is also the basis for the
function
[`ts_velocity_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_augment.md).

## See also

Other Vector Function:
[`ts_acceleration_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_vec.md),
[`ts_growth_rate_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_vec.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))

len_out    = 25
by_unit    = "month"
start_date = as.Date("2021-01-01")

data_tbl <- tibble(
  date_col = seq.Date(from = start_date, length.out = len_out, by = by_unit),
  a    = rnorm(len_out),
  b    = runif(len_out)
)

vec_1 <- ts_velocity_vec(data_tbl$b)

plot(data_tbl$b)
lines(data_tbl$b)
lines(vec_1, col = "blue")

```
