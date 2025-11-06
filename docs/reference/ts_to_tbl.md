# Coerce a time-series object to a tibble

This function takes in a time-series object and returns it in a `tibble`
format.

## Usage

``` r
ts_to_tbl(.data)
```

## Arguments

- .data:

  The time-series object you want transformed into a `tibble`

## Value

A tibble

## Details

This function makes use of
[`timetk::tk_tbl()`](https://business-science.github.io/timetk/reference/tk_tbl.html)
under the hood to obtain the initial `tibble` object. After the inital
object is obtained a new column called `date_col` is constructed from
the `index` column using `lubridate` if an index column is returned.

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
[`util_difflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_difflog_ts.md),
[`util_doublediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doublediff_ts.md),
[`util_doubledifflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doubledifflog_ts.md),
[`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md),
[`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
ts_to_tbl(BJsales)
#> # A tibble: 150 × 1
#>    value
#>    <dbl>
#>  1  200.
#>  2  200.
#>  3  199.
#>  4  199.
#>  5  199 
#>  6  200.
#>  7  199.
#>  8  200 
#>  9  200.
#> 10  201.
#> # ℹ 140 more rows
ts_to_tbl(AirPassengers)
#> # A tibble: 144 × 3
#>    index     date_col   value
#>    <yearmon> <date>     <dbl>
#>  1 Jan 1949  1949-01-01   112
#>  2 Feb 1949  1949-02-01   118
#>  3 Mar 1949  1949-03-01   132
#>  4 Apr 1949  1949-04-01   129
#>  5 May 1949  1949-05-01   121
#>  6 Jun 1949  1949-06-01   135
#>  7 Jul 1949  1949-07-01   148
#>  8 Aug 1949  1949-08-01   148
#>  9 Sep 1949  1949-09-01   136
#> 10 Oct 1949  1949-10-01   119
#> # ℹ 134 more rows
```
