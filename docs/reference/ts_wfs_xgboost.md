# Auto XGBoost (XGBoost) Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_xgboost(
  .model_type = "xgboost",
  .recipe_list,
  .trees = 15L,
  .min_n = 1L,
  .tree_depth = 6L,
  .learn_rate = 0.3,
  .loss_reduction = 0,
  .sample_size = 1,
  .stop_iter = Inf
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [parsnip::boost_tree](https://parsnip.tidymodels.org/reference/boost_tree.html)
  under the hood and can take one of the following:

  - "xgboost"

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .trees:

  The number of trees (type: integer, default: 15L)

- .min_n:

  Minimal Node Size (type: integer, default: 1L)

- .tree_depth:

  Tree Depth (type: integer, default: 6L)

- .learn_rate:

  Learning Rate (type: double, default: 0.3)

- .loss_reduction:

  Minimum Loss Reduction (type: double, default: 0.0)

- .sample_size:

  Proportion Observations Sampled (type: double, default: 1.0)

- .stop_iter:

  The number of ierations Before Stopping (type: integer, default: Inf)

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This only uses the option `set_engine("xgboost")` and therefore the
.model_type is not needed. The parameter is kept because it is possible
in the future that this could change, and it keeps with the framework of
how other functions are written.

[`parsnip::boost_tree()`](https://parsnip.tidymodels.org/reference/boost_tree.html)
xgboost::xgb.train() creates a series of decision trees forming an
ensemble. Each tree depends on the results of previous trees. All trees
in the ensemble are combined to produce a final prediction.

## See also

<https://workflowsets.tidymodels.org/>

<https://parsnip.tidymodels.org/reference/details_boost_tree_xgboost.html>

<https://arxiv.org/abs/1603.02754>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
[`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
[`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
[`ts_wfs_nnetar_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_nnetar_reg.md),
[`ts_wfs_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_prophet_reg.md),
[`ts_wfs_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_poly.md),
[`ts_wfs_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_rbf.md)

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

wf_sets <- ts_wfs_xgboost("xgboost", rec_objs)
wf_sets
#> # A workflow set/tibble: 4 × 4
#>   wflow_id                        info             option    result    
#>   <chr>                           <list>           <list>    <list>    
#> 1 rec_base_boost_tree             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_date_boost_tree             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_fourier_boost_tree     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_fourier_nzv_boost_tree <tibble [1 × 4]> <opts[0]> <list [0]>
```
