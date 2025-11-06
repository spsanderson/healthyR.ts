# Helper function - Calibrate and Plot

This function is a helper function. It will take in a set of workflows
and then perform the
[`modeltime::modeltime_calibrate()`](https://business-science.github.io/modeltime/reference/modeltime_calibrate.html)
and
[`modeltime::plot_modeltime_forecast()`](https://business-science.github.io/modeltime/reference/plot_modeltime_forecast.html).

## Usage

``` r
calibrate_and_plot(
  ...,
  .type = "testing",
  .splits_obj,
  .data,
  .print_info = TRUE,
  .interactive = FALSE
)
```

## Arguments

- ...:

  The workflow(s) you want to add to the function.

- .type:

  Either the training(splits) or testing(splits) data.

- .splits_obj:

  The splits object.

- .data:

  The full data set.

- .print_info:

  The default is TRUE and will print out the calibration accuracy tibble
  and the resulting plotly plot.

- .interactive:

  The defaults is FALSE. This controls if a forecast plot is interactive
  or not via plotly.

## Value

The original time series, the simulated values and a some plots

## Details

This function expects to take in workflows fitted with training data.

## See also

Other Utility:
[`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md),
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
if (FALSE) { # \dontrun{
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(recipes))
suppressPackageStartupMessages(library(rsample))
suppressPackageStartupMessages(library(parsnip))
suppressPackageStartupMessages(library(workflows))

data <- ts_to_tbl(AirPassengers) %>%
  select(-index)

splits <- timetk::time_series_split(
   data
  , date_col
  , assess = 12
  , skip = 3
  , cumulative = TRUE
)

rec_obj <- recipe(value ~ ., data = training(splits))

model_spec <- linear_reg(
   mode = "regression"
   , penalty = 0.1
   , mixture = 0.5
) %>%
   set_engine("lm")

wflw <- workflow() %>%
   add_recipe(rec_obj) %>%
   add_model(model_spec) %>%
   fit(training(splits))

output <- calibrate_and_plot(
  wflw
  , .type = "training"
  , .splits_obj = splits
  , .data = data
  , .print_info = FALSE
  , .interactive = FALSE
 )
} # }
```
