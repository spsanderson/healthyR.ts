# Frequently Asked Questions (FAQ)

Common questions and answers about using healthyR.ts.

## General Questions

### What is healthyR.ts?

healthyR.ts is an R package specifically designed for time series analysis and forecasting of hospital administrative and clinical data. It provides automated workflows, visualization tools, and statistical functions built on the tidymodels ecosystem.

### Is healthyR.ts free?

Yes! healthyR.ts is open-source software released under the MIT License. You can use it freely for both personal and commercial purposes.

### What R version do I need?

healthyR.ts requires R >= 3.3. We recommend using the latest version of R for best performance and compatibility.

### How is healthyR.ts different from other time series packages?

healthyR.ts is specifically designed for healthcare data and provides:
- One-function automated modeling workflows
- Healthcare-specific visualizations (calendar heatmaps, etc.)
- Integration with the tidymodels ecosystem
- 15 pre-configured forecasting models
- Focus on interpretability and ease of use

## Installation Issues

### Installation fails on Linux - what should I do?

Install system dependencies first:

```bash
# Ubuntu/Debian
sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev libgit2-dev

# Fedora/CentOS
sudo yum install libcurl-devel openssl-devel libxml2-devel libgit2-devel
```

Then install the package:
```r
install.packages("healthyR.ts")
```

### I get compilation errors on Windows - help!

