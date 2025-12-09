# Changelog

## healthyR.ts (development version)

### Minor Fixes and Improvements

None

### New Features

1.  Add function
    [`ts_random_walk_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk_plot.md) -
    Creates a side-by-side faceted plot for random walk simulations
    showing both the random variable and the random walk path
    (cumulative product).

### Breaking Changes

1.  Require R \>= 4.1 per CRAN request due to using the native pipe.
2.  Fix [\#542](https://github.com/spsanderson/healthyR.ts/issues/542) -
    Refactor
    [`ts_ma_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_ma_plot.md)
    to use
    [`ggplot2::facet_wrap()`](https://ggplot2.tidyverse.org/reference/facet_wrap.html)
    instead of
    [`cowplot::plot_grid()`](https://wilkelab.org/cowplot/reference/plot_grid.html)
    for stacking plots. The function now returns only ggplot2 output and
    no longer includes xts plotting functionality. The return value has
    been simplified from 6 items to 2 items: `pgrid` (ggplot2 facet_wrap
    plot object) and `data_summary_tbl` (summary data table). Removed
    return values: `data_trans_xts`, `data_diff_xts_a`,
    `data_diff_xts_b`, and `xts_plt`.

### Minor Fixes and Improvements

None

### New Features

None

## healthyR.ts 0.3.1

CRAN release: 2024-10-11

### Breaking Changes

1.  Fix [\#509](https://github.com/spsanderson/healthyR.ts/issues/509) -
    Drop invisible returns.

### New Features

None

### Minor Fixes and Improvements

1.  1.  Fix
        [\#511](https://github.com/spsanderson/healthyR.ts/issues/511) -
        Fix a bug in
        [`ts_random_walk()`](https://www.spsanderson.com/healthyR.ts/reference/ts_random_walk.md)
        that would generate 3 runs when run was set to less than 2.
2.  \#518 - Fix ts_qq_plot() - Add color and alpha to the output.
3.  \#516 - Fix ts_vva_plot() - Correct to add cumsum of the passed
    value and correct lagged differences.
4.  \#521 - Fix for CRAN maintenance.
5.  Remove
    [`timetk::step_holiday_signature()`](https://business-science.github.io/timetk/reference/step_holiday_signature.html)
    as it is throwing recycle erros in boilerplate functions and I
    currently cannot figure out why.

## healthyR.ts 0.3.0

CRAN release: 2023-11-15

### Breaking Changes

None

### New Features

1.  Fix [\#484](https://github.com/spsanderson/healthyR.ts/issues/484) -
    Add function
    [`util_log_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_log_ts.md)
2.  Fix [\#485](https://github.com/spsanderson/healthyR.ts/issues/485) -
    Add function
    [`util_singlediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_singlediff_ts.md)
3.  Fix [\#486](https://github.com/spsanderson/healthyR.ts/issues/486) -
    Add function
    [`util_doublediff_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doublediff_ts.md)
4.  Fix [\#487](https://github.com/spsanderson/healthyR.ts/issues/487) -
    Add function
    [`util_difflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_difflog_ts.md)
5.  Fix [\#488](https://github.com/spsanderson/healthyR.ts/issues/488) -
    Add function
    [`util_doubledifflog_ts()`](https://www.spsanderson.com/healthyR.ts/reference/util_doubledifflog_ts.md)

### Minor Fixes and Improvements

1.  Fix [\#480](https://github.com/spsanderson/healthyR.ts/issues/480) -
    Add attributes to output of
    [`ts_growth_rate_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_vec.md)
2.  Fix [\#481](https://github.com/spsanderson/healthyR.ts/issues/481)
    [\#483](https://github.com/spsanderson/healthyR.ts/issues/483) -
    Update
    [`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md)
3.  Fix [\#489](https://github.com/spsanderson/healthyR.ts/issues/489) -
    Update
    [`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md)
    to utilize the parsnip engine of `auto_arima` if `.tune` is set to
    `FALSE`

## healthyR.ts 0.2.11

CRAN release: 2023-10-14

### Breaking Changes

None

### New Features

1.  Fix [\#459](https://github.com/spsanderson/healthyR.ts/issues/459) -
    Add function
    [`ts_growth_rate_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_vec.md)
2.  Fix [\#463](https://github.com/spsanderson/healthyR.ts/issues/463) -
    Add function
    [`ts_adf_test()`](https://www.spsanderson.com/healthyR.ts/reference/ts_adf_test.md)
3.  Fix [\#417](https://github.com/spsanderson/healthyR.ts/issues/417) -
    Add function
    [`auto_stationarize()`](https://www.spsanderson.com/healthyR.ts/reference/auto_stationarize.md)
4.  Fix [\#460](https://github.com/spsanderson/healthyR.ts/issues/460) -
    Add function
    [`ts_growth_rate_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_growth_rate_augment.md)

### Minor Fixes and Improvements

1.  Fix [\#456](https://github.com/spsanderson/healthyR.ts/issues/456)
    Fix boilerplate examples to set the `.true` param to `FALSE`

## healthyR.ts 0.2.10

CRAN release: 2023-08-22

### Breaking Changes

1.  Fix [\#439](https://github.com/spsanderson/healthyR.ts/issues/439)
    fix-example-rsample 6366226ec2dccdc296037e8e7efadf89994e6a1d from
    [@hfrick](https://github.com/hfrick)

### New Features

None

### Minor Fixes and Improvements

None

## healthyR.ts 0.2.9

CRAN release: 2023-06-24

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvements

1.  Fix [\#436](https://github.com/spsanderson/healthyR.ts/issues/436) -
    Modify all *boilerplate* fitting functions to use
    `tune::show_best(n = 1)` instead of `Inf` and using
    `dplyr::slice(1)`

## healthyR.ts 0.2.8

CRAN release: 2023-04-14

### Breaking Changes

1.  Fix [\#424](https://github.com/spsanderson/healthyR.ts/issues/424) -
    Require R \>= 3.3

### New Features

None

### Minor Fixes and Improvements

1.  Fix [\#425](https://github.com/spsanderson/healthyR.ts/issues/425) -
    Fix `ts_ma_plt()` errors stemming from deprecations. Also fixed
    examples of all boilerplate functions.

## healthyR.ts 0.2.7

CRAN release: 2023-01-28

### Breaking Changes

None

### New Features

1.  Fix [\#397](https://github.com/spsanderson/healthyR.ts/issues/397) -
    Add function
    [`ts_geometric_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion.md)
2.  Fix [\#402](https://github.com/spsanderson/healthyR.ts/issues/402) -
    Add function
    [`ts_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_augment.md)
3.  Fix [\#403](https://github.com/spsanderson/healthyR.ts/issues/403) -
    Add function
    [`ts_geometric_brownian_motion_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_geometric_brownian_motion_augment.md)
4.  Fix [\#404](https://github.com/spsanderson/healthyR.ts/issues/404) -
    Add function
    [`ts_brownian_motion_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion_plot.md)

### Minor Fixes and Improvements

1.  Fix [\#395](https://github.com/spsanderson/healthyR.ts/issues/395) -
    Update and optimize
    [`ts_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion.md)
    49x speedup by way of vectorization.
2.  Fix [\#412](https://github.com/spsanderson/healthyR.ts/issues/412) -
    Update all brownian motion functions to have an attribute of
    `.motion_type`
3.  Fix [\#411](https://github.com/spsanderson/healthyR.ts/issues/411) -
    Drop the invisible return for
    [`ts_vva_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_vva_plot.md)

## healthyR.ts 0.2.6

CRAN release: 2023-01-06

### Breaking Changes

None

### New Features

1.  Fix [\#389](https://github.com/spsanderson/healthyR.ts/issues/389) -
    Add function
    [`ts_brownian_motion()`](https://www.spsanderson.com/healthyR.ts/reference/ts_brownian_motion.md)

### Minor Fixes and Improvements

1.  Fix [\#387](https://github.com/spsanderson/healthyR.ts/issues/387) -
    Fix documentation for
    [`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md)

## healthyR.ts 0.2.5

CRAN release: 2022-11-16

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvements

1.  Fix [\#380](https://github.com/spsanderson/healthyR.ts/issues/380) -
    Fix
    [`ts_lag_correlation()`](https://www.spsanderson.com/healthyR.ts/reference/ts_lag_correlation.md)
    to fix a bug in the correlation matrix calculation where columns may
    come through that are not numeric and are not part of the original
    value and it’s lags.

## healthyR.ts 0.2.4

CRAN release: 2022-11-10

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvements

1.  Fix [\#368](https://github.com/spsanderson/healthyR.ts/issues/368) -
    Pull request from [@EmilHvitfeldt](https://github.com/EmilHvitfeldt)
    to use
    [`recipes::check_type()`](https://recipes.tidymodels.org/reference/check_type.html)
    on recipe functions.
2.  Fix [\#370](https://github.com/spsanderson/healthyR.ts/issues/370) -
    Update
    [`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)
    to set `regression` as the argument to
    [`parsnip::set_mode()`](https://parsnip.tidymodels.org/reference/set_args.html)
    which fires a failure in the
    [`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)
    not running on newer versions of `parsnip`

## healthyR.ts 0.2.3

CRAN release: 2022-10-03

### Breaking Changes

None

### New Features

1.  Fix [\#357](https://github.com/spsanderson/healthyR.ts/issues/357) -
    Add function
    [`ts_wfs_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_xgboost.md)

### Minor Fixes and Improvements

1.  Fix [\#358](https://github.com/spsanderson/healthyR.ts/issues/358) -
    Update
    [`ts_calendar_heatmap_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_calendar_heatmap_plot.md)
    Change weekdays and Monthls to abbreviated labels.

## healthyR.ts 0.2.2

CRAN release: 2022-08-07

### Breaking Changes

1.  Fix 345 - Fix
    [`ts_sma_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_sma_plot.md)
    There is a change in the API of this function. It now requires a
    `data.frame`/`tibble` to be passed to the `.data` parameter, and it
    also now requires the input of a date column and value column. This
    also now no longer returns invisible. There was also a fix in the
    sliding calculation to appropriately use the given value column.

### New Features

1.  Fix [\#342](https://github.com/spsanderson/healthyR.ts/issues/342) -
    Add function
    [`ts_extract_auto_fitted_workflow()`](https://www.spsanderson.com/healthyR.ts/reference/ts_extract_auto_fitted_workflow.md)
    Which will pull out the fitted workflow from any of the Boilerplate
    functions.

### Minor Fixes and Improvements

1.  Fix [\#343](https://github.com/spsanderson/healthyR.ts/issues/343) -
    Add attributes to output list of boilerplate functions.
2.  Fix [\#347](https://github.com/spsanderson/healthyR.ts/issues/347) -
    Fix
    [`ts_auto_lm()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_lm.md)
    by dropping
    [`step_rm()`](https://recipes.tidymodels.org/reference/step_rm.html)
    and
    [`step_corr()`](https://recipes.tidymodels.org/reference/step_corr.html)
    which would prevent
    [`calibrate_and_plot()`](https://www.spsanderson.com/healthyR.ts/reference/calibrate_and_plot.md)
    from working due to `modeltime_calibration()` failing. Also dropped
    unused parameters from function and documentation.
3.  Fix [\#349](https://github.com/spsanderson/healthyR.ts/issues/349) -
    Fix to
    [`ts_lag_correlation()`](https://www.spsanderson.com/healthyR.ts/reference/ts_lag_correlation.md)
    `select` statement.

## healthyR.ts 0.2.1

CRAN release: 2022-07-19

### Breaking Changes

None

### New Features

1.  Fix [\#306](https://github.com/spsanderson/healthyR.ts/issues/306) -
    Add function
    [`ts_time_event_analysis_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_time_event_analysis_tbl.md)
2.  Fix [\#315](https://github.com/spsanderson/healthyR.ts/issues/315) -
    Add function
    [`ts_lag_correlation()`](https://www.spsanderson.com/healthyR.ts/reference/ts_lag_correlation.md)
3.  Fix [\#327](https://github.com/spsanderson/healthyR.ts/issues/327) -
    Add some date helpers
4.  Fix [\#326](https://github.com/spsanderson/healthyR.ts/issues/326) -
    Add functions
    [`ci_hi()`](https://www.spsanderson.com/healthyR.ts/reference/ci_hi.md)
    and
    [`ci_lo()`](https://www.spsanderson.com/healthyR.ts/reference/ci_lo.md)
5.  Fix [\#325](https://github.com/spsanderson/healthyR.ts/issues/325) -
    Add function
    [`ts_event_analysis_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_event_analysis_plot.md)

### Minor Fixes and Improvements

1.  Fix [\#333](https://github.com/spsanderson/healthyR.ts/issues/333) -
    Update
    [`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)
    and
    [`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)
    to accept `svm_poly` and `svm_rbf`. This helps in allowing users to
    auto tune models that are create by
    [`ts_wfs_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_poly.md)
    and
    [`ts_wfs_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_rbf.md)
    functions respectively. Also added “model_spec_class” to the output
    of the
    [`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)
    function.

## healthyR.ts 0.2.0

CRAN release: 2022-06-09

### Breaking Changes

None

### New Features

1.  Fix [\#277](https://github.com/spsanderson/healthyR.ts/issues/277) -
    Add function
    [`ts_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima.md)
    boiler plate function.
2.  Fix [\#284](https://github.com/spsanderson/healthyR.ts/issues/284) -
    Add functions
    [`color_blind()`](https://www.spsanderson.com/healthyR.ts/reference/color_blind.md)
    [`ts_scale_fill_colorblind()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scale_fill_colorblind.md)
    and
    [`ts_scale_color_colorblind()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scale_color_colorblind.md)
3.  Fix [\#278](https://github.com/spsanderson/healthyR.ts/issues/278) -
    Add function
    [`ts_auto_smooth_es()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_smooth_es.md)
4.  Fix [\#279](https://github.com/spsanderson/healthyR.ts/issues/279) -
    Add function
    [`ts_auto_theta()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_theta.md)
5.  Fix [\#280](https://github.com/spsanderson/healthyR.ts/issues/280) -
    Add function
    [`ts_auto_lm()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_lm.md)
6.  Fix [\#281](https://github.com/spsanderson/healthyR.ts/issues/281) -
    Add function
    [`ts_auto_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_poly.md)
7.  Fix [\#282](https://github.com/spsanderson/healthyR.ts/issues/282) -
    Add function
    [`ts_auto_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_svm_rbf.md)

### Minor Fixes and Improvements

1.  Fix [\#275](https://github.com/spsanderson/healthyR.ts/issues/275) -
    Correct `ts_auto_arima_xgboots()` when `.tune` is FALSE.
2.  Fix [\#286](https://github.com/spsanderson/healthyR.ts/issues/286) -
    Change the boilerplate recipe to keep the date column and change it
    to a numeric rather than using step_rm() instead use
    step_mutate(as.numeric())
3.  Fix [\#288](https://github.com/spsanderson/healthyR.ts/issues/288) -
    Update tune template helper function smooth_es to use
    [`tune::tune()`](https://hardhat.tidymodels.org/reference/tune.html)
4.  Fix [\#291](https://github.com/spsanderson/healthyR.ts/issues/291) -
    Move kmeans functions from using `healthyR` to `healthyR.ai` in
    anticipation of dropping `kmeans` functionality from `healthyR`

## healthyR.ts 0.1.9

CRAN release: 2022-04-26

### Breaking Changes

None

### New Features

1.  Fix [\#223](https://github.com/spsanderson/healthyR.ts/issues/223) -
    Add function
    [`ts_arima_simulator()`](https://www.spsanderson.com/healthyR.ts/reference/ts_arima_simulator.md)
2.  Fix [\#227](https://github.com/spsanderson/healthyR.ts/issues/227) -
    Add function
    [`ts_feature_cluster()`](https://www.spsanderson.com/healthyR.ts/reference/ts_feature_cluster.md)
3.  Fix [\#228](https://github.com/spsanderson/healthyR.ts/issues/228) -
    Add function
    [`ts_feature_cluster_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_feature_cluster_plot.md)
4.  Fix [\#241](https://github.com/spsanderson/healthyR.ts/issues/241) -
    Add function
    [`ts_auto_glmnet()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_glmnet.md)
5.  Fix [\#243](https://github.com/spsanderson/healthyR.ts/issues/243) -
    Add function
    [`ts_auto_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_xgboost.md)
6.  Fix [\#244](https://github.com/spsanderson/healthyR.ts/issues/244) -
    Add function
    [`ts_auto_arima_xgboost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_arima_xgboost.md)
7.  Fix [\#245](https://github.com/spsanderson/healthyR.ts/issues/245) -
    Add function
    [`ts_auto_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_mars.md)
8.  Fix [\#246](https://github.com/spsanderson/healthyR.ts/issues/246) -
    Add function
    [`ts_auto_exp_smoothing()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_exp_smoothing.md)
9.  Fix [\#247](https://github.com/spsanderson/healthyR.ts/issues/247) -
    Add function
    [`ts_auto_croston()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_croston.md)
10. Fix [\#248](https://github.com/spsanderson/healthyR.ts/issues/248) -
    Add function
    [`ts_auto_nnetar()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_nnetar.md)
11. Fix [\#250](https://github.com/spsanderson/healthyR.ts/issues/250) -
    Add function
    [`ts_auto_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_reg.md)
12. Fix [\#251](https://github.com/spsanderson/healthyR.ts/issues/251) -
    Add function
    [`ts_auto_prophet_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_prophet_boost.md)

### Minor Fixes and Improvements

1.  Fix [\#212](https://github.com/spsanderson/healthyR.ts/issues/212) -
    Update recipes to use the new `[recipes::print_step()]` method.
2.  Fix [\#229](https://github.com/spsanderson/healthyR.ts/issues/229) -
    Change all plots to
    [`ggplot2::theme_minimal()`](https://ggplot2.tidyverse.org/reference/ggtheme.html)
3.  Fix [\#242](https://github.com/spsanderson/healthyR.ts/issues/242) -
    Add `hardhat` to DESCRIPTION since functionality like extracting
    dials parameters was taken out of dials and moved to hardhat.

## healthyR.ts 0.1.8

CRAN release: 2022-02-25

### Breaking Changes

None

### New Features

1.  Fix [\#201](https://github.com/spsanderson/healthyR.ts/issues/201) -
    Add Fitted `ts` and Fitted `tibble` data to output.
2.  Fix [\#202](https://github.com/spsanderson/healthyR.ts/issues/202) -
    Add Residuals `ts` and Residuals `tibble` data to output.
3.  Fix [\#204](https://github.com/spsanderson/healthyR.ts/issues/204) -
    Add
    [`Arima()`](https://pkg.robjhyndman.com/forecast/reference/Arima.html)
    models with xreg to
    [`ts_forecast_simulator()`](https://www.spsanderson.com/healthyR.ts/reference/ts_forecast_simulator.md)

### Minor Fixes and Improvements

1.  Fix [\#199](https://github.com/spsanderson/healthyR.ts/issues/199) -
    Update
    [`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md)
    to utilize `forecast:::arima.string()` under the hood for `Arima`
    `arima` and `auto.arima` models produced by the `forecast` package.
2.  Fix [\#195](https://github.com/spsanderson/healthyR.ts/issues/195) -
    Drop need for `crayon`, `cli`, and `rstudioapi` since all it did was
    make a welcome message that can be done with regular
    [`print()`](https://rdrr.io/r/base/print.html) method.
3.  Fix [\#213](https://github.com/spsanderson/healthyR.ts/issues/213) -
    Update navigation bar.

## healthyR.ts 0.1.7

CRAN release: 2021-12-11

### Breaking Changes

None

### New Features

1.  Fix [\#181](https://github.com/spsanderson/healthyR.ts/issues/181) -
    Add function
    [`ts_qq_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_qq_plot.md)
2.  Fix [\#180](https://github.com/spsanderson/healthyR.ts/issues/180) -
    Add function
    [`ts_scedacity_scatter_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_scedacity_scatter_plot.md)
3.  Fix [\#179](https://github.com/spsanderson/healthyR.ts/issues/179) -
    Add function
    [`ts_model_rank_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_rank_tbl.md)

### Minor Fixes and Improvments

1.  Fix [\#178](https://github.com/spsanderson/healthyR.ts/issues/178) -
    Extend
    [`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md)
    to grab `workflow` `model_spec` and `model_fit` objects.

## healthyR.ts 0.1.6

CRAN release: 2021-12-04

### Breaking Changes

None

### New Features

1.  Fix [\#157](https://github.com/spsanderson/healthyR.ts/issues/157) -
    Add function
    [`ts_vva_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_vva_plot.md)
2.  Fix [\#149](https://github.com/spsanderson/healthyR.ts/issues/149) -
    Add function
    [`ts_model_compare()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_compare.md)
3.  Fix [\#156](https://github.com/spsanderson/healthyR.ts/issues/156) -
    Add functions:

- [`ts_acceleration_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_vec.md)
- [`ts_acceleration_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_acceleration_augment.md)
- [`step_ts_acceleration()`](https://www.spsanderson.com/healthyR.ts/reference/step_ts_acceleration.md)

4.  Fix [\#155](https://github.com/spsanderson/healthyR.ts/issues/155) -
    Add functions:

- [`ts_velocity_vec()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_vec.md)
- [`ts_velocity_augment()`](https://www.spsanderson.com/healthyR.ts/reference/ts_velocity_augment.md)
- [`step_ts_velocity()`](https://www.spsanderson.com/healthyR.ts/reference/step_ts_velocity.md)

### Minor Fixes and Improvements

1.  Fix [\#159](https://github.com/spsanderson/healthyR.ts/issues/159) -
    Add parameter `.date_col` to
    [`ts_sma_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_sma_plot.md)
    so that if a tibble is passed the appropriate column is passed to
    the `ggplot` object.
2.  Fix [\#164](https://github.com/spsanderson/healthyR.ts/issues/164) -
    Update
    [`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md)
    function to extract workflow fit models.

## healthyR.ts 0.1.5

CRAN release: 2021-11-10

### Breaking Changes

None

### New Features

None

### Minor Fixes and Improvements

Fix [\#143](https://github.com/spsanderson/healthyR.ts/issues/143) -
Drop `mtry = tune::tune()` from `ts_model_spec_tune_template` as it
causes issues downstream.

## healthyR.ts 0.1.4

CRAN release: 2021-10-31

### Breaking Changes

None

### New Features

1.  Fix [\#90](https://github.com/spsanderson/healthyR.ts/issues/90) -
    Add
    [`tidy_fft()`](https://www.spsanderson.com/healthyR.ts/reference/tidy_fft.md)
    function
2.  Fix [\#92](https://github.com/spsanderson/healthyR.ts/issues/92) -
    Add
    [`ts_info_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_info_tbl.md)
    function
3.  Fix [\#96](https://github.com/spsanderson/healthyR.ts/issues/96) -
    Add
    [`ts_sma_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_sma_plot.md)
    function
4.  Fix [\#98](https://github.com/spsanderson/healthyR.ts/issues/98) -
    Add
    [`ts_to_tbl()`](https://www.spsanderson.com/healthyR.ts/reference/ts_to_tbl.md)
    function
5.  Fix [\#103](https://github.com/spsanderson/healthyR.ts/issues/103) -
    Add
    [`ts_model_auto_tune()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_auto_tune.md)
    function
6.  Fix [\#104](https://github.com/spsanderson/healthyR.ts/issues/104) -
    Add
    [`ts_model_spec_tune_template()`](https://www.spsanderson.com/healthyR.ts/reference/ts_model_spec_tune_template.md)
    function
7.  Fix [\#114](https://github.com/spsanderson/healthyR.ts/issues/114) -
    Add
    [`ts_wfs_auto_arima()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_auto_arima.md)
    function
8.  Fix [\#117](https://github.com/spsanderson/healthyR.ts/issues/117) -
    Add
    [`ts_wfs_arima_boost()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_arima_boost.md)
    function
9.  Fix [\#122](https://github.com/spsanderson/healthyR.ts/issues/122) -
    Add
    [`ts_wfs_ets_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_ets_reg.md)
    function
10. Fix [\#125](https://github.com/spsanderson/healthyR.ts/issues/125) -
    Add
    [`ts_wfs_nnetar_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_nnetar_reg.md)
    function
11. Fix [\#128](https://github.com/spsanderson/healthyR.ts/issues/128) -
    Add
    [`ts_wfs_prophet_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_prophet_reg.md)
    function

### Minor Fixes and Improvements

1.  Fix [\#105](https://github.com/spsanderson/healthyR.ts/issues/105) -
    Fix
    [`ts_auto_recipe()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_recipe.md)
    bug that forced the change of column names in the output. This has
    been fixed and the column names supplied will now be in the recipe
    terms.

## healthyR.ts 0.1.3

CRAN release: 2021-08-23

### Breaking Changes

None

### New Features

1.  Fix [\#36](https://github.com/spsanderson/healthyR.ts/issues/36) -
    Add
    [`ts_forecast_simulator()`](https://www.spsanderson.com/healthyR.ts/reference/ts_forecast_simulator.md)
    function
2.  Fix [\#45](https://github.com/spsanderson/healthyR.ts/issues/45) -
    Add
    [`calibrate_and_plot()`](https://www.spsanderson.com/healthyR.ts/reference/calibrate_and_plot.md)
    helper function
3.  Fix [\#46](https://github.com/spsanderson/healthyR.ts/issues/46) -
    Add
    [`ts_wfs_lin_reg()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_lin_reg.md),
    [`ts_wfs_mars()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_mars.md),
    [`ts_wfs_svm_poly()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_poly.md),
    [`ts_wfs_svm_rbf()`](https://www.spsanderson.com/healthyR.ts/reference/ts_wfs_svm_rbf.md)
4.  Fix [\#47](https://github.com/spsanderson/healthyR.ts/issues/47) -
    Add
    [`model_extraction_helper()`](https://www.spsanderson.com/healthyR.ts/reference/model_extraction_helper.md)
    helper function
5.  Fix [\#51](https://github.com/spsanderson/healthyR.ts/issues/51) -
    Add
    [`ts_ma_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_ma_plot.md)
    plotting function
6.  Fix [\#59](https://github.com/spsanderson/healthyR.ts/issues/59) -
    Add
    [`ts_calendar_heatmap_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_calendar_heatmap_plot.md)
    plotting function
7.  Fix [\#65](https://github.com/spsanderson/healthyR.ts/issues/65) -
    Add
    [`ts_splits_plot()`](https://www.spsanderson.com/healthyR.ts/reference/ts_splits_plot.md)
    plotting function

### Minor Fixes and Improvements

1.  Fix [\#40](https://github.com/spsanderson/healthyR.ts/issues/40) -
    Add ggplot object
2.  Fix [\#54](https://github.com/spsanderson/healthyR.ts/issues/54) -
    Drop xts::legend and add .align = “right” to slidify_vec function
3.  Fix [\#62](https://github.com/spsanderson/healthyR.ts/issues/62) -
    Fix ggplot title for Arima models

## healthyR.ts 0.1.2

CRAN release: 2021-06-25

### Breaking Changes

None

### New Features

1.  Fix [\#16](https://github.com/spsanderson/healthyR.ts/issues/16) -
    Add
    [`ts_auto_recipe()`](https://www.spsanderson.com/healthyR.ts/reference/ts_auto_recipe.md)
    function

### Minor Fixes and Improvments

None

## healthyR.ts 0.1.1

CRAN release: 2021-02-09

- update DESCRIPTION file and minor cleanups
- GitHub release:
  <https://github.com/spsanderson/healthyR.ts/releases/tag/v0.1.1>

## healthyR.ts 0.1.0

CRAN release: 2021-01-22

- Added functions

1.  ts_qc_run_chart
2.  ts_compare_data

## healthyR.ts 0.0.0.9001

- Added fuctions

1.  ts_random_walk
2.  ts_random_walk_ggplot_layers

## healthyR.ts 0.0.0.9000

- Added a `NEWS.md` file to track changes to the package.
