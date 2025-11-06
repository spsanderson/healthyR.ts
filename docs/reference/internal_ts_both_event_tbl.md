# Event Analysis

This is a function that sits inside of the
[`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md).
It is only meant to be used there. This is an internal function.

## Usage

``` r
internal_ts_both_event_tbl(.data, .horizon)
```

## Arguments

- .data:

  The date.frame/tibble that holds the data.

- .horizon:

  How far do you want to look back or ahead.

## Value

A tibble.

## Details

This is a helper function for
[`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)
only.

## See also

Other Utility:
[`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md),
[`calibrate_and_plot()`](https://www.spsanderson.com/healthyR.ts/reference/calibrate_and_plot.md),
[`internal_ts_backward_event_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/internal_ts_backward_event_tbl.md),
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
