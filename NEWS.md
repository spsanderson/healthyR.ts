# healthyR.ts (development version)

## Breaking Changes

## New Features
1. Fix #223 - Add function `ts_arima_simulator()` 
2. Fix #227 - Add function `ts_feature_cluster()`

## Minor Fixes and Improvements
1. Fix #212 - Update recipes to use the new [recipes::print_step()] method.
2. Fix #229 - Change all plots to  `ggplot2::theme_minimal()`
3. Fix #242 - Add `hardhat` to DESCRIPTION since functionality like extracting
dials parameters was taken out of dials and moved to hardhat.

# healthyR.ts 0.1.8

## Breaking Changes
None

## New Features
1. Fix #201 - Add Fitted `ts` and Fitted `tibble` data to output.
2. Fix #202 - Add Residuals `ts` and Residuals `tibble` data to output.
3. Fix #204 - Add `Arima()` models with xreg to `ts_forecast_simulator()`

## Minor Fixes and Improvements
1. Fix #199 - Update `model_extraction_helper()` to utilize `forecast:::arima.string()`
under the hood for `Arima` `arima` and `auto.arima` models produced by the `forecast`
package.
2. Fix #195 - Drop need for `crayon`, `cli`, and `rstudioapi` since all it did was
make a welcome message that can be done with regular `print()` method.
3. Fix #213 - Update navigation bar.

# healthyR.ts 0.1.7

## Breaking Changes
None

## New Features
1. Fix #181 - Add function `ts_qq_plot()`
2. Fix #180 - Add function `ts_scedacity_scatter_plot()`
3. Fix #179 - Add function `ts_model_rank_tbl()`

## Minor Fixes and Improvments
1. Fix #178 - Extend `model_extraction_helper()` to grab `workflow` `model_spec`
and `model_fit` objects.

# healthyR.ts 0.1.6

## Breaking Changes
None

## New Features
1. Fix #157 - Add function `ts_vva_plot()`
2. Fix #149 - Add function `ts_model_compare()`
3. Fix #156 - Add functions:
-  `ts_acceleration_vec()`
-  `ts_acceleration_augment()`
-  `step_ts_acceleration()`
4. Fix #155 - Add functions:
-  `ts_velocity_vec()`
-  `ts_velocity_augment()`
-  `step_ts_velocity()`

## Minor Fixes and Improvements
1. Fix #159 - Add parameter `.date_col` to `ts_sma_plot()` so that if a tibble is passed
the appropriate column is passed to the `ggplot` object.
2. Fix #164 - Update `model_extraction_helper()` function to extract workflow fit
models.

# healthyR.ts 0.1.5

## Breaking Changes
None

## New Features
None

## Minor Fixes and Improvements
Fix #143 - Drop `mtry = tune::tune()` from `ts_model_spec_tune_template` as it 
causes issues downstream.

# healthyR.ts 0.1.4

## Breaking Changes
None

## New Features
1. Fix #90   - Add `tidy_fft()` function
2. Fix #92   - Add `ts_info_tbl()` function
3. Fix #96   - Add `ts_sma_plot()` function
4. Fix #98   - Add `ts_to_tbl()` function
5. Fix #103  - Add `ts_model_auto_tune()` function
6. Fix #104  - Add `ts_model_spec_tune_template()` function
7. Fix #114  - Add `ts_wfs_auto_arima()` function
8. Fix #117  - Add `ts_wfs_arima_boost()` function
9. Fix #122  - Add `ts_wfs_ets_reg()` function
10. Fix #125 - Add `ts_wfs_nnetar_reg()` function
11. Fix #128 - Add `ts_wfs_prophet_reg()` function

## Minor Fixes and Improvements
1. Fix #105 - Fix `ts_auto_recipe()` bug that forced the change of column names
in the output. This has been fixed and the column names supplied will now be in
the recipe terms.

# healthyR.ts 0.1.3

## Breaking Changes
None

## New Features
1. Fix #36 - Add `ts_forecast_simulator()` function
2. Fix #45 - Add `calibrate_and_plot()` helper function
3. Fix #46 - Add `ts_wfs_lin_reg()`, `ts_wfs_mars()`, `ts_wfs_svm_poly()`, `ts_wfs_svm_rbf()`
4. Fix #47 - Add `model_extraction_helper()` helper function
5. Fix #51 - Add `ts_ma_plot()` plotting function
6. Fix #59 - Add `ts_calendar_heatmap_plot()` plotting function
7. Fix #65 - Add `ts_splits_plot()` plotting function

## Minor Fixes and Improvements
1. Fix #40 - Add ggplot object
2. Fix #54 - Drop xts::legend and add .align = "right" to slidify_vec function
3. Fix #62 - Fix ggplot title for Arima models

# healthyR.ts 0.1.2

## Breaking Changes
None

## New Features
1. Fix #16 - Add `ts_auto_recipe()` function

## Minor Fixes and Improvments
None

# healthyR.ts 0.1.1
* update DESCRIPTION file and minor cleanups
* GitHub release: https://github.com/spsanderson/healthyR.ts/releases/tag/v0.1.1

# healthyR.ts 0.1.0
* Added functions
1. ts_qc_run_chart
2. ts_compare_data

# healthyR.ts 0.0.0.9001
* Added fuctions
1. ts_random_walk
2. ts_random_walk_ggplot_layers

# healthyR.ts 0.0.0.9000

* Added a `NEWS.md` file to track changes to the package.
