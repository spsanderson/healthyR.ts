#' Time Series Value, Velocity and Acceleration Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will produce three plots faceted on a single graph. The three
#' graphs are the following:
#' -  Value Plot (Actual values)
#' -  Value Velocity Plot
#' -  Value Acceleration Plot
#'
#' @details This function expects to take in a data.frame/tibble. It will return
#' a list object that contains the augmented data along with a static plot and
#' an interactive plotly plot. It is important that the data be prepared and have
#' at minimum a date column and the value column as they need to be supplied to
#' the function. If your data is a ts, xts, zoo or mts then use `ts_to_tbl()` to
#' convert it to a tibble.
#'
#' @param .data The data you want to visualize. This should be pre-processed and
#' the aggregation should match the `.frequency` argument.
#' @param .date_col The data column from the `.data` argument.
#' @param .value_col The value column from the `.data` argument
#'
#' @examples
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
#'
#' ts_vva_plot(data_tbl, date_col, value)$plots$static_plot
#'
#' @return
#' The original time series augmented with the differenced data, a static plot
#' and a plotly plot of the ggplot object. The output is a list that gets returned
#' invisibly.
#'
#' @export ts_vva_plot
#'

ts_vva_plot <- function(.data, .date_col, .value_col){

    # Tidyeval ---
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)

    # Checks ----
    if(!is.data.frame(.data)){
        stop(call. = FALSE, ".data is not a data.frame/tibble, please supply.")
    }

    if(rlang::quo_is_missing(date_col_var_expr) | rlang::quo_is_missing(value_col_var_expr)){
        stop(call. = FALSE, "Both .date_col and .value_col must be supplied.")
    }

    # Data Manipulation ----
    data_tbl <- tibble::as_tibble(.data) %>%
        dplyr::select({{date_col_var_expr}},{{value_col_var_expr}})

    data_diff_tbl <- data_tbl %>%
        timetk::tk_augment_differences(.value = {{value_col_var_expr}}, .differences = 1) %>%
        timetk::tk_augment_differences(.value = {{value_col_var_expr}}, .differences = 2) %>%
        dplyr::rename(velocity = contains("_diff1")) %>%
        dplyr::rename(acceleration = contains("_diff2")) %>%
        tidyr::pivot_longer(-{{date_col_var_expr}}) %>%
        dplyr::mutate(name = stringr::str_to_title(name)) %>%
        dplyr::mutate(name = forcats::as_factor(name))

    # Plot ----
    g <- ggplot2::ggplot(
        data = data_diff_tbl,
        ggplot2::aes(
            x = {{date_col_var_expr}},
            y = value,
            group = name,
            color = name
        )
    ) +
        ggplot2::geom_line() +
        ggplot2::facet_wrap(name ~ ., ncol = 1, scale = "free") +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            x = "Date",
            y = "",
            color = ""
        ) +
        tidyquant::scale_color_tq()

    p <- plotly::ggplotly(g)

    # Return ----
    output_list <- list(
        data = list(
            augmented_data_tbl = data_diff_tbl
        ),
        plots = list(
            static_plot = g,
            interactive_plot = p
        )
    )

    return(invisible(output_list))

}


