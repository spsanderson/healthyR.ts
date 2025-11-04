# Clustering Functions

Guide to time series clustering and feature-based analysis in healthyR.ts.

## Overview

Time series clustering in healthyR.ts uses feature-based methods to group similar time series together. Instead of clustering raw values, it:
1. Extracts statistical features from each series
2. Clusters based on these features
3. Groups similar temporal patterns

**Key Functions:**
- `ts_feature_cluster()` - Perform clustering
- `ts_feature_cluster_plot()` - Visualize clusters

## Feature-Based Clustering

### `ts_feature_cluster()`

Cluster time series based on extracted features.

**Usage:**
```r
ts_feature_cluster(
  .data,
  .date_col,
  .value_col,
  ...,
  .features = c("acf_features", "entropy"),
  .scale = TRUE,
  .prefix = "ts_",
  .centers = 3
)
```

**Parameters:**
- `.data` - Data frame/tibble with multiple time series
- `.date_col` - Date column (unquoted)
- `.value_col` - Value column (unquoted)
- `...` - Grouping variables (one or more columns identifying different series)
- `.features` - Feature sets to extract
- `.scale` - Scale features before clustering (recommended)
- `.prefix` - Prefix for feature names
- `.centers` - Number of clusters

**Available Feature Sets:**
- `"acf_features"` - Autocorrelation features
- `"entropy"` - Spectral entropy
- `"stl_features"` - STL decomposition features
- `"heterogeneity"` - Heterogeneity measures
- `"nonlinearity"` - Non-linearity tests
- `"pacf_features"` - Partial autocorrelation features
- `"stability"` - Stability features
- `"lumpiness"` - Lumpiness measures

**Returns:**
Original data augmented with:
- Cluster assignments
- Feature values
- Scaled features (if `.scale = TRUE`)

**Example 1: Basic Clustering**
```r
library(healthyR.ts)
library(dplyr)

# Prepare data with groups
data_grouped <- ts_to_tbl(AirPassengers) %>%
  mutate(
    group_id = rep(1:12, 12),  # 12 groups (months)
    series_id = paste0("series_", group_id)
  )

# Perform clustering
clusters <- ts_feature_cluster(
  .data = data_grouped,
  .date_col = date_col,
  .value_col = value,
  group_id,  # Group by this column
  .features = c("acf_features", "entropy"),
  .scale = TRUE,
  .centers = 3
)

# View cluster assignments
clusters %>%
  select(group_id, cluster) %>%
  distinct()
```

**Example 2: Multiple Feature Sets**
```r
# Use multiple feature types
clusters_advanced <- ts_feature_cluster(
  .data = data_grouped,
  .date_col = date_col,
  .value_col = value,
  group_id,
  .features = c(
    "acf_features",
    "entropy",
    "stl_features",
    "heterogeneity"
  ),
  .scale = TRUE,
  .centers = 4
)

# Examine cluster characteristics
clusters_advanced %>%
  group_by(cluster) %>%
  summarise(
    n_series = n_distinct(group_id),
    mean_value = mean(value),
    sd_value = sd(value)
  )
```

**Example 3: Hospital Departments**
```r
# Cluster different hospital departments
hospital_data <- data.frame(
  date = rep(seq.Date(as.Date("2020-01-01"), by = "day", length.out = 365), 5),
  department = rep(c("ER", "ICU", "Surgery", "Cardiology", "Pediatrics"), each = 365),
  admissions = c(
    rnorm(365, mean = 50, sd = 10),  # ER
    rnorm(365, mean = 20, sd = 5),   # ICU
    rnorm(365, mean = 15, sd = 3),   # Surgery
    rnorm(365, mean = 25, sd = 7),   # Cardiology
    rnorm(365, mean = 30, sd = 8)    # Pediatrics
  )
)

# Cluster departments by admission patterns
dept_clusters <- ts_feature_cluster(
  .data = hospital_data,
  .date_col = date,
  .value_col = admissions,
  department,  # Cluster by department
  .features = c("acf_features", "entropy", "stl_features"),
  .centers = 3
)

# Which departments are similar?
dept_clusters %>%
  select(department, cluster) %>%
  distinct() %>%
  arrange(cluster)
```

