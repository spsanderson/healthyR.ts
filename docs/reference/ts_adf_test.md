# Augmented Dickey-Fuller Test for Time Series Stationarity

This function performs the Augmented Dickey-Fuller test to assess the
stationarity of a time series. The Augmented Dickey-Fuller (ADF) test is
used to determine if a given time series is stationary. This function
takes a numeric vector as input, and you can optionally specify the lag
order with the `.k` parameter. If `.k` is not provided, it is calculated
based on the number of observations using a formula. The test statistic
and p-value are returned.

## Usage

``` r
ts_adf_test(.x, .k = NULL)
```

## Arguments

- .x:

  A numeric vector representing the time series to be tested for
  stationarity.

- .k:

  An optional parameter specifying the number of lags to use in the ADF
  test (default is calculated).

## Value

A list containing the results of the Augmented Dickey-Fuller test:

- `test_stat`: The test statistic from the ADF test.

- `p_value`: The p-value of the test.

## See also

Other Statistic:
[`ci_hi()`](https://www.spsanderson.com/healthyR.ts/reference/ci_hi.md),
[`ci_lo()`](https://www.spsanderson.com/healthyR.ts/reference/ci_lo.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using the AirPassengers dataset
ts_adf_test(AirPassengers)
#> $test_stat
#> [1] -7.318571
#> 
#> $p_value
#> [1] 0.01
#> 

# Example 2: Using a custom time series vector
custom_ts <- rnorm(100, 0, 1)
ts_adf_test(custom_ts)
#> $test_stat
#> [1] -4.075302
#> 
#> $p_value
#> [1] 0.01
#> 
```
