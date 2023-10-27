#' Logarithmic Transformation to Make Time Series Stationary
#'
#' @family Utility
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This function attempts to make a non-stationary time series stationary
#' by applying a logarithmic transformation. If successful, it returns the stationary
#' time series. If the transformation fails, it informs the user.
#'
#' @details
#' This function checks if the minimum value of the input time series is greater than or equal to zero.
#' If yes, it performs the Augmented Dickey-Fuller test on the logarithm of the time series.
#' If the p-value of the test is less than 0.05, it concludes that the logarithmic transformation
#' made the time series stationary and returns the result as a list with the following elements:
#'
#' - stationary_ts: The stationary time series after the logarithmic transformation.
#' - ndiffs: Not applicable in this case, marked as NA.
#' - adf_stats: Augmented Dickey-Fuller test statistics on the stationary time series.
#' - trans_type: Transformation type, which is "log" in this case.
#' - ret: TRUE to indicate a successful transformation.
#'
#' If the minimum value of the time series is less than or equal to 0 or if the logarithmic
#' transformation doesn't make the time series stationary, it informs the user and returns
#' a list with ret set to FALSE.
#'
#' @param .time_series A time series object to be made stationary.
#'
#' @examples
#' # Example 1: Using a time series dataset
#' util_log_ts(AirPassengers)
#'
#' # Example 2: Using a different time series dataset
#' util_log_ts(BJsales.lead)$ret
#'
#' @return
#' If the time series is already stationary or the logarithmic transformation is successful,
#' it returns a list as described in the details section. If the transformation fails,
#' it returns a list with ret set to FALSE.
#'
#' @name util_log_ts
NULL

#' @export
#' @rdname util_log_ts
util_log_ts <- function(.time_series){

    time_series <- .time_series
    min_x <- min(time_series)

    if (min_x >= 0){
        if (ts_adf_test(log(time_series))$p_value < 0.05){
            rlang::inform(
                message = "Logrithmic transformation made the time series stationary",
                use_cli_format = TRUE
            )
            stationary_ts <- log(time_series)
            # Return
            return(
                list(
                    stationary_ts = stationary_ts,
                    ndiffs = NA,
                    adf_stats = ts_adf_test(stationary_ts),
                    trans_type = "log",
                    ret = TRUE
                )
            )
        } else {
            rlang::inform(
                message = "Logrithmic Transformation Failed.",
                use_cli_format = TRUE
            )
            return(list(ret = FALSE))
        }
    } else {
        rlang::inform(
            message = "The minimum value of the time series is less than or equal to 0.",
            use_cli_format = TRUE
        )
        return(list(ret = FALSE))
    }
}
