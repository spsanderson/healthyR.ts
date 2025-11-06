# Time Series Model QQ Plot

This takes in a calibration tibble and will produce a QQ plot.

## Usage

``` r
ts_qq_plot(.calibration_tbl, .model_id = NULL, .interactive = FALSE)
```

## Arguments

- .calibration_tbl:

  A calibrated modeltime table.

- .model_id:

  The id of a particular model from a calibration tibble. If there are
  multiple models in the tibble and this remains **NULL** then the plot
  will be returned using `ggplot2::facet_grid(~ .model_id)`

- .interactive:

  A boolean with a default value of FALSE. TRUE will produce an
  interactive `plotly` plot.

## Value

A QQ plot.

## Details

This takes in a calibration tibble and will create a QQ plot. You can
also pass in a `model_id` and a boolean for `interactive` which will
return a
[`plotly::ggplotly`](https://rdrr.io/pkg/plotly/man/ggplotly.html)
interactive plot.

## See also

<https://en.wikipedia.org/wiki/Q%E2%80%93Q_plot>

Other Plot:
[`ts_brownian_motion_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_plot.md),
[`ts_event_analysis_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_event_analysis_plot.md),
[`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md)

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
# NOT RUN
if (FALSE) { # \dontrun{
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(modeltime))
suppressPackageStartupMessages(library(rsample))
suppressPackageStartupMessages(library(workflows))
suppressPackageStartupMessages(library(parsnip))
suppressPackageStartupMessages(library(recipes))

data_tbl <- ts_to_tbl(AirPassengers) %>%
  select(-index)

splits <- time_series_split(
  data_tbl,
  date_var = date_col,
  assess = "12 months",
  cumulative = TRUE
)

rec_obj <- recipe(value ~ ., training(splits))

model_spec_arima <- arima_reg() %>%
  set_engine(engine = "auto_arima")

model_spec_mars <- mars(mode = "regression") %>%
  set_engine("earth")

wflw_fit_arima <- workflow() %>%
  add_recipe(rec_obj) %>%
  add_model(model_spec_arima) %>%
  fit(training(splits))

wflw_fit_mars <- workflow() %>%
  add_recipe(rec_obj) %>%
  add_model(model_spec_mars) %>%
  fit(training(splits))

model_tbl <- modeltime_table(wflw_fit_arima, wflw_fit_mars)

calibration_tbl <- model_tbl %>%
  modeltime_calibrate(new_data = testing(splits))

ts_qq_plot(calibration_tbl)

} # }
```
