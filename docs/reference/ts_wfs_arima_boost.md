# Auto Arima XGBoost Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_arima_boost(
  .model_type = "all_engines",
  .recipe_list,
  .trees = 10,
  .min_node = 2,
  .tree_depth = 6,
  .learn_rate = 0.015,
  .stop_iter = NULL,
  .seasonal_period = 0,
  .non_seasonal_ar = 0,
  .non_seasonal_differences = 0,
  .non_seasonal_ma = 0,
  .seasonal_ar = 0,
  .seasonal_differences = 0,
  .seasonal_ma = 0
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`modeltime::arima_boost()`](https://business-science.github.io/modeltime/reference/arima_boost.html)
  under the hood and can take one of the following:

  - "arima_xgboost"

  - "auto_arima_xgboost

  - "all_engines" - This will make a model spec for all available
    engines.

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .trees:

  An integer for the number of trees contained in the ensemble.

- .min_node:

  An integer for the minimum number of data points in a node that is
  required for the node to be split further.

- .tree_depth:

  An integer for the maximum depth of the tree (i.e. number of splits)
  (specific engines only).

- .learn_rate:

  A number for the rate at which the boosting algorithm adapts from
  iteration-to-iteration (specific engines only).

- .stop_iter:

  The number of iterations without improvement before stopping (xgboost
  only).

- .seasonal_period:

  Set to 0,

- .non_seasonal_ar:

  Set to 0,

- .non_seasonal_differences:

  Set to 0,

- .non_seasonal_ma:

  Set to 0,

- .seasonal_ar:

  Set to 0,

- .seasonal_differences:

  Set to 0,

- .seasonal_ma:

  Set to 0,

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This uses the option `set_engine("auto_arima_xgboost")` or
`set_engine("arima_xgboost")`

[`modeltime::arima_boost()`](https://business-science.github.io/modeltime/reference/arima_boost.html)
arima_boost() is a way to generate a specification of a time series
model that uses boosting to improve modeling errors (residuals) on
Exogenous Regressors. It works with both "automated" ARIMA (auto.arima)
and standard ARIMA (arima). The main algorithms are:

- Auto ARIMA + XGBoost Errors (engine = auto_arima_xgboost, default)

- ARIMA + XGBoost Errors (engine = arima_xgboost)

## See also

<https://workflowsets.tidymodels.org/>

<https://business-science.github.io/modeltime/reference/arima_boost.html>

Other Auto Workflowsets:
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
[`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
[`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
[`ts_wfs_nnetar_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_nnetar_reg.md),
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

wf_sets <- ts_wfs_arima_boost("all_engines", rec_objs)
wf_sets
#> # A workflow set/tibble: 8 × 4
#>   wflow_id                           info             option    result    
#>   <chr>                              <list>           <list>    <list>    
#> 1 rec_base_arima_boost_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_base_arima_boost_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_arima_boost_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_arima_boost_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 5 rec_date_fourier_arima_boost_1     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 6 rec_date_fourier_arima_boost_2     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 7 rec_date_fourier_nzv_arima_boost_1 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 8 rec_date_fourier_nzv_arima_boost_2 <tibble [1 × 4]> <opts[0]> <list [0]>
```
