# healthyR.ts Wiki - Complete Summary

## Overview

This document provides a comprehensive summary of the healthyR.ts wiki structure and content.

## Wiki Statistics

- **Total Pages:** 17 comprehensive documents
- **Total Lines:** ~8,000 lines of documentation
- **Code Examples:** 250+ working examples
- **Functions Documented:** 90+ functions
- **Models Covered:** 15 automated forecasting models

## Complete Page List

### Getting Started (5 pages)

1. **[Home](Home)** - 3.7 KB
   - Wiki navigation hub
   - Quick links by user type and task
   - Package introduction

2. **[Installation Guide](Installation-Guide)** - 5.8 KB
   - System requirements
   - Three installation methods
   - Dependency management
   - Troubleshooting installation issues

3. **[Quick Start](Quick-Start)** - 7.7 KB
   - First time series analysis
   - 4 complete examples
   - Common workflows
   - Key functions overview
   - Tips for success

4. **[Package Overview](Package-Overview)** - 11 KB
   - Philosophy and design
   - 90+ functions in 9 categories
   - Naming conventions
   - Dependencies
   - Use cases
   - Architecture

5. **[README](README)** - 5.4 KB
   - Wiki structure
   - Navigation tips
   - Quick access guide
   - Contributing information

### Function References (6 pages)

6. **[Data Generators](Data-Generators)** - 9.7 KB
   - `ts_random_walk()` - Random walk simulation
   - `ts_brownian_motion()` - Standard Brownian motion
   - `ts_geometric_brownian_motion()` - GBM for financial modeling
   - `ts_arima_simulator()` - ARIMA process simulation
   - Comparison tables
   - Monte Carlo patterns

7. **[Forecasting Models](Forecasting-Models)** - 15 KB
   - 15 automated model workflows
   - Common parameters
   - Return values
   - Individual model details:
     - ARIMA family (2 models)
     - Prophet family (2 models)
     - Machine learning (6 models)
     - Statistical models (5 models)
   - Model comparison table
   - Best practices

8. **[Visualization Functions](Visualization-Functions)** - 13 KB
   - Calendar heatmaps
   - Moving average plots
   - Velocity/acceleration plots
   - Diagnostic plots (QQ, scedasticity)
   - Time series splits visualization
   - Event analysis plots
   - Clustering visualization
   - Customization guide

9. **[Statistical Functions](Statistical-Functions)** - 14 KB
   - Stationarity testing (`ts_adf_test()`)
   - Auto-stationarization
   - 5 transformation functions
   - FFT analysis (`tidy_fft()`)
   - Confidence intervals
   - Lag correlation
   - Vector functions
   - Practical examples

10. **[Clustering Functions](Clustering-Functions)** - 16 KB
    - Feature-based clustering
    - 8 feature sets explained
    - `ts_feature_cluster()`
    - `ts_feature_cluster_plot()`
    - Choosing number of clusters
    - Hospital use cases
    - Anomaly detection

11. **[Utility Functions](Utility-Functions)** - 13 KB
    - Data transformation (`ts_to_tbl()`)
    - Date/time helpers (month, quarter, year functions)
    - Recipe creation (`ts_auto_recipe()`)
    - Model extraction
    - Workflow helpers
    - Tuning utilities
    - Comparison and ranking

### Practical Guides (1 page)

12. **[Hospital Admissions Forecasting](Hospital-Admissions-Forecasting)** - 15 KB
    - Complete end-to-end workflow
    - Dataset creation
    - Exploratory data analysis
    - Data preparation
    - 5 model building examples
    - Model comparison
    - Forecasting future values
    - Operational insights
    - Resource planning
    - Budget estimation
    - Model monitoring
    - Ensemble methods
    - Deployment checklist

### Support (4 pages)

13. **[FAQ](FAQ)** - 14 KB
    - 50+ questions and answers
    - Categories:
      - General questions
      - Installation issues
      - Data preparation
      - Modeling questions
      - Error messages
      - Performance questions
      - Visualization questions
    - Best practices
    - Common misconceptions

14. **[Troubleshooting](Troubleshooting)** - 13 KB
    - Installation issues
    - Data issues (dates, missing values, duplicates)
    - Modeling issues (fitting, tuning, memory)
    - Plotting issues
    - Performance issues
    - Function-specific issues
    - Error message explanations
    - Getting help guide
    - Prevention tips

15. **[Contributing](Contributing)** - 11 KB
    - Ways to contribute
    - Development setup
    - Coding standards
    - Function structure
    - Testing guide
    - Pull request process
    - Code review guidelines
    - Documentation standards

16. **[Changelog](Changelog)** - 9.8 KB
    - Version history from 0.0.0.9000 to current
    - Breaking changes
    - New features by version
    - Bug fixes
    - Upgrade guides
    - Release schedule
    - Package evolution history

17. **[WIKI-SUMMARY](WIKI-SUMMARY)** - This document
    - Complete wiki overview
    - Page summaries
    - Content organization
    - Usage guide

## Content Organization

### By Function Category

**Data Generation (1 page):**
- [Data Generators](Data-Generators)

**Forecasting (2 pages):**
- [Forecasting Models](Forecasting-Models)
- [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting)

**Visualization (1 page):**
- [Visualization Functions](Visualization-Functions)

**Analysis (3 pages):**
- [Statistical Functions](Statistical-Functions)
- [Clustering Functions](Clustering-Functions)
- [Utility Functions](Utility-Functions)

