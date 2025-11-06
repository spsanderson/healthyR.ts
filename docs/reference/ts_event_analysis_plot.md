# Time Series Event Analysis Plot

Plot out the data from the
[`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)
function.

## Usage

``` r
ts_event_analysis_plot(
  .data,
  .plot_type = "mean",
  .plot_ci = TRUE,
  .interactive = FALSE
)
```

## Arguments

- .data:

  The data that comes from the
  [`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)

- .plot_type:

  The default is "mean" which will show the mean event change of the
  output from the analysis tibble. The possible values for this are:
  mean, median, and individual.

- .plot_ci:

  The default is TRUE. This will only work if you choose one of the
  aggregate plots of either "mean" or "median"

- .interactive:

  The default is FALSE. TRUE will return a plotly plot.

## Value

A ggplot2 object

## Details

This function will take in data strictly from the
[`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)
and plot out the data. You can choose what type of plot you want in the
parameter of `.plot_type`. This will give you a choice of "mean",
"median", and "individual".

You can also plot the upper and lower confidence intervals if you choose
one of the aggregate plots ("mean"/"median").

## See also

Other Plot:
[`ts_brownian_motion_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_plot.md),
[`ts_qq_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_qq_plot.md),
[`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
library(dplyr)
df <- ts_to_tbl(AirPassengers) %>% select(-index)

ts_time_event_analysis_tbl(
  .data = df,
  .horizon = 6,
  .date_col = date_col,
  .value_col = value,
  .direction = "both"
) %>%
  ts_event_analysis_plot()


ts_time_event_analysis_tbl(
  .data = df,
  .horizon = 6,
  .date_col = date_col,
  .value_col = value,
  .direction = "both"
) %>%
  ts_event_analysis_plot(.plot_type = "individual")

```
