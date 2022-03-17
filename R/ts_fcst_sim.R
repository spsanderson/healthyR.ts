#' Time-series Forecasting Simulator
#'
#' @family Simulator
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description Creating different forecast paths for forecast objects (when applicable),
#' by utilizing the underlying model distribution with the \code{\link[stats]{simulate}} function.
#'
#' @details This function expects to take in a model of either `Arima`,
#' `auto.arima`, `ets` or `nnetar` from the `forecast` package. You can supply a
#' forecasting horizon, iterations and a few other items. You may also specify
#' an Arima() model using xregs.
#'
#' @param .model A forecasting model of one of the following from the `forecast` package:
#'   * \code{\link[forecast]{Arima}}
#'   * \code{\link[forecast]{auto.arima}}
#'   * \code{\link[forecast]{ets}}
#'   * \code{\link[forecast]{nnetar}}
#'   * `Arima()` with xreg
#' @param .data The data that is used for the `.model` parameter. This is used with
#' [timetk::tk_index()]
#' @param .ext_reg A `tibble` or `matrix` of future xregs that should be the same
#' length as the horizon you want to forecast.
#' @param .frequency This is for the conversion of an internal table and should
#' match the time frequency of the data.
#' @param .bootstrap A boolean value of TRUE/FALSE. From [forecast::simulate.Arima()]
#' Do simulation using resampled errors rather than normally distributed errors.
#' @param .horizon An integer defining the forecast horizon.
#' @param .iterations An integer, set the number of iterations of the simulation.
#' @param .sim_color Set the color of the simulation paths lines.
#' @param .alpha Set the opacity level of the simulation path lines.
#'
#' @examples
#' suppressPackageStartupMessages(library(forecast))
#' suppressPackageStartupMessages(library(dplyr))
#'
#' # Create a model
#' fit <- auto.arima(AirPassengers)
#' data_tbl <- ts_to_tbl(AirPassengers)
#'
#' # Simulate 50 possible forecast paths, with .horizon of 12 months
#' output <- ts_forecast_simulator(
#'   .model        = fit
#'   , .horizon    = 12
#'   , .iterations = 50
#'   , .data       = data_tbl
#' )
#'
#' output$ggplot
#'
#' @return The original time series, the simulated values and a some plots
#'
#' @export ts_forecast_simulator

ts_forecast_simulator <- function(.model,
                                  .data,
                                  .ext_reg = NULL,
                                  .frequency = NULL,
                                  .bootstrap = TRUE,
                                  .horizon = 4,
                                  .iterations = 25,
                                  .sim_color = "steelblue",
                                  .alpha = 0.05) {

  # Setting variables
  x <- y <- s <- s1 <- sim_output <- p <- output <- NULL
  boot <- as.logical(.bootstrap)
  ext_reg <- .ext_reg
  freq <- as.integer(.frequency)
  has_xreg <- if(is.null(.ext_reg)){
    FALSE
  } else {
    TRUE
  }

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

  # Check external regressors
  if (has_xreg && !any(class(.ext_reg) %in% c("matrix", "data.frame","tbl"))){
    rlang::abort("The '.ext_reg' argument requires that you pass either a
                 matrix or tibble of future external regressors.")
  }

  if(has_xreg & is.data.frame(ext_reg)){
    ext_reg <- as.matrix(ext_reg)
  } else {
    ext_reg <- ext_reg
  }

  # Data ----
  data_tbl <- .data

  # Manipulation ----
  # Simulation
  s <- lapply(1:.iterations, function(i) {
    # Set Var
    sim <- sim_df <- x <- y <- NULL

    sim <- stats::simulate(.model, nsim = .horizon, xreg = ext_reg,
                           future = TRUE, bootstrap = boot)
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
      start = stats::start(stats::simulate(.model, nsim = 1, xreg = ext_reg)),
      frequency = stats::frequency(stats::simulate(.model, nsim = 1, xreg = ext_reg))
    )

  # Make s into a tibble
  s_tbl <- purrr::map_dfr(s, dplyr::as_tibble) %>%
    dplyr::group_by(n) %>%
    dplyr::mutate(id = dplyr::row_number(n)) %>%
    dplyr::ungroup()

  # Make a model time series tibble
  model_ts_tbl <- timetk::tk_tbl(.model$x, timetk_idx = TRUE, silent = TRUE)

  # If model_ts_tbl has only one column, rename it value
  start_date <- min(data_tbl %>% timetk::tk_index())
  end_date   <- max(data_tbl %>% timetk::tk_index())

  start_yr <- lubridate::year(start_date)
  start_mo <- lubridate::month(start_date)

  end_yr <- lubridate::year(end_date)
  end_mo <- lubridate::month(end_date)

  if(ncol(model_ts_tbl) == 1) {
    model_ts_tbl <- stats::ts(
      model_ts_tbl,
      start = c(start_yr, start_mo),
      frequency = freq
    ) %>%
      timetk::tk_tbl() %>%
      dplyr::mutate(index = as.Date(index, format = "%Y-%B"))

    names(model_ts_tbl)[2] <- "value"
  } else {
    model_ts_tbl <- model_ts_tbl
  }

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
  model_method <- healthyR.ts::model_extraction_helper(.fit_object = .model)
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
    ggplot2::theme_minimal() +
    ggplot2::labs(
      title = glue::glue("Model: {model_method}, Iterations: {.iterations}")
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
      #color = "#00526d",
      color = "red",
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
    plotly_plot           = p
    , ggplot              = g
    , forecast_sim        = sim_output
    , forecast_sim_tbl    = s_tbl
    , time_series         = .model$x
    , fitted_values       = .model$fitted
    , fitted_values_tbl   = .model$fitted %>% timetk::tk_tbl()
    , residual_values     = .model$residuals
    , residual_values_tbl = .model$residuals %>% timetk::tk_tbl()
    , input_data          = model_ts_tbl
    , sim_ts_tbl          = s_joined_tbl
  )

  # Return ----
  return(output)
}
