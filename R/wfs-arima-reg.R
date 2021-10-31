#' Auto Arima (Forecast auto_arima) Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://business-science.github.io/modeltime/reference/arima_reg.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This only uses the option `set_engine("auto_arima")` and therefore the .model_type
#' is not needed. The parameter is kept because it is possible in the future that
#' this could change, and it keeps with the framework of how other functions
#' are written.
#'
#' [modeltime::arima_reg()] arima_reg() is a way to generate a specification of
#' an ARIMA model before fitting and allows the model to be created using
#' different packages. Currently the only package is `forecast`.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::arima_reg()] under the hood and can take one of the following:
#'   * "auto_arima"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
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
#' wf_sets <- ts_wfs_auto_arima("auto_arima", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_auto_arima <- function(.model_type = "auto_arima", .recipe_list){

    # * Tidyeval ---
    model_type   = .model_type
    recipe_list  = .recipe_list

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be set to a character string.")
    }

    if (!model_type %in% c("auto_arima")){
        stop(call. = FALSE, "(.model_type) must be 'auto_arima'.")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    # * Models ----
    model_spec_auto_arima <- modeltime::arima_reg(
        mode = "regression",
    ) %>%
        parsnip::set_engine("auto_arima")

    final_model_list <- list(
        model_spec_auto_arima
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


