# Installation Guide

This guide will help you install **healthyR.ts** and its dependencies on your system.

## Prerequisites

### System Requirements

- **R Version**: R >= 3.3
- **Operating System**: Windows, macOS, or Linux
- **Memory**: At least 4GB RAM recommended (8GB+ for large datasets)

### Required Knowledge

Basic familiarity with:
- R programming
- Time series concepts
- The tidyverse ecosystem (helpful but not required)

## Installation Methods

### Method 1: Install from CRAN (Recommended)

The easiest way to install the stable release:

```r
install.packages("healthyR.ts")
```

This will automatically install all required dependencies.

### Method 2: Install Development Version from GitHub

To get the latest features and bug fixes:

```r
# First, install devtools if you don't have it
install.packages("devtools")

# Then install healthyR.ts from GitHub
devtools::install_github("spsanderson/healthyR.ts")
```

### Method 3: Install Specific Version

To install a specific version from GitHub:

```r
# Install version 0.3.1
devtools::install_github("spsanderson/healthyR.ts@v0.3.1")
```

## Dependencies

### Required Packages

healthyR.ts automatically installs these required dependencies:

**Core Dependencies:**
- `magrittr` - Pipe operators
- `rlang` - Tidy evaluation framework
- `tibble` - Modern data frames
- `dplyr` - Data manipulation
- `tidyr` - Data tidying
- `purrr` - Functional programming tools

**Time Series Specific:**
- `timetk` - Time series toolkit
- `lubridate` - Date/time handling
- `recipes` - Feature engineering
- `parsnip` - Model specification
- `modeltime` - Time series modeling
- `workflowsets` - Workflow management
- `hardhat` - Model preprocessing

**Visualization:**
- `ggplot2` - Data visualization
- `plotly` - Interactive plots
- `cowplot` - Plot composition

**Other:**
- `forcats` - Factor handling
- `stringi` - String operations
- `graphics` - Base graphics

### Suggested Packages

For full functionality, you may want to install these optional packages:

```r
# Suggested packages for extended functionality
install.packages(c(
  "knitr",          # Report generation
  "rmarkdown",      # Markdown documents
  "scales",         # Scale functions
  "rsample",        # Resampling
  "healthyR.ai",    # ML companion package
  "stringr",        # String manipulation
  "forecast",       # Forecasting methods
  "tidymodels",     # Modeling framework
  "glue",           # String interpolation
  "xts",            # Time series objects
  "zoo",            # Time series infrastructure
  "TSA",            # Time series analysis
  "tune",           # Hyperparameter tuning
  "dials",          # Parameter grids
  "workflows",      # Workflow objects
  "tidyselect",     # Selection helpers
  "glmnet",         # Regularized regression
  "earth",          # MARS models
  "smooth",         # Smoothing methods
  "kernlab"         # Kernel methods (SVM)
))
```

## Verification

After installation, verify that healthyR.ts is working correctly:

```r
# Load the package
library(healthyR.ts)

# Check version
packageVersion("healthyR.ts")

# Run a simple example
df <- ts_random_walk(.num_walks = 5, .periods = 50)
head(df)
```

If you see output without errors, the installation was successful!

## Troubleshooting

### Common Installation Issues

#### Issue 1: Package Dependencies Fail to Install

**Problem**: Some dependencies fail to install, especially on Linux.

**Solution**: Install system dependencies first. On Ubuntu/Debian:

```bash
sudo apt-get update
sudo apt-get install -y \
  libcurl4-openssl-dev \
  libssl-dev \
  libxml2-dev \
  libgit2-dev
```

On macOS with Homebrew:

```bash
brew install openssl libgit2
```

#### Issue 2: Compilation Errors on Windows

**Problem**: Package compilation fails on Windows.

**Solution**: Install Rtools for your R version from [CRAN](https://cran.r-project.org/bin/windows/Rtools/).

#### Issue 3: tidymodels Version Conflicts

**Problem**: Version conflicts with tidymodels ecosystem packages.

**Solution**: Update all tidymodels packages:

```r
# Update all packages
update.packages(ask = FALSE)

# Or specifically update tidymodels
install.packages("tidymodels")
```

#### Issue 4: Memory Issues During Installation

**Problem**: Installation fails due to insufficient memory.

**Solution**: Close other applications and try again, or increase R's memory limit:

```r
# Windows
memory.limit(size = 8000)

# All platforms - install one dependency at a time
install.packages("modeltime")
install.packages("timetk")
# ... then install healthyR.ts
```

### Getting Help

If you encounter issues not covered here:

1. Check the [GitHub Issues](https://github.com/spsanderson/healthyR.ts/issues) for similar problems
2. Search the [R-help mailing list](https://stat.ethz.ch/mailman/listinfo/r-help)
3. Post a question on [Stack Overflow](https://stackoverflow.com/questions/tagged/r) with the `r` and `healthyr-ts` tags
4. Open a new issue on [GitHub](https://github.com/spsanderson/healthyR.ts/issues/new)

## Next Steps

Once installed, proceed to:
- [Quick Start Guide](Quick-Start.md) - Get started with basic examples
- [Package Overview](Package-Overview.md) - Learn about package structure
- [Data Preparation](Data-Preparation.md) - Prepare your data for analysis

## Updating healthyR.ts

To update to the latest version:

### From CRAN:
```r
update.packages("healthyR.ts")
```

### From GitHub:
```r
devtools::install_github("spsanderson/healthyR.ts")
```

## Uninstalling

To remove healthyR.ts:

```r
remove.packages("healthyR.ts")
```

Note: This does not remove dependencies. To also remove dependencies:

```r
# List dependencies
dependencies <- tools::package_dependencies("healthyR.ts", 
                                           recursive = FALSE)[[1]]

# Remove package and dependencies
remove.packages(c("healthyR.ts", dependencies))
```
