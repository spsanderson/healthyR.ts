#' Coerce a time-series object to a tibble
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description This function takes in a time-series object and returns it in a
#' `tibble` format.
#'
#' @details
#'
#' @param
#'
#' @examples
#'
#' @return
#'
#' @export ts_to_tbl
#'

ts_to_tbl <- function(.data){

    ts_obj <- .data

    # * Checks ----
    if(!stats::is.ts(ts_obj) & !xts::is.xts(ts_obj) & !zoo::is.zoo(ts_obj) & !stats::is.mts(ts_obj)){
        stop(call. = FALSE, "(.data) needs to be one of ts, xts, mts, or zoo.")
    }

    # * Manipulate ----
    ts_tbl <- timetk::tk_tbl(ts_obj) %>%
        dplyr::mutate(
            date_col = base::paste0(
                lubridate::year(index),
                "-",
                lubridate::month(index),
                "-01"
            ) %>%
                lubridate::ymd()
        ) %>%
        dplyr::select(index, date_col, dplyr::everything())

    # * Return ----
    return(ts_tbl)

}
