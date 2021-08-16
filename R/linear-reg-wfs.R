#' Linear Regression Workflowset Function
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
#'
#' @return
#' Returns a workflowsets object.
#'

linear_reg_wfs <- function(.model_type, .recipe_list, .penalty = 1, .mixture = 0.5){

    # * Tidyeval ---
    model_type  = .model_type
    recipe_list = .recipe_list

    # * Checks ----
    if (!is.character(.model_type)) {
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


    # * Workflow Sets ----


    # * Return ---
    print(model_type)
    return(recipe_list)

}

