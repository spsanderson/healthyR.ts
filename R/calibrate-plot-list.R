#' Helper function - Calibrate and Plot
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is a helper function. It will take in a set of workflows and then
#' perform the [modeltime::modeltime_calibrate()] and [modeltime::plot_modeltime_forecast()].
#'
#' @details This function expects to take in workflows fitted with training data.
#'
#' @param ... The workflow(s) you want to add to the function.
#' @param .type Either the training(splits) or testing(splits) data.
#' @param .data The full data set.
#' @param .splits_obj The splits object.
#' @param .print_info The default is TRUE and will print out the calibration
#' accuracy tibble and the resulting plotly plot.
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(tidyverse))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(tidymodels))
#'
#' data <- healthyR_data %>%
#'  filter(ip_op_flag == "I") %>%
#'    select(visit_end_date_time) %>%
#'    rename(date_col = visit_end_date_time) %>%
#'    summarise_by_time(
#'        .date_var = date_col
#'        , .by     = "month"
#'        , value   = n()
#'   ) %>%
#'    filter_by_time(
#'        .date_var     = date_col
#'        , .start_date = "2012"
#'        , .end_date   = "2019"
#'    )
#'
#' splits <- time_series_split(
#'    data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' rec_obj <- recipe(value ~ ., data = training(splits))
#'
#' model_spec <- linear_reg(
#'    mode = "regression"
#'    , penalty = 0.1
#'    , mixture = 0.5
#' ) %>%
#'    set_engine("lm")
#'
#' wflw <- workflow() %>%
#'    add_recipe(rec_obj) %>%
#'    add_model(model_spec) %>%
#'    fit(training(splits))
#'
#' calibrate_and_plot(
#'   wflw
#'   , .type = "training"
#'   , .splits_obj = splits
#'   , .data = data
#'  )
#'
#' calibrate_and_plot(
#'   wflw
#'   , .type        = "testing"
#'   , .splits_obj = splits
#'   , .data       = data
#' )
#'
#' @return
#' The original time series, the simulated values and a some plots
#'
#' @export calibrate_and_plot

# *** PLOTTING UTILITY *** ----
# - Calibrate & Plot
calibrate_and_plot <- function(..., .type = "testing", .splits_obj
                               , .data, .print_info = TRUE){

    # Tidyeval ----
    splits_obj <- .splits_obj

    # Checks ----
    if(.type == "testing"){
        new_data = rsample::testing(splits_obj)
    } else {
        new_data = rsample::training(splits_obj) %>%
            tidyr::drop_na()
    }

    if(!is.data.frame(.data)){
        stop(call. = FALSE, "(.data) is missing or is not a data.frame/tibble, please supply.")
    }

    if(!class(splits_obj)[[1]] == "ts_cv_split") {
        if(!class(splits_obj)[[2]] == "rsplit") {
            stop(call. = FALSE, ("(.splits) is missing or is not an rsplit or ts_cv_split. Please supply."))
        }
        stop(call. = FALSE, ("(.splits) is missing or is not a rsplit or ts_cv_split. Please supply."))
    }

    # Data
    data <- .data

    # Calibration Tibble
    calibration_tbl <- modeltime::modeltime_table(...) %>%
        modeltime::modeltime_calibrate(new_data)

    model_accuracy_tbl <- calibration_tbl %>%
        modeltime::modeltime_accuracy()

    plt <- calibration_tbl %>%
        modeltime::modeltime_forecast(
            new_data = new_data
            , actual_data = data
        ) %>%
        modeltime::plot_modeltime_forecast(
            .conf_interval_show = FALSE
        )

    output <- list(
        calibration_tbl = calibration_tbl,
        model_accuracy  = model_accuracy_tbl,
        plot            = plt
    )

    # Should we print?
    if(.print_info){
        print(model_accuracy_tbl)
        plt
    }

    return(output)
}