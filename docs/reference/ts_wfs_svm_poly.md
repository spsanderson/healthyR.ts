# Auto SVM Poly (Kernlab) Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_svm_poly(
  .model_type = "kernlab",
  .recipe_list,
  .cost = 1,
  .degree = 1,
  .scale_factor = 1,
  .margin = 0.1
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`parsnip::svm_poly()`](https://parsnip.tidymodels.org/reference/svm_poly.html)
  under the hood and can take one of the following:

  - "kernlab"

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .cost:

  A positive number for the cose of predicting a sample within or on the
  wrong side of the margin.

- .degree:

  A positive number for polynomial degree.

- .scale_factor:

  A positive number for the polynomial scaling factor.

- .margin:

  A positive number for the epsilon in the SVM insensitive loss function
  (regression only.)

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This only uses the option `set_engine("kernlab")` and therefore the
.model_type is not needed. The parameter is kept because it is possible
in the future that this could change, and it keeps with the framework of
how other functions are written.

[`parsnip::svm_poly()`](https://parsnip.tidymodels.org/reference/svm_poly.html)
svm_poly() defines a support vector machine model. For classification,
the model tries to maximize the width of the margin between classes. For
regression, the model optimizes a robust loss function that is only
affected by very large model residuals.

This SVM model uses a nonlinear function, specifically a polynomial
function, to create the decision boundary or regression line.

## See also

<https://workflowsets.tidymodels.org/>

<https://parsnip.tidymodels.org/reference/svm_poly.html>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
[`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md),
[`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
[`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
[`ts_wfs_nnetar_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_nnetar_reg.md),
[`ts_wfs_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_prophet_reg.md),
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

wf_sets <- ts_wfs_svm_poly("kernlab", rec_objs)
wf_sets
#> # A workflow set/tibble: 4 × 4
#>   wflow_id                      info             option    result    
#>   <chr>                         <list>           <list>    <list>    
#> 1 rec_base_svm_poly             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 2 rec_date_svm_poly             <tibble [1 × 4]> <opts[0]> <list [0]>
#> 3 rec_date_fourier_svm_poly     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 4 rec_date_fourier_nzv_svm_poly <tibble [1 × 4]> <opts[0]> <list [0]>
```
