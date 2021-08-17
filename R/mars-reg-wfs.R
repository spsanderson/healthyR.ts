#' MARS (Earth) Workflowset Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://parsnip.tidymodels.org/reference/mars.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This only uses the option `set_engine("earth")` and therefore the .model_type
#' is not needed. The parameter is kept because it is possible in the future that
#' this could change, and it keeps with the framework of how other frunctions
#' are written.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [parsnip::mars()] under the hood and can take one of the following:
#'   * "earth"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .num_terms The number of features that will be retained in the final
#' model, including the intercept.
#' @param .prod_degree The highest possible interaction degree.
#' @param .prune_method The pruning method. This is a character, the default is
#' "backward". You can choose from one of the following:
#'   * "backward"
#'   * "none"
#'   * "exhaustive"
#'   * "forward"
#'   * "seqrep"
#'   * "cv"
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
#' rec_objs <- ts_auto_recipe(
#'  .data = training(splits)
#'  , .date_col = date_col
#'  , .pred_col = value
#' )
#'
#' wf_sets <- ts_wfs_mars("all_engines", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_mars <- function(.model_type = "earth", .recipe_list,
                           .num_terms = 200, .prod_degree = 1,
                           .prune_method = "backward"){

    # * Tidyeval ---
    model_type   = .model_type
    recipe_list  = .recipe_list
    prune_method = .prune_method
    num_terms    = .num_terms
    prod_degree  = .prod_degree

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be set to a character string.")
    }

    if (!is.character(prune_method)){
        stop(call. = FALSE, "(.prune_method) must be set to a character string.")
    }

    if (!model_type %in% c("earth")){
        stop(call. = FALSE, "(.model_type) must be 'earth'.")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    if (!prune_method %in% c("backward","none","exhaustive","forward","seqrep","cv")){
        stop(call. = FALSE, "(.prune_method) must be set to either 'backward','none','exhaustive'
             'forward','seqrep', or 'cv'")
    }

    if (!is.numeric(num_terms) | !is.numeric(prod_degree)){
        stop(call. = FALSE, "Both the .num_terms and .prod-degree parameters must be numeric.")
    }

    # * Models ----
    model_spec_mars <- parsnip::mars(
        mode         = "regression",
        num_terms    = num_terms,
        prod_degree  = prod_degree,
        prune_method = prune_method
    ) %>%
        parsnip::set_engine("earth")

    final_model_list <- list(
            model_spec_mars
        )

    # * Workflow Sets ----
    wf_sets <- workflowsets::workflow_set(
        preproc = recipe_list,
        models  = final_model_list,
        cross   = TRUE
    )

    # * Return ---
    return(wf_sets)

}

