#' Auto PROPHET Regression Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}(workflowsets)
#' @seealso \url{https://business-science.github.io/modeltime/reference/prophet_reg.html}
#' @seealso \url{https://business-science.github.io/modeltime/reference/prophet_boost.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the `prophet` and `prophet_xgboost` model specification,
#' but if you choose you can set them yourself if you have a good understanding
#' of what they should be.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [modeltime::prophet_boost()] under the hood and can take one of the following:
#'   * "prophet"
#'   * "prophet_xgboost"
#'   * "all_engines" - This will make a model spec for all available engines.
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .growth String 'linear' or 'logistic' to specify a linear or logistic trend.
#' @param .changepoint_num Number of potential changepoints to include for modeling trend.
#' @param .changepoint_range Adjusts the flexibility of the trend component by
#' limiting to a percentage of data before the end of the time series. 0.80
#' means that a changepoint cannot exist after the first 80% of the data.
#' @param .seasonality_yearly One of "auto", TRUE or FALSE. Set to FALSE for `prophet_xgboost`.
#' Toggles on/off a seasonal component that models year-over-year seasonality.
#' @param .seasonality_weekly One of "auto", TRUE or FALSE. Toggles on/off a
#' seasonal component that models week-over-week seasonality. Set to FALSE for `prophet_xgboost`
#' @param .seasonality_daily One of "auto", TRUE or FALSE. Toggles on/off a
#' seasonal componet that models day-over-day seasonality. Set to FALSE for `prophet_xgboost`
#' @param .season 'additive' (default) or 'multiplicative'.
#' @param .prior_scale_changepoints Parameter modulating the flexibility of the
#' automatic changepoint selection. Large values will allow many changepoints,
#' small values will allow few changepoints.
#' @param .prior_scale_seasonality Parameter modulating the strength of the
#' seasonality model. Larger values allow the model to fit larger seasonal
#' fluctuations, smaller values dampen the seasonality.
#' @param .prior_scale_holidays Parameter modulating the strength of the holiday
#' components model, unless overridden in the holidays input.
#' @param .logistic_cap When growth is logistic, the upper-bound for "saturation".
#' @param .logistic_floor When growth is logistic, the lower-bound for "saturation"
#' @param .trees An integer for the number of trees contained in the ensemble.
#' @param .min_n An integer for the minimum number of data points in a node
#' that is required for the node to be split further.
#' @param .tree_depth An integer for the maximum depth of the tree
#' (i.e. number of splits) (specific engines only).
#' @param .learn_rate A number for the rate at which the boosting algorithm
#' adapts from iteration-to-iteration (specific engines only).
#' @param .loss_reduction A number for the reduction in the loss function
#' required to split further (specific engines only).
#' @param .stop_iter The number of iterations without improvement before
#' stopping (xgboost only).
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(tidymodels))
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
#' wf_sets <- ts_wfs_prophet_reg("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_prophet_reg <- function(.model_type = "all_engines",
                               .recipe_list,
                               .growth = NULL,
                               .changepoint_num = 25,
                               .changepoint_range = 0.8,
                               .seasonality_yearly = "auto",
                               .seasonality_weekly = "auto",
                               .seasonality_daily = "auto",
                               .season = "additive",
                               .prior_scale_changepoints = 25,
                               .prior_scale_seasonality = 1,
                               .prior_scale_holidays = 1,
                               .logistic_cap = NULL,
                               .logistic_floor = NULL,
                               .trees = 50,
                               .min_n = 10,
                               .tree_depth = 5,
                               .learn_rate = 0.01,
                               .loss_reduction = NULL,
                               .stop_iter = NULL
){

    # * Tidyeval ---
    model_type  = .model_type
    recipe_list = .recipe_list
    growth      = .growth
    changepoint_num = .changepoint_num
    changepoint_range = .changepoint_range
    seasonality_yearly = .seasonality_yearly
    seasonality_weekly = .seasonality_weekly
    seasonality_daily = .seasonality_daily
    season = .season
    prior_scale_changepoints = .prior_scale_changepoints
    prior_scale_seasonality = .prior_scale_seasonality
    prior_scale_holidays = .prior_scale_holidays
    logistic_cap = .logistic_cap
    logistic_floor = .logistic_floor
    trees = .trees
    min_n = .min_n
    tree_depth = .tree_depth
    learn_rate = .learn_rate
    loss_reduction = .loss_reduction
    stop_iter = .stop_iter

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be a character like 'lm', 'glmnet'")
    }

    if (!model_type %in% c("lm","glmnet","all_engines")){
        stop(call. = FALSE, "(.model_type) must be one of the following, 'lm','glmnet', or 'all_engines'")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    if (!is.numeric(.penalty) | !is.numeric(.mixture)){
        stop(call. = FALSE, "Both the .penalty and .mixture parameters must be numeric.")
    }

    # * Models ----
    model_spec_prophet <- modeltime::prophet_reg(
        changepoint_num      = tune::tune()
        , changepoint_range  = tune::tune()
        , seasonality_yearly = "auto"
        , seasonality_weekly = "auto"
        , seasonality_daily  = "auto"
        , prior_scale_changepoints = tune::tune()
        , prior_scale_seasonality  = tune::tune()
        , prior_scale_holidays     = tune::tune()
    ) %>%
        parsnip::set_engine(pe)

    model_spec_glmnet <- parsnip::linear_reg(
        mode    = "regression",
        penalty = .penalty,
        mixture = .mixture
    ) %>%
        parsnip::set_engine("glmnet")

    final_model_list <- if (model_type == "lm"){
        fml <- list(model_spec_lm)
    } else if (model_type == "glmnet"){
        fml <- list(model_spec_glmnet)
    } else {
        fml <- list(
            model_spec_lm,
            model_spec_glmnet
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

