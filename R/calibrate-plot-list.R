#' Time-series Forecasting Simulator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is a helper function. It will take in a set of pre-processors and then
#' calibrate and plot them.
#'
#' @details This function expects to take in ...
#'
#' @param .type
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
calibrate_and_plot <- function(..., type = "testing"){

    if(type == "testing"){
        new_data = testing(splits)
    } else {
        new_data = training(splits) %>%
            drop_na()
    }

    calibration_tbl <- modeltime_table(...) %>%
        modeltime_calibrate(new_data)

    print(calibration_tbl %>% modeltime_accuracy())

    calibration_tbl %>%
        modeltime_forecast(
            new_data = new_data
            , actual_data = data_prepared_tbl
        ) %>%
        plot_modeltime_forecast(
            .conf_interval_show = FALSE
        )
}

calibrate_and_plot(
    wflw_fit_glmnet_spline,
    wflw_fit_glmnet_lag,
    type = "testing"
)
