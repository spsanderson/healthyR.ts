#' Simple Moving Average Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function will take in a value column and return any number `n` moving averages.
#'
#' @details
#' This function will accept a time series object or a tibble/data.frame. This is a
#' simple wrapper around [timetk::slidify_vec()]. It uses that function to do the underlying
#' moving average work.
#'
#' It can only handle a single moving average at a time and therefore if multiple
#' are called for, it will loop through and append data to a tibble or `ts` object.
#'
#' @param .data The data that you are passing, this can be either a `ts` object or a `tibble`
#' @param .sma_order This will default to 1. This can be a vector like c(2,4,6,12)
#' @param .align This can be either "left", "center", "right"
#' @param .partial This is a bool value of TRUE/FALSE, the default is TRUE
#' @param .interactive This is a bool value of TRUE/FALSE, the default is FALSE.
#' If this is set to TRUE, then a `plotly::ggplotly` object will be returned.
#'
#' @examples
#' ts_sma_plot(AirPassengers)
#'
#' @return
#' Will invisibly return a list object.
#'
#' @export ts_sma_plot
#'

ts_sma_plot <- function(.data, .sma_order, .func = mean, .align = "center",
                        .partial = FALSE, .interactive = FALSE) {

    # * Tidyeval ----
    # slidify_vec parameters
    sma_vec      <- as.vector(.sma_order)
    sma_fun      <- .func
    sma_align    <- stringr::str_to_lower(as.character(.align))
    sma_partial  <- as.logical(.partial)
    multi_plot   <- as.logical(.multi_plot)
    interactive  <- as.logical(.interactive)

    # * Checks ----
    if(!sma_align %in% c("center","left","right")){
        stop(call. = FALSE, "(.align) must be either 'center','left', or 'right'")
    }

    if(!is.numeric(sma_vec)){
        stop(call. = FALSE, "(.sma_order) must be all numeric values, c(1,2,3,...)")
    }

    if(!is.logical(sma_partial) & !is.logical(multi_plot) & !is.logical(interactive)){
        stop(call. = FLASE, "(.partial) (.multi_plot) and (.interactive) must all be logical values.")
    }

    # Get data object
    ts_obj <- .data

    # Get data and try to coerce to tibble
    # We do this because we use timetk::slidify_vec
    if(stats::is.ts(ts_obj) | stats::is.mts(ts_obj) | xts::is.xts(ts_obj) | zoo::is.zoo(ts_obj)){
        message("Attempting to coerce to a tibble.")
        ts_tbl <- ts_to_tbl(ts_obj)
    } else {
        ts_tbl <- ts_obj
    }

    # * Loop through periods ----
    df <- data.frame(matrix(ncol = 0, nrow = 0))
    for(i in sma_vec){
        ret_tmp <- ts_tbl %>%
            dplyr::mutate(sma_order = as.factor(i)) %>%
            dplyr::mutate(sma_value = timetk::slidify_vec(
                .x       = value,
                .f       = sma_fun,
                .period  = i,
                .align   = sma_align,
                .partial = sma_partial
            ))

        df <- base::rbind(df, ret_tmp)
    }

    date_col_exists <- "date_col" %in% base::names(df)

    # * Plots ----
    g <- df %>%
        ggplot2::ggplot(
            ggplot2::aes(
                x = if(date_col_exists){date_col} else {1:nrow(df)},
                y = value,
                group = sma_order,
                color = sma_order
            )
        ) +
        ggplot2::geom_line(color = "black") +
        ggplot2::geom_line(
            data = df,
            ggplot2::aes(y = sma_value)
        ) +
        ggplot2::labs(
            x = "Time",
            y = "Value",
            title = "SMA Plot",
            subtitle = "Black line is original values.",
            color = "SMA Order"
        ) +
        tidyquant::theme_tq()

    # * Return ----
    print(g)
    return(df)

}

