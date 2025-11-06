# Time Series Model Spec Template

This function will create a generic tuneable model specification, this
function can be used by itself and is called internally by
[`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md).

## Usage

``` r
ts_model_spec_tune_template(.parsnip_engine = NULL, .model_spec_class = NULL)
```

## Arguments

- .parsnip_engine:

  The model engine that is used by
  [`parsnip::set_engine()`](https://parsnip.tidymodels.org/reference/set_engine.html).

- .model_spec_class:

  The model spec class that is use by `parsnip`. For example the
  'kernlab' engine can use both `svm_poly` and `svm_rbf`.

## Value

A tuneable parsnip model specification.

## Details

This function takes in a single parameter and uses that to output a
generic tuneable model specification. This function can work with the
following parsnip/modeltime engines:

- "auto_arima"

- "auto_arima_xgboost"

- "ets"

- "croston"

- "theta"

- "smooth_es"

- "stlm_ets"

- "tbats"

- "stlm_arima"

- "nnetar"

- "prophet"

- "prophet_xgboost"

- "lm"

- "glmnet"

- "stan"

- "spark"

- "keras"

- "earth"

- "xgboost"

- "kernlab"

## See also

Other Model Tuning:
[`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)

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
ts_model_spec_tune_template("ets")
#> Exponential Smoothing State Space Model Specification (regression)
#> 
#> Main Arguments:
#>   seasonal_period = auto
#>   error = auto
#>   trend = auto
#>   season = auto
#>   damping = auto
#>   smooth_level = tune::tune()
#>   smooth_trend = tune::tune()
#>   smooth_seasonal = tune::tune()
#> 
#> Computational engine: ets 
#> 
ts_model_spec_tune_template("prophet")
#> PROPHET Regression Model Specification (regression)
#> 
#> Main Arguments:
#>   changepoint_num = tune::tune()
#>   changepoint_range = tune::tune()
#>   seasonality_yearly = auto
#>   seasonality_weekly = auto
#>   seasonality_daily = auto
#>   prior_scale_changepoints = tune::tune()
#>   prior_scale_seasonality = tune::tune()
#>   prior_scale_holidays = tune::tune()
#> 
#> Computational engine: prophet 
#> 
```
