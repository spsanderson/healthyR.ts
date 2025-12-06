#' Time Series Moving Average Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will produce two plots. Both of these are moving average plots.
#' One of the plots is from [xts::plot.xts()] and the other a `ggplot2` plot with
#' facet wrapping. This is done so that the user can choose which type is best for
#' them. The ggplot2 plots are stacked using facet_wrap so each graph is on top of
#' the other.
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
#' suppressPackageStartupMessages(library(dplyr))
#'
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
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
#' @name ts_ma_plot
NULL

#' @export ts_ma_plot
#' @rdname ts_ma_plot
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

    # tibbles for ggplot
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
    # Prepare data for faceting
    # Create long format data with panel indicator for faceting
    data_for_facet <- data_summary_tbl %>%
        dplyr::mutate(
            panel = "Main",
            panel_order = 1
        ) %>%
        dplyr::select(date_col, value, ma12, panel, panel_order) %>%
        dplyr::bind_rows(
            data_summary_tbl %>%
                dplyr::mutate(
                    panel = "Diff A",
                    panel_order = 2,
                    plot_value = diff_a,
                    fill_color = ifelse(diff_a < 1, "red", "green")
                ) %>%
                dplyr::select(date_col, plot_value, fill_color, panel, panel_order)
        ) %>%
        dplyr::bind_rows(
            data_summary_tbl %>%
                dplyr::mutate(
                    panel = "Diff B",
                    panel_order = 3,
                    plot_value = diff_b,
                    fill_color = ifelse(diff_b < 1, "red", "green")
                ) %>%
                dplyr::select(date_col, plot_value, fill_color, panel, panel_order)
        ) %>%
        dplyr::mutate(
            panel = factor(panel, levels = c("Main", "Diff A", "Diff B"))
        )

    # Create facet titles
    panel_labels <- c(
        "Main" = ifelse(is.null(.main_title), "Main Plot", .main_title),
        "Diff A" = ifelse(is.null(.secondary_title), "Difference A", .secondary_title),
        "Diff B" = ifelse(is.null(.tertiary_title), "Difference B", .tertiary_title)
    )

    # Pre-filter data for each panel to avoid redundant operations
    main_panel_data <- data_for_facet %>% dplyr::filter(panel == "Main")
    diff_panel_data <- data_for_facet %>% dplyr::filter(panel %in% c("Diff A", "Diff B"))

    # Create single plot with facet_wrap
    pgrid <- ggplot2::ggplot() +
        # Main panel: line plots
        ggplot2::geom_line(
            data = main_panel_data,
            ggplot2::aes(x = date_col, y = value),
            linewidth = 1
        ) +
        ggplot2::geom_line(
            data = main_panel_data,
            ggplot2::aes(x = date_col, y = ma12),
            color = "blue",
            linewidth = 1
        ) +
        # Diff A and Diff B panels: bar plots
        ggplot2::geom_col(
            data = diff_panel_data,
            ggplot2::aes(x = date_col, y = plot_value, fill = fill_color)
        ) +
        ggplot2::scale_fill_manual(values = c("red" = "red", "green" = "green")) +
        ggplot2::scale_x_date(
            labels = scales::label_date("'%y"),
            breaks = scales::breaks_width("2 years")
        ) +
        ggplot2::facet_wrap(
            ~ panel,
            ncol = 1,
            scales = "free_y",
            labeller = ggplot2::labeller(panel = panel_labels)
        ) +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            x = "",
            y = ""
        ) +
        ggplot2::theme(
            legend.position = "none",
            strip.text = ggplot2::element_text(hjust = 0, size = 11),
            axis.text.x = ggplot2::element_text(angle = 0)
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