## Visualization

### `ts_feature_cluster_plot()`

Visualize time series within a cluster.

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

**Returns:**
ggplot2 object showing all series in the specified cluster

**Example:**
```r
# Cluster the data
clusters <- ts_feature_cluster(
  .data = data_grouped,
  .date_col = date_col,
  .value_col = value,
  group_id,
  .features = c("acf_features", "entropy"),
  .centers = 3
)

# Plot each cluster
ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 1,
  group_id
)

ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 2,
  group_id
)

ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 3,
  group_id
)
```

**Customize the Plot:**
```r
library(ggplot2)

p <- ts_feature_cluster_plot(
  .data = clusters,
  .date_col = date_col,
  .value_col = value,
  .center = 1,
  group_id
)

# Customize
p +
  labs(
    title = "Cluster 1: High Variance Series",
    subtitle = "Similar temporal patterns",
    x = "Date",
    y = "Value"
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")
```

## Feature Explanations

### ACF Features (`"acf_features"`)

Autocorrelation function features measure temporal dependencies:

- **First autocorrelation** - Correlation with lag 1
- **Sum of squared ACF** - Overall autocorrelation strength
- **ACF at specific lags** - Correlations at different time lags

**Interpretation:**
- High ACF → Strong temporal structure
- Low ACF → More random/white noise
- Periodic ACF → Seasonality

### Entropy (`"entropy"`)

Spectral entropy measures signal regularity:

**Range**: 0 (perfectly regular) to 1 (completely random)

**Interpretation:**
- Low entropy (< 0.3) → Highly predictable, strong patterns
- Medium entropy (0.3-0.7) → Mix of signal and noise
- High entropy (> 0.7) → Mostly random, little structure

### STL Features (`"stl_features"`)

Seasonal-Trend-Loess decomposition features:

- **Trend strength** - How strong is the trend component
- **Seasonal strength** - How strong is seasonality
- **Seasonal period** - Length of seasonal cycle
- **Linearity** - How linear is the trend

**Interpretation:**
- High trend strength → Strong directional movement
- High seasonal strength → Clear periodic patterns
- Low seasonal strength → Weak or no seasonality

### Heterogeneity (`"heterogeneity"`)

Measures of variance heterogeneity:

- **Arch effect** - Changing variance over time
- **GARCH effect** - Volatility clustering

**Interpretation:**
- High heterogeneity → Variance changes over time
- Low heterogeneity → Constant variance

### Other Features

- **Non-linearity** - Tests for non-linear dynamics
- **PACF features** - Partial autocorrelations
- **Stability** - Measure of local stability
- **Lumpiness** - Variance of block variances

## Practical Examples

### Example 1: Patient Flow Clustering

```r
library(healthyR.ts)
library(dplyr)

# Simulate patient flow for different units
set.seed(123)

patient_data <- expand.grid(
  date = seq.Date(as.Date("2020-01-01"), by = "day", length.out = 365),
  unit = c("ER", "ICU", "Med-Surg", "Pediatrics", "Maternity")
) %>%
  mutate(
    # Different patterns for different units
    patients = case_when(
      unit == "ER" ~ rpois(n(), lambda = 50 + 10 * sin(2*pi*as.numeric(date)/7)),
      unit == "ICU" ~ rpois(n(), lambda = 20 + 5 * sin(2*pi*as.numeric(date)/30)),
      unit == "Med-Surg" ~ rpois(n(), lambda = 40 + 8 * sin(2*pi*as.numeric(date)/7)),
      unit == "Pediatrics" ~ rpois(n(), lambda = 25 + 15 * sin(2*pi*as.numeric(date)/365)),
      unit == "Maternity" ~ rpois(n(), lambda = 15 + 3 * sin(2*pi*as.numeric(date)/30))
    )
  )

# Cluster units by patient flow patterns
flow_clusters <- ts_feature_cluster(
  .data = patient_data,
  .date_col = date,
  .value_col = patients,
  unit,
  .features = c("acf_features", "entropy", "stl_features"),
  .scale = TRUE,
  .centers = 3
)

# Identify cluster characteristics
flow_clusters %>%
  select(unit, cluster) %>%
  distinct() %>%
  arrange(cluster)

# Visualize each cluster
for (i in 1:3) {
  p <- ts_feature_cluster_plot(
    .data = flow_clusters,
    .date_col = date,
    .value_col = patients,
    .center = i,
    unit
  ) +
    ggtitle(paste("Cluster", i))
  
  print(p)
}
```

