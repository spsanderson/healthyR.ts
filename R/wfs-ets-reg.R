#' Auto Arima XGBoost Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://business-science.github.io/modeltime/reference/exp_smoothing.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This uses the following engines:
#'
#' [modeltime::exp_smoothing()] exp_smoothing() is a way to generate a specification
#' of an Exponential Smoothing model before fitting and allows the model to be
#' created using different packages. Currently the only package is forecast.
#' Several algorithms are implemented:
#' -  "ets"
#' -  "croston"
#' -  "theta"
#' -  "smooth_es
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::exp_smoothing()] under the hood and can take one of the following:
#'   * "ets"
#'   * "croston"
#'   * "theta"
#'   * "smooth_es"
#'   * "all_engines" - This will make a model spec for all available engines.
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .seasonal_period A seasonal frequency. Uses "auto" by default.
#' A character phrase of "auto" or time-based phrase of "2 weeks" can be used
#' if a date or date-time variable is provided. See Fit Details below.
#' @param .error The form of the error term: "auto", "additive", or
#' "multiplicative". If the error is multiplicative, the data must be non-negative.
#' @param .trend The form of the trend term: "auto", "additive", "multiplicative"
#' or0 "none".
#' @param .season The form of the seasonal term: "auto", "additive",
#' "multiplicative" or "none".
#' @param .damping Apply damping to a trend: "auto", "damped", or "none".
#' @param .smooth_level This is often called the "alpha" parameter used as the
#' base level smoothing factor for exponential smoothing models.
#' @param .smooth_trend This is often called the "beta" parameter used as the
#' trend smoothing factor for exponential smoothing models.
#' @param .smooth_seasonal This is often called the "gamma" parameter used as
#' the seasonal smoothing factor for exponential smoothing models.
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
#' rec_objs <- ts_auto_recipe(
#'  .data = training(splits)
#'  , .date_col = date_col
#'  , .pred_col = value
#' )
#'
#' wf_sets <- ts_wfs_ets_reg("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_ets_reg <- function(.model_type = "all_engines",
                           .recipe_list,
                           .seasonal_period = "auto",
                           .error = "auto",
                           .trend = "auto",
                           .season = "auto",
                           .damping = "auto",
                           .smooth_level = 0.1,
                           .smooth_trend = 0.1,
                           .smooth_seasonal = 0.1
){

    # * Tidyeval ----
    model_type      = .model_type
    recipe_list     = recipe_list
    seasonal_period = .seasonal_period
    error           = .error
    trend           = .trend
    season          = .season
    damping         = .damping
    smooth_level    = .smooth_level
    smooth_trend    = .smooth_trend
    smooth_seasonal = .smooth_seasonal

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be a character like 'ets','theta','croston','smooth_ets','all_engines'")
    }

    if (!model_type %in% c("ets","croston","theta","smooth_ets","all_engines")){
        stop(call. = FALSE, "(.model_type) must be one of the following, 'ets','croston','theta','smooth_ets','all_engines'")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }



}
