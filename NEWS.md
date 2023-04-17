# healthyR.ts (development version)

# healthyR.ts 0.2.8

## Breaking Changes
1. Fix #424 - Require R >= 3.3

## New Features
None

## Minor Fixes and Improvements
1. Fix #425 - Fix `ts_ma_plt()` errors stemming from deprecations. Also fixed
examples of all boilerplate functions.

# healthyR.ts 0.2.7

## Breaking Changes
None

## New Features
1. Fix #397 - Add function `ts_geometric_brownian_motion()`
2. Fix #402 - Add function `ts_brownian_motion_augment()`
3. Fix #403 - Add function `ts_geometric_brownian_motion_augment()`
4. Fix #404 - Add function `ts_brownian_motion_plot()`

## Minor Fixes and Improvements
1. Fix #395 - Update and optimize `ts_brownian_motion()` 49x speedup by way of
vectorization.
2. Fix #412 - Update all brownian motion functions to have an attribute of 
`.motion_type`
3. Fix #411 - Drop the invisible return for `ts_vva_plot()`

# healthyR.ts 0.2.6

## Breaking Changes
None

## New Features
1. Fix #389 - Add function `ts_brownian_motion()`

## Minor Fixes and Improvements
1. Fix #387 - Fix documentation for `ts_scedacity_scatter_plot()`

# healthyR.ts 0.2.5

## Breaking Changes
None

## New Features
None

## Minor Fixes and Improvements
1. Fix #380 - Fix `ts_lag_correlation()` to fix a bug in the correlation matrix calculation where columns may come through that are not numeric and are not part of the original value and it's lags.

# healthyR.ts 0.2.4

## Breaking Changes
None

## New Features
None

## Minor Fixes and Improvements
1. Fix #368 - Pull request from @EmilHvitfeldt to use `recipes::check_type()`
on recipe functions.
2. Fix #370 - Update `ts_model_spec_tune_template()` to set `regression` as the
argument to `parsnip::set_mode()` which fires a failure in the `ts_model_auto_tune()`
not running on newer versions of `parsnip`

# healthyR.ts 0.2.3

## Breaking Changes
None

## New Features
1. Fix #357 - Add function `ts_wfs_xgboost()`

## Minor Fixes and Improvements
1. Fix #358 - Update `ts_calendar_heatmap_plot()` Change weekdays and Monthls
to abbreviated labels.

# healthyR.ts 0.2.2

## Breaking Changes
1. Fix 345 - Fix `ts_sma_plot()` There is a change in the API of this function.
It now requires a `data.frame`/`tibble` to be passed to the `.data` parameter, and
it also now requires the input of a date column and value column. This also now 
no longer returns invisible. There was also a fix in the sliding calculation
to appropriately use the given value column.

## New Features
1. Fix #342 - Add function `ts_extract_auto_fitted_workflow()` Which will pull
out the fitted workflow from any of the Boilerplate functions.

## Minor Fixes and Improvements
1. Fix #343 - Add attributes to output list of boilerplate functions.
2. Fix #347 - Fix `ts_auto_lm()` by dropping `step_rm()` and `step_corr()` which
would prevent `calibrate_and_plot()` from working due to `modeltime_calibration()`
failing. Also dropped unused parameters from function and documentation.
3. Fix #349 - Fix to `ts_lag_correlation()` `select` statement.

# healthyR.ts 0.2.1

## Breaking Changes
None

## New Features
1. Fix #306 - Add function `ts_time_event_analysis_tbl()`
2. Fix #315 - Add function `ts_lag_correlation()`
3. Fix #327 - Add some date helpers
4. Fix #326 - Add functions `ci_hi()` and `ci_lo()`
5. Fix #325 - Add function `ts_event_analysis_plot()`

## Minor Fixes and Improvements
1. Fix #333 - Update `ts_model_auto_tune()` and `ts_model_spec_tune_template()` to
accept `svm_poly` and `svm_rbf`. This helps in allowing users to auto tune models
that are create by `ts_wfs_svm_poly()` and `ts_wfs_svm_rbf()` functions respectively.
Also added "model_spec_class" to the output of the `ts_model_auto_tune()` function.

# healthyR.ts 0.2.0

## Breaking Changes
None

## New Features
1. Fix #277 - Add function `ts_auto_arima()` boiler plate function.
2. Fix #284 - Add functions `color_blind()` `ts_scale_fill_colorblind()` and
`ts_scale_color_colorblind()`
3. Fix #278 - Add function `ts_auto_smooth_es()`
4. Fix #279 - Add function `ts_auto_theta()`
5. Fix #280 - Add function `ts_auto_lm()`
6. Fix #281 - Add function `ts_auto_svm_poly()`
7. Fix #282 - Add function `ts_auto_svm_rbf()`

## Minor Fixes and Improvements
1. Fix #275 - Correct `ts_auto_arima_xgboots()` when `.tune` is FALSE.
2. Fix #286 - Change the boilerplate recipe to keep the date column and change
it to a numeric rather than using step_rm() instead use step_mutate(as.numeric())
3. Fix #288 - Update tune template helper function smooth_es to use `tune::tune()`
4. Fix #291 - Move kmeans functions from using `healthyR` to `healthyR.ai` in
anticipation of dropping `kmeans` functionality from `healthyR`

# healthyR.ts 0.1.9

## Breaking Changes
None

## New Features
1. Fix #223 - Add function `ts_arima_simulator()` 
2. Fix #227 - Add function `ts_feature_cluster()`
3. Fix #228 - Add function `ts_feature_cluster_plot()`
4. Fix #241 - Add function `ts_auto_glmnet()`
5. Fix #243 - Add function `ts_auto_xgboost()`
6. Fix #244 - Add function `ts_auto_arima_xgboost()`
7. Fix #245 - Add function `ts_auto_mars()`
8. Fix #246 - Add function `ts_auto_exp_smoothing()`
9. Fix #247 - Add function `ts_auto_croston()`
10. Fix #248 - Add function `ts_auto_nnetar()`
11. Fix #250 - Add function `ts_auto_prophet_reg()`
12. Fix #251 - Add function `ts_auto_prophet_boost()`

## Minor Fixes and Improvements
1. Fix #212 - Update recipes to use the new `[recipes::print_step()]` method.
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
