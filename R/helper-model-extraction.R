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
#'
#' # Create a model
#' fit_arima  <- auto.arima(AirPassengers)
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
        ar_mod <- healthyR.ts::arima_string(fit_object)
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
