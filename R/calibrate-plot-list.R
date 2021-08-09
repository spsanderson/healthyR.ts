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
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(ggplot2))
#' suppressPackageStartupMessages(library(plotly))
#' suppressPackageStartupMessages(library(tidyquant))
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
#'
#' @return
#' The original time series, the simulated values and a some plots
#'
#' @export calibrate_and_plot

# *** PLOTTING UTILITY *** ----
# - Calibrate & Plot
calibrate_and_plot <- function(..., type = "testing", .splits_obj, .data){

    # Tidyeval ----
    workflow_var_expr <- rlang::enquos(...)
    splits_obj        <- .splits_obj

    # Checks ----
    if(type == "testing"){
        new_data = testing(splits_obj)
    } else {
        new_data = training(splits_obj) %>%
            drop_na()
    }

    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) is missing or is not a data.frame/tibble, please supply.")
    }

    if(!class(splits_obj) == "rsplit") {
        stop(call. = FALSE, ("(.splits) is missing or is not a rsplit or ts_cv_split. Please supply."))
    }

    if(!class({{{ workflow_var_expr }}}) == "workflow") {
        stop(call. = FALSE, "Must provide a workflow object")
    }

    # Data
    data <- .data

    # Calibration Tibble
    calibration_tbl <- modeltime_table({{{ workflow_var_expr }}}) %>%
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
