# Extract Boilerplate Items

Extract the fitted workflow from a `ts_auto_` function.

## Usage

``` r
ts_extract_auto_fitted_workflow(.input)
```

## Arguments

- .input:

  This is the output list object of a `ts_auto_` function.

## Value

A fitted `workflow` object.

## Details

Extract the fitted workflow from a `ts_auto_` function. This will only
work on those functions that are designated as *Boilerplate*.

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
if (FALSE) { # \dontrun{
library(dplyr)

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

ts_lm <- ts_auto_lm(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
)

ts_extract_auto_fitted_workflow(ts_lm)
} # }
```
