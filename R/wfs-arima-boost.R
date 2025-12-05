#' Auto Arima XGBoost Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://business-science.github.io/modeltime/reference/arima_boost.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This uses the option `set_engine("auto_arima_xgboost")` or `set_engine("arima_xgboost")`
#'
#' [modeltime::arima_boost()] arima_boost() is a way to generate a specification
#' of a time series model that uses boosting to improve modeling errors
#' (residuals) on Exogenous Regressors. It works with both "automated" ARIMA
#' (auto.arima) and standard ARIMA (arima). The main algorithms are:
#' -  Auto ARIMA + XGBoost Errors (engine = auto_arima_xgboost, default)
#' -  ARIMA + XGBoost Errors (engine = arima_xgboost)
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::arima_boost()] under the hood and can take one of the following:
#'   * "arima_xgboost"
#'   * "auto_arima_xgboost
#'   * "all_engines" - This will make a model spec for all available engines.
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .seasonal_period Set to 0,
#' @param .non_seasonal_ar Set to 0,
#' @param .non_seasonal_differences Set to 0,
#' @param .non_seasonal_ma Set to 0,
#' @param .seasonal_ar Set to 0,
#' @param .seasonal_differences Set to 0,
#' @param .seasonal_ma Set to 0,
#' @param .trees An integer for the number of trees contained in the ensemble.
#' @param .min_node An integer for the minimum number of data points in a node
#' that is required for the node to be split further.
#' @param .tree_depth An integer for the maximum depth of the tree
#' (i.e. number of splits) (specific engines only).
#' @param .learn_rate A number for the rate at which the boosting algorithm
#' adapts from iteration-to-iteration (specific engines only).
#' @param .stop_iter The number of iterations without improvement before
#' stopping (xgboost only).
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(rsample))
#'
#' data <- AirPassengers %>%
#'   ts_to_tbl() %>%
#'   select(-index)
#'
#' splits <- time_series_split(
#'    data
#'   , date_col
#'   , assess = 12
#'   , skip = 3
#'   , cumulative = TRUE
#' )
#'
#' rec_objs <- ts_auto_recipe(
#'  .data = training(splits)
#'  , .date_col = date_col
#'  , .pred_col = value
#' )
#'
#' wf_sets <- ts_wfs_arima_boost("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @name ts_wfs_arima_boost
NULL

#' @export
#' @rdname ts_wfs_arima_boost

ts_wfs_arima_boost <- function(.model_type = "all_engines", .recipe_list,
                               .trees = 10, .min_node = 2, .tree_depth = 6,
                               .learn_rate = 0.015,
                               .stop_iter = NULL, .seasonal_period = 0,
                               .non_seasonal_ar = 0,
                               .non_seasonal_differences = 0,
                               .non_seasonal_ma = 0,
                               .seasonal_ar = 0,
                               .seasonal_differences = 0,
                               .seasonal_ma = 0){

    # * Tidyeval ---
    model_type               = .model_type
    recipe_list              = .recipe_list
    seasonal_period          = .seasonal_period
    non_seasonal_ar          = .non_seasonal_ar
    non_seasonal_differences = .non_seasonal_differences
    non_seasonal_ma          = .non_seasonal_ma
    seasonal_ar              = .seasonal_ar
    seasonal_differences     = .seasonal_differences
    seasonal_ma              = .seasonal_ma
    trees                    = .trees
    min_n                    = .min_node
    tree_depth               = .tree_depth
    learn_rate               = .learn_rate
    stop_iter                = .stop_iter

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be set to a character string.")
    }

    if (!model_type %in% c("arima_xgboost","auto_arima_xgboost","all_engines")){
        stop(call. = FALSE, "(.model_type) must be 'arima_xgboost','auto_arima_xgboost', or 'all_engines'.")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    # * Models ----
    model_spec_arima_boost <- modeltime::arima_boost(
        mode = "regression",

        # ARIMA args
        seasonal_period          = seasonal_period,
        non_seasonal_ar          = non_seasonal_ar,
        non_seasonal_differences = non_seasonal_differences,
        non_seasonal_ma          = non_seasonal_ma,
        seasonal_ar              = seasonal_ar,
        seasonal_differences     = seasonal_differences,
        seasonal_ma              = seasonal_ma,

        # XGBoost Args
        trees                    = trees,
        min_n                    = min_n,
        tree_depth               = tree_depth,
        learn_rate               = learn_rate,
        stop_iter                = stop_iter
    ) %>%
        parsnip::set_engine("arima_xgboost", objective = "reg:squarederror")

    model_sepc_auto_arima_boost <- modeltime::arima_boost(
        mode = "regression",

        # XGBoost Args
        trees                    = trees,
        min_n                    = min_n,
        tree_depth               = tree_depth,
        learn_rate               = learn_rate,
        stop_iter                = stop_iter
    ) %>%
        parsnip::set_engine("auto_arima_xgboost", objective = "reg:squarederror")

    final_model_list <- if (model_type == "arima_xgboost"){
        fml <- list(model_spec_arima_boost)
    } else if (model_type == "auto_arima_xgboost"){
        fml <- list(model_sepc_auto_arima_boost)
    } else {
        fml <- list(
            model_spec_arima_boost,
            model_sepc_auto_arima_boost
        )
    }

    # * Workflow Sets ----
    wf_sets <- workflowsets::workflow_set(
        preproc = recipe_list,
        models  = final_model_list,
        cross   = TRUE
    )

    # * Return ---
    return(wf_sets)

}


