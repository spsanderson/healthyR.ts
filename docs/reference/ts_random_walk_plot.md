# Auto-Plot a Random Walk

Plot a random walk with side-by-side facets showing both the random
variable and cumulative product (random walk path).

## Usage

``` r
ts_random_walk_plot(.data, .interactive = FALSE)
```

## Arguments

- .data:

  The data from
  [`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)
  function.

- .interactive:

  The default is FALSE, TRUE will produce an interactive plotly plot.

## Value

A ggplot2 object or an interactive `plotly` plot

## Details

This function will take output from the
[`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)
function and create a side-by-side faceted plot. The left panel shows
the random variable (y) over time, and the right panel shows the
cumulative product (cum_y, i.e., the random walk path) over time. Each
simulation run is shown as a separate line. The legend is set to "none"
if the simulation count is higher than 9.

## See also

Other Plot:
[`ts_brownian_motion_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_plot.md),
[`ts_event_analysis_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_event_analysis_plot.md),
[`ts_qq_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_qq_plot.md),
[`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md)

## Author

Steven P. Sanderson II, MPH

## Examples

``` r
df <- ts_random_walk(
  .mean = 0,
  .sd = 1,
  .num_walks = 25,
  .periods = 180,
  .initial_value = 100
)

ts_random_walk_plot(df)

```
