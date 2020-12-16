#' Compare data over time periods
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Given a tibble/data.frame, you can get date from two different but comparative
#' date ranges. Lets say you want to compare visits in one year to visits from 2
#' years before without also seeing the previous 1 year. You can do that with
#' this function.
#'
#' @details
#' - Uses the `timetk::filter_by_time()` function in order to filter the date
#' column.
#' - Uses the `timetk::subtract_time()` function to subtract time from the start date.
#'
#' @param .data The date.frame/tibble that holds the data
#' @param .date_col The column with the date value
#' @param .start_date The start of the period you want to analyze
#' @param .end_date The end of the period you want to analyze
#' @param .periods_back How long ago do you want to compare data too. Time units
#' are collapsed using `lubridate::floor_date()`. The value can be:
#'   + second
#'   + minute
#'   + hour
#'   + day
#'   + week
#'   + month
#'   + bimonth
#'   + quarter
#'   + season
#'   + halfyear
#'   + year
#'
#' Arbitrary unique English abbreviations as in the `lubridate::period()` constructor are allowed.
#'
#' @return
#' A tibble.
#'
#' @examples
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(timetk))
#' ts_compare_data(
#'   .data           = healthyR_data
#'   , .date_col     = visit_start_date_time
#'   , .start_date   = "2019-01-01"
#'   , .end_date     = "2019-12-31"
#'   , .periods_back = "2 years"
#'   ) %>%
#'   select(visit_start_date_time) %>%
#'   summarise_by_time(
#'     .date_var = visit_start_date_time
#'     , .by     = "year"
#'     , visits  = n()
#'   )
#'
#' ts_compare_data(
#'  .data = healthyR_data
#'  , .date_col     = visit_end_date_time
#'  , .start_date   = "2019-01-01"
#'  , .end_date     = "2019-12-31"
#'  , .periods_back = "2 years"
#' )
#'
#' @export
#'

ts_compare_data <- function(.data, .date_col, .start_date, .end_date
                            , .periods_back) {

    # Tidyeval
    date_col_var_expr <- rlang::enquo(.date_col)

    start_date   <- as.Date(.start_date)
    end_date     <- as.Date(.end_date)
    periods_back <- .periods_back

    # Compareison Date Range
    start_date_b <- timetk::subtract_time(start_date, periods_back)
    end_date_b   <- timetk::subtract_time(end_date, periods_back)

    # Checks
    if(!is.data.frame(.data)){
        stop(call. = FALSE,"(.data) is missing. Please supply.")
    }

    if(!lubridate::is.Date(start_date)){
        stop(call. = FALSE,"(.start_date) is not a date. Please supply.")
    }

    if(!lubridate::is.Date(end_date)){
        stop(call. = FALSE,"(.end_date) is not a date. Please supply.")
    }

    # Manipulate Data
    data_tbl <- tibble::as_tibble(.data)

    df_a_tbl <- data_tbl %>%
        timetk::filter_by_time(
            .date_var     = {{date_col_var_expr}}
            , .start_date = start_date
            , .end_date   = end_date
        )

    df_b_tbl <- data_tbl %>%
        timetk::filter_by_time(
            .date_var     = {{date_col_var_expr}}
            , .start_date = start_date_b
            , .end_date   = end_date_b
        )

    data_time_filtered_tbl <- rbind(df_a_tbl, df_b_tbl) %>%
        dplyr::arrange({{date_col_var_expr}})

    # Return data
    return(data_time_filtered_tbl)

}
