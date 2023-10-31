#' Compare Two Time Series Models
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description
#' This function will expect to take in two models that will be used for comparison.
#' It is useful to use this after appropriately following the modeltime workflow and
#' getting two models to compare. This is an extension of the calibrate and plot, but
#' it only takes two models and is most likely better suited to be used after running
#' a model through the `ts_model_auto_tune()` function to see the difference in performance
#' after a base model has been tuned.
#'
#' @details This function expects to take two models. You must tell it if it will
#' be assessing the training or testing data, where the testing data is the default.
#' You must therefore supply the splits object to this function along with the origianl
#' dataset. You must also tell it which default modeltime accuracy metric should
#' be printed on the graph itself. You can also tell this function to print
#' information to the console or not. A static `ggplot2` polot and an interactive
#' `plotly` plot will be returned inside of the output list.
#'
#' @param .model_1 The model being compared to the base, this can also be a
#' hyperparameter tuned model.
#' @param .model_2 The base model.
#' @param .type The default is the testing tibble, can be set to training as well.
#' @param .splits_obj The splits object
#' @param .data The original data that was passed to splits
#' @param .print_info This is a boolean, the default is TRUE
#' @param .metric This should be one of the following character strings:
#' -  "mae"
#' -  "mape"
#' -  "mase"
#' -  "smape"
#' -  "rmse"
#' -  "rsq"
#'
#' @examples
#' \dontrun{
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(rsample))
#' suppressPackageStartupMessages(library(dplyr))
#'
#' data_tbl <- ts_to_tbl(AirPassengers) %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'   data       = data_tbl,
#'   date_var   = date_col,
#'   assess     = "12 months",
#'   cumulative = TRUE
#' )
#'
#' rec_obj <- ts_auto_recipe(
#'  .data     = data_tbl,
#'  .date_col = date_col,
#'  .pred_col = value
#' )
#'
#' wfs_mars <- ts_wfs_mars(.recipe_list = rec_obj)
#'
#' wf_fits <- wfs_mars %>%
#'   modeltime_fit_workflowset(
#'     data = training(splits)
#'     , control = control_fit_workflowset(
#'          allow_par = FALSE
#'          , verbose = TRUE
#'        )
#'  )
#'
#' calibration_tbl <- wf_fits %>%
#'     modeltime_calibrate(new_data = testing(splits))
#'
#' base_mars <- calibration_tbl %>% pluck_modeltime_model(1)
#' date_mars <- calibration_tbl %>% pluck_modeltime_model(2)
#'
#' ts_model_compare(
#'  .model_1    = base_mars,
#'  .model_2    = date_mars,
#'  .type       = "testing",
#'  .splits_obj = splits,
#'  .data       = data_tbl,
#'  .print_info = TRUE,
#'  .metric     = "rmse"
#'  )$plots$static_plot
#' }
#'
#' @return
#' The function outputs a list invisibly.
#' @name ts_model_compare
NULL

#' @export ts_model_compare
#' @rdname ts_model_compare