**Getting Started (5 pages):**
- [Home](Home)
- [Installation Guide](Installation-Guide)
- [Quick Start](Quick-Start)
- [Package Overview](Package-Overview)
- [README](README)

**Support (4 pages):**
- [FAQ](FAQ)
- [Troubleshooting](Troubleshooting)
- [Contributing](Contributing)
- [Changelog](Changelog)

### By User Level

**Beginners:**
1. [Installation Guide](Installation-Guide)
2. [Quick Start](Quick-Start)
3. [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting)
4. [FAQ](FAQ)

**Intermediate:**
1. [Package Overview](Package-Overview)
2. [Forecasting Models](Forecasting-Models)
3. [Visualization Functions](Visualization-Functions)
4. [Statistical Functions](Statistical-Functions)

**Advanced:**
1. [Clustering Functions](Clustering-Functions)
2. [Utility Functions](Utility-Functions)
3. [Troubleshooting](Troubleshooting)
4. [Contributing](Contributing)

### By Use Case

**Hospital Operations:**
- [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting)
- [Forecasting Models](Forecasting-Models)
- [Data Generators](Data-Generators) (for testing)

**Data Analysis:**
- [Statistical Functions](Statistical-Functions)
- [Visualization Functions](Visualization-Functions)
- [Clustering Functions](Clustering-Functions)

**Model Development:**
- [Forecasting Models](Forecasting-Models)
- [Utility Functions](Utility-Functions)
- [Statistical Functions](Statistical-Functions)

**Package Exploration:**
- [Package Overview](Package-Overview)
- [Quick Start](Quick-Start)
- [FAQ](FAQ)

## Key Features Documented

### Functions (90+)
- ✅ 15 automated forecasting models
- ✅ 9 data generator functions
- ✅ 15+ visualization functions
- ✅ 10+ statistical functions
- ✅ 2 clustering functions
- ✅ 20+ utility functions
- ✅ 10+ transformation functions
- ✅ 3 vector functions
- ✅ 2 recipe step functions

### Concepts
- ✅ Time series basics
- ✅ Stationarity and testing
- ✅ Feature engineering
- ✅ Model tuning
- ✅ Cross-validation
- ✅ Ensemble methods
- ✅ Seasonality detection
- ✅ Trend analysis
- ✅ Forecasting workflows
- ✅ Model comparison

### Workflows
- ✅ Complete forecasting pipeline
- ✅ Data preparation
- ✅ Model selection
- ✅ Hyperparameter tuning
- ✅ Model calibration
- ✅ Forecast generation
- ✅ Model monitoring
- ✅ Operational insights

## How to Use This Wiki

### For First-Time Users
1. Start at [Home](Home)
2. Read [Installation Guide](Installation-Guide)
3. Follow [Quick Start](Quick-Start)
4. Try [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting)

### For Function Reference
1. Go to [Package Overview](Package-Overview)
2. Identify function category
3. Navigate to specific function page:
   - [Data Generators](Data-Generators)
   - [Forecasting Models](Forecasting-Models)
   - [Visualization Functions](Visualization-Functions)
   - [Statistical Functions](Statistical-Functions)
   - [Clustering Functions](Clustering-Functions)
   - [Utility Functions](Utility-Functions)

### For Problem Solving
1. Check [FAQ](FAQ) first
2. If not found, go to [Troubleshooting](Troubleshooting)
3. Search error message in relevant function page
4. Post issue on GitHub if unresolved

### For Contributing
1. Read [Contributing](Contributing)
2. Review [Package Overview](Package-Overview) for structure
3. Check [Changelog](Changelog) for recent changes
4. Follow coding standards and submit PR

## Search Tips

### Finding Functions
- Use Ctrl+F on [Package Overview](Package-Overview)
- Browse by category in function reference pages
- Check [README](README) for quick access

### Finding Examples
- [Quick Start](Quick-Start) - Basic examples
- [Hospital Admissions Forecasting](Hospital-Admissions-Forecasting) - Complete workflow
- Each function page has multiple examples

### Finding Solutions
- [FAQ](FAQ) - Common questions
- [Troubleshooting](Troubleshooting) - Problems and fixes
- Function pages - Specific use cases

## Maintenance Notes

### Last Updated
November 2024

### Maintainer
Steven P. Sanderson II, MPH

### Version
Covers healthyR.ts version 0.3.1 and development version

### Future Updates
This wiki will be updated with:
- New functions as they're added
- Additional practical guides
- More use cases
- Community contributions

## Related Resources

### Package Documentation
- Website: https://www.spsanderson.com/healthyR.ts/
- GitHub: https://github.com/spsanderson/healthyR.ts
- CRAN: https://CRAN.R-project.org/package=healthyR.ts

### Vignettes
- Getting Started
- Using Tidy FFT

### Community
- GitHub Issues: Report bugs and request features
- Stack Overflow: Tag with `r` and `healthyr-ts`
- Email: spsanderson@gmail.com

## Acknowledgments

Special thanks to:
- Package users for feedback
- Contributors for improvements
- tidymodels team for infrastructure
- R community for support

---

**Note:** This wiki represents a comprehensive documentation effort covering all major aspects of the healthyR.ts package. Each page is designed to be self-contained while also linking to related topics for deeper exploration.

For the latest updates, visit the [GitHub Wiki](https://github.com/spsanderson/healthyR.ts/wiki).
