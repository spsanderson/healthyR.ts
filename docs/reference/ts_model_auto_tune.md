# Time Series Model Tuner

This function will create a tuned model. It uses the
[`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)
under the hood to get the generic template that is used in the grid
search.

## Usage

``` r
ts_model_auto_tune(
  .modeltime_model_id,
  .calibration_tbl,
  .splits_obj,
  .drop_training_na = TRUE,
  .date_col,
  .value_col,
  .tscv_assess = "12 months",
  .tscv_skip = "6 months",
  .slice_limit = 6,
  .facet_ncol = 2,
  .grid_size = 30,
  .num_cores = 1,
  .best_metric = "rmse"
)
```

## Arguments

- .modeltime_model_id:

  The .model_id from a calibrated modeltime table.

- .calibration_tbl:

  A calibrated modeltime table.

- .splits_obj:

  The time_series_split object.

- .drop_training_na:

  A boolean that will drop NA values from the training(splits) data

- .date_col:

  The column that holds the date values.

- .value_col:

  The column that holds the time series values.

- .tscv_assess:

  A character expression like "12 months". This gets passed to
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .tscv_skip:

  A character expression like "6 months". This gets passed to
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .slice_limit:

  An integer that gets passed to
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .facet_ncol:

  The number of faceted columns to be passed to plot_time_series_cv_plan

- .grid_size:

  An integer that gets passed to the
  [`dials::grid_latin_hypercube()`](https://dials.tidymodels.org/reference/grid_max_entropy.html)
  function.

- .num_cores:

  The default is 1, you can set this to any integer value as long as it
  is equal to or less than the available cores on your machine.

- .best_metric:

  The default is "rmse" and this can be set to any default dials metric.
  This must be passed as a character.

## Value

A list object with multiple items.

## Details

This function can work with the following parsnip/modeltime engines:

- "auto_arima"

- "auto_arima_xgboost"

- "ets"

- "croston"

- "theta"

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

This function returns a list object with several items inside of it.
There are three categories of items that are inside of the list.

- `data`

- `model_info`

- `plots`

The `data` section has the following items:

- `calibration_tbl` This is the calibration data passed into the
  function.

- `calibration_tuned_tbl` This is a calibration tibble that has used the
  tuned workflow.

- `tscv_data_tbl` This is the tibble of the time series cross
  validation.

- `tuned_results` This is a tuning results tibble with all slices from
  the time series cross validation.

- `best_tuned_results_tbl` This is a tibble of the parameters for the
  best test set with the chosen metric.

- `tscv_obj` This is the actual time series cross validation object
  returned from
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

The `model_info` section has the following items:

- `model_spec` This is the original modeltime/parsnip model
  specification.

- `model_spec_engine` This is the engine used for the model
  specification.

- `model_spec_tuner` This is the tuning model template returned from
  [`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)

- `plucked_model` This is the model that we have plucked from the
  calibration tibble for tuning.

- `wflw_tune_spec` This is a new workflow with the `model_spec_tuner`
  attached.

- `grid_spec` This is the grid search specification for the tuning
  process.

- `tuned_tscv_wflw_spec` This is the final tuned model where the
  workflow and model have been finalized. This would be the model that
  you would want to pull out if you are going to work with it further.

The `plots` section has the following items:

- `tune_results_plt` This is a static ggplot of the grid search.

- `tscv_pl` This is the time series cross validation plan plot.

## See also

Other Model Tuning:
[`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)

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
suppressPackageStartupMessages(library(modeltime))
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(dplyr))

data <- ts_to_tbl(AirPassengers) %>%
  select(-index)

splits <- time_series_split(
    data
    , date_col
    , assess = 12
    , skip = 3
    , cumulative = TRUE
)

rec_objs <- ts_auto_recipe(
  .data = data
  , .date_col = date_col
  , .pred_col = value
)

wfsets <- ts_wfs_mars(
  .model_type = "earth"
  , .recipe_list = rec_objs
)

wf_fits <- wfsets %>%
  modeltime_fit_workflowset(
    data = training(splits)
    , control = control_fit_workflowset(
     allow_par = TRUE
     , verbose = TRUE
    )
  )

models_tbl <- wf_fits %>%
  filter(.model != "NULL")

calibration_tbl <- models_tbl %>%
  modeltime_calibrate(new_data = testing(splits))

output <- ts_model_auto_tune(
  .modeltime_model_id = 1,
  .calibration_tbl = calibration_tbl,
  .splits_obj = splits,
  .drop_training_na = TRUE,
  .date_col = date_col,
  .value_col = value,
  .tscv_assess = "12 months",
  .tscv_skip = "3 months",
  .num_cores = parallel::detectCores() - 1
)
} # }
```
