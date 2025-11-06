# Boilerplate Workflow

This is a boilerplate function to create automatically the following:

- recipe

- model specification

- workflow

- calibration tibble and plot

## Usage

``` r
ts_auto_lm(
  .data,
  .date_col,
  .value_col,
  .formula,
  .rsamp_obj,
  .prefix = "ts_lm",
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

  Default is `ts_lm`

- .bootstrap_final:

  Not yet implemented.

## Value

A list

## Details

This uses
[`parsnip::linear_reg()`](https://parsnip.tidymodels.org/reference/linear_reg.html)
and sets the `engine` to `lm`

## See also

<https://parsnip.tidymodels.org/reference/linear_reg.html>

Other Boiler_Plate:
[`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md),
[`ts_auto_arima_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima_xgboost.md),
[`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md),
[`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md),
[`ts_auto_glmnet()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_glmnet.md),
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

ts_lm <- ts_auto_lm(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
)
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `.nested.col = purrr::map2(...)`.
#> Caused by warning in `predict.lm()`:
#> ! prediction from rank-deficient fit; consider predict(., rankdeficient="NA")
#> Warning: There was 1 warning in `dplyr::mutate()`.
#> ℹ In argument: `.nested.col = purrr::map2(...)`.
#> Caused by warning in `predict.lm()`:
#> ! prediction from rank-deficient fit; consider predict(., rankdeficient="NA")

ts_lm$recipe_info
#> $recipe_call
#> recipe(.data = data, .date_col = date_col, .value_col = value, 
#>     .formula = value ~ ., .rsamp_obj = splits)
#> 
#> $recipe_syntax
#> [1] "ts_lm_recipe <-"                                                                                                    
#> [2] "\n  recipe(.data = data, .date_col = date_col, .value_col = value, .formula = value ~ \n    ., .rsamp_obj = splits)"
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
#> • Variable mutation for: as.numeric(^date_col)
#> • Dummy variables from: recipes::all_nominal()
#> • Sparse, unbalanced variable filter on: recipes::all_predictors(), ...
#> • Centering and scaling for: recipes::all_numeric_predictors(), ...
#> • Linear combination filter on: recipes::all_numeric_predictors()
#> 
# }
```
