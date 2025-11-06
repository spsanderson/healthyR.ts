# Vector Function Time Series Growth Rate

This function computes the growth rate of a numeric vector, typically
representing a time series, with optional transformations like scaling,
power, and lag differences.

## Usage

``` r
ts_growth_rate_vec(.x, .scale = 100, .power = 1, .log_diff = FALSE, .lags = 1)
```

## Arguments

- .x:

  A numeric vector

- .scale:

  A numeric value that is used to scale the output

- .power:

  A numeric value that is used to raise the output to a power

- .log_diff:

  A logical value that determines whether the output is a log difference

- .lags:

  An integer that determines the number of lags to use

## Value

A list object of workflows.

## Details

The function calculates growth rates for a time series, allowing for
scaling, exponentiation, and lag differences. It can be useful for
financial data analysis, among other applications.

The growth rate is computed as follows:

- If lags is positive and log_diff is FALSE: growth_rate = (((x / lag(x,
  lags))^power) - 1) \* scale

- If lags is positive and log_diff is TRUE: growth_rate = log(x / lag(x,
  lags)) \* scale

- If lags is negative and log_diff is FALSE: growth_rate = (((x /
  lead(x, -lags))^power) - 1) \* scale

- If lags is negative and log_diff is TRUE: growth_rate = log(x /
  lead(x, -lags)) \* scale

## See also

Other Vector Function:
[`ts_acceleration_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_vec.md),
[`ts_velocity_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_vec.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Calculate the growth rate of a time series without any transformations.
ts_growth_rate_vec(c(100, 110, 120, 130))
#> [1]        NA 10.000000  9.090909  8.333333
#> attr(,"name")
#> [1] "c(100, 110, 120, 130)"

# Calculate the growth rate with scaling and a power transformation.
ts_growth_rate_vec(c(100, 110, 120, 130), .scale = 10, .power = 2)
#> [1]       NA 2.100000 1.900826 1.736111
#> attr(,"name")
#> [1] "c(100, 110, 120, 130)"

# Calculate the log differences of a time series with lags.
ts_growth_rate_vec(c(100, 110, 120, 130), .log_diff = TRUE, .lags = -1)
#> [1] -9.531018 -8.701138 -8.004271        NA
#> attr(,"name")
#> [1] "c(100, 110, 120, 130)"

# Plot
plot.ts(AirPassengers)

plot.ts(ts_growth_rate_vec(AirPassengers))

```
