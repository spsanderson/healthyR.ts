#' Extract Boilerplate Items
#'
#' @family Boilerplate Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details
#'
#' @description
#'
#' @param
#'
#' @examples
#'
#' @return
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
