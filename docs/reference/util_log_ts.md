# Logarithmic Transformation to Make Time Series Stationary

This function attempts to make a non-stationary time series stationary
by applying a logarithmic transformation. If successful, it returns the
stationary time series. If the transformation fails, it informs the
user.

## Usage

``` r
util_log_ts(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary or the logarithmic
transformation is successful, it returns a list as described in the
details section. If the transformation fails, it returns a list with ret
set to FALSE.

## Details

This function checks if the minimum value of the input time series is
greater than or equal to zero. If yes, it performs the Augmented
Dickey-Fuller test on the logarithm of the time series. If the p-value
of the test is less than 0.05, it concludes that the logarithmic
transformation made the time series stationary and returns the result as
a list with the following elements:

- stationary_ts: The stationary time series after the logarithmic
  transformation.

- ndiffs: Not applicable in this case, marked as NA.

- adf_stats: Augmented Dickey-Fuller test statistics on the stationary
  time series.

- trans_type: Transformation type, which is "log" in this case.

- ret: TRUE to indicate a successful transformation.

If the minimum value of the time series is less than or equal to 0 or if
the logarithmic transformation doesn't make the time series stationary,
it informs the user and returns a list with ret set to FALSE.

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
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using a time series dataset
util_log_ts(AirPassengers)
#> Logrithmic transformation made the time series stationary
#> $stationary_ts
#>           Jan      Feb      Mar      Apr      May      Jun      Jul      Aug
#> 1949 4.718499 4.770685 4.882802 4.859812 4.795791 4.905275 4.997212 4.997212
#> 1950 4.744932 4.836282 4.948760 4.905275 4.828314 5.003946 5.135798 5.135798
#> 1951 4.976734 5.010635 5.181784 5.093750 5.147494 5.181784 5.293305 5.293305
#> 1952 5.141664 5.192957 5.262690 5.198497 5.209486 5.384495 5.438079 5.488938
#> 1953 5.278115 5.278115 5.463832 5.459586 5.433722 5.493061 5.575949 5.605802
#> 1954 5.318120 5.236442 5.459586 5.424950 5.455321 5.575949 5.710427 5.680173
#> 1955 5.488938 5.451038 5.587249 5.594711 5.598422 5.752573 5.897154 5.849325
#> 1956 5.648974 5.624018 5.758902 5.746203 5.762051 5.924256 6.023448 6.003887
#> 1957 5.752573 5.707110 5.874931 5.852202 5.872118 6.045005 6.142037 6.146329
#> 1958 5.828946 5.762051 5.891644 5.852202 5.894403 6.075346 6.196444 6.224558
#> 1959 5.886104 5.834811 6.006353 5.981414 6.040255 6.156979 6.306275 6.326149
#> 1960 6.033086 5.968708 6.037871 6.133398 6.156979 6.282267 6.432940 6.406880
#>           Sep      Oct      Nov      Dec
#> 1949 4.912655 4.779123 4.644391 4.770685
#> 1950 5.062595 4.890349 4.736198 4.941642
#> 1951 5.214936 5.087596 4.983607 5.111988
#> 1952 5.342334 5.252273 5.147494 5.267858
#> 1953 5.468060 5.351858 5.192957 5.303305
#> 1954 5.556828 5.433722 5.313206 5.433722
#> 1955 5.743003 5.613128 5.468060 5.627621
#> 1956 5.872118 5.723585 5.602119 5.723585
#> 1957 6.001415 5.849325 5.720312 5.817111
#> 1958 6.001415 5.883322 5.736572 5.820083
#> 1959 6.137727 6.008813 5.891644 6.003887
#> 1960 6.230481 6.133398 5.966147 6.068426
#> 
#> $ndiffs
#> [1] NA
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -6.421458
#> 
#> $adf_stats$p_value
#> [1] 0.01
#> 
#> 
#> $trans_type
#> [1] "log"
#> 
#> $ret
#> [1] TRUE
#> 

# Example 2: Using a different time series dataset
util_log_ts(BJsales.lead)$ret
#> Logrithmic Transformation Failed.
#> [1] FALSE
```
