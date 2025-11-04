# Hospital Admissions Forecasting

A comprehensive practical guide to forecasting hospital admissions using healthyR.ts.

## Overview

Hospital admissions forecasting is critical for:
- **Resource planning** - Staffing and bed allocation
- **Budget forecasting** - Financial planning
- **Operational efficiency** - Reducing bottlenecks
- **Quality of care** - Adequate capacity for patient needs

This guide walks through a complete admissions forecasting workflow.

## Dataset

We'll create a realistic hospital admissions dataset:

```r
library(healthyR.ts)
library(dplyr)
library(lubridate)
library(ggplot2)
library(timetk)
library(modeltime)

set.seed(123)

# Generate 3 years of daily admission data
dates <- seq.Date(
  from = as.Date("2020-01-01"),
  to = as.Date("2022-12-31"),
  by = "day"
)

# Create realistic patterns
admissions_data <- data.frame(date = dates) %>%
  mutate(
    # Day of week effect (lower on weekends)
    dow_effect = case_when(
      wday(date) %in% c(1, 7) ~ -10,  # Sunday, Saturday
      TRUE ~ 0
    ),
    # Seasonal effect (higher in winter - flu season)
    seasonal_effect = 20 * sin(2 * pi * (yday(date) - 15) / 365),
    # Trend (growing over time)
    trend = as.numeric(date - min(date)) / 30,
    # Random noise
    noise = rnorm(n(), mean = 0, sd = 5),
    # Combine all effects
    admissions = round(
      80 + trend + dow_effect + seasonal_effect + noise
    ),
    admissions = pmax(admissions, 0)  # Ensure non-negative
  ) %>%
  select(date, admissions)

# View the data
head(admissions_data, 10)
```

## Exploratory Data Analysis

### 1. Visualize Raw Data

```r
# Time series plot
admissions_data %>%
  ggplot(aes(x = date, y = admissions)) +
  geom_line(color = "steelblue") +
  geom_smooth(method = "loess", se = TRUE, color = "darkred") +
  labs(
    title = "Daily Hospital Admissions",
    subtitle = "2020-2022",
    x = "Date",
    y = "Number of Admissions"
  ) +
  theme_minimal()

# Calendar heatmap
ts_calendar_heatmap_plot(
  .data = admissions_data,
  .date_col = date,
  .value_col = admissions,
  .plt_title = "Admission Patterns by Day",
  .interactive = FALSE
)
```

### 2. Check for Seasonality

```r
# FFT analysis
fft_result <- tidy_fft(
  .data = admissions_data,
  .date_col = date,
  .value_col = admissions,
  .frequency = 365,  # Daily data
  .harmonics = 5
)

# View dominant frequencies
fft_result$plot

# Extract seasonal pattern
fft_result$fft_tbl %>%
  arrange(desc(amplitude)) %>%
  head(10)
```

### 3. Test for Stationarity

```r
# ADF test
adf_result <- ts_adf_test(admissions_data, admissions)

cat("P-value:", adf_result$p_value, "\n")
cat("Stationary:", adf_result$stationary, "\n")

# If non-stationary, transform
if (!adf_result$stationary) {
  admissions_stationary <- util_singlediff_ts(
    admissions_data,
    admissions
  )
  
  # Test again
  adf_result2 <- ts_adf_test(admissions_stationary, admissions)
  cat("After differencing - Stationary:", adf_result2$stationary, "\n")
}
```

### 4. Summary Statistics

```r
# Basic info
ts_info_tbl(admissions_data, date, admissions)

# Descriptive statistics
admissions_data %>%
  summarise(
    mean = mean(admissions),
    median = median(admissions),
    sd = sd(admissions),
    min = min(admissions),
    max = max(admissions),
    q25 = quantile(admissions, 0.25),
    q75 = quantile(admissions, 0.75)
  )

# Day of week pattern
admissions_data %>%
  mutate(dow = wday(date, label = TRUE)) %>%
  group_by(dow) %>%
  summarise(
    avg_admissions = mean(admissions),
    sd_admissions = sd(admissions)
  ) %>%
  ggplot(aes(x = dow, y = avg_admissions)) +
  geom_col(fill = "steelblue") +
  geom_errorbar(
    aes(ymin = avg_admissions - sd_admissions,
        ymax = avg_admissions + sd_admissions),
    width = 0.2
  ) +
  labs(
    title = "Average Admissions by Day of Week",
    x = "Day",
    y = "Average Admissions"
  ) +
  theme_minimal()
```