Install Rtools from [CRAN](https://cran.r-project.org/bin/windows/Rtools/). Make sure to:
1. Download the version matching your R version
2. Install with "Add to PATH" option selected
3. Restart R/RStudio
4. Try installing again

### Package X fails to install as a dependency

Update all packages first:
```r
update.packages(ask = FALSE)
```

If specific packages fail, install them individually:
```r
install.packages("modeltime")
install.packages("timetk")
# Then try healthyR.ts again
install.packages("healthyR.ts")
```

## Data Preparation

### What format should my data be in?

Your data should be a data frame or tibble with at least:
- A date/datetime column (Date or POSIXct class)
- A numeric value column

Example:
```r
data <- data.frame(
  date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 365),
  value = rnorm(365, mean = 100)
)
```

### How do I handle missing dates?

Use `timetk::pad_by_time()` to fill in missing dates:

```r
library(timetk)

data_padded <- data %>%
  pad_by_time(
    .date_var = date,
    .by = "day",
    .fill_na_direction = "down"  # Or "up", "downup"
  )
```

### Should I remove outliers before modeling?

It depends:
- **Prophet models**: Robust to outliers, removal not necessary
- **ARIMA models**: Sensitive to outliers, consider removing or transforming
- **ML models (XGBoost, etc.)**: Generally robust, but extreme outliers can affect performance

Use visualization first:
```r
boxplot(data$value)
ts_qq_plot(data, date, value)
```

### How do I handle missing values?

Options:
1. **Remove** them (if few):
   ```r
   data %>% filter(!is.na(value))
   ```

2. **Impute** them:
   ```r
   library(tidyr)
   data %>% fill(value, .direction = "down")
   ```

3. **Use models that handle missing data** (e.g., Prophet)

## Modeling Questions

### Which model should I use?

Start with these guidelines:

**For seasonal data with clear patterns:**
- `ts_auto_prophet_reg()` - Best for multiple seasonalities
- `ts_auto_arima()` - Classic approach
- `ts_auto_exp_smoothing()` - Fast and simple

**For non-linear patterns:**
- `ts_auto_xgboost()` - High accuracy
- `ts_auto_nnetar()` - Neural network approach
- `ts_auto_mars()` - Interpretable non-linear

**For intermittent/sparse data:**
- `ts_auto_croston()` - Designed for this

**For quick baselines:**
- `ts_auto_lm()` - Simple linear
- `ts_auto_theta()` - Fast and effective

### Should I tune hyperparameters (`.tune = TRUE`)?

**Use `.tune = TRUE` when:**
- You need maximum accuracy
- You have computational resources
- You're fitting final production models

**Use `.tune = FALSE` when:**
- You're exploring/prototyping
- You need quick results
- Using simple models (ARIMA, LM, Theta)

### How long does tuning take?

Tuning time depends on:
- `.grid_size` - Larger = longer (default: 10)
- `.cv_slice_limit` - More slices = longer (default: 6)
- `.num_cores` - More cores = faster
- Model complexity

Typical times (on 1000 observations, `.grid_size = 10`):
- Fast models (LM, ARIMA): 1-5 minutes
- Medium models (Prophet, MARS): 5-15 minutes
- Slow models (XGBoost, SVM, NN): 15-60 minutes

Speed it up:
```r
ts_auto_xgboost(
  ...,
  .num_cores = 4,        # Use 4 cores
  .grid_size = 10,       # Smaller grid
  .cv_slice_limit = 3    # Fewer CV folds
)
```

### Can I use my own recipe?

No, boilerplate functions create recipes automatically. However, you can:

1. **Use workflow sets** for custom recipes:
   ```r
   my_recipe <- ts_auto_recipe(data, date_col, value_col, value ~ .)
   my_model <- arima_reg() %>% set_engine("auto_arima")
   my_wf <- workflow() %>% add_recipe(my_recipe) %>% add_model(my_model)
   ```

2. **Extract and modify** the auto-generated recipe:
   ```r
   auto_model <- ts_auto_arima(...)
   recipe <- auto_model$recipe_info
   # Inspect with recipe
   ```

### What if my model doesn't converge?

Try:
1. **Scale your data**:
   ```r
   data <- data %>% mutate(value = scale(value))
   ```

2. **Transform the response**:
   ```r
   data <- data %>% mutate(value = log(value + 1))
   ```

3. **Use different model**
4. **Check for data issues** (outliers, missing values)

### How do I forecast future values?

```r
library(modeltime)

# 1. Fit model
model <- ts_auto_arima(...)

# 2. Create future dates
future_dates <- data %>%
  future_frame(.date_var = date, .length_out = 12)

# 3. Forecast
forecast <- model$fitted_wflw %>%
  modeltime_forecast(
    new_data = future_dates,
    actual_data = data
  )

# 4. Visualize
plot_modeltime_forecast(forecast)
```

## Error Messages

### "Error: `.date_col` must be provided"

You forgot to specify the date column:
```r
# Wrong
ts_auto_arima(.data = data, .value_col = value, ...)

# Correct
ts_auto_arima(.data = data, .date_col = date, .value_col = value, ...)
```

### "Error: could not find function"

The package or function isn't loaded:
```r
library(healthyR.ts)
library(timetk)  # For time series helpers
library(modeltime)  # For forecasting
```

### "Error: object of type 'closure' is not subsettable"

You tried to subset a function. Check your variable names:
```r
# Wrong - forgot to call the function
data <- ts_random_walk  # This is the function itself

# Correct
data <- ts_random_walk()  # Call the function with ()
```

### "Warning: All models failed validation"

Your data might have issues:
```r
# Check for:
sum(is.na(data$value))  # Missing values
length(data$value) < 10  # Too few observations
class(data$date)  # Proper date class
```

## Performance Questions

### Can healthyR.ts handle large datasets?

Yes, but performance varies:
- **Small** (<1,000 rows): All models work well
- **Medium** (1,000-10,000 rows): Most models work, tune with `.grid_size = 5-10`
- **Large** (10,000-100,000 rows): Use simpler models or subsample
- **Very large** (>100,000 rows): Consider aggregation or parallel processing

### How can I speed up my analysis?

1. **Use parallel processing**:
   ```r
   ts_auto_xgboost(..., .num_cores = 4)
   ```

2. **Reduce tuning grid**:
   ```r
   ts_auto_prophet_reg(..., .grid_size = 5)
   ```

3. **Fewer CV folds**:
   ```r
   ts_auto_mars(..., .cv_slice_limit = 3)
   ```

4. **Skip tuning for quick models**:
   ```r
   ts_auto_arima(..., .tune = FALSE)
   ```

5. **Use simpler models first**:
   - Start with `ts_auto_lm()` or `ts_auto_theta()`
   - Move to complex models only if needed

### My R session crashes during modeling

Possible causes:
1. **Insufficient memory**: Close other applications
2. **Grid too large**: Reduce `.grid_size`
3. **Data too large**: Aggregate or sample
4. **Model complexity**: Try simpler model first

```r
# Safer approach for large data
model <- ts_auto_prophet_reg(
  ...,
  .tune = TRUE,
  .grid_size = 5,      # Smaller grid
  .cv_slice_limit = 2, # Fewer folds
  .num_cores = 2       # Moderate parallelism
)
```

## Visualization Questions

### How do I make plots interactive?

Many plotting functions have an `.interactive` parameter:
```r
ts_calendar_heatmap_plot(
  .data = data,
  .date_col = date,
  .value_col = value,
  .interactive = TRUE  # Returns plotly instead of ggplot2
)
```

### Can I customize the plots?

Yes! Most functions return ggplot2 objects that you can modify:
```r
p <- ts_calendar_heatmap_plot(
  .data = data,
  .date_col = date,
  .value_col = value,
  .interactive = FALSE
)

# Customize
p + 
  labs(title = "My Custom Title") +
  theme_minimal() +
  scale_fill_viridis_c()
```

### How do I save plots?

```r
# ggplot2 plots
p <- ts_vva_plot(data, date, value)
ggsave("my_plot.png", p, width = 10, height = 6)

# Interactive plotly plots
library(plotly)
p <- ts_calendar_heatmap_plot(..., .interactive = TRUE)
htmlwidgets::saveWidget(p, "my_plot.html")
```

## Getting Help

### Where can I find more examples?

1. **Package vignettes**:
   ```r
   browseVignettes("healthyR.ts")
   ```

2. **Function documentation**:
   ```r
   ?ts_auto_arima
   ?ts_calendar_heatmap_plot
   ```

3. **Package website**: https://www.spsanderson.com/healthyR.ts/

4. **GitHub examples**: https://github.com/spsanderson/healthyR.ts

### How do I report a bug?

1. Check [existing issues](https://github.com/spsanderson/healthyR.ts/issues)
2. Create a minimal reproducible example:
   ```r
   library(healthyR.ts)
   
   # Minimal data
   data <- data.frame(
     date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 100),
     value = rnorm(100)
   )
   
   # Code that fails
   result <- ts_auto_arima(...)  # Your error here
   ```
3. [Open a new issue](https://github.com/spsanderson/healthyR.ts/issues/new)
4. Include:
   - R version: `R.version.string`
   - Package version: `packageVersion("healthyR.ts")`
   - Error message
   - Reproducible example

### Can I request new features?

Absolutely! Open an issue on [GitHub](https://github.com/spsanderson/healthyR.ts/issues) with:
- Clear description of the feature
- Use case / motivation
- Example of how you'd like it to work

### How can I contribute?

See the [Contributing Guide](Contributing) for details on:
- Code contributions
- Documentation improvements
- Bug reports
- Feature requests

## Best Practices

### Should I check for stationarity?

Yes, especially for ARIMA models:
```r
# Test for stationarity
ts_adf_test(data, value)

# If non-stationary, try:
# 1. Differencing
data_diff <- data %>% mutate(value = c(NA, diff(value)))

# 2. Log transformation
data_log <- data %>% mutate(value = log(value))

# 3. Auto-stationarize
data_stat <- auto_stationarize(data, value)
```

### How should I split my data?

Use time-aware splitting:
```r
library(timetk)

# Single split
splits <- time_series_split(
  data,
  date_col,
  assess = 12,      # Last 12 periods for testing
  cumulative = TRUE
)

# For cross-validation
cv_splits <- time_series_cv(
  data,
  date_var = date_col,
  assess = 12,
  skip = 3,
  cumulative = TRUE,
  slice_limit = 6
)
```

### Should I transform my target variable?

Consider transformation if:
- **Variance increases with level**: Use `log()` or `sqrt()`
- **Heavy skewness**: Use Box-Cox transformation
- **Large scale differences**: Standardize with `scale()`

```r
# Log transformation
data %>% mutate(value = log(value + 1))  # +1 if zeros present

# Standardization
data %>% mutate(value = as.numeric(scale(value)))
```

### How many observations do I need?

Minimum recommendations:
- **Simple models** (LM, Theta): 30-50 observations
- **ARIMA**: 50-100 observations (2-3 seasonal cycles)
- **ML models** (XGBoost, NN): 100+ observations
- **With tuning**: 2x the above recommendations

For seasonal data: At least 2-3 full seasonal cycles.

## Common Misconceptions

### "More data always means better models"

Not necessarily. Quality > quantity. Having:
- Clean, consistent data
- Proper date formatting
- Handled missing values

...is more important than having millions of rows.

### "Complex models always outperform simple ones"

False. Often:
- Simple models (ARIMA, ETS) work well for classic patterns
- Complex models (XGBoost, NN) may overfit small datasets
- Start simple and add complexity only if needed

### "I should tune all hyperparameters"

Not always:
- Default parameters often work well
- Tuning adds computational cost
- For exploration, `.tune = FALSE` is fine
- Reserve tuning for final models

### "Forecast accuracy on training data matters most"

No! What matters is:
- **Test set performance** - How well it predicts unseen data
- **Out-of-sample accuracy** - Real-world performance
- **Cross-validation scores** - Robust evaluation

Always evaluate on held-out test data:
```r
calibration <- model$fitted_wflw %>%
  modeltime_calibrate(testing(splits))

calibration %>% modeltime_accuracy()  # Check test set RMSE, MAE, etc.
```

## Still Have Questions?

- **Email**: spsanderson@gmail.com
- **GitHub Issues**: https://github.com/spsanderson/healthyR.ts/issues
- **Stack Overflow**: Tag questions with `r` and `healthyr-ts`
