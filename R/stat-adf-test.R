#' Augmented Dickey-Fuller Test for Time Series Stationarity
#'
#' @family Statistical Test
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function performs the Augmented Dickey-Fuller test to assess the
#' stationarity of a time series. The Augmented Dickey-Fuller (ADF) test is used
#' to determine if a given time series is stationary. This function takes a
#' numeric vector as input, and you can optionally specify the lag order with
#' the `.k` parameter. If `.k` is not provided, it is calculated based on the
#' number of observations using a formula. The test statistic and p-value are
#' returned.
#'
#' @param .x A numeric vector representing the time series to be tested for
#' stationarity.
#' @param .k An optional parameter specifying the number of lags to use in the
#' ADF test (default is calculated).
#'
#' @examples
#' # Example 1: Using the AirPassengers dataset
#' ts_adf_test(AirPassengers)
#'
#' # Example 2: Using a custom time series vector
#' custom_ts <- rnorm(100, 0, 1)
#' ts_adf_test(custom_ts)
#'
#' @return
#' A list containing the results of the Augmented Dickey-Fuller test:
#' - `test_stat`: The test statistic from the ADF test.
#' - `p_value`: The p-value of the test.
#'
#' @name ts_adf_test
NULL

#' @export
#' @rdname ts_adf_test
ts_adf_test <- function(.x, .k = NULL) {
    # Variables
    x <- as.vector(.x, mode = "double")
    k <- .k

    # Checks
    if (!is.vector(x) || !is.numeric(x)){
        rlang::abort(
            message = ".x is not a numeric vector",
            use_cli_format = TRUE
        )
    }

    if (any(is.na(x))) {
        rlang::abort(
            message = "NAs are present in x",
            use_cli_format = TRUE
        )
    }

    if (is.null(k)){
        k <- trunc((length(x) - 1)^(1 / 3))
    }

    if (k < 0) {
        rlang::abort(
            message = ".k must be positive",
            use_cli_format = TRUE
        )
    }

    k <- k + 1
    y <- diff(x)
    n <- length(y)
    z <- stats::embed(y, k)
    yt <- z[, 1]
    xt1 <- x[k:n]
    tt <- k:n

    if (k > 1) {
        yt1 <- z[, 2:k]
        res <- stats::lm(yt ~ xt1 + 1 + tt + yt1)
    } else {
        res <- stats::lm(yt ~ xt1 + 1 + tt)
    }

    res_sum <- summary(res)
    stat <- res_sum$coefficients[2, 1] / res_sum$coefficients[2, 2]
    table <- cbind(
        c(4.38, 4.15, 4.04, 3.99, 3.98, 3.96),
        c(3.95, 3.80, 3.73, 3.69, 3.68, 3.66),
        c(3.60, 3.50, 3.45, 3.43, 3.42, 3.41),
        c(3.24, 3.18, 3.15, 3.13, 3.13, 3.12),
        c(1.14, 1.19, 1.22, 1.23, 1.24, 1.25),
        c(0.80, 0.87, 0.90, 0.92, 0.93, 0.94),
        c(0.50, 0.58, 0.62, 0.64, 0.65, 0.66),
        c(0.15, 0.24, 0.28, 0.31, 0.32, 0.33)
    )
    table <- -table
    tablen <- dim(table)[2]
    tableT <- c(25, 50, 100, 250, 500, 100000)
    tablep <- c(0.01, 0.025, 0.05, 0.10, 0.90, 0.95, 0.975, 0.99)
    tableipl <- numeric(tablen)
    for (i in (1:tablen)) {
        tableipl[i] <- stats::approx(tableT, table[, i], n, rule = 2)$y
    }
    p_val <- stats::approx(tableipl, tablep, stat, rule = 2)$y

    return(
        list(
            test_stat = stat,
            p_value = p_val
        )
    )
}
