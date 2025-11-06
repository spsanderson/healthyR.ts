# Auto Arima (Forecast auto_arima) Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_auto_arima(.model_type = "auto_arima", .recipe_list)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`modeltime::arima_reg()`](https://business-science.github.io/modeltime/reference/arima_reg.html)
  under the hood and can take one of the following:

  - "auto_arima"

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This only uses the option `set_engine("auto_arima")` and therefore the
.model_type is not needed. The parameter is kept because it is possible
in the future that this could change, and it keeps with the framework of
how other functions are written.

[`modeltime::arima_reg()`](https://business-science.github.io/modeltime/reference/arima_reg.html)
arima_reg() is a way to generate a specification of an ARIMA model
before fitting and allows the model to be created using different
packages. Currently the only package is `forecast`.

## See also

<https://workflowsets.tidymodels.org/>

<https://business-science.github.io/modeltime/reference/arima_reg.html>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
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

wf_sets <- ts_wfs_auto_arima("auto_arima", rec_objs)
wf_sets
#> # A workflow set/tibble: 4 × 4
#>   wflow_id                       info             option    result    
#>   <chr>                          <list>           <list>    <list>    
#> 1 rec_base_arima_reg             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_date_arima_reg             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_fourier_arima_reg     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_fourier_nzv_arima_reg <tibble [1 × 4]> <opts[0]> <list [0]>
```
