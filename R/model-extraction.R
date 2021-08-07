#' Time Series Model Extraction
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is a helper function. It will ...
#'
#' @details This function expects to take in ...
#'
#' @param .fit
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
#' data_ts <- tk_ts(data = data, frequency = 12)
#'
#' #Create a model
#' fit_nnetar <- nnetar(data_ts)
#' fit_arima  <- auto.arima(data_ts)
#' fit_ets    <- ets(data_ts)
#'
#'
#' @return
#' The model specification
#'
#' @export model_extraction
