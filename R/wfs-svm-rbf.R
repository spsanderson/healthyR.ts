#' SVM Poly (Kernlab) Workflowset Function
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @description
#' This function is used to quickly create a workflowsets object.
#'
#' @seealso \url{https://workflowsets.tidymodels.org/}
#' @seealso \url{https://parsnip.tidymodels.org/reference/svm_poly.html}
#'
#' @details This function expects to take in the recipes that you want to use in
#' the modeling process. This is an automated workflow process. There are sensible
#' defaults set for the model specification, but if you choose you can set them
#' yourself if you have a good understanding of what they should be. The mode is
#' set to "regression".
#'
#' This only uses the option `set_engine("kernlab")` and therefore the .model_type
#' is not needed. The parameter is kept because it is possible in the future that
#' this could change, and it keeps with the framework of how other functions
#' are written.
#'
#' [parsnip::svm_poly()] svm_poly() defines a support vector machine model.
#' For classification, the model tries to maximize the width of the margin
#' between classes. For regression, the model optimizes a robust loss function
#' that is only affected by very large model residuals.
#'
#' This SVM model uses a nonlinear function, specifically a polynomial function,
#' to create the decision boundary or regression line.
#'
#' @param .model_type This is where you will set your engine. It uses
#' [parsnip::svm_poly()] under the hood and can take one of the following:
#'   * "kernlab"
#' @param .recipe_list You must supply a list of recipes. list(rec_1, rec_2, ...)
#' @param .cost A positive number for the cose of predicting a sample within or
#' on the wrong side of the margin.
#' @param .degree A positive number for polynomial degree.
#' @param .scale_factor A positive number for the polynomial scaling factor.
#' @param .margin A positive number for the epsilon in the SVM insensitive loss
#' function (regression only.)
#'
#' @examples
#' suppressPackageStartupMessages(library(modeltime))
#' suppressPackageStartupMessages(library(timetk))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(tidymodels))
#' suppressPackageStartupMessages(library(earth))
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
#' wf_sets <- ts_wfs_svm_rbf("kernlab", rec_objs)
#' wf_sets
#'
#' @return
#' Returns a workflowsets object.
#'
#' @export
#'

ts_wfs_svm_rbf <- function(.model_type = "kernlab", .recipe_list,
                            .cost = 1, .rbf_sigma = 0.01,
                            .margin = 0.1){

    # * Tidyeval ---
    model_type   = .model_type
    recipe_list  = .recipe_list
    cost         = .cost
    rbf_sigma    = .rbf_sigma
    margin       = .margin

    # * Checks ----
    if (!is.character(model_type)) {
        stop(call. = FALSE, "(.model_type) must be set to a character string.")
    }

    if (!model_type %in% c("kernlab")){
        stop(call. = FALSE, "(.model_type) must be 'kernlab'.")
    }

    if (!is.list(recipe_list)){
        stop(call. = FALSE, "(.recipe_list) must be a list of recipe objects")
    }

    if (!is.double(cost) | !is.double(rbf_sigma) | !is.double(margin)){
        stop(call. = FALSE, "The .cost, .rbf_sigma, and .margin must be floats.")
    }

    # * Models ----
    model_spec_svm_rbf <- parsnip::svm_rbf(
        mode         = "regression",
        cost         = cost,
        rbf_sigma    = rbf_sigma,
        margin       = margin
    ) %>%
        parsnip::set_engine("kernlab")

    final_model_list <- list(
        model_spec_svm_rbf
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

