# Auto PROPHET Regression Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_prophet_reg(
  .model_type = "all_engines",
  .recipe_list,
  .growth = NULL,
  .changepoint_num = 25,
  .changepoint_range = 0.8,
  .seasonality_yearly = "auto",
  .seasonality_weekly = "auto",
  .seasonality_daily = "auto",
  .season = "additive",
  .prior_scale_changepoints = 25,
  .prior_scale_seasonality = 1,
  .prior_scale_holidays = 1,
  .logistic_cap = NULL,
  .logistic_floor = NULL,
  .trees = 50,
  .min_n = 10,
  .tree_depth = 5,
  .learn_rate = 0.01,
  .loss_reduction = NULL,
  .stop_iter = NULL
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`modeltime::prophet_reg()`](https://business-science.github.io/modeltime/reference/prophet_reg.html)
  under the hood and can take one of the following:

  - "prophet" Or
    [`modeltime::prophet_boost()`](https://business-science.github.io/modeltime/reference/prophet_boost.html)
    under the hood and can take one of the following:

  - "prophet_xgboost" You can also choose:

  - "all_engines" - This will make a model spec for all available
    engines.

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .growth:

  String 'linear' or 'logistic' to specify a linear or logistic trend.

- .changepoint_num:

  Number of potential changepoints to include for modeling trend.

- .changepoint_range:

  Adjusts the flexibility of the trend component by limiting to a
  percentage of data before the end of the time series. 0.80 means that
  a changepoint cannot exist after the first 80% of the data.

- .seasonality_yearly:

  One of "auto", TRUE or FALSE. Set to FALSE for `prophet_xgboost`.
  Toggles on/off a seasonal component that models year-over-year
  seasonality.

- .seasonality_weekly:

  One of "auto", TRUE or FALSE. Toggles on/off a seasonal component that
  models week-over-week seasonality. Set to FALSE for `prophet_xgboost`

- .seasonality_daily:

  One of "auto", TRUE or FALSE. Toggles on/off a seasonal componet that
  models day-over-day seasonality. Set to FALSE for `prophet_xgboost`

- .season:

  'additive' (default) or 'multiplicative'.

- .prior_scale_changepoints:

  Parameter modulating the flexibility of the automatic changepoint
  selection. Large values will allow many changepoints, small values
  will allow few changepoints.

- .prior_scale_seasonality:

  Parameter modulating the strength of the seasonality model. Larger
  values allow the model to fit larger seasonal fluctuations, smaller
  values dampen the seasonality.

- .prior_scale_holidays:

  Parameter modulating the strength of the holiday components model,
  unless overridden in the holidays input.

- .logistic_cap:

  When growth is logistic, the upper-bound for "saturation".

- .logistic_floor:

  When growth is logistic, the lower-bound for "saturation"

- .trees:

  An integer for the number of trees contained in the ensemble.

- .min_n:

  An integer for the minimum number of data points in a node that is
  required for the node to be split further.

- .tree_depth:

  An integer for the maximum depth of the tree (i.e. number of splits)
  (specific engines only).

- .learn_rate:

  A number for the rate at which the boosting algorithm adapts from
  iteration-to-iteration (specific engines only).

- .loss_reduction:

  A number for the reduction in the loss function required to split
  further (specific engines only).

- .stop_iter:

  The number of iterations without improvement before stopping (xgboost
  only).

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the `prophet` and `prophet_xgboost` model
specification, but if you choose you can set them yourself if you have a
good understanding of what they should be.

## See also

<https://workflowsets.tidymodels.org/>(workflowsets)

<https://business-science.github.io/modeltime/reference/prophet_reg.html>

<https://business-science.github.io/modeltime/reference/prophet_boost.html>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
[`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
[`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
[`ts_wfs_nnetar_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_nnetar_reg.md),
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

wf_sets <- ts_wfs_prophet_reg("all_engines", rec_objs)
wf_sets
#> # A workflow set/tibble: 8 × 4
#>   wflow_id                           info             option    result    
#>   <chr>                              <list>           <list>    <list>    
#> 1 rec_base_prophet_reg               <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_base_prophet_boost             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_prophet_reg               <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_prophet_boost             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 5 rec_date_fourier_prophet_reg       <tibble [1 × 4]> <opts[0]> <list [0]>
#> 6 rec_date_fourier_prophet_boost     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 7 rec_date_fourier_nzv_prophet_reg   <tibble [1 × 4]> <opts[0]> <list [0]>
#> 8 rec_date_fourier_nzv_prophet_boost <tibble [1 × 4]> <opts[0]> <list [0]>
```
