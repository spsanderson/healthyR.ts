# Data Generators

Functions for creating synthetic time series data for testing, simulation, and understanding time series behavior.

## Overview

Data generators in healthyR.ts allow you to:
- Create synthetic time series for testing algorithms
- Simulate market behavior or patient flow
- Generate training data when real data is unavailable
- Understand statistical properties of different processes
- Validate forecasting methods

## Random Walk

### `ts_random_walk()`

Generate random walk time series data.

**Usage:**
```r
ts_random_walk(
  .mean = 0.0,
  .sd = 0.10,
  .num_walks = 100,
  .periods = 100,
  .initial_value = 1000
)
```

**Parameters:**
- `.mean` - Mean of the random walk (default: 0.0)
- `.sd` - Standard deviation (default: 0.10)
- `.num_walks` - Number of random walks to generate (default: 100)
- `.periods` - Length of each walk (default: 100)
- `.initial_value` - Starting value (default: 1000)

**Returns:**
A tibble with columns:
- `run` - Walk identifier
- `x` - Time period
- `y` - Random increment
- `cum_y` - Cumulative value

**Example:**
```r
library(healthyR.ts)

# Generate 25 random walks over 180 periods
df <- ts_random_walk(
  .mean = 0,
  .sd = 0.05,
  .num_walks = 25,
  .periods = 180,
  .initial_value = 1000
)

# Visualize
library(ggplot2)
df %>%
  ggplot(aes(x = x, y = cum_y, color = factor(run), group = factor(run))) +
  geom_line(alpha = 0.8) +
  ts_random_walk_ggplot_layers(df) +
  theme_minimal() +
  labs(
    title = "Random Walk Simulation",
    subtitle = "25 walks over 180 periods",
    x = "Time Period",
    y = "Value"
  )
```

**Use Cases:**
- Simulating stock prices
- Modeling patient admission variability
- Testing forecasting algorithms
- Understanding market volatility

### Helper: `ts_random_walk_ggplot_layers()`

Add standard layers to random walk plots.

```r
ts_random_walk_ggplot_layers(.data)
```

Automatically adds:
- Appropriate theme
- Title and labels
- Legend formatting

## Brownian Motion

### `ts_brownian_motion()`

Generate standard Brownian motion (Wiener process).

**Usage:**
```r
ts_brownian_motion(
  .num_sims = 25,
  .time = 25,
  .initial_value = 100,
  .delta_time = 1,
  .mean = 0,
  .variance = 1
)
```

**Parameters:**
- `.num_sims` - Number of simulations
- `.time` - Time periods to simulate
- `.initial_value` - Starting value
- `.delta_time` - Time step size
- `.mean` - Drift parameter
- `.variance` - Volatility parameter

**Returns:**
A tibble with:
- `sim_number` - Simulation identifier
- `t` - Time point
- `y` - Value at time t

**Example:**
```r
# Generate Brownian motion
bm <- ts_brownian_motion(
  .num_sims = 50,
  .time = 100,
  .initial_value = 100,
  .delta_time = 0.1
)

# Plot
bm %>%
  ggplot(aes(x = t, y = y, group = sim_number, color = sim_number)) +
  geom_line(alpha = 0.6) +
  theme_minimal() +
  theme(legend.position = "none")
```

**Attributes:**
The output has a `.motion_type` attribute set to `"standard"`.

```r
attr(bm, ".motion_type")
#> [1] "standard"
```

### `ts_brownian_motion_augment()`

Augment existing data with Brownian motion calculations.

```r
ts_brownian_motion_augment(.data, .value, .time, .delta_time = 1)
```

### `ts_brownian_motion_plot()`

Create a visualization of Brownian motion.

```r
ts_brownian_motion_plot(.data, .date_col, .value_col, .interactive = FALSE)
```

**Example:**
```r
# Generate and plot in one go
bm <- ts_brownian_motion(.num_sims = 25, .time = 100)

ts_brownian_motion_plot(
  .data = bm,
  .date_col = t,
  .value_col = y,
  .interactive = TRUE  # For interactive plotly
)
```

