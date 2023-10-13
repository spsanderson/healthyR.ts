#' Augment Data with Time Series Growth Rates
#'
#' @family Augment Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to augment a data frame or tibble with time series
#' growth rates of selected columns. You can provide a data frame or tibble as
#' the first argument, the column(s) for which you want to calculate the growth
#' rates using the `.value` parameter, and optionally specify custom names for
#' the new columns using the `.names` parameter.
#'
#' @param .data A data frame or tibble containing the data to be augmented.
#' @param .value A quosure specifying the column(s) for which you want to
#' calculate growth rates.
#' @param .names Optional. A character vector specifying the names of the new
#' columns to be created. Use "auto" for automatic naming.
#'
#' @examples
#' data <- data.frame(
#'   Year = 1:5,
#'   Income = c(100, 120, 150, 180, 200),
#'   Expenses = c(50, 60, 75, 90, 100)
#' )
#' ts_growth_rate_augment(data, .value = c(Income, Expenses))
#'
#' @return
#' A tibble that includes the original data and additional columns representing
#' the growth rates of the selected columns. The column names are either
#' automatically generated or as specified in the `.names` parameter.
#'
#' @name ts_growth_rate_augment
NULL

#' @export
#' @rdname ts_growth_rate_augment
ts_growth_rate_augment <- function(.data, .value, .names = "auto") {
    column_expr <- rlang::enquo(.value)

    if(rlang::quo_is_missing(column_expr)) stop(call. = FALSE, "ts_growth_rate_augment(.value) is missing.")

    col_nms <- names(tidyselect::eval_select(rlang::enquo(.value), .data))

    make_call <- function(col, scale_type) {
        rlang::call2(
            "ts_growth_rate_vec",
            .x = rlang::sym(col),
            .ns = "healthyR.ts"
        )
    }

    grid <- expand.grid(
        col = col_nms,
        stringsAsFactors = FALSE
    )

    calls <- purrr::pmap(.l = list(grid$col), make_call)

    if (any(.names == "auto")) {
        newname <- paste0("growth_rate_", grid$col)
    } else {
        newname <- as.list(.names)
    }

    calls <- purrr::set_names(calls, newname)

    ret <- dplyr::as_tibble(dplyr::mutate(.data, !!!calls))

    return(ret)
}
