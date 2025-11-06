# Single Differencing to Make Time Series Stationary

This function attempts to make a non-stationary time series stationary
by applying single differencing. It iteratively increases the
differencing order until stationarity is achieved.

## Usage

``` r
util_singlediff_ts(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary or the single differencing is
successful, it returns a list as described in the details section. If
additional differencing is required, it informs the user and returns a
list with ret set to FALSE.

## Details

The function calculates the frequency of the input time series using the
[`stats::frequency`](https://rdrr.io/r/stats/time.html) function. It
then applies single differencing incrementally until the Augmented
Dickey-Fuller test indicates stationarity (p-value \< 0.05) or until the
differencing order reaches the frequency of the data.

If single differencing successfully makes the time series stationary, it
returns the stationary time series and related information as a list
with the following elements:

- stationary_ts: The stationary time series after differencing.

- ndiffs: The order of differencing applied to make it stationary.

- adf_stats: Augmented Dickey-Fuller test statistics on the stationary
  time series.

- trans_type: Transformation type, which is "diff" in this case.

- ret: TRUE to indicate a successful transformation.

If the data requires more single differencing than its frequency allows,
it informs the user and returns a list with ret set to FALSE, indicating
that double differencing may be needed.

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
[`util_doublediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doublediff_ts.md),
[`util_doubledifflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doubledifflog_ts.md),
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using a time series dataset
util_singlediff_ts(AirPassengers)
#> Differencing of order 1 made the time series stationary
#> $stationary_ts
#>       Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
#> 1949         6   14   -3   -8   14   13    0  -12  -17  -15   14
#> 1950   -3   11   15   -6  -10   24   21    0  -12  -25  -19   26
#> 1951    5    5   28  -15    9    6   21    0  -15  -22  -16   20
#> 1952    5    9   13  -12    2   35   12   12  -33  -18  -19   22
#> 1953    2    0   40   -1   -6   14   21    8  -35  -26  -31   21
#> 1954    3  -16   47   -8    7   30   38   -9  -34  -30  -26   26
#> 1955   13   -9   34    2    1   45   49  -17  -35  -38  -37   41
#> 1956    6   -7   40   -4    5   56   39   -8  -50  -49  -35   35
#> 1957    9  -14   55   -8    7   67   43    2  -63  -57  -42   31
#> 1958    4  -22   44  -14   15   72   56   14 -101  -45  -49   27
#> 1959   23  -18   64  -10   24   52   76   11  -96  -56  -45   43
#> 1960   12  -26   28   42   11   63   87  -16  -98  -47  -71   42
#> 
#> $ndiffs
#> [1] 1
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -7.017671
#> 
#> $adf_stats$p_value
#> [1] 0.01
#> 
#> 
#> $trans_type
#> [1] "diff"
#> 
#> $ret
#> [1] TRUE
#> 

# Example 2: Using a different time series dataset
util_singlediff_ts(BJsales)$ret
#> Data requires more single differencing than its frequency, trying double
#> differencing
#> [1] FALSE
```
