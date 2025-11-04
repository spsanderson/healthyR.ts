# Quick Start Guide

This guide will help you get started with **healthyR.ts** in minutes.

## Your First Time Series Analysis

### Load the Package

```r
library(healthyR.ts)
library(dplyr)
library(ggplot2)
```

### Example 1: Random Walk Simulation

Generate and visualize random walk data to understand market volatility or patient flow variations:

```r
# Generate random walk data
df <- ts_random_walk(
  .num_walks = 25,
  .periods = 100,
  .initial_value = 1000
)

# View the data
head(df)
#> # A tibble: 6 × 4
#>     run     x        y cum_y
#>   <dbl> <dbl>    <dbl> <dbl>
#> 1     1     1 0.0521   1052.
#> 2     1     2 0.000486 1053.
#> 3     1     3 0.0567   1112.
#> 4     1     4 0.125    1252.
#> 5     1     5 0.0825   1355.
#> 6     1     6 0.00340  1360.
```

Visualize the random walks:

```r
df %>%
  ggplot(aes(x = x, y = cum_y, color = factor(run), group = factor(run))) +
  geom_line(alpha = 0.8) +
  ts_random_walk_ggplot_layers(df)
```

For a clearer view of volatility range:

```r
df %>%
  group_by(x) %>%
  summarise(
    min_y = min(cum_y),
    max_y = max(cum_y)
  ) %>%
  ggplot(aes(x = x)) +
  geom_line(aes(y = max_y), color = "steelblue") +
  geom_line(aes(y = min_y), color = "firebrick") +
  geom_ribbon(aes(ymin = min_y, ymax = max_y), alpha = 0.2) +
  labs(
    title = "Random Walk Volatility Range",
    x = "Time Period",
    y = "Value"
  )
```

### Example 2: Calendar Heatmap

Visualize temporal patterns in your data:

```r
# Create sample data
data_tbl <- data.frame(
  date_col = seq.Date(
    from = as.Date("2020-01-01"),
    to = as.Date("2022-06-01"),
    length.out = 365*2 + 180
  ),
  value = rnorm(365*2 + 180, mean = 100, sd = 15)
)

# Create calendar heatmap
ts_calendar_heatmap_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value,
  .interactive = FALSE
)
```

### Example 3: Convert Time Series to Tibble

Work with built-in R time series objects:

```r
# Convert AirPassengers to tibble
air_tbl <- ts_to_tbl(AirPassengers)

head(air_tbl)
#> # A tibble: 6 × 3
#>   index date_col   value
#>   <int> <date>     <dbl>
#> 1     1 1949-01-01   112
#> 2     2 1949-02-01   118
#> 3     3 1949-03-01   132
#> 4     4 1949-04-01   129
#> 5     5 1949-05-01   121
#> 6     6 1949-06-01   135
```

### Example 4: Simple ARIMA Model

Create an automatic ARIMA model:

```r
library(timetk)
library(modeltime)

# Prepare data
data <- AirPassengers %>%
  ts_to_tbl() %>%
  select(-index)

# Create train/test splits
splits <- time_series_split(
  data,
  date_col,
  assess = 12,
  cumulative = TRUE
)

# Build automatic ARIMA model
ts_arima <- ts_auto_arima(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .tune = FALSE
)

# View calibration
ts_arima$calibration_tbl
```

## Common Workflows

### Workflow 1: Data Exploration

```r
# 1. Load your data
data <- read.csv("your_data.csv") %>%
  mutate(date = as.Date(date))

# 2. Visualize patterns
ts_calendar_heatmap_plot(
  .data = data,
  .date_col = date,
  .value_col = admissions
)

# 3. Check for trends
data %>%
  ggplot(aes(x = date, y = admissions)) +
  geom_line() +
  geom_smooth(method = "loess")

# 4. Compute basic statistics
ts_info_tbl(data, date, admissions)
```

### Workflow 2: Feature Engineering

```r
# Add velocity (rate of change)
data_augmented <- data %>%
  ts_velocity_augment(.value = admissions)

# Add acceleration
data_augmented <- data_augmented %>%
  ts_acceleration_augment(.value = admissions)

# Add growth rate
data_augmented <- data_augmented %>%
  ts_growth_rate_augment(.value = admissions)

# View results
head(data_augmented)
```

### Workflow 3: Time Series Clustering

