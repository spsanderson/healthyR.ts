# Troubleshooting Guide

Common problems and solutions when using healthyR.ts.

## Installation Issues

### Problem: Package installation fails

**Symptoms:**
```r
install.packages("healthyR.ts")
#> Error: installation of package 'healthyR.ts' had non-zero exit status
```

**Solutions:**

1. **Update R and packages:**
   ```r
   # Update R from CRAN
   # Then update all packages
   update.packages(ask = FALSE, checkBuilt = TRUE)
   ```

2. **Install system dependencies (Linux):**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install -y libcurl4-openssl-dev libssl-dev libxml2-dev
   
   # Fedora/CentOS
   sudo yum install libcurl-devel openssl-devel libxml2-devel
   ```

3. **Install Rtools (Windows):**
   - Download from https://cran.r-project.org/bin/windows/Rtools/
   - Match your R version
   - Add to PATH during installation

4. **Install Xcode Command Line Tools (macOS):**
   ```bash
   xcode-select --install
   ```

### Problem: Dependency version conflicts

**Symptoms:**
```r
#> Error: package 'X' required by 'healthyR.ts' is not available
```

**Solution:**
```r
# Remove and reinstall problematic package
remove.packages("modeltime")
install.packages("modeltime")

# Then install healthyR.ts
install.packages("healthyR.ts")
```

## Data Issues

### Problem: Date column not recognized

**Symptoms:**
```r
ts_auto_arima(.data = data, .date_col = date, ...)
#> Error: .date_col must be Date or POSIXct
```

**Solutions:**

1. **Check date class:**
   ```r
   class(data$date)
   #> [1] "character"  # Wrong!
   ```

2. **Convert to proper date:**
   ```r
   # From character
   data$date <- as.Date(data$date, format = "%Y-%m-%d")
   
   # From datetime
   data$date <- as.Date(data$datetime)
   
   # Verify
   class(data$date)
   #> [1] "Date"  # Correct!
   ```

### Problem: Missing values in data

**Symptoms:**
```r
ts_auto_arima(...)
#> Error: Missing values in .value_col
```

**Solutions:**

1. **Check for NAs:**
   ```r
   sum(is.na(data$value))
   ```

2. **Remove NAs:**
   ```r
   data_clean <- data %>% filter(!is.na(value))
   ```

3. **Impute NAs:**
   ```r
   library(tidyr)
   
   # Forward fill
   data$value <- fill(data, value, .direction = "down")$value
   
   # Linear interpolation
   library(zoo)
   data$value <- na.approx(data$value)
   ```

### Problem: Non-numeric value column

**Symptoms:**
```r
#> Error: .value_col must be numeric
```

**Solution:**
```r
# Check class
class(data$value)

# Convert to numeric
data$value <- as.numeric(data$value)

# Remove any conversion failures
data <- data %>% filter(!is.na(value))
```

### Problem: Duplicate dates

**Symptoms:**
```r
#> Error: Duplicate date values found
```

**Solution:**
```r
# Check for duplicates
data %>%
  group_by(date) %>%
  filter(n() > 1)

# Aggregate duplicates
data_clean <- data %>%
  group_by(date) %>%
  summarise(value = mean(value, na.rm = TRUE)) %>%
  ungroup()
