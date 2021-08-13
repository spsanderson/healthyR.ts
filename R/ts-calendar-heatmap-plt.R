#' Time Series Calendar Heatmap
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Takes in data that has been aggregated to the day level and makes a calendar
#' heatmap.
#'
#' @details
#' The data provided must have been aggregated to the day level, if not funky
#' output could result and it is possible nothing will be output but errors.
#' There must be a date column and a value column, those are the only items
#' required for this function to work.
#'
#' This function is intentionally inflexible, it complains more and does less in
#' order to force the user to supply a clean data-set.
#'
#' @param .data The time-series data with a date column and value column.
#' @param .date_col The column that has the datetime values
#' @param .value_col The column that has the values
#' @param .low The color for the low value, must be quoted like "red". The default is "red"
#' @param .high The color for the high value, must be quoted like "green". The default is "green"
#' @param .plt_title The title of the plot
#' @param .interactive Default is TRUE to get an interactive plot using [plotly::ggplotly()].
#' It can be set to FALSE to get a ggplot plot.
#'
#' @examples
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(ggplot2))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(lubridate))
#' suppressPackageStartupMessages(library(zoo))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(stringi))
#' suppressPackageStartupMessages(library(plotly))
#' suppressPackageStartupMessages(library(purrr))
#' suppressPackageStartupMessages(library(forcats))
#'
#' data <- healthyR_data %>%
#'    filter(ip_op_flag == "O") %>%
#'    filter(substr(visit_id, 1, 1) == "8") %>%
#'    select(visit_start_date_time) %>%
#'    filter_by_time(
#'        .date_var     = visit_start_date_time
#'        , .start_date = "2014"
#'        , .end_date   = "2016"
#'    ) %>%
#'    summarise_by_time(
#'        .date_var = visit_start_date_time
#'        , value   = n()
#'    ) %>%
#'    set_names("date_col","value") %>%
#'    tk_augment_timeseries_signature(.date_var = date_col) %>%
#'    select(
#'        date_col
#'        , value
#'        , year
#'        , month
#'        , week
#'        , wday.lbl
#'    ) %>%
#'    mutate(yearmonth_fct = as.yearmon(date_col) %>% factor()) %>%
#'    mutate(wday.lbl = fct_rev(wday.lbl)) %>%
#'    select(date_col, year, yearmonth_fct, everything()) %>%
#'    arrange(date_col) %>%
#'    mutate(week_of_month = stri_datetime_fields(date_col)$WeekOfMonth) %>%
#'    rename("week_day" = "wday.lbl")
#'
#' ts_calendar_heatmap_plt(
#'   .data        = data
#'   , .date_col  = date_col
#'   , .value_col = value
#' )
#'
#' ts_calendar_heatmap_plt(
#'   .data          = data
#'   , .date_col    = date_col
#'   , .value_col   = value
#'   , .interactive = FALSE
#' )
#'
#' @return
#' A ggplot2 plot or if interactive a plotly plot
#'
#' @export
#'

ts_calendar_heatmap_plt <- function(.data, .date_col, .value_col,
                                    .low = "red", .high = "green",
                                    .plt_title = "",
                                    .interactive = TRUE){

    # * Tidyeval ----
    date_col_var_expr  <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)
    plotly_plt         <- .interactive
    low                <- .low
    high               <- .high

    # * Checks ----
    if (rlang::quo_is_missing(date_col_var_expr)) {
        stop(call. = FALSE, "(.date_col) is missing, please supply.")
    }

    if (rlang::quo_is_missing(value_col_var_expr)){
        stop(call. = FALSE, "(.value_col) is missing, please supply.")
    }

    if(!is.logical(plotly_plt)){
        stop(call. = FALSE, "You must supply either TRUE or FALSE for .interactive")
    }

    # * Data and Manipulation ----
    data <- tibble::as_tibble(.data) %>%
        dplyr::select( {{date_col_var_expr }}, {{ value_col_var_expr }} ) %>%
        purrr::set_names("date_col", "value")

    data_tbl <- data %>%
        timetk::tk_augment_timeseries_signature(date_col) %>%
        dplyr::select(
            date_col
            , value
            , year
            , month.lbl
            , wday.lbl
        ) %>%
        dplyr::mutate(wday.lbl = forcats::fct_rev(wday.lbl)) %>%
        dplyr::select(date_col, year, dplyr::everything()) %>%
        dplyr::arrange(date_col) %>%
        dplyr::mutate(week_of_month = stringi::stri_datetime_fields(date_col)$WeekOfMonth) %>%
        dplyr::rename("week_day" = "wday.lbl")

    # * Plot ----
    g <- ggplot2::ggplot(
        data = data_tbl
        , ggplot2::aes(
            x      = week_of_month
            , y    = week_day
            , fill = value
        )
    ) +
        ggplot2::geom_tile(color = "white") +
        ggplot2::facet_grid(year ~ month.lbl) +
        ggplot2::scale_fill_gradient(low = low, high = high) +
        ggplot2::labs(
            title = .plt_title
        )
    ggplot2::theme_minimal()

    # Which plot to return
    if(plotly_plt){
        plt <- plotly::ggplotly(g)
    } else {
        plt <- g
    }

    # * Return ----
    print(plt)

}
