#' Double Differencing with Log Transformation to Make Time Series Stationary
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function attempts to make a non-stationary time series stationary by applying
#' double differencing with a logarithmic transformation. It iteratively increases the differencing order
#' until stationarity is achieved or informs the user if the transformation is not possible.
#'
#' @details
#' The function calculates the frequency of the input time series using the `stats::frequency` function
#' and checks if the minimum value of the time series is greater than 0. It then applies double differencing
#' with a logarithmic transformation incrementally until the Augmented Dickey-Fuller test indicates
#' stationarity (p-value < 0.05) or until the differencing order reaches the frequency of the data.
#'
#' If double differencing with a logarithmic transformation successfully makes the time series stationary,
#' it returns the stationary time series and related information as a list with the following elements:
#' - stationary_ts: The stationary time series after the transformation.
#' - ndiffs: The order of differencing applied to make it stationary.
#' - adf_stats: Augmented Dickey-Fuller test statistics on the stationary time series.
#' - trans_type: Transformation type, which is "double_diff_log" in this case.
#' - ret: TRUE to indicate a successful transformation.
#'
#' If the data either had a minimum value less than or equal to 0 or requires more differencing than
#' its frequency allows, it informs the user that the data could not be stationarized.
#'
#' @param .time_series A time series object to be made stationary.
#'
#' @examples
#' # Example 1: Using a time series dataset
#' util_doubledifflog_ts(AirPassengers)
#'
#' # Example 2: Using a different time series dataset
#' util_doubledifflog_ts(BJsales)$ret
#'
#' @return
#' If the time series is already stationary or the double differencing with a logarithmic transformation is successful,
#' it returns a list as described in the details section. If the transformation is not possible, it informs
#' the user and returns a list with ret set to FALSE, indicating that the data could not be stationarized.
#'
#' @name util_doubledifflog_ts
NULL

#' @export
#' @rdname util_doubledifflog_ts
util_doubledifflog_ts <- function(.time_series){

    time_series <- .time_series
    f <- stats::frequency(time_series)
    min_x <- min(time_series)

    # Diff of Log
    diff_order <- 1
    while (
        (min_x > 0) &
        (ts_adf_test(diff(diff(log(time_series), diff_order)))$p_value >= 0.05 &
         (diff_order <= f))
    ){
        diff_order <- diff_order + 1
    }

    if (diff_order <= f){
        rlang::inform(
            message = paste0("Double Differencing of order "
                             , diff_order
                             , " made the time series stationary"),
            use_cli_format = TRUE
        )
        # Return
        stationary_ts <- diff(diff(log(time_series), diff_order))
        return(
            list(
                stationary_ts = stationary_ts,
                ndiffs = diff_order,
                adf_stats = ts_adf_test(stationary_ts),
                trans_type = "double_diff_log",
                ret = TRUE
            )
        )
    } else {
        rlang::inform(
            message = "Could not stationarize data.",
            use_cli_format = TRUE
        )
        return(list(ret = FALSE))
    }
}