```

## Modeling Issues

### Problem: Model fitting fails

**Symptoms:**
```r
model <- ts_auto_arima(...)
#> Error in fit: Model failed to converge
```

**Solutions:**

1. **Check data scale:**
   ```r
   # Scale to reasonable range
   data$value_scaled <- scale(data$value)
   
   # Or normalize
   data$value_norm <- (data$value - min(data$value)) / 
                      (max(data$value) - min(data$value))
   ```

2. **Transform data:**
   ```r
   # Log transform (for positive values)
   data$value_log <- log(data$value + 1)
   
   # Box-Cox transform
   library(forecast)
   lambda <- BoxCox.lambda(data$value)
   data$value_bc <- BoxCox(data$value, lambda)
   ```

3. **Try different model:**
   ```r
   # If ARIMA fails, try Prophet
   model <- ts_auto_prophet_reg(...)
   
   # Or simple linear model
   model <- ts_auto_lm(...)
   ```

### Problem: Tuning takes too long

**Symptoms:**
Code runs for hours without completing.

**Solutions:**

1. **Reduce grid size:**
   ```r
   model <- ts_auto_xgboost(
     ...,
     .grid_size = 5,  # Instead of 10 or 20
     .tune = TRUE
   )
   ```

2. **Reduce CV folds:**
   ```r
   model <- ts_auto_prophet_reg(
     ...,
     .cv_slice_limit = 2,  # Instead of 6
     .cv_assess = 6,       # Instead of 12
     .tune = TRUE
   )
   ```

3. **Use parallel processing:**
   ```r
   model <- ts_auto_xgboost(
     ...,
     .num_cores = 4,  # Use 4 cores
     .tune = TRUE
   )
   ```

4. **Skip tuning:**
   ```r
   model <- ts_auto_arima(
     ...,
     .tune = FALSE  # Use defaults
   )
   ```

### Problem: Out of memory error

**Symptoms:**
```r
#> Error: cannot allocate vector of size X Gb
```

**Solutions:**

1. **Aggregate data:**
   ```r
   # Daily to weekly
   library(lubridate)
   data_weekly <- data %>%
     mutate(week = floor_date(date, "week")) %>%
     group_by(week) %>%
     summarise(value = mean(value))
   ```

2. **Subsample:**
   ```r
   # Use every Nth row
   data_sample <- data[seq(1, nrow(data), by = 2), ]
   ```

3. **Increase memory limit (Windows):**
   ```r
   memory.limit(size = 8000)  # 8GB
   ```

4. **Use simpler model:**
   ```r
   # Instead of XGBoost
   model <- ts_auto_lm(...)  # Much less memory
   ```

### Problem: "All models failed" warning

**Symptoms:**
```r
#> Warning: All models failed in cross-validation
```

**Solutions:**

1. **Check data quality:**
   ```r
   # Summary statistics
   summary(data$value)
   
   # Check for:
   # - Outliers (use boxplot)
   # - Variance = 0 (use sd())
   # - Too few observations (use nrow())
   ```

2. **Check splits:**
   ```r
   # Ensure proper split
   library(timetk)
   
   splits <- time_series_split(
     data,
     date_col,
     assess = 12,
     cumulative = TRUE
   )
   
   # Check sizes
   nrow(training(splits))
   nrow(testing(splits))
   ```

3. **Try different model:**
   ```r
   # Some models need more data
   # Minimum recommendations:
   # - ARIMA: 50+ observations
   # - Prophet: 100+ observations
   # - Neural Network: 100+ observations
   # - XGBoost: 100+ observations
   ```

## Plotting Issues

### Problem: Plot is blank or empty

**Symptoms:**
```r
p <- ts_calendar_heatmap_plot(...)
print(p)
# Shows empty plot
```

**Solutions:**

1. **Check data:**
   ```r
   # Ensure data exists
   nrow(data)
   head(data)
   
   # Check date range
   range(data$date)
   ```

2. **Verify column names:**
   ```r
   # Ensure columns exist
   names(data)
   
   # Check for typos in column names
   "date_col" %in% names(data)
   ```

3. **Check value range:**
   ```r
   # Are all values the same?
   length(unique(data$value))
   
   # If so, add variation or use different plot
   ```

### Problem: Interactive plot doesn't show

**Symptoms:**
```r
p <- ts_calendar_heatmap_plot(..., .interactive = TRUE)
# Nothing displays
```

**Solutions:**

1. **Check environment:**
   ```r
   # RStudio: Should show in Viewer pane
   # R console: May not display, save instead
   
   library(htmlwidgets)
   saveWidget(p, "plot.html")
   browseURL("plot.html")
   ```

2. **Try static plot:**
   ```r
   p <- ts_calendar_heatmap_plot(..., .interactive = FALSE)
   print(p)
   ```

## Performance Issues

### Problem: Code runs slowly

**Solutions:**

1. **Profile your code:**
   ```r
   library(profvis)
   
   profvis({
     # Your slow code here
     model <- ts_auto_arima(...)
   })
   ```

2. **Optimize data size:**
   ```r
   # Remove unnecessary columns
   data_small <- data %>% select(date, value)
   
   # Aggregate if possible
   # Daily → Weekly
   ```

3. **Use vectorized operations:**
   ```r
   # Slow (loop)
   for (i in 1:nrow(data)) {
     data$new_col[i] <- some_function(data$value[i])
   }
   
   # Fast (vectorized)
   data$new_col <- some_function(data$value)
   ```

4. **Parallel processing:**
   ```r
   # For models
   model <- ts_auto_xgboost(..., .num_cores = 4)
   
   # For custom loops
   library(parallel)
   cl <- makeCluster(4)
   results <- parLapply(cl, data_list, function)
   stopCluster(cl)
   ```

## Function-Specific Issues

### ts_random_walk()

**Problem: Fewer walks than requested**

```r
df <- ts_random_walk(.num_walks = 1)
# Only generates 1 walk regardless of input
```

**Solution:**
```r
# Ensure .num_walks > 1
df <- ts_random_walk(.num_walks = 25)

