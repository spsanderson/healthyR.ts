#' Auto XGBoost (XGBoost) Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://parsnip.tidymodels.org/reference/details_boost_tree_xgboost.html}
#' @seealso \url{https://arxiv.org/abs/1603.02754}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This only uses the option `set_engine("xgboost")` and therefore the .model_type
#' is not needed. The parameter is kept because it is possible in the future that
#' this could change, and it keeps with the framework of how other functions
#' are written.
#'
#' [parsnip::boost_tree()] xgboost::xgb.train() creates a series of decision trees
#' forming an ensemble. Each tree depends on the results of previous trees.
#' All trees in the ensemble are combined to produce a final prediction.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [parsnip::boost_tree] under the hood and can take one of the following:
#'   * "xgboost"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .tree_depth Tree Depth (type: integer, default: 6L)
#' @param .trees The number of trees (type: integer, default: 15L)
#' @param .learn_rate Learning Rate (type: double, default: 0.3)
#' @param .min_n Minimal Node Size (type: integer, default: 1L)
#' @param .loss_reduction Minimum Loss Reduction (type: double, default: 0.0)
#' @param .sample_size Proportion Observations Sampled (type: double, default: 1.0)
#' @param .stop_iter The number of ierations Before Stopping (type: integer, default: Inf)
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
#' wf_sets <- ts_wfs_xgboost("xgboost", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @name ts_wfs_xgboost
NULL

#' @export
#' @rdname ts_wfs_xgboost

ts_wfs_xgboost <- function(.model_type = "xgboost", .recipe_list,
                           .trees = 15L, .min_n = 1L, .tree_depth = 6L,
                           .learn_rate = 0.3, .loss_reduction = 0.0,
                           .sample_size = 1.0, .stop_iter = Inf){

    # * Tidyeval ---
    model_type = .model_type
    recipe_list = .recipe_list
    trees = .trees
    min_n = .min_n
    tree_depth = .tree_depth
    learn_rate = .learn_rate
    loss_reduction = .loss_reduction
    sample_size = .sample_size
    stop_iter = .stop_iter

    # * Checks ---
    if (!is.character(model_type)) {
        rlang::abort(
            message = ".model_type must be a character string.",
            use_cli_format = TRUE
        )
    }

    if (!model_type %in% c("xgboost")){
        rlang::abort(
            message = ".model_type must be 'xgboost'.",
            use_cli_format = TRUE
        )
    }

    if (!is.list(recipe_list)){
        rlang::abort(
            message = ".recipe_list must be a list of recipe objects.",
            use_cli_format = TRUE
        )
    }

    # * Models ----
    model_spec_xgboost <- parsnip::boost_tree(
        mode = "regression",
        tree_depth = tree_depth,
        trees = trees,
        learn_rate = learn_rate,
        min_n = min_n,
        loss_reduction = loss_reduction,
        sample_size = sample_size,
        stop_iter = stop_iter
    ) %>%
        parsnip::set_engine("xgboost", objective = "reg:squarederror")

    final_model_list <- if (model_type == "xgboost"){
        fml <- list(model_spec_xgboost)
    }

    # * Workflow Sets ----
    wf_sets <- workflowsets::workflow_set(
        preproc = recipe_list,
        models = final_model_list,
        cross = TRUE
    )

    # * Return ----
    return(wf_sets)

}
