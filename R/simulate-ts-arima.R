#' Simulate ARIMA Model
#'
#' @family Simulator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This function takes in a user specified arima model. The specification
#' is passed to [stats::arima.sim()]
#'
#' @seealso \url{https://www.machinelearningplus.com/time-series/arima-model-time-series-forecasting-python/}
#'
#' @description Returns a list output of any `n` simulations of a user specified
#' ARIMA model. The function returns a list object with two sections:
#' -  data
#' -  plots
#'
#' The data section of the output contains the following:
#' -  simulation_time_series object (ts format)
#' -  simulation_time_series_output (mts format)
#' -  simulations_tbl (simulation_time_series_object in a tibble)
#' -  simulations_median_value_tbl (contains the [stats::median()] value of the
#' simulated data)
#'
#' The plots section of the output contains the following:
#' -  static_plot The `ggplot2` plot
#' -  plotly_plot The `plotly` plot
#'
#' @param .n The number of points to be simulated.
#' @param .num_sims The number of different simulations to be run.
#' @param .order_p The p value, the order of the AR term.
#' @param .order_d The d value, the number of differencing to make the series stationary
#' @param .order_q The q value, the order of the MA term.
#' @param .ma You can list the MA terms respectively if desired.
#' @param .ar You can list the AR terms respectively if desired.
#' @param .sim_color The color of the lines for the simulated series.
#' @param .alpha The alpha component of the `ggplot2` and `plotly` lines.
#' @param .size The size of the median line for the `ggplot2`
#' @param ... Any other additional arguments for [stats::arima.sim]
#'
#' @examples
#' output <- ts_arima_simulator()
#' output$plots$static_plot
#'
#' @return
#' A list object.
#' @name ts_arima_simulator
NULL

#' @export
#' @rdname ts_arima_simulator

ts_arima_simulator <- function(.n = 100, .num_sims = 25, .order_p = 0,
                               .order_d = 0, .order_q = 0, .ma = c(), .ar = c(),
                               .sim_color = "steelblue", .alpha = 0.05,
                               .size = 1, ...){

    # Tidyeval ----
    n <- as.integer(.n)
    num_sims <- as.integer(.num_sims)
    order_p <- .order_p
    order_d <- .order_d
    order_q <- .order_q
    alpha <- as.numeric(.alpha)
    size <- as.numeric(.size)
    sim_color <- .sim_color

    # Checks ----
    if (exists(".ma")){
        ma = .ma
    }

    if (exists(".ar")){
        ar = .ar
    }

    if (exists(".sd")){
        sd = .sd
    }

    if (alpha < 0 | alpha > 1){
        rlang::abort(
            "The '.alpha' parameter must be between 0 and 1 inclusive."
        )
    }

    if (size <= 0){
        rlang::abort(
            "The '.size' parameter must be greater than 0."
        )
    }

    if (length(order_p) > 1 | length(order_q) > 1 | length(order_d) > 1){
        rlang::abort(
            "The parameters of '.order_' should be a single integer value."
        )
    }

    # Make the simulated arima time series
    simulations_ts <- lapply(1:num_sims, function(i){
        # Set Vars
        sim <- sim_df <- x <- y <- NULL

        sim <- stats::arima.sim(
            model = list(
                order = c(order_p, order_d, order_q),
                ma = ma,
                ar = ar
            ),
            n = n,
            ... = ...
        )

        sim_df <- data.frame(
            x = as.numeric(stats::time(sim)),
            y = as.numeric(sim)
        )

        sim_df$n <- paste0("sim_", i)
        return(sim_df)
    })

    # Make simulated time series list into a tibble
    simulations_tbl <- purrr::map_dfr(simulations_ts, dplyr::as_tibble) %>%
        dplyr::group_by(n) %>%
        dplyr::mutate(id = dplyr::row_number(n)) %>%
        dplyr::ungroup()

    # Median value
    simulations_median_value_tbl <- simulations_tbl %>%
        dplyr::group_by(x) %>%
        dplyr::summarise(p50 = stats::median(y))

    # Simulation time series output
    simulations_output_ts <- simulations_tbl %>%
        tidyr::pivot_wider(names_from = n, values_from = y) %>%
        dplyr::select(-x) %>%
        stats::ts(
            start = 1,
            frequency = 1
        )

    # Plots ----
    g <- ggplot2::ggplot(
        data = simulations_median_value_tbl,
        ggplot2::aes(x = x, y = p50)
    ) +
        ggplot2::geom_line(color = "red", linetype = "dashed", size = size) +
        ggplot2::geom_line(
            data = simulations_tbl,
            ggplot2::aes(x = x, y = y, group = n),
            color = "steelblue",
            alpha = 0.15
        ) +
        ggplot2::theme_minimal() +
        ggplot2::labs(
            x = "Time",
            y = "Simulated Values",
            title = "Simulated ARIMA Model",
            subtitle = paste0("Simulations: ", num_sims, "\n",
                              "Simulated Points: ", n, "\n",
                              "Median Value in Red")
        )

    p <- plotly::plot_ly()

    for (i in 1:num_sims){
        p <- p %>%
            plotly::add_lines(
                x = simulations_ts[[i]]$x,
                y = simulations_ts[[i]]$y,
                line = list(color = sim_color),
                opacity = alpha,
                showlegend = FALSE,
                name = paste("Sim", i, sep = " ")
            )
    }

    p <- p %>%
        plotly::add_lines(
            x = simulations_median_value_tbl$x,
            y = simulations_median_value_tbl$p50,
            line = list(
                color = "red",
                dash = "dash",
                width = 3
            ),
            name = "Median"
        ) %>%
        plotly::layout(title = paste0("Simulations: ", num_sims,
                                      " Simulated Points: ", n, "\n",
                                      " Median Value in Red"))

    # Output List ----
    output <- list(
        data = list(
            simulation_time_series        = simulations_ts,
            simulation_time_series_output = simulations_output_ts,
            simulations_tbl               = simulations_tbl,
            simulations_median_value_tbl  = simulations_median_value_tbl
        ),
        plots = list(
            static_plot = g,
            plotly_plot = p
        )
    )

    # Return ----
    return(output)

}