ts_model_compare <- function(.model_1, .model_2, .type = "testing", .splits_obj
                             , .data, .print_info = TRUE, .metric = "rmse"){

    # Tidyeval ----
    splits_obj <- .splits_obj
    st_metric  <- as.character(tolower(.metric))

    # Checks ----
    if(!st_metric %in% c("mae","mape","mase","smape","rmse","rsq")){
        stop(call. = FALSE, ".subtitle_metric must be one of the following: 'mae','mape','mase','smpae','rmse','rsq")
    }

    # What data are we testing out?
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
    calibration_tbl <- modeltime::modeltime_table(.model_1, .model_2) %>%
        modeltime::modeltime_calibrate(new_data)

    # Make the model accuracy tibble
    model_accuracy_tbl <- calibration_tbl %>%
        modeltime::modeltime_accuracy()

    # Get the relative delta's between the new model and the old/base model
    rc_mae   <- (model_accuracy_tbl$mae[1] - model_accuracy_tbl$mae[2])/model_accuracy_tbl$mae[1]
    rc_mape  <- (model_accuracy_tbl$mape[1] - model_accuracy_tbl$mape[2])/model_accuracy_tbl$mape[1]
    rc_mase  <- (model_accuracy_tbl$mase[1] - model_accuracy_tbl$mase[2])/model_accuracy_tbl$mase[1]
    rc_smape <- (model_accuracy_tbl$smape[1] - model_accuracy_tbl$smape[2])/model_accuracy_tbl$smape[1]
    rc_rmse  <- (model_accuracy_tbl$rmse[1] - model_accuracy_tbl$rmse[2])/model_accuracy_tbl$rmse[1]
    rc_rsq   <- (model_accuracy_tbl$rsq[1] - model_accuracy_tbl$rsq[2])/model_accuracy_tbl$rsq[1]

    relative_delta_tbl <- tibble::tibble(
        .model_id   = 3L,
        .model_desc = 'Relative',
        .type       = 'Delta',
        mae         = as.double(rc_mae * 100.0),
        mape        = as.double(rc_mape * 100.0),
        mase        = as.double(rc_mase * 100.0),
        smape       = as.double(rc_smape * 100.0),
        rmse        = as.double(rc_rmse * 100.0),
        rsq         = as.double(rc_rsq * 100.0)
    )

    # Final model_accuracy_tbl binded with deltas
    model_accuracy_tbl <- model_accuracy_tbl %>%
        dplyr::bind_rows(relative_delta_tbl)

    # Se the metric_value var for the title
    metric_value <- if(st_metric == "mae"){
        relative_delta_tbl$mae
    } else if(st_metric == "mape"){
        relative_delta_tbl$mape
    } else if(st_metric == "mase"){
        relative_delta_tbl$mase
    } else if(st_metric == "smape"){
        relative_delta_tbl$smape
    } else if(st_metric == "rmse"){
        relative_delta_tbl$rmse
    } else {
        relative_delta_tbl$rsq
    }

    # Set the title metric_string
    metric_string <- base::paste0(
        "Model Metric Delta: ",
        base::toupper(st_metric),
        " ",
        base::round(metric_value, 2),
        "%"
    )

    # Make the plot caption
    caption_string <- base::paste0(
        "Metric Deltas: ",
        " MAE: ", round(relative_delta_tbl$mae,2), "%",
        " MAPE: ", round(relative_delta_tbl$mape,2), "%",
        " MASE: ", round(relative_delta_tbl$mase,2), "%",
        " SMAPE: ", round(relative_delta_tbl$smape,2), "%",
        " RMSE: ", round(relative_delta_tbl$rmse,2), "%",
        " RSQ: ", round(relative_delta_tbl$rsq,2), "%"
    )

    # A message that can be printed to the console
    model_message <- message(
        "Thew new model has the following metric improvements:",
        "\nMAE:   ", round(relative_delta_tbl$mae,2), "%", ifelse(relative_delta_tbl$mae < 0," - Excellent!"," - Bummer"),
        "\nMAPE:  ", round(relative_delta_tbl$mape,2), "%", ifelse(relative_delta_tbl$mape < 0," - Excellent!"," - Bummer"),
        "\nMASE:  ", round(relative_delta_tbl$mase,2), "%", ifelse(relative_delta_tbl$mase < 0," - Excellent!"," - Bummer"),
        "\nSMAPE: ", round(relative_delta_tbl$smape,2), "%", ifelse(relative_delta_tbl$smape < 0," - Excellent!"," - Bummer"),
        "\nRMSE:  ", round(relative_delta_tbl$rmse,2), "%", ifelse(relative_delta_tbl$rmse < 0," - Excellent!"," - Bummer"),
        "\nRSQ:   ", round(relative_delta_tbl$rsq,2), "%", ifelse(relative_delta_tbl$rsq > 0," - Excellent!"," - Bummer")
    )

    # The plot
    g <- calibration_tbl %>%
        modeltime::modeltime_forecast(
            new_data = new_data
            , actual_data = data
        ) %>%
        modeltime::plot_modeltime_forecast(
            .conf_interval_show = FALSE
            , .interactive = FALSE
        ) +
        ggplot2::labs(
            title    = base::paste0("Forecast Plot - ", metric_string),
            subtitle = "Redline Indicates New Model",
            caption  = caption_string
        ) +
        ggplot2::theme(
            plot.caption = ggplot2::element_text(face = "bold")
        )

    p <- plotly::ggplotly(g)

    # Return ----
    output <- list(
        data = list(
            calibration_tbl = calibration_tbl,
            model_accuracy  = model_accuracy_tbl
        ),
        plots = list(
            static_plot      = g,
            interactive_plot = p
        )
    )

    # Should we print?
    if(.print_info){
        print(model_accuracy_tbl)
        print(g)
        model_message
    }
    return(invisible(output))
}

