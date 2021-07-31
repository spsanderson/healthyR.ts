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
#' @param .show_plot Logical, if TRUE will display the output plot.
#' @param .plotly_plot Logical, if TRUE will display the plotly plot otherwise a
#' ggplot object.
#'
#' @examples
#' library(forecast)
#' library(healthyR.data)
#' library(dplyr)
#' library(timetk)
#' library(ggplot2)
#' library(plotly)
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
#' # Make a ts object
#' start_date <- min(data$date_col)
#' start <- c(lubridate::year(start_date), lubridate::month(start_date))
#'
#'  data <- ts(
#'    data = data$value
#'    , start = c(start[[1]], start[[2]])
#'    , frequency = 12
#'  )
#'
#' # Create a model
#' fit <- auto.arima(data)
#'
#' # Simulate 50 possible forecast paths, with .horizon of 12 months
#' ts_forecast_simulator(
#'   .model        = fit
#'   , .horizon    = 12
#'   , .iterations = 50
#' )
#'
#'
#' @return The baseline series, the simulated values and a plot
#'
#' @export ts_forecast_simulator

ts_forecast_simulator <- function(.model,
                                  .horizon = 4,
                                  .iterations = 25,
                                  .sim_color = "steelblue",
                                  .alpha = 0.05,
                                  .show_plot = TRUE,
                                  .plotly_plot = TRUE) {

  # Setting variables
  x <- y <- s <- s1 <- sim_output <- p <- output <- NULL

  # Error handling
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

  if (!base::is.logical(.show_plot)) {
    warning("The value of the '.show_plot' parameter is invalid, using default option TRUE")
    .show_plot <- TRUE
  }

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

  sim_output <- s %>%
    dplyr::bind_rows() %>%
    tidyr::pivot_wider(names_from = n, values_from = y) %>%
    dplyr::select(-x) %>%
    stats::ts(
      start = stats::start(stats::simulate(.model, nsim = 1)),
      frequency = stats::frequency(stats::simulate(.model, nsim = 1))
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

  s1 <- s %>%
    dplyr::bind_rows() %>%
    dplyr::group_by(x) %>%
    dplyr::summarise(p50 = stats::median(y))

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

  if (.show_plot) {
    print(p)
  }

  output <- list(
      plot           = p
      , forecast_sim = sim_output
      , series       = .model$x
  )
  return(output)
}
