# Get Time Series Information

This function will take in a data set and return to you a tibble of
useful information.

## Usage

``` r
ts_info_tbl(.data, .date_col)
```

## Arguments

- .data:

  The data you are passing to the function

- .date_col:

  This is only needed if you are passing a tibble.

## Value

A tibble

## Details

This function can accept objects of the following classes:

- ts

- xts

- mts

- zoo

- tibble/data.frame

The function will return the following pieces of information in a
tibble:

- name

- class

- frequency

- start

- end

- var

- length

## See also

Other Utility:
[`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md),
[`calibrate_and_plot()`](https://www.spsanderson.com/healthyR.ts/reference/calibrate_and_plot.md),
[`internal_ts_backward_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_backward_event_tbl.md),
[`internal_ts_both_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_both_event_tbl.md),
[`internal_ts_forward_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_forward_event_tbl.md),
[`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md),
[`ts_get_date_columns()`](https://www.spsanderson.com/healthyR.ts/reference/ts_get_date_columns.md),
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
ts_info_tbl(AirPassengers)
#> # A tibble: 1 × 7
#>   name          class frequency start  end     var        length
#>   <chr>         <chr>     <dbl> <chr>  <chr>   <chr>       <int>
#> 1 AirPassengers ts           12 1949 1 1960 12 univariate    144
ts_info_tbl(BJsales)
#> # A tibble: 1 × 7
#>   name    class frequency start end   var        length
#>   <chr>   <chr>     <dbl> <chr> <chr> <chr>       <int>
#> 1 BJsales ts            1 1 1   150 1 univariate    150
```
