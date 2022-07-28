#' Boilerplate Workflow
#'
#' @family Boiler_Plate
#' @family lm
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This uses `parsnip::linear_reg()` and sets the `engine` to `lm`
#'
#' @seealso \url{https://parsnip.tidymodels.org/reference/linear_reg.html}
#'
#' @description This is a boilerplate function to create automatically the following:
#' -  recipe
#' -  model specification
#' -  workflow
#' -  calibration tibble and plot
#'
#' @param .data The data being passed to the function. The time-series object.
#' @param .date_col The column that holds the datetime.
#' @param .value_col The column that has the value
#' @param .formula The formula that is passed to the recipe like `value ~ .`
#' @param .rsamp_obj The rsample splits object
#' @param .prefix Default is `ts_glmnet`
#' @param .cv_assess How many observations for assess. See [timetk::time_series_cv()]
#' @param .cv_skip How many observations to skip. See [timetk::time_series_cv()]
#' @param .cv_slice_limit How many slices to return. See [timetk::time_series_cv()]
#' @param .best_metric Default is "rmse". See [modeltime::default_forecast_accuracy_metric_set()]
#' @param .bootstrap_final Not yet implemented.
#'
#' @examples
#' \dontrun{
#' library(dplyr)
#'
#' data <- AirPassengers %>%
#'   ts_to_tbl() %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'   data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' ts_lm <- ts_auto_lm(
#'   .data = data,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .rsamp_obj = splits,
#'   .formula = value ~ .,
#' )
#'
#' ts_lm$recipe_info
#' }
#'
#' @return
#' A list
#'
#' @export
#'

ts_auto_lm <- function(.data, .date_col, .value_col, .formula, .rsamp_obj,
                       .prefix = "ts_lm", .cv_assess = 12, .cv_skip = 3,
                       .cv_slice_limit = 6, .best_metric = "rmse",
                       .bootstrap_final = FALSE){

    # Tidyeval ----
    date_col_var_expr <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)
    sampling_object <- .rsamp_obj

    # Cross Validation
    cv_assess = as.numeric(.cv_assess)
    cv_skip   = as.numeric(.cv_skip)
    cv_slice  = as.numeric(.cv_slice_limit)

    # Data and splits
    splits <- .rsamp_obj
    data_tbl <- dplyr::as_tibble(.data)

    # Checks ----
    if (rlang::quo_is_missing(date_col_var_expr)){
        rlang::abort(
            message = "'.date_col' must be supplied.",
            use_cli_format = TRUE
        )
    }

    if (rlang::quo_is_missing(value_col_var_expr)){
        rlang::abort(
            message = "'.value_col' must be supplied.",
            use_cli_format = TRUE
        )
    }

    if (!inherits(x = splits, what = "rsplit")){
        rlang::abort(
            message = "'.rsamp_obj' must be have class rsplit, use the rsample package.",
            use_cli_format = TRUE
        )
    }

    # Recipe ----
    # Get the initial recipe call
    recipe_call <- get_recipe_call(match.call())

    rec_syntax <- paste0(.prefix, "_recipe") %>%
        assign_value(!!recipe_call)

    rec_obj <- recipes::recipe(formula = .formula, data = data_tbl)

    rec_obj <- rec_obj %>%
        timetk::step_timeseries_signature({{date_col_var_expr}}) %>%
        timetk::step_holiday_signature({{date_col_var_expr}}) %>%
        recipes::step_novel(recipes::all_nominal_predictors()) %>%
        recipes::step_mutate_at(tidyselect::vars_select_helpers$where(is.character)
                                , fn = ~ as.factor(.)) %>%
        recipes::step_mutate({{date_col_var_expr}} := as.numeric({{date_col_var_expr}})) %>%
        #recipes::step_rm({{date_col_var_expr}}) %>%
        recipes::step_dummy(recipes::all_nominal(), one_hot = TRUE) %>%
        recipes::step_nzv(recipes::all_predictors(), -date_col_index.num) %>%
        recipes::step_normalize(recipes::all_numeric_predictors(), -date_col_index.num) %>%
        recipes::step_corr(recipes::all_numeric_predictors()) %>%
        recipes::step_lincomb(recipes::all_numeric_predictors())

    # Model Specification ----
    model_spec <- parsnip::linear_reg(
        mode   = "regression",
        engine = "lm"
    )

    # Workflow ----
    wflw <- workflows::workflow() %>%
        workflows::add_recipe(rec_obj) %>%
        workflows::add_model(model_spec)

    wflw_fit <- wflw %>%
        parsnip::fit(rsample::training(splits))

    # Calibrate and Plot ----
    cap <- healthyR.ts::calibrate_and_plot(
        wflw_fit,
        .splits_obj  = splits,
        .data        = data_tbl,
        .interactive = TRUE,
        .print_info  = FALSE
    )

    # Return ----
    output <- list(
        recipe_info = list(
            recipe_call   = recipe_call,
            recipe_syntax = rec_syntax,
            rec_obj       = rec_obj
        ),
        model_info = list(
            model_spec  = model_spec,
            wflw        = wflw,
            fitted_wflw = wflw_fit,
            was_tuned   = "not_tuned"
        ),
        model_calibration = list(
            plot = cap$plot,
            calibration_tbl = cap$calibration_tbl,
            model_accuracy = cap$model_accuracy
        )
    )

    # Add attributes
    attr(output, ".tune") <- "not_tuned"
    attr(output, ".grid_size") <- .grid_size
    attr(output, ".cv_assess") <- .cv_assess
    attr(output, ".cv_skip") <- .cv_skip
    attr(output, ".cv_slice_limit") <- .cv_slice_limit
    attr(output, ".best_metric") <- .best_metric
    attr(output, ".bootstrap_final") <- .bootstrap_final
    attr(output, ".mode") <- "regression"
    attr(output, ".parsnip_engine") <- "lm"
    attr(output, ".function_family") <- "boilerplate"

    return(invisible(output))
}
