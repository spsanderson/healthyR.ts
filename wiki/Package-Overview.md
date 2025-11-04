# Package Overview

A comprehensive guide to the structure and organization of **healthyR.ts**.

## What is healthyR.ts?

**healthyR.ts** is a comprehensive R package designed specifically for time series analysis and forecasting of hospital administrative and clinical data. Built on the powerful [tidymodels](https://www.tidymodels.org/) ecosystem, it provides a consistent, user-friendly framework that simplifies complex time series workflows.

## Philosophy and Design

### Core Principles

1. **Consistency**: All functions follow consistent naming conventions and argument structures
2. **Tidyverse Integration**: Seamless integration with tidyverse packages (dplyr, ggplot2, etc.)
3. **Automation**: One-function solutions for complete modeling pipelines
4. **Flexibility**: Options for both automated and manual control
5. **Reproducibility**: Built-in support for reproducible analyses

### Function Naming Convention

Functions in healthyR.ts follow a consistent naming pattern:

- `ts_*` - Core time series functions
- `ts_auto_*` - Automated modeling workflows (boilerplate functions)
- `ts_wfs_*` - Workflow set functions
- `*_augment()` - Add features to existing data
- `*_vec()` - Vectorized operations
- `step_ts_*` - Custom recipe steps
- `*_plot()` / `*_plt()` - Visualization functions
- `util_*` - Utility functions

## Package Structure

### 90+ Functions Organized into 9 Categories

#### 1. Data Generators
Functions for creating synthetic time series data:

- **Random Walks**: `ts_random_walk()`
- **Brownian Motion**: `ts_brownian_motion()`, `ts_geometric_brownian_motion()`
- **ARIMA Simulation**: `ts_arima_simulator()`
- **Augmentation**: `ts_brownian_motion_augment()`, `ts_geometric_brownian_motion_augment()`

#### 2. Plotting Functions
Comprehensive visualization suite:

- **Calendar Heatmaps**: `ts_calendar_heatmap_plot()`
- **Moving Averages**: `ts_ma_plot()`, `ts_sma_plot()`
- **Diagnostics**: `ts_qq_plot()`, `ts_scedacity_scatter_plot()`
- **Event Analysis**: `ts_event_analysis_plot()`
- **Velocity/Acceleration**: `ts_vva_plot()`
- **Clustering**: `ts_feature_cluster_plot()`
- **Time Series Splits**: `ts_splits_plot()`
- **Helper Layers**: `ts_random_walk_ggplot_layers()`, `ts_brownian_motion_plot()`

#### 3. Clustering Functions
Feature-based time series clustering:

- **Clustering**: `ts_feature_cluster()`
- **Visualization**: `ts_feature_cluster_plot()`

#### 4. Forecasting Functions
Automated modeling workflows (15 models):

**ARIMA Family:**
- `ts_auto_arima()` - Automatic ARIMA
- `ts_auto_arima_xgboost()` - ARIMA with XGBoost errors

**Prophet:**
- `ts_auto_prophet_reg()` - Facebook's Prophet
- `ts_auto_prophet_boost()` - Prophet with XGBoost

**Machine Learning:**
- `ts_auto_xgboost()` - Gradient boosting
- `ts_auto_nnetar()` - Neural network autoregression
- `ts_auto_lm()` - Linear regression
- `ts_auto_mars()` - MARS (Multivariate Adaptive Regression Splines)
- `ts_auto_glmnet()` - Elastic net regression
- `ts_auto_svm_poly()` - SVM with polynomial kernel
- `ts_auto_svm_rbf()` - SVM with radial kernel

**Statistical Models:**
- `ts_auto_exp_smoothing()` - Exponential smoothing
- `ts_auto_smooth_es()` - Smooth package ETS
- `ts_auto_theta()` - Theta method
- `ts_auto_croston()` - Croston's method (intermittent demand)

**Supporting Functions:**
- `ts_forecast_simulator()` - Forecast simulation
- `ts_model_compare()` - Compare models
- `ts_model_rank_tbl()` - Rank models by accuracy
- `ts_extract_auto_fitted_workflow()` - Extract workflows

#### 5. Statistical Functions
Tests, transformations, and analysis:

**Stationarity:**
- `ts_adf_test()` - Augmented Dickey-Fuller test
- `auto_stationarize()` - Automatic stationarization

**Transformations:**
- `util_log_ts()` - Log transformation
- `util_singlediff_ts()` - First difference
- `util_doublediff_ts()` - Second difference
- `util_difflog_ts()` - Difference of log
- `util_doubledifflog_ts()` - Second difference of log

**Analysis:**
- `tidy_fft()` - Fast Fourier Transform
- `ci_hi()` / `ci_lo()` - Confidence intervals
- `ts_lag_correlation()` - Lag correlation analysis
- `ts_info_tbl()` - Time series information table

#### 6. Utility Functions
Helper functions for data manipulation:

**Data Transformation:**
- `ts_to_tbl()` - Convert ts objects to tibbles
- `ts_compare_data()` - Compare time series

**Time Helpers:**
- `month_start()`, `month_end()`
- `quarter_start()`, `quarter_end()`
- `year_start()`, `year_end()`

**Workflow Helpers:**
- `ts_auto_recipe()` - Automatic recipe creation
- `model_extraction_helper()` - Extract model components
- `calibrate_and_plot()` - Calibrate and visualize
- `get_recipe_call()` - Get recipe details

**Model Tuning:**
- `ts_model_auto_tune()` - Automatic model tuning
- `ts_model_spec_tune_template()` - Tuning templates

#### 7. Augment Functions
Add features to existing data:

- `ts_velocity_augment()` - Rate of change
- `ts_acceleration_augment()` - Second derivative
- `ts_growth_rate_augment()` - Growth rate

#### 8. Vector Functions
Vectorized operations:

- `ts_velocity_vec()` - Velocity calculation
- `ts_acceleration_vec()` - Acceleration calculation
- `ts_growth_rate_vec()` - Growth rate calculation

#### 9. Recipe Steps
Custom tidymodels recipe steps:

- `step_ts_velocity()` - Add velocity as feature
- `step_ts_acceleration()` - Add acceleration as feature

## Workflow Sets

Pre-configured workflow sets for common models:

- `ts_wfs_auto_arima()` - ARIMA workflow
- `ts_wfs_arima_boost()` - ARIMA boost workflow
- `ts_wfs_ets_reg()` - ETS workflow
- `ts_wfs_nnetar_reg()` - Neural network workflow
- `ts_wfs_prophet_reg()` - Prophet workflow
- `ts_wfs_lin_reg()` - Linear regression workflow
- `ts_wfs_mars()` - MARS workflow
- `ts_wfs_svm_poly()` - SVM polynomial workflow
- `ts_wfs_svm_rbf()` - SVM radial workflow
- `ts_wfs_xgboost()` - XGBoost workflow

## Dependencies

### Core Dependencies

**tidyverse Ecosystem:**
- `dplyr` - Data manipulation
- `tidyr` - Data tidying
- `purrr` - Functional programming
- `ggplot2` - Visualization
- `tibble` - Modern data frames

**Time Series:**
- `timetk` - Time series toolkit
- `modeltime` - Time series modeling framework
- `lubridate` - Date/time operations

**Modeling:**
- `recipes` - Feature engineering
- `parsnip` - Model specification
- `workflowsets` - Workflow management
- `hardhat` - Preprocessing infrastructure

**Other:**
- `magrittr` - Pipe operators
- `rlang` - Tidy evaluation
- `plotly` - Interactive plots
- `cowplot` - Plot composition

### Optional Dependencies

For extended functionality:
- `forecast` - Additional forecasting methods
- `tidymodels` - Complete modeling framework
- `rsample` - Resampling methods
- `tune` - Hyperparameter tuning
- `dials` - Parameter grids
- `glmnet`, `earth`, `smooth`, `kernlab` - Specific model engines

## Use Cases

healthyR.ts excels in these healthcare analytics scenarios:

### 1. Hospital Operations
- Daily/weekly patient admission forecasting
- Bed occupancy prediction
- Emergency department volume forecasting
- Operating room utilization

### 2. Clinical Metrics
- Average Length of Stay (ALOS) analysis
- Readmission rate monitoring
- Patient outcomes tracking
- Treatment efficacy over time

### 3. Resource Planning
- Staffing needs forecasting
- Supply chain demand prediction
- Budget planning and allocation
- Seasonal trend analysis

### 4. Quality Metrics
- Patient satisfaction scores
- Wait time analysis
- Procedure volume tracking
- Adverse event monitoring

## Relationship to healthyR Ecosystem

healthyR.ts is part of a larger ecosystem:

```
healthyverse (meta-package)
│
├── healthyR - Core hospital data analysis
│   └── Administrative data processing
│   └── Common metrics and summaries
│
├── healthyR.ts - Time series analysis (this package)
│   └── Forecasting and temporal patterns
│   └── Time series specific operations
│
└── healthyR.ai - Machine learning
    └── Classification and clustering
    └── Advanced ML algorithms
```

### When to Use Each Package

- **healthyR**: For static analysis, summary statistics, and administrative reporting
- **healthyR.ts**: For forecasting, temporal patterns, and time-dependent analysis
- **healthyR.ai**: For classification, clustering, and advanced machine learning

### Installation of Full Suite

```r
# Install all packages at once
install.packages("healthyverse")

# Load all packages
library(healthyverse)
```

## Architecture

### Design Patterns

1. **Boilerplate Pattern**: Complete workflows in single function
   - Recipe creation → Model specification → Workflow → Fitting → Tuning → Calibration

2. **Augment Pattern**: Add features to existing data
   - Input: data + value column
   - Output: data with additional computed columns

3. **Vec Pattern**: Pure vectorized operations
   - Input: numeric vector
   - Output: transformed numeric vector

4. **Step Pattern**: tidymodels recipe steps
   - Input: recipe object
   - Output: recipe with added step

### Function Categories by Pattern

```
Boilerplate Functions: ts_auto_*()
└── Handle complete modeling pipeline
└── Return list with multiple components

Augment Functions: *_augment()
└── Add columns to data frame
└── Return augmented data frame

Vec Functions: *_vec()
└── Transform numeric vectors
└── Return numeric vector

Plot Functions: *_plot() / *_plt()
└── Create visualizations
└── Return ggplot2 or plotly object

Workflow Functions: ts_wfs_*()
└── Create workflow sets
└── Return workflowset object
```

## Performance Considerations

### Speed
- Vectorized operations where possible
- Efficient data.table/dplyr operations
- Parallel processing support in tuning functions

### Memory
- Lazy evaluation patterns
- Minimal data copying
- Efficient storage of model objects

### Scalability
- Works with small datasets (100s of rows)
- Scales to large datasets (100,000+ rows)
- Parallel processing for multiple models

## Next Steps

- Learn about [Data Preparation](Data-Preparation.md)
- Explore [Automated Modeling Workflows](Automated-Modeling-Workflows.md)
- See [Function References](Function-References.md) for complete documentation
- Read [Time Series Basics](Time-Series-Basics.md) for foundational concepts
