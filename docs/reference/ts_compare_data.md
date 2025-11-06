# Compare data over time periods

Given a tibble/data.frame, you can get date from two different but
comparative date ranges. Lets say you want to compare visits in one year
to visits from 2 years before without also seeing the previous 1 year.
You can do that with this function.

## Usage

``` r
ts_compare_data(.data, .date_col, .start_date, .end_date, .periods_back)
```

## Arguments

- .data:

  The date.frame/tibble that holds the data

- .date_col:

  The column with the date value

- .start_date:

  The start of the period you want to analyze

- .end_date:

  The end of the period you want to analyze

- .periods_back:

  How long ago do you want to compare data too. Time units are collapsed
  using
  [`lubridate::floor_date()`](https://lubridate.tidyverse.org/reference/round_date.html).
  The value can be:

  - second

  - minute

  - hour

  - day

  - week

  - month

  - bimonth

  - quarter

  - season

  - halfyear

  - year

  Arbitrary unique English abbreviations as in the
  [`lubridate::period()`](https://lubridate.tidyverse.org/reference/period.html)
  constructor are allowed.

## Value

A tibble.

## Details

- Uses the
  [`timetk::filter_by_time()`](https://business-science.github.io/timetk/reference/filter_by_time.html)
  function in order to filter the date column.

- Uses the
  [`timetk::subtract_time()`](https://business-science.github.io/timetk/reference/time_arithmetic.html)
  function to subtract time from the start date.

## See also

Other Time_Filtering:
[`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(timetk))

data_tbl <- ts_to_tbl(AirPassengers) %>%
  select(-index)

ts_compare_data(
  .data           = data_tbl
  , .date_col     = date_col
  , .start_date   = "1955-01-01"
  , .end_date     = "1955-12-31"
  , .periods_back = "2 years"
  ) %>%
  summarise_by_time(
    .date_var = date_col
    , .by     = "year"
    , visits  = sum(value)
  )
#> # A tibble: 2 × 2
#>   date_col   visits
#>   <date>      <dbl>
#> 1 1953-01-01   2700
#> 2 1955-01-01   3408
```
