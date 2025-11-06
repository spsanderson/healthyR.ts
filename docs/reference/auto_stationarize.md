# Automatically Stationarize Time Series Data

This function attempts to make a non-stationary time series stationary.
This function attempts to make a given time series stationary by
applying transformations such as differencing or logarithmic
transformation. If the time series is already stationary, it returns the
original time series.

## Usage

``` r
auto_stationarize(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary, it returns the original time
series. If a transformation is applied to make it stationary, it returns
a list with two elements:

- stationary_ts: The stationary time series.

- ndiffs: The order of differencing applied to make it stationary.

## Details

If the input time series is non-stationary (determined by the Augmented
Dickey-Fuller test), this function will try to make it stationary by
applying a series of transformations:

1.  It checks if the time series is already stationary using the
    Augmented Dickey-Fuller test.

2.  If not stationary, it attempts a logarithmic transformation.

3.  If the logarithmic transformation doesn't work, it applies
    differencing.

## See also

Other Utility:
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
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md),
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using the AirPassengers dataset
auto_stationarize(AirPassengers)
#> The time series is already stationary via ts_adf_test().
#>      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
#> 1949 112 118 132 129 121 135 148 148 136 119 104 118
#> 1950 115 126 141 135 125 149 170 170 158 133 114 140
#> 1951 145 150 178 163 172 178 199 199 184 162 146 166
#> 1952 171 180 193 181 183 218 230 242 209 191 172 194
#> 1953 196 196 236 235 229 243 264 272 237 211 180 201
#> 1954 204 188 235 227 234 264 302 293 259 229 203 229
#> 1955 242 233 267 269 270 315 364 347 312 274 237 278
#> 1956 284 277 317 313 318 374 413 405 355 306 271 306
#> 1957 315 301 356 348 355 422 465 467 404 347 305 336
#> 1958 340 318 362 348 363 435 491 505 404 359 310 337
#> 1959 360 342 406 396 420 472 548 559 463 407 362 405
#> 1960 417 391 419 461 472 535 622 606 508 461 390 432

# Example 2: Using the BJsales dataset
auto_stationarize(BJsales)
#> The time series is not stationary. Attempting to make it stationary...
#> Logrithmic Transformation Failed.
#> Data requires more single differencing than its frequency, trying double
#> differencing
#> Double Differencing of order 1 made the time series stationary
#> $stationary_ts
#> Time Series:
#> Start = 3 
#> End = 150 
#> Frequency = 1 
#>   [1]  0.5 -0.4  0.6  1.1 -2.8  3.0 -1.1  0.6 -0.5 -0.5  0.1  2.0 -0.6  0.8  1.2
#>  [16] -3.4 -0.7 -0.3  1.7  3.0 -3.2  0.9  2.2 -2.5 -0.4  2.6 -4.3  2.0 -3.1  2.7
#>  [31] -2.1  0.1  2.1 -0.2 -2.2  0.6  1.0 -2.6  3.0  0.3  0.2 -0.8  1.0  0.0  3.2
#>  [46] -2.2 -4.7  1.2  0.8 -0.6 -0.4  0.6  1.0 -1.6 -0.1  3.4 -0.9 -1.7 -0.5  0.8
#>  [61]  2.4 -1.9  0.6 -2.2  2.6 -0.1 -2.7  1.7 -0.3  1.9 -2.7  1.1 -0.6  0.9  0.0
#>  [76]  1.8 -0.5 -0.4 -1.2  2.6 -1.8  1.7 -0.9  0.6 -0.4  3.0 -2.8  3.1 -2.3 -1.1
#>  [91]  2.1 -0.3 -1.7 -0.8 -0.4  1.1 -1.5  0.3  1.4 -2.0  1.3 -0.3  0.4 -3.5  1.1
#> [106]  2.6  0.4 -1.3  2.0 -1.6  0.6 -0.1 -1.4  1.6  1.6 -3.4  1.7 -2.2  2.1 -2.0
#> [121] -0.2  0.2  0.7 -1.4  1.8 -0.1 -0.7  0.4  0.4  1.0 -2.4  1.0 -0.4  0.8 -1.0
#> [136]  1.4 -1.2  1.1 -0.9  0.5  1.9 -0.6  0.3 -1.4 -0.9 -0.5  1.4  0.1
#> 
#> $ndiffs
#> [1] 1
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -6.562008
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
```
