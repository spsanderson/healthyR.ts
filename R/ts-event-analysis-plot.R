#' Time Series Event Analysis Plot
#'
#' @family Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This function will take in data strictly from the `ts_time_event_analysis_tbl()`
#' and plot out the data. You can choose what type of plot you want in the parameter
#' of `.plot_type`. This will give you a choice of "mean", "median", and "individual".
#'
#' You can also plot the upper and lower confidence intervals if you choose one
#' of the aggregate plots ("mean"/"median").
#'
#' @description Plot out the data from the `ts_time_event_analysis_tbl()` function.
#'
#' @param .data The data that comes from the `ts_time_event_analysis_tbl()`
#' @param .plot_type The default is "mean" which will show the mean event change
#' of the output from the analysis tibble. The possible values for this are: mean,
#' median, and individual.
#' @param .plot_ci The default is TRUE. This will only work if you choose one
#' of the aggregate plots of either "mean" or "median"
#' @param .interactive The default is FALSE. TRUE will return a plotly plot.
#'
#' @examples
#'
#' df <- ts_to_tbl(AirPassengers) %>% select(-index)
#'
#' ts_time_event_analysis_tbl(
#'   .data = df,
#'   .horizon = 6,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .direction = "both"
#' ) %>%
#'   ts_event_analysis_plot()
#'
#' ts_time_event_analysis_tbl(
#'   .data = df,
#'   .horizon = 6,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .direction = "both"
#' ) %>%
#'   ts_event_analysis_plot(.plot_type = "individual")
#'
#' @return
#' A ggplot2 object
#'
#' @export
#'

ts_event_analysis_plot <- function(.data, .plot_type = "mean", .plot_ci = TRUE,
                                   .interactive = FALSE){

    # Tidyeval
    plot_type = tolower(as.character(.plot_type))
    plot_ci = as.logical(.plot_ci)
    plotly_plot = as.logical(.interactive)

    # Checks
    if (!attributes(.data)$.tibble_type == "event_analysis"){
        rlang::abort(
            message = "You must use the 'ts_time_event_analysis_tbl()` function
            in order to use this plotting function.",
            use_cli_format = TRUE
        )
    }

    if (!plot_type %in% c("mean","median","individual")){
        rlang::abort(
            message = "The parameter '.plot_type' must either be 'mean', 'median',
            or 'individual'.",
            use_cli_format = TRUE
        )
    }

    if (plot_ci == TRUE & !plot_type %in% c("mean","median","individual")){
        rlang::abort(
            message = "If you set '.plot_ci' to TRUE then you must set '.plot_type'
            to either 'mean' or 'median'",
            use_cli_format = TRUE
        )
    }

    # Series of If statements based upon plot_type
    df <- dplyr::as_tibble(.data)
    atb <- attributes(df)

    plt_subtitle <- paste0(
        "Max Event Change: ",
        scales::percent(atb$.max_event_change, accuracy = 0.01),
        " - ",
        "Direction: ",
        atb$.direction,
        " - ",
        "Horizon: ",
        atb$.horizon,
        " - ",
        "Pct Change: ",
        scales::percent(atb$.percent_change, accuracy = 0.01)
    )

    if (plot_type == "mean"){
        df <- df %>%
            dplyr::select(
                x,
                mean_event_change,
                event_change_ci_low,
                event_change_ci_high
            ) %>%
            dplyr::distinct()

        # Xintercept
        if (atb$.direction == "both"){
            x <- c(1, which(df$mean_event_change == 0), nrow(df))
        } else if (atb$.direction == "forward") {
            x <- 1
        } else if (atb$.direction == "backward") {
            x <- nrow(df)
        }

        p <- df %>%
            ggplot2::ggplot(ggplot2::aes(x = x, y = mean_event_change)) +
            ggplot2::geom_line() +
            ggplot2::geom_vline(
                xintercept = x,
                color = "steelblue",
                linetype = "dashed"
            ) +
            ggplot2::theme_minimal() +
            ggplot2::scale_y_continuous(
                labels = scales::percent
            ) +
            ggplot2::labs(
                x = "Horizon Event",
                y = "Mean Change",
                title = "Mean Event Change Analysis Plot",
                subtitle = plt_subtitle
            )
    }

    if (plot_type == "median"){
        df <- df %>%
            dplyr::select(
                x,
                median_event_change,
                event_change_ci_low,
                event_change_ci_high
            ) %>%
            dplyr::distinct()

        # Xintercept
        if (atb$.direction == "both"){
            x <- c(1, which(df$median_event_change == 0), nrow(df))
        } else if (atb$.direction == "forward") {
            x <- 1
        } else if (atb$.direction == "backward") {
            x <- nrow(df)
        }

        p <- df %>%
            ggplot2::ggplot(ggplot2::aes(x = x, y = median_event_change)) +
            ggplot2::geom_line() +
            ggplot2::geom_vline(
                #xintercept = c(1, which(df$median_event_change == 0), nrow(df)),
                xintercept = x,
                color = "steelblue",
                linetype = "dashed"
            ) +
            ggplot2::theme_minimal() +
            ggplot2::scale_y_continuous(
                labels = scales::percent
            ) +
            ggplot2::labs(
                x = "Horizon Event",
                y = "Median Change",
                title = "Median Event Change Analysis Plot",
                subtitle = plt_subtitle
            )
    }

    if (plot_type == "individual"){
        df <- df %>%
            dplyr::select(
                x, event_base_change,
                event_change_ci_low,
                event_change_ci_high,
                group_event_number
            ) %>%
            dplyr::distinct()

        r <- which(df$event_base_change == 0)
        x <- unique(df[r,]$x)
        # Xintercept
        if (atb$.direction == "both"){
            x <- x
        } else if (atb$.direction == "forward") {
            x <- 1
        } else if (atb$.direction == "backward") {
            x <- max(x)
        }

        p <- df %>%
            ggplot2::ggplot(
                ggplot2::aes(
                x = x,
                y = event_base_change,
                group = group_event_number,
                color = factor(group_event_number)
                )
            ) +
            ggplot2::geom_line() +
            ggplot2::geom_vline(
                xintercept = x,
                color = "steelblue",
                linetype = "dashed"
            ) +
            ggplot2::theme_minimal() +
            ggplot2::scale_y_continuous(
                labels = scales::percent
            ) +
            ggplot2::labs(
                x = "Horizon Event",
                y = "Event Base Change",
                subtitle = plt_subtitle,
                title = "Event Base Change Analysis Plot",
                color = "Event Number"
            ) +
            ggplot2::theme(legend.position = "bottom")
    }

    # Confidence Intervals?
    if (plot_ci & plot_type != "individual"){
        p <- p +
            ggplot2::geom_line(
                ggplot2::aes(y = event_change_ci_high),
                color = "red",
                linetype = "dashed"
            ) +
            ggplot2::geom_line(
                ggplot2::aes(y = event_change_ci_low),
                color = "red",
                linetype = "dashed"
            )
    }

    # Return
    if (plotly_plot){
        p <- plotly::ggplotly(p)
    }

    return(p)

}