### Example 2: Seasonal Pattern Detection

```r
# Generate series with different seasonal patterns
seasonal_data <- expand.grid(
  date = seq.Date(as.Date("2018-01-01"), by = "day", length.out = 1095),
  series = paste0("S", 1:6)
) %>%
  mutate(
    value = case_when(
      series == "S1" ~ 100 + 20*sin(2*pi*as.numeric(date)/7),      # Weekly
      series == "S2" ~ 100 + 20*sin(2*pi*as.numeric(date)/30),     # Monthly
      series == "S3" ~ 100 + 20*sin(2*pi*as.numeric(date)/365),    # Yearly
      series == "S4" ~ 100 + 10*sin(2*pi*as.numeric(date)/7) + 
                       10*sin(2*pi*as.numeric(date)/30),           # Mixed
      series == "S5" ~ 100 + rnorm(n(), 0, 5),                     # Random
      series == "S6" ~ 100 + as.numeric(date - min(date))/10       # Trend only
    )
  )

# Cluster by seasonal patterns
seasonal_clusters <- ts_feature_cluster(
  .data = seasonal_data,
  .date_col = date,
  .value_col = value,
  series,
  .features = c("stl_features", "acf_features", "entropy"),
  .scale = TRUE,
  .centers = 4
)

# Which series have similar seasonality?
seasonal_clusters %>%
  select(series, cluster) %>%
  distinct() %>%
  arrange(cluster)

# Extract feature importance
seasonal_clusters %>%
  group_by(cluster) %>%
  summarise(
    avg_trend = mean(ts_trend, na.rm = TRUE),
    avg_seasonal = mean(ts_seasonal, na.rm = TRUE),
    avg_entropy = mean(ts_entropy, na.rm = TRUE)
  )
```

### Example 3: Anomalous Series Detection

```r
# Generate mostly normal series with some anomalies
set.seed(456)

mixed_data <- expand.grid(
  date = seq.Date(as.Date("2020-01-01"), by = "week", length.out = 52),
  series = paste0("Series", 1:20)
) %>%
  mutate(
    # Most series are similar
    value = rnorm(n(), mean = 100, sd = 10),
    # Add seasonality to most
    value = ifelse(
      series %in% paste0("Series", 1:15),
      value + 20*sin(2*pi*as.numeric(date)/365),
      value
    ),
    # Make a few series anomalous
    value = ifelse(
      series %in% c("Series16", "Series17"),
      value * 3,  # Very high variance
      value
    ),
    value = ifelse(
      series == "Series18",
      value + as.numeric(date - min(date))/2,  # Strong trend
      value
    )
  )

# Cluster to identify anomalies
mixed_clusters <- ts_feature_cluster(
  .data = mixed_data,
  .date_col = date,
  .value_col = value,
  series,
  .features = c("acf_features", "entropy", "heterogeneity"),
  .scale = TRUE,
  .centers = 3
)

# Find small clusters (potential anomalies)
cluster_sizes <- mixed_clusters %>%
  group_by(cluster) %>%
  summarise(n_series = n_distinct(series)) %>%
  arrange(n_series)

# Series in smallest cluster (likely anomalous)
anomalous_cluster <- cluster_sizes$cluster[1]

anomalous_series <- mixed_clusters %>%
  filter(cluster == anomalous_cluster) %>%
  distinct(series)

print(anomalous_series)

# Visualize anomalous cluster
ts_feature_cluster_plot(
  .data = mixed_clusters,
  .date_col = date,
  .value_col = value,
  .center = anomalous_cluster,
  series
) +
  ggtitle("Anomalous Series")
```

## Choosing Number of Clusters

### Method 1: Elbow Method

