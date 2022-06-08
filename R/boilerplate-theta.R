#' Boilerplate Workflow
#'
#' @family Boiler_Plate
#' @family exp_smoothing
#' @family theta
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @details This uses the `forecast::thetaf()` for the `parsnip` engine. This
#' model does not use exogenous regressors, so only a univariate model of: value ~ date
#' will be used from the `.date_col` and `.value_col` that you provide.
#'
#' @seealso \url{https://business-science.github.io/modeltime/reference/exp_smoothing.html#engine-details}
#' @seealso \url{https://pkg.robjhyndman.com/forecast/reference/thetaf.html}
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
#' @param .rsamp_obj The splits object
#' @param .prefix Default is `ts_theta`
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
#' ts_theta <- ts_auto_theta(
#'   .data = data,
#'   .date_col = date_col,
#'   .value_col = value,
#'   .rsamp_obj = splits
#' )
#'
#' ts_theta$recipe_info
#' }
#'
#' @return
#' A list
#'
#' @export
#'

ts_auto_theta <- function(.data, .date_col, .value_col, .rsamp_obj,
                          .prefix = "ts_theta", .bootstrap_final = FALSE){

    # Tidyeval ----
    date_col_var_expr <- rlang::enquo(.date_col)
    value_col_var_expr <- rlang::enquo(.value_col)

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
    data_tbl <- data_tbl %>%
        dplyr::select(
            {{ date_col_var_expr }}
            , {{ value_col_var_expr }}
            , dplyr::everything()
        )

    # * Orignal Cols and formula ----
    ds <- rlang::sym(base::names(data_tbl)[[1]])
    v  <- rlang::sym(base::names(data_tbl)[[2]])
    f  <- stats::as.formula(base::paste(v, " ~ ."))

    recipe_call <- get_recipe_call(match.call())

    rec_syntax <- paste0(.prefix, "_recipe") %>%
        assign_value(!!recipe_call)

    rec_obj <- recipes::recipe(formula = f, data = data_tbl)

    # Tune/Spec ----
    model_spec <- modeltime::exp_smoothing(
        seasonal_period = "auto"
    ) %>%
        parsnip::set_mode(mode = "regression") %>%
        parsnip::set_engine("theta")

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

    return(invisible(output))
}