## Data Preparation

### 1. Handle Missing Values

```r
# Check for missing
cat("Missing dates:", sum(is.na(admissions_data$date)), "\n")
cat("Missing values:", sum(is.na(admissions_data$admissions)), "\n")

# If missing values exist
if (any(is.na(admissions_data$admissions))) {
  admissions_data <- admissions_data %>%
    # Option 1: Remove
    filter(!is.na(admissions))
    
  # Or Option 2: Impute
  # mutate(admissions = na.approx(admissions))
}
```

### 2. Create Train/Test Split

```r
# Split data (hold out last 30 days for testing)
splits <- time_series_split(
  admissions_data,
  date_var = date,
  assess = 30,
  cumulative = TRUE
)

# Verify split
cat("Training observations:", nrow(training(splits)), "\n")
cat("Testing observations:", nrow(testing(splits)), "\n")

# Visualize split
ts_splits_plot(
  .data = admissions_data,
  .splits = splits,
  .date_col = date
)
```

### 3. Feature Engineering

```r
# Add temporal features
admissions_features <- admissions_data %>%
  mutate(
    # Day of week
    dow = wday(date, label = TRUE),
    dow_num = wday(date),
    # Month
    month = month(date, label = TRUE),
    month_num = month(date),
    # Quarter
    quarter = quarter(date),
    # Year
    year = year(date),
    # Day of year
    doy = yday(date),
    # Is weekend
    is_weekend = dow_num %in% c(1, 7),
    # Lagged values
    lag1 = lag(admissions, 1),
    lag7 = lag(admissions, 7),
    lag30 = lag(admissions, 30),
    # Rolling statistics
    ma7 = slider::slide_dbl(
      admissions,
      mean,
      .before = 6,
      .complete = TRUE
    ),
    ma30 = slider::slide_dbl(
      admissions,
      mean,
      .before = 29,
      .complete = TRUE
    )
  ) %>%
  filter(!is.na(lag30))  # Remove rows with NA from lags
```

## Model Building

### Model 1: ARIMA (Baseline)

```r
# Automatic ARIMA
model_arima <- ts_auto_arima(
  .data = training(splits),
  .date_col = date,
  .value_col = admissions,
  .formula = admissions ~ .,
  .rsamp_obj = splits,
  .tune = FALSE  # Use auto.arima defaults
)

# View results
model_arima$calibration_tbl
model_arima$calibration_plot
```

### Model 2: Prophet (Handles Seasonality)

```r
# Prophet with tuning
model_prophet <- ts_auto_prophet_reg(
  .data = training(splits),
  .date_col = date,
  .value_col = admissions,
  .formula = admissions ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 10,
  .num_cores = 2
)

# View best parameters
model_prophet$best_tuned_tbl
```

### Model 3: XGBoost (Captures Non-linearity)

```r
# XGBoost with tuning
model_xgboost <- ts_auto_xgboost(
  .data = training(splits),
  .date_col = date,
  .value_col = admissions,
  .formula = admissions ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 15,
  .num_cores = 4
)

# View tuning results
model_xgboost$tuned_tbl %>%
  arrange(mean) %>%
  head(5)
```

### Model 4: Linear Model (Simple Benchmark)

```r
# Linear model (fast baseline)
model_lm <- ts_auto_lm(
  .data = training(splits),
  .date_col = date,
  .value_col = admissions,
  .formula = admissions ~ .,
  .rsamp_obj = splits,
  .tune = FALSE
)
```

### Model 5: Exponential Smoothing

```r
# ETS model
model_ets <- ts_auto_exp_smoothing(
  .data = training(splits),
  .date_col = date,
  .value_col = admissions,
  .formula = admissions ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 10
)
```

