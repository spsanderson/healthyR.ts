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
#' @param .data This should be your training data typically obtained from the
#' splits object training(splits). You can provide a tibble or you can provide
#' training(splits) as the argument. This will get passed to the
#' [parsnip::fit()] portion of the [workflows::workflow()]
#' @param .model_type This is where you will set your engine. It uses
#' [parsnip::linear_reg()] under the hood and can take one of the following:
#'   * "lm"
#'   * "glmnet"
#'   * "all_engines" - This will make a model spec for all available engines.
#' Not yet implemented are:
#'   * "stan"
#'   * "spark"
#'   * "keras"
#' @param ... The recipes you want to use in the function.
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

linear_reg_wfs <- function(.data, .model_type, ...){

    print("still working on it")
}

