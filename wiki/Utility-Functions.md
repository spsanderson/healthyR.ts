# Utility Functions

Guide to helper and utility functions in healthyR.ts.

## Overview

Utility functions provide supporting functionality for:
- Data transformation
- Workflow management
- Model extraction
- Recipe creation
- Date/time helpers

## Data Transformation

### `ts_to_tbl()`

Convert ts objects to tibbles.

**Usage:**
```r
ts_to_tbl(.data)
```

**Parameters:**
- `.data` - A ts object

**Returns:**
A tibble with columns:
- `index` - Sequential index
- `date_col` - Date column (inferred from ts attributes)
- `value` - The time series values

**Example:**
```r
library(healthyR.ts)

# Convert built-in ts object
data_tbl <- ts_to_tbl(AirPassengers)

head(data_tbl)
#> # A tibble: 6 × 3
#>   index date_col   value
#>   <int> <date>     <dbl>
#> 1     1 1949-01-01   112
#> 2     2 1949-02-01   118
#> 3     3 1949-03-01   132

# Now can use with healthyR.ts functions
ts_calendar_heatmap_plot(
  .data = data_tbl,
  .date_col = date_col,
  .value_col = value
)
```

**Use Cases:**
- Work with base R ts objects in tidyverse workflows
- Convert legacy time series to modern format
- Prepare data for healthyR.ts functions

### `ts_compare_data()`

Compare two time series datasets.

**Usage:**
```r
ts_compare_data(.data1, .data2)
```

**Returns:**
Comparison metrics and visualizations

**Example:**
```r
# Compare actual vs forecast
actual <- ts_to_tbl(AirPassengers)
forecast <- ts_to_tbl(some_forecast_ts)

comparison <- ts_compare_data(actual, forecast)
```

## Date/Time Helpers

### Month Functions

Get month boundaries:

**Functions:**
- `month_start(date)` - First day of month
- `month_end(date)` - Last day of month

**Example:**
```r
library(lubridate)

dates <- seq.Date(as.Date("2020-01-15"), by = "month", length.out = 12)

data.frame(
  original = dates,
  month_start = month_start(dates),
  month_end = month_end(dates)
)
#>    original month_start  month_end
#> 1  2020-01-15  2020-01-01  2020-01-31
#> 2  2020-02-15  2020-02-01  2020-02-29
#> 3  2020-03-15  2020-03-01  2020-03-31
```

**Use Cases:**
- Aggregate data to month level
- Define reporting periods
- Filter by month boundaries

### Quarter Functions

Get quarter boundaries:

**Functions:**
- `quarter_start(date)` - First day of quarter
- `quarter_end(date)` - Last day of quarter

**Example:**
```r
dates <- as.Date(c("2020-02-15", "2020-05-20", "2020-08-10", "2020-11-30"))

data.frame(
  original = dates,
  quarter_start = quarter_start(dates),
  quarter_end = quarter_end(dates),
  quarter = quarter(dates)
)
#>    original quarter_start quarter_end quarter
#> 1  2020-02-15    2020-01-01  2020-03-31       1
#> 2  2020-05-20    2020-04-01  2020-06-30       2
#> 3  2020-08-10    2020-07-01  2020-09-30       3
#> 4  2020-11-30    2020-10-01  2020-12-31       4
```

### Year Functions

Get year boundaries:

**Functions:**
- `year_start(date)` - First day of year
- `year_end(date)` - Last day of year

**Example:**
```r
dates <- as.Date(c("2020-06-15", "2021-03-20", "2022-09-10"))

data.frame(
  original = dates,
  year_start = year_start(dates),
  year_end = year_end(dates)
)
#>    original year_start   year_end
#> 1  2020-06-15 2020-01-01 2020-12-31
#> 2  2021-03-20 2021-01-01 2021-12-31
#> 3  2022-09-10 2022-01-01 2022-12-31
```

**Use Cases:**
- Year-over-year comparisons
- Fiscal year calculations
- Annual reporting periods

## Recipe Functions

### `ts_auto_recipe()`

Automatically create a recipe for time series modeling.

**Usage:**
```r
ts_auto_recipe(
  .data,
  .date_col,
  .value_col,
  .formula
)
```

**Parameters:**
- `.data` - Data frame/tibble
- `.date_col` - Date column
- `.value_col` - Value column
- `.formula` - Model formula (e.g., `value ~ .`)

**Returns:**
A recipes object with automatic time series feature engineering

**Example:**
```r
library(recipes)
library(dplyr)

# Create data
data <- ts_to_tbl(AirPassengers) %>% select(-index)

# Create recipe
recipe <- ts_auto_recipe(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .formula = value ~ .
)

# View recipe steps
recipe

# Prep and bake
prepped <- prep(recipe, training = data)
baked <- bake(prepped, new_data = data)

head(baked)
```

**What It Does:**
Automatically adds:
- Fourier features (seasonality)
- Date features (month, day of week, etc.)
- Normalization
- Interaction terms
- And more...

