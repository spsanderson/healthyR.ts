#' Time-series Forecasting Simulator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Creating different forecast paths for forecast objects (when applicable),
#' by utilizing the underline model distribution with the \code{\link[stats]{simulate}} function.
#'
#' @details This function expects to take in a model of either `Arima`,
#' `auto.arima`, `ets` or `nnetar` from the `forecast` package. You can supply a
#' forecasting horizon, iterations and a few other items.
#'

#' @param .model A forecasting model of one of the following from the `forecast` package:
#'   * \code{\link[forecast]{Arima}}
#'   * \code{\link[forecast]{auto.arima}}
#'   * \code{\link[forecast]{ets}}
#'   * \code{\link[forecast]{nnetar}}
#' @param .horizon An integer defining the forecast horizon.
#' @param .iterations An integer, set the number of iterations of the simulation.
#' @param .sim_color Set the color of the simulation paths lines.
#' @param .alpha Set the opacity level of the simulation path lines.
#' @param .data The data that is used for the `.model` parameter. This is used with
#' [timetk::tk_index()]
#'
#' @examples
#' suppressPackageStartupMessages(library(forecast))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(ggplot2))
#' suppressPackageStartupMessages(library(plotly))
#' suppressPackageStartupMessages(library(purrr))
#' suppressPackageStartupMessages(library(tidyquant))
#' suppressPackageStartupMessages(library(tidyr))
#'
#' data <- healthyR_data %>%
#'  filter(ip_op_flag == "I") %>%
#'    select(visit_end_date_time) %>%
#'    rename(date_col = visit_end_date_time) %>%
#'    summarise_by_time(
#'        .date_var = date_col
#'        , .by     = "month"
#'        , value   = n()
#'   ) %>%
#'    filter_by_time(
#'        .date_var     = date_col
#'        , .start_date = "2012"
#'        , .end_date   = "2019"
#'    )
#'
#' data_ts <- tk_ts(data = data, frequency = 12)
#'
#' # Create a model
#' fit <- auto.arima(data_ts)
#'
#' # Simulate 50 possible forecast paths, with .horizon of 12 months
#' output <- ts_forecast_simulator(
#'   .model        = fit
#'   , .horizon    = 12
#'   , .iterations = 50
#'   , .data       = data
#' )
#'
#' output$ggplot
#'
#' output$plotly_plot
#'
#' output$forecast_sim_tbl
#'
#' output$input_data
#'
#' output$sim_ts_tbl
#'
#' output$forecast_sim
#'
#' output$time_series
#'
#'
#' @return The original time series, the simulated values and a some plots
#'
#' @export ts_forecast_simulator

