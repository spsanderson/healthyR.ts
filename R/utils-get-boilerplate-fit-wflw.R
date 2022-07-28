#' Extract Boilerplate Items
#'
#' @family Boilerplate Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details Extract the fitted workflow from a `ts_auto_` function. This will
#' only work on those functions that are designated as _Boilerplate_.
#'
#' @description Extract the fitted workflow from a `ts_auto_` function.
#'
#' @param .input This is the output list object of a `ts_auto_` function.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' data <- AirPassengers %>%
#'   ts_to_tbl() %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'   data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' ts_lm <- ts_auto_lm(
#'   .data = data,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .rsamp_obj = splits,
#'   .formula = value ~ .,
#' )
#'
#' ts_extract_auto_fitted_workflow(ts_lm)
#' }
#'
#' @return
#' A fitted `workflow` object.
#'
#' @export
#'

ts_extract_auto_fitted_workflow <- function(.input){

    # Input
    input <- .input

    atb <- attributes(input)

    # Checks ----
    if (!inherits(x = input, what = "list")){
        rlang::abort(
            message = "Are you sure you used a 'ts_auto' function?",
            use_cli_format = TRUE
        )
    }

    if (!atb$.function_family == "boilerplate"){
        rlang::abort(
            message = "You must use a 'ts_auto' function."
        )
    }

    # Extract Fitted Workflow
    fitted_wflw <- input$model_info$fitted_wflw

    return(fitted_wflw)
}
