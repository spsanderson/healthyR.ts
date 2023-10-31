#' Get Time Series Information
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description
#' This function will take in a data set and return to you a tibble of useful
#' information.
#'
#' @details
#' This function can accept objects of the following classes:
#'   * ts
#'   * xts
#'   * mts
#'   * zoo
#'   * tibble/data.frame
#'
#' The function will return the following pieces of information in a tibble:
#'   * name
#'   * class
#'   * frequency
#'   * start
#'   * end
#'   * var
#'   * length
#'
#' @param .data The data you are passing to the function
#' @param .date_col This is only needed if you are passing a tibble.
#'
#' @examples
#' ts_info_tbl(AirPassengers)
#' ts_info_tbl(BJsales)
#'
#' @return
#' A tibble
#' @name ts_info_tbl
NULL

#' @export ts_info_tbl
#' @rdname ts_info_tbl

ts_info_tbl <- function(.data, .date_col){

    # Internal Data Var ----
    ts_obj <- .data

    # * Checks ----
    if(!stats::is.ts(ts_obj) & !xts::is.xts(ts_obj) & !zoo::is.zoo(ts_obj) & !is.data.frame(ts_obj)){
        stop(call. = FALSE, "(.data) must be a valid time series object, ts, xts, mts, zoo, or tibble/data.frame.")
    }

    ts_name <- NULL
    ts_info <- NULL

    # Get Name
    ts_name <- base::deparse(base::substitute(.data))

    # * TS Object Tyep ----
    # ** Stats TS Object ----
    if(stats::is.ts(ts_obj) & !stats::is.mts(ts_obj)){
        ts_info  <- tibble::tibble(
            name = ts_name,
            class = "ts",
            frequency = stats::frequency(ts_obj),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = "univariate",
            length = base::length(ts_obj)
        )
    } else if(stats::is.ts(ts_obj) & stats::is.mts(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "mts",
            frequency = stats::frequency(ts_obj),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = base::paste(dim(ts_obj)[2], "variables", sep = " "),
            length = base::dim(ts_obj)[1],
        )
    } else if(xts::is.xts(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "xts",
            frequency = dplyr::case_when(
                xts::periodicity(ts_obj)$scale != "minute" ~ xts::periodicity(ts_obj)$scale
                , TRUE ~ base::paste(xts::periodicity(ts_obj)$frequency, xts::periodicity(ts_obj)$units, collapse = " ")
            ),
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                "univariate"
            } else if(dim(ts_obj)[2] == 1){
                base::paste(dim(ts_obj)[2], "variable", sep = " ")
            } else if (dim(ts_obj)[2] > 1){
                base::paste(dim(ts_obj)[2], "variables", sep = " ")
            },
            length = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                base::length(ts_obj)
            } else {
                base::dim(ts_obj)[1]
            }
        )
    } else if(zoo::is.zoo(ts_obj)){
        ts_info <- tibble::tibble(
            name = ts_name,
            class = "zoo",
            frequency = xts::periodicity(ts_obj)$scale,
            start = base::paste(stats::start(ts_obj), collapse = " "),
            end = base::paste(stats::end(ts_obj), collapse = " "),
            var = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                "univariate"
            } else if(dim(ts_obj)[2] == 1){
                base::paste(dim(ts_obj)[2], "variable", sep = " ")
            } else {
                base::paste(dim(ts_obj)[2], "variables", sep = " ")
            },
            length = if(base::is.null(base::dim(ts_obj)) & !base::is.null(base::length(ts_obj))){
                base::length(ts_obj)
            } else if(dim(ts_obj)[2] == 1){
                base::dim(ts_obj)[1]
            } else {
                base::length(ts_obj)
            }
        )
    } else if(is.data.frame(ts_obj)){
        date_var <- rlang::enquo(.date_col)
        if(rlang::quo_is_missing(date_var)){
            stop(call. = FALSE, "(.date_col) must be supplied when passing a tibble.")
        }
        date_val <- ts_obj %>% dplyr::pull( {{ date_var }} )
        tk_ts_sum <- timetk::tk_get_timeseries_summary(date_val)

        ts_info <- tibble::tibble(
            name = ts_name,
            class = "data.frame",
            frequency = tk_ts_sum$scale,
            start = tk_ts_sum$start,
            end = tk_ts_sum$end,
            var = base::ncol(ts_obj) - 1,
            length = tk_ts_sum$n.obs
        )
    }

    # * Return ----
    return(ts_info)
}
