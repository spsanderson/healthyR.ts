# Visualization Functions

Comprehensive guide to plotting and visualization functions in healthyR.ts.

## Overview

healthyR.ts provides a rich suite of visualization functions for time series exploration, diagnostics, and presentation. All plotting functions return either:
- **ggplot2 objects** - Static, customizable plots
- **plotly objects** - Interactive plots (when `.interactive = TRUE`)

## Calendar Heatmaps

### `ts_calendar_heatmap_plot()`

Visualize temporal patterns using a calendar layout.

**Usage:**
```r
ts_calendar_heatmap_plot(
  .data,
  .date_col,
  .value_col,
  .low = "red",
  .high = "green",
  .plt_title = "",
  .interactive = FALSE
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.date_col` - Date column (unquoted)
- `.value_col` - Value column (unquoted)
- `.low` - Color for low values (default: "red")
- `.high` - Color for high values (default: "green")
- `.plt_title` - Plot title
- `.interactive` - Return plotly object if TRUE

**Example:**
```r
library(healthyR.ts)

# Create sample data
data_tbl <- data.frame(
  date_col = seq.Date(
    from = as.Date("2020-01-01"),
    to = as.Date("2022-12-31"),
    by = "day"
  ),
  value = rnorm(1096, mean = 100, sd = 15)
)

# Static plot
ts_calendar_heatmap_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value,
  .low = "blue",
  .high = "orange",
  .plt_title = "Daily Metrics 2020-2022"
)

# Interactive plot
ts_calendar_heatmap_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value,
  .interactive = TRUE
)
```

**Use Cases:**
- Identify day-of-week patterns
- Spot seasonal trends
- Detect anomalous dates
- Visualize year-over-year comparisons
- Communicate temporal patterns to stakeholders

## Moving Average Plots

### `ts_ma_plot()`

Visualize moving averages with different window sizes.

**Usage:**
```r
ts_ma_plot(
  .data,
  .date_col,
  .value_col,
  .ts_frequency,
  .main_title = NULL,
  .interactive = FALSE
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.date_col` - Date column
- `.value_col` - Value column
- `.ts_frequency` - Time series frequency (e.g., 12 for monthly, 7 for daily)
- `.main_title` - Plot title
- `.interactive` - Return plotly if TRUE

**Example:**
```r
library(dplyr)

# Convert AirPassengers
data <- ts_to_tbl(AirPassengers) %>%
  select(-index)

# Create MA plot
ts_ma_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .ts_frequency = 12,  # Monthly data
  .main_title = "AirPassengers with Moving Averages"
)
```

**What It Shows:**
- Original time series
- Multiple moving average lines
- Helps identify trends and smooth noise

### `ts_sma_plot()`

Simple moving average plot.

**Usage:**
```r
ts_sma_plot(
  .data,
  .date_col,
  .value_col,
  .sma_order = 4,
  .func = mean
)
```

**Example:**
```r
data %>%
  ts_sma_plot(
    .date_col = date_col,
    .value_col = value,
    .sma_order = 7,    # 7-day moving average
    .func = mean
  )
```

## Velocity, Value, and Acceleration

### `ts_vva_plot()`

Visualize value, velocity (rate of change), and acceleration (second derivative).

**Usage:**
```r
ts_vva_plot(
  .data,
  .date_col,
  .value_col,
  .interactive = FALSE
)
```

**Example:**
```r
# Using AirPassengers
data <- ts_to_tbl(AirPassengers) %>% select(-index)

ts_vva_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .interactive = FALSE
)
```

**What It Shows:**
Three panels:
1. **Top**: Original values (cumulative sum)
2. **Middle**: Velocity (first difference) - rate of change
3. **Bottom**: Acceleration (second difference) - change in rate of change

**Use Cases:**
- Understand momentum in time series
- Identify acceleration/deceleration points
- Detect trend changes
- Analyze growth dynamics

## Diagnostic Plots

### `ts_qq_plot()`

QQ plot to assess normality of residuals or values.

**Usage:**
```r
ts_qq_plot(
  .data,
  .date_col,
  .value_col,
  .interactive = FALSE,
  .alpha = 0.5,
  .color = "steelblue"
)
```

**Example:**
```r
# Check if data is normally distributed
ts_qq_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .color = "darkred",
  .alpha = 0.7
)
```

**Interpretation:**
- Points on diagonal line = Normal distribution
- Deviation from line = Non-normality
- Curved pattern = Skewness
- S-shaped pattern = Heavy/light tails

### `ts_scedacity_scatter_plot()`

Scedasticity plot to check for heteroscedasticity.

