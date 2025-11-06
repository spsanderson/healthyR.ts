# Boilerplate Workflow

This is a boilerplate function to create automatically the following:

- recipe

- model specification

- workflow

- tuned model (grid ect)

- calibration tibble and plot

## Usage

``` r
ts_auto_mars(
  .data,
  .date_col,
  .value_col,
  .formula,
  .rsamp_obj,
  .prefix = "ts_mars",
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

  Default is `ts_mars`

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
[`parsnip::mars()`](https://parsnip.tidymodels.org/reference/mars.html)
function with the `engine` set to `earth`.

## See also

<https://parsnip.tidymodels.org/reference/mars.html>

Other Boiler_Plate:
[`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md),
[`ts_auto_arima_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima_xgboost.md),
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_glmnet()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_glmnet.md),
[`ts_auto_lm()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_lm.md),
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
library(earth)
#> Error in library(earth): there is no package called 'earth'

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

ts_auto_mars <- ts_auto_mars(
  .data = data,
  .num_cores = 2,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .grid_size = 20,
  .tune = FALSE
)
#> Error in fit_xy(spec, x = mold$predictors, y = mold$outcomes, case_weights = case_weights,     control = control_parsnip): Please install the earth package to use this engine.

ts_auto_mars$recipe_info
#> Error in ts_auto_mars$recipe_info: object of type 'closure' is not subsettable
# }
```
