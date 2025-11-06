# Auto NNETAR Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_nnetar_reg(
  .model_type = "nnetar",
  .recipe_list,
  .non_seasonal_ar = 0,
  .seasonal_ar = 0,
  .hidden_units = 5,
  .num_networks = 10,
  .penalty = 0.1,
  .epochs = 10
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`modeltime::nnetar_reg()`](https://business-science.github.io/modeltime/reference/nnetar_reg.html)
  under the hood and can take one of the following:

  - "nnetar"

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .non_seasonal_ar:

  The order of the non-seasonal auto-regressive (AR) terms. Often
  denoted "p" in pdq-notation.

- .seasonal_ar:

  The order of the seasonal auto-regressive (SAR) terms. Often denoted
  "P" in PDQ-notation.

- .hidden_units:

  An integer for the number of units in the hidden model.

- .num_networks:

  Number of networks to fit with different random starting weights.
  These are then averaged when producing forecasts.

- .penalty:

  A non-negative numeric value for the amount of weight decay.

- .epochs:

  An integer for the number of training iterations.

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This uses the following engines:

[`modeltime::nnetar_reg()`](https://business-science.github.io/modeltime/reference/nnetar_reg.html)
nnetar_reg() is a way to generate a specification of an NNETAR model
before fitting and allows the model to be created using different
packages. Currently the only package is forecast.

- "nnetar"

## See also

<https://workflowsets.tidymodels.org/>

<https://business-science.github.io/modeltime/reference/nnetar_reg.html>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
[`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
[`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
[`ts_wfs_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_prophet_reg.md),
[`ts_wfs_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_poly.md),
[`ts_wfs_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_rbf.md),
[`ts_wfs_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_xgboost.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(modeltime))
suppressPackageStartupMessages(library(timetk))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(rsample))

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

rec_objs <- ts_auto_recipe(
 .data = training(splits)
 , .date_col = date_col
 , .pred_col = value
)

wf_sets <- ts_wfs_nnetar_reg("nnetar", rec_objs)
wf_sets
#> # A workflow set/tibble: 4 × 4
#>   wflow_id                        info             option    result    
#>   <chr>                           <list>           <list>    <list>    
#> 1 rec_base_nnetar_reg             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_date_nnetar_reg             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_fourier_nnetar_reg     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_fourier_nzv_nnetar_reg <tibble [1 × 4]> <opts[0]> <list [0]>
```
