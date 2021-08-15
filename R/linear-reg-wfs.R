#' Helper function - Calibrate and Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is
#'
#' @details This function expects to take
#'
#' @param .type Either the training(splits) or testing(splits) data.
#' @param .data The full data set.
#' @param .splits_obj The splits object.
#' @param .print_info The default is TRUE
#' @param ... The workflow(s) you want to add to the function.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
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
#'
#' @return
#' The
#'


