#' Vector Function Time Series Growth Rate
#'
#' @family Vector Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function computes the growth rate of a numeric vector,
#' typically representing a time series, with optional transformations like
#' scaling, power, and lag differences.
#'
#' @details
#' The function calculates growth rates for a time series, allowing for scaling,
#' exponentiation, and lag differences. It can be useful for financial data analysis,
#' among other applications.
#'
#' The growth rate is computed as follows:
#' - If lags is positive and log_diff is FALSE:
#'   growth_rate = (((x / lag(x, lags))^power) - 1) * scale
#' - If lags is positive and log_diff is TRUE:
#'   growth_rate = log(x / lag(x, lags)) * scale
#' - If lags is negative and log_diff is FALSE:
#'   growth_rate = (((x / lead(x, -lags))^power) - 1) * scale
#' - If lags is negative and log_diff is TRUE:
#'   growth_rate = log(x / lead(x, -lags)) * scale
#'
#' @param .x A numeric vector
#' @param .scale A numeric value that is used to scale the output
#' @param .power A numeric value that is used to raise the output to a power
#' @param .log_diff A logical value that determines whether the output is a log difference
#' @param .lags An integer that determines the number of lags to use
#'
#' @examples
#' # Calculate the growth rate of a time series without any transformations.
#' ts_growth_rate_vec(c(100, 110, 120, 130))
#'
#' # Calculate the growth rate with scaling and a power transformation.
#' ts_growth_rate_vec(c(100, 110, 120, 130), .scale = 10, .power = 2)
#'
#' # Calculate the log differences of a time series with lags.
#' ts_growth_rate_vec(c(100, 110, 120, 130), .log_diff = TRUE, .lags = -1)
#'
#' # Plot
#' plot.ts(AirPassengers)
#' plot.ts(ts_growth_rate_vec(AirPassengers))
#'
#' @return
#' A list object of workflows.
#'
#' @name ts_growth_rate_vec
NULL

#' @export
#' @rdname ts_growth_rate_vec

ts_growth_rate_vec <- function(.x, .scale = 100, .power = 1, .log_diff = FALSE,
                               .lags = 1){

    # Variables
    x <- as.vector(as.numeric(.x))
    s <- as.numeric(.scale)
    p <- as.numeric(.power)
    l <- as.numeric(.lags)
    ld <- as.logical(.log_diff)

    # Checks
    if (!is.vector(x) | !is.numeric(x)){
        rlang::abort(
            message = ".x must be a numeric vector",
            use_cli_format = TRUE
        )
    }

    if (!is.numeric(s) | !is.numeric(p) | !is.numeric(l)){
        rlang::abort(
            message = ".scale, .power and .lags must all be numeric",
            use_cli_format = TRUE
        )
    }

    if (!is.logical(ld)){
        rlang::abort(
            message = ".log_diff must be either TRUE or FALSE",
            use_cli_format = TRUE
        )
    }

    if (l == 0){
        rlang::abort(
            message = ".lags must be an integer that is either greater than or less than 0",
            use_cli_format = TRUE
        )
    }

    # Calculation
    if (l < 0){
        if (ld) {
            return(log(x / dplyr::lead(x, -l)) * s)
        } else {
            return(((x / dplyr::lead(x, -l))^p - 1) * s)
        }
    } else if (ld){
        return(log(x/dplyr::lag(x, l)) * s)
    } else {
        return(((x / dplyr::lag(x, l))^p - 1) * s)
    }
}
