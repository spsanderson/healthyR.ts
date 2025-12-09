#' Auto-Plot a Random Walk
#'
#' @family Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Plot a random walk with side-by-side facets showing both the
#' random variable and cumulative product (random walk path).
#'
#' @details This function will take output from the `ts_random_walk()` function
#' and create a side-by-side faceted plot. The left panel shows the random
#' variable (y) over time, and the right panel shows the cumulative product (cum_y, i.e., the random walk path)
#' over time. Each simulation run is shown as a separate line. The legend is set
#' to "none" if the simulation count is higher than 9.
#'
#' @param .data The data from `ts_random_walk()` function.
#' @param .interactive The default is FALSE, TRUE will produce an interactive
#' plotly plot.
#'
#' @examples
#' library(dplyr)
#'
#' df <- ts_random_walk(
#'   .mean = 0,
#'   .sd = 1,
#'   .num_walks = 25,
#'   .periods = 180,
#'   .initial_value = 100
#' )
#'
#' ts_random_walk_plot(df)
#'
#' @return
#' A ggplot2 object or an interactive `plotly` plot
#'
#' @name ts_random_walk_plot
NULL

#' @export
#' @rdname ts_random_walk_plot

ts_random_walk_plot <- function(.data, .interactive = FALSE) {

    # Tidyeval ---
    plotly_plot <- as.logical(.interactive)

    # Attributes
    atb <- attributes(.data)

    # Checks ---
    if (!is.data.frame(.data)) {
        rlang::abort(
            message = "'.data' must be either a data.frame/tibble.",
            use_cli_format = TRUE
        )
    }

    if (!is.logical(.interactive)) {
        rlang::abort(
            message = "'.interactive' must be a logical of TRUE/FALSE.",
            use_cli_format = TRUE
        )
    }

    # Check if required attributes exist
    required_attrs <- c(".mean", ".sd", ".num_walks", ".periods", ".initial_value")
    if (!all(required_attrs %in% names(atb))) {
        rlang::abort(
            message = "The '.data' must come from the ts_random_walk() function.",
            use_cli_format = TRUE
        )
    }

    # Data Manipulation ---
    df <- dplyr::as_tibble(.data)

    # Reshape data for faceting
    df_long <- df |>
        tidyr::pivot_longer(
            cols = c(y, cum_y),
            names_to = "variable",
            values_to = "value"
        ) |>
        dplyr::mutate(
            variable = dplyr::case_when(
                variable == "y" ~ "Random Variable (y)",
                variable == "cum_y" ~ "Cumulative Product (cum_y)",
                TRUE ~ variable
            ),
            variable = factor(variable, levels = c("Random Variable (y)", "Cumulative Product (cum_y)"))
        )

    # Graph ---
    g <- df_long |>
        ggplot2::ggplot(
            ggplot2::aes(
                x = x,
                y = value,
                group = run,
                color = factor(run)
            )
        ) +
        ggplot2::geom_line(alpha = 0.8) +
        ggplot2::facet_wrap(~ variable, scales = "free_y", ncol = 2) +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            title = "Random Walk Simulation",
            subtitle = paste0(
                "Simulations: ", atb$.num_walks,
                " - Initial Value: ", atb$.initial_value,
                " - Mean: ", atb$.mean,
                " - SD: ", atb$.sd
            ),
            x = "Period",
            y = "Value",
            color = "Run"
        ) +
        ggplot2::theme(legend.position = if (atb$.num_walks > 9) {"none"} else {"right"})

    # Return ---
    if (plotly_plot) {
        g <- plotly::ggplotly(g)
    }

    return(g)

}
