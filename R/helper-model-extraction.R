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
        stop(call. = FALSE, "(.fit_object) is not of type Arima, auto.arima, nnetar, or ets.")
    }

    # * Function Factory ----
    mod_obj_arima <- function(model_fit_type){
        ar_mod <- if (model_fit_type == "arima"){
            ar_order <- forecast::arimaorder(fit_object)
            ar_p <- ar_order[["p"]]
            ar_d <- ar_order[["d"]]
            ar_q <- ar_order[["q"]]
            ar_P <- ar_order[["P"]]
            ar_D <- ar_order[["D"]]
            ar_Q <- ar_order[["Q"]]
            ar_F <- ar_order[["Frequency"]]
            ar_drift <- ifelse(fit_object$coef[["drift"]], "with drift", "")
            ar_model <- paste0(
                "ARIMA",
                "(", ar_p, ",", ar_d, ",", ar_q, ")",
                "(", ar_P, ",", ar_D, ",", ar_Q, ")",
                "[", ar_F, "]",
                " ", ar_drift
            )
        }
        return(ar_mod)
    }

    mod_obj_ets <- function(model_fit_type){
        ets_mod <- fit_object$method
        return(ets_mod)
    }

    mod_obj_nnetar <- function(model_fit_type){
        nnetar_mod <- fit_object$method
    }

    final_mod_method <- if (model_fit_type == "arima"){
        mod_method <- mod_obj_arima(model_fit_type = model_fit_type)
    } else if (model_fit_type == "nnetar"){
        mod_method <- mod_obj_nnetar(model_fit_type = model_fit_type)
    } else {
        mod_method <- mod_obj_ets(model_fit_type = model_fit_type)
    }

    # * Return ----
    return(mod_method)
}
