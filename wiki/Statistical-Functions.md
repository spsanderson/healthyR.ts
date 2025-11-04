# Statistical Functions

Comprehensive guide to statistical analysis and testing functions in healthyR.ts.

## Overview

healthyR.ts provides a suite of statistical functions for:
- Stationarity testing
- Time series transformations
- Frequency analysis
- Confidence intervals
- Correlation analysis
- Information extraction

## Stationarity Testing

### `ts_adf_test()`

Augmented Dickey-Fuller test for stationarity.

**Usage:**
```r
ts_adf_test(.data, .value)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.value` - Value column to test (unquoted)

**Returns:**
A list containing:
- `adf_stat` - Test statistic
- `p_value` - P-value
- `lags` - Number of lags used
- `stationary` - Boolean (TRUE if stationary at 5% level)

**Example:**
```r
library(healthyR.ts)

# Test AirPassengers for stationarity
data <- ts_to_tbl(AirPassengers) %>% select(-index)

# Test original data
result <- ts_adf_test(data, value)

result$stationary
#> [1] FALSE  # Non-stationary

result$p_value
#> [1] 0.99  # Fail to reject null (non-stationary)

# Test differenced data
data_diff <- data %>%
  mutate(value_diff = c(NA, diff(value))) %>%
  filter(!is.na(value_diff))

result_diff <- ts_adf_test(data_diff, value_diff)

result_diff$stationary
#> [1] TRUE  # Stationary after differencing
```

**Interpretation:**
- **H₀ (Null Hypothesis)**: Series has a unit root (non-stationary)
- **H₁ (Alternative)**: Series is stationary
- **p-value < 0.05**: Reject H₀, series is stationary
- **p-value ≥ 0.05**: Fail to reject H₀, series is non-stationary

**When to Use:**
- Before fitting ARIMA models
- To check if differencing is needed
- To validate transformations
- To ensure modeling assumptions are met

## Automatic Stationarization

### `auto_stationarize()`

Automatically make a time series stationary.

**Usage:**
```r
auto_stationarize(
  .data,
  .value,
  .num_iterations = 10,
  .significance_level = 0.05
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.value` - Value column (unquoted)
- `.num_iterations` - Maximum transformations to try
- `.significance_level` - P-value threshold for stationarity

**Example:**
```r
# Automatically stationarize
data <- ts_to_tbl(AirPassengers) %>% select(-index)

stationary_data <- auto_stationarize(
  .data = data,
  .value = value,
  .num_iterations = 5
)

# Check result
ts_adf_test(stationary_data, value)$stationary
#> [1] TRUE
```

**What It Does:**
Tries transformations in sequence until stationary:
1. Log transformation
2. First difference
3. Second difference
4. Difference of log
5. Second difference of log

**Returns:**
Transformed data (stationary if successful)

## Time Series Transformations

### `util_log_ts()`

Log transformation of time series.

**Usage:**
```r
util_log_ts(.data, .value)
```

**Example:**
```r
data_log <- util_log_ts(data, value)
```

**When to Use:**
- Variance increases with level
- Exponential growth patterns
- To stabilize variance

### `util_singlediff_ts()`

First-order differencing.

**Usage:**
```r
util_singlediff_ts(.data, .value)
```

**Example:**
```r
# Remove trend
data_diff <- util_singlediff_ts(data, value)
```

**Mathematical Definition:**
```
y'ₜ = yₜ - yₜ₋₁
```

**When to Use:**
- Remove linear trends
- Make non-stationary series stationary
- First step in ARIMA(p,1,q) models

### `util_doublediff_ts()`

Second-order differencing.

**Usage:**
```r
util_doublediff_ts(.data, .value)
```

**Mathematical Definition:**
```
y''ₜ = (yₜ - yₜ₋₁) - (yₜ₋₁ - yₜ₋₂)
```

**When to Use:**
- Remove quadratic trends
- For ARIMA(p,2,q) models
- Rarely needed (check with ADF test first)

