#' Random Walk Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function takes in four arguments and returns a tibble of random walks.
#'
#' @details
#' Monte Carlo simulations were first formally designed in the 1940’s while
#' developing nuclear weapons, and since have been heavily used in various fields
#' to use randomness solve problems that are potentially deterministic in nature.
#' In finance, Monte Carlo simulations can be a useful tool to give a sense of
#' how assets with certain characteristics might behave in the future.
#' While there are more complex and sophisticated financial forecasting methods
#' such as ARIMA (Auto-Regressive Integrated Moving Average) and
#' GARCH (Generalized Auto-Regressive Conditional Heteroskedasticity)
#' which attempt to model not only the randomness but underlying macro factors
#' such as seasonality and volatility clustering, Monte Carlo random walks work
#' surprisingly well in illustrating market volatility as long as the results
#' are not taken too seriously.
#'
#' @param .mean The desired mean of the random walks
#' @param .sd The standard deviation of the random walks
#' @param .num_walks The number of random walks you want generated
#' @param .periods The length of the random walk(s) you want generated
#' @param .initial_value The initial value where the random walks should start
#'
#' @examples
#' ts_random_walk(
#' .mean = 0,
#' .sd = 1,
#' .num_walks = 25,
#' .periods = 180,
#' .initial_value = 6
#' )
#'
#' @return
#' A tibble
#'
#' @export
#'

ts_random_walk <- function(
    .mean = 0.0,
    .sd = 0.10,
    .num_walks = 100,
    .periods = 100,
    .initial_value = 1000
) {
    # Build data frame of first random walk
    x <- seq(1, .periods, 1)
    y <- stats::rnorm(.periods, .mean, .sd)
    df <- data.frame(run = 1, x = x, y = y)
    # Add on additional random walks
    for (i in 2:.num_walks) {
        x <- seq(1, .periods, 1)
        y <- stats::rnorm(.periods, .mean, .sd)
        tmp <- data.frame(run = i, x = x, y = y)
        df <- rbind(df, tmp)
    }
    # Convert data frame to tibble format
    df <- dplyr::as_tibble(
        df %>%
            # Group each random walk so cumprod will be applied to each of them separately
            dplyr::group_by(run) %>%
            # Calculate cumulative product of each random walk
            dplyr::mutate(cum_y = .initial_value * cumprod(1 + y)) %>%
            # Remove grouping to improve future performance
            dplyr::ungroup()
    )
    # Attach descriptive attributes to tibble
    attr(df, ".mean") <- .mean
    attr(df, ".sd") <- .sd
    attr(df, ".num_walks") <- .num_walks
    attr(df, ".periods") <- .periods
    attr(df, ".initial_value") <- .initial_value
    # Return final result as function output
    return(df)
}


