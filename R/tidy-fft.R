#' Tidy Style FFT
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' Perform an fft using [fft()] and return a tidier style output list with plots.
#'
#' @details
#'
#'
#' @param .data The data.frame/tibble you will pass for analysis.
#' @param .value_col The column that holds the data to be analyzed.
#' @param .date_col The column that holds the date.
#' @param .frequency The frequency of the data, 12 = monthly for example.
#' @param .harmonics How many harmonic waves do you want to produce.
#' @param .upsampling The upsampling of the time series.
#'
#' @examples
#'
#' @return
#' A list object.
#'
#' @export
#'

tidy_fft <- function(.data, .value_col, .date_col, .frequency = 12L,
                         .harmonics = 1L, .upsampling = 10L){

    # * Checks ----
    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) must be supplied as a data.frame")
    }

    if(is.na(.harmonics)){
        message(".harmonics was not provided so setting to 1.")
        .harmonics <- 1L
    }

    if(!is.numeric(.harmonics)){
        stop(call. = FALSE, "(.harmonics) must be a positive number and coercable to an integer.")
    }

    if(!is.numeric(.frequency)){
        stop(call. = FALSE, "(.frequency) must be a positive number and coercable to an integer.")
    }

    # * Data ----
    data <- tibble::as_tibble(.data)

    # * Value Vector ----
    value_col <- rlang::enquo(.value_col)
    x <- data %>% dplyr::pull( {{ value_col }} )

    # ** Dates ----
    date_col_var <- rlang::enquo(.date_col)
    date_data    <- data %>% dplyr::pull( {{date_col_var }} )
    date_val     <- lubridate::as_datetime(date_data)
    start_date   <- min(date_val)
    start_int    <- lubridate::year(start_date)
    end_date     <- max(date_val)
    freq_var     <- as.integer(.frequency)

    # Make ts object
    ts_obj <- stats::ts(
        data        = x
        , start     = start_int
        , frequency = freq_var
    )

    m   <- as.integer(round(freq_var/2L, 0))
    har <- TSA::harmonic(ts_obj, m = m)
    harmonic_model    <- stats::lm(ts_obj ~ har)
    har_model_summary <- summary(harmonic_model)

    # * Variables ----
    dff  <- fft(x)
    n    <- as.integer(.harmonics)
    up   <- as.integer(.upsampling)
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

    maximum_harmonic_tbl <- data_tbl %>%
        dplyr::filter(harmonic == max(as.numeric(harmonic)))

    differenced_value_tbl <- tibble::as_tibble(diff(x))

    dff_tbl <- dff %>%
        tibble::as_tibble() %>%
        dplyr::rename(dff_trans = value) %>%
        dplyr::mutate(
            real_part = Re(dff_trans),
            imag_part = Im(dff_trans)
        )

    # * Plots ----
    harmonic_plt <- data_tbl %>%
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

    # Difference Plot
    diff_plt <- differenced_value_tbl %>%
        ggplot2::ggplot(aes(x = 1:nrow(differenced_value_tbl), y = value)) +
        ggplot2::geom_point() +
        ggplot2::geom_line() +
        ggplot2::labs(
            title = "Difference of Value Column"
            , x = "Time"
            , y = "Lag 1 Difference"
        ) +
        tidyquant::theme_tq()

    # Maximum Harmonic Plot
    max_har_plt <- data_tbl %>%
        dplyr::filter(as.numeric(harmonic) == max(as.numeric(harmonic))) %>%
        ggplot2::ggplot(ggplot2::aes(x = x, y = y_actual)) +
        ggplot2::geom_line() +
        ggplot2::geom_point() +
        ggplot2::geom_line(
            ggplot2::aes(
                x = time
                , y = y_hat
                , color = harmonic
            )
        ) +
        ggplot2::labs(
            title = paste0("Harmonic ", n, " Plot"),
            x = "Time",
            y = "Measurement"
        ) +
        tidyquant::theme_tq()

    # * Return ----
    output_list <- list(
        data = list(
            data                  = data_tbl,
            error_data            = error_term_tbl,
            input_vector          = x,
            maximum_harmonic_tbl  = maximum_harmonic_tbl,
            differenced_value_tbl = differenced_value_tbl,
            dff_tbl               = dff_tbl,
            ts_obj                = ts_obj
        ),
        plots = list(
            harmonic_plot   = harmonic_plt,
            diff_plt        = diff_plt,
            max_har_plt     = max_har_plt,
            harmonic_plotly = plotly::ggplotly(harmonic_plt),
            max_har_plotly  = plotly::ggplotly(max_har_plt)
        ),
        parameters = list(
            harmonics  = up,
            upsampling = n,
            start_date = start_date,
            end_date   = end_date,
            freq       = freq_var
        ),
        model = list(
            m              = m,
            harmonic_obj   = har,
            harmonic_model = harmonic_model,
            model_summary  = har_model_summary
        )
    )

    return(invisible(output_list))

}

a <- tidy_fft(
    .data = dat,
    .value_col = V1,
    .date_col = visit_end_date_time,
    .frequency = 12,
    .harmonics = 8,
    .upsampling = 100
)