### `util_difflog_ts()`

Difference of log-transformed series.

**Usage:**
```r
util_difflog_ts(.data, .value)
```

**Mathematical Definition:**
```
y'ₜ = log(yₜ) - log(yₜ₋₁) = log(yₜ/yₜ₋₁)
```

**Interpretation:**
Approximates percentage change.

**When to Use:**
- Data with multiplicative seasonality
- Variance proportional to level
- Financial returns analysis

### `util_doubledifflog_ts()`

Second difference of log transformation.

**Usage:**
```r
util_doubledifflog_ts(.data, .value)
```

**When to Use:**
- Rarely needed
- Extreme non-stationarity
- After other methods fail

## Frequency Analysis

### `tidy_fft()`

Fast Fourier Transform for frequency domain analysis.

**Usage:**
```r
tidy_fft(
  .data,
  .date_col,
  .value_col,
  .frequency = 12,
  .harmonics = 1,
  .upsampling = 1
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.date_col` - Date column
- `.value_col` - Value column
- `.frequency` - Sampling frequency
- `.harmonics` - Number of harmonics to extract
- `.upsampling` - Upsampling factor

**Returns:**
A list containing:
- `fft_tbl` - FFT coefficients
- `plot` - Visualization

**Example:**
```r
library(dplyr)

# Prepare data
data <- ts_to_tbl(AirPassengers) %>%
  select(-index)

# Perform FFT
fft_result <- tidy_fft(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .frequency = 12,  # Monthly data
  .harmonics = 3
)

# View results
fft_result$fft_tbl
fft_result$plot
```

**What It Shows:**
- Dominant frequencies in the data
- Seasonal components
- Cyclical patterns
- Periodic behavior

**Use Cases:**
- Identify seasonality
- Detect hidden periodicities
- Decompose time series
- Signal processing

## Confidence Intervals

### `ci_hi()` / `ci_lo()`

Calculate confidence interval bounds.

**Usage:**
```r
ci_hi(.data, .value, .alpha = 0.05)
ci_lo(.data, .value, .alpha = 0.05)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.value` - Value column
- `.alpha` - Significance level (default: 0.05 for 95% CI)

**Example:**
```r
library(dplyr)

data <- data.frame(
  date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 100),
  value = rnorm(100, mean = 100, sd = 10)
)

# Add confidence intervals
data_with_ci <- data %>%
  mutate(
    ci_upper = ci_hi(., value, .alpha = 0.05),
    ci_lower = ci_lo(., value, .alpha = 0.05)
  )

# Visualize
library(ggplot2)
ggplot(data_with_ci, aes(x = date)) +
  geom_line(aes(y = value)) +
  geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), alpha = 0.2)
```

**Common Alpha Values:**
- `.alpha = 0.01` → 99% CI
- `.alpha = 0.05` → 95% CI (default)
- `.alpha = 0.10` → 90% CI

## Correlation Analysis

### `ts_lag_correlation()`

Compute lag correlations (autocorrelation and cross-correlation).

**Usage:**
```r
ts_lag_correlation(
  .data,
  .date_col,
  .value_col,
  .lags = 1
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.date_col` - Date column
- `.value_col` - Value column
- `.lags` - Number of lags to compute

**Returns:**
Data with lagged values and correlation matrix

**Example:**
```r
library(dplyr)

# Prepare data
data <- ts_to_tbl(AirPassengers) %>% select(-index)

# Compute lag correlations
lag_cor <- ts_lag_correlation(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .lags = 12  # 12 months of lags
)

# View correlation matrix
lag_cor %>%
  select(contains("lag")) %>%
  cor(use = "complete.obs")
```

**Use Cases:**
- Identify autoregressive order (p) for ARIMA
- Detect seasonal patterns
- Understand temporal dependencies
- Feature engineering for ML models

**Interpretation:**
- High correlation at lag k → value at time t relates to value at t-k
- Regular pattern in correlations → seasonality
- Exponential decay → AR process
- Cutoff after lag q → MA process

