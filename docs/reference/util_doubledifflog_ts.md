# Double Differencing with Log Transformation to Make Time Series Stationary

This function attempts to make a non-stationary time series stationary
by applying double differencing with a logarithmic transformation. It
iteratively increases the differencing order until stationarity is
achieved or informs the user if the transformation is not possible.

## Usage

``` r
util_doubledifflog_ts(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary or the double differencing with
a logarithmic transformation is successful, it returns a list as
described in the details section. If the transformation is not possible,
it informs the user and returns a list with ret set to FALSE, indicating
that the data could not be stationarized.

## Details

The function calculates the frequency of the input time series using the
[`stats::frequency`](https://rdrr.io/r/stats/time.html) function and
checks if the minimum value of the time series is greater than 0. It
then applies double differencing with a logarithmic transformation
incrementally until the Augmented Dickey-Fuller test indicates
stationarity (p-value \< 0.05) or until the differencing order reaches
the frequency of the data.

If double differencing with a logarithmic transformation successfully
makes the time series stationary, it returns the stationary time series
and related information as a list with the following elements:

- stationary_ts: The stationary time series after the transformation.

- ndiffs: The order of differencing applied to make it stationary.

- adf_stats: Augmented Dickey-Fuller test statistics on the stationary
  time series.

- trans_type: Transformation type, which is "double_diff_log" in this
  case.

- ret: TRUE to indicate a successful transformation.

If the data either had a minimum value less than or equal to 0 or
requires more differencing than its frequency allows, it informs the
user that the data could not be stationarized.

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
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md),
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using a time series dataset
util_doubledifflog_ts(AirPassengers)
#> Double Differencing of order 1 made the time series stationary
#> $stationary_ts
#>                Jan           Feb           Mar           Apr           May
#> 1949                              0.0599315450 -0.1351068163 -0.0410323405
#> 1950 -0.1520462214  0.1171022747  0.0211282048 -0.1559630954 -0.0334759292
#> 1951 -0.1703526544 -0.0011897681  0.1372467045 -0.2591816057  0.1417776255
#> 1952 -0.0987053985  0.0216175262  0.0184400436 -0.1339264957  0.0751822792
#> 1953 -0.1101071821 -0.0102565002  0.1857171458 -0.1899634367 -0.0216172197
#> 1954 -0.0955329714 -0.0964931168  0.3048215823 -0.2577790480  0.0650065945
#> 1955 -0.0653003019 -0.0931149952  0.1741094774 -0.1287474836 -0.0037521418
#> 1956 -0.1382078481 -0.0463098564  0.1598409997 -0.1475828510  0.0285467756
#> 1957 -0.0924787442 -0.0744499110  0.2132828402 -0.1905487172  0.0426435608
#> 1958 -0.0849649257 -0.0787286925  0.1964870639 -0.1690345611  0.0816420865
#> 1959 -0.0174895318 -0.1173143955  0.2228357169 -0.1964813709  0.0837794484
#> 1960 -0.0830437006 -0.0935778165  0.1335420218  0.0263637631 -0.0719461805
#>                Jun           Jul           Aug           Sep           Oct
#> 1949  0.1735060916 -0.0175467375 -0.0919374953 -0.0845573880 -0.0489740046
#> 1950  0.2525936098 -0.0437804375 -0.1318521311 -0.0732034040 -0.0990425008
#> 1951 -0.0194552025  0.0772322010 -0.1115212744 -0.0783690671 -0.0489703553
#> 1952  0.1640197884 -0.1214246638 -0.0027258289 -0.1974618914  0.0565426503
#> 1953  0.0852029504  0.0235482200 -0.0530346967 -0.1675948883  0.0215399175
#> 1954  0.0902568899  0.0138499264 -0.1647323226 -0.0930901390  0.0002384892
#> 1955  0.1504401004 -0.0095694510 -0.1924103165 -0.0584925044 -0.0235534893
#> 1956  0.1463562224 -0.0630126191 -0.1187523214 -0.1122087518 -0.0167634099
#> 1957  0.1529722149 -0.0758554330 -0.0927402395 -0.1492062318 -0.0071757183
#> 1958  0.1387428423 -0.0598451001 -0.0929837952 -0.2512578528  0.1050510618
#> 1959  0.0578837743  0.0325720271 -0.1294221152 -0.2082966053  0.0595085504
#> 1960  0.1017068187  0.0253855845 -0.1767334525 -0.1503384318  0.0793151339
#>                Nov           Dec
#> 1949 -0.0012012013  0.2610263193
#> 1950  0.0180952250  0.3595946540
#> 1951  0.0233497089  0.2323708802
#> 1952 -0.0147181273  0.2251426335
#> 1953 -0.0426992749  0.2692493398
#> 1954  0.0025900336  0.2410320490
#> 1955 -0.0151928838  0.3046289378
#> 1956  0.0270664065  0.2429325621
#> 1957  0.0230770947  0.2258123867
#> 1958 -0.0286576015  0.2302607239
#> 1959  0.0117448950  0.2294118289
#> 1960 -0.0701678993  0.2695301530
#> 
#> $ndiffs
#> [1] 1
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -7.858955
#> 
#> $adf_stats$p_value
#> [1] 0.01
#> 
#> 
#> $trans_type
#> [1] "double_diff_log"
#> 
#> $ret
#> [1] TRUE
#> 

# Example 2: Using a different time series dataset
util_doubledifflog_ts(BJsales)$ret
#> Double Differencing of order 1 made the time series stationary
#> [1] TRUE
```
