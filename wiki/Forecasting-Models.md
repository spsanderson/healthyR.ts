# Forecasting Models

Comprehensive guide to the 15 automated forecasting models available in healthyR.ts.

## Overview

healthyR.ts provides 15 pre-configured automated modeling workflows ("boilerplate functions") that handle the complete modeling pipeline:

1. **Recipe Creation** - Feature engineering
2. **Model Specification** - Define model with tunable parameters
3. **Workflow** - Combine recipe and model
4. **Model Fitting** - Train on data
5. **Hyperparameter Tuning** (optional) - Optimize parameters
6. **Calibration** - Evaluate on test set

Each `ts_auto_*()` function returns a list containing all these components plus diagnostic plots.

## Common Parameters

All boilerplate functions share these parameters:

```r
ts_auto_*</ (
  .data,              # Time series data (tibble/data.frame)
  .date_col,          # Date column name
  .value_col,         # Value column name  
  .formula,           # Model formula (usually value ~ .)
  .rsamp_obj,         # rsample split object
  .prefix = "ts_*",   # Prefix for saved objects
  .tune = TRUE,       # Whether to tune hyperparameters
  .grid_size = 10,    # Size of tuning grid
  .num_cores = 1,     # Cores for parallel processing
  .cv_assess = 12,    # CV assessment period
  .cv_skip = 3,       # CV skip period
  .cv_slice_limit = 6,# Number of CV slices
  .best_metric = "rmse", # Metric for model selection
  .bootstrap_final = FALSE # Bootstrap final model
)
```

## Return Value

All boilerplate functions return a list with:

- `recipe_info` - Recipe object
- `model_spec` - Model specification (parsnip)
- `wflw` - Workflow object
- `fitted_wflw` - Fitted workflow
- `model_info` - Model information
- `parameter_tuning` - Tuning results (if `.tune = TRUE`)
- `tuned_tbl` - Table of tuned parameters
- `best_tuned_tbl` - Best parameters
- `calibration_tbl` - Calibration results
- `calibration_plot` - Visual diagnostics
- Attributes with metadata

## ARIMA Family

### `ts_auto_arima()`

Automatic ARIMA modeling with auto-tuning.

**Model Details:**
- Engine: `modeltime::arima_reg()` with `"auto_arima"` engine
- Automatically selects p, d, q orders
- Handles seasonality
- Uses AIC for model selection

**Key Parameters:**
All common parameters apply.

**Example:**
```r
library(healthyR.ts)
library(dplyr)
library(timetk)

# Prepare data
data <- AirPassengers %>%
  ts_to_tbl() %>%
  select(-index)

# Create splits
splits <- time_series_split(
  data,
  date_col,
  assess = 12,
  cumulative = TRUE
)

# Build model
arima_model <- ts_auto_arima(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = FALSE  # Use auto.arima defaults
)

# View results
arima_model$calibration_tbl
arima_model$calibration_plot
```

**When to Use:**
- Classic time series with trends and seasonality
- When you need interpretable models
- Benchmark model for comparison

### `ts_auto_arima_xgboost()`

ARIMA with XGBoost for modeling errors.

**Model Details:**
- Combines ARIMA with gradient boosting
- ARIMA captures linear patterns
- XGBoost captures non-linear residual patterns

**Example:**
```r
arima_boost <- ts_auto_arima_xgboost(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 10
)
```

**When to Use:**
- Complex patterns beyond traditional ARIMA
- Non-linear relationships
- When you need better accuracy than pure ARIMA

## Prophet Family

### `ts_auto_prophet_reg()`

Facebook's Prophet algorithm for forecasting.

**Model Details:**
- Additive model: y(t) = g(t) + s(t) + h(t) + εₜ
  - g(t): Trend
  - s(t): Seasonality
  - h(t): Holidays
  - ε: Error term
- Handles missing data
- Robust to outliers
- Automatic seasonality detection

**Tunable Parameters:**
- `changepoint_num` - Number of potential changepoints
- `changepoint_range` - Range for changepoints
- `seasonality_yearly`, `seasonality_weekly`, `seasonality_daily`
- `season` - Seasonality mode ('additive' or 'multiplicative')

**Example:**
```r
prophet_model <- ts_auto_prophet_reg(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 15
)

# Extract best parameters
prophet_model$best_tuned_tbl
```

**When to Use:**
- Strong seasonal patterns
- Multiple seasonalities
- Holiday effects
- Missing data

### `ts_auto_prophet_boost()`

Prophet combined with XGBoost.

**Model Details:**
- Prophet for seasonal components
- XGBoost for residual patterns

**When to Use:**
- Seasonal data with non-linear patterns
- When pure Prophet underperforms

## Machine Learning Models

### `ts_auto_xgboost()`

Gradient boosting for time series.

**Model Details:**
- Engine: `parsnip::boost_tree()` with `"xgboost"`
- Ensemble of decision trees
- Handles non-linear patterns
- Feature importance available

