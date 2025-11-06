# Boilerplate Workflow

This is a boilerplate function to create automatically the following:

- recipe

- model specification

- workflow

- tuned model (grid ect)

- calibration tibble and plot

## Usage

``` r
ts_auto_arima_xgboost(
  .data,
  .date_col,
  .value_col,
  .formula,
  .rsamp_obj,
  .prefix = "ts_arima_boost",
  .tune = TRUE,
  .grid_size = 10,
  .num_cores = 1,
  .cv_assess = 12,
  .cv_skip = 3,
  .cv_slice_limit = 6,
  .best_metric = "rmse",
  .bootstrap_final = FALSE
)
```

## Arguments

- .data:

  The data being passed to the function. The time-series object.

- .date_col:

  The column that holds the datetime.

- .value_col:

  The column that has the value

- .formula:

  The formula that is passed to the recipe like `value ~ .`

- .rsamp_obj:

  The rsample splits object

- .prefix:

  Default is `ts_arima_boost`

- .tune:

  Defaults to TRUE, this creates a tuning grid and tuned model.

- .grid_size:

  If `.tune` is TRUE then the `.grid_size` is the size of the tuning
  grid.

- .num_cores:

  How many cores do you want to use. Default is 1

- .cv_assess:

  How many observations for assess. See
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .cv_skip:

  How many observations to skip. See
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .cv_slice_limit:

  How many slices to return. See
  [`timetk::time_series_cv()`](https://business-science.github.io/timetk/reference/time_series_cv.html)

- .best_metric:

  Default is "rmse". See
  [`modeltime::default_forecast_accuracy_metric_set()`](https://business-science.github.io/modeltime/reference/metric_sets.html)

- .bootstrap_final:

  Not yet implemented.

## Value

A list

## Details

This uses the
[`modeltime::arima_boost()`](https://business-science.github.io/modeltime/reference/arima_boost.html)
with the `engine` set to `xgboost`

## See also

<https://business-science.github.io/modeltime/reference/arima_boost.html>

Other Boiler_Plate:
[`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md),
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_glmnet()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_glmnet.md),
[`ts_auto_lm()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_lm.md),
[`ts_auto_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_mars.md),
[`ts_auto_nnetar()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_nnetar.md),
[`ts_auto_prophet_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_boost.md),
[`ts_auto_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_reg.md),
[`ts_auto_smooth_es()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_smooth_es.md),
[`ts_auto_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_poly.md),
[`ts_auto_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_rbf.md),
[`ts_auto_theta()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_theta.md),
[`ts_auto_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_xgboost.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
# \donttest{
library(dplyr)
library(timetk)
library(modeltime)

data <- AirPassengers %>%
  ts_to_tbl() %>%
  select(-index)

splits <- time_series_split(
  data
  , date_col
  , assess = 12
  , skip = 3
  , cumulative = TRUE
)

ts_auto_arima_xgboost <- ts_auto_arima_xgboost(
  .data = data,
  .num_cores = 2,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .grid_size = 5,
  .cv_slice_limit = 2,
  .tune = FALSE
)
#> frequency = 12 observations per 1 year

ts_auto_arima_xgboost$recipe_info
#> $recipe_call
#> recipe(.data = data, .date_col = date_col, .value_col = value, 
#>     .formula = value ~ ., .rsamp_obj = splits, .tune = FALSE, 
#>     .grid_size = 5, .num_cores = 2, .cv_slice_limit = 2)
#> 
#> $recipe_syntax
#> [1] "ts_arima_boost_recipe <-"                                                                                                                                                                     
#> [2] "\n  recipe(.data = data, .date_col = date_col, .value_col = value, .formula = value ~ \n    ., .rsamp_obj = splits, .tune = FALSE, .grid_size = 5, .num_cores = 2, \n    .cv_slice_limit = 2)"
#> 
#> $rec_obj
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: date_col
#> • Novel factor level assignment for: recipes::all_nominal_predictors()
#> • Variable mutation for: tidyselect::vars_select_helpers$where(is.character)
#> • Dummy variables from: recipes::all_nominal()
#> • Zero variance filter on: recipes::all_predictors() -date_col_index.num
#> • Centering and scaling for: recipes::all_numeric_predictors()
#> 
# }
```
