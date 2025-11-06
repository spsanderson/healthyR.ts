# Boilerplate Workflow

This is a boilerplate function to create automatically the following:

- recipe

- model specification

- workflow

- calibration tibble and plot

## Usage

``` r
ts_auto_theta(
  .data,
  .date_col,
  .value_col,
  .rsamp_obj,
  .prefix = "ts_theta",
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

- .rsamp_obj:

  The splits object

- .prefix:

  Default is `ts_theta`

- .bootstrap_final:

  Not yet implemented.

## Value

A list

## Details

This uses the
[`forecast::thetaf()`](https://pkg.robjhyndman.com/forecast/reference/thetaf.html)
for the `parsnip` engine. This model does not use exogenous regressors,
so only a univariate model of: value ~ date will be used from the
`.date_col` and `.value_col` that you provide.

## See also

<https://business-science.github.io/modeltime/reference/exp_smoothing.html#engine-details>

<https://pkg.robjhyndman.com/forecast/reference/thetaf.html>

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
[`ts_auto_smooth_es()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_smooth_es.md),
[`ts_auto_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_poly.md),
[`ts_auto_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_rbf.md),
[`ts_auto_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_xgboost.md)

Other exp_smoothing:
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_smooth_es()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_smooth_es.md)

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

ts_theta <- ts_auto_theta(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits
)

ts_theta$recipe_info
#> $recipe_call
#> recipe(.data = data, .date_col = date_col, .value_col = value, 
#>     .rsamp_obj = splits)
#> 
#> $recipe_syntax
#> [1] "ts_theta_recipe <-"                                                                     
#> [2] "\n  recipe(.data = data, .date_col = date_col, .value_col = value, .rsamp_obj = splits)"
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
# }
```
