#' Model Rank
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description This takes in a calibration tibble and computes the ranks of the
#' models inside of it.
#'
#' @details
#' This takes in a calibration tibble and computes the ranks of the models inside
#' of it. It computes for now only the default `yardstick` metrics from `modeltime`
#' These are the following using the `dplyr` `min_rank()` function with `desc` use
#' on `rsq`:
#' -  "rmse"
#' -  "mae"
#' -  "mape"
#' -  "smape"
#' -  "rsq"
#'
#' @param .calibration_tbl A calibrated modeltime table.
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
#' ts_model_rank_tbl(calibration_tbl)
#'
#' }
#'
#' @return
#' A tibble with models ranked by metric performance order
#'
#' @export
#'

ts_model_rank_tbl <- function(.calibration_tbl){

    calibration_tbl <- .calibration_tbl

    if(!modeltime::is_calibrated(calibration_tbl)){
        stop(call. = FALSE, "You must supply a calibrated modeltime table.")
    }

    model_rank_tbl <- calibration_tbl %>%
        modeltime::modeltime_accuracy() %>%
        base::as.data.frame() %>%
        dplyr::mutate(
            mae_rank = dplyr::min_rank(`mae`),
            mape_rank = dplyr::min_rank(`mape`),
            mase_rank = dplyr::min_rank(`mase`),
            smape_rank = dplyr::min_rank(`smape`),
            rmse_rank = dplyr::min_rank(`rmse`),
            rsq_rank = dplyr::min_rank(dplyr::desc(`rsq`))
        ) %>%
        dplyr::mutate(
            model_score = base::rowSums(
                dplyr::across(.cols = dplyr::contains("_rank"))
            )
        ) %>%
        dplyr::arrange(model_score) %>%
        dplyr::select(-dplyr::contains("_rank")) %>%
        dplyr::as_tibble()

    # * Return ----
    return(model_rank_tbl)

}
