#' Augment Function Velocity
#'
#' @family Augment Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Takes a numeric vector and will return the velocity of that vector.
#'
#' @details
#' Takes a numeric vector and will return the velocity of that vector. The
#' velocity of a time series is computed by taking the first difference, so
#' \deqn{x_t - x_t1}
#'
#' This function is intended to be used on its own in order to add columns to a
#' tibble.
#'
#' @param .data The data being passed that will be augmented by the function.
#' @param .value This is passed [rlang::enquo()] to capture the vectors you want
#' to augment.
#' @param .names The default is "auto"
#'
#' @examples
#' suppressPackageStartupMessages(library(dplyr))
#'
#' len_out    = 10
#' by_unit    = "month"
#' start_date = as.Date("2021-01-01")
#'
#' data_tbl <- tibble(
#'   date_col = seq.Date(from = start_date, length.out = len_out, by = by_unit),
#'   a    = rnorm(len_out),
#'   b    = runif(len_out)
#' )
#'
#' ts_velocity_augment(data_tbl, b)
#'
#' @return
#' A augmented
#'
#' @name ts_velocity_augment
NULL

#' @export
#' @rdname ts_velocity_augment

ts_velocity_augment <- function(.data, .value, .names = "auto"){

    column_expr <- rlang::enquo(.value)

    if(rlang::quo_is_missing(column_expr)) stop(call. = FALSE, ".value is missing.")

    col_nms <- names(tidyselect::eval_select(rlang::enquo(.value), .data))

    make_call <- function(col){
        rlang::call2(
            "ts_velocity_vec",
            .x = rlang::sym(col),
            .ns = "healthyR.ts"
        )
    }

    grid <- expand.grid(
        col = col_nms
        , stringsAsFactors = FALSE
    )

    calls <- purrr::pmap(.l = list(grid$col), make_call)

    if(any(.names == "auto")) {
        newname <- paste0("velocity_", grid$col)
    } else {
        newname <- as.list(.names)
    }

    calls <- purrr::set_names(calls, newname)

    ret <- tibble::as_tibble(dplyr::mutate(.data, !!!calls))

    return(ret)

}
