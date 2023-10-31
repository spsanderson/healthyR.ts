#' Time Series Model Tuner
#'
#' @family Model Tuning
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will create a tuned model. It uses the [healthyR.ts::ts_model_spec_tune_template()]
#' under the hood to get the generic template that is used in the grid search.
#'
#' @details
#' This function can work with the following parsnip/modeltime engines:
#' -  "auto_arima"
#' -  "auto_arima_xgboost"
#' -  "ets"
#' -  "croston"
#' -  "theta"
#' -  "stlm_ets"
#' -  "tbats"
#' -  "stlm_arima"
#' -  "nnetar"
#' -  "prophet"
#' -  "prophet_xgboost"
#' -  "lm"
#' -  "glmnet"
#' -  "stan"
#' -  "spark"
#' -  "keras"
#' -  "earth"
#' -  "xgboost"
#' -  "kernlab"
#'
#' This function returns a list object with several items inside of it. There are
#' three categories of items that are inside of the list.
#' -  `data`
#' -  `model_info`
#' -  `plots`
#'
#' The `data` section has the following items:
#' -  `calibration_tbl` This is the calibration data passed into the function.
#' -  `calibration_tuned_tbl` This is a calibration tibble that has used the
#'    tuned workflow.
#' -  `tscv_data_tbl` This is the tibble of the time series cross validation.
#' -  `tuned_results` This is a tuning results tibble with all slices from the
#'     time series cross validation.
#' -  `best_tuned_results_tbl` This is a tibble of the parameters for the best
#'     test set with the chosen metric.
#' -  `tscv_obj` This is the actual time series cross validation object returned
#'     from [timetk::time_series_cv()]
#'
#' The `model_info` section has the following items:
#' -  `model_spec` This is the original modeltime/parsnip model specification.
#' -  `model_spec_engine` This is the engine used for the model specification.
#' -  `model_spec_tuner` This is the tuning model template returned from [healthyR.ts::ts_model_spec_tune_template()]
#' -  `plucked_model` This is the model that we have plucked from the calibration tibble
#'     for tuning.
#' -  `wflw_tune_spec` This is a new workflow with the `model_spec_tuner` attached.
#' -  `grid_spec` This is the grid search specification for the tuning process.
#' -  `tuned_tscv_wflw_spec` This is the final tuned model where the workflow and
#'    model have been finalized. This would be the model that you would want to
#'    pull out if you are going to work with it further.
#'
#' The `plots` section has the following items:
#' -  `tune_results_plt` This is a static ggplot of the grid search.
#' -  `tscv_pl` This is the time series cross validation plan plot.
#'
#' @param .modeltime_model_id The .model_id from a calibrated modeltime table.
#' @param .calibration_tbl A calibrated modeltime table.
#' @param .splits_obj The time_series_split object.
#' @param .drop_training_na A boolean that will drop NA values from the training(splits)
#' data
#' @param .date_col The column that holds the date values.
#' @param .value_col The column that holds the time series values.
#' @param .tscv_assess A character expression like "12 months". This gets passed to
#' [timetk::time_series_cv()]
#' @param .tscv_skip A character expression like "6 months". This gets passed to
#' [timetk::time_series_cv()]
#' @param .slice_limit An integer that gets passed to [timetk::time_series_cv()]
#' @param .facet_ncol The number of faceted columns to be passed to plot_time_series_cv_plan
#' @param .grid_size An integer that gets passed to the [dials::grid_latin_hypercube()]
#' function.
#' @param .num_cores The default is 1, you can set this to any integer value as long
#' as it is equal to or less than the available cores on your machine.
#' @param .best_metric The default is "rmse" and this can be set to any default dials
#' metric. This must be passed as a character.
#'
#' @examples
#' \dontrun{
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#'
#' data <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'     data
#'     , date_col
#'     , assess = 12
#'     , skip = 3
#'     , cumulative = TRUE
#' )
#'
#' rec_objs <- ts_auto_recipe(
#'   .data = data
#'   , .date_col = date_col
#'   , .pred_col = value
#' )
#'
#' wfsets <- ts_wfs_mars(
#'   .model_type = "earth"
#'   , .recipe_list = rec_objs
#' )
#'
#' wf_fits <- wfsets %>%
#'   modeltime_fit_workflowset(
#'     data = training(splits)
#'     , control = control_fit_workflowset(
#'      allow_par = TRUE
#'      , verbose = TRUE
#'     )
#'   )
#'
#' models_tbl <- wf_fits %>%
#'   filter(.model != "NULL")
#'
#' calibration_tbl <- models_tbl %>%
#'   modeltime_calibrate(new_data = testing(splits))
#'
#' output <- ts_model_auto_tune(
#'   .modeltime_model_id = 1,
#'   .calibration_tbl = calibration_tbl,
#'   .splits_obj = splits,
#'   .drop_training_na = TRUE,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .tscv_assess = "12 months",
#'   .tscv_skip = "3 months",
#'   .num_cores = parallel::detectCores() - 1
#' )
#' }
#'
#' @return
#' A list object with multiple items.
#'
#' @name ts_model_auto_tune
NULL

#' @export
#' @rdname ts_model_auto_tune

