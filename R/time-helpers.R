#' Get date or datetime variables (column names)
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @param data An object of class `data.frame`
#'
#' @return
#' A vector containing the column names that are of date/date-like classes.
#'
#' @details
#' `ts_get_date_columns` returns the column names of date or datetime variables
#' in a data frame.
#'
#' @examples
#' ts_to_tbl(AirPassengers) %>%
#'   ts_get_date_columns()
#'
#' @export
#'

ts_get_date_columns <- function(.data){

    # Checks ----
    if (!is.data.frame(.data)) {
        rlang::abort(
            message = "'.data' must be a data.frame/tibble.",
            use_cli_format = TRUE
        )
    }

    # Get columns
    col_class <- lapply(.data, class)

    date_col_class <- (sapply(col_class, function(x) 'POSIXt' %in% x) |
                           sapply(col_class, function(x) 'Date' %in% x) |
                           sapply(col_class, function(x) 'yearmon' %in% x) |
                           sapply(col_class, function(x) 'yearqtr' %in% x))

    # Return
    return(names(which(date_col_class)))
}

#' Check if an object is a date class
#'
#' @family Utility
#'
#' @param .x A vector to check
#'
#' @return Logical (TRUE/FALSE)
#'
#' @examples
#'
#' seq.Date(from = as.Date("2022-01-01"), by = "day", length.out = 10) %>%
#' ts_is_date_class()
#'
#' letters %>% ts_is_date_class()
#'
#'
#' @export

ts_is_date_class <- function(.x) {

    classes <- class(.x)

    (sapply(classes, function(x) 'POSIXt' %in% x) |
            sapply(classes, function(x) 'Date' %in% x) |
            sapply(classes, function(x) 'yearmon' %in% x) |
            sapply(classes, function(x) 'yearqtr' %in% x)) %>%
        any()
}
