#' Single Differencing to Make Time Series Stationary
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function attempts to make a non-stationary time series stationary by applying
#' single differencing. It iteratively increases the differencing order until stationarity is achieved.
#'
#' @details
#' The function calculates the frequency of the input time series using the `stats::frequency` function.
#' It then applies single differencing incrementally until the Augmented Dickey-Fuller test indicates
#' stationarity (p-value < 0.05) or until the differencing order reaches the frequency of the data.
#'
#' If single differencing successfully makes the time series stationary, it returns the stationary time series
#' and related information as a list with the following elements:
#' - stationary_ts: The stationary time series after differencing.
#' - ndiffs: The order of differencing applied to make it stationary.
#' - adf_stats: Augmented Dickey-Fuller test statistics on the stationary time series.
#' - trans_type: Transformation type, which is "diff" in this case.
#' - ret: TRUE to indicate a successful transformation.
#'
#' If the data requires more single differencing than its frequency allows, it informs the user and
#' returns a list with ret set to FALSE, indicating that double differencing may be needed.
#'
#' @param .time_series A time series object to be made stationary.
#'
#' @examples
#' # Example 1: Using a time series dataset
#' util_singlediff_ts(AirPassengers)
#'
#' # Example 2: Using a different time series dataset
#' util_singlediff_ts(BJsales)$ret
#'
#' @return
#' If the time series is already stationary or the single differencing is successful,
#' it returns a list as described in the details section. If additional differencing is required,
#' it informs the user and returns a list with ret set to FALSE.
#'
#' @name util_singlediff_ts
NULL

#' @export
#' @rdname util_singlediff_ts
util_singlediff_ts <- function(.time_series){

    time_series <- .time_series
    f <- stats::frequency(time_series)

    # Single Differencing
    diff_order <- 1
    while ((ts_adf_test(diff(time_series, diff_order))$p_value >= 0.05) &
           (diff_order <= f)){
        diff_order <- diff_order + 1
    }

    if (diff_order <= f){
        rlang::inform(
            message = paste0("Differencing of order "
                             , diff_order
                             , " made the time series stationary"),
            use_cli_format = TRUE
        )
        # Return
        stationary_ts <- diff(time_series, diff_order)
        return(
            list(
                stationary_ts = stationary_ts,
                ndiffs = diff_order,
                adf_stats = ts_adf_test(stationary_ts),
                trans_type = "diff",
                ret = TRUE
            )
        )
    } else {
        rlang::inform(
            message = "Data requires more single differencing than its frequency,
      trying double differencing",
      use_cli_format = TRUE
        )
        return(list(ret = FALSE))
    }
}
