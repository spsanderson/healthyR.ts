# Time Series Moving Average Plot

This function will produce two plots. Both of these are moving average
plots. One of the plots is from
[`xts::plot.xts()`](https://rdrr.io/pkg/xts/man/plot.xts.html) and the
other a `ggplot2` plot. This is done so that the user can choose which
type is best for them. The plots are stacked so each graph is on top of
the other.

## Usage

``` r
ts_ma_plot(
  .data,
  .date_col,
  .value_col,
  .ts_frequency = "monthly",
  .main_title = NULL,
  .secondary_title = NULL,
  .tertiary_title = NULL
)
```

## Arguments

- .data:

  The data you want to visualize. This should be pre-processed and the
  aggregation should match the `.frequency` argument.

- .date_col:

  The data column from the `.data` argument.

- .value_col:

  The value column from the `.data` argument

- .ts_frequency:

  The frequency of the aggregation, quoted, ie. "monthly", anything else
  will default to weekly, so it is very important that the data passed
  to this function be in either a weekly or monthly aggregation.

- .main_title:

  The title of the main plot.

- .secondary_title:

  The title of the second plot.

- .tertiary_title:

  The title of the third plot.

## Value

A few time series data sets and two plots.

## Details

This function expects to take in a data.frame/tibble. It will return a
list object so it is a good idea to save the output to a variable and
extract from there.

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))

data_tbl <- ts_to_tbl(AirPassengers) %>%
  select(-index)

output <- ts_ma_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value
)
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Removed 11 rows containing missing values or values outside the scale range
#> (`geom_line()`).

output$pgrid

output$xts_plt

output$data_summary_tbl %>% head()
#> # A tibble: 6 × 5
#>   date_col   value  ma12 diff_a diff_b
#>   <date>     <dbl> <dbl>  <dbl>  <dbl>
#> 1 1949-01-01   112    NA   0         0
#> 2 1949-02-01   118    NA   5.36      0
#> 3 1949-03-01   132    NA  11.9       0
#> 4 1949-04-01   129    NA  -2.27      0
#> 5 1949-05-01   121    NA  -6.20      0
#> 6 1949-06-01   135    NA  11.6       0

output <- ts_ma_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value,
  .ts_frequency = "week"
)
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Non-numeric columns being dropped: date_col
#> Warning: 'tzone' attributes are inconsistent
#> Warning: Removed 51 rows containing missing values or values outside the scale range
#> (`geom_line()`).

output$pgrid

output$xts_plt

output$data_summary_tbl %>% head()
#> # A tibble: 6 × 5
#>   date_col   value  ma12 diff_a diff_b
#>   <date>     <dbl> <dbl>  <dbl>  <dbl>
#> 1 1949-01-01   112    NA   0         0
#> 2 1949-02-01   118    NA   5.36      0
#> 3 1949-03-01   132    NA  11.9       0
#> 4 1949-04-01   129    NA  -2.27      0
#> 5 1949-05-01   121    NA  -6.20      0
#> 6 1949-06-01   135    NA  11.6       0
```
