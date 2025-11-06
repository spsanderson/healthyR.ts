# Auto ETS Workflowset Function

This function is used to quickly create a workflowsets object.

## Usage

``` r
ts_wfs_ets_reg(
  .model_type = "all_engines",
  .recipe_list,
  .seasonal_period = "auto",
  .error = "auto",
  .trend = "auto",
  .season = "auto",
  .damping = "auto",
  .smooth_level = 0.1,
  .smooth_trend = 0.1,
  .smooth_seasonal = 0.1
)
```

## Arguments

- .model_type:

  This is where you will set your engine. It uses
  [`modeltime::exp_smoothing()`](https://business-science.github.io/modeltime/reference/exp_smoothing.html)
  under the hood and can take one of the following:

  - "ets"

  - "croston"

  - "theta"

  - "smooth_es"

  - "all_engines" - This will make a model spec for all available
    engines.

- .recipe_list:

  You must supply a list of recipes. list(rec_1, rec_2, ...)

- .seasonal_period:

  A seasonal frequency. Uses "auto" by default. A character phrase of
  "auto" or time-based phrase of "2 weeks" can be used if a date or
  date-time variable is provided. See Fit Details below.

- .error:

  The form of the error term: "auto", "additive", or "multiplicative".
  If the error is multiplicative, the data must be non-negative.

- .trend:

  The form of the trend term: "auto", "additive", "multiplicative" or0
  "none".

- .season:

  The form of the seasonal term: "auto", "additive", "multiplicative" or
  "none".

- .damping:

  Apply damping to a trend: "auto", "damped", or "none".

- .smooth_level:

  This is often called the "alpha" parameter used as the base level
  smoothing factor for exponential smoothing models.

- .smooth_trend:

  This is often called the "beta" parameter used as the trend smoothing
  factor for exponential smoothing models.

- .smooth_seasonal:

  This is often called the "gamma" parameter used as the seasonal
  smoothing factor for exponential smoothing models.

## Value

Returns a workflowsets object.

## Details

This function expects to take in the recipes that you want to use in the
modeling process. This is an automated workflow process. There are
sensible defaults set for the model specification, but if you choose you
can set them yourself if you have a good understanding of what they
should be. The mode is set to "regression".

This uses the following engines:

[`modeltime::exp_smoothing()`](https://business-science.github.io/modeltime/reference/exp_smoothing.html)
exp_smoothing() is a way to generate a specification of an Exponential
Smoothing model before fitting and allows the model to be created using
different packages. Currently the only package is forecast. Several
algorithms are implemented:

- "ets"

- "croston"

- "theta"

- "smooth_es

## See also

<https://workflowsets.tidymodels.org/>

<https://business-science.github.io/modeltime/reference/exp_smoothing.html>

Other Auto Workflowsets:
[`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md),
[`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md),
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

wf_sets <- ts_wfs_ets_reg("all_engines", rec_objs)
wf_sets
#> # A workflow set/tibble: 16 × 4
#>    wflow_id                             info             option    result    
#>    <chr>                                <list>           <list>    <list>    
#>  1 rec_base_exp_smoothing_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  2 rec_base_exp_smoothing_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  3 rec_base_exp_smoothing_3             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  4 rec_base_exp_smoothing_4             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  5 rec_date_exp_smoothing_1             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  6 rec_date_exp_smoothing_2             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  7 rec_date_exp_smoothing_3             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  8 rec_date_exp_smoothing_4             <tibble [1 × 4]> <opts[0]> <list [0]>
#>  9 rec_date_fourier_exp_smoothing_1     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 10 rec_date_fourier_exp_smoothing_2     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 11 rec_date_fourier_exp_smoothing_3     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 12 rec_date_fourier_exp_smoothing_4     <tibble [1 × 4]> <opts[0]> <list [0]>
#> 13 rec_date_fourier_nzv_exp_smoothing_1 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 14 rec_date_fourier_nzv_exp_smoothing_2 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 15 rec_date_fourier_nzv_exp_smoothing_3 <tibble [1 × 4]> <opts[0]> <list [0]>
#> 16 rec_date_fourier_nzv_exp_smoothing_4 <tibble [1 × 4]> <opts[0]> <list [0]>
```
