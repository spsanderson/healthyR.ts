#' Event Analysis
#'
#' @family Time_Filtering
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Given a tibble/data.frame, you can get information on what happens before, after,
#' or in both directions of some given event, where the event is defined by some
#' percentage increase/decrease in values from time `t` to `t+1`
#'
#' @details
#' This takes in a `data.frame`/`tibble` of a time series. It requires a date column,
#' and a value column. You can convert a `ts`/`xts`/`zoo`/`mts` object into a tibble by
#' using the `ts_to_tbl()` function.
#'
#' You will provide the function with a percentage change in the form of -1 to 1
#' inclusive. You then provide a time horizon in which you want to see. For example
#' you may want to see what happens to `AirPassengers` after a 0.1 percent increase
#' in volume.
#'
#' The next most important thing to supply is the direction. Do you want to see what
#' typically happens after such an event, what leads up to such an event, or both.
#'
#' @param .data The date.frame/tibble that holds the data.
#' @param .date_col The column with the date value.
#' @param .value_col The column with the value you are measuring.
#' @param .percent_change This defaults to 0.05 which is a 5% increase in the
#' `.value_col`.
#' @param .horizon How far do you want to look back or ahead.
#' @param .precision The default is 2 which means it rounds the lagged 1 value
#' percent change to 2 decimal points. You may want more for more finely tuned
#' results, this will result in fewer groupings.
#' @param .direction The default is `forward`. You can supply either `forward`,
#' `backwards` or `both`.
#' @param .filter_non_event_groups The default is TRUE, this drops groupings with
#' no events on the rare occasion it does occur.
#'
#' @return
#' A tibble.
#'
#' @examples
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(ggplot2))
#'
#' df_tbl <- ts_to_tbl(AirPassengers) %>% select(-index)
#'
#' tst <- ts_time_event_analysis_tbl(df_tbl, date_col, value_col, .direction = "both")
#'
#' glimpse(tst)
#'
#' tst %>%
#'   ggplot(aes(x = x, y = mean_event_change)) +
#'   geom_line() +
#'   geom_line(aes(y = event_change_ci_high), color = "blue", linetype = "dashed") +
#'   geom_line(aes(y = event_change_ci_low), color = "blue", linetype = "dashed") +
#'   geom_vline(xintercept = (horizon + 1), color = "red", linetype = "dashed") +
#'   theme_minimal() +
#'   labs(
#'     title = "'AirPassengers' Event Analysis at 5% Increase",
#'     subtitle = "Vertical Red line is normalized event epoch - Direction: Both",
#'     x = "",
#'     y = "Mean Event Change"
#'   )
#'
#'
#' @export
#'

ts_time_event_analysis_tbl <- function(.data, .date_col, .value_col,
                                       .percent_change = 0.05, .horizon = 12,
                                       .precision = 2, .direction = "forward",
                                       .filter_non_event_groups = TRUE) {

    # Tidyeval ----
    date_var_expr <- rlang::enquo(.date_col)
    value_var_expr <- rlang::enquo(.value_col)
    horizon <- as.integer(.horizon)
    precision <- as.numeric(.precision)
    percent_change <- as.numeric(.percent_change)
    direction <- tolower(as.character(.direction))
    filter_non_event_groups <- as.logical(.filter_non_event_groups)

    change_sign <- ifelse(percent_change < 0, -1, 1)

    # Checks ----
    if (rlang::quo_is_missing(date_var_expr)) {
        rlang::abort(
            message = "You must supply a date column.",
            use_cli_format = TRUE
        )
    }

    if (rlang::quo_is_missing(value_var_expr)) {
        rlang::abort(
            message = "You must supply a value column.",
            use_cli_format = TRUE
        )
    }

    if (!is.integer(horizon) | horizon < 1) {
        rlang::abort(
            message = "The '.horizon' parameter must be and integer of 1 or more.",
            use_cli_format = TRUE
        )
    }

    if (percent_change < -1 | percent_change > 1 | !is.numeric(percent_change)) {
        rlang::abort(
            message = "The '.percent_change' parameter must be a numeric/dbl and between
      -1 and 1 inclusive.",
      use_cli_format = TRUE
        )
    }

    if (!is.numeric(precision) | precision < 0) {
        rlang::abort(
            message = "The '.precision' parameter must be a numeric/dbl and must be
      greater than or equal to 0.",
      use_cli_format = TRUE
        )
    }

    if (!is.character(direction) | !direction %in% c("backward", "forward", "both")) {
        rlang::abort(
            message = "The '.direction' parameter must be a character string of either
      'backward', 'forward', or 'both'.",
      use_cli_format = TRUE
        )
    }

    # Data ----
    df <- dplyr::as_tibble(.data) %>%
        dplyr::select({{ date_var_expr }}, {{ value_var_expr }}, dplyr::everything()) %>%
        # Manipulation
        dplyr::mutate(
            lag_val = dplyr::lag({{ value_var_expr }}, 1),
            adj_diff = ({{ value_var_expr }} - lag_val),
            relative_change_raw = adj_diff / lag_val
        ) %>%
        tidyr::drop_na(lag_val) %>%
        dplyr::mutate(
            relative_change = round(relative_change_raw, precision),
            pct_chg_mark = ifelse(relative_change == percent_change, TRUE, FALSE),
            event_base_change = ifelse(pct_chg_mark == TRUE, 0, relative_change_raw),
            group_number = cumsum(pct_chg_mark)
        ) %>%
        dplyr::mutate(numeric_group_number = group_number) %>%
        dplyr::mutate(group_number = as.factor(group_number))

    # Drop group 0 if indicated
    if (filter_non_event_groups){
        df <- df %>%
            dplyr::filter(numeric_group_number != 0)
    }

    if (direction == "forward"){
        df_final_tbl <- internal_ts_forward_event_tbl(df, horizon)
    }

    if (direction == "backward"){
        df_final_tbl <- internal_ts_backward_event_tbl(df, horizon)
    }

    if (direction == "both"){
        df_final_tbl <- internal_ts_both_event_tbl(df, horizon)
    }

    max_event_change <- max(df_final_tbl$event_base_change)
    max_groups <- max(df_final_tbl$numeric_group_number)

    # Output ----
    attr(df_final_tbl, ".change_sign") <- change_sign
    attr(df_final_tbl, ".percent_change") <- .percent_change
    attr(df_final_tbl, ".horizon") <- .horizon
    attr(df_final_tbl, ".precision") <- .precision
    attr(df_final_tbl, ".direction") <- .direction
    attr(df_final_tbl, ".filter_non_event_groups") <- .filter_non_event_groups
    attr(df_final_tbl, ".max_event_change") <- max_event_change
    attr(df_final_tbl, ".max_group_number") <- max_groups

    return(df_final_tbl)
}
