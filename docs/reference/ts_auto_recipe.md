# Build a Time Series Recipe

Automatically builds generic time series recipe objects from a given
tibble.

## Usage

``` r
ts_auto_recipe(
  .data,
  .date_col,
  .pred_col,
  .step_ts_sig = TRUE,
  .step_ts_rm_misc = TRUE,
  .step_ts_dummy = TRUE,
  .step_ts_fourier = TRUE,
  .step_ts_fourier_period = 365/12,
  .K = 1,
  .step_ts_yeo = TRUE,
  .step_ts_nzv = TRUE
)
```

## Arguments

- .data:

  The data that is going to be modeled. You must supply a tibble.

- .date_col:

  The column that holds the date for the time series.

- .pred_col:

  The column that is to be predicted.

- .step_ts_sig:

  A Boolean indicating should the
  [`timetk::step_timeseries_signature()`](https://business-science.github.io/timetk/reference/step_timeseries_signature.html)
  be added, default is TRUE.

- .step_ts_rm_misc:

  A Boolean indicating should the following items be removed from the
  time series signature, default is TRUE.

  - iso\$

  - xts\$

  - hour

  - min

  - sec

  - am.pm

- .step_ts_dummy:

  A Boolean indicating if all_nominal_predictors() should be dummied and
  with one hot encoding.

- .step_ts_fourier:

  A Boolean indicating if
  [`timetk::step_fourier()`](https://business-science.github.io/timetk/reference/step_fourier.html)
  should be added to the recipe.

- .step_ts_fourier_period:

  A number such as 365/12, 365/4 or 365 indicting the period of the
  fourier term. The numeric period for the oscillation frequency.

- .K:

  The number of orders to include for each sine/cosine fourier series.
  More orders increase the number of fourier terms and therefore the
  variance of the fitted model at the expense of bias. See details for
  examples of K specification.

- .step_ts_yeo:

  A Boolean indicating if the
  [`recipes::step_YeoJohnson()`](https://recipes.tidymodels.org/reference/step_YeoJohnson.html)
  should be added to the recipe.

- .step_ts_nzv:

  A Boolean indicating if the
  [`recipes::step_nzv()`](https://recipes.tidymodels.org/reference/step_nzv.html)
  should be run on all predictors.

## Details

This will build out a couple of generic recipe objects and return those
items in a list.

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(rsample))

data_tbl <- ts_to_tbl(AirPassengers) %>%
  select(-index)

splits <- initial_time_split(
 data_tbl
 , prop = 0.8
)

ts_auto_recipe(
    .data = data_tbl
    , .date_col = date_col
    , .pred_col = value
)
#> $rec_base
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> $rec_date
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> 
#> $rec_date_fourier
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> • Fourier series features from: ds
#> • Yeo-Johnson transformation on: value
#> 
#> $rec_date_fourier_nzv
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> • Fourier series features from: ds
#> • Yeo-Johnson transformation on: value
#> • Sparse, unbalanced variable filter on: recipes::all_predictors()
#> 

ts_auto_recipe(
  .data = training(splits)
  , .date_col = date_col
  , .pred_col = value
)
#> $rec_base
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> $rec_date
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> 
#> $rec_date_fourier
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> • Fourier series features from: ds
#> • Yeo-Johnson transformation on: value
#> 
#> $rec_date_fourier_nzv
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 1
#> 
#> ── Operations 
#> • Timeseries signature features from: ds
#> • Centering and scaling for: dplyr::contains("index.num"), ...
#> • Variables removed: dplyr::matches("(iso$)|(xts$)|(hour)|(min)|(sec)|(am.pm)")
#> • Dummy variables from: recipes::all_nominal_predictors()
#> • Fourier series features from: ds
#> • Yeo-Johnson transformation on: value
#> • Sparse, unbalanced variable filter on: recipes::all_predictors()
#> 
```
