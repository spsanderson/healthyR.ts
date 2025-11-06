# Differencing with Log Transformation to Make Time Series Stationary

This function attempts to make a non-stationary time series stationary
by applying differencing with a logarithmic transformation. It
iteratively increases the differencing order until stationarity is
achieved or informs the user if the transformation is not possible.

## Usage

``` r
util_difflog_ts(.time_series)
```

## Arguments

- .time_series:

  A time series object to be made stationary.

## Value

If the time series is already stationary or the differencing with a
logarithmic transformation is successful,

## Details

The function calculates the frequency of the input time series using the
[`stats::frequency`](https://rdrr.io/r/stats/time.html) function and
checks if the minimum value of the time series is greater than 0. It
then applies differencing with a logarithmic transformation
incrementally until the Augmented Dickey-Fuller test indicates
stationarity (p-value \< 0.05) or until the differencing order reaches
the frequency of the data.

If differencing with a logarithmic transformation successfully makes the
time series stationary, it returns the stationary time series and
related information as a list with the following elements:

- stationary_ts: The stationary time series after the transformation.

- ndiffs: The order of differencing applied to make it stationary.

- adf_stats: Augmented Dickey-Fuller test statistics on the stationary
  time series.

- trans_type: Transformation type, which is "diff_log" in this case.

- ret: TRUE to indicate a successful transformation.

If the data either had a minimum value less than or equal to 0 or
requires more differencing than its frequency allows, it informs the
user and suggests trying double differencing with a logarithmic
transformation.

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
[`util_doublediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doublediff_ts.md),
[`util_doubledifflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doubledifflog_ts.md),
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md),
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# Example 1: Using a time series dataset
util_difflog_ts(AirPassengers)
#> Differencing of order 1 made the time series stationary
#> $stationary_ts
#>               Jan          Feb          Mar          Apr          May
#> 1949               0.052185753  0.112117298 -0.022989518 -0.064021859
#> 1950 -0.025752496  0.091349779  0.112477983 -0.043485112 -0.076961041
#> 1951  0.035091320  0.033901552  0.171148256 -0.088033349  0.053744276
#> 1952  0.029675768  0.051293294  0.069733338 -0.064193158  0.010989122
#> 1953  0.010256500  0.000000000  0.185717146 -0.004246291 -0.025863511
#> 1954  0.014815086 -0.081678031  0.223143551 -0.034635497  0.030371098
#> 1955  0.055215723 -0.037899273  0.136210205  0.007462721  0.003710579
#> 1956  0.021353124 -0.024956732  0.134884268 -0.012698583  0.015848192
#> 1957  0.028987537 -0.045462374  0.167820466 -0.022728251  0.019915310
#> 1958  0.011834458 -0.066894235  0.129592829 -0.039441732  0.042200354
#> 1959  0.066021101 -0.051293294  0.171542423 -0.024938948  0.058840500
#> 1960  0.029199155 -0.064378662  0.069163360  0.095527123  0.023580943
#>               Jun          Jul          Aug          Sep          Oct
#> 1949  0.109484233  0.091937495  0.000000000 -0.084557388 -0.133531393
#> 1950  0.175632569  0.131852131  0.000000000 -0.073203404 -0.172245905
#> 1951  0.034289073  0.111521274  0.000000000 -0.078369067 -0.127339422
#> 1952  0.175008910  0.053584246  0.050858417 -0.146603474 -0.090060824
#> 1953  0.059339440  0.082887660  0.029852963 -0.137741925 -0.116202008
#> 1954  0.120627988  0.134477914 -0.030254408 -0.123344547 -0.123106058
#> 1955  0.154150680  0.144581229 -0.047829088 -0.106321592 -0.129875081
#> 1956  0.162204415  0.099191796 -0.019560526 -0.131769278 -0.148532688
#> 1957  0.172887525  0.097032092  0.004291852 -0.144914380 -0.152090098
#> 1958  0.180943197  0.121098097  0.028114301 -0.223143551 -0.118092489
#> 1959  0.116724274  0.149296301  0.019874186 -0.188422419 -0.128913869
#> 1960  0.125287761  0.150673346 -0.026060107 -0.176398538 -0.097083405
#>               Nov          Dec
#> 1949 -0.134732594  0.126293725
#> 1950 -0.154150680  0.205443974
#> 1951 -0.103989714  0.128381167
#> 1952 -0.104778951  0.120363682
#> 1953 -0.158901283  0.110348057
#> 1954 -0.120516025  0.120516025
#> 1955 -0.145067965  0.159560973
#> 1956 -0.121466281  0.121466281
#> 1957 -0.129013003  0.096799383
#> 1958 -0.146750091  0.083510633
#> 1959 -0.117168974  0.112242855
#> 1960 -0.167251304  0.102278849
#> 
#> $ndiffs
#> [1] 1
#> 
#> $adf_stats
#> $adf_stats$test_stat
#> [1] -6.431315
#> 
#> $adf_stats$p_value
#> [1] 0.01
#> 
#> 
#> $trans_type
#> [1] "diff_log"
#> 
#> $ret
#> [1] TRUE
#> 

# Example 2: Using a different time series dataset
util_difflog_ts(BJsales)$ret
#> Data either had a minimum value less than or equal to 0, or requires more than
#> differencing than its frequency, trying double differencing log.
#> [1] FALSE
```
