#' Model Method Extraction Helper
#'
#' @author Steven P. Sanderson II, MPH
#'
#' @family Utility
#'
#' @description This takes in a model fit and returns the method of the fit object.
#'
#' @details
#' Currently supports forecasting model of one of the following from the
#' `forecast` package:
#'   * \code{\link[forecast]{Arima}}
#'   * \code{\link[forecast]{auto.arima}}
#'   * \code{\link[forecast]{ets}}
#'   * \code{\link[forecast]{nnetar}}
#'   * `workflow` fitted models.
#'
#' @param .fit_object A time-series fitted model
#'
#' @examples
#' # NOT RUN
#' \dontrun{
#' suppressPackageStartupMessages(library(forecast))
#' suppressPackageStartupMessages(library(healthyR.data))
#' suppressPackageStartupMessages(library(dplyr))
#' suppressPackageStartupMessages(library(timetk))
#'
#' data <- healthyR_data %>%
#'     filter(ip_op_flag == "I") %>%
#'     select(visit_end_date_time) %>%
#'     rename(date_col = visit_end_date_time) %>%
#'     summarise_by_time(
#'         .date_var = date_col
#'         , .by     = "month"
#'         , value   = n()
#'     ) %>%
#'     filter_by_time(
#'        .date_var     = date_col
#'        , .start_date = "2012"
#'        , .end_date   = "2019"
#'     )
#'
#' data_ts <- tk_ts(data = data, frequency = 12)
#'
#' # Create a model
#' fit_arima  <- auto.arima(data_ts)
#'
#' model_extraction_helper(fit_arima)
#' }
#'
#' @return A model description
#'
#' @export
#'

model_extraction_helper <- function(.fit_object){

    fit_object <- .fit_object

    # * Checks ----
    # See what type of model we have
    model_fit_type <- if (forecast::is.Arima(fit_object)){
        "arima"
    } else if (forecast::is.nnetar(fit_object)){
        "nnetar"
    } else if (forecast::is.ets(fit_object)){
        "ets"
    } else {
        "workflow"
    }

    # * Function Factory ----
    mod_obj_arima <- function(model_fit_type){
        ar_mod <- forecast:::arima.string(fit_object)
        return(ar_mod)
    }

    mod_obj_ets <- function(model_fit_type){
        ets_mod <- fit_object$method
        return(ets_mod)
    }

    mod_obj_nnetar <- function(model_fit_type){
        nnetar_mod <- fit_object$method
        return(nnetar_mod)
    }

    mod_obj_workflow <- function(model_fit_type){
        wflw_mod <- modeltime::get_model_description(fit_object)
        return(wflw_mod)
    }

    final_mod_method <- if (model_fit_type == "arima"){
        mod_method <- mod_obj_arima(model_fit_type = model_fit_type)
    } else if (model_fit_type == "nnetar"){
        mod_method <- mod_obj_nnetar(model_fit_type = model_fit_type)
    } else if (model_fit_type == "ets"){
        mod_method <- mod_obj_ets(model_fit_type = model_fit_type)
    } else if (model_fit_type == "workflow"){
        mod_method <- mod_obj_workflow(model_fit_type = model_fit_type)
    }

    # * Return ----
    return(mod_method)

}