**Use Cases:**
- Quick feature engineering
- Baseline for custom recipes
- Automated workflows

### `get_recipe_call()`

Extract recipe call from a recipe object.

**Usage:**
```r
get_recipe_call(.recipe)
```

**Example:**
```r
recipe <- ts_auto_recipe(...)

# Get the recipe call
call <- get_recipe_call(recipe)
print(call)
```

## Model Extraction

### `model_extraction_helper()`

Extract components from fitted models.

**Usage:**
```r
model_extraction_helper(.model_object)
```

**Parameters:**
- `.model_object` - A fitted model object (various types supported)

**Returns:**
Extracted model information depending on model type

**Supported Model Types:**
- `Arima` - ARIMA models from forecast package
- `auto.arima` - Auto ARIMA models
- `workflow` - Tidymodels workflow objects
- `model_spec` - Parsnip model specifications
- `model_fit` - Fitted parsnip models

**Example:**
```r
# Fit a model
model <- ts_auto_arima(
  .data = data,
  .date_col = date_col,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .,
  .tune = FALSE
)

# Extract workflow
workflow <- model_extraction_helper(model$fitted_wflw)

# Extract model spec
model_spec <- model_extraction_helper(model$model_spec)
```

**Use Cases:**
- Examine model structure
- Extract parameters
- Debug models
- Model comparison

### `ts_extract_auto_fitted_workflow()`

Extract fitted workflow from boilerplate functions.

**Usage:**
```r
ts_extract_auto_fitted_workflow(.model_list)
```

**Parameters:**
- `.model_list` - Output list from `ts_auto_*()` functions

**Returns:**
The fitted workflow object

**Example:**
```r
# Fit boilerplate model
model <- ts_auto_arima(...)

# Extract workflow
wf <- ts_extract_auto_fitted_workflow(model)

# Use with modeltime
library(modeltime)

model_table <- modeltime_table(wf)
```

**Use Cases:**
- Use boilerplate models in custom workflows
- Combine multiple boilerplate models
- Extract for ensemble methods

## Workflow Helpers

### `calibrate_and_plot()`

Calibrate model and create diagnostic plots.

**Usage:**
```r
calibrate_and_plot(
  .model_object,
  .splits_object,
  .data,
  .interactive = FALSE
)
```

**Parameters:**
- `.model_object` - Fitted workflow or model
- `.splits_object` - rsample split object
- `.data` - Original data
- `.interactive` - Return interactive plot if TRUE

**Returns:**
List with:
- `calibration_tbl` - Calibration results
- `plot` - Diagnostic plot

**Example:**
```r
library(timetk)
library(modeltime)

# Create splits
splits <- time_series_split(data, date_col, assess = 12, cumulative = TRUE)

# Fit model
model <- ts_auto_arima(...)

# Calibrate and plot
result <- calibrate_and_plot(
  .model_object = model$fitted_wflw,
  .splits_object = splits,
  .data = data,
  .interactive = FALSE
)

# View calibration
result$calibration_tbl

# View plot
result$plot
```

## Model Tuning

### `ts_model_auto_tune()`

Automatically tune model hyperparameters.

**Usage:**
```r
ts_model_auto_tune(
  .model_spec,
  .recipe_spec,
  .splits_obj,
  .grid_size = 10,
  .num_cores = 1,
  .best_metric = "rmse"
)
```

**Parameters:**
- `.model_spec` - Parsnip model specification with `tune()` placeholders
- `.recipe_spec` - Recipe object
- `.splits_obj` - rsample split or CV folds
- `.grid_size` - Size of tuning grid
- `.num_cores` - Cores for parallel processing
- `.best_metric` - Metric to optimize

**Returns:**
Tuned model with best parameters

**Example:**
```r
library(parsnip)
library(tune)

# Create model spec with tune() placeholders
model_spec <- boost_tree(
  trees = tune(),
  tree_depth = tune(),
  learn_rate = tune()
) %>%
  set_engine("xgboost") %>%
  set_mode("regression")

# Create recipe
recipe <- ts_auto_recipe(...)

# Tune
tuned_model <- ts_model_auto_tune(
  .model_spec = model_spec,
  .recipe_spec = recipe,
  .splits_obj = splits,
  .grid_size = 20,
  .num_cores = 4
)

# View best parameters
show_best(tuned_model)
```

### `ts_model_spec_tune_template()`

Create tuning template for model specification.

**Usage:**
```r
ts_model_spec_tune_template(
  .model_type = "arima"
)
```

**Supported Model Types:**
- `"arima"`
- `"arima_boost"`
- `"ets"`
- `"prophet"`
- `"prophet_boost"`
- `"lm"`
- `"glmnet"`
- `"xgboost"`
- `"mars"`
- `"svm_poly"`
- `"svm_rbf"`
- `"nnetar"`

**Returns:**
Model specification with `tune()` placeholders

