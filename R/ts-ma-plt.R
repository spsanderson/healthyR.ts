#' Time Series Moving Average Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will produce two plots. Both of these are moving average plots.
#' One of the plots is from [xts::plot.xts()] and the other a `ggplot2` plot. This
#' is done so that the user can choose which type is best for them. The plots are
#' stacked so each graph is on top of the other.
#'
#' @details This function expects to take in a data.frame/tibble. It will return
#' a list object so it is a good idea to save the output to a variable and extract
#' from there.
#'
#' @param .data The data you want to visualize. This should be pre-processed and
#' the aggregation should match the `.frequency` argument.
#' @param .date_col The data column from the `.data` argument.
#' @param .value_col The value column from the `.data` argument
#' @param .ts_frequency The frequency of the aggregation, quoted, ie. "monthly", anything else
#' will default to weekly, so it is very important that the data passed to this
#' function be in either a weekly or monthly aggregation.
#' @param .main_title The title of the main plot.
#' @param .secondary_title The title of the second plot.
#' @param .tertiary_title The title of the third plot.
#'
#' @examples
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(purrr))
#' suppressPackageStartupMessages(library(ggplot2))
#' suppressPackageStartupMessages(library(xts))
#' suppressPackageStartupMessages(library(cowplot))
#' suppressPackageStartupMessages(library(healthyR.data))
#'
#' data_tbl <- healthyR_data %>%
#'   select(visit_end_date_time) %>%
#'   summarise_by_time(
#'     .date_var = visit_end_date_time,
#'     .by       = "month",
#'     value     = n()
#'   ) %>%
#'   set_names("date_col","value") %>%
#'   filter_by_time(
#'     .date_var = date_col,
#'     .start_date = "2013",
#'     .end_date = "2020"
#'   )
#'
#' output <- ts_ma_plot(
#'   .data = data_tbl,
#'   .date_col = date_col,
#'   .value_col = value
#' )
#'
#' output$pgrid
#' output$xts_plt
#' output$data_summary_tbl %>% head()
#'
#' data_tbl <- healthyR_data %>%
#'   select(visit_end_date_time) %>%
#'   summarise_by_time(
#'     .date_var = visit_end_date_time,
#'     .by = "week",
#'     value = n()
#'   ) %>%
#'   set_names("date_col","value") %>%
#'   filter_by_time(
#'     .date_var = date_col,
#'     .start_date = "2013",
#'     .end_date = "2020"
#'   )
#'
#' output <- ts_ma_plot(
#'   .data = data_tbl,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .ts_frequency = "week"
#' )
#'
#' output$pgrid
#' output$xts_plt
#' output$data_summary_tbl %>% head()
#'
#' @return
#' A few time series data sets and two plots.
#'
#' @export ts_ma_plot