## Geometric Brownian Motion

### `ts_geometric_brownian_motion()`

Generate geometric Brownian motion - commonly used in financial modeling.

**Usage:**
```r
ts_geometric_brownian_motion(
  .num_sims = 25,
  .time = 25,
  .initial_value = 100,
  .delta_time = 1,
  .mu = 0.05,     # Drift (expected return)
  .sigma = 0.10   # Volatility
)
```

**Parameters:**
- `.num_sims` - Number of simulations
- `.time` - Time periods
- `.initial_value` - Starting value (S₀)
- `.delta_time` - Time increment
- `.mu` - Drift coefficient (expected return)
- `.sigma` - Diffusion coefficient (volatility)

**Mathematical Model:**
```
dS = μS dt + σS dW
```
Where:
- S = asset price
- μ = drift
- σ = volatility
- dW = Brownian motion increment

**Returns:**
A tibble with columns similar to standard Brownian motion.

**Example:**
```r
# Model stock price with 5% drift and 20% volatility
gbm <- ts_geometric_brownian_motion(
  .num_sims = 100,
  .time = 252,        # Trading days in a year
  .initial_value = 100,
  .delta_time = 1/252,
  .mu = 0.05,         # 5% expected return
  .sigma = 0.20       # 20% volatility
)

# Calculate summary statistics
library(dplyr)
gbm %>%
  filter(t == max(t)) %>%
  summarise(
    mean_final = mean(y),
    sd_final = sd(y),
    min_final = min(y),
    max_final = max(y)
  )
```

**Attributes:**
The output has a `.motion_type` attribute set to `"geometric"`.

### `ts_geometric_brownian_motion_augment()`

Augment data with geometric Brownian motion calculations.

```r
ts_geometric_brownian_motion_augment(
  .data,
  .value,
  .time,
  .delta_time = 1,
  .mu = 0,
  .sigma = 1
)
```

## ARIMA Simulation

### `ts_arima_simulator()`

Simulate ARIMA(p,d,q) time series with various parameters.

**Usage:**
```r
ts_arima_simulator(
  .n = 100,
  .mean = 0,
  .sd = 1,
  .ar = c(0, 0, 0),
  .ma = c(0, 0, 0),
  .order = c(0, 0, 0),
  .include.mean = FALSE,
  .num_sims = 10
)
```

**Parameters:**
- `.n` - Length of time series
- `.mean` - Mean of the series
- `.sd` - Standard deviation
- `.ar` - AR coefficients (p terms)
- `.ma` - MA coefficients (q terms)
- `.order` - ARIMA order c(p, d, q)
- `.include.mean` - Include mean in model
- `.num_sims` - Number of simulations

**Returns:**
A list containing:
- `data` - Tibble with simulated data
- `plots$static_plot` - ggplot2 visualization
- `plots$interactive_plot` - plotly visualization
- Model parameters and metadata

**Example 1: AR(1) Process**
```r
# Simulate AR(1) with coefficient 0.7
ar1_sim <- ts_arima_simulator(
  .n = 200,
  .mean = 100,
  .sd = 10,
  .ar = c(0.7),
  .order = c(1, 0, 0),
  .num_sims = 50
)

# View the plot
ar1_sim$plots$static_plot

# Access the data
head(ar1_sim$data)
```

**Example 2: ARIMA(1,1,1) Process**
```r
# Simulate ARIMA(1,1,1)
arima111 <- ts_arima_simulator(
  .n = 200,
  .ar = c(0.5),
  .ma = c(0.3),
  .order = c(1, 1, 1),
  .num_sims = 25
)

arima111$plots$interactive_plot
```

**Example 3: Moving Average MA(2)**
```r
# Simulate MA(2)
ma2_sim <- ts_arima_simulator(
  .n = 150,
  .ma = c(0.6, 0.3),
  .order = c(0, 0, 2),
  .num_sims = 30
)
```

