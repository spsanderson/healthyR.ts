#' Double Differencing to Make Time Series Stationary
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function attempts to make a non-stationary time series stationary by applying
#' double differencing. It iteratively increases the differencing order until stationarity is achieved.
#'
#' @details
#' The function calculates the frequency of the input time series using the `stats::frequency` function.
#' It then applies double differencing incrementally until the Augmented Dickey-Fuller test indicates
#' stationarity (p-value < 0.05) or until the differencing order reaches the frequency of the data.
#'
#' If double differencing successfully makes the time series stationary, it returns the stationary time series
#' and related information as a list with the following elements:
#' - stationary_ts: The stationary time series after double differencing.
#' - ndiffs: The order of differencing applied to make it stationary.
#' - adf_stats: Augmented Dickey-Fuller test statistics on the stationary time series.
#' - trans_type: Transformation type, which is "double_diff" in this case.
#' - ret: TRUE to indicate a successful transformation.
#'
#' If the data requires more double differencing than its frequency allows, it informs the user and
#' suggests trying differencing with the natural logarithm instead.
#'
#' @param .time_series A time series object to be made stationary.
#'
#' @examples
#' # Example 1: Using a time series dataset
#' util_doublediff_ts(AirPassengers)
#'
#' # Example 2: Using a different time series dataset
#' util_doublediff_ts(BJsales)$ret
#'
#' @return
#' If the time series is already stationary or the double differencing is successful,
#' it returns a list as described in the details section. If additional differencing is required,
#' it informs the user and returns a list with ret set to FALSE, suggesting trying differencing
#' with the natural logarithm.
#'
#' @name util_doublediff_ts
NULL

#' @export
#' @rdname util_doublediff_ts
util_doublediff_ts <- function(.time_series){

    time_series <- .time_series
    f <- stats::frequency(time_series)

    # Double Differencing
    diff_order <- 1
    while ((ts_adf_test(diff(diff(time_series, diff_order)))$p_value >= 0.05) &
           (diff_order <= f)){
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
        stationary_ts <- diff(diff(time_series, diff_order))
        return(
            list(
                stationary_ts = stationary_ts,
                ndiffs = diff_order,
                adf_stats = ts_adf_test(stationary_ts),
                trans_type = "double_diff",
                ret = TRUE
            )
        )
    } else {
        rlang::inform(
            message = "Data requires more double differencing than its frequency,
      trying differencing log.",
      use_cli_format = TRUE
        )
        return(list(ret = FALSE))
    }
}
