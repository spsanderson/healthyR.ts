#' Time Series Model QQ Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Plot
#' @family Utility
#'
#' @description This takes in a calibration tibble and will produce a QQ plot.
#'
#' @details
#' This takes in a calibration tibble and will create a QQ plot. You can also
#' pass in a `model_id` and a boolean for `interactive` which will return a
#' `plotly::ggplotly` interactive plot.
#'
#' @param .calibration_tbl A calibrated modeltime table.
#' @param .model_id The id of a particular model from a calibration tibble. If
#' there are multiple models in the tibble and this remains __NULL__ then the
#' plot will be returned using `ggplot2::facet_grid(~ .model_id)`
#' @param .interactive A boolean with a default value of FALSE. TRUE will produce
#' an interactive `plotly` plot.
#'
#' @seealso
#' \url{https://en.wikipedia.org/wiki/Q%E2%80%93Q_plot}
#'
#' @examples
#' # NOT RUN
#' \dontrun{
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(rsample))
#' suppressPackageStartupMessages(library(workflows))
#' suppressPackageStartupMessages(library(parsnip))
#' suppressPackageStartupMessages(library(recipes))
#'
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'   data_tbl,
#'   date_var = date_col,
#'   assess = "12 months",
#'   cumulative = TRUE
#' )
#'
#' rec_obj <- recipe(value ~ ., training(splits))
#'
#' model_spec_arima <- arima_reg() %>%
#'   set_engine(engine = "auto_arima")
#'
#' model_spec_mars <- mars(mode = "regression") %>%
#'   set_engine("earth")
#'
#' wflw_fit_arima <- workflow() %>%
#'   add_recipe(rec_obj) %>%
#'   add_model(model_spec_arima) %>%
#'   fit(training(splits))
#'
#' wflw_fit_mars <- workflow() %>%
#'   add_recipe(rec_obj) %>%
#'   add_model(model_spec_mars) %>%
#'   fit(training(splits))
#'
#' model_tbl <- modeltime_table(wflw_fit_arima, wflw_fit_mars)
#'
#' calibration_tbl <- model_tbl %>%
#'   modeltime_calibrate(new_data = testing(splits))
#'
#' ts_qq_plot(calibration_tbl)
#'
#' }
#'
#' @return
#' A QQ plot.
#'
#' @name ts_qq_plot
NULL

#' @export
#' @rdname ts_qq_plot

ts_qq_plot <- function(.calibration_tbl, .model_id = NULL
                       , .interactive = FALSE){

    # * Tidyeval ----
    calibration_tbl  <- .calibration_tbl
    model_id         <- .model_id
    interactive_bool <- .interactive

    # * Checks ----
    if(!modeltime::is_calibrated(calibration_tbl)){
        stop(call. = FALSE, "You must supply a calibrated modeltime table.")
    }

    # Calibration Tibble filter
    if(is.null(model_id)){
        calibration_tbl <- calibration_tbl
    } else {
        calibration_tbl <- calibration_tbl %>%
            dplyr::filter(.model_id == model_id)
    }

    g <- calibration_tbl %>%
        dplyr::ungroup() %>%
        dplyr::select(-.model, -.type) %>%
        tidyr::unnest(.calibration_data) %>%
        ggplot2::ggplot(
            mapping = ggplot2::aes(
                sample = .residuals
                , color = .model_desc
            )
        ) +
        ggplot2::stat_qq(alpha = 0.328, color = "black") +
        ggplot2::stat_qq_line() +
        ggplot2::facet_wrap(
            ~ .model_desc
            , scales = "free"
        ) +
        ggplot2::theme_minimal() +
        ggplot2::theme(legend.position = "none") +
        ggplot2::labs(
            title = "QQ Scatter Plot"
            , x = "Theoretical Quantiles"
            , y = "Sample Quantiles"
        )

    if(interactive_bool){
        g <- plotly::ggplotly(g)
    }

    return(g)

}
