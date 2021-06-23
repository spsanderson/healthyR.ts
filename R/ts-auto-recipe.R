#' Build a Time Series Recipe
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#'
#' @details
#'
#' @param .data The data that is going to be modeled.
#' @param .date_col The column that holds the date for the time series.
#' @param .pred_col The column that is to be predicted, the value.
#'
#' @examples
#'
#' @export
#'

ts_auto_recipe <- function(.data
                           , .date_col
                           , .pred_col) {

    # * Tidyeval ----
    date_col_var_expr <- rlang::enquo(.date_col)
    pred_col_var_expr <- rlang::enquo(.pred_col)

    # * Checks ----
    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) is missing, please supply.")
    }

}