# If still issues, check package version
packageVersion("healthyR.ts")
# Update if needed
```

### ts_feature_cluster()

**Problem: Clustering fails**

```r
#> Error in kmeans: NA/NaN/Inf in foreign function call
```

**Solutions:**

1. **Check for missing values:**
   ```r
   # Remove NAs before clustering
   data_complete <- data %>%
     group_by(series_id) %>%
     filter(!any(is.na(value))) %>%
     ungroup()
   ```

2. **Ensure sufficient data:**
   ```r
   # Each series needs minimum observations
   data_filtered <- data %>%
     group_by(series_id) %>%
     filter(n() >= 24) %>%
     ungroup()
   ```

3. **Scale features:**
   ```r
   # Always scale
   clusters <- ts_feature_cluster(
     ...,
     .scale = TRUE  # Important!
   )
   ```

### ts_auto_* functions

**Problem: `.date_col` error**

```r
#> Error: `.date_col` must be provided
```

**Solution:**
```r
# Don't quote column names
ts_auto_arima(
  .date_col = date,      # Correct
  # .date_col = "date",  # Wrong
  .value_col = value
)
```

## Error Messages Explained

### "could not find function"

**Cause:** Package not loaded

**Solution:**
```r
library(healthyR.ts)
library(timetk)  # If using time series helpers
library(modeltime)  # If using modeltime functions
```

### "object not found"

**Cause:** Variable doesn't exist

**Solution:**
```r
# Check variable names
ls()  # List all objects
names(data)  # Check data frame columns
```

### "non-numeric argument"

**Cause:** Function expects numbers but got characters

**Solution:**
```r
# Convert to numeric
data$value <- as.numeric(data$value)
```

### "subscript out of bounds"

**Cause:** Trying to access element that doesn't exist

**Solution:**
```r
# Check dimensions
nrow(data)
ncol(data)
length(vector)

# Ensure index is valid
if (i <= length(vector)) {
  result <- vector[i]
}
```

## Getting More Help

### Minimal Reproducible Example

When asking for help, provide:

```r
library(healthyR.ts)

# Minimal data
data <- data.frame(
  date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 100),
  value = rnorm(100)
)

# Code that fails
result <- ts_auto_arima(
  .data = data,
  .date_col = date,
  .value_col = value,
  .rsamp_obj = splits,
  .formula = value ~ .
)

#> Error message here
```

### Information to Include

1. **R version:**
   ```r
   R.version.string
   ```

2. **Package version:**
   ```r
   packageVersion("healthyR.ts")
   ```

3. **Session info:**
   ```r
   sessionInfo()
   ```

4. **Complete error message:**
   Copy the full error, including traceback

5. **What you expected:**
   Describe desired outcome

### Where to Get Help

1. **Check documentation:**
   ```r
   ?ts_auto_arima
   ```

2. **Search issues:**
   https://github.com/spsanderson/healthyR.ts/issues

3. **Browse vignettes:**
   ```r
   browseVignettes("healthyR.ts")
   ```

4. **Ask on Stack Overflow:**
   Tag with `r` and `healthyr-ts`

5. **Open GitHub issue:**
   https://github.com/spsanderson/healthyR.ts/issues/new

6. **Email maintainer:**
   spsanderson@gmail.com

## Prevention Tips

### 1. Always Validate Input

```r
# Before modeling
stopifnot(
  is.data.frame(data),
  "date" %in% names(data),
  "value" %in% names(data),
  is(data$date, "Date"),
  is.numeric(data$value),
  !any(is.na(data$value))
)
```

### 2. Start Simple

```r
# Test with small data first
data_test <- head(data, 100)

# Use simple model
model_test <- ts_auto_lm(
  .data = data_test,
  ...,
  .tune = FALSE
)

# If works, scale up
```

### 3. Check Output

```r
# After each step
result <- some_function(...)

# Verify
class(result)
names(result)
head(result)
```

### 4. Use Try-Catch

```r
# Prevent crashes
result <- tryCatch(
  {
    ts_auto_arima(...)
  },
  error = function(e) {
    message("ARIMA failed, trying Prophet")
    ts_auto_prophet_reg(...)
  }
)
```

### 5. Save Progress

```r
# Save intermediate results
saveRDS(model, "model.rds")

# Load if needed
model <- readRDS("model.rds")
```

## Debug Mode

Enable verbose output:

```r
options(warn = 1)  # Show warnings immediately

# For specific packages
Sys.setenv("TIDYMODELS_DEBUG" = "TRUE")
```

## Common Gotchas

1. **Forgetting to load packages**
2. **Quoting column names** (use unquoted)
3. **Not checking for NAs**
4. **Using wrong date format**
5. **Insufficient data for model**
6. **Not scaling features for clustering**
7. **Trying to tune models without tunable parameters**
8. **Not setting seed for reproducibility**

## See Also

- [FAQ](FAQ.md) - Frequently asked questions
- [Installation Guide](Installation-Guide.md) - Setup help
- [Quick Start](Quick-Start.md) - Basic usage
- [Contributing](Contributing.md) - Report bugs
