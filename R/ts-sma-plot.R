#' Simple Moving Average Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will take in a value column and return any number `n` moving averages.
#'
#' @details
#' This function will accept a time series object or a tibble/data.frame. This is a
#' simple wrapper around [forecast::ma()]. It uses that function to do the underlying
#' moving average work.
#'
#' It can only handle a single moving average at a time and therefore if multiple
#' are called for, it will loop through and append data to a tibble and `ts` object.
#'
#' @param .data The data that you are passing, this can be either a `ts` object or a `tibble`
#' @param .value_col This only needs to be used if you are passing a `tibble` object.
#' @param .sma_order This will default to 1
#' @param .centered This is a bool value of TRUE/FALSE, the default is TRUE
#' @param .multi_plot
#' @param .interactive
#'
#'
#' @examples
#'
#' @return
#' Will invisibly return a list object.
#'
#' @export ts_sma_plot
#'

ts_sma_plot <- function(.data, )