ts_forecast_simulator <- function(.model,
                                  .horizon = 4,
                                  .iterations = 25,
                                  .sim_color = "steelblue",
                                  .alpha = 0.05,
                                  .data) {

  # Setting variables
  x <- y <- s <- s1 <- sim_output <- p <- output <- NULL

  # Checks ----
  if (!any(class(.model) %in% c("ARIMA", "ets", "nnetar", "Arima"))) {
    stop("The .model argument is not valid")
  }

  if (.alpha < 0 || .alpha > 1) {
    stop("The value of the '.alpha' argument is invalid")
  }

  if (!is.numeric(.iterations)) {
    stop("The value of the '.iterations' argument is not valid")
  }

  if (!is.numeric(.horizon)) {
    stop("The value of the '.horizon' argument is not valid")
  } else if (.horizon %% 1 != 0) {
    stop("The '.horizon' argument is not integer")
  } else if (.horizon < 1) {
    stop("The value of the '.horizon' argument is not valid")
  }

  if(!is.data.frame(.data)){
    stop(call. = FALSE, "You must provide a data.frame/tibble to this function.")
  }

  # Data ----
  data_tbl <- .data

  # Manipulation ----
  # Simulation
  s <- lapply(1:.iterations, function(i) {
    # Set Var
    sim <- sim_df <- x <- y <- NULL

    sim <- stats::simulate(.model, nsim = .horizon)
    sim_df <- base::data.frame(
      x = base::as.numeric(stats::time(sim)),
      y = base::as.numeric(sim)
    )
    sim_df$n <- base::paste0("sim_", i)
    return(sim_df)
  })

  s1 <- s %>%
    dplyr::bind_rows() %>%
    dplyr::group_by(x) %>%
    dplyr::summarise(p50 = stats::median(y))

  # Simulation Output
  sim_output <- s %>%
    dplyr::bind_rows() %>%
    tidyr::pivot_wider(names_from = n, values_from = y) %>%
    dplyr::select(-x) %>%
    stats::ts(
      start = stats::start(stats::simulate(.model, nsim = 1)),
      frequency = stats::frequency(stats::simulate(.model, nsim = 1))
    )

  # Make s into a tibble
  s_tbl <- purrr::map_dfr(s, as_tibble) %>%
    dplyr::group_by(n) %>%
    dplyr::mutate(id = dplyr::row_number(n)) %>%
    dplyr::ungroup()

  # Make a model time series tibble
  model_ts_tbl <- timetk::tk_tbl(.model$x, timetk_idx = TRUE)

  # Get the timetk index of the
  data_ts_index <- timetk::tk_index(data = data_tbl)
  future_tbl <- timetk::tk_make_future_timeseries(
    idx = data_ts_index
    , length_out = .horizon
  ) %>%
    tibble::as_tibble() %>%
    dplyr::mutate(id = dplyr::row_number())

  s_joined_tbl <- s_tbl %>%
    dplyr::left_join(future_tbl, by = c("id"="id")) %>%
    dplyr::select(value, dplyr::everything()) %>%
    dplyr::rename(index = value)

  s1_tbl <- s1 %>%
    dplyr::mutate(id = dplyr::row_number()) %>%
    dplyr::left_join(future_tbl, by = c("id"="id")) %>%
    dplyr::select(value, dplyr::everything()) %>%
    dplyr::rename(index = value)

  # ggplot object
  g <- ggplot2::ggplot(
    data = model_ts_tbl
    , ggplot2::aes(x = index, y = value)
  ) +
    ggplot2::geom_line() +
    ggplot2::geom_line(
      data = s1_tbl
      , ggplot2::aes(x = index, y = p50)
      , color = "red"
      , size = 1
    ) +
    ggplot2::geom_line(
      data = s_joined_tbl
      , ggplot2::aes(x = index, y = y, group = n)
      , alpha = .alpha
      , color = .sim_color
    ) +
    tidyquant::theme_tq() +
    ggplot2::labs(
      title = glue::glue("Model: {.model$method}, Iterations: {.iterations}")
    )

  p <- plotly::plot_ly()

  for (i in 1:.iterations) {
    p <- p %>%
      plotly::add_lines(
        x = s[[i]]$x,
        y = s[[i]]$y,
        line = list(color = .sim_color),
        opacity = .alpha,
        showlegend = FALSE,
        name = paste("Sim", i, sep = " ")
      )
  }

  # Plotly Plot
  p <- p %>% plotly::add_lines(
    x = s1$x, y = s1$p50,
    line = list(
      color = "#00526d",
      dash = "dash",
      width = 3
    ), name = "Median"
  )

  p <- p %>%
      plotly::add_lines(
        x = stats::time(.model$x),
        y = .model$x,
        line = list(color = "#00526d"),
        name = "Actual"
      )

  output <- list(
      plotly_plot        = p
      , ggplot           = g
      , forecast_sim     = sim_output
      , forecast_sim_tbl = s_tbl
      , time_series      = .model$x
      , input_data       = model_ts_tbl
      , sim_ts_tbl       = s_joined_tbl
  )

  # Return ----
  return(output)
}
