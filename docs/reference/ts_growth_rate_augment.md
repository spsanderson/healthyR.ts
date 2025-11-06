# Augment Data with Time Series Growth Rates

This function is used to augment a data frame or tibble with time series
growth rates of selected columns. You can provide a data frame or tibble
as the first argument, the column(s) for which you want to calculate the
growth rates using the `.value` parameter, and optionally specify custom
names for the new columns using the `.names` parameter.

## Usage

``` r
ts_growth_rate_augment(.data, .value, .names = "auto")
```

## Arguments

- .data:

  A data frame or tibble containing the data to be augmented.

- .value:

  A quosure specifying the column(s) for which you want to calculate
  growth rates.

- .names:

  Optional. A character vector specifying the names of the new columns
  to be created. Use "auto" for automatic naming.

## Value

A tibble that includes the original data and additional columns
representing the growth rates of the selected columns. The column names
are either automatically generated or as specified in the `.names`
parameter.

## See also

Other Augment Function:
[`ts_acceleration_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_augment.md),
[`ts_velocity_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_augment.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
data <- data.frame(
  Year = 1:5,
  Income = c(100, 120, 150, 180, 200),
  Expenses = c(50, 60, 75, 90, 100)
)
ts_growth_rate_augment(data, .value = c(Income, Expenses))
#> # A tibble: 5 × 5
#>    Year Income Expenses growth_rate_Income growth_rate_Expenses
#>   <int>  <dbl>    <dbl>              <dbl>                <dbl>
#> 1     1    100       50               NA                   NA  
#> 2     2    120       60               20                   20  
#> 3     3    150       75               25                   25  
#> 4     4    180       90               20                   20  
#> 5     5    200      100               11.1                 11.1
```