**Usage:**
```r
ts_scedacity_scatter_plot(
  .data,
  .date_col,
  .value_col,
  .interactive = FALSE
)
```

**Example:**
```r
ts_scedacity_scatter_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value
)
```

**What It Shows:**
- Fitted values vs. residuals
- Helps identify:
  - Heteroscedasticity (non-constant variance)
  - Non-linear patterns
  - Outliers

**Ideal Pattern:**
- Random scatter around zero
- Constant spread across x-axis

## Time Series Splits

### `ts_splits_plot()`

Visualize train/test splits for time series cross-validation.

**Usage:**
```r
ts_splits_plot(
  .data,
  .splits,
  .date_col
)
```

**Example:**
```r
library(timetk)

# Create splits
splits <- time_series_cv(
  data = data,
  date_var = date_col,
  assess = 12,
  skip = 3,
  slice_limit = 6,
  cumulative = TRUE
)

# Visualize
ts_splits_plot(
  .data = data,
  .splits = splits,
  .date_col = date_col
)
```

**What It Shows:**
- Training data (blue)
- Testing data (red)
- Multiple CV folds
- Temporal structure of splits

**Use Cases:**
- Verify CV setup
- Understand data splitting
- Ensure no data leakage
- Communicate validation strategy

## Event Analysis

### `ts_event_analysis_plot()`

Visualize time series behavior around events.

**Usage:**
```r
ts_event_analysis_plot(
  .data,
  .plot_type = "mean",
  .plot_ci = TRUE,
  .interactive = FALSE
)
```

**Parameters:**
- `.data` - Output from `ts_time_event_analysis_tbl()`
- `.plot_type` - "mean" (aggregate) or "individual" (separate lines)
- `.plot_ci` - Show confidence intervals
- `.interactive` - Interactive plotly plot

**Example:**
```r
# Perform event analysis
df <- ts_to_tbl(AirPassengers) %>% select(-index)

event_data <- ts_time_event_analysis_tbl(
  .data = df,
  .horizon = 6,
  .date_col = date_col,
  .value_col = value,
  .direction = "both"
)

# Mean plot with CI
event_data %>%
  ts_event_analysis_plot(
    .plot_type = "mean",
    .plot_ci = TRUE
  )

# Individual event plots
event_data %>%
  ts_event_analysis_plot(
    .plot_type = "individual"
  )
```

**What It Shows:**
- Value behavior before/after events
- Average pattern across all events
- Confidence intervals
- Individual event trajectories (if `.plot_type = "individual"`)

**Use Cases:**
- Analyze policy impact
- Study intervention effects
- Understand event-driven patterns
- Before/after comparisons

## Clustering

### `ts_feature_cluster_plot()`

Visualize time series clusters.

**Usage:**
```r
ts_feature_cluster_plot(
  .data,
  .date_col,
  .value_col,
  .center,
  ...
)
```

**Parameters:**
- `.data` - Output from `ts_feature_cluster()`
- `.date_col` - Date column
- `.value_col` - Value column
- `.center` - Which cluster to plot (numeric)
- `...` - Grouping variables

**Example:**
```r
# Cluster time series
data_grouped <- ts_to_tbl(AirPassengers) %>%
  mutate(group_id = rep(1:12, 12))

clusters <- ts_feature_cluster(
  .data = data_grouped,
  .date_col = date_col,
  .value_col = value,
  group_id,
  .features = c("acf_features", "entropy"),
  .scale = TRUE,
  .centers = 3
)

# Plot cluster 1
ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 1,
  group_id
)

# Plot cluster 2
ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 2,
  group_id
)
```

**What It Shows:**
- All time series in a specific cluster
- Helps understand cluster characteristics
- Identify similar patterns

## Brownian Motion

### `ts_brownian_motion_plot()`

Visualize Brownian motion simulations.

**Usage:**
```r
ts_brownian_motion_plot(
  .data,
  .date_col,
  .value_col,
  .interactive = FALSE
)
```

**Example:**
```r
# Generate Brownian motion
bm <- ts_brownian_motion(
  .num_sims = 50,
  .time = 100
)

# Plot
ts_brownian_motion_plot(
  .data = bm,
  .date_col = t,
  .value_col = y,
  .interactive = TRUE
)
```

## Helper Functions

### `ts_random_walk_ggplot_layers()`

Add standard layers to random walk plots.

**Usage:**
```r
# First create base plot
p <- data %>%
  ggplot(aes(x = x, y = cum_y, group = run, color = factor(run))) +
  geom_line()

# Add layers
p + ts_random_walk_ggplot_layers(data)
```