ts_ma_plot <- function(.data,
                            .date_col,
                            .value_col,
                            .ts_frequency = "monthly",
                            .main_title = NULL,
                            .secondary_title = NULL,
                            .tertiary_title = NULL) {

    # * Tidyeval ----
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)
    ts_freq_var_expr   <- .ts_frequency
    ts_freq_for_calc   <- if(ts_freq_var_expr == "monthly"){
        ts_freq_for_calc <- 12
    } else {
        ts_freq_for_calc <- round(365.25/7, 0)
    }
    .main_title        <- .main_title
    .secondary_title   <- .secondary_title
    .tertiary_title    <- .tertiary_title

    # * Checks ----
    if (rlang::quo_is_missing(date_col_var_expr)) {
        stop(call. = FALSE, "(.date_col) is missing, please supply.")
    }

    if (rlang::quo_is_missing(value_col_var_expr)) {
        stop(call. = FALSE, "(.value_col) is mising, please supply.")
    }

    if (!is.data.frame(.data)) {
        stop(call. = FALSE, "(.data) is missing, please supply.")
    }

    if (is.null(ts_freq_var_expr)) {
        message(".ts_frequency was not supplied. One will try to be obtained.")
    }

    # * Data ----
    data_tbl <- tibble::as_tibble(.data) %>%
        dplyr::select({{ date_col_var_expr }}, {{ value_col_var_expr }}) %>%
        purrr::set_names("date_col", "value")

    # * Manipulate ----
    # Initial tables that get coerced to xts
    data_trans_tbl <- data_tbl %>%
        dplyr::mutate(
            ma12 = timetk::slidify_vec(
                .x = value,
                .period = ts_freq_for_calc,
                .f = mean,
                .align = "right",
                na.rm = TRUE
            )
        )

    data_diff_a <- data_trans_tbl %>%
        dplyr::mutate(diff_a = (value / dplyr::lag(value) - 1) * 100) %>%
        dplyr::select(date_col, diff_a)

    data_diff_b <- data_trans_tbl %>%
        dplyr::mutate(diff_b = (value / dplyr::lag(value, ts_freq_for_calc) - 1) * 100) %>%
        dplyr::select(date_col, diff_b)

    # Get start date for timetk::tk_ts() function
    start_date <- min(data_trans_tbl$date_col)
    start_yr <- lubridate::year(start_date)
    start_mn <- lubridate::month(start_date)

    # xts data
    data_trans_xts <- timetk::tk_ts(
        data_trans_tbl,
        frequency = ts_freq_for_calc,
        start = c(start_yr, start_mn)
    ) %>%
        timetk::tk_xts()

    data_diff_xts_a <- timetk::tk_ts(
        data_diff_a,
        frequency = ts_freq_for_calc,
        start = c(start_yr, start_mn)
    ) %>%
        timetk::tk_xts()

    data_diff_xts_b <- timetk::tk_ts(
        data_diff_b,
        frequency = ts_freq_for_calc,
        start = c(start_yr, start_mn)
    ) %>%
        timetk::tk_xts()

    # tibbles for ggplot/cowplot
    data_summary_tbl <- data_tbl %>%
        dplyr::mutate(date_col = as.Date(date_col)) %>%
        dplyr::mutate(
            ma12 = timetk::slidify_vec(
                .x = value,
                .period = ts_freq_for_calc,
                .f = mean,
                .align = "right",
                na.rm = TRUE
            )
        ) %>%
        dplyr::mutate(diff_a = (value / dplyr::lag(value) - 1) * 100) %>%
        dplyr::mutate(diff_b = (value / dplyr::lag(value, ts_freq_for_calc) - 1) * 100) %>%
        dplyr::mutate(
            diff_a = ifelse(is.na(diff_a), 0, diff_a),
            diff_b = ifelse(is.na(diff_b), 0, diff_b)
        )

    # * Visualize ----
    # ggplot only here, plot.xts in the list object
    p1 <- ggplot2::ggplot(
        data = data_summary_tbl,
        ggplot2::aes(
            x = date_col,
            y = value
        )
    ) +
        ggplot2::geom_line(size = 1) +
        ggplot2::geom_line(
            ggplot2::aes(
                x = date_col,
                y = ma12
            ),
            color = "blue",
            size = 1
        ) +
        ggplot2::scale_y_continuous(labels = scales::label_number_si()) +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            title = .main_title,
            x = "",
            y = ""
        ) +
        ggplot2::theme(
            axis.title.x = ggplot2::element_blank(),
            axis.text.x  = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank()
        )

    p2 <- ggplot2::ggplot(
        data = data_summary_tbl,
        ggplot2::aes(
            x = date_col,
            y = diff_a,
            fill = ifelse(diff_a < 1, "red", "green")
        )
    ) +
        ggplot2::geom_col() +
        ggplot2::scale_y_continuous(
            labels = scales::label_percent(scale = 1, accuracy = 0.1)
        ) +
        ggplot2::theme_minimal() +
        ggplot2::scale_fill_manual(values = c("red"="red","green"="green")) +
        ggplot2::labs(
            title = .secondary_title,
            x = "",
            y = ""
        ) +
        ggplot2::theme(
            legend.position = "none",
            axis.title.x = ggplot2::element_blank(),
            axis.text.x = ggplot2::element_blank(),
            axis.ticks.x = ggplot2::element_blank()
        )

    p3 <- ggplot2::ggplot(
        data = data_summary_tbl,
        ggplot2::aes(
            x = date_col,
            y = diff_b,
            fill = ifelse(diff_b < 1, "red", "green")
        )
    ) +
        ggplot2::geom_col() +
        ggplot2::scale_y_continuous(
            labels = scales::label_percent(
                scale = 1,
                accuracy = 0.1
            )
        ) +
        ggplot2::scale_x_date(
            labels = scales::label_date("'%y"),
            breaks = scales::breaks_width("2 years")
        ) +
        ggplot2::theme_minimal() +
        ggplot2::scale_fill_manual(values = c("red"="red","green"="green")) +
        ggplot2::labs(
            title = .tertiary_title,
            x = "",
            y = ""
        ) +
        ggplot2::theme(
            legend.position = "none"
        )

    pgrid <- cowplot::plot_grid(
        # ggplots
        p1, p2, p3,
        ncol = 1,
        rel_heights = c(8, 5, 5)
    )

    # xts plot?
    #' @export
    ts_xts_plt_internal <- function(){
        xts::plot.xts(
            data_trans_xts,
            main = .main_title,
            multi.panel = FALSE,
            col = c("black","blue")
        )
        graphics::lines(
            data_diff_xts_a,
            col = "red",
            type = "h",
            on = NA,
            main = .secondary_title
        )
        graphics::lines(
            data_diff_xts_b,
            col = "purple",
            type = "h",
            on = NA,
            main = .tertiary_title
        )
    }

    # * Return ----
    output <- list(
        data_trans_xts = data_trans_xts,
        data_diff_xts_a = data_diff_xts_a,
        data_diff_xts_b = data_diff_xts_b,
        data_summary_tbl = data_summary_tbl,
        pgrid = pgrid,
        xts_plt = ts_xts_plt_internal()
    )

    return(output)

}
