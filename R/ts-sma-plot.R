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
#' are called for, it will loop through and append data to a tibble object.
#'
#' @param .data The data that you are passing, must be a data.frame/tibble.
#' @param .date_col The column that holds the date.
#' @param .value_col The column that holds the value.
#' @param .sma_order This will default to 1. This can be a vector like c(2,4,6,12)
#' @param .func The unquoted function you want to pass, mean, median, etc
#' @param .align This can be either "left", "center", "right"
#' @param .partial This is a bool value of TRUE/FALSE, the default is TRUE
#'
#' @examples
#' df <- ts_to_tbl(AirPassengers)
#' out <- ts_sma_plot(df, date_col, value, .sma_order = c(3,6))
#'
#' out$data
#'
#' out$plots$static_plot
#'
#'
#' @return
#' Will return a list object.
#'
#' @export ts_sma_plot
#'

ts_sma_plot <- function(.data, .date_col, .value_col, .sma_order = 2,
                        .func = mean, .align = "center", .partial = FALSE) {

    # * Tidyeval ----
    date_col_var_expr <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)

    # slidify_vec parameters
    sma_vec      <- as.vector(.sma_order)
    sma_fun      <- .func
    sma_align    <- stringr::str_to_lower(as.character(.align))
    sma_partial  <- as.logical(.partial)

    # * Checks ----
    if(!sma_align %in% c("center","left","right")){
        rlang::abort(
            message = "'.align' must be either 'center','left', or 'right'",
            use_cli_format = TRUE
        )
    }

    if(!is.numeric(sma_vec)){
        rlang::abort(
            message = "'.sma_order' must be all numeric values, c(1,2,3,...)",
            use_cli_format = TRUE
        )
    }

    if(!is.logical(sma_partial)){
        rlang::abort(
            message = "'.partial' must be a logical value.",
            use_cli_format = TRUE
        )
    }

    if(!is.data.frame(.data)){
        rlang::abort(
            message = "'.data' must be a data.frame/tibble.",
            use_cli_format = TRUE
        )
    }

    if(rlang::quo_is_missing(date_col_var_expr)){
        rlang::abort(
            message = "'.date_col' must be supplied.",
            use_cli_format = TRUE
        )
    }

    if(rlang::quo_is_missing(value_col_var_expr)){
        rlang::abort(
            message = "'.value_col' must be supplied.",
            use_cli_format = TRUE
        )
    }

    # Get data object
    ts_tbl <- dplyr::as_tibble(.data)

    # * Loop through periods ----
    df <- data.frame(matrix(ncol = 0, nrow = 0))
    for(i in sma_vec){
        ret_tmp <- ts_tbl %>%
            dplyr::mutate(sma_order = as.factor(i)) %>%
            dplyr::mutate(sma_value = timetk::slidify_vec(
                .x       = {{ value_col_var_expr }},
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
                x = {{ date_col_var_expr }},
                y = {{ value_col_var_expr }},
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
            title = paste0("SMA Plot"),
            subtitle = "Black line is original values.",
            color = "SMA Order"
        ) +
        ggplot2::theme_minimal()

    i_plot <- plotly::ggplotly(g)

    # * Return ----
    output <- list(
        data = df,
        plots = list(
            static_plot      = g,
            interactive_plot = i_plot
        )
    )

    return(output)

}