**What It Adds:**
- Theme
- Title formatting
- Legend adjustments
- Axis labels

## Color Scales

### `ts_scale_color_colorblind()` / `ts_scale_fill_colorblind()`

Color-blind friendly color scales.

**Usage:**
```r
library(ggplot2)

# Using color scale
data %>%
  ggplot(aes(x = date, y = value, color = group)) +
  geom_line() +
  ts_scale_color_colorblind()

# Using fill scale
data %>%
  ggplot(aes(x = date, y = value, fill = group)) +
  geom_col() +
  ts_scale_fill_colorblind()
```

### `color_blind()`

Access the color-blind palette directly.

```r
colors <- color_blind()
colors
#>  [1] "#000000" "#E69F00" "#56B4E9" "#009E73" ...
```

## Model Calibration Plots

All `ts_auto_*()` functions return calibration plots automatically:

```r
model <- ts_auto_arima(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .
)

# View calibration plot
model$calibration_plot
```

**What It Shows:**
- Actual vs. fitted values
- Forecast vs. actual (on test set)
- Model performance visualization

## Customization

### Modifying ggplot2 Objects

All static plots return ggplot2 objects that can be customized:

```r
# Create base plot
p <- ts_calendar_heatmap_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value
)

# Customize
library(ggplot2)

p +
  labs(
    title = "My Custom Title",
    subtitle = "Additional context",
    caption = "Data source: Hospital records"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    legend.position = "bottom"
  )
```

### Saving Plots

**Static plots:**
```r
p <- ts_vva_plot(data, date_col, value)

# Save with ggsave
ggsave("my_plot.png", p, width = 10, height = 6, dpi = 300)
ggsave("my_plot.pdf", p, width = 10, height = 6)
```

**Interactive plots:**
```r
library(plotly)

p <- ts_calendar_heatmap_plot(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .interactive = TRUE
)

# Save as HTML
htmlwidgets::saveWidget(p, "my_plot.html")
```

## Best Practices

### 1. Choose Appropriate Plot Type

```r
# For patterns over time → line plots (ts_ma_plot, ts_sma_plot)
# For distribution → qq plots (ts_qq_plot)
# For variance → scedasticity plots
# For calendar patterns → heatmaps
# For event impact → event analysis plots
# For momentum → VVA plots
```

### 2. Use Interactive Plots for Exploration

```r
# Interactive allows:
# - Zooming
# - Hovering for values
# - Panning
# - Better exploration

ts_calendar_heatmap_plot(
  ...,
  .interactive = TRUE
)
```

### 3. Use Static Plots for Reports

```r
# Static plots are:
# - Easier to save
# - Better for PDFs
# - More customizable
# - Publication-ready

ts_vva_plot(
  ...,
  .interactive = FALSE
)
```

### 4. Always Check Diagnostics

```r
# Before modeling, check:
ts_qq_plot(data, date_col, value)  # Normality
ts_scedacity_scatter_plot(data, date_col, value)  # Variance
```

### 5. Use Color-Blind Friendly Palettes

```r
# Always use accessible colors
ggplot(...) +
  geom_line() +
  ts_scale_color_colorblind()
```

## Common Patterns

### Pattern 1: Comprehensive EDA

```r
library(patchwork)

# Multiple plots
p1 <- ts_calendar_heatmap_plot(data, date_col, value)
p2 <- ts_ma_plot(data, date_col, value, .ts_frequency = 12)
p3 <- ts_vva_plot(data, date_col, value)
p4 <- ts_qq_plot(data, date_col, value)

# Combine (requires patchwork)
(p1 | p2) / (p3 | p4)
```

### Pattern 2: Before/After Comparison

```r
# Split data
before <- data %>% filter(date_col < as.Date("2020-03-01"))
after <- data %>% filter(date_col >= as.Date("2020-03-01"))

# Compare
p1 <- ts_qq_plot(before, date_col, value) + ggtitle("Before")
p2 <- ts_qq_plot(after, date_col, value) + ggtitle("After")

library(patchwork)
p1 | p2
```

### Pattern 3: Multi-Model Comparison

```r
# Fit multiple models
models <- list(
  arima = ts_auto_arima(...),
  prophet = ts_auto_prophet_reg(...),
  xgboost = ts_auto_xgboost(...)
)

# View all calibration plots
lapply(models, function(m) m$calibration_plot)
```

## See Also

- [Data Generators](Data-Generators.md) - Generate data to visualize
- [Statistical Functions](Statistical-Functions.md) - Analyze patterns
- [Quick Start](Quick-Start.md) - Basic examples
- [FAQ](FAQ.md) - Common questions