```r
# Prepare data with groups
data_grouped <- ts_to_tbl(AirPassengers) %>%
  mutate(group_id = rep(1:12, 12))

# Perform clustering
clusters <- ts_feature_cluster(
  .data = data_grouped,
  .date_col = date_col,
  .value_col = value,
  group_id,
  .features = c("acf_features", "entropy"),
  .scale = TRUE,
  .centers = 3
)

# Visualize cluster
ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 1,
  group_id
)
```

### Workflow 4: Event Analysis

Analyze behavior around specific events:

```r
# Convert time series
df <- ts_to_tbl(AirPassengers) %>%
  select(-index)

# Analyze events
event_analysis <- ts_time_event_analysis_tbl(
  .data = df,
  .horizon = 6,
  .date_col = date_col,
  .value_col = value,
  .direction = "both"
)

# Visualize
event_analysis %>%
  ts_event_analysis_plot()

# Individual plots
event_analysis %>%
  ts_event_analysis_plot(.plot_type = "individual")
```

## Key Functions to Know

### Data Generation
- `ts_random_walk()` - Generate random walks
- `ts_brownian_motion()` - Standard Brownian motion
- `ts_geometric_brownian_motion()` - Geometric Brownian motion
- `ts_arima_simulator()` - ARIMA simulation

### Data Transformation
- `ts_to_tbl()` - Convert ts to tibble
- `ts_velocity_augment()` - Add velocity (rate of change)
- `ts_acceleration_augment()` - Add acceleration
- `ts_growth_rate_augment()` - Add growth rate

### Visualization
- `ts_calendar_heatmap_plot()` - Calendar heatmap
- `ts_vva_plot()` - Velocity, value, acceleration plot
- `ts_ma_plot()` - Moving average plot
- `ts_sma_plot()` - Simple moving average plot
- `ts_qq_plot()` - QQ plot for normality
- `ts_event_analysis_plot()` - Event analysis visualization

### Statistical Analysis
- `ts_adf_test()` - Augmented Dickey-Fuller test
- `tidy_fft()` - Fast Fourier Transform
- `ci_hi()` / `ci_lo()` - Confidence intervals
- `ts_lag_correlation()` - Lag correlation analysis

### Modeling (Boilerplate Functions)
- `ts_auto_arima()` - Automatic ARIMA
- `ts_auto_prophet_reg()` - Prophet model
- `ts_auto_xgboost()` - XGBoost for time series
- `ts_auto_nnetar()` - Neural network autoregression
- And 11 more! See [Forecasting Models](Forecasting-Models.md)

## Tips for Success

### 1. Always Check Your Data
```r
# Check for missing values
sum(is.na(data$value))

# Check date continuity
all(diff(data$date) == 1)  # For daily data

# Check for outliers
boxplot(data$value)
```

### 2. Start Simple
Begin with basic visualizations and statistics before jumping into complex models.

### 3. Use the Pipe
healthyR.ts is designed to work seamlessly with the pipe operator:

```r
data %>%
  ts_velocity_augment(.value = value) %>%
  ts_acceleration_augment(.value = value) %>%
  filter(!is.na(velocity))
```

### 4. Leverage Boilerplate Functions
The `ts_auto_*()` functions handle the entire modeling pipeline for you:

```r
# One function call for complete workflow
model <- ts_auto_arima(
  .data = data,
  .date_col = date,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .
)
```

## Next Steps

Now that you've completed the quick start:

1. **Explore More Examples**: Check out [Examples and Tutorials](Examples-Tutorials.md)
2. **Learn About Functions**: Browse the [Function References](Function-References.md)
3. **Dive Deeper**: Read about [Automated Modeling Workflows](Automated-Modeling-Workflows.md)
4. **Real-World Cases**: See [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting.md)

## Getting Help

- **Documentation**: Check function documentation with `?function_name`
- **Vignettes**: Run `browseVignettes("healthyR.ts")`
- **Issues**: Report bugs at [GitHub Issues](https://github.com/spsanderson/healthyR.ts/issues)
- **Questions**: Post on Stack Overflow with `r` and `healthyr-ts` tags

## Common Pitfalls to Avoid

1. **Not checking for stationarity** - Use `ts_adf_test()` before modeling
2. **Ignoring missing values** - Handle NAs before analysis
3. **Not using proper date formats** - Convert to Date or POSIXct
4. **Forgetting to set seeds** - Use `set.seed()` for reproducibility
5. **Not splitting train/test** - Always validate on held-out data

Happy forecasting! 📈
