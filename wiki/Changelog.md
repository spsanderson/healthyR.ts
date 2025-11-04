# Changelog

Version history and release notes for healthyR.ts.

For the most up-to-date changelog, see [NEWS.md on GitHub](https://github.com/spsanderson/healthyR.ts/blob/master/NEWS.md).

## Current Development Version

### healthyR.ts (development version)

Development is ongoing. Check the [GitHub repository](https://github.com/spsanderson/healthyR.ts) for the latest updates.

## Released Versions

### healthyR.ts 0.3.1

**Release Date:** [Date from CRAN]

#### Breaking Changes
- Fix #509 - Drop invisible returns from functions

#### Minor Fixes and Improvements
- Fix #511 - Bug in `ts_random_walk()` that would generate 3 runs when run was set to less than 2
- #518 - Fix `ts_qq_plot()` - Add color and alpha to the output
- #516 - Fix `ts_vva_plot()` - Correct cumsum calculation and lagged differences
- #521 - Fix for CRAN maintenance
- Remove `timetk::step_holiday_signature()` due to recycle errors in boilerplate functions

### healthyR.ts 0.3.0

#### New Features
- Fix #484 - Add function `util_log_ts()`
- Fix #485 - Add function `util_singlediff_ts()`
- Fix #486 - Add function `util_doublediff_ts()`
- Fix #487 - Add function `util_difflog_ts()`
- Fix #488 - Add function `util_doubledifflog_ts()`

#### Minor Fixes and Improvements
- Fix #480 - Add attributes to output of `ts_growth_rate_vec()`
- Fix #481 #483 - Update `auto_stationarize()`
- Fix #489 - Update `ts_auto_arima()` to utilize parsnip engine of `auto_arima` if `.tune` is FALSE

### healthyR.ts 0.2.11

#### New Features
- Fix #459 - Add function `ts_growth_rate_vec()`
- Fix #463 - Add function `ts_adf_test()`
- Fix #417 - Add function `auto_stationarize()`
- Fix #460 - Add function `ts_growth_rate_augment()`

#### Minor Fixes and Improvements
- Fix #456 - Fix boilerplate examples to set `.tune` param to FALSE

### healthyR.ts 0.2.10

#### Breaking Changes
- Fix #439 - Fix example rsample from @hfrick

### healthyR.ts 0.2.9

#### Minor Fixes and Improvements
- Fix #436 - Modify all boilerplate fitting functions to use `tune::show_best(n = 1)` instead of `Inf`

### healthyR.ts 0.2.8

#### Breaking Changes
- Fix #424 - Require R >= 3.3

#### Minor Fixes and Improvements
- Fix #425 - Fix `ts_ma_plt()` errors from deprecations

### healthyR.ts 0.2.7

#### New Features
- Fix #397 - Add function `ts_geometric_brownian_motion()`
- Fix #402 - Add function `ts_brownian_motion_augment()`
- Fix #403 - Add function `ts_geometric_brownian_motion_augment()`
- Fix #404 - Add function `ts_brownian_motion_plot()`

#### Minor Fixes and Improvements
- Fix #395 - Update and optimize `ts_brownian_motion()` - 49x speedup via vectorization
- Fix #412 - Update brownian motion functions to have `.motion_type` attribute
- Fix #411 - Drop invisible return for `ts_vva_plot()`

### healthyR.ts 0.2.6

#### New Features
- Fix #389 - Add function `ts_brownian_motion()`

#### Minor Fixes and Improvements
- Fix #387 - Fix documentation for `ts_scedacity_scatter_plot()`

### healthyR.ts 0.2.5

#### Minor Fixes and Improvements
- Fix #380 - Fix `ts_lag_correlation()` bug in correlation matrix calculation

### healthyR.ts 0.2.4

#### Minor Fixes and Improvements
- Fix #368 - Pull request from @EmilHvitfeldt to use `recipes::check_type()` on recipe functions
- Fix #370 - Update `ts_model_spec_tune_template()` to set `regression` as argument to `parsnip::set_mode()`

### healthyR.ts 0.2.3

#### New Features
- Fix #357 - Add function `ts_wfs_xgboost()`

#### Minor Fixes and Improvements
- Fix #358 - Update `ts_calendar_heatmap_plot()` - Change weekdays and months to abbreviated labels

### healthyR.ts 0.2.2

#### Breaking Changes
- Fix #345 - Fix `ts_sma_plot()` API change - now requires data frame/tibble, date column, and value column inputs

#### New Features
- Fix #342 - Add function `ts_extract_auto_fitted_workflow()`

#### Minor Fixes and Improvements
- Fix #343 - Add attributes to output list of boilerplate functions
- Fix #347 - Fix `ts_auto_lm()` by dropping problematic step functions
- Fix #349 - Fix `ts_lag_correlation()` select statement

### healthyR.ts 0.2.1

#### New Features
- Fix #306 - Add function `ts_time_event_analysis_tbl()`
- Fix #315 - Add function `ts_lag_correlation()`
- Fix #327 - Add date helper functions
- Fix #326 - Add functions `ci_hi()` and `ci_lo()`
- Fix #325 - Add function `ts_event_analysis_plot()`

#### Minor Fixes and Improvements
- Fix #333 - Update `ts_model_auto_tune()` and `ts_model_spec_tune_template()` to accept SVM models

### healthyR.ts 0.2.0

#### New Features
- Fix #277 - Add function `ts_auto_arima()` boilerplate function
- Fix #284 - Add colorblind palette functions
- Fix #278 - Add function `ts_auto_smooth_es()`
- Fix #279 - Add function `ts_auto_theta()`
- Fix #280 - Add function `ts_auto_lm()`
- Fix #281 - Add function `ts_auto_svm_poly()`
- Fix #282 - Add function `ts_auto_svm_rbf()`

#### Minor Fixes and Improvements
- Fix #275 - Correct `ts_auto_arima_xgboost()` when `.tune` is FALSE
- Fix #286 - Change boilerplate recipe to keep date column and convert to numeric
- Fix #288 - Update tune template helper function for smooth_es
- Fix #291 - Move kmeans functions from healthyR to healthyR.ai

### healthyR.ts 0.1.9

#### New Features
- Fix #223 - Add function `ts_arima_simulator()`
- Fix #227 - Add function `ts_feature_cluster()`
- Fix #228 - Add function `ts_feature_cluster_plot()`
- Fix #241 - Add function `ts_auto_glmnet()`
- Fix #243 - Add function `ts_auto_xgboost()`
- Fix #244 - Add function `ts_auto_arima_xgboost()`
- Fix #245 - Add function `ts_auto_mars()`
- Fix #246 - Add function `ts_auto_exp_smoothing()`
- Fix #247 - Add function `ts_auto_croston()`
- Fix #248 - Add function `ts_auto_nnetar()`
- Fix #250 - Add function `ts_auto_prophet_reg()`
- Fix #251 - Add function `ts_auto_prophet_boost()`

#### Minor Fixes and Improvements
- Fix #212 - Update recipes to use new `recipes::print_step()` method
- Fix #229 - Change all plots to `ggplot2::theme_minimal()`
- Fix #242 - Add hardhat to DESCRIPTION

## Early Versions

### healthyR.ts 0.1.8

#### New Features
- Add fitted ts and tibble data to output
- Add residuals ts and tibble data to output
- Add Arima() models with xreg to `ts_forecast_simulator()`

### healthyR.ts 0.1.7

#### New Features
- Add function `ts_qq_plot()`
- Add function `ts_scedacity_scatter_plot()`
- Add function `ts_model_rank_tbl()`
- Extend `model_extraction_helper()` to grab workflow objects

### healthyR.ts 0.1.6

#### New Features
- Add function `ts_vva_plot()`
- Add function `ts_model_compare()`
- Add acceleration functions: `ts_acceleration_vec()`, `ts_acceleration_augment()`, `step_ts_acceleration()`
- Add velocity functions: `ts_velocity_vec()`, `ts_velocity_augment()`, `step_ts_velocity()`

### healthyR.ts 0.1.4 - 0.1.5

Major expansion with many new functions including:
- `tidy_fft()` - Fast Fourier Transform
- `ts_info_tbl()` - Time series information
- `ts_sma_plot()` - Simple moving average plot
- `ts_to_tbl()` - Convert ts objects to tibbles
- Model tuning infrastructure
- Workflow set functions
- And more...

### healthyR.ts 0.1.3

#### New Features
- `ts_forecast_simulator()` function
- `calibrate_and_plot()` helper
- Workflow set functions
- `model_extraction_helper()`
- Plotting functions

### healthyR.ts 0.1.0 - 0.1.2

Initial releases with:
- Basic time series functions
- `ts_random_walk()` and layers
- `ts_qc_run_chart()`
- `ts_compare_data()`
- `ts_auto_recipe()`

## Version Numbering

healthyR.ts follows [Semantic Versioning](https://semver.org/):
- **Major.Minor.Patch** (e.g., 0.3.1)
- **Major** - Breaking changes
- **Minor** - New features (backwards compatible)
- **Patch** - Bug fixes (backwards compatible)

## Upgrade Guide

### Upgrading to 0.3.x from 0.2.x

**Breaking Changes:**
- Functions no longer return invisible objects
- Some plotting functions have updated APIs

**Recommended Actions:**
1. Update code to handle visible returns
2. Test custom plotting code
3. Review function documentation for API changes

### Upgrading to 0.2.x from 0.1.x

**Breaking Changes:**
- `ts_sma_plot()` API changed - now requires data frame input

**New Features:**
- Many boilerplate `ts_auto_*()` functions
- Enhanced visualization options
- Improved performance

**Recommended Actions:**
1. Update `ts_sma_plot()` calls to new API
2. Explore new boilerplate functions
3. Consider using colorblind palettes

## Release Schedule

- **Major releases:** Yearly
- **Minor releases:** Quarterly
- **Patch releases:** As needed for bug fixes

## Stay Updated

### Ways to Track Updates

1. **CRAN:**
   ```r
   old.packages()
   update.packages("healthyR.ts")
   ```

2. **GitHub Releases:**
   Watch the [GitHub repository](https://github.com/spsanderson/healthyR.ts/releases)

3. **RSS Feed:**
   Subscribe to CRAN package updates

4. **Twitter/Social Media:**
   Follow package maintainer updates

## Contributing to Releases

Want to contribute to future releases?

1. Report bugs: [GitHub Issues](https://github.com/spsanderson/healthyR.ts/issues)
2. Suggest features: [Feature Requests](https://github.com/spsanderson/healthyR.ts/issues/new)
3. Submit PRs: See [Contributing Guide](Contributing.md)

## Historical Notes

### Package Evolution

- **2020:** Initial release (0.0.0.9000)
- **2021:** Major expansion with workflow functions (0.1.x)
- **2022:** Introduction of boilerplate functions (0.2.x)
- **2023:** Utility functions and improvements (0.3.x)

### Design Philosophy Changes

Early versions focused on individual functions. Later versions introduced:
- **Boilerplate functions** - Complete workflows in one call
- **Workflow sets** - Pre-configured model workflows
- **Enhanced visualizations** - More plotting options
- **Better integration** - Tighter tidymodels integration

## See Also

- [Package Overview](Package-Overview.md) - Current package structure
- [Installation Guide](Installation-Guide.md) - Installation instructions
- [Contributing](Contributing.md) - How to contribute
