#' Time Series Lag Correlation Analysis
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This function takes in a time series data in the form of a tibble and
#' outputs a list object of data and plots. This function will take in an argument
#' of '.lags' and get those lags in your data, outputting a correlation matrix,
#' heatmap and lag plot among other things of the input data.
#'
#' @description This function outputs a list object of both data and plots.
#'
#' The data output are the following:
#' -  lag_list
#' -  lag_tbl
#' -  correlation_lag_matrix
#' -  correlation_lag_tbl
#'
#' The plots output are the following:
#' -  lag_plot
#' -  plotly_lag_plot
#' -  correlation_heatmap
#' -  plotly_heatmap
#'
#' @param .data A tibble of time series data
#' @param .date_col A date column
#' @param .value_col The value column being analyzed
#' @param .lags This is a vector of integer lags, ie 1 or c(1,6,12)
#' @param .heatmap_color_low What color should the low values of the heatmap of
#' the correlation matrix be, the default is 'white'
#' @param .heatmap_color_hi What color should the low values of the heatmap of
#' the correlation matrix be, the default is 'steelblue'
#'
#' @examples
#' library(dplyr)
#'
#' df <- ts_to_tbl(AirPassengers) %>% select(-index)
#' lags <- c(1,3,6,12)
#'
#' output <- ts_lag_correlation(
#'   .data = df,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .lags = lags
#' )
#'
#' output$data$correlation_lag_matrix
#' output$plots$lag_plot
#'
#' @return
#' A list object
#'
#' @export
#'

ts_lag_correlation <- function(.data, .date_col, .value_col, .lags = 1,
                                   .heatmap_color_low = "white",
                                   .heatmap_color_hi = "steelblue") {

  # Tidyeval
  date_col_var_expr <- rlang::enquo(.date_col)
  value_col_var_expr <- rlang::enquo(.value_col)
  lags <- as.numeric(.lags)
  data_length <- nrow(.data)
  heatmap_low <- base::tolower(as.character(.heatmap_color_low))
  heatmap_hi <- base::tolower(as.character(.heatmap_color_hi))

  # Checks
  if (!is.data.frame(.data)) {
    rlang::abort(
      message = "'.data' must be a data.frame/tibble.",
      use_cli_format = TRUE
    )
  }

  if (rlang::quo_is_missing(date_col_var_expr)) {
    rlang::abort(
      message = "'.date_col' is required and must be a Date class.",
      use_cli_format = TRUE
    )
  }

  if (rlang::quo_is_missing(value_col_var_expr)) {
    rlang::abort(
      message = "'.value_col' is required and must be numeric.",
      use_cli_format = TRUE
    )
  }

  # Data
  df <- dplyr::as_tibble(.data) %>%
    dplyr::select(
      {{ date_col_var_expr }}, {{ value_col_var_expr }},
      dplyr::everything()
    ) %>%
    dplyr::rename(value = {{ value_col_var_expr }})

  # Lagged Tibble List
  lagged_list <- lapply(seq_along(lags), function(i) {
    dplyr::tibble(
      lag            = factor(lags[i]),
      original_value = df$value,
      lagged_value   = dplyr::lag(df$value, lags[i])
    ) %>%
      tidyr::drop_na() %>%
      dplyr::rename(
        {{ value_col_var_expr }} := original_value
      )
  })

  # Lagged Tibble
  lagged_tibble <- purrr::map_df(lagged_list, dplyr::as_tibble) %>%
    dplyr::mutate(lag_title = paste0("Lag: ", lag) %>%
      forcats::as_factor())

  # Lagged Correlation Matrix
  lagged_cor_matrix <- df %>%
    timetk::tk_augment_lags(
      .value = value,
      .lags = lags
    ) %>%
    dplyr::select(-{{ date_col_var_expr }}) %>%
    tidyr::drop_na() %>%
    stats::cor()

  # Lagged Correlation Long Tibble
  lct_names <- base::rownames(lagged_cor_matrix)

  lagged_cor_tbl <- lagged_cor_matrix %>%
    dplyr::as_tibble() %>%
    dplyr::mutate(data_names = lct_names) %>%
    dplyr::select(data_names, dplyr::everything()) %>%
    tidyr::pivot_longer(cols = -data_names) %>%
    dplyr::mutate(name = forcats::as_factor(name)) %>%
    dplyr::mutate(data_names = forcats::as_factor(data_names)) %>%
    dplyr::select(name, data_names, dplyr::everything())

  # Plots ----
  # Lagged Plot
  plt <- lagged_tibble %>%
    ggplot2::ggplot(
      ggplot2::aes(
        x = {{ value_col_var_expr }},
        y = lagged_value,
        color = lag
      )
    ) +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(~lag_title, scales = "free") +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x = "Original Value",
      y = "Lagged Value",
      color = "Lags"
    ) +
    ggplot2::theme(legend.position = "none")

  # Correlation Heatmap
  correlation_heatmap <- lagged_cor_tbl %>%
    ggplot2::ggplot(ggplot2::aes(
      x = name,
      y = data_names
    )) +
    ggplot2::geom_tile(ggplot2::aes(fill = value), color = "white") +
    ggplot2::scale_fill_gradient(
      low = heatmap_low,
      high = heatmap_hi
    ) +
    ggplot2::theme_minimal() +
    ggplot2::labs(
      x = "",
      y = "",
      fill = "Correlation"
    )

  # Return ----
  output <- list(
    data = list(
      lag_list = lagged_list,
      lag_tbl = lagged_tibble,
      correlation_lag_matrix = lagged_cor_matrix,
      correlation_lag_tbl = lagged_cor_tbl
    ),
    plots = list(
      lag_plot = plt,
      plotly_lag_plot = plotly::ggplotly(plt),
      correlation_heatmap = correlation_heatmap,
      plotly_heatmap = plotly::ggplotly(correlation_heatmap)
    )
  )

  attr(output, "input_data_length") <- data_length
  attr(output, ".lags") <- .lags

  return(output)
}
