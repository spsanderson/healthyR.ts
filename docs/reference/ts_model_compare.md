# Compare Two Time Series Models

This function will expect to take in two models that will be used for
comparison. It is useful to use this after appropriately following the
modeltime workflow and getting two models to compare. This is an
extension of the calibrate and plot, but it only takes two models and is
most likely better suited to be used after running a model through the
[`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)
function to see the difference in performance after a base model has
been tuned.

## Usage

``` r
ts_model_compare(
  .model_1,
  .model_2,
  .type = "testing",
  .splits_obj,
  .data,
  .print_info = TRUE,
  .metric = "rmse"
)
```

## Arguments

- .model_1:

  The model being compared to the base, this can also be a
  hyperparameter tuned model.

- .model_2:

  The base model.

- .type:

  The default is the testing tibble, can be set to training as well.

- .splits_obj:

  The splits object

- .data:

  The original data that was passed to splits

- .print_info:

  This is a boolean, the default is TRUE

- .metric:

  This should be one of the following character strings:

  - "mae"

  - "mape"

  - "mase"

  - "smape"

  - "rmse"

  - "rsq"

## Value

The function outputs a list invisibly.

## Details

This function expects to take two models. You must tell it if it will be
assessing the training or testing data, where the testing data is the
default. You must therefore supply the splits object to this function
along with the origianl dataset. You must also tell it which default
modeltime accuracy metric should be printed on the graph itself. You can
also tell this function to print information to the console or not. A
static `ggplot2` polot and an interactive `plotly` plot will be returned
inside of the output list.

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
suppressPackageStartupMessages(library(rsample))
suppressPackageStartupMessages(library(dplyr))

data_tbl <- ts_to_tbl(AirPassengers) %>%
  select(-index)

splits <- time_series_split(
  data       = data_tbl,
  date_var   = date_col,
  assess     = "12 months",
  cumulative = TRUE
)

rec_obj <- ts_auto_recipe(
 .data     = data_tbl,
 .date_col = date_col,
 .pred_col = value
)

wfs_mars <- ts_wfs_mars(.recipe_list = rec_obj)

wf_fits <- wfs_mars %>%
  modeltime_fit_workflowset(
    data = training(splits)
    , control = control_fit_workflowset(
         allow_par = FALSE
         , verbose = TRUE
       )
 )

calibration_tbl <- wf_fits %>%
    modeltime_calibrate(new_data = testing(splits))

base_mars <- calibration_tbl %>% pluck_modeltime_model(1)
date_mars <- calibration_tbl %>% pluck_modeltime_model(2)

ts_model_compare(
 .model_1    = base_mars,
 .model_2    = date_mars,
 .type       = "testing",
 .splits_obj = splits,
 .data       = data_tbl,
 .print_info = TRUE,
 .metric     = "rmse"
 )$plots$static_plot
} # }
```
