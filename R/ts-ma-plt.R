#' Time Series Moving Average Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will produce a `ggplot2` plot with facet wrapping. The plot
#' contains three moving average panels stacked on top of each other using
#' facet_wrap. The panels show the main time series with moving average, and
#' two difference calculations: Diff A shows sequential period-over-period percentage changes (e.g., month-over-month or week-over-week), and Diff B shows year-over-year percentage changes.
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
#' output$data_summary_tbl %>% head()
#'
#' @return
#' A list containing the ggplot2 plot object and the summary data table.
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
        stop(call. = FALSE, "(.value_col) is missing, please supply.")
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
    # Create summary tibble for visualization
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
            panel = "Main"
        ) %>%
        dplyr::select(date_col, value, ma12, panel) %>%
        dplyr::bind_rows(
            data_summary_tbl %>%
                dplyr::mutate(
                    panel = "Diff A",
                    plot_value = diff_a,
                    fill_color = ifelse(diff_a < 0, "red", "green")
                ) %>%
                dplyr::select(date_col, plot_value, fill_color, panel)
        ) %>%
        dplyr::bind_rows(
            data_summary_tbl %>%
                dplyr::mutate(
                    panel = "Diff B",
                    plot_value = diff_b,
                    fill_color = ifelse(diff_b < 0, "red", "green")
                ) %>%
                dplyr::select(date_col, plot_value, fill_color, panel)
        ) %>%
        dplyr::mutate(
            panel = factor(panel, levels = c("Main", "Diff A", "Diff B"))
        )

    # Create facet titles
    panel_labels <- c(
        "Main" = if (is.null(.main_title)) "Main Plot" else .main_title,
        "Diff A" = if (is.null(.secondary_title)) "Difference A" else .secondary_title,
        "Diff B" = if (is.null(.tertiary_title)) "Difference B" else .tertiary_title
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
        ggplot2::scale_y_continuous(labels = scales::label_number_auto()) +
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

    # * Return ----
    output <- list(
        data_summary_tbl = data_summary_tbl,
        pgrid = pgrid
    )

    return(output)

}
