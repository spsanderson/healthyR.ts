# Boilerplate Workflow

This is a boilerplate function to automatically create the following:

- recipe

- model specification

- workflow

- tuned model (grid ect)

- calibration tibble and plot

## Usage

``` r
ts_auto_smooth_es(
  .data,
  .date_col,
  .value_col,
  .formula,
  .rsamp_obj,
  .prefix = "ts_smooth_es",
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

  Default is `ts_smooth_es`

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

This uses
[`modeltime::exp_smoothing()`](https://business-science.github.io/modeltime/reference/exp_smoothing.html)
and sets the `parsnip::engine` to `smooth_es`.

## See also

<https://business-science.github.io/modeltime/reference/exp_smoothing.html#ref-examples>

<https://github.com/config-i1/smooth>

Other Boiler_Plate:
[`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md),
[`ts_auto_arima_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima_xgboost.md),
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_glmnet()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_glmnet.md),
[`ts_auto_lm()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_lm.md),
[`ts_auto_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_mars.md),
[`ts_auto_nnetar()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_nnetar.md),
[`ts_auto_prophet_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_boost.md),
[`ts_auto_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_reg.md),
[`ts_auto_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_poly.md),
[`ts_auto_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_rbf.md),
[`ts_auto_theta()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_theta.md),
[`ts_auto_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_xgboost.md)

Other exp_smoothing:
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_theta()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_theta.md)

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

ts_smooth_es <- ts_auto_smooth_es(
  .data = data,
  .num_cores = 2,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .grid_size = 3,
  .tune = FALSE
)
#> Error in fit_xy(spec, x = mold$predictors, y = mold$outcomes, case_weights = case_weights,     control = control_parsnip): Please install the smooth package to use this engine.

ts_smooth_es$recipe_info
#> Error: object 'ts_smooth_es' not found
# }
```