## Information Extraction

### `ts_info_tbl()`

Extract comprehensive time series information.

**Usage:**
```r
ts_info_tbl(.data, .date_col, .value_col)
```

**Returns:**
A tibble with:
- Time series length
- Start and end dates
- Frequency
- Missing values count
- Basic statistics (mean, sd, min, max)
- Trend information

**Example:**
```r
data <- ts_to_tbl(AirPassengers) %>% select(-index)

info <- ts_info_tbl(data, date_col, value)

print(info)
#> # A tibble: 1 × 10
#>   n_obs start_date end_date   frequency missing mean    sd    min   max   trend
#>   <int> <date>     <date>     <chr>       <int> <dbl> <dbl>  <dbl> <dbl>   <chr>
#> 1   144 1949-01-01 1960-12-01 monthly         0  280.  119.    104   622 increa…
```

**Use Cases:**
- Quick data summary
- Validation before modeling
- Documentation
- Data quality checks

## Vector Functions

Vector versions for direct computation:

### `ts_velocity_vec()`

Calculate rate of change (first difference).

**Usage:**
```r
ts_velocity_vec(.x)
```

**Example:**
```r
values <- c(100, 105, 103, 110, 115)
velocity <- ts_velocity_vec(values)
#> [1]  NA   5  -2   7   5
```

### `ts_acceleration_vec()`

Calculate acceleration (second difference).

**Usage:**
```r
ts_acceleration_vec(.x)
```

**Example:**
```r
values <- c(100, 105, 103, 110, 115)
acceleration <- ts_acceleration_vec(values)
#> [1]  NA  NA  -7   9  -2
```

### `ts_growth_rate_vec()`

Calculate growth rate (percentage change).

**Usage:**
```r
ts_growth_rate_vec(.x, .scale = 100)
```

**Parameters:**
- `.x` - Numeric vector
- `.scale` - Scaling factor (100 for percentage)

**Example:**
```r
values <- c(100, 105, 103, 110, 115)
growth_rate <- ts_growth_rate_vec(values, .scale = 100)
#> [1]   NA  5.00 -1.90  6.80  4.55
```

**Mathematical Definition:**
```
growth_rate_t = ((x_t - x_{t-1}) / x_{t-1}) × scale
```

## Practical Examples

### Example 1: Complete Stationarity Analysis

```r
library(healthyR.ts)
library(dplyr)

# Original data
data <- ts_to_tbl(AirPassengers) %>% select(-index)

# 1. Test original
original_test <- ts_adf_test(data, value)
cat("Original p-value:", original_test$p_value, "\n")

# 2. Try log transform
data_log <- util_log_ts(data, value)
log_test <- ts_adf_test(data_log, value)
cat("Log p-value:", log_test$p_value, "\n")

# 3. Try differencing
data_diff <- util_singlediff_ts(data, value)
diff_test <- ts_adf_test(data_diff, value)
cat("Diff p-value:", diff_test$p_value, "\n")

# 4. Try diff of log
data_difflog <- util_difflog_ts(data, value)
difflog_test <- ts_adf_test(data_difflog, value)
cat("Diff-log p-value:", difflog_test$p_value, "\n")

# 5. Or use automatic
data_auto <- auto_stationarize(data, value)
auto_test <- ts_adf_test(data_auto, value)
cat("Auto p-value:", auto_test$p_value, "\n")
```

### Example 2: Identify Seasonality with FFT

```r
# Analyze frequencies
data <- ts_to_tbl(AirPassengers) %>% select(-index)

fft_result <- tidy_fft(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .frequency = 12,
  .harmonics = 5
)

# View dominant frequencies
fft_result$fft_tbl %>%
  arrange(desc(amplitude)) %>%
  head(5)

# Plot frequency spectrum
fft_result$plot
```

### Example 3: Correlation-based Feature Engineering

