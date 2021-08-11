#' Time-series Forecasting Simulator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is a helper function. It will take in a set of pre-processors and then
#' calibrate and plot them.
#'
#' @details This function expects to take in workflows
#'
#' @param ... The workflow(s) you want to add to the function.
#' @param .type Either the training(splits) or testing(splits) data.
#' @param .data The full data set.
#' @param .splits_obj The splits object.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(tidyverse))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(tidymodels))
#'
#' data <- healthyR_data %>%
#'  filter(ip_op_flag == "I") %>%
#'    select(visit_end_date_time) %>%
#'    rename(date_col = visit_end_date_time) %>%
#'    summarise_by_time(
#'        .date_var = date_col
#'        , .by     = "month"
#'        , value   = n()
#'   ) %>%
#'    filter_by_time(
#'        .date_var     = date_col
#'        , .start_date = "2012"
#'        , .end_date   = "2019"
#'    )
#'
#' splits <- time_series_split(
#'    data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' rec_obj <- recipe(value ~ ., data = training(splits))
#'
#' model_spec <- linear_reg(
#'    mode = "regression"
#'    , penalty = 0.1
#'    , mixture = 0.5
#' ) %>%
#'    set_engine("lm")
#'
#' wflw <- workflow() %>%
#'    add_recipe(rec_obj) %>%
#'    add_model(model_spec) %>%
#'    fit(training(splits))
#'
#' calibrate_and_plot(
#'   wflw
#'   , .type = "training"
#'   , .splits_obj = splits
#'   , .data = data
#'  )
#'
#' calibrate_and_plot(
#'   wflw
#'   , .type        = "testing"
#'   , .splits_obj = splits
#'   , .data       = data
#' )
#'
#' @return
#' The original time series, the simulated values and a some plots
#'
#' @export calibrate_and_plot

# *** PLOTTING UTILITY *** ----
# - Calibrate & Plot
calibrate_and_plot <- function(..., .type = "testing", .splits_obj, .data){

    # Tidyeval ----
    splits_obj        <- .splits_obj

    # Checks ----
    if(.type == "testing"){
        new_data = testing(splits_obj)
    } else {
        new_data = training(splits_obj) %>%
            drop_na()
    }

    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) is missing or is not a data.frame/tibble, please supply.")
    }

    if(!class(splits_obj)[[1]] == "ts_cv_split") {
        if(!class(splits_obj)[[2]] == "rsplit") {
            stop(call. = FALSE, ("(.splits) is missing or is not an rsplit or ts_cv_split. Please supply."))
        }
        stop(call. = FALSE, ("(.splits) is missing or is not a rsplit or ts_cv_split. Please supply."))
    }

    # Data
    data <- .data

    # Calibration Tibble
    calibration_tbl <- modeltime_table(...) %>%
        modeltime_calibrate(new_data)

    print(calibration_tbl %>% modeltime_accuracy())

    calibration_tbl %>%
        modeltime_forecast(
            new_data = new_data
            , actual_data = data
        ) %>%
        plot_modeltime_forecast(
            .conf_interval_show = FALSE
        )

}