## Model Comparison

### 1. Create Model Table

```r
# Combine all models
model_table <- modeltime_table(
  model_arima$fitted_wflw,
  model_prophet$fitted_wflw,
  model_xgboost$fitted_wflw,
  model_lm$fitted_wflw,
  model_ets$fitted_wflw
)

model_table
```

### 2. Calibrate on Test Set

```r
# Calibrate
calibration_table <- model_table %>%
  modeltime_calibrate(testing(splits))

calibration_table
```

### 3. Compare Accuracy

```r
# Accuracy metrics
accuracy_table <- calibration_table %>%
  modeltime_accuracy()

# View sorted by RMSE
accuracy_table %>%
  arrange(rmse)

# Visualize accuracy
accuracy_table %>%
  mutate(model = paste0("Model ", .model_id, ": ", .model_desc)) %>%
  select(model, mae, rmse, mape, rsq) %>%
  tidyr::pivot_longer(-model, names_to = "metric", values_to = "value") %>%
  ggplot(aes(x = model, y = value, fill = metric)) +
  geom_col() +
  facet_wrap(~metric, scales = "free_y") +
  coord_flip() +
  labs(title = "Model Performance Comparison") +
  theme_minimal() +
  theme(legend.position = "none")
```

### 4. Visual Comparison

```r
# Forecast plot
calibration_table %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = admissions_data
  ) %>%
  plot_modeltime_forecast(.interactive = FALSE)
```

## Select Best Model

```r
# Select best model by RMSE
best_model_id <- accuracy_table %>%
  arrange(rmse) %>%
  slice(1) %>%
  pull(.model_id)

cat("Best model:", best_model_id, "\n")

# Extract best model
best_model <- calibration_table %>%
  filter(.model_id == best_model_id)
```

## Forecast Future Values

### 1. Create Future Dates

```r
# Forecast next 30 days
future_data <- admissions_data %>%
  future_frame(.date_var = date, .length_out = 30)

head(future_data)
```

### 2. Generate Forecasts

```r
# Forecast with best model
forecast_tbl <- best_model %>%
  modeltime_forecast(
    new_data = future_data,
    actual_data = admissions_data
  )

# View forecast
forecast_tbl %>%
  filter(.key == "prediction") %>%
  select(.index, .value, .conf_lo, .conf_hi)
```

### 3. Visualize Forecast

```r
# Plot forecast
plot_modeltime_forecast(
  forecast_tbl,
  .interactive = FALSE,
  .title = "30-Day Hospital Admissions Forecast"
)

# Summary statistics of forecast
forecast_tbl %>%
  filter(.key == "prediction") %>%
  summarise(
    mean_forecast = mean(.value),
    min_forecast = min(.value),
    max_forecast = max(.value),
    sd_forecast = sd(.value)
  )
```

## Operational Insights

### 1. Identify Peak Days

```r
# Find highest forecast days
peak_days <- forecast_tbl %>%
  filter(.key == "prediction") %>%
  arrange(desc(.value)) %>%
  head(5)

cat("\nTop 5 highest admission days:\n")
print(peak_days)

# Add day of week
peak_days <- peak_days %>%
  mutate(
    day_of_week = wday(.index, label = TRUE),
    week_number = week(.index)
  )
```

### 2. Resource Planning

```r
# Calculate required resources
forecast_tbl %>%
  filter(.key == "prediction") %>%
  mutate(
    # Assume 1 nurse per 5 patients
    nurses_needed = ceiling(.value / 5),
    # Assume 1 doctor per 10 patients
    doctors_needed = ceiling(.value / 10),
    # Assume 80% bed occupancy target
    beds_needed = ceiling(.value / 0.8)
  ) %>%
  select(.index, .value, nurses_needed, doctors_needed, beds_needed) %>%
  summary()
```

### 3. Budget Estimation

