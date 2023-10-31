#' Auto Linear Regression Workflowset Function
#'
#' @family Auto Workflowsets
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}(workflowsets)
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the `glmnet` model specification, but if you choose you can
#' set them yourself if you have a good understanding of what they should be.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [parsnip::linear_reg()] under the hood and can take one of the following:
#'   * "lm"
#'   * "glmnet"
#'   * "all_engines" - This will make a model spec for all available engines.
#'
#' Not yet implemented are:
#'   * "stan"
#'   * "spark"
#'   * "keras"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .penalty The penalty parameter of the glmnet. The default is 1
#' @param .mixture The mixture parameter of the glmnet. The default is 0.5
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
#' wf_sets <- ts_wfs_lin_reg("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @name ts_wfs_lin_reg
NULL

#' @export
#' @rdname ts_wfs_lin_reg

ts_wfs_lin_reg <- function(.model_type, .recipe_list, .penalty = 1, .mixture = 0.5){

    # * Tidyeval ---
    model_type  = .model_type
    recipe_list = .recipe_list

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
    model_spec_lm <- parsnip::linear_reg(
        mode = "regression"
    ) %>%
        parsnip::set_engine("lm")

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

