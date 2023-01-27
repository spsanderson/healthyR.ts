#' Auto-Plot a Geometric/Brownian Motion Augment
#'
#' @family Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Plot an augmented Geometric/Brownian Motion.
#'
#' @details This function will take output from either the `ts_brownian_motion_augment()`
#' or the `ts_geometric_brownian_motion_augment()` function and plot them. The
#' legend is set to "none" if the simulation count is higher than 9.
#'
#' @param .data The data you are going to pass to the function to augment.
#' @param .date_col The column that holds the date
#' @param .value_col The column that holds the value
#' @param .interactive The default is FALSE, TRUE will produce an interactive
#' plotly plot.
#'
#' @examples
#' library(dplyr)
#'
#' df <- ts_to_tbl(AirPassengers) %>% select(-index)
#'
#' augmented_data <- df %>%
#'   ts_brownian_motion_augment(
#'     .date_col = date_col,
#'     .value_col = value,
#'     .time = 144
#'   )
#'
#'  augmented_data %>%
#'    ts_brownian_motion_plot(.date_col = date_col, .value_col = value)
#'
#' @return
#' A ggplot2 object or an interactive `plotly` plot
#'
#' @name ts_brownian_motion_plot
NULL

#' @export
#' @rdname ts_brownian_motion_plot

ts_brownian_motion_plot <- function(.data, .date_col, .value_col,
                                    .interactive = FALSE){

    # Tidyeval ---
    plotly_plot <- as.logical(.interactive)
    date_var_expr <- rlang::enquo(.date_col)
    value_var_expr <- rlang::enquo(.value_col)

    # Attributes
    atb <- attributes(.data)

    # Checks ---
    if (!is.data.frame(.data)){
        rlang::abort(
            message = "'.data' must be either a data.frame/tibble.",
            use_cli_format = TRUE
        )
    }

    if (!is.logical(.interactive)){
        rlang::abort(
            message = "'.interactive' must be a logical of TRUE/FALSE.",
            use_cli_format = TRUE
        )
    }

    if (!".motion_type" %in% names(atb)){
        rlang::abort(
            message = "The '.data' must come from a ts_brownian or ts_geometric
            function."
        )
    }

    # Data Manipulation ---
    df <- dplyr::as_tibble(.data)

    # Graph ---
    g <- df %>%
        ggplot2::ggplot(ggplot2::aes(x = {{ date_var_expr }}, y = {{ value_var_expr }},
                                     group = sim_number, color = sim_number)) +
        ggplot2::geom_line() +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            title = atb$.motion_type,
            subtitle = paste0("Simulations: ", atb$.num_sims,
                              " - Initial Value: ", round(atb$.initial_value, 2),
                              " - Delta Time: ", round(atb$.delta_time, 2))
        ) +
        ggplot2::theme(legend.position = if(atb$.num_sims > 9) {"none"})

    # Return ---
    if (plotly_plot){
        g <- plotly::ggplotly(g)
    }

    return(g)

}