**Tunable Parameters:**
- `trees` - Number of trees
- `min_n` - Minimum observations per node
- `tree_depth` - Maximum depth
- `learn_rate` - Learning rate
- `loss_reduction` - Minimum loss reduction
- `sample_size` - Proportion of data per tree

**Example:**
```r
xgboost_model <- ts_auto_xgboost(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 20,
  .num_cores = 4  # Parallel processing
)

# View tuning results
xgboost_model$tuned_tbl %>%
  arrange(mean) %>%
  head()
```

**When to Use:**
- Complex non-linear patterns
- Multiple predictors
- When accuracy is paramount

### `ts_auto_nnetar()`

Neural network autoregression.

**Model Details:**
- Engine: `modeltime::nnetar_reg()` with `"nnetar"`
- Feed-forward neural network
- Lagged inputs
- Single hidden layer

**Tunable Parameters:**
- `non_seasonal_ar` - Number of lags
- `seasonal_ar` - Seasonal lags
- `hidden_units` - Nodes in hidden layer
- `penalty` - Weight decay
- `num_networks` - Number of networks to average

**Example:**
```r
nnetar_model <- ts_auto_nnetar(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE
)
```

**When to Use:**
- Non-linear patterns
- No clear seasonality structure
- When you have sufficient data

### `ts_auto_lm()`

Linear regression with time features.

**Model Details:**
- Simple linear model
- Uses time-based features from recipe
- Fast and interpretable

**Example:**
```r
lm_model <- ts_auto_lm(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = FALSE  # No hyperparameters to tune
)
```

**When to Use:**
- Linear trends
- Baseline model
- When interpretability is critical

### `ts_auto_mars()`

Multivariate Adaptive Regression Splines.

**Model Details:**
- Engine: `parsnip::mars()` with `"earth"`
- Piecewise linear models
- Automatic interaction detection
- Feature selection built-in

**Tunable Parameters:**
- `num_terms` - Maximum number of terms
- `prod_degree` - Degree of interactions
- `prune_method` - Pruning method

**Example:**
```r
mars_model <- ts_auto_mars(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE,
  .grid_size = 12
)
```

**When to Use:**
- Non-linear relationships
- Automatic feature selection needed
- Interpretability important

### `ts_auto_glmnet()`

Elastic net regression (Ridge + Lasso).

**Model Details:**
- Engine: `parsnip::linear_reg()` with `"glmnet"`
- L1 (Lasso) and L2 (Ridge) regularization
- Feature selection via Lasso
- Handles multicollinearity

**Tunable Parameters:**
- `penalty` - Regularization strength
- `mixture` - Mix of L1 and L2 (0 = Ridge, 1 = Lasso)

**Example:**
```r
glmnet_model <- ts_auto_glmnet(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE
)
```

**When to Use:**
- Many features
- Multicollinearity present
- Feature selection needed

### `ts_auto_svm_poly()`

Support Vector Machine with polynomial kernel.

**Model Details:**
- Engine: `parsnip::svm_poly()` with `"kernlab"`
- Polynomial kernel
- Non-linear decision boundaries

**Tunable Parameters:**
- `cost` - Cost of constraint violation
- `degree` - Polynomial degree
- `scale_factor` - Kernel scale

**Example:**
```r
svm_poly_model <- ts_auto_svm_poly(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE
)
```

**When to Use:**
- Non-linear patterns
- Robust to outliers needed

### `ts_auto_svm_rbf()`

Support Vector Machine with radial basis function.

**Model Details:**
- Engine: `parsnip::svm_rbf()` with `"kernlab"`
- RBF (Gaussian) kernel
- Flexible non-linear modeling

**Tunable Parameters:**
- `cost` - Cost parameter
- `rbf_sigma` - Kernel width

**When to Use:**
- Complex non-linear patterns
- Alternative to polynomial SVM

## Statistical Models

### `ts_auto_exp_smoothing()`

Exponential smoothing (ETS).

**Model Details:**
- Engine: `modeltime::exp_smoothing()` with `"ets"`
- Error, Trend, Seasonal components
- Automatic model selection

**Tunable Parameters:**
- `seasonal_period` - Seasonal period
- `error` - Error type
- `trend` - Trend type
- `season` - Seasonal type

**Example:**
```r
ets_model <- ts_auto_exp_smoothing(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = TRUE
)
```

**When to Use:**
- Seasonal data
- Short to medium term forecasting
- Simple, fast model

### `ts_auto_smooth_es()`

Exponential smoothing from smooth package.

**Model Details:**
- Engine: `"smooth_es"` from smooth package
- Advanced ETS implementation
- Multiple seasonal patterns

**When to Use:**
- Alternative to standard ETS
- Complex seasonality

### `ts_auto_theta()`

Theta method.

**Model Details:**
- Engine: `modeltime::theta_reg()` with `"theta"`
- Decomposes series into local and global components
- Simple and effective

**Example:**
```r
theta_model <- ts_auto_theta(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .,
  .rsamp_obj = splits,
  .tune = FALSE
)
```