```r
library(purrr)

# Try different numbers of clusters
k_values <- 2:10

cluster_results <- map_df(k_values, function(k) {
  result <- ts_feature_cluster(
    .data = data_grouped,
    .date_col = date_col,
    .value_col = value,
    group_id,
    .features = c("acf_features", "entropy"),
    .centers = k
  )
  
  # Calculate within-cluster sum of squares
  # (would need to extract from clustering object)
  tibble(k = k)
})

# Plot elbow curve (simplified)
```

### Method 2: Domain Knowledge

```r
# If you know there are 3 types of patterns:
# - High volume, high variance
# - Medium volume, stable
# - Low volume, trending

clusters <- ts_feature_cluster(
  ...,
  .centers = 3  # Based on domain knowledge
)
```

### Method 3: Silhouette Analysis

```r
library(cluster)

# Extract features
features <- clusters %>%
  select(starts_with("ts_")) %>%
  select(-cluster)

# Calculate silhouette
sil <- silhouette(clusters$cluster, dist(features))

# Average silhouette width
mean(sil[, "sil_width"])
#> Higher is better (max 1)
```

## Best Practices

### 1. Scale Features

```r
# Always scale when features have different ranges
clusters <- ts_feature_cluster(
  ...,
  .scale = TRUE  # Essential!
)
```

### 2. Choose Appropriate Features

```r
# For seasonal patterns
.features = c("stl_features", "acf_features")

# For volatility/variance
.features = c("heterogeneity", "entropy")

# For general clustering
.features = c("acf_features", "entropy", "stl_features")
```

### 3. Validate Clusters

```r
# After clustering, inspect each cluster
for (i in 1:n_clusters) {
  p <- ts_feature_cluster_plot(
    .data = clusters,
    .date_col = date_col,
    .value_col = value,
    .center = i,
    group_id
  )
  print(p)
}

# Check if clusters make sense
```

### 4. Handle Multiple Series

```r
# Ensure each series is complete
data_clean <- data %>%
  group_by(series_id) %>%
  filter(n() == max_length) %>%  # Same length for all
  ungroup()

# Then cluster
clusters <- ts_feature_cluster(
  .data = data_clean,
  ...,
  series_id
)
```

## Common Patterns

### Pattern 1: Cluster-Specific Models

```r
# Fit different models for different clusters
library(modeltime)

clusters <- ts_feature_cluster(...)

# Get cluster assignments
cluster_map <- clusters %>%
  select(group_id, cluster) %>%
  distinct()

# Fit models by cluster
models_by_cluster <- cluster_map %>%
  group_by(cluster) %>%
  group_map(~ {
    cluster_data <- clusters %>%
      filter(cluster == .y$cluster)
    
    # Fit appropriate model for this cluster
    ts_auto_arima(
      .data = cluster_data,
      ...
    )
  })
```

### Pattern 2: Segmentation for Targeted Analysis

```r
# Segment customers/patients by behavior
segments <- ts_feature_cluster(...)

# Analyze each segment
segment_summary <- segments %>%
  group_by(cluster) %>%
  summarise(
    n = n_distinct(customer_id),
    avg_value = mean(value),
    growth_rate = (last(value) - first(value)) / first(value)
  )

# Target interventions by segment
```

## Troubleshooting

### Issue: All series in one cluster

**Cause**: Insufficient variation or too few clusters

**Solution**:
```r
# Increase number of clusters
.centers = 5  # Instead of 3

# Or use more discriminating features
.features = c("acf_features", "entropy", "stl_features", "heterogeneity")
```

### Issue: Clustering seems random

**Cause**: Features not informative or not scaled

**Solution**:
```r
# Ensure scaling
.scale = TRUE

# Try different feature sets
.features = c("stl_features", "heterogeneity")
```

### Issue: Error with feature extraction

**Cause**: Series too short or irregular

**Solution**:
```r
# Filter short series
data_clean <- data %>%
  group_by(series_id) %>%
  filter(n() >= 24) %>%  # At least 24 observations
  ungroup()
```

## See Also

- [Statistical Functions](Statistical-Functions.md) - Feature extraction details
- [Visualization Functions](Visualization-Functions.md) - Plotting clusters
- [Data Generators](Data-Generators.md) - Generate test data
- [Quick Start](Quick-Start.md) - Basic examples