```r
# Cost per admission (example: $5000)
cost_per_admission <- 5000

# Calculate budget
budget_forecast <- forecast_tbl %>%
  filter(.key == "prediction") %>%
  summarise(
    total_admissions = sum(.value),
    estimated_revenue = total_admissions * cost_per_admission,
    lower_bound = sum(.conf_lo) * cost_per_admission,
    upper_bound = sum(.conf_hi) * cost_per_admission
  )

cat("\n30-Day Budget Forecast:\n")
cat("Expected revenue: $", format(budget_forecast$estimated_revenue, big.mark = ","), "\n")
cat("Lower bound: $", format(budget_forecast$lower_bound, big.mark = ","), "\n")
cat("Upper bound: $", format(budget_forecast$upper_bound, big.mark = ","), "\n")
```

## Model Monitoring

### 1. Create Residual Diagnostics

```r
# Extract residuals
residuals <- calibration_table %>%
  modeltime_residuals(testing(splits))

# Plot residuals
residuals %>%
  filter(.model_id == best_model_id) %>%
  ggplot(aes(x = .index, y = .residuals)) +
  geom_point(alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +
  geom_smooth(method = "loess", se = TRUE) +
  labs(
    title = "Residual Plot",
    x = "Date",
    y = "Residuals"
  ) +
  theme_minimal()

# QQ plot for residuals
ts_qq_plot(
  .data = residuals %>% filter(.model_id == best_model_id),
  .date_col = .index,
  .value_col = .residuals
)
```

### 2. Track Forecast Accuracy Over Time

```r
# As new data comes in, compare forecasts to actuals
# (This would be done in production)

performance_tracking <- tibble(
  date = seq.Date(Sys.Date(), by = "day", length.out = 30),
  forecast = NA_real_,
  actual = NA_real_,
  error = NA_real_,
  pct_error = NA_real_
)

# Update as actual values become available
# Calculate rolling MAPE, alert if degrades
```

## Advanced: Ensemble Model

### Create Weighted Ensemble

```r
# Use top 3 models
top_models <- accuracy_table %>%
  arrange(rmse) %>%
  head(3)

# Calculate weights (inverse of RMSE)
weights <- 1 / top_models$rmse
weights <- weights / sum(weights)

cat("Ensemble weights:\n")
print(data.frame(
  model_id = top_models$.model_id,
  weight = round(weights, 3)
))

# Create ensemble (manual approach)
ensemble_forecast <- forecast_tbl %>%
  filter(.model_id %in% top_models$.model_id, .key == "prediction") %>%
  group_by(.index) %>%
  summarise(
    .value = sum(.value * rep(weights, length.out = n())),
    .conf_lo = min(.conf_lo),
    .conf_hi = max(.conf_hi)
  ) %>%
  mutate(
    .key = "prediction",
    .model_id = 999,
    .model_desc = "Weighted Ensemble"
  )
```

## Deployment Checklist

- [ ] Models trained on full historical data
- [ ] Forecast accuracy metrics documented
- [ ] Confidence intervals calculated
- [ ] Resource requirements estimated
- [ ] Monitoring dashboard created
- [ ] Alert thresholds defined
- [ ] Model retraining schedule established
- [ ] Stakeholders briefed
- [ ] Documentation complete

## Next Steps

1. **Automate the pipeline:**
   ```r
   # Create function to run entire pipeline
   forecast_admissions <- function(data, forecast_horizon = 30) {
     # ... all steps above ...
     return(forecast_tbl)
   }
   ```

2. **Add more features:**
   - Holiday indicators
   - Local events
   - Weather data
   - Historical flu trends

3. **Try more models:**
   - Neural networks (`ts_auto_nnetar()`)
   - MARS (`ts_auto_mars()`)
   - Hybrid models

4. **Implement real-time monitoring:**
   - Track forecast vs. actual
   - Alert on significant deviations
   - Retrain when performance degrades

## See Also

- [Forecasting Models](Forecasting-Models) - All available models
- [Model Tuning and Selection](Model-Tuning-Selection) - Optimization guide
- [Statistical Functions](Statistical-Functions) - Data analysis tools
- [Visualization Functions](Visualization-Functions) - Plotting guide