## Comparison of Generators

| Generator | Best For | Key Parameter | Output Type |
|-----------|----------|---------------|-------------|
| `ts_random_walk()` | Market volatility, general uncertainty | `.sd` | Tibble |
| `ts_brownian_motion()` | Diffusion processes, random movement | `.variance` | Tibble |
| `ts_geometric_brownian_motion()` | Stock prices, growth processes | `.mu`, `.sigma` | Tibble |
| `ts_arima_simulator()` | Testing forecasting models | `.ar`, `.ma` | List with plots |

## Common Patterns

### Pattern 1: Testing Forecast Accuracy

```r
# Generate known ARIMA process
true_model <- ts_arima_simulator(
  .n = 200,
  .ar = c(0.7, -0.3),
  .order = c(2, 0, 0),
  .num_sims = 1
)

# Extract data
test_data <- true_model$data %>%
  filter(sim_number == 1) %>%
  select(x, y) %>%
  rename(date = x, value = y)

# Now fit models and compare accuracy
# (models should recover similar AR parameters)
```

### Pattern 2: Monte Carlo Risk Analysis

```r
# Simulate 1000 price paths
price_paths <- ts_geometric_brownian_motion(
  .num_sims = 1000,
  .time = 252,
  .initial_value = 100,
  .mu = 0.07,
  .sigma = 0.25
)

# Calculate Value at Risk (VaR)
var_95 <- price_paths %>%
  filter(t == max(t)) %>%
  summarise(var = quantile(y, 0.05)) %>%
  pull(var)

cat("95% VaR:", 100 - var_95, "\n")
```

### Pattern 3: Volatility Analysis

```r
# Compare different volatility scenarios
low_vol <- ts_random_walk(.sd = 0.05, .num_walks = 50, .periods = 100)
high_vol <- ts_random_walk(.sd = 0.15, .num_walks = 50, .periods = 100)

# Calculate ending value distributions
low_vol_final <- low_vol %>% filter(x == 100) %>% pull(cum_y)
high_vol_final <- high_vol %>% filter(x == 100) %>% pull(cum_y)

# Compare standard deviations
sd(low_vol_final)
sd(high_vol_final)
```

## Tips and Best Practices

### 1. Choose Appropriate Parameters

```r
# For realistic stock data
ts_geometric_brownian_motion(
  .mu = 0.07,      # ~7% annual return
  .sigma = 0.20    # 20% volatility (typical for stocks)
)

# For more stable processes (e.g., treasury yields)
ts_geometric_brownian_motion(
  .mu = 0.03,
  .sigma = 0.05
)
```

### 2. Set Seeds for Reproducibility

```r
set.seed(123)
df1 <- ts_random_walk(.num_walks = 10)

set.seed(123)
df2 <- ts_random_walk(.num_walks = 10)

identical(df1, df2)  # TRUE
```

### 3. Validate Generated Data

```r
# Check properties match parameters
sim_data <- ts_arima_simulator(
  .n = 1000,
  .mean = 100,
  .sd = 10,
  .order = c(0, 0, 0),
  .num_sims = 1
)

# Should be close to specified values
mean(sim_data$data$y)  # ≈ 100
sd(sim_data$data$y)    # ≈ 10
```

### 4. Use Appropriate Simulation Size

```r
# For quick testing
quick_sim <- ts_brownian_motion(.num_sims = 10, .time = 50)

# For robust analysis
robust_sim <- ts_brownian_motion(.num_sims = 1000, .time = 100)

# For visualization
viz_sim <- ts_brownian_motion(.num_sims = 25, .time = 200)
```

## See Also

- [Statistical Functions](Statistical-Functions) - Analyze generated data
- [Visualization Functions](Visualization-Functions) - Plot simulations
- [ARIMA Tutorial](ARIMA-Tutorial) - Learn about ARIMA processes
- [Random Walk Tutorial](Random-Walk-Tutorial) - Detailed random walk guide
