#' Auto NNETAR Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://business-science.github.io/modeltime/reference/nnetar_reg.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This uses the following engines:
#'
#' [modeltime::nnetar_reg()] nnetar_reg() is a way to generate a specification
#' of an NNETAR model before fitting and allows the model to be created using
#' different packages. Currently the only package is forecast.
#' -  "nnetar"
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::nnetar_reg()] under the hood and can take one of the following:
#'   * "nnetar"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .non_seasonal_ar The order of the non-seasonal auto-regressive (AR) terms.
#' Often denoted "p" in pdq-notation.
#' @param .seasonal_ar The order of the seasonal auto-regressive (SAR) terms.
#' Often denoted "P" in PDQ-notation.
#' @param .hidden_units An integer for the number of units in the hidden model.
#' @param .num_networks Number of networks to fit with different random starting
#' weights. These are then averaged when producing forecasts.
#' @param .penalty A non-negative numeric value for the amount of weight decay.
#' @param .epochs An integer for the number of training iterations.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(tidymodels))
#'
#' data <- AirPassengers %>%
#'   ts_to_tbl() %>%
#'   select(-index)
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
#' wf_sets <- ts_wfs_nnetar_reg("nnetar", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_nnetar_reg <- function(.model_type = "nnetar",
                           .recipe_list,
                           .non_seasonal_ar = 0,
                           .seasonal_ar = 0,
                           .hidden_units = 5,
                           .num_networks = 10,
                           .penalty = .1,
                           .epochs = 10
){

    # * Tidyeval ----
    model_type      = .model_type
    recipe_list     = .recipe_list
    non_seasonal_ar = .non_seasonal_ar
    seasonal_ar     = .seasonal_ar
    hidden_units    = .hidden_units
    num_networks    = .num_networks
    penalty         = .penalty
    epochs          = .epochs

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be a character like 'nnetar'")
    }

    if (!model_type %in% c("nnetar")){
        stop(call. = FALSE, "(.model_type) must be one of the following, 'nnetar'")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    # * Models ----
    model_spec_nnetar <- modeltime::nnetar_reg(
        seasonal_period   = "auto"
        , non_seasonal_ar = non_seasonal_ar
        , seasonal_ar     = seasonal_ar
        , hidden_units    = hidden_units
        , num_networks    = num_networks
        , penalty         = penalty
        , epochs          = epochs
    ) %>%
        parsnip::set_engine("nnetar")

    final_model_list <- list(
            model_spec_nnetar
        )

    # * Workflow Sets ----
    wf_sets <- workflowsets::workflow_set(
        preproc = recipe_list,
        models  = final_model_list,
        cross   = TRUE
    )

    # * Return ---
    return(wf_sets)

}