ts_model_auto_tune <- function(.modeltime_model_id, .calibration_tbl,
                               .splits_obj, .drop_training_na = TRUE, .date_col,
                               .value_col, .tscv_assess = "12 months",
                               .tscv_skip = "6 months", .slice_limit = 6,
                               .facet_ncol = 2, .grid_size = 30, .num_cores = 1,
                               .best_metric = "rmse") {

  # * Tidyeval ----
  model_number <- base::as.integer(.modeltime_model_id)
  calibration_tbl <- .calibration_tbl
  splits_obj <- .splits_obj
  drop_na <- base::as.logical(.drop_training_na)
  date_col <- rlang::enquo(.date_col)
  value_col <- rlang::enquo(.value_col)
  assess <- base::as.character(.tscv_assess)
  skip <- base::as.character(.tscv_skip)
  slice_limit <- .slice_limit
  facet_ncol <- base::as.integer(.facet_ncol)
  grid_size <- base::as.integer(.grid_size)
  num_cores <- base::as.integer(.num_cores)
  best_metric <- base::as.character(.best_metric)


  # * Checks ----
  if (!modeltime::is_calibrated(calibration_tbl)) {
    stop(call. = FALSE, "(.calibration_tbl) must be a calibrated modeltime_table.")
  }

  if (!is.integer(model_number)) {
    stop(call. = FALSE, "(.modeltime_model_id) must be an integer.")
  }

  # * Manipulations ----
  # Get Model
  plucked_model <- calibration_tbl %>%
    modeltime::pluck_modeltime_model(model_number)

  # Get Training Data
  if (!drop_na) {
    training_data <- rsample::training(splits_obj)
  } else {
    training_data <- rsample::training(splits_obj) %>%
      tidyr::drop_na()
  }

  # Make TSCV
  tscv <- timetk::time_series_cv(
    data        = training_data,
    date_var    = {{ date_col }},
    cumulative  = TRUE,
    assess      = assess,
    skip        = skip,
    slice_limit = slice_limit
  )

  # TSCV Data Plan Tibble
  tscv_data_tbl <- tscv %>%
    timetk::tk_time_series_cv_plan()

  # TSCV Plot
  tscv_plt <- tscv_data_tbl %>%
    timetk::plot_time_series_cv_plan(
      {{ date_col }}, {{ value_col }},
      .facet_ncol = {{ facet_ncol }}
    )

  # * Tune Spec ----
  # Model Spec
  model_spec <- plucked_model %>% parsnip::extract_spec_parsnip()
  model_spec_engine <- model_spec[["engine"]]
  model_spec_class <- workflows::extract_spec_parsnip(plucked_model) %>% class()
  model_spec_tuner <- healthyR.ts::ts_model_spec_tune_template(
      model_spec_engine, model_spec_class
      )

  # * Grid Spec ----
  grid_spec <- dials::grid_latin_hypercube(
    tune::parameters(model_spec_tuner),
    size = grid_size
  )

  # * Tune Model ----
  wflw_tune_spec <- plucked_model %>%
    workflows::update_model(model_spec_tuner)

  # * Run Tuning Grid ----
  modeltime::parallel_start(num_cores)

  tune_results <- wflw_tune_spec %>%
    tune::tune_grid(
      resamples = tscv,
      grid = grid_spec,
      metrics = modeltime::default_forecast_accuracy_metric_set(),
      control = tune::control_grid(
        verbose = TRUE,
        save_pred = TRUE
      )
    )

  modeltime::parallel_stop()

  # * Get best result
  best_result_set <- tune_results %>%
    tune::show_best(metric = best_metric, n = 1)

  # * Viz results ----
  tune_results_plt <- tune_results %>%
    tune::autoplot() +
    ggplot2::geom_smooth(se = FALSE)

  # * Retrain and Assess ----
  wflw_tune_spec_tscv <- wflw_tune_spec %>%
    workflows::update_model(model_spec_tuner) %>%
    tune::finalize_workflow(
      tune_results %>%
        tune::show_best(metric = best_metric, n = 1)
    ) %>%
    parsnip::fit(rsample::training(splits_obj))

  # * Calibration Tuned tibble ----
  calibration_tuned_tbl <- modeltime::modeltime_table(
    wflw_tune_spec_tscv
  ) %>%
    modeltime::modeltime_calibrate(rsample::testing(splits_obj))


  # * Return ----
  output <- list(
    data = list(
      calibration_tbl        = calibration_tbl,
      calibration_tuned_tbl  = calibration_tuned_tbl,
      tscv_data_tbl          = tscv_data_tbl,
      tuned_results          = tune_results,
      best_tuned_results_tbl = best_result_set,
      tscv_obj               = tscv
    ),
    model_info = list(
      model_spec           = model_spec,
      model_spec_engine    = model_spec_engine,
      model_spec_class     = model_spec_class,
      model_spec_tuner     = model_spec_tuner,
      plucked_model        = plucked_model,
      wflw_tune_spec       = wflw_tune_spec,
      grid_spec            = grid_spec,
      tuned_tscv_wflw_spec = wflw_tune_spec_tscv
    ),
    plots = list(
      tune_results_plt = tune_results_plt,
      tscv_plt         = tscv_plt
    )
  )

  return(output)
}