**When to Use:**
- Simple univariate forecasting
- Benchmark model
- Short-term forecasts

### `ts_auto_croston()`

Croston's method for intermittent demand.

**Model Details:**
- Engine: `"croston"` from forecast
- Separate forecasts for:
  - Demand size (when non-zero)
  - Inter-arrival time
- Designed for sparse/intermittent data

**Example:**
```r
# Data with many zeros (intermittent demand)
intermittent_data <- data.frame(
  date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 365),
  demand = c(rep(0, 10), 5, rep(0, 15), 3, rep(0, 20), ...)
)

croston_model <- ts_auto_croston(
  .data = intermittent_data,
  .date_col = date,
  .value_col = demand,
  .formula = demand ~ .,
  .rsamp_obj = splits,
  .tune = FALSE
)
```

**When to Use:**
- Intermittent demand (many zeros)
- Inventory management
- Spare parts forecasting

## Model Comparison

### Quick Reference Table

| Model | Complexity | Speed | Interpretability | Best For |
|-------|-----------|-------|-----------------|----------|
| `ts_auto_lm()` | Low | Fast | High | Linear trends |
| `ts_auto_arima()` | Medium | Medium | High | Classic TS patterns |
| `ts_auto_exp_smoothing()` | Low | Fast | High | Simple seasonality |
| `ts_auto_theta()` | Low | Fast | Medium | Quick forecasts |
| `ts_auto_prophet_reg()` | Medium | Medium | Medium | Multiple seasonalities |
| `ts_auto_croston()` | Low | Fast | Medium | Intermittent demand |
| `ts_auto_nnetar()` | High | Slow | Low | Non-linear patterns |
| `ts_auto_mars()` | Medium | Medium | Medium | Non-linear + interpretable |
| `ts_auto_glmnet()` | Low-Medium | Fast | High | Many features |
| `ts_auto_xgboost()` | High | Medium | Low | Maximum accuracy |
| `ts_auto_svm_poly()` | High | Slow | Low | Non-linear |
| `ts_auto_svm_rbf()` | High | Slow | Low | Complex non-linear |
| `ts_auto_arima_xgboost()` | High | Slow | Low | Hybrid approach |
| `ts_auto_prophet_boost()` | High | Slow | Low | Seasonal + non-linear |
| `ts_auto_smooth_es()` | Medium | Medium | High | Complex seasonality |

## Workflow Example: Compare Multiple Models

```r
library(healthyR.ts)
library(dplyr)
library(timetk)
library(modeltime)

# Prepare data
data <- AirPassengers %>%
  ts_to_tbl() %>%
  select(-index)

splits <- time_series_split(data, date_col, assess = 12, cumulative = TRUE)

# Fit multiple models
m1 <- ts_auto_arima(.data = data, .date_col = date_col, .value_col = value,
                    .formula = value ~ ., .rsamp_obj = splits, .tune = FALSE)

m2 <- ts_auto_prophet_reg(.data = data, .date_col = date_col, .value_col = value,
                          .formula = value ~ ., .rsamp_obj = splits, .tune = TRUE)

m3 <- ts_auto_xgboost(.data = data, .date_col = date_col, .value_col = value,
                      .formula = value ~ ., .rsamp_obj = splits, .tune = TRUE)

# Extract fitted workflows
model_tbl <- modeltime_table(
  m1$fitted_wflw,
  m2$fitted_wflw,
  m3$fitted_wflw
)

# Calibrate on test set
calibration <- model_tbl %>%
  modeltime_calibrate(testing(splits))

# Compare accuracy
calibration %>%
  modeltime_accuracy() %>%
  arrange(rmse)

# Forecast
calibration %>%
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = data
  ) %>%
  plot_modeltime_forecast()
```

## Best Practices

### 1. Start Simple
```r
# Begin with simple, interpretable models
models <- list(
  ts_auto_lm(),
  ts_auto_arima(),
  ts_auto_exp_smoothing()
)
```

### 2. Use Cross-Validation
```r
# Proper time series CV
ts_auto_xgboost(
  ...,
  .cv_assess = 12,    # Test on 12 periods
  .cv_skip = 3,       # Skip 3 between folds
  .cv_slice_limit = 6 # Use 6 CV folds
)
```

### 3. Tune When Needed
```r
# Quick model (no tuning)
quick_model <- ts_auto_arima(.tune = FALSE)

# Optimized model (with tuning)
tuned_model <- ts_auto_xgboost(.tune = TRUE, .grid_size = 30)
```

### 4. Use Parallel Processing
```r
# Speed up tuning with multiple cores
ts_auto_prophet_reg(
  ...,
  .num_cores = 4,
  .tune = TRUE,
  .grid_size = 20
)
```

## See Also

- [Model Tuning and Selection](Model-Tuning-Selection)
- [Automated Modeling Workflows](Automated-Modeling-Workflows)
- [Quick Start](Quick-Start) - Basic examples
- [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting) - Real-world application
