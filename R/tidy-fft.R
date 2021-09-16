#' Tidy Style FFT
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Perform an fft using [fft()] and return a tidier style output list with plots.
#'
#' @details
#' - Set the intercept of the initial value from the random walk
#' - Set the max and min of the cumulative sum of the random walks
#'
#' @param .x The vector you want to analyze
#' @param .n The number of harmonics you want to plot out.
#' @param .up The upsampling of the time series.
#'
#' @examples
#'
#' @return
#' A list object.
#'
#' @export
#'

tidy_fft <- function(x = NULL, n = NULL, up = 10L){

    # * Variables ----
    x    <- x
    dff  <- fft(x)
    n    <- n
    up   <- up
    t    <- seq(from = 1, to = length(x))
    nt   <- seq(from = 1, to = length(x) + 1 - 1/up, by = 1/up)
    ndff <- array(data = 0, dim = c(length(nt), 1L))
    df   <- data.frame(matrix(ncol = 3, nrow = 0))
    colnames(df) <- c('time','y_hat','harmonic')
    dtx  <- tibble::tibble(x = x, y = 1:length(x))

    # * FFT Loop ----
    for(i in 1:n){
        ndff[1] = dff[1]
        if(i != 0){
            ndff[2:(i+1)] = dff[2:(i+1)]
            ndff[length(ndff):(length(ndff) - i + 1)] = dff[length(x):(length(x) - i + 1)]
        }
        indff_tmp <- fft(ndff/length(x), inverse = TRUE)
        idff_tmp  <- fft(dff/length(x), inverse = TRUE)
        harmonic  <- as.factor(i)
        ret_tmp   <- data.frame(
            time       = nt
            , y_hat    = Mod(indff_tmp)
            , harmonic = harmonic
        )
        df        <- rbind(df, ret_tmp)
    }

    # * Manipulate ----
    data_tbl <- tibble::as_tibble(df)

    data_tbl <- data_tbl %>%
        dplyr::mutate(x = replace(time, -seq(1, dplyr::n(), up), 0)) %>%
        dplyr::left_join(y = dtx, by = c("x" = "y")) %>%
        dplyr::rename(y_actual = x.y) %>%
        dplyr::select(harmonic, time, y_actual, y_hat, x) %>%
        dplyr::mutate(error_term = y_actual - y_hat)

    error_term_tbl <- data_tbl %>%
        dplyr::filter(!is.na(y_actual))

    # * Plot ----
    g <- data_tbl %>%
        ggplot2::ggplot(ggplot2::aes(x = x, y = y_actual)) +
        ggplot2::geom_line() +
        ggplot2::geom_point() +
        ggplot2::geom_line(
            ggplot2::aes(
                x = time
                , y = y_hat
                , group = harmonic
                , color = harmonic
            )
        ) +
        ggplot2::labs(
            title = paste0("Harmonics from 1:", n),
            x = "Time",
            y = "Measurement"
        ) +
        tidyquant::theme_tq() +
        ggplot2::theme(
            legend.position = "none"
        )

    # * Return ----
    output_list <- list(
        data = list(
            data       = data_tbl,
            error_data = error_term_tbl
        ),
        plots = list(
            plot   = g,
            plotly = plotly::ggplotly(g)
        )
    )

    return(invisible(output_list))

}

