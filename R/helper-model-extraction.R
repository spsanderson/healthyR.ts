#' Model Method Extraction Helper
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description This takes in a model fit and returns the method of the fit object.
#'
#' @details
#' Currently supports forecasting model of one of the following from the
#' `forecast` package:
#'   * \code{\link[forecast]{Arima}}
#'   * \code{\link[forecast]{auto.arima}}
#'   * \code{\link[forecast]{ets}}
#'   * \code{\link[forecast]{nnetar}}
