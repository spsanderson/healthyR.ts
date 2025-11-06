# Auto Linear Regression Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_lin_reg(.model_type, .recipe_list, .penalty = 1, .mixture = 0.5)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`parsnip::linear_reg()`](https://parsnip.tidymodels.org/reference/linear_reg.html)
  under the hood and can take one of the following:

  - "lm"

  - "glmnet"

  - "all_engines" - This will make a model spec for all available
    engines.

  Not yet implemented are:

  - "stan"

  - "spark"

  - "keras"

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .penalty:

  The penalty parameter of the glmnet. The default is 1

- .mixture:

  The mixture parameter of the glmnet. The default is 0.5

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the `glmnet` model specification, but if you
choose you can set them yourself if you have a good understanding of
what they should be.

## See also

<https://workflowsets.tidymodels.org/>(workflowsets)

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
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

wf_sets <- ts_wfs_lin_reg("all_engines", rec_objs)
wf_sets
#> # A workflow set/tibble: 8 × 4
#>   wflow_id                          info             option    result    
#>   <chr>                             <list>           <list>    <list>    
#> 1 rec_base_linear_reg_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_base_linear_reg_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_linear_reg_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_linear_reg_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 5 rec_date_fourier_linear_reg_1     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 6 rec_date_fourier_linear_reg_2     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 7 rec_date_fourier_nzv_linear_reg_1 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 8 rec_date_fourier_nzv_linear_reg_2 <tibble [1 × 4]> <opts[0]> <list [0]>
```