```r
# Create lagged features
data_lagged <- ts_lag_correlation(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .lags = 12
)

# Select significant lags based on correlation
cor_matrix <- data_lagged %>%
  select(value, contains("lag")) %>%
  cor(use = "complete.obs")

# Keep lags with |correlation| > 0.3
significant_lags <- cor_matrix[1, -1] %>%
  abs() %>%
  .[. > 0.3] %>%
  names()

# Use in modeling
model_data <- data_lagged %>%
  select(date_col, value, all_of(significant_lags)) %>%
  filter(complete.cases(.))
```

### Example 4: Confidence Interval Visualization

```r
library(ggplot2)

# Rolling statistics with CI
data <- ts_to_tbl(AirPassengers) %>% select(-index)

# Calculate rolling mean and CI
data_summary <- data %>%
  mutate(
    row_num = row_number(),
    mean_val = mean(value),
    ci_upper = ci_hi(., value),
    ci_lower = ci_lo(., value)
  )

# Visualize
ggplot(data_summary, aes(x = date_col)) +
  geom_line(aes(y = value), color = "black") +
  geom_hline(aes(yintercept = mean_val), 
             color = "blue", linetype = "dashed") +
  geom_hline(aes(yintercept = ci_upper), 
             color = "red", linetype = "dotted") +
  geom_hline(aes(yintercept = ci_lower), 
             color = "red", linetype = "dotted") +
  labs(
    title = "Time Series with Confidence Intervals",
    y = "Value"
  ) +
  theme_minimal()
```

## Best Practices

### 1. Always Test for Stationarity

```r
# Before ARIMA modeling
result <- ts_adf_test(data, value)

if (!result$stationary) {
  # Apply transformation
  data <- util_singlediff_ts(data, value)
  # Or use automatic
  data <- auto_stationarize(data, value)
}
```

### 2. Choose Appropriate Transformation

```r
# Decision tree
if (variance_increases_with_level) {
  data <- util_log_ts(data, value)
} else if (has_trend) {
  data <- util_singlediff_ts(data, value)
} else if (has_quadratic_trend) {
  data <- util_doublediff_ts(data, value)
}

# Then verify
ts_adf_test(data, value)
```

### 3. Use FFT for Hidden Patterns

```r
# When seasonality is unclear
fft_result <- tidy_fft(data, date_col, value, .frequency = 1)

# Look for peaks in frequency domain
fft_result$plot
```

### 4. Don't Over-Difference

```r
# Check differencing need
adf_test <- ts_adf_test(data, value)

if (adf_test$p_value > 0.05) {
  # Difference once
  data_diff <- util_singlediff_ts(data, value)
  
  # Check again
  adf_test2 <- ts_adf_test(data_diff, value)
  
  if (adf_test2$p_value < 0.05) {
    # Stop! Already stationary
    data <- data_diff
  } else {
    # May need second difference (rare)
    data <- util_doublediff_ts(data, value)
  }
}
```

## Common Patterns

### Pattern 1: Pre-modeling Checklist

```r
# 1. Info
info <- ts_info_tbl(data, date_col, value)

# 2. Stationarity
adf <- ts_adf_test(data, value)

# 3. Correlation structure
lag_cor <- ts_lag_correlation(data, date_col, value, .lags = 12)

# 4. Frequency analysis
fft <- tidy_fft(data, date_col, value)

# Now ready for modeling
```

### Pattern 2: Diagnostic Pipeline

```r
# Test → Transform → Verify
result <- ts_adf_test(data, value)

if (!result$stationary) {
  data <- auto_stationarize(data, value)
  result <- ts_adf_test(data, value)
  
  if (!result$stationary) {
    warning("Could not achieve stationarity")
  }
}
```

## See Also

- [Data Preparation](Data-Preparation.md) - Preparing data for analysis
- [Forecasting Models](Forecasting-Models.md) - Models requiring stationary data
- [Data Generators](Data-Generators.md) - Generate test data
- [Visualization Functions](Visualization-Functions.md) - Visualize statistical properties
