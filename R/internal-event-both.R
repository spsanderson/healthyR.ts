#' Event Analysis
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This is a function that sits inside of the `ts_time_event_analysis_tbl()`. It
#' is only meant to be used there. This is an internal function.
#'
#' @details
#' This is a helper function for `ts_time_event_analysis_tbl()` only.
#'
#' @param .data The date.frame/tibble that holds the data.
#' @param .horizon How far do you want to look back or ahead.
#'
#' @return
#' A tibble.
#'
#' @export
#'

internal_ts_both_event_tbl <- function(.data, .horizon){

    # Variables
    horizon <- .horizon

    # Capture data
    df <- dplyr::as_tibble(.data)

    inds <- which(df$pct_chg_mark == TRUE)
    rows <- lapply(inds, function(x) (x - horizon):(x + horizon))
    l <- purrr::map(
        .x = rows,
        .f = ~ .x %>%
            subset(. > 0) %>%
            df[.,]
    ) %>%
        purrr::imap(.f = ~ dplyr::bind_cols(.x, group_event_number = .y)) %>%
        purrr::map_df(dplyr::as_tibble)

    l <- l %>%
        dplyr::group_by(group_event_number) %>%
        dplyr::mutate(x = dplyr::row_number()) %>%
        dplyr::ungroup() %>%
        dplyr::group_by(x) %>%
        dplyr::mutate(
            mean_event_change = mean(event_base_change, na.rm = TRUE),
            median_event_change = stats::median(event_base_change, na.rm = TRUE),
            event_change_ci_low = unname(stats::quantile(event_base_change, 0.025, na.rm = TRUE)),
            event_change_ci_high = unname(stats::quantile(event_base_change, 0.975, na.rm = TRUE))
        ) %>%
        dplyr::ungroup() %>%
        tibble::rowid_to_column() %>%
        dplyr::mutate(
            event_type = ifelse(x < (horizon + 1), "Before","After") %>%
                as.factor()
        )

    # Return Forward analysis tibble
    return(l)
}
