# Double Differencing to Make Time Series Stationary

This function attempts to make a non-stationary time series stationary
by applying double differencing. It iteratively increases the
differencing order until stationarity is achieved.

## Usage

``` r
util_doublediff_ts(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary or the double differencing is
successful, it returns a list as described in the details section. If
additional differencing is required, it informs the user and returns a
list with ret set to FALSE, suggesting trying differencing with the
natural logarithm.

## Details

The function calculates the frequency of the input time series using the
[`stats::frequency`](https://rdrr.io/r/stats/time.html) function. It
then applies double differencing incrementally until the Augmented
Dickey-Fuller test indicates stationarity (p-value \< 0.05) or until the
differencing order reaches the frequency of the data.

If double differencing successfully makes the time series stationary, it
returns the stationary time series and related information as a list
with the following elements:

- stationary_ts: The stationary time series after double differencing.

- ndiffs: The order of differencing applied to make it stationary.

- adf_stats: Augmented Dickey-Fuller test statistics on the stationary
  time series.

- trans_type: Transformation type, which is "double_diff" in this case.

- ret: TRUE to indicate a successful transformation.

If the data requires more double differencing than its frequency allows,
it informs the user and suggests trying differencing with the natural
logarithm instead.

## See also

Other Utility:
[`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md),
[`calibrate_and_plot()`](https://www.spsanderson.com/healthyR.ts/reference/calibrate_and_plot.md),
[`internal_ts_backward_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_backward_event_tbl.md),
[`internal_ts_both_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_both_event_tbl.md),
[`internal_ts_forward_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_forward_event_tbl.md),
[`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md),
[`ts_get_date_columns()`](https://www.spsanderson.com/healthyR.ts/reference/ts_get_date_columns.md),
[`ts_info_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_info_tbl.md),
[`ts_is_date_class()`](https://www.spsanderson.com/healthyR.ts/reference/ts_is_date_class.md),
[`ts_lag_correlation()`](https://www.spsanderson.com/healthyR.ts/reference/ts_lag_correlation.md),
[`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md),
[`ts_model_compare()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_compare.md),
[`ts_model_rank_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_rank_tbl.md),
[`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md),
[`ts_qq_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_qq_plot.md),
[`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md),
[`ts_to_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_to_tbl.md),
[`util_difflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_difflog_ts.md),
[`util_doubledifflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doubledifflog_ts.md),
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md),
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using a time series dataset
util_doublediff_ts(AirPassengers)
#> Double Differencing of order 1 made the time series stationary
#> $stationary_ts
#>       Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
#> 1949              8  -17   -5   22   -1  -13  -12   -5    2   29
#> 1950  -17   14    4  -21   -4   34   -3  -21  -12  -13    6   45
#> 1951  -21    0   23  -43   24   -3   15  -21  -15   -7    6   36
#> 1952  -15    4    4  -25   14   33  -23    0  -45   15   -1   41
#> 1953  -20   -2   40  -41   -5   20    7  -13  -43    9   -5   52
#> 1954  -18  -19   63  -55   15   23    8  -47  -25    4    4   52
#> 1955  -13  -22   43  -32   -1   44    4  -66  -18   -3    1   78
#> 1956  -35  -13   47  -44    9   51  -17  -47  -42    1   14   70
#> 1957  -26  -23   69  -63   15   60  -24  -41  -65    6   15   73
#> 1958  -27  -26   66  -58   29   57  -16  -42 -115   56   -4   76
#> 1959   -4  -41   82  -74   34   28   24  -65 -107   40   11   88
#> 1960  -31  -38   54   14  -31   52   24 -103  -82   51  -24  113
#> 
#> $ndiffs
#> [1] 1
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -8.051569
#> 
#> $adf_stats$p_value
#> [1] 0.01
#> 
#> 
#> $trans_type
#> [1] "double_diff"
#> 
#> $ret
#> [1] TRUE
#> 

# Example 2: Using a different time series dataset
util_doublediff_ts(BJsales)$ret
#> Double Differencing of order 1 made the time series stationary
#> [1] TRUE
```
