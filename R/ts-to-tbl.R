#' Coerce a time-series object to a tibble
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description This function takes in a time-series object and returns it in a
#' `tibble` format.
#'
#' @details This function makes use of [timetk::tk_tbl()] under the hood to obtain
#' the initial `tibble` object. After the inital object is obtained a new column
#' called `date_col` is constructed from the `index` column using `lubridate` if
#' an index column is returned.
#'
#' @param .data The time-series object you want transformed into a `tibble`
#'
#' @examples
#'
#' ts_to_tbl(BJsales)
#' ts_to_tbl(AirPassengers)
#'
#' @return
#' A tibble
#'
#' @name ts_to_tbl
NULL

#' @export ts_to_tbl
#' @rdname ts_to_tbl

ts_to_tbl <- function(.data){

    ts_obj <- .data

    # * Checks ----
    if(!stats::is.ts(ts_obj) & !xts::is.xts(ts_obj) & !zoo::is.zoo(ts_obj) &
       !stats::is.mts(ts_obj)){
        stop(call. = FALSE, "(.data) needs to be one of ts, xts, mts, or zoo.")
    }

    # * Manipulate ----
    ts_tbl <- timetk::tk_tbl(ts_obj, silent = TRUE, timetk_idx = TRUE)
    ts_tbl_names <- base::names(ts_tbl)

    if(!ts_tbl_names[1] == "index"){
        ts_tbl <- ts_tbl
    } else {
        ts_tbl <- ts_tbl %>%
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
    }

    # * Return ----
    return(ts_tbl)

}
