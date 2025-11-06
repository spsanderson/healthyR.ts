# Recipes Time Series velocity Generator

`step_ts_velocity` creates a a *specification* of a recipe step that
will convert numeric data into from a time series into its velocity.

## Usage

``` r
step_ts_velocity(
  recipe,
  ...,
  role = "predictor",
  trained = FALSE,
  columns = NULL,
  skip = FALSE,
  id = rand_id("ts_velocity")
)
```

## Arguments

- recipe:

  A recipe object. The step will be added to the sequence of operations
  for this recipe.

- ...:

  One or more selector functions to choose which variables that will be
  used to create the new variables. The selected variables should have
  class `numeric`

- role:

  For model terms created by this step, what analysis role should they
  be assigned?. By default, the function assumes that the new variable
  columns created by the original variables will be used as predictors
  in a model.

- trained:

  A logical to indicate if the quantities for preprocessing have been
  estimated.

- columns:

  A character string of variables that will be used as inputs. This
  field is a placeholder and will be populated once
  [`recipes::prep()`](https://recipes.tidymodels.org/reference/prep.html)
  is used.

- skip:

  A logical. Should the step be skipped when the recipe is baked by
  bake.recipe()? While all operations are baked when prep.recipe() is
  run, some operations may not be able to be conducted on new data (e.g.
  processing the outcome variable(s)). Care should be taken when using
  skip = TRUE as it may affect the computations for subsequent
  operations.

- id:

  A character string that is unique to this step to identify it.

## Value

For `step_ts_velocity`, an updated version of recipe with the new step
added to the sequence of existing steps (if any).

Main Recipe Functions:

- [`recipes::recipe()`](https://recipes.tidymodels.org/reference/recipe.html)

- [`recipes::prep()`](https://recipes.tidymodels.org/reference/prep.html)

- [`recipes::bake()`](https://recipes.tidymodels.org/reference/bake.html)

## Details

**Numeric Variables** Unlike other steps, `step_ts_velocity` does *not*
remove the original numeric variables.
[`recipes::step_rm()`](https://recipes.tidymodels.org/reference/step_rm.html)
can be used for this purpose.

## See also

Other Recipes:
[`step_ts_acceleration()`](https://www.spsanderson.com/healthyR.ts/reference/step_ts_acceleration.md)

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(recipes))

len_out    = 10
by_unit    = "month"
start_date = as.Date("2021-01-01")

data_tbl <- tibble(
  date_col = seq.Date(from = start_date, length.out = len_out, by = by_unit),
  a    = rnorm(len_out),
  b    = runif(len_out)
)

# Create a recipe object
rec_obj <- recipe(a ~ ., data = data_tbl) %>%
  step_ts_velocity(b)

# View the recipe object
rec_obj
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 2
#> 
#> ── Operations 
#> • Time Series Velocity transformation on: <none>

# Prepare the recipe object
prep(rec_obj)
#> 
#> ── Recipe ──────────────────────────────────────────────────────────────────────
#> 
#> ── Inputs 
#> Number of variables by role
#> outcome:   1
#> predictor: 2
#> 
#> ── Training information 
#> Training data contained 10 data points and no incomplete rows.
#> 
#> ── Operations 
#> • Time Series Velocity transformation on: ~b | Trained

# Bake the recipe object - Adds the Time Series Signature
bake(prep(rec_obj), data_tbl)
#> # A tibble: 10 × 4
#>    date_col        b       a velocity_b
#>    <date>      <dbl>   <dbl>      <dbl>
#>  1 2021-01-01 0.0281 -0.936     NA     
#>  2 2021-02-01 0.466  -0.0160     0.438 
#>  3 2021-03-01 0.390  -0.827     -0.0760
#>  4 2021-04-01 0.0201 -1.51      -0.370 
#>  5 2021-05-01 0.377   0.935      0.357 
#>  6 2021-06-01 0.560   0.176      0.183 
#>  7 2021-07-01 0.857   0.244      0.297 
#>  8 2021-08-01 0.385   1.62      -0.472 
#>  9 2021-09-01 0.528   0.112      0.143 
#> 10 2021-10-01 0.601  -0.134      0.0727

rec_obj %>% prep() %>% juice()
#> # A tibble: 10 × 4
#>    date_col        b       a velocity_b
#>    <date>      <dbl>   <dbl>      <dbl>
#>  1 2021-01-01 0.0281 -0.936     NA     
#>  2 2021-02-01 0.466  -0.0160     0.438 
#>  3 2021-03-01 0.390  -0.827     -0.0760
#>  4 2021-04-01 0.0201 -1.51      -0.370 
#>  5 2021-05-01 0.377   0.935      0.357 
#>  6 2021-06-01 0.560   0.176      0.183 
#>  7 2021-07-01 0.857   0.244      0.297 
#>  8 2021-08-01 0.385   1.62      -0.472 
#>  9 2021-09-01 0.528   0.112      0.143 
#> 10 2021-10-01 0.601  -0.134      0.0727
```