**Example:**
```r
# Get ARIMA tune template
arima_spec <- ts_model_spec_tune_template(.model_type = "arima")

# Get XGBoost tune template
xgb_spec <- ts_model_spec_tune_template(.model_type = "xgboost")

# Use for tuning
tuned_model <- ts_model_auto_tune(
  .model_spec = xgb_spec,
  .recipe_spec = recipe,
  .splits_obj = splits
)
```

## Comparison and Ranking

### `ts_model_compare()`

Compare multiple models side-by-side.

**Usage:**
```r
ts_model_compare(.model_list)
```

**Parameters:**
- `.model_list` - List of fitted models

**Returns:**
Comparison table with accuracy metrics

**Example:**
```r
# Fit multiple models
m1 <- ts_auto_arima(...)
m2 <- ts_auto_prophet_reg(...)
m3 <- ts_auto_xgboost(...)

# Compare
comparison <- ts_model_compare(
  list(
    arima = m1,
    prophet = m2,
    xgboost = m3
  )
)

comparison
```

### `ts_model_rank_tbl()`

Rank models by performance.

**Usage:**
```r
ts_model_rank_tbl(
  .model_table,
  .metric = "rmse",
  .ascending = TRUE
)
```

**Parameters:**
- `.model_table` - modeltime_table object
- `.metric` - Metric to rank by
- `.ascending` - TRUE for lower is better (RMSE), FALSE for higher is better (R²)

**Returns:**
Ranked table

**Example:**
```r
library(modeltime)

# Create model table
models <- modeltime_table(
  m1$fitted_wflw,
  m2$fitted_wflw,
  m3$fitted_wflw
)

# Calibrate
calibrated <- models %>%
  modeltime_calibrate(testing(splits))

# Get accuracy
accuracy <- calibrated %>%
  modeltime_accuracy()

# Rank by RMSE
ranked <- ts_model_rank_tbl(
  .model_table = accuracy,
  .metric = "rmse",
  .ascending = TRUE
)

ranked
```

## Internal Utilities

These functions are used internally but may be useful:

### Tidy Evaluation Helpers

- Manage unquoted column names
- Handle tidy evaluation in functions

### Validation Functions

- Check input types
- Validate parameters
- Ensure data consistency

### Color Palettes

- `color_blind()` - Get colorblind-friendly palette
- `ts_scale_color_colorblind()` - ggplot2 color scale
- `ts_scale_fill_colorblind()` - ggplot2 fill scale

**Example:**
```r
library(ggplot2)

# Get palette
colors <- color_blind()

# Use in plot
data %>%
  ggplot(aes(x = date, y = value, color = group)) +
  geom_line() +
  ts_scale_color_colorblind()
```

## Best Practices

### 1. Use Utility Functions for Consistency

```r
# Instead of manual conversion
# data_tbl <- data.frame(...)

# Use utility
data_tbl <- ts_to_tbl(ts_object)
```

### 2. Leverage Date Helpers

```r
# For reporting periods
data %>%
  mutate(
    quarter_start = quarter_start(date),
    quarter_end = quarter_end(date)
  ) %>%
  group_by(quarter_start) %>%
  summarise(total = sum(value))
```

### 3. Extract Models for Flexibility

```r
# Build with boilerplate
model <- ts_auto_arima(...)

# Extract for custom use
wf <- ts_extract_auto_fitted_workflow(model)

# Use in ensemble or other workflows
```

### 4. Standardize Recipe Creation

```r
# Always start with auto recipe
recipe <- ts_auto_recipe(...)

# Then customize if needed
recipe <- recipe %>%
  step_additional_feature(...)
```

## Common Patterns

### Pattern 1: End-to-End Automation

```r
# Convert → Recipe → Model → Extract
data_tbl <- ts_to_tbl(ts_object)

recipe <- ts_auto_recipe(
  data_tbl,
  date_col,
  value,
  value ~ .
)

model <- ts_auto_arima(
  data_tbl,
  date_col,
  value,
  value ~ .,
  splits
)

workflow <- ts_extract_auto_fitted_workflow(model)
```

### Pattern 2: Model Comparison Pipeline

```r
# Fit multiple → Compare → Rank
models <- list(
  arima = ts_auto_arima(...),
  prophet = ts_auto_prophet_reg(...),
  xgboost = ts_auto_xgboost(...)
)

comparison <- ts_model_compare(models)

best_model <- comparison %>%
  filter(rmse == min(rmse))
```

### Pattern 3: Custom Tuning Workflow

```r
# Template → Customize → Tune
template <- ts_model_spec_tune_template("xgboost")

recipe <- ts_auto_recipe(...)

tuned <- ts_model_auto_tune(
  .model_spec = template,
  .recipe_spec = recipe,
  .splits_obj = splits,
  .grid_size = 30,
  .num_cores = 4
)
```

## See Also

- [Quick Start](Quick-Start.md) - Basic usage
- [Forecasting Models](Forecasting-Models.md) - Model functions
- [Statistical Functions](Statistical-Functions.md) - Analysis tools
- [Package Overview](Package-Overview.md) - Complete function list
