#' Automatically Stationarize Time Series Data
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function attempts to make a non-stationary time series stationary.
#' This function attempts to make a given time series stationary by applying transformations
#' such as differencing or logarithmic transformation. If the time series is already
#' stationary, it returns the original time series.
#'
#' @details
#' If the input time series is non-stationary (determined by the Augmented Dickey-Fuller test),
#' this function will try to make it stationary by applying a series of transformations:
#' 1. It checks if the time series is already stationary using the Augmented Dickey-Fuller test.
#' 2. If not stationary, it attempts a logarithmic transformation.
#' 3. If the logarithmic transformation doesn't work, it applies differencing.
#'
#' @param .time_series A time series object to be made stationary.
#'
#' @examples
#' # Example 1: Using the AirPassengers dataset
#' auto_stationarize(AirPassengers)
#'
#' # Example 2: Using the BJsales dataset
#' auto_stationarize(BJsales)
#'
#' @return
#' If the time series is already stationary, it returns the original time series.
#' If a transformation is applied to make it stationary, it returns a list with two elements:
#' - stationary_ts: The stationary time series.
#' - ndiffs: The order of differencing applied to make it stationary.
#'
#' @name auto_stationarize
NULL

#' @export
#' @rdname auto_stationarize
auto_stationarize <- function(.time_series) {

    # Variables
    time_series <- .time_series
    freq <- frequency(.time_series)
    min_x <- min(.time_series)

    # Check if the time series is already stationary
    if (ts_adf_test(time_series)$p_value < 0.05) {
        cat("The time series is already stationary via ts_adf_test().\n")
        return(time_series)
    } else {
        cat("The time series is not stationary. Attempting to make it stationary...\n")
    }

    # Transformation (e.g., logarithmic)
    ret <- util_log_ts(time_series)
    if(ret$ret == TRUE){return(ret)}

    # Single Differencing
    ret <- util_singlediff_ts(time_series)
    if (ret$ret == TRUE){return(ret)}

    # Double Differencing
    ret <- util_doublediff_ts(time_series)
    if (ret$ret == TRUE){return(ret)}

    # Diff of Log
    ret <- util_difflog_ts(time_series)
    if (ret$ret == TRUE){return(ret)}

    # Double Diff Log
    ret <- util_doubledifflog_ts(time_series)
    if (ret$ret == TRUE){return(ret)}

}
